from brownie import FundMe, network, config, MockV3Aggregator
from scripts.utils import get_account, deploy_mocks, LOCAL_NETWORKS


def deploy_fund_me():
    account = get_account()
    # if on a persistent nework use the network contract
    # otherwise deploy mocks
    if network.show_active() not in LOCAL_NETWORKS:
        price_feed_address = config["networks"][network.show_active()][
            "eth_usd_price_feed"
        ]
    else:
        deploy_mocks()
        price_feed_address = MockV3Aggregator[-1].address

    fund_me = FundMe.deploy(
        price_feed_address,
        {"from": account},
        publish_source=False,
    )  # public=True <= publish the source code
    # NOTE: We will not publish, since brownie does not allow us :(
    print("FundMe deployed to" + fund_me.address)

    return fund_me


def main():
    deploy_fund_me()
