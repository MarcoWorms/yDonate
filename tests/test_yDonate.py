from brownie import accounts, yDonate
import pytest

@pytest.fixture(scope="module")
def deploy_yDonate(get_yRegistry, get_receiver):
    yRegistryAddress = get_yRegistry
    receiver = get_receiver
    yDonateContract = yDonate.deploy(yRegistryAddress, receiver, {"from": accounts[0]})
    return yDonateContract

@pytest.fixture(scope="module")
def get_yRegistry():
    # Replace this with the address of your deployed yRegistry contract
    return "0x123..."

@pytest.fixture(scope="module")
def get_receiver():
    return accounts[1]

@pytest.fixture(scope="module")
def get_token():
    # Replace this with the address of your deployed ERC20 token contract
    return "0x456..."

def test_stake(deploy_yDonate, get_token):
    user = accounts[2]
    token = ERC20.at(get_token)
    token.transfer(user, 1000, {"from": accounts[0]})
    
    initial_balance = token.balanceOf(user)

    # Approve yDonate contract to spend tokens on behalf of the user
    token.approve(deploy_yDonate, 1000, {"from": user})

    # Stake 500 tokens
    deploy_yDonate.stake(500, get_token, {"from": user})

    assert deploy_yDonate._stakedAmount(user, get_token) == 500
    assert token.balanceOf(user) == initial_balance - 500

def test_unstake(deploy_yDonate, get_token, get_receiver):
    user = accounts[3]
    token = ERC20.at(get_token)
    token.transfer(user, 1000, {"from": accounts[0]})

    # Approve yDonate contract to spend tokens on behalf of the user
    token.approve(deploy_yDonate, 1000, {"from": user})

    # Stake 500 tokens
    deploy_yDonate.stake(500, get_token, {"from": user})

    # Unstake tokens
    deploy_yDonate.unstake(get_token, {"from": user})

    assert deploy_yDonate._stakedAmount(user, get_token) == 0
    assert deploy_yDonate._stakedShares(user, get_token) == 0

    # Check if donation was made
    donated_amount = token.balanceOf(get_receiver)
    assert donated_amount > 0

def test_donateYield(deploy_yDonate, get_token, get_receiver):
    user = accounts[4]
    token = ERC20.at(get_token)
    token.transfer(user, 1000, {"from": accounts[0]})

    # Approve yDonate contract to spend tokens on behalf of the user
    token.approve(deploy_yDonate, 1000, {"from": user})

    # Stake 500 tokens
    deploy_yDonate.stake(500, get_token, {"from": user})

    # Wait for some time to pass (assuming yield generation in the yVault)
    # You may need to adjust this based on the yVault implementation
    chain.sleep(60 * 60 * 24 * 7)  # 1 week
    chain.mine()

    # Donate yield
    deploy_yDonate.donateYield(get_token, {"from": user})

    # Check if donation was made
    donated_amount = token.balanceOf(get_receiver)
    assert donated_amount > 0
    # Check if user's staked amount and shares remain the same after donating yield
    assert deploy_yDonate._stakedAmount(user, get_token) == 500
    assert deploy_yDonate._stakedShares(user, get_token) > 0

def test_fail_unstake_without_staking(deploy_yDonate, get_token):
    user = accounts[5]
    with pytest.raises(Exception, match="You need to stake before unstaking."):
        deploy_yDonate.unstake(get_token, {"from": user})

def test_fail_donateYield_without_staking(deploy_yDonate, get_token):
    user = accounts[6]
    with pytest.raises(Exception, match="You need to stake before donating yield."):
        deploy_yDonate.donateYield(get_token, {"from": user})

def test_fail_stake_zero_amount(deploy_yDonate, get_token):
    user = accounts[7]
    token = ERC20.at(get_token)
    token.transfer(user, 1000, {"from": accounts[0]})
    # Approve yDonate contract to spend tokens on behalf of the user
    token.approve(deploy_yDonate, 1000, {"from": user})
    with pytest.raises(Exception, match="Must stake more than 0 tokens."):
        deploy_yDonate.stake(0, get_token, {"from": user})
