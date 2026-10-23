// Downloads the javac classes CheerpJ compiles learner code with.
// Run with `pnpm --filter @latent/web java:fetch` after cloning.
import { createWriteStream, existsSync, mkdirSync, statSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import { pipeline } from "node:stream/promises";
import { Readable } from "node:stream";

const here = dirname(fileURLToPath(import.meta.url));
const target = join(here, "..", "public", "runtime", "java", "tools.jar");
const url = process.env.JAVA_TOOLS_URL ?? "https://raw.githubusercontent.com/leaningtech/javafiddle/main/static/tools.jar";
const expected = 18_000_000;

if (existsSync(target) && statSync(target).size > expected) {
  console.log(`tools.jar already present (${statSync(target).size} bytes)`);
  process.exit(0);
}

mkdirSync(dirname(target), { recursive: true });
console.log(`Downloading ${url}`);
const res = await fetch(url);
if (!res.ok || !res.body) {
  console.error(`Download failed: ${res.status} ${res.statusText}`);
  process.exit(1);
}
await pipeline(Readable.fromWeb(res.body), createWriteStream(target));
console.log(`Saved ${statSync(target).size} bytes to ${target}`);
