# Solidity Smart Contract Learning Process
These are my projects from the [16-hour Solidity Python Course by Patrick Collins](https://youtu.be/M576WGiDBdQ).

Projects include the `.sol` Smart Contracts that I wrote in [Remix](https://remix.ethereum.org/), as well as the Web3.py and Brownie project folders in [LocalDemos](./localDemos/).

## Table of contents
- [Overview](#overview)
    - [Projects List](#order-of-the-projects)
    - [What I learned](#what-i-learned)
    - [Future development](#future-development)
- [Notes](#notes)
    - [Testing](#how-to-test-contracts)
    - [Brownie](#brownie)
        - [Brownie CLI](#brownie-cli)

## Order of the projects
This is the order in which I have built the projects included in this folder
1. [Lesson Zero](./Lesson%20Zero.md)
2. [SimpleStorage.sol](./SimpleStorage.sol)
3. [StorageFactory.sol](./StorageFactory.sol)
4. [FundMe.sol](./FundMe.sol)
5. LocalDemos > [web3_py_simple_storage](./localDemos/web3_py_simple_storage/)
6. LocalDemos > [brownie_simple_storage](./localDemos/brownie_simple_storage/)
7. LocalDemos > [lottery](https://github.com/Vladmidir/Lottery-Smart-Contract) (*upgraded to VRF V2*)
8. LocalDemos > [brownie_fund_me](./localDemos/brownie_fund_me/) (yes, I did them in the wrong order 🤦‍♂️)
9. LocalDemos> [erc20_brownie](./localDemos/erc20_brownie/)

## What I learned
The course has taught me the fundamentals of smart contract development:
- How to store data on chain
- How to fund contracts and move funds around
- How to interact with the ABI
- How to deliver random numbers to the blockchain
    - For this one I had to read the documentation myself, to set up the mocks and local test for VRF V2. The research process has strengthened my understanding of how the VRF V2 works and how to setup mock contracts.
- How to [create ERC20 tokens](./localDemos/erc20_brownie/)
- How to write different kinds of tests for smart contracts (local, testnet, mainnet-fork)
- How to set up mock contracts for local testing
- How to configure a Brownie project (including dependencies)

Additionally I have improved my understanding of the blockchain as a technology, thanks to [Lesson Zero](/Lesson%20Zero.md)

## Future development
In the future, I want to make 1 or 2 projects with Brownie on my own. After that, I want to transition to Hardhad and finish the Hardhat course by Patrick Collins (I still have to learn about NFTs and DeFi contract design).


Of course, learning how to add front-end to interact with the chain is another big part I am excited to learn.

## Notes
Some of my general course notes.
- To configure VS Code solidity version [how to](https://youtu.be/umg2fWQX6jM?t=658)
- Had to install ganache-cli with npm instead of yarn.

### How to test contracts
We want to run tests in this order (mainnet-fork is rather optional).
1. `development` with mocks (local machine)
2. `testnet` (sepolia)
3. `mainnet-fork` (custom) # A fork is the fork of the main (ETH) net.

### Brownie
- Ran into difficulties when installing Brownie. Messed with the PATH local variables.
Might want to clean up the unused directories from the [PATH](https://gist.github.com/nex3/c395b2f8fd4b02068be37c961301caa7).
- To delete a Brownie account: `brownie accounts delete {name}`
- brownie-config.yaml - config file for brownie. Tell it what to do (where to extract data, etc.)
- For brownie templates: `brownie bake chainlink-mix` (templates by Patrick Collins)

#### Brownie cli 
All brownie tests come from Pytest! (almost the same interface)
- brownie run script/{scipt name} # run a script
- brownie test -k {test_name} # to only run the specific test function
- brownie test --pdb # if a test fails, we get put into python shell, so we can debug   
- brownie test -s # more details (which exact tests failed/passed)
- brownie run {srcipt} --network {network} # to deploy to a test network
- brownie console # interactive console to run commands by hand (deploy, test contracts, etc.)

## Questions
- What is JSON RPC? # I think RPC is a blockchain network node...
- What exactly is Infura and why exactly do we need it?
ANSWER: I think Infura is the middleman API for us to send our contracts to the network. It is a smart contract deployment API. Infura is an RPC ^
- For ERC20, the initial supply is specified in ETHER. How do we count the number of actual tokens?


## To do
- <s>Review deploy.py and make sure I understand every step. Write comments for what every step does.</s>
- <s>Take notes on the Brownie project configuration [Video explanation](https://youtu.be/OeHYm7CXNsw?t=262).</s>