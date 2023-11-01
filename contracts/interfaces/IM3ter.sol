// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "@openzeppelin/contracts@4.9.3/token/ERC721/IERC721.sol";

interface IM3ter is IERC721 {
    error ZeroAddress();
    error NonexistentM3ter();

    event Register(
        uint256 indexed tokenId,
        bytes32 indexed publicKey,
        uint256 timestamp,
        address from
    );

    function mint() external;

    function _setMintFee(uint256 amount) external;

    function _register(uint256 tokenId, bytes32 publicKey) external;

    function _claim(uint256 amountIn, uint256 amountOutMin, uint256 deadline) external;
}
