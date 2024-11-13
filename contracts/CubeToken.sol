// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

abstract contract ERC20Interface {
    string public symbol;
    string public name;
    uint8 public decimals;
    uint public initialSupply;
    uint public maxSupply;
    address public owner;
    bool public paused;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier whenNotPaused() {
        require(!paused, "Contract is paused");
        _;
    }

    event Paused(address indexed account);
    event Unpaused(address indexed account);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

abstract contract ApproveAndCallFallBack {
    function receiveApproval(
        address from,
        uint256 tokens,
        address token,
        bytes memory data
    ) public virtual;
}

contract CubeToken is ERC20Interface {
    constructor() {
        symbol = "CBT";
        name = "Cube Token";
        decimals = 18;
        initialSupply = 5_000_000 * (10 ** uint(decimals));
        maxSupply = 10_000_000 * (10 ** uint(decimals));
        owner = msg.sender;
        paused = false;
        balances[owner] = initialSupply;
        emit Transfer(address(0), owner, initialSupply);
    }

    function totalSupply() public view virtual returns (uint) {
        return initialSupply;
    }

    function balanceOf(address tokenOwner) public view virtual returns (uint balance) {
        return balances[tokenOwner];
    }

    function transfer(address to, uint tokens) public virtual whenNotPaused returns (bool success) {
        require(balances[msg.sender] >= tokens, "Insufficient balance");
        balances[msg.sender] -= tokens;
        balances[to] += tokens;
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    function approve(address spender, uint tokens) public virtual whenNotPaused returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) public virtual whenNotPaused returns (bool success) {
        require(balances[from] >= tokens, "Insufficient balance");
        require(allowed[from][msg.sender] >= tokens, "Allowance exceeded");

        balances[from] -= tokens;
        allowed[from][msg.sender] -= tokens;
        balances[to] += tokens;

        emit Transfer(from, to, tokens);
        return true;
    }

    function allowance(address tokenOwner, address spender) public view virtual returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    function increaseAllowance(address spender, uint256 addValue) public virtual whenNotPaused returns (bool success) {
        require(allowed[msg.sender][spender] + addValue >= allowed[msg.sender][spender], "allowance overflow");
        allowed[msg.sender][spender] += addValue;
        emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
        return true;
    }
    
    function decreaseAllowance(address spender, uint256 subValue) public virtual whenNotPaused returns (bool success) {
        uint256 currAllowance = allowed[msg.sender][spender];
        require(currAllowance >= subValue, "decreased allowance below zero");
        allowed[msg.sender][spender] = currAllowance - subValue;
        emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
        return true;
    }

    function mint(uint tokens) public onlyOwner returns (bool success) {
        require(initialSupply + tokens <= maxSupply, "Minting exceeds maximum supply");
        initialSupply += tokens;
        balances[owner] += tokens;
        emit Transfer(address(0), owner, tokens);
        return true;
    }

    function burn(uint tokens) public returns (bool success) {
        require(balances[msg.sender] >= tokens, "Insufficient balance to burn");
        balances[msg.sender] -= tokens;
        initialSupply -= tokens;
        emit Transfer(msg.sender, address(0), tokens);
        return true;
    }

    function pause() public onlyOwner {
        paused = true;
        emit Paused(msg.sender);
    }

    function unpause() public onlyOwner {
        paused = false;
        emit Unpaused(msg.sender);
    }

    receive() external payable {
        revert("Cannot accept ETH");
    }
}