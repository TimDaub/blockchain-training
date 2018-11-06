require('dotenv').config();
const Web3 = require('web3');
const web3 = new Web3();
const WalletProvider = require('truffle-wallet-provider');
const Wallet = require('ethereumjs-wallet');
const privateKey = process.env['RINKEBY_PRIVATE_KEY']
var rinkebyProvider

if (privateKey) {
  // read the private key `RINKEBY_PRIVATE_KEY` from our ENV variables
  let rinkebyPrivateKey = new Buffer(privateKey, 'hex')
  // create a wallet using the private key
  let rinkebyWallet = Wallet.fromPrivateKey(rinkebyPrivateKey);
  // and initialize a wallet provider with a full node on infura.
  rinkebyProvider = new WalletProvider(rinkebyWallet, 'https://rinkeby.infura.io/');
}


module.exports = {
  networks: {
    development: {
      provider: rinkebyProvider,
      // You can get the current gasLimit by running
      // truffle deploy
      // truffle(rinkeby)> web3.eth.getBlock('pending', (error, result) =>
      //   console.log(result.gasLimit))
      gas: 4600000,
      gasPrice: web3.toWei('20', 'gwei'),
      network_id: '4',
    }
  }
};
