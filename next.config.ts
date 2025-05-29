import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  output: 'standalone', // Optimizes for production deployment
  poweredByHeader: false, // Removes the X-Powered-By header
  compress: true, // Enables gzip compression
  experimental: {
    serverComponents: true,
  },
  webpack: (config) => {
    return config;
  },
  // Enable hostname and port configuration
  hostname: '0.0.0.0',
  port: 3000,
  images: {
    formats: ['image/avif', 'image/webp'],
    remotePatterns: [
      {
        protocol: 'https',
        hostname: '**', // Allow loading images from any HTTPS source
      },
    ],
  },
  env: {
    NEXT_PUBLIC_CONTACT_PHONE: process.env.NEXT_PUBLIC_CONTACT_PHONE,
    NEXT_PUBLIC_CONTACT_EMAIL: process.env.NEXT_PUBLIC_CONTACT_EMAIL,
    NEXT_PUBLIC_GITHUB_USERNAME: process.env.NEXT_PUBLIC_GITHUB_USERNAME,
  }
};

export default nextConfig;
