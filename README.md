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

### 3.2 Giving the creator all coins ¯\_(ツ)_/¯

The `constructor` initializes the smart contract. Before a contract is not
initialized, it's methods cannot be called appropriately. For our token we want
to give all of the coins initially to ourselves. A `uint256 initialSupply` is
already passed to `constructor(uint256 initialSupply)`. This happens when we
deploy the contract with a migration. Take a look at
`migrations/2_deploy_contract.js`. There we pass in `10000` as a second
parameter to `.deploy()`. This is our `initialSupply` value. As a first
parameter we're passing the artifact of the contract itself.

We'd like to give the person initializing the contract all the initialSupply
coins. Remember, `balanceOf` maps an `address` to a `uint`. It happens to be
that `msg.sender` is an `address` and `initialSupply` an `uint256`. To do this,
we need to set the `balanceOf` of the caller (`msg.sender`) to `initialSupply`.
Implement this in the `constructor` method.

### 3.3 The transfer method

To recapitulate, we introduced a variable `balanceOf` that maps `address =>
uint256`.  We told our contructor to allocate all funds to `msg.sender` (so to
ourselves). However, without having a way to transfer tokens, there is not much
usefulness in our approach so far. That's why we'd like to implement `function
transfer`.

#### The function signature

As we can see there is already a function signature for us. A transfer gets
passed an `address _to` and a `uint256 value`. We know also that the caller's
`address` can be accessed with `msg.sender`.
