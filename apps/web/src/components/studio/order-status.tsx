import type { OrderStatus } from "@latent/shared";
import { Badge } from "@/components/ui/primitives";

export function OrderStatusBadge({ status }: { status: OrderStatus }) {
  const map = { paid: ["success", "Paid"], pending: ["warning", "Pending"], refunded: ["default", "Refunded"], failed: ["danger", "Failed"] } as const;
  const [variant, label] = map[status];
  return (
    <Badge variant={variant} size="sm">
      <span className="size-1.5 rounded-full bg-current" />
      {label}
    </Badge>
  );
}
