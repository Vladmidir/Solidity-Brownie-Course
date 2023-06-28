# This script interacts with the contracts we have already deployed.
# We can view our deployed scripts inside the "build > deployments". The folder name is the deployment network id.

from brownie import accounts, config, SimpleStorage


def read_contract():
    simple_storage = SimpleStorage[-1]  # most recet deployment
    # ABI - already knows
    # Address - already knows
    print(simple_storage.retrieve())


def main():
    read_contract()
