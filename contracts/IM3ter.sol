// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

interface IM3ter {
    event Register(
        uint256 indexed tokenId,
        bytes32 indexed deviceId,
        uint256 timestamp,
        address from
    );

    function _register(uint256 tokenId, bytes32 deviceId) external;

    function identify(uint256 tokenId) external view returns (bytes32);

    function safeMint() external payable;
}
