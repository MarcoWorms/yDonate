from brownie import yDonate, accounts

# def main():
#     acct = accounts.load('worms')
#     yvop = '0x7D2382b1f8Af621229d33464340541Db362B4907'
#     cause = '0xB1d693B77232D88a3C9467eD5619FfE79E80BCCc'
#     yDonate.deploy(yvop, cause, { 'from': acct.address })

def main():
    acct = accounts.load('worms')
    ftmRegistry = '0x727fe1759430df13655ddb0731dE0D0FDE929b04'
    cause = '0xB1d693B77232D88a3C9467eD5619FfE79E80BCCc'
    deployed = yDonate.deploy(ftmRegistry, cause, { 'from': acct.address })
    toVerify = yDonate.at(deployed.address)
    yDonate.publish_source(toVerify)