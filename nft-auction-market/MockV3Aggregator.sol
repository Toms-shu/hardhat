// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract MockV3Aggregator {

    int256 private answer;

    uint8 private _decimals;

    constructor(
        int256 _answer
    ) {
        answer = _answer;

        _decimals = 8;
    }

    function decimals()
        external
        view
        returns (uint8)
    {
        return _decimals;
    }

    function description()
        external
        pure
        returns (string memory)
    {
        return "Mock Price Feed";
    }

    function version()
        external
        pure
        returns (uint256)
    {
        return 1;
    }

    function latestRoundData()
        external
        view
        returns (
            uint80,
            int256,
            uint256,
            uint256,
            uint80
        )
    {
        return (
            0,
            answer,
            0,
            0,
            0
        );
    }
}