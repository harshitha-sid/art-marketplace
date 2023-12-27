// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ArtMarketplace is ERC1155, Ownable {
    uint256 public constant PAINTING_TYPE = 1;
    uint256 public constant GIFT_CARD_TYPE = 2;

    uint256 public constant INITIAL_PAINTING_SUPPLY = 10;
    uint256 public constant INITIAL_GIFT_CARD_SUPPLY = 100 * (10**18);

    uint256 public constant PAINTING_PRICE = 10 * (10**18);

    event PaintingPurchased(address indexed buyer, uint256 amountPaid, uint256 paintingsPurchased, uint256 changeInEth);

    constructor() ERC1155("My Token") Ownable(msg.sender) {

        // Mint initial supply of paintings
        _mint(owner(), PAINTING_TYPE, INITIAL_PAINTING_SUPPLY, "");
        // Mint initial supply of ERC-20 tokens
        _mint(owner(), GIFT_CARD_TYPE, INITIAL_GIFT_CARD_SUPPLY, "");
    }

    function purchasePainting() external payable {
        uint256 amountPaid = msg.value;
        require(amountPaid > 0, "Invalid payment amount");

        // Calculate the number of paintings to transfer
        uint256 paintingsToTransfer = amountPaid / PAINTING_PRICE;

        // Ensure there are enough paintings in the supply
        require(balanceOf(owner(), PAINTING_TYPE) >= paintingsToTransfer, "Not enough paintings available");

        uint256[] memory paintings = new uint256[](1);
        paintings[0] = paintingsToTransfer;

        uint256[] memory painting_type = new uint256[](1);
        painting_type[0] = PAINTING_TYPE;

        // Transfer paintings to the buyer
        _safeBatchTransferFrom(owner(), msg.sender, painting_type, paintings, "");

        // Calculate change in ETH
        uint256 changeInEth = amountPaid - (paintingsToTransfer * PAINTING_PRICE);

        // If there's any change, transfer it back to the buyer using ERC-20
        if (changeInEth > 0) {
            // Assuming 1 ETH = 1 ERC-20 for simplicity
            require(balanceOf(owner(), GIFT_CARD_TYPE) >= changeInEth, "Not enough gift cards available");
            _safeTransferFrom(owner(), msg.sender, GIFT_CARD_TYPE, changeInEth, "");
        }

        // Emit event
        emit PaintingPurchased(msg.sender, amountPaid, paintingsToTransfer, changeInEth);

        // Transfer the Ether directly to the owner
        payable(owner()).transfer(amountPaid);
    }

    function getOwnerTokens(address _owner) external view returns (uint256, uint256) {
        return (balanceOf(_owner, PAINTING_TYPE), balanceOf(_owner, GIFT_CARD_TYPE));
    }
}
