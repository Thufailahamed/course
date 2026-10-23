Permissions decide which tools the agent may use, and sandboxes decide where a file tool may reach. A read-only search is harmless to run automatically. A tool that sends an email should ask first, and a tool that deletes data should not run from an agent at all. A sandbox keeps file access inside a directory, even when the model asks for a path that climbs out of it.

## Risk tiers

Each tool belongs to a tier. Reads run automatically, writes need confirmation, and dangerous actions are denied. A tool with no tier is denied by default.

```python run
TIER_DECISION = {"read": "allow", "write": "confirm", "dangerous": "deny"}
policy = {"search": "read", "email": "write", "delete": "dangerous"}

def decide(tool, policy):
    tier = policy.get(tool)
    return TIER_DECISION.get(tier, "deny")

for tool in ["search", "email", "delete", "unknown_tool"]:
    print(tool, "->", decide(tool, policy))
```

## Normalizing paths

A path such as "/data/../etc/passwd" leaves the directory it starts in. Normalizing the path first shows where it really points.

```python run
import posixpath
print(posixpath.normpath("/data/reports/../summary.txt"))
print(posixpath.normpath("/data/../etc/passwd"))
```

## Inside the sandbox

A path is inside a root when it equals the root or sits below it with a slash. A simple prefix check is not enough, because "/database" starts with "/data".

```python run
def is_inside(path, root):
    norm = posixpath.normpath(path)
    return norm == root or norm.startswith(root.rstrip("/") + "/")

print(is_inside("/data/a.txt", "/data"), is_inside("/database/x", "/data"), is_inside("/data/../etc/passwd", "/data"))
```

## The Model Context Protocol

The Model Context Protocol is a standard way for an agent to discover and call tools served by another process. A server publishes its tools with schemas and permissions, and the agent connects to it. The client shown below is static code, because it needs a running server.

```python
# Static example: a Model Context Protocol client with the official Python SDK.
from mcp import ClientSession, StdioServerParameters
from mcp.client.stdio import stdio_client

server = StdioServerParameters(command="python", args=["orders_server.py"])

async def list_tools():
    async with stdio_client(server) as (read, write):
        async with ClientSession(read, write) as session:
            await session.initialize()
            tools = await session.list_tools()
            return [t.name for t in tools.tools]
```

## Traversal in a path

Normalization collapses the parent steps, so a path that appears to stay in a folder may not.

```python run
print(posixpath.normpath("/data/a/../../secret"))
```

> **Pitfall:** a permission check on the tool name is not enough when the arguments change what the tool does. Check the arguments too, such as the recipient of an email or the path of a file.

> **In the wild:** agent platforms ask the user before every write, run reads automatically, and log each decision. The sandbox is the last line of defence, not the first.

## Challenge: permission decision

```python exercise id=decide title="Decide whether a tool may run"
# TODO: `decide(tool, policy)` takes a dictionary from tool name to tier ("read", "write" or "dangerous"). It returns "allow"
# for read, "confirm" for write and "deny" for dangerous. A tool with no tier, or with an unknown tier, is denied.
def decide(tool, policy):
    ...
--- solution
def decide(tool, policy):
    decision = {"read": "allow", "write": "confirm", "dangerous": "deny"}
    return decision.get(policy.get(tool), "deny")
--- test
policy = {"search": "read", "email": "write", "delete": "dangerous"}
assert decide("search", policy) == "allow", "Read tools run automatically."
assert decide("email", policy) == "confirm", "Write tools ask first."
assert decide("delete", policy) == "deny", "Dangerous tools are denied."
assert decide("unknown", policy) == "deny", "A tool with no tier is denied by default."
--- hint
Look up the tier, then look up the decision for that tier, with a default of deny.
--- hint
`decision.get(policy.get(tool), "deny")`.
```

## Challenge: inside a root

```python exercise id=is-inside title="Is a path inside the sandbox?"
import posixpath

# TODO: `is_inside(path, root)` returns True when the normalized path equals root or lies below root with a slash, and False
# otherwise. Use posixpath.normpath on the path first.
def is_inside(path, root):
    ...
--- solution
import posixpath

def is_inside(path, root):
    norm = posixpath.normpath(path)
    return norm == root or norm.startswith(root.rstrip("/") + "/")
--- test
assert is_inside("/data/a.txt", "/data") is True, "A file below the root is inside."
assert is_inside("/data/../etc/passwd", "/data") is False, "A path that climbs out of the root is outside."
assert is_inside("/database/x", "/data") is False, "A sibling directory with the same prefix is outside."
--- hint
Normalize first, then compare against the root followed by a slash.
--- hint
`norm.startswith(root.rstrip("/") + "/")`.
```

## Debug: a prefix that is not a directory

The sandbox check should only accept paths inside the root directory, but a plain prefix test also accepts a sibling directory.

```python debug id=prefix-sibling title="Check the directory boundary"
import posixpath
path, root = "/database/x", "/data"
norm = posixpath.normpath(path)
inside = norm.startswith(root)                  # bug: a plain prefix also matches /database
print("inside:", inside)
--- solution
import posixpath
path, root = "/database/x", "/data"
norm = posixpath.normpath(path)
inside = norm == root or norm.startswith(root.rstrip("/") + "/")
print("inside:", inside)
--- test
assert inside is False, "/database is a sibling of /data, not a child, so the path is outside. Require the slash after the root."
--- hint
A directory boundary is a slash, not just a common prefix.
--- hint
Add `+ "/"` to the root before the prefix test.
```

## Predict the decision

```python predict id=predict-decide title="What does decide return for a write tool?"
print({"read": "allow", "write": "confirm", "dangerous": "deny"}["write"])
--- options
* confirm
allow
deny
error
--- explain
Write tools are not allowed silently, so they ask the user to confirm first.
```

## Recap

- Assign each tool to a tier, and deny anything without one.
- Normalize paths, and check the directory boundary, not a string prefix.
- Check the arguments as well as the tool name, because arguments change the effect.

**Up next:** planning, and how an agent recovers when a step fails.
