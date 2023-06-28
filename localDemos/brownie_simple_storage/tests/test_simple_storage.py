# make sure to add 'test' in from of the file name!
from brownie import SimpleStorage, accounts


# Test the deployment of the contract
def test_deploy():
    # Testing setup:
    # - Arrage
    account = accounts[0]
    # - Act
    simple_storage = SimpleStorage.deploy({"from": account})
    starting_value = simple_storage.retrieve()
    excepted = 0
    # - Assert
    assert starting_value == excepted


def test_update_storage():
    # Arrage
    account = accounts[0]
    simple_storage = SimpleStorage.deploy({"from": account})
    # Act
    expected = 15
    simple_storage.store(15, {"from": account})
    # Assert
    assert expected == simple_storage.retrieve()
