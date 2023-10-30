// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts@4.9.3/utils/Counters.sol";
import "./DEX/DAI2SLX.sol";
import "./XRC721.sol";
import "./interfaces/IM3ter.sol";

/// @custom:security-contact info@whynotswitch.com
contract TestM3ter is XRC721, IM3ter {
    bytes32 public constant REGISTRAR_ROLE = keccak256("REGISTRAR_ROLE");

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    mapping(uint256 => bytes32) public registry;

    constructor() ERC721("M3ter", "M3R") {
        if (address(DAI2SLX.MIMO) == address(0)) revert ZeroAddress();
        if (address(DAI2SLX.DAI) == address(0)) revert ZeroAddress();
        if (address(DAI2SLX.SLX) == address(0)) revert ZeroAddress();

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(REGISTRAR_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
    }

    function mint() external onlyRole(REGISTRAR_ROLE) whenNotPaused {
        _safeMint(msg.sender, _tokenIdCounter.current());
        _tokenIdCounter.increment();
    }

    function _register(
        uint256 tokenId,
        bytes32 deviceId
    ) external onlyRole(REGISTRAR_ROLE) {
        if (!_exists(tokenId)) revert NonexistentM3ter();
        emit Register(tokenId, deviceId, block.timestamp, msg.sender);
        registry[tokenId] = deviceId;
    }
}
