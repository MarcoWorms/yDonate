pragma solidity ^0.8.14;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./IyVault.sol";

contract yDonate {

    address public _yVaultAddress;
    IyVault private _yVault;

    address public _stakedTokenAddress;
    ERC20 private _stakedToken;

    address public _receiver;

    mapping (address => uint256) public _stakedAmount;
    mapping (address => uint256) public _stakedShares;

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amountUnstaked, uint256 amountDonated);

    constructor (address yVaultAddress, address receiver) {
        _yVaultAddress = yVaultAddress;
        _yVault = IyVault(yVaultAddress);
        _stakedTokenAddress = _yVault.token();
        _stakedToken = ERC20(_stakedTokenAddress);
        _receiver = receiver;
        _stakedToken.approve(_yVaultAddress, 2**256 - 1);
    }

    function yearnReapprove() public {
        _stakedToken.approve(_yVaultAddress , 2**256 - 1);
    }

    function stake(uint256 amount) public {
        require(amount > 0, "Must stake more than 0 tokens.");

        if (_stakedShares[msg.sender] > 0) {
            unstake();
        }

        _stakedToken.transferFrom(msg.sender, address(this), amount);

        _stakedAmount[msg.sender] = amount;
        _stakedShares[msg.sender] = _yVault.deposit(amount);

        emit Staked(msg.sender, amount);
    }

    function unstake() public returns (uint256 stakedAmount) {
        require(_stakedShares[msg.sender] > 0, "You need to stake before unstaking.");

        uint256 stakedShares = _stakedShares[msg.sender];
        uint256 stakedAmount = _stakedAmount[msg.sender];

        _stakedShares[msg.sender] = 0;
        _stakedAmount[msg.sender] = 0;

        uint256 totalRedeemed = _yVault.withdraw(stakedShares);

        if (stakedAmount > totalRedeemed) {
            stakedAmount = totalRedeemed;
        }

        _stakedToken.transfer(msg.sender, stakedAmount);

        uint256 donated = totalRedeemed - stakedAmount;
        if (donated > 0) {
            _stakedToken.transfer(_receiver, donated);
        }

        emit Unstaked(msg.sender, stakedAmount, donated);
        return stakedAmount;
    }

    function donateYield() public {
        require(_stakedShares[msg.sender] > 0, "You need to stake before donating yield.");
        uint toRestake = unstake();
        stake(toRestake);
    }

}