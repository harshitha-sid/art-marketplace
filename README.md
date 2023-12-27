# Art Marketplace using ERC-1155 Tokenization.

### Fall 2023: Work Submitted for CSE700 Independent Study (Credits: 2)
##### Submitted by: Harshitha Siddaramaiah (hsiddara), 
##### UB Person Number: 50483838
##### Date: 26-Dec-2023

## Description

The "ArtMarketplace" smart contract is an implementation of ERC-1155, representing two types of assets: paintings and gift cards. This standard allows for the efficient creation of tokens that can represent represent multiple fungible and non-fungible tokens within a single contract. ERC-1155 is particularly useful for managing multiple types of assets efficiently and economically. The contract includes ownership functionalities and is built upon the OpenZeppelin library. In this example, paintings are to be treated as NFTs or ERC-721 tokens and gift card as Fungible Tokens or ERC-20 tokens. 

Users can purchase paintings by sending Ether to the `purchasePainting` function, and any change is returned in the form of gift cards. For example, if the purchaser pays 35 ETH and the painting price is 10 ETH, 3 such paintings have to be sold to the user and deduct 35 ETH from the purchaser account and credit it to the owner account. The remaining 5 ETH change will be transferred to the purchaser via 5 ETH gift card (ERC-20 tokens), assuming 1 ETH = 1 ERC-20 for simplicity. 


### Key Components:

1. **Token Types:**
   - The contract defines two types of tokens: PAINTING_TYPE (for representing paintings) and GIFT_CARD_TYPE (for representing gift cards). These types are identified by unique numeric constants (1 and 2, respectively).
     
   **Paintings (PAINTING_TYPE):** This token type represents non-fungible assets, specifically paintings. Each painting is uniquely identified by its token ID within the contract.

   **Gift Cards (GIFT_CARD_TYPE):** This token type represents fungible assets, namely gift cards. These tokens are identical and interchangeable.

3. **Initial Supplies:**
   - Upon deployment, the contract mints an initial supply of paintings (INITIAL_PAINTING_SUPPLY) and gift cards (INITIAL_GIFT_CARD_SUPPLY). These initial supplies are allocated to the owner of the contract.

4. **Pricing:**
   - The cost of purchasing a painting is defined by the PAINTING_PRICE, set at 10 Ether (10^18 Wei) per painting.

### Ownership:

The contract incorporates the Ownable contract from the OpenZeppelin library, providing a basic ownership structure. The deployer of the contract (the account that deploys the contract to the Ethereum blockchain) is initially set as the owner. Ownership can be useful for implementing administrative functions, upgrades, or access control.

### Events:

The contract emits an event named "PaintingPurchased" each time a user successfully purchases a painting. This event includes details such as the buyer's address, the amount paid in Ether, the number of paintings purchased, and any change in Ether returned.

### Constructor:

The constructor function is executed only once during the deployment of the contract. It initializes the ERC-1155 token with the name "ArtMarketplace" and mints the initial supplies of paintings and gift cards to the owner.

### Purchase Function:

The `purchasePainting` function allows users to buy paintings by sending Ether to the contract. It calculates the number of paintings to transfer based on the amount paid and the painting price. After ensuring there are enough paintings available, it transfers the paintings to the buyer using the `_safeBatchTransferFrom` function. Any change in Ether is returned to the buyer in the form of gift cards (assuming a simple 1:1 exchange rate between Ether and gift cards).

### Token Balance Retrieval:

The `getOwnerTokens` function allows external parties to query the token balances of a specific address. It returns the number of paintings and gift cards owned by the specified address.


## Batch Transfer

The contract supports batch transfers of paintings using the `_safeBatchTransferFrom` function. This enables efficient and secure transfers of multiple tokens in a single transaction from one address to another, enhancing efficiency and reducing gas costs compared to individual transfers.

Certainly! Let's delve deeper into the batch transfer functionality provided by the `_safeBatchTransferFrom` function in the "MyToken" smart contract.

The function signature is as follows:

```solidity
function _safeBatchTransferFrom(
    address _from,
    address _to,
    uint256[] memory _ids,
    uint256[] memory _amounts,
    bytes memory _data
) internal virtual
```

#### Parameters:

- `_from`: The address from which the tokens are transferred.
- `_to`: The address to which the tokens are transferred.
- `_ids`: An array of token IDs to be transferred.
- `_amounts`: An array specifying the quantity of each corresponding token ID to be transferred.
- `_data`: Additional data that can be passed to the receiving contract. It is typically used for extra information or customization.

#### Function Purpose:

This function is designed to transfer multiple tokens in a single transaction, enhancing the efficiency and reducing gas costs compared to executing individual transfers. It is particularly useful in scenarios where a user wishes to acquire a batch of different tokens simultaneously.

#### Usage in the Contract:

In the "ArtMarketplace" contract, this function is specifically used in the `purchasePainting` method to transfer paintings from the owner to the buyer. Here's how it is utilized in the contract:

```solidity
// Transfer paintings to the buyer
_safeBatchTransferFrom(owner(), msg.sender, painting_type, paintings, "");
```

In this line, the paintings (represented by their token IDs and quantities) are transferred from the contract owner (deployer) to the buyer's address using the `_safeBatchTransferFrom` function.

#### Key Points:

1. **Efficiency:** Batch transfers improve efficiency by consolidating multiple token transfers into a single transaction, reducing gas costs compared to executing each transfer individually.

2. **Atomicity:** The batch transfer is atomic, meaning that either all transfers within the batch succeed, or none of them do. This ensures a consistent state in case of any issues during the transfer process.

3. **Security:** The `_safeBatchTransferFrom` function is a safer alternative to `_batchTransferFrom` because it checks whether the recipient is a smart contract and calls the `onERC1155BatchReceived` function if it exists. This helps prevent accidental token loss and ensures compatibility with recipient contracts.

In summary, the `_safeBatchTransferFrom` function is a crucial component in the "ArtMarketplace" contract, providing an efficient and secure way to transfer batches of ERC-1155 tokens from one address to another. It is particularly beneficial in scenarios where multiple token transfers need to be executed within a single transaction.

## How to Execute

### Owner Account

1. Deploy the contract, specifying the initial supplies of paintings and gift cards.
2. Access the contract functions for managing tokens and viewing balances using `getOwnerTokens` function.

### Purchaser Account

1. Execute the `purchasePainting` function by sending Ether to acquire paintings.
2. Query token balances using the `getOwnerTokens` function.

### Steps:
1. As owner account, deploy the smart contract.
2. Check the initial supplies of paintings and gift cards for the owner account. By default, it should be 10 paintings and 100 ETHs respectively.
3. Now, change to the purchaser account by selecting another account in the drop down.
4. Enter the value of the ETH that is payable to the `purchasePainting` method. In this example, 35 ETH will be deducted from the purchaser account.
5. Verify that the purchaser account should have 3 paintings transferred and 5 ETH credited as gift card.
6. Verify that the owner account is credited with 35 ETH and that the purchaser account is deducted by 35 ETH.
7. Verify that the owner account has only 7 paintings and 95 ETH worth gift cards.

## Errors Encountered and Solutions
- **Transact to MyERC1155Token.purchasePainting errored: Error occured: revert.**
  - Error: The called function should be payable if you send value and the value you send should be less than your current balance.
  - Solution: Make sure that the ETH value in the code are multiplied by (10 ^ 18).
    
- **Invalid Payment Amount:**
  - Error: Payment amount is zero.
  - Solution: Ensure that the payment amount sent with the transaction is greater than zero.

- **Not Enough Paintings Available:**
  - Error: Insufficient paintings in the owner's supply.
  - Solution: Mint additional paintings or reduce the purchase amount.

- **Not Enough Gift Cards Available:**
  - Error: Insufficient gift cards in the owner's supply.
  - Solution: Mint additional gift cards or adjust the change amount.

## Future Work/Extensibility

1. **Enhanced Token Types:** Extend the contract to support additional token types with unique properties.
2. **Dynamic Pricing:** Implement dynamic pricing based on supply and demand.
3. **User Profiles:** Introduce user profiles and ownership tracking.

## Code

>[!NOTE]
>The smart contract code is available in the /src/contracts/ArtMarketplace.sol file same as shown below:
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC1155, Ownable {
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
```

## Summary

The "ArtMarketplace" contract leverages ERC-1155 to represent paintings and gift cards, enabling users to purchase paintings with Ether. Batch transfer functionality enhances efficiency, and the contract is extensible for future enhancements. This contract provides a foundation for a digital asset marketplace.

In conclusion, the "ArtMarketplace" smart contract is a basic ERC-1155 implementation that introduces a digital representation of paintings and gift cards on the Ethereum blockchain. It leverages the features of ERC-1155 for efficiency and flexibility, and its ownership structure allows for secure management. The contract's purpose extends to potential use cases in the digital asset space.

---
