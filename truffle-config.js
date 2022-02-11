const mnemonicPhrase = "half orbit alpha basket suspect cradle until blue sheriff violin shove flock"
const HDWalletProvider = require('@truffle/hdwallet-provider')

module.exports = {
  contracts_build_directory: './build',
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
    },
    ropsten: {
      provider: () => new HDWalletProvider(mnemonicPhrase, "https://ropsten.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161"),
      network_id: 3,
      gas: 4000000,
      skipDryRun: true,
    },
    kovan: {
      provider: () => new HDWalletProvider(mnemonicPhrase, "https://kovan.infura.io/v3/6fd2fd8e1b334661b0c38556bd48b257"),
      network_id: 42,
      gas: 4000000,
      skipDryRun: true,
    },
  },
  plugins: [
    'truffle-plugin-verify'
  ],
  api_keys: {
    etherscan: 'NPIT4183DK8BMGVZDT9C4R14S1QMEHIT88',
    bscscan: 'A2HNWK3VKZNQFAGU254HW1DAG4RPB8FI8T'
  },
  compilers: {
    solc: {
      // Add path to the optimism solc fork
      version: "0.8.0",
      settings: {
        optimizer: {
          enabled: true,
          runs: 1
        },
      }
    }
  }
}