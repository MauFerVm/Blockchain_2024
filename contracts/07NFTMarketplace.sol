// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTMarketplace {
    struct Listing {
        address seller;
        uint256 price;
        uint256 tokenId;
    }
    ERC721 public nft;
    mapping(uint256 => Listing) public listings;

    constructor(address nftAddress) {
        nft = ERC721(nftAddress);
    }

    /* Función modificada para que funcione estando solo aprobado el token 
    que se quiere listar o todos, tambien revisa que el token no este ya listado*/
    function listNFT(uint256 tokenId, uint256 price) public {
        require(nft.ownerOf(tokenId) == msg.sender, "not owner");

        // Verifica si el NFT específico está aprobado o si todos están aprobados
        require(
            nft.getApproved(tokenId) == address(this) ||
                nft.isApprovedForAll(msg.sender, address(this)),
            "nft not approved for sale"
        );

        require(listings[tokenId].seller == address(0), "nft already listed");

        listings[tokenId] = Listing(msg.sender, price, tokenId);
    }

    /*[NO FUNCIONA] Función para listar todos los NFT en caso de que sean muchos
    y no se quiera listar 1 por 1, siempre me devuelve "not owner" a pesar de que solo
    es una llamada multiple a listNFT*/
    function listAllNFTs(uint256[] memory tokenIds, uint256 price) public {
        uint256 failedCount = 0;
        string[] memory failureReasons = new string[](tokenIds.length);

        for (uint256 i = 0; i < tokenIds.length; i++) {
            uint256 tokenId = tokenIds[i];

            // Intenta listar cada NFT
            try this.listNFT(tokenId, price) {
                // Si tiene éxito
            } catch Error(string memory reason) {
                // Captura el motivo del fallo
                failureReasons[failedCount] = reason;
                failedCount++;
            }
        }

        emit ListingAttemptCompleted(failureReasons, failedCount);
    }

    // Evento para registrar los motivos de fallos en los intentos de listado
    event ListingAttemptCompleted(string[] failureReasons, uint256 failedCount);

    event BuyNFTAttempt(
        address buyer,
        uint256 tokenId,
        uint256 sentValue,
        uint256 expectedPrice
    );

    function buyNFT(uint256 tokenId) public payable {
        Listing storage listing = listings[tokenId];
        require(msg.value == listing.price, "incorrect price");
        nft.transferFrom(listing.seller, msg.sender, tokenId);
        payable(listing.seller).transfer(msg.value);
        delete listings[tokenId];
    }
}
