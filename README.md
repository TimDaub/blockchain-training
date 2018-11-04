# How to launch a token on Ethereum

## 1. Installation

To install this codebase first clone it from github and setup node dependencies.

```
# Clone the project from GitHub
$ git clone git@github.com:TimDaub/blockchain-training.git

# Go in the downloaded folder
$ cd blockchain-training

# Install the node.js dependencies
$ npm install 

# Install truffle, a smart contract tooling frame work
npm install -g truffle
```

## 2. Overview

Check out the repository. There are a variety of folders for you to take a look
at. Open them and familiarize yourself with the files in them.

```
# holds pictures that are included in this document. Nothing of importance
/assets/

# holds the solidity contracts
/contracts/

# holds the token contract <- the main file you'll be interacting with
/contracts/MyToken.sol

# holds the solidity migrations
/migrations/

# holds all node.js dependencies
/node_modules/

# stores information about the node.js project
/package.json

# stores the deployment routine to the rinkeby test network
/truffle.js
```

## 3. Writing our own token contract

Open the file `contracts/MyToken.sol` and take a look at it. It has already a
contract definition called `MyToken`. It also has two methods:

- `constructor`; and
- `function transfer`.

### 3.1 Creating a mapping of our balances

For a contract to create tokens we'll have to create a mapping between addresses
and their balances. Balances are of type `uint256`. Addresses have a special
`address` type in Ethereum.
At the top of contract, create a mapping that maps `address => uint256` and
call it `balanceOf`.

To test whether nor not the code that you wrote is correct, you can execute
`truffle compile` in the root of your directory.

### 3.2 Giving the creator all coins ¯\_(ツ)_/¯

The `constructor` initializes the smart contract. Before a contract is not
initialized, it's methods cannot be called appropriately. For our token we want
to give all of the coins initially to ourselves. A `uint256 initialSupply` is
already passed to `constructor(uint256 initialSupply)`. This happens when we
deploy the contract with a migration. Take a look at
`migrations/2_deploy_contract.js`. 

```
var MyToken = artifacts.require('./MyToken.sol');

module.exports = function(deployer) {
  deployer.deploy(MyToken, 10000);
};
```

There we pass in `10000` as a second parameter to `.deploy()`. This is our
`initialSupply` value. As a first parameter we're passing the artifact of the
contract itself.

We'd like to give the person initializing the contract all the initialSupply
coins. Remember, `balanceOf` maps an `address` to a `uint`. It happens to be
that `msg.sender` is an `address` and `initialSupply` an `uint256`. To do this,
we need to set the `balanceOf` of the caller (`msg.sender`) to `initialSupply`.
Implement this in the `constructor` method. Test your code again by executing
`truffle compile` in the root directory of your project.

### 3.3 The transfer method

To recapitulate, we introduced a variable `balanceOf` that maps `address =>
uint256`.  We told our contructor to allocate all funds to `msg.sender` (so to
ourselves). However, without having a way to transfer tokens, there is not much
usefulness in our approach so far. That's why we'd like to implement `function
transfer`.

#### The function signature

As we can see there is already a function signature for us. A transfer gets
passed an `address _to` and a `uint256 value`. We know also that the caller's
`address` can be accessed with `msg.sender`. Let's now create fill in the
transfer method's instructions.

#### Checks

As you can see, there is already a `require` statement in the `function
transfer`.  It checks for overflows. Solidity `uint256` can overflow if a large
or small enough value is passed to them. With this `require` statement, we'd
like to make sure that anyone calling `function transfer` cannot actively
overflow our values to create artificially more coins.

Secondly, we'd like to check whether the caller of the contract has enough of a
balance to make the call anyways. For this we need to check the `balanceOf`
`msg.sender`. We can do this by accessing `balanceOf` like this:
`balanceOf[msg.sender]`. We then want to compare this value, which is a
`uint256` to `_value`. `balanceOf[msg.sender]` should be greater or equal
`_value`. In solidity to assert if a statement is `true`, we can use the
`require` statement. To learn more about when to use `require`, checkout the
[solidity
documentation](https://solidity.readthedocs.io/en/v0.4.24/control-structures.html#error-handling-assert-require-revert-and-exceptions).

#### Re-assigning `_value` to `_to`

Now that we have our sanity checks in place, there is only two more things that
need to happen. First, we want to remove the amount of `_value` for the `balanceOf`
of the caller `msg.sender`. Secondly, we want to assign the amount of `_value`
for the `balanceOf` to `_to`.

Let's first remove `_value` from `msg.sender`. We can use the `-=` operator to
do so. As a second step, we'd like to add `_value` to `balanceOf[_to]`. To do
so we can use the `+=` operator. If you're struggling to assign the values, go
back and take a look at how we assigned the `initialSupply` to
`balanceOf[msg.sender]` in the `constructor` method. Test your code again by
doing `truffle compile` in the root directory of your project.

### Finishing up

That's it. You've successfully implemented your own token tracker in solidity.
Congratulations! Now let's deploy this thing onto a test net and use it.

## 4. Installing metamask and getting ether from rinkeby faucet

To deploy a smart contract we're going to need ether to deploy it. To store
our ether, we'll need a wallet. A very convenient wallet is Metamask. It works
as a browser plugin and allows you to call your smart contract functions directly.
To download and install it, visit [this website](https://metamask.io/).

### Getting Rinkeby ether from a faucet

We're going to deploy our code to the Rinkeby test net. It's mainly there for
testing purposes and it's ether doesn't have any value. It can be spend without
worrying about it. To request some ether, we're using a so called faucet.  A
faucet dispenses some ether to us for free. Go to [this
website](https://faucet.rinkeby.io/), read the instructions and request some
ether using your social media profile of your choice.

### Getting ready to deploy

Now that you've received your ether in Metamask, we can start to deploy our
contract. To do so, let's take a look at our `truffle.js` file in the root
directory. We've commented the code so you can see what it does.

```javascript
// it requires dotenv and reads the .env file
require('dotenv').config();

// it requires a bunch of libraries which we're going to use later on
const Web3 = require("web3");
const web3 = new Web3();
const WalletProvider = require("truffle-wallet-provider");
const Wallet = require('ethereumjs-wallet');

// it reads the private key `RINKEBY_PRIVATE_KEY` from our ENV variables
var rinkebyPrivateKey = new Buffer(process.env["RINKEBY_PRIVATE_KEY"], "hex")

// creates a wallet using the private key
var rinkebyWallet = Wallet.fromPrivateKey(rinkebyPrivateKey);

// and initializes a wallet provider with a full node on infura. A wallet
// provider.
var rinkebyProvider = new WalletProvider(rinkebyWallet, "https://rinkeby.infura.io/");


module.exports = {
  networks: {
    rinkeby: {
      provider: rinkebyProvider,
      gas: 4600000,
      gasPrice: web3.toWei("20", "gwei"),
      network_id: "4",
    }
  }
};
```

To deploy a contract, you'll have to use the `truffle` command line interface.
Remember that you installed it in the beginning of the lesson already. First,
we want to compile our contract to check whether or not we have any errors.
In your command line, execute `$ truffle compile`. It should give you an output
like this:

```
 TimDaub@kazoo  ~/Projects/blockchain-training   master  truffle compile
 Compiling ./contracts/MyToken.sol...

 Compilation warnings encountered:

 /Users/TimDaub/Projects/blockchain-training/contracts/MyToken.sol:15:5: Warning: No visibility specified. Defaulting to "public".
     function transfer(address _to, uint256 _value) {
         ^ (Relevant source part starts here and spans across multiple lines).

         Writing artifacts to ./build/contracts
```

Assuming you don't have any errors in your code, we can now deploy your contract
to the Rinkeby test network.

### Deploying to the Rinkeby test network

Deploying to the Rinkeby test network is simple. All you have to do is invoke
the script in `truffle.config`. Creating a contract on the network requires
some ether however. Remember that in earlier in this step we requested some
ether from a faucet. We'll now need to tell `truffle.config` our private key to
this ether for it to successfully deploy the token tracker. To get the private
key from Metamask, open Metamask in your browser. Click on the three dots next
to your address and click "View Account Details".

![metamask account](https://github.com/TimDaub/blockchain-training/blob/master/assets/screenshot1.png?raw=true)

Click on "Export Private Key", enter your password and reveal your private key.
Copy it into your clipboard. Go into your console and enter the following:

```
$ RINKEBY_PRIVATE_KEY=<Your private key> truffle migrate --network rinkeby
```

and hit enter. You should see the following output:
```
TimDaub@kazoo  ~/Projects/blockchain-training   master  RINKEBY_PRIVATE_KEY=<My private key> truffle migrate --network rinkeby --reset
Using network 'rinkeby'.

Running migration: 1_initial_migration.js
    Replacing Migrations...
    ... 0xc564f83149174c48d12577f9101c989632e0cde78ca1b2cfe48979a4eb185bb8
    Migrations: 0x598074dd1b443ac1f7d4fc82ba1eb69eb1a8a7c1
Saving successful migration to network...
    ... 0x044cb720d4bf7278a2e5d30451f3950ff6890defbcd9d07ecf63fa4fe7c746f1
Saving artifacts...
Running migration: 2_deploy_contracts.js
    Deploying MyToken...
    ... 0x19ca5e34163098b1df9b4e3ee1f650ec4a5355dee36e6a4bffb3c92ac6a46647
    MyToken: 0x99630163238b40a4de6c35eb8ca5904d11def718
Saving successful migration to network...
    ... 0xf1e391f253ad157ebc3c886d77cfe17e8b1f23500f182d36393e4092784593b9
Saving artifacts...
```

To check whether or not your token tracker was successfully implemented on the
Rinkeby test network you can use rinkeby.etherscan.io to check your
transaction.  To do so, copy the following line from above:

```
MyToken: 0x99630163238b40a4de6c35eb8ca5904d11def718
```

This is your contract's address on the Rinkeby test network. Open
rinkeby.etherscan.io in a page in the browser and type into the search the
address. Hit enter.  You'll see your contract page being loaded.

Now that we've successfully deployed our token to the network, it's time to open
our frontend.
