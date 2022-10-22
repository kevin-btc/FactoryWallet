//SPDX-License-Identifier: None

pragma solidity ^0.8.4;

import "./Wallet.sol";

contract FactoryWallet {

    struct FactoryWalletStruct {
        Wallet wallet;
        bool created;
    }

    mapping (address => FactoryWalletStruct) factoryWallets;

    modifier isCreatedWallet() {
        require(factoryWallets[msg.sender].created, "No Wallet created");
        _;
    }

    function createWallet() external returns(address){
        require(!factoryWallets[msg.sender].created, "Already Created");
        Wallet w = new Wallet();
        factoryWallets[msg.sender].wallet = w;
        factoryWallets[msg.sender].created = true;

        return address(w);
    }

    function getTotalBalanceByContrat() external view isCreatedWallet returns (uint) {
        return factoryWallets[msg.sender].wallet.getTotalBalance();
    }

    function getBalanceByContrat() external view  isCreatedWallet returns (uint) {
        return factoryWallets[msg.sender].wallet.getTotalBalance();

    }

    function withdrawAllMoneyByContrat(address payable _to) external isCreatedWallet {
        factoryWallets[msg.sender].wallet.withdrawAllMoney(_to);

    }

    function withdrawMoneyByContrat(address payable _to, uint _amount) external isCreatedWallet {
        factoryWallets[msg.sender].wallet.withdrawMoney(_to, _amount);
    }

    
}