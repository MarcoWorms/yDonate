# yDonate

> yield for a cause

This contract allows users to stake ERC20 tokens that are deposited in Yearn Vaults and the yield generated is sent to one receiver.

yDonate automatically detects the vault for the token staked by using the [Yearn FTM Registry](https://ftmscan.com/address/0x727fe1759430df13655ddb0731dE0D0FDE929b04)

**Source:**
- https://github.com/MarcoWorms/yDonate/blob/master/contracts/yDonate.sol  

**Live preview at:**
- https://ftmscan.com/address/0x4D4C0146A9672681E54B5a53cB2D177c9347C2a3

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
