/* ────────────────────────────────────────────────────────────
 * Java cell harness, shared by the browser runtime and the Node
 * validator so both compile, run and check code identically.
 *
 * Snippet cells are wrapped in `public class Main`; complete-source
 * (`class`) cells are compiled as Main.java. Challenge tests run in
 * the same `main` (snippet mode) or in a generated LatentTest class
 * (class mode), capture stdout, and print a marker the runtime reads.
 * ──────────────────────────────────────────────────────────── */

export const JAVA_PASS = "@@LATENT_PASS@@";
export const JAVA_FAIL = "@@LATENT_FAIL@@";
export const JAVA_IMPORTS = ["java.util.*", "java.io.*", "java.nio.file.*", "java.math.*", "java.time.*"].map((i) => `import ${i};`).join("\n");

export interface JavaSource {
  source: string;
  /** Lines before the learner's first line, used to map javac and stack-trace lines. */
  offset: number;
  /** Number of learner lines (snippet mode only). */
  codeLines: number;
}

export function javaPackagePrefix(pkg: string) {
  return `package ${pkg};\n\n${JAVA_IMPORTS}\n\n`;
}

/** Lines before the learner code in a complete-source (`class`) cell. */
export function javaClassOffset(pkg: string) {
  return javaPackagePrefix(pkg).split("\n").length - 1;
}

export function javaMainRunSource(pkg: string, code: string): JavaSource {
  const prefix = `${javaPackagePrefix(pkg)}public class Main {\n  public static void main(String[] args) throws Exception {\n`;
  return { source: `${prefix}${code}\n  }\n}\n`, offset: prefix.split("\n").length - 1, codeLines: code.split("\n").length };
}

const HELPERS = `
  static String __latentMsg(Throwable e) {
    String m = e.getMessage();
    if (m == null || m.isEmpty()) m = "One of the checks did not pass.";
    return m.replace("\\n", " ");
  }

  static String __out() {
    return new String(__latentBuf.toByteArray(), java.nio.charset.StandardCharsets.UTF_8).replace("\\r\\n", "\\n");
  }

  static void __check(boolean ok, String msg) {
    if (!ok) throw new AssertionError(msg);
  }
`;

export function javaMainCheckSource(pkg: string, code: string, test: string): JavaSource {
  const prefix = `${javaPackagePrefix(pkg)}public class Main {
  static final ByteArrayOutputStream __latentBuf = new ByteArrayOutputStream();
  static final PrintStream __latentReal = System.out;

  public static void main(String[] args) throws Exception {
    System.setOut(new PrintStream(__latentBuf, true, "UTF-8"));
    try {
`;
  const suffix = `
    } catch (AssertionError __latentE) {
      System.setOut(__latentReal);
      __latentReal.print(__latentBuf.toString("UTF-8"));
      __latentReal.println("${JAVA_FAIL}" + __latentMsg(__latentE));
      return;
    } catch (Throwable __latentE) {
      System.setOut(__latentReal);
      __latentReal.print(__latentBuf.toString("UTF-8"));
      throw __latentE;
    } finally {
      System.setOut(__latentReal);
    }
    __latentReal.print(__latentBuf.toString("UTF-8"));
    __latentReal.println("${JAVA_PASS}");
  }
${HELPERS}}
`;
  return {
    source: `${prefix}${code}\n\n${test}${suffix}`,
    offset: prefix.split("\n").length - 1,
    codeLines: code.split("\n").length,
  };
}

export function javaClassTestSource(pkg: string, test: string) {
  return `${javaPackagePrefix(pkg)}public class LatentTest {
  static final ByteArrayOutputStream __latentBuf = new ByteArrayOutputStream();
  static final PrintStream __latentReal = System.out;

  public static void main(String[] args) throws Exception {
    System.setOut(new PrintStream(__latentBuf, true, "UTF-8"));
    try {
${test}
    } catch (AssertionError __latentE) {
      System.setOut(__latentReal);
      __latentReal.print(__latentBuf.toString("UTF-8"));
      __latentReal.println("${JAVA_FAIL}" + __latentMsg(__latentE));
      return;
    } catch (Throwable __latentE) {
      System.setOut(__latentReal);
      __latentReal.print(__latentBuf.toString("UTF-8"));
      throw __latentE;
    } finally {
      System.setOut(__latentReal);
    }
    __latentReal.print(__latentBuf.toString("UTF-8"));
    __latentReal.println("${JAVA_PASS}");
  }
${HELPERS}
  static void __runMain() throws Exception {
    __latentBuf.reset();
    java.lang.reflect.Method m = Main.class.getMethod("main", String[].class);
    m.invoke(null, (Object) new String[]{});
  }
}
`;
}

export interface JavaDiagnostic {
  ename: string;
  evalue: string;
  line: number | null;
  file: string | null;
  traceback: string;
}

const stripAnsi = (s: string) => s.replace(/\x1b\[[0-9;]*m/g, "");
const simpleName = (name: string) => name.slice(name.lastIndexOf(".") + 1);

export function javaCompileError(raw: string, offset: number, codeLines: number): JavaDiagnostic {
  const text = stripAnsi(raw).trim() || "Compilation failed.";
  const matches = [...text.matchAll(/(?:^|[/\\])([A-Za-z_$][\w$]*)\.java:(\d+):\s*(?:error|warning):\s*([^\n]*)/gm)];
  const first = matches.find((m) => m[3] !== undefined);
  if (first) {
    const file = first[1]!;
    const adjusted = file === "Main" ? Number(first[2]) - offset : null;
    const inLearner = file === "Main" && adjusted !== null && adjusted >= 1 && adjusted <= codeLines;
    return {
      ename: "CompileError",
      evalue: first[3]!.trim() || "The compiler rejected this code.",
      line: inLearner ? adjusted : null,
      file: inLearner ? "<cell>" : "<test>",
      traceback: text,
    };
  }
  return { ename: "CompileError", evalue: "Compilation failed. Read the compiler output below.", line: null, file: "<test>", traceback: text };
}

export function javaRuntimeError(raw: string, offset: number, codeLines: number): JavaDiagnostic | null {
  const text = stripAnsi(raw).trim();
  if (!text) return null;
  const thrown = /(?:Exception in thread "main" |^|\n)([A-Za-z_$][\w.$]*(?:Exception|Error))(?::\s*([^\n]*))?/.exec(text);
  const frame = /Main\.java:(\d+)\)/.exec(text);
  let line: number | null = null;
  if (frame) {
    const adjusted = Number(frame[1]) - offset;
    if (adjusted >= 1 && adjusted <= codeLines) line = adjusted;
  }
  if (thrown) {
    return {
      ename: simpleName(thrown[1]!),
      evalue: (thrown[2] ?? "").trim() || simpleName(thrown[1]!),
      line,
      file: line ? "<cell>" : "<test>",
      traceback: text,
    };
  }
  return { ename: "RuntimeError", evalue: "The program exited with an error.", line, file: line ? "<cell>" : "<test>", traceback: text };
}

export interface JavaMarkers {
  pass: boolean;
  message: string | null;
  stdout: string;
}

export function javaMarkers(raw: string): JavaMarkers {
  const text = stripAnsi(raw);
  const pass = text.includes(JAVA_PASS);
  const fail = text.match(new RegExp(`${JAVA_FAIL}([^\\n]*)`));
  const stdout = text
    .replace(new RegExp(`${JAVA_PASS}.*$`, "m"), "")
    .replace(new RegExp(`${JAVA_FAIL}[^\\n]*`, "g"), "")
    .replace(/\n{3,}$/, "\n")
    .trimEnd();
  return { pass, message: fail?.[1]?.trim() || (fail ? "One of the checks did not pass." : null), stdout };
}
