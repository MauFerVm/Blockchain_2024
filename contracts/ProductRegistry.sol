// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract ProductRegistry {
    struct Product {
        string name;
        uint256 price;
    }
    mapping(uint256 => Product) private products;

    function registerProduct(uint256 _id, string memory _name, uint256 _price) public {
        // Verifica si ya existe un producto con el mismo id para no sobreescribirlo
        if (bytes(products[_id].name).length != 0) {
            revert("Ya existe un producto con esa ID");
        }

        products[_id] = Product(_name, _price);
    }

    // Le agregue a products el modificador private y genere un get para respetar el encapsulamiento
    function getProduct(uint256 _id) public view returns (string memory, uint256) {
        Product memory product = products[_id];
        return (product.name, product.price);
    }
}
