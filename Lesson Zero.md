# Notes from lesson zero Free Code Camp

## Overview

### Get your questions answered
- Issue on the github repo 
- Stack Exchange Eth
- Discord of the technology 
Question I have is what is the return value of address() ?


### Oracles
bring data to the blockchain (real world data)

Hybrid smart contracts and smart contracts are often used interchangibly

Hybrid smart contracts - blockchain contracts (decentrilized) with centrilized data (offchain component)

Chainlink is an oracle (good one. most popular)


### Advantages of blockchain and smart contracts

#### Decentrilized
made of node operators running the software

#### Transparency and flexibility
All on chain things can be seen by anyone

#### Speed and efficiency

#### Security and immutability

#### Removal of counterparty risk
Contract is fixed. Impossible to find loopholes or dodge the agreement. 

I dont really like the insurance example. What if someone fakes an accident? 
Who decides whether the conditions for the contract were met?
I guess the oracle decides it, but who controlls the oracle and assures the accuracy of the data?


#### Trust minimized agreements
Move from brand based agreements to math based agreements.
Math > Reputaion. 

### Two major pieces
1. Freedom
2. Trustless
Better world (thumbs up)


### DAOs
Decentrilized Autonomous Organizations

Live online (in smart contracts)
People hold governance tokens, etc. On chain organization (government or something)

## Wallets
Etherscan to view data about adresses.
Etherscan is a "block explorer". Meaning it allows us to see the things on the blockchain easily.
[Fake money source](https://sepoliafaucet.com/)

### Faucet
Application that gives free ETH for development.

### Gas
Unit of computational measure. More computation = more gas.
Gas price - how much native token to one unit of gas.

When a node succesfully includes a transaction in the blockchain, it is paid in gas (by the transaction author)

## What is blockchain

[Website demo](https://andersbrownworth.com/blockchain/)

### Hash
Hash - unique fixed legth string ment to indetify any piece of data. 
Creater by putting some data into a 'hash' function.

### Block

A block containts block number, Nonce (number used once), and Data.

All three (number, nonce, data) are being hashed.

Therefore a block is uniquely represented with a hash.

#### Mining
A problem for the block to solve in order to slow down the hashing process.
Used as a measure to prevent fraud (slow down brute forcers).
The miner gets paid for succesfuly solving the mining problem.

### Blockchain
Linked list of blocks.
Each block points to the previous' block hash.

#### Genesis block
First block in the blockchain. Hash points to non-existen block.

Prevhash also goes through hashing algorithm.

#### IMPORTANT
When we change one block, it changes that block's hash, making it invalid.
Thus the block that used to point the that prev block, also ends up having an invalid hash (since it hashes the wrong prevhash). This prevents mutating the blocks. Mutating one block invalidate the entire blockchain! Meaning you would have to remine EVERY SINGLE BLOCK! Which is practically impossible :).

### Decentralized
No single point of authority
#### Many nodes
Number of 'peers' each running the blockchain. Each one has the exact same power. 
We can tell which blockchain is correct by looking at the last block's hash. It that has is valid, the whole chain is valid (watch '[important](#important)' section from '[blockchain](#blockchain)').

#### Whos right
To determine which chain is correct, we look at what 'endhash' the majority of the 'nodes' have. 
If the node's endhash does not match the majory, that node is "kicked out" of the game (can not participate in mining).

### Tokens
More informative data (tables, list of transactions).

In our case that will be Solidity code.

[stopped at 1:05:00](https://youtu.be/Qe-3FUxThso?t=3941)

## Keys 

### Private key
Used to sign transactions.

Only the owner has access to their private key.

### Public key
Averybody has access to it. Related to (derived from) the Private Key by the Elliptic Curve Digital Signature Algorithm.

Wallet address is derived from the public key (hash and take the last 20 bits)

#### IMPORTANT
People can verify our [Private key](#private-key) signatures using our [Public key](#public-key).

### Signing
Every user has a private key and a public key.
A user *signs* a piece of data (transaction) with his private key, creating a *signature*.

Anybody can then confirm the signature using the user's *public key*.
Confirming the signarue includes *retrieving/confirming the data (transcation data)* that was signed.

Signing allows us to know that the user *for sure* commited the transaction.

## Consensus (Proof of work/Proof of stake)

### Chain selection

### Sybil Resistance mechanism
Defends from a bunch of fake nodes.

Proof of work - mining. No matter how many nodes you make, each one has to mine.

### Nakamoto consensus 
Used by Bitcoing and Ethereum.
The longest chain - the right chain 
#### Block confirmations
Number of additional blocks added after our transaction went through in a block 

## Block reward
Each successful block confimation/validaiton pays the miner/validator the transaction fee(gas)
along with *block reward*. Block reward adds more currency to the pool. 

### Proof of work
mining

### Proof of stake
Put out money. If the block is invalid, lose the money.
Nodes are randomly selected to propose blocks. The rest of the network then validates the block that was proposed.

Sligtly less decentrilized, due to the costs to participate. <-- Opinion

### Sharding
One main blockchain manages a lot of little blockchains.
Improves efficiency and reduces transaction costs.

#### Layer 1
Single blockchain
BTC, ETH, ...

#### Layer 2
A blockchain added on top of another blockchain
Chainlink, Arbitrum, Optimism
