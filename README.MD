# Learning Solidity
Here I will save my .sol files that I write while getting to know how to use Solidity

I am using the Remix solidity IDE for development and just copy paste the code I write there to my local machine, 
so that it can be easily referenced. 

> Note: Solidity Format on save is ON. Python formater = black. Font size: changed from 14 to 16.

## Order of the "projects"
This this the order in which I have build the files included in this folder
1. SimpleStorage.sol
2. StorageFactory.sol
3. FundMe.sol
4. LocalDemos > web3_py_simple_storage
5. LocalDemos > brownie_simple_storage
6. LocalDemos > lottery (upgraded to VRF V2)
7. LocalDemos > brownie_fund_me (yes, I did them in the wrong order 🤦‍♂️)

## Notes
- To configure VS Code solidity version [how to](https://youtu.be/umg2fWQX6jM?t=658)
- Had to install ganache-cli with npm instead of yarn.

### How to test contracts
We want to run tests in this order (mainnet-fork is rather optional).
1. `development` with mocks (local machine)
2. `testnet` (sepolia)
3. `mainnet-fork` (custom) # A fork is the fork of the main (ETH) net.

### Brownie
- Ran into difficulties when installing Brownie. Messed with the PATH local variables.
Might want to clean up the unused directories form the [PATH](https://gist.github.com/nex3/c395b2f8fd4b02068be37c961301caa7).
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

## Quetions
- What is JSON RPC? # I think RPC is a network node...
- What exactly is Infura and why exactly do we need it?
ANSWER: I think Infura is the middleman API for us to send our contracts to the network. It is a smart contract deployment API.
- For ERC20, the initial supply is specified in ETHER. How do we count the number of actual tokens?


## To do
- <s>Review deploy.py and make sure I understand every step. Write comments for what every step does.</s>
- Take notes on Brownie project configuration [Video explanation](https://youtu.be/OeHYm7CXNsw?t=262).