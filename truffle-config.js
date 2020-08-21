const HDWalletProvider = require("@truffle/hdwallet-provider");
const mnemonic = fs.readFileSync("mnemonic.secret").toString().trim();

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*" // Match any network id
    },
    infura: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "https://ropsten.infura.io/v3/1ad1bbbd906741eaa09ce122356ef066")
      },
      network_id: '3'
    }
  },
  compilers: {
    solc: {
      version: "0.6.2"
    }
  }
};
