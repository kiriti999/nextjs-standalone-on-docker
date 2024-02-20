/** @type {import('next').NextConfig} */
// module.exports = {
//   output: 'standalone',
//   assetPrefix: 'https://res.cloudinary.com/cloudinary999/raw/upload/v1707144049',
//   transpilePackages: ["@repo/ui"],
// };

const { NextFederationPlugin } = require('@module-federation/nextjs-mf');

/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    appDir: false,
  },
  assetPrefix: 'https://res.cloudinary.com/cloudinary999/raw/upload/v1707144049',
  transpilePackages: ["@repo/ui"],
  webpack: (config, options) => {
    config.plugins.push(
      new NextFederationPlugin({
        name: 'helpHome',
        exposes: {
          './homeComponent': './src/page.tsx',
        },
        filename: 'static/chunks/remoteEntry.js'
      })
    )
    return config;
  }
}

module.exports = nextConfig

