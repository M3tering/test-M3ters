// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

interface IM3ter {
    error NonexistentM3ter();

    event Register(
        uint256 indexed tokenId,
        bytes32 indexed deviceId,
        uint256 timestamp,
        address from
    );

    function mint() external;

    function _setMintFee(uint256 amount) external;

    function _register(uint256 tokenId, bytes32 deviceId) external;

    function _claim(uint256 amountIn, uint256 amountOutMin, uint256 deadline) external;
}
