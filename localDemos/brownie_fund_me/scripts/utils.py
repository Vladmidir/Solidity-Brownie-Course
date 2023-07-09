from brownie import network, config, accounts, MockV3Aggregator

DECIMALS = 8
STARTING_PRICE = 2000 * 10**DECIMALS

LOCAL_NETWORKS = ["development", "ganache-local"]
FORKED_LOCAL_NETWORKS = ["mainnet-fork", "mainnet-fork-dev"]


def get_account():
    # for dev purposes
    if (
        network.show_active() in LOCAL_NETWORKS
        or network.show_active() in FORKED_LOCAL_NETWORKS
    ):
        return accounts[0]
    # for test networks
    else:
        return accounts.add(config["wallets"]["from_key"])


def deploy_mocks():
    account = get_account()
    print("Deploying mocks...")
    if len(MockV3Aggregator) <= 0:
        MockV3Aggregator.deploy(DECIMALS, STARTING_PRICE, {"from": account})
    print("Mocks deployed!")
