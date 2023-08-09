// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./XRC721.sol";
import "./IM3ter.sol";
import "./IMimo.sol";

/// @custom:security-contact info@whynotswitch.com
contract M3ter is XRC721, IM3ter {
    IERC20 public constant DAI = IERC20(0x1CbAd85Aa66Ff3C12dc84C5881886EEB29C1bb9b); // ioDAI
    IMimo public constant MIMO = IMimo(0x147CdAe2BF7e809b9789aD0765899c06B361C5cE); // router
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
        if (!DAI.transferFrom(msg.sender, address(this), mintFee)) revert TransferError();
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
        uint256 amountOutMin,
        uint256 deadline
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        uint256 amountIn = DAI.balanceOf(address(this));
        if (amountIn < 1) revert InputIsZero();
        if (!DAI.approve(address(MIMO), amountIn)) revert Unauthorized();

        MIMO.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            amountIn,
            amountOutMin,
            _swapPath(),
            msg.sender,
            deadline
        );

        emit Claim(msg.sender, amountIn, block.timestamp);
    }

    function _swapPath() internal pure returns (address[] memory) {
        address[] memory path = new address[](2);
        path[0] = address(DAI);
        path[1] = 0x1CbAd85Aa66Ff3C12dc84C5881886EEB29C1bb9b; // TODO: added DePIN token address
        return path;
    }
}
