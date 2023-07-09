from brownie import FundMe, network, accounts, exceptions
from scripts.utils import get_account, LOCAL_NETWORKS
from scripts.deploy import deploy_fund_me
import pytest


def test_fund_and_withdraw():
    # Arrange
    account = get_account()
    fund_me = deploy_fund_me()
    entrance_fee = fund_me.getEntranceFee() + 100
    # Act
    tx = fund_me.fund({"from": account, "value": entrance_fee})
    tx.wait(1)
    # Assert
    assert fund_me.addressToAmountFunded(account) == entrance_fee
    # Act
    tx2 = fund_me.withdraw({"from": account})
    tx2.wait(1)
    # Assert
    assert fund_me.addressToAmountFunded(account) == 0


def test_only_owner_can_withdraw():
    if network.show_active() not in LOCAL_NETWORKS:
        pytest.skip("only for local testing")

    account = get_account()
    fund_me = deploy_fund_me()
    account2 = accounts.add()
    with pytest.raises(exceptions.VirtualMachineError):
        fund_me.withdraw({"from": account2})
