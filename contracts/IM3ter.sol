// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

interface IM3ter {
    event Register(
        uint256 indexed id,
        bytes1 indexed parity,
        bytes32 indexed pointX,
        uint256 timestamp,
        address from
    );

    struct PubKey {
        bytes1 parity;
        bytes32 pointX;
    }

    function _register(uint256 id, bytes1 parity, bytes32 pointX) external;

    function identify(uint256 id) external view returns (PubKey memory);
}
