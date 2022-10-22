//SPDX-License-Identifier: None

pragma solidity ^0.8.4;

import "./Ownable.sol";

contract Wallet is Ownable {

    struct Payment {
        uint amount;
        uint timestamp;
    }

    struct Balance {
        uint totalBalance;
        uint numberPayment;
        mapping(uint => Payment) payments;
    }

    mapping (address => Balance) wallets;

    receive() external payable {
        Payment memory payment = Payment(msg.value, block.timestamp);
        wallets[msg.sender].totalBalance = msg.value;     
        wallets[msg.sender].payments[wallets[msg.sender].numberPayment] = payment;     
        wallets[msg.sender].numberPayment++;     
    }

    function getTotalBalance() external view onlyOwner returns (uint) {
        return address(this).balance;
    }

       function getBalance() external view  returns (uint) {
        return wallets[msg.sender].totalBalance;
    }

    function withdrawAllMoney(address payable _to) external {
        uint amount = wallets[msg.sender].totalBalance;
        require(amount != 0 , "Empty wallet");
        wallets[msg.sender].totalBalance = 0;
        _to.transfer(amount);
    }

    function withdrawMoney(address payable _to, uint _amount) external {
        require(_amount != 0 , "Empty wallet");
        require(_amount <= wallets[msg.sender].totalBalance, "Not enought money");

        wallets[msg.sender].totalBalance -= _amount;
        _to.transfer(_amount);
    }
}