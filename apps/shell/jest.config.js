const sharedConfig = require("jest-config/jest-config.js");

module.exports = {
  ...sharedConfig,
  collectCoverageFrom: [
    "**/*.{ts,tsx}",
    "!**/*.d.ts",
    "!**/node_modules/**",
    "!<rootDir>/out/**",
    "!<rootDir>/.next/**",
    "!<rootDir>/coverage/**",
    ...sharedConfig.collectCoverageFrom
  ],
  testPathIgnorePatterns: ["<rootDir>/node_modules/", "<rootDir>/.next/", ...sharedConfig.testPathIgnorePatterns],
  setupFilesAfterEnv: ["./setupTests.ts"],
  transform: {
    "^.+\\.(js|jsx|ts|tsx)$": ["babel-jest", { presets: ["next/babel"] }],
  },
  moduleNameMapper: {
    "^.+\\.(css|sass|scss)$": "<rootDir>/__mocks__/styleMock.js"
  },
  coveragePathIgnorePatterns: ["<rootDir>/pages/_app.tsx"],
};
