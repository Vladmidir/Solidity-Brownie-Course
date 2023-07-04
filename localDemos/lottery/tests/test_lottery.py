# expect approx $50 == .027 eth

from brownie import Lottery, accounts, config, network
from web3 import Web3


def test_get_entrace_fee():
    account = accounts[0]
    lottery = Lottery.deploy(
        config["networks"][network.show_active()]["eth_usd_price_feed"],
        {"from": account},
    )

    assert lottery.getEntranceFee() > Web3.toWei(0.025, "gwei")
    assert lottery.getEntranceFee() < Web3.toWei(0.029, "gwei")
