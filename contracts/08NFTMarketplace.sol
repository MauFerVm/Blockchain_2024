// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract NFTMarketplace {
    IERC20 public paymentToken;

    struct Listing {
        address seller;
        uint256 priceInETH;    // Precio del NFT en ETH
        uint256 priceInToken;   // Precio del NFT en el token ERC20
        uint256 tokenId;
    }

    ERC721 public nft;
    
    mapping(uint256 => Listing) public listings;

    constructor(address nftAddress, address tokenAddress) {
        nft = ERC721(nftAddress);
        paymentToken = IERC20(tokenAddress);
    }

    // Función para listar un NFT en el mercado
    function listNFT(uint256 tokenId, uint256 priceInETH, uint256 priceInToken) public {
        // Verifica que quien lista sea el propietario del NFT
        require(nft.ownerOf(tokenId) == msg.sender, "Not the NFT owner");
        // Verifica que el contrato tenga permiso para transferir el NFT
        require(nft.isApprovedForAll(msg.sender, address(this)), "Marketplace not approved");

        listings[tokenId] = Listing(msg.sender, priceInETH, priceInToken, tokenId);
    }

    // Función para comprar un NFT utilizando ETH
    function buyNFTWithETH(uint256 tokenId) public payable {
        Listing storage listing = listings[tokenId];
        
        require(msg.value >= listing.priceInETH, "Insufficient ETH sent");
        
        nft.transferFrom(listing.seller, msg.sender, tokenId);
        
        payable(listing.seller).transfer(listing.priceInETH);
        
        delete listings[tokenId];

        if (msg.value > listing.priceInETH) {
            payable(msg.sender).transfer(msg.value - listing.priceInETH);
        }
    }

    // Función para comprar un NFT utilizando un token ERC20
    function buyNFTWithToken(uint256 tokenId) public {
        Listing storage listing = listings[tokenId];
        
        require(paymentToken.transferFrom(msg.sender, listing.seller, listing.priceInToken), "Payment failed"); // Verifica que la transferencia del token sea exitosa
        
        nft.transferFrom(listing.seller, msg.sender, tokenId);
        
        delete listings[tokenId];
    }
}
