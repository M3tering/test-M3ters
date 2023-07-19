// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";

import "./XRC721.sol";
import "./IM3ter.sol";

/// @custom:security-contact info@whynotswitch.com
contract M3ter is XRC721, IM3ter {
    bytes32 public constant REGISTRAR_ROLE = keccak256("REGISTRAR_ROLE");

    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter private _tokenIdCounter;

    mapping(uint256 => bytes32) REGISTRY;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        __ERC721_init("M3ter", "M3R");
        __ERC721Enumerable_init();
        __ERC721URIStorage_init();
        __AccessControl_init();
        __UUPSUpgradeable_init();

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(REGISTRAR_ROLE, msg.sender);
        _grantRole(UPGRADER_ROLE, msg.sender);
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://m3ter.whynotswitch.com/";
    }

    function _register(
        uint256 tokenId,
        bytes32 deviceId
    ) public onlyRole(REGISTRAR_ROLE) {
        require(_exists(tokenId), "M3ter: can't register, M3ter doesn't exist");
        emit Register(tokenId, deviceId, block.timestamp, msg.sender);
        REGISTRY[tokenId] = deviceId;
    }

    function safeMint() public payable onlyRole(REGISTRAR_ROLE) {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
    }

    function identify(uint256 tokenId) external view returns (bytes32) {
        require(_exists(tokenId), "M3ter: device doesn't exist");
        return REGISTRY[tokenId];
    }
}
