// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

interface IM3ter {
    event Register(
        uint indexed id,
        uint indexed parity,
        bytes32 indexed pointX,
        uint timestamp,
        address from
    );

    struct PubKey {
        uint parity;
        bytes32 pointX;
    }

    function _register(uint id, uint parity, bytes32 pointX) external;

    function identify(uint id) external view returns (PubKey memory);
}
