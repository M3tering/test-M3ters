// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

interface IM3ter {
    event Register(
        uint256 indexed tokenId,
        bytes32 indexed pkb,
        uint256 timestamp,
        address from
    );

    function _register(uint256 tokenId, bytes32 pbk) external;

    function identify(uint256 tokenId) external view returns (bytes32);
}
