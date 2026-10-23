import type { Bindings } from "../env";

interface Mail {
  to: string;
  subject: string;
  html: string;
}

/** Sends via Resend when configured, otherwise logs (useful in local dev). */
export async function sendEmail(env: Bindings, mail: Mail) {
  if (!env.RESEND_API_KEY) {
    console.log(`[email] to=${mail.to} subject="${mail.subject}"\n${mail.html.replace(/<[^>]+>/g, " ")}`);
    return;
  }
  const res = await fetch("https://api.resend.com/emails", {
    method: "POST",
    headers: { Authorization: `Bearer ${env.RESEND_API_KEY}`, "Content-Type": "application/json" },
    body: JSON.stringify({ from: env.EMAIL_FROM ?? `${env.APP_NAME} <onboarding@resend.dev>`, ...mail }),
  });
  if (!res.ok) console.error("[email] send failed", res.status, await res.text());
}

export function emailLayout(env: Bindings, title: string, body: string, cta?: { label: string; url: string }) {
  return `<!doctype html><html><body style="margin:0;background:#0b0b10;font-family:Inter,Segoe UI,Arial,sans-serif;color:#e8e8ef">
  <div style="max-width:560px;margin:0 auto;padding:40px 24px">
    <div style="font-size:20px;font-weight:700;letter-spacing:-0.02em;margin-bottom:32px">${env.APP_NAME}</div>
    <div style="background:#15151d;border:1px solid #26263a;border-radius:16px;padding:32px">
      <h1 style="font-size:22px;margin:0 0 12px;color:#fff">${title}</h1>
      <div style="font-size:15px;line-height:1.6;color:#b4b4c6">${body}</div>
      ${cta ? `<a href="${cta.url}" style="display:inline-block;margin-top:24px;background:#7c6cff;color:#fff;text-decoration:none;padding:12px 20px;border-radius:10px;font-weight:600">${cta.label}</a>` : ""}
    </div>
    <p style="font-size:12px;color:#6b6b80;margin-top:24px">You received this because you have an account on ${env.APP_NAME}.</p>
  </div></body></html>`;
}
