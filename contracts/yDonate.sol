pragma solidity ^0.8.14;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./IyVault.sol";
import "./IyRegistry.sol";

contract yDonate {

    address public _yRegistryAddress;
    IyRegistry private _yRegistry;

    address public _receiver;

    // user address => token address => data
    mapping (address =>  mapping (address => uint256)) public _stakedAmount;
    mapping (address =>  mapping (address => uint256)) public _stakedShares;
    mapping (address =>  mapping (address => address)) public _stakedvaultAddress;

    event Staked(address indexed user, uint256 amount, address tokenAddress);
    event Unstaked(address indexed user, uint256 amountUnstaked, uint256 amountDonated, address tokenAddress);

    constructor (address registryAddress, address receiver) {
        _yRegistryAddress = registryAddress;
        _yRegistry = IyRegistry(_yRegistryAddress);
        _receiver = receiver;
    }

    function stake(uint256 amount, address tokenAddress) public {
        require(amount > 0, "Must stake more than 0 tokens.");

        if (_stakedShares[msg.sender][tokenAddress] > 0) {
            unstake(tokenAddress);
        }

        address yVaultAddress = _yRegistry.latestVault(tokenAddress);
        IyVault yVault = IyVault(yVaultAddress);
        ERC20 want = ERC20(tokenAddress);

        if (want.allowance(address(this), yVaultAddress) < amount) {
            want.approve(yVaultAddress, 2**256 - 1);
        }
        
        want.transferFrom(msg.sender, address(this), amount);

        _stakedAmount[msg.sender][tokenAddress] = amount;
        _stakedShares[msg.sender][tokenAddress] = yVault.deposit(amount);
        _stakedvaultAddress[msg.sender][tokenAddress] = yVaultAddress;

        emit Staked(msg.sender, amount, tokenAddress);
    }

    function unstake(address tokenAddress) public returns (uint256 stakedAmount) {
        require(_stakedShares[msg.sender][tokenAddress] > 0, "You need to stake before unstaking.");

        uint256 stakedShares = _stakedShares[msg.sender][tokenAddress];
        uint256 stakedAmount = _stakedAmount[msg.sender][tokenAddress];

        _stakedShares[msg.sender][tokenAddress] = 0;
        _stakedAmount[msg.sender][tokenAddress] = 0;

        address yVaultAddress = _stakedvaultAddress[msg.sender][tokenAddress];
        IyVault yVault = IyVault(yVaultAddress);
        ERC20 want = ERC20(tokenAddress);

        uint256 totalRedeemed = yVault.withdraw(stakedShares);

        // yvault may return less than expected due to rounding
        if (stakedAmount > totalRedeemed) {
            stakedAmount = totalRedeemed;
        }

        if (want.allowance(address(this), yVaultAddress) < totalRedeemed) {
            want.approve(yVaultAddress, 2**256 - 1);
        }

        want.transfer(msg.sender, stakedAmount);

        uint256 donated = totalRedeemed - stakedAmount;
        if (donated > 0) {
            want.transfer(_receiver, donated);
        }

        emit Unstaked(msg.sender, stakedAmount, donated, tokenAddress);
        return stakedAmount;
    }

    function donateYield(address tokenAddress) public {
        require(_stakedShares[msg.sender][tokenAddress] > 0, "You need to stake before donating yield.");
        uint toRestake = unstake(tokenAddress);
        stake(toRestake, tokenAddress);
    }

}