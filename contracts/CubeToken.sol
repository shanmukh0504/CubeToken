// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

abstract contract ERC20Interface {
    function totalSupply() public view virtual returns (uint);
    function balanceOf(address tokenOwner) public view virtual returns (uint balance);
    function allowance(address tokenOwner, address spender) public view virtual returns (uint remaining);
    function transfer(address to, uint tokens) public virtual returns (bool success);
    function approve(address spender, uint tokens) public virtual returns (bool success);
    function transferFrom(address from, address to, uint tokens) public virtual returns (bool success);

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

contract CBToken is ERC20Interface {
    string public symbol;
    string public name;
    uint8 public decimals;
    uint public _totalSupply;
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

    constructor() {
        symbol = "CBT";
        name = "Cube Token";
        decimals = 18;
        maxSupply = 20_000_000 * (10 ** uint(decimals));
        _totalSupply = 10_000_000 * (10 ** uint(decimals));
        owner = msg.sender;
        balances[owner] = _totalSupply;
        emit Transfer(address(0), owner, _totalSupply);
        paused = false;
    }

    function totalSupply() public view virtual override returns (uint) {
        return _totalSupply;
    }

    function balanceOf(address tokenOwner) public view virtual override returns (uint balance) {
        return balances[tokenOwner];
    }

    function transfer(address to, uint tokens) public virtual override whenNotPaused returns (bool success) {
        uint tokensToTransfer = tokens * (10 ** uint(decimals));
        require(balances[msg.sender] >= tokensToTransfer, "Insufficient balance");
        balances[msg.sender] -= tokensToTransfer;
        balances[to] += tokensToTransfer;
        emit Transfer(msg.sender, to, tokensToTransfer);
        return true;
    }

    function approve(address spender, uint tokens) public virtual override whenNotPaused returns (bool success) {
        uint tokensToApprove = tokens * (10 ** uint(decimals));
        allowed[msg.sender][spender] = tokensToApprove;
        emit Approval(msg.sender, spender, tokensToApprove);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) public virtual override whenNotPaused returns (bool success) {
        uint tokensToTransfer = tokens * (10 ** uint(decimals));
        require(balances[from] >= tokensToTransfer, "Insufficient balance");
        require(allowed[from][msg.sender] >= tokensToTransfer, "Allowance exceeded");

        balances[from] -= tokensToTransfer;
        allowed[from][msg.sender] -= tokensToTransfer;
        balances[to] += tokensToTransfer;

        emit Transfer(from, to, tokensToTransfer);
        return true;
    }

    function allowance(address tokenOwner, address spender) public view virtual override returns (uint remaining) {
        return allowed[tokenOwner][spender] / (10 ** uint(decimals));
    }

    function approveAndCall(address spender, uint tokens, bytes memory data) public whenNotPaused returns (bool success) {
        uint tokensToApprove = tokens * (10 ** uint(decimals));
        allowed[msg.sender][spender] = tokensToApprove;
        emit Approval(msg.sender, spender, tokensToApprove);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokensToApprove, address(this), data);
        return true;
    }

    function mint(uint tokens) public onlyOwner returns (bool success) {
        uint tokensToMint = tokens * (10 ** uint(decimals));
        require(_totalSupply + tokensToMint <= maxSupply, "Minting exceeds maximum supply");
        _totalSupply += tokensToMint;
        balances[owner] += tokensToMint;
        emit Transfer(address(0), owner, tokensToMint);
        return true;
    }

    function burn(uint tokens) public returns (bool success) {
        uint tokensToBurn = tokens * (10 ** uint(decimals));
        require(balances[msg.sender] >= tokensToBurn, "Insufficient balance to burn");
        balances[msg.sender] -= tokensToBurn;
        _totalSupply -= tokensToBurn;
        emit Transfer(msg.sender, address(0), tokensToBurn);
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