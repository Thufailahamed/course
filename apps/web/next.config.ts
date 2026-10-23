import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  transpilePackages: ["@latent/shared"],
  images: { unoptimized: true },
  poweredByHeader: false,
};

export default nextConfig;
