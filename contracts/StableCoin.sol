// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract MyNFT is ERC721, ERC721URIStorage {
    uint public nextTokenId;
    address public admin;

    event Minted(address indexed to, uint indexed tokenId, string uri, string rarity);
    event Burned(uint indexed tokenId);

    // Posibles rarezas
    string[] public rarities = [
        unicode"Común", 
        unicode"No Común", 
        unicode"Raro", 
        unicode"Épico", 
        unicode"Legendario"
    ];
    
    // Probabilidades acumulativas para cada rareza
    uint[] public rarityProbabilities = [45, 70, 85, 95, 100];

    // Mapeo para almacenar la rareza de cada token
    mapping(uint256 => string) public tokenRarities;

    constructor() ERC721('MyNFT', 'MNFT') {
        admin = msg.sender;
    }

    // Función para acuñar nuevos tokens NFT con rareza aleatoria
    function mint(address to, string memory uri) external {
        require(msg.sender == admin, "only admin");
        
        _safeMint(to, nextTokenId);
        _setTokenURI(nextTokenId, uri);
        
        // Seleccionar una rareza aleatoria
        string memory rarity = selectRandomRarity();
        
        // Almacenar la rareza en el mapeo
        tokenRarities[nextTokenId] = rarity;
        
        emit Minted(to, nextTokenId, uri, rarity);
        
        nextTokenId++;
    }

    // Función interna para seleccionar una rareza aleatoria basada en probabilidades
    function selectRandomRarity() internal view returns (string memory) {
        uint256 randomNumber = (uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao))) % 100) + 1;

        for (uint i = 0; i < rarityProbabilities.length; i++) {
            if (randomNumber <= rarityProbabilities[i]) {
                return rarities[i];
            }
        }

        return unicode"Común"; 
    }

    // Nueva función para obtener la rareza de un NFT
    function getRarity(uint256 tokenId) external view returns (string memory) {
        return tokenRarities[tokenId];
    }

    function burn(uint256 tokenId) external {
        require(msg.sender == ownerOf(tokenId) || getApproved(tokenId) == msg.sender || isApprovedForAll(ownerOf(tokenId), msg.sender), "Caller is not owner nor approved");
        emit Burned(tokenId);
        _burn(tokenId);
        
        // Opcional: Eliminar la rareza al quemar el token
        delete tokenRarities[tokenId];
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function tokenURI(uint tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }
}
