// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";


contract AuctionMarketUpgradeable is Initializable, UUPSUpgradeable, OwnableUpgradeable {

          // initialer修饰器保证函数只被执行一次
          function initialize() public initializer {
                    // 初始化owner，因为逻辑合约不会执行constructor函数
                    __Ownable_init();
                    // 初始化内部状态变量，为后续升级做准备
                    __UUPSUpgradeable_init();
          }

          //升级权限控制，继承后必须重写
          function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}