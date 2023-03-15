# yDonate

> yield for a cause

This contract allows users to stake ERC20 tokens that are deposited in Yearn Vaults and the yield generated is sent to one receiver.

yDonate automatically detects the vault for the token staked by using the [Yearn FTM Registry](https://ftmscan.com/address/0x727fe1759430df13655ddb0731dE0D0FDE929b04)

**Source:**
- https://github.com/MarcoWorms/yDonate/blob/master/contracts/yDonate.sol  

**Live preview at:**
- https://ftmscan.com/address/0x6c861a651F303CFb92cbaa4D9c9AB35B84d6c3f0


<img width="750" alt="Screenshot 2023-03-15 at 3 10 11 PM" src="https://user-images.githubusercontent.com/7863230/225454965-5e3e3985-cb63-419c-9bd6-ff926db01274.png">

## Usage

The yDonate contract allows users to stake their tokens in Yearn Finance vaults and automatically donate the generated yield to a predefined receiver. This contract uses OpenZeppelin's ERC20.sol and interfaces with Yearn Finance's vaults and registry.

### Contract Initialization
To deploy the yDonate contract, you need to provide the following parameters:

- `registryAddress`: The address of the Yearn Finance registry contract.
- `receiver`: The address that will receive the donated yield.

### Contract Functions

#### stake

The stake function allows users to stake their tokens in the corresponding Yearn Finance vault.

- `amount`: The number of tokens the user wants to stake.
- `tokenAddress`: The address of the token that the user wants to stake.

#### unstake

The unstake function allows users to unstake their tokens and automatically donate the generated yield to the receiver.

- `tokenAddress`: The address of the staked token.

#### donateYield

The donateYield function allows users to donate the generated yield without unstaking their tokens.

- `tokenAddress`: The address of the staked token.
