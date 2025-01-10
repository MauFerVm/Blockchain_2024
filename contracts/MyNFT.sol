// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// Importar las bibliotecas de OpenZeppelin para ERC721 y almacenamiento de URI
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

// Definición del contrato MyNFT que hereda de ERC721 y ERC721URIStorage
contract MyNFT is ERC721, ERC721URIStorage {
    // Variable para rastrear el siguiente ID de token a acuñar
    uint public nextTokenId;
    // Dirección del administrador del contrato
    address public admin;

    // Eventos para registrar acciones importantes en la blockchain
    event Minted(address indexed to, uint indexed tokenId, string uri);
    event Burned(uint indexed tokenId);

    // Constructor que inicializa el contrato con un nombre y símbolo
    constructor() ERC721('MyNFT', 'MNFT') {
        // Establecer al administrador como la dirección que despliega el contrato
        admin = msg.sender;
    }

    // Función para acuñar nuevos tokens NFT
    function mint(address to, string memory uri) external {
        // Solo el administrador puede acuñar nuevos tokens
        require(msg.sender == admin, "only admin");
        
        // Acuñar el nuevo token de forma segura y asignar el ID actual
        _safeMint(to, nextTokenId);
        
        // Establecer el URI asociado al token acuñado
        _setTokenURI(nextTokenId, uri);
        
        // Emitir un evento para registrar la acuñación del NFT
        emit Minted(to, nextTokenId, uri);
        
        // Incrementar el ID del siguiente token a acuñar
        nextTokenId++;
    }

    // Función para quemar (eliminar) un token NFT existente
    function burn(uint256 tokenId) external {
        // Verificar que el llamador sea el propietario del token o un operador aprobado
        require(msg.sender == ownerOf(tokenId) || getApproved(tokenId) == msg.sender || isApprovedForAll(ownerOf(tokenId), msg.sender), "Caller is not owner nor approved");

        // Emitir un evento antes de quemar el token
        emit Burned(tokenId);
        
        // Llamar a la función _burn para destruir el token
        _burn(tokenId);
    }

    // Función para verificar si el contrato soporta una interfaz específica
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    // Función para obtener el URI de los metadatos de un token específico
    function tokenURI(uint tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }
}

