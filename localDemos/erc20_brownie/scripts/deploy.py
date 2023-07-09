from brownie import ourToken, accounts


def deploy_our_token():
    account = accounts[0]
    # NOTE: The initial supply is specified in ETHER. How do we count the actual token?
    token = ourToken.deploy(1000, {"from": account})
    print("Deployed OurToken!")
    # balanceOf function is inherite from ERC20 (it is a standart for all ERC20s)
    print(f"Our balance is {token.balanceOf(account.address)}")


def main():
    deploy_our_token()
