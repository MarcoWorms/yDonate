from brownie import yDonate, accounts

def main():
    acct = accounts.load('worms')
    yvop = '0x7D2382b1f8Af621229d33464340541Db362B4907'
    cause = '0xB1d693B77232D88a3C9467eD5619FfE79E80BCCc'
    yDonate.deploy(yvop, cause, { 'from': acct.address })
    # CookieCapital.publish_source(CookieCapital.address)
