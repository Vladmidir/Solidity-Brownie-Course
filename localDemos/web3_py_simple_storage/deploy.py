from solcx import compile_standard, install_solc
import json
from web3 import Web3  # why error if it works?
import os
from dotenv import load_dotenv

# load the local env
load_dotenv()

# Does this redownload everytime? Doesn't look like it.
print("Installing...")
install_solc("0.6.0")  # careful with the version
# read the contract
with open("./SimpleStorage.sol", "r") as file:
    simple_storage_file = file.read()


# Compile the contract
complied_sol = compile_standard(
    {
        "language": "Solidity",
        "sources": {"SimpleStorage.sol": {"content": simple_storage_file}},
        "settings": {
            "outputSelection": {
                "*": {"*": ["abi", "metadata", "evm.bytecode", "evm.sourceM ap"]}
            }
        },
    },
    solc_version="0.6.0",
)

# record the compiled code in a file
with open("complied_code.json", "w") as file:
    json.dump(complied_sol, file)

# get bytecode (walk down the json)
bytecode = complied_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["evm"][
    "bytecode"
]["object"]

# get abi (interface)
abi = complied_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["abi"]

# for connection to Ganache (Now Sepolia) (web3 docs - https://web3py.readthedocs.io/en/stable/)
w3 = Web3(
    Web3.HTTPProvider("https://sepolia.infura.io/v3/91c6edf564e0401795b6cb547f05b9c8")
)
chain_id = 11155111  # Sepolia chainID # had to change to 1337, from 5777. Even tho Ganache says the network id is 5777
my_address = "0xf20112ff009A1230a720513fff10c6c339aC09C0"
private_key = os.getenv("PRIVATE_KEY")  # Not optimal, but better then hardcoding

# Create contract object in python based on the previosly build contract from the .sol
SimpleStorage = w3.eth.contract(abi=abi, bytecode=bytecode)

# get number of transactions, so that the nonce doesn't repeat (syntax has changed)
nonce = w3.eth.get_transaction_count(my_address)

# 1. build a transaction
# 2. sign the transaction
# 3. send the transaction

transaction = SimpleStorage.constructor().build_transaction(  # build
    {
        "gasPrice": w3.eth.gas_price,  # add this to prevent errors
        "chainId": chain_id,
        "from": my_address,
        "nonce": nonce,
    }
)

signed_transaction = w3.eth.account.sign_transaction(  # sign
    transaction, private_key=private_key
)

# Send this signed transaction
print("Deploying contract...")
transaction_hash = w3.eth.send_raw_transaction(
    signed_transaction.rawTransaction
)  # send

# Pause the code, waiting for the transaction to deploy
transaction_receipt = w3.eth.wait_for_transaction_receipt(transaction_hash)
print("Deployed!")

# Working with the contract.
# When working with a contract, we always need:
# - Contract address (can get it from deployment transaction reciept)
# - Contract ABI

# Get our contract from the address.
simple_storage = w3.eth.contract(address=transaction_receipt.contractAddress, abi=abi)

# Two ways to interact with contract functions (properties are also functions):
# Call -> Simulate making the call and get a return value (no state change)
# Transact -> Actually make a state change (costs gas)

# Initial val of fav number
print(simple_storage.functions.retrieve().call())

# print(simple_storage.functions.store(15).call()) # DOES NOT ACTUALLY RECORD

# Run the acctual 'sture' function. Call build_transaction() on the function.
print("Updating contract...")
store_transaction = simple_storage.functions.store(151).build_transaction(  # build
    {
        "gasPrice": w3.eth.gas_price,  # add this to prevent errors
        "chainId": chain_id,
        "from": my_address,
        "nonce": nonce + 1,  # shouldnt I update the nonce variable itself?
        # QUESTION: What if I run multiple transactions?
        # Would have to do nonce + 2, etc., since the nonce = w3.eth.get_transaction_count() only runs once.
        # ANSWER: That is exactly what we are doing!!!
    }
)

signed_store_transaction = w3.eth.account.sign_transaction(  # sign
    store_transaction, private_key=private_key
)

send_store_tx = w3.eth.send_raw_transaction(  # send
    signed_store_transaction.rawTransaction
)
transcation_receipt = w3.eth.wait_for_transaction_receipt(send_store_tx)

print("Updated!")

# look at the updated fav num.
print(simple_storage.functions.retrieve().call())
