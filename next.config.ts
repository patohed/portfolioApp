import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  output: 'standalone', // Optimizes for production deployment
  poweredByHeader: false, // Removes the X-Powered-By header
  compress: true, // Enables gzip compression
  // Server Components y Actions están habilitados por defecto en Next.js 13+
  webpack: (config) => {
    return config;
  },
  images: {
    formats: ['image/avif', 'image/webp'],
    remotePatterns: [
      {
        protocol: 'https',
        hostname: '**', // Allow loading images from any HTTPS source
      },
    ],
  }
};

export default nextConfig;
