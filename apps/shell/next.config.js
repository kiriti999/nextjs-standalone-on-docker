const { NextFederationPlugin } = require('@module-federation/nextjs-mf');

const MFE_HOST= {
  dev: 'https://google.com',
  local: 'http://127.0.0.1:3001'
}

const node_env = process.env['NODE_ENV'];

/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    appDir: false,
  },
  transpilePackages: ["@repo/ui"],
  webpack: (config, options) => {
    const { isServer } = options;
    config.plugins.push(
      new NextFederationPlugin({
        name: 'shell',
        remotes: {
          helpHome: `helpHome@{MFE_HOST[node_env]}/_next/static/${isServer ? "ssr" : "chunks"}/remoteEntry.js`
            },
        exposes: {
          './EmptyComponent': './pages/Empty.component.tsx',
        },
        filename: 'static/chunks/remoteEntry.js'
      })
    )
    return config;
  }
}

module.exports = nextConfig

