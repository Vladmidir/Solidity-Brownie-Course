from brownie import accounts, config, network, SimpleStorage  # easy contract import!
import os

# I LOVE BROWNIE


def deploy_simple_storage():
    account = get_account()  # use this for dev purposes
    # Brownie does most of the deployment automatically!
    # We just need to specify the private and public (address) keys.
    # account = accounts.add(config["wallets"]["from_key"])  # Good way to store keys :)
    simple_storage = SimpleStorage.deploy({"from": account})  # much faster deployment!
    stored_value = simple_storage.retrieve()
    print(stored_value)
    transaction = simple_storage.store(120, {"from": account})
    transaction.wait(1)  # wait one block
    updated_stored_value = simple_storage.retrieve()
    print(updated_stored_value)


def get_account():
    # for dev purposes
    if network.show_active() == "development":
        return accounts[0]
    # for test networks
    else:
        return accounts.add(config["wallets"]["from_key"])


def main():
    deploy_simple_storage()
