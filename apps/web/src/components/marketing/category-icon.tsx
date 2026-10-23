import { BarChart3, Bot, Brain, Code, Eye, Globe, Layers, MessageSquare, Server, Sigma, Sparkles, type LucideIcon } from "lucide-react";

const ICONS: Record<string, LucideIcon> = {
  brain: Brain,
  layers: Layers,
  sparkles: Sparkles,
  bot: Bot,
  eye: Eye,
  "message-square": MessageSquare,
  server: Server,
  sigma: Sigma,
  "bar-chart": BarChart3,
  code: Code,
  globe: Globe,
};

export function CategoryIcon({ name, className }: { name: string | null | undefined; className?: string }) {
  const Icon = (name && ICONS[name]) || Sparkles;
  return <Icon className={className} />;
}
