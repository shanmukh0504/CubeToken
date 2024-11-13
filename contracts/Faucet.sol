// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

interface IERC20 {
    function transfer(address to, uint256 tokens) external returns (bool success);

    function balanceOf(address account) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);
}

contract Faucet {
    address payable owner;
    IERC20 public token;

    uint256 public withdrawalAmount = 0.5 * 10**18;
    uint256 public lockTime = 24 hours;

    event Withdrawal(address indexed to, uint256 indexed amount);
    event Deposit(address indexed from, uint256 indexed amount);

    mapping(address => uint256) nextAccessTime;

    constructor(address tokenAddress) payable {
        token = IERC20(tokenAddress);
        owner = payable(msg.sender);
    }

    function requestTokens() public {
        require(
            msg.sender != address(0),
            "Request must not originate from a zero account"
        );
        require(
            token.balanceOf(address(this)) >= withdrawalAmount,
            "Insufficient balance in faucet for withdrawal request"
        );
        require(
            block.timestamp >= nextAccessTime[msg.sender],
            "Insufficient time elapsed since last withdrawal - try again later."
        );

        nextAccessTime[msg.sender] = block.timestamp + lockTime;

        token.transfer(msg.sender, withdrawalAmount);
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function getBalance() external view returns (uint256) {
        return token.balanceOf(address(this));
    }

    function setWithdrawalAmount(uint256 amount) public onlyOwner {
        withdrawalAmount = amount;
    }

    function setLockTime(uint256 amount) public onlyOwner {
        lockTime = amount * 24 hours;
    }

    function withdraw() external onlyOwner {
        uint256 faucetBalance = token.balanceOf(address(this));
        require(faucetBalance > 0, "No tokens available in faucet to withdraw");

        bool success = token.transfer(owner, faucetBalance);
        require(success, "Token transfer failed");

        emit Withdrawal(owner, faucetBalance);
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only the contract owner can call this function"
        );
        _;
    }
}
