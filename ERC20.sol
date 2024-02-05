// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GovernanceToken {
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowances;
    uint256 public _totalSupply;
    address public owner;

    string public _name;
    string public _symbol;

    constructor(string memory name_, string memory symbol_, uint256 initialSupply) {
        _name = name_;
        _symbol = symbol_;
        owner = msg.sender;
        _mint(owner, initialSupply);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        require(balances[msg.sender] >= amount, "Insufficient balance.");
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        return true;
    }

    function allowance(address _owner, address spender) public view returns (uint256) {
        return allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        allowances[msg.sender][spender] = amount;
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        require(balances[sender] >= amount, "Insufficient balance.");
        require(allowances[sender][msg.sender] >= amount, "Insufficient allowance.");
        balances[sender] -= amount;
        balances[recipient] += amount;
        allowances[sender][msg.sender] -= amount;
        return true;
    }

    function mint(uint256 amount) public {
        require(msg.sender == owner, "Only the contract owner can mint tokens.");
        _mint(owner, amount);
    }

    function burn(uint256 amount) public {
        require(msg.sender == owner, "Only the contract owner can burn tokens.");
        require(balances[owner] >= amount, "Insufficient balance to burn.");
        balances[owner] -= amount;
        _totalSupply -= amount;
    }

    function _mint(address account, uint256 amount) internal {
        _totalSupply += amount;
        balances[account] += amount;
    }
}