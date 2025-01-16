// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract ProductRegistry {
    struct Product {
        string name;
        uint price;
        uint stock; // Agregar campo para el stock
    }

    mapping(uint => Product) public products;

    event ProductRegistered(uint indexed id, string name, uint price, uint stock);
    event ProductUpdated(uint indexed id, string name, uint price, uint stock);

    // Función para registrar un producto
    function registerProduct(uint _id, string memory _name, uint _price, uint _stock) public {
        require(products[_id].price == 0, unicode"El producto ya está registrado.");
        
        products[_id] = Product(_name, _price, _stock);
        
        emit ProductRegistered(_id, _name, _price, _stock); // Emitir evento al registrar
    }

    /* Función para actualizar un producto, si se quiere actualizar solo una variable
    se debe ingresar -1 en las variables numericas que no se quiere modificar*/
    function updateProduct(uint _id, string memory _name, int _price, int _stock) public {
        require(products[_id].price != 0, "El producto no existe."); // Verificar que el producto exista

        if (bytes(_name).length > 0) { // Actualizar nombre solo si se proporciona uno
            products[_id].name = _name;
        }
        
        if (_price >= 0) { // Actualizar precio solo si se proporciona uno mayor o igual a 0
            products[_id].price = uint(_price);
        }
        
        if (_stock >= 0) { // Actualizar stock solo si se proporciona uno no negativo
            products[_id].stock = uint(_stock);
        }

        emit ProductUpdated(_id, _name, uint(_price), uint(_stock)); // Emitir evento al actualizar
    }
}
