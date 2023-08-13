// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/Counters.sol";
import "./DEX/DAI2SLX.sol";
import "./XRC721.sol";
import "./IM3ter.sol";

/// @custom:security-contact info@whynotswitch.com
contract M3ter is XRC721, IM3ter {
    bytes32 public constant REGISTRAR_ROLE = keccak256("REGISTRAR_ROLE");
    uint256 public mintFee = 250 * 10 ** 18;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    mapping(uint256 => bytes32) public registry;

    constructor() ERC721("M3ter", "M3R") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(REGISTRAR_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
    }

    function mint() external whenNotPaused {
        DAI2SLX.depositDAI(mintFee);
        _safeMint(msg.sender, _tokenIdCounter.current());
        _tokenIdCounter.increment();
    }

    function _setMintFee(uint256 amount) external onlyRole(DEFAULT_ADMIN_ROLE) {
        mintFee = amount;
    }

    function _register(
        uint256 tokenId,
        bytes32 deviceId
    ) external onlyRole(REGISTRAR_ROLE) {
        if (!_exists(tokenId)) revert NonexistentM3ter();
        emit Register(tokenId, deviceId, block.timestamp, msg.sender);
        registry[tokenId] = deviceId;
    }

    function _claim(
        uint256 amountIn,
        uint256 amountOutMin,
        uint256 deadline
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        DAI2SLX.claimSLX(amountIn, amountOutMin, deadline);
    }
}
