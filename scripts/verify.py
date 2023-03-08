import brownie
from brownie import yDonate

def main():
  deploy_address = '0x18830f8CC6A4bf2D71baeaf59B1A2f983F69bE01'
  token = yDonate.at(deploy_address)
  yDonate.publish_source(token)
