import { RedirectToLogin } from "@/components/redirect-to-login";
import { getSession } from "@/lib/server";

// Every page in this group requires a signed-in user.
export default async function LearnerLayout({ children }: { children: React.ReactNode }) {
  const user = await getSession();
  if (!user) return <RedirectToLogin />;
  return children;
}
