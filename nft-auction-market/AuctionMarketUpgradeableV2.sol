// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./AuctionMarketUpgradeable.sol";

contract AuctionMarketUpgradeableV2 is
    AuctionMarketUpgradeable
{
    function version()
        public
        pure
        returns (string memory)
    {
        return "V2";
    }
}