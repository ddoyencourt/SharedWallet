//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SharedWallet{
    event deposit(address sender, uint256 amount, uint a);
    mapping(address => uint256) public allowance;
    address owner;

    constructor(){
        owner=msg.sender;
    }
    fallback () external payable  {
        emit deposit(msg.sender, msg.value, 1);
    }

    receive() external payable{
        emit deposit(msg.sender, msg.value, 2);
    }

    function withdraw(uint256 _amount) public{
        require(_amount <= address(this).balance, "Contract doesn't own enough money");
        require(_amount <= allowance[msg.sender], "Withdraw not allowed");
        require(_amount > 0, "amount must be greater than 0");
        allowance[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
    }

    function setAllowance(address _address, uint256 _amount) public onlyOwner{
        allowance[_address]=_amount;
    }

    function getBalance() public view returns(uint256){
        return address(this).balance;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Only the owner can do that.");
        _;
    }

}
