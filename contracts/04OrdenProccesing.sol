// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./04ProductRegistry.sol";

contract OrderProcessing {
    ProductRegistry registry;

    constructor(address _registryAddress) {
        registry = ProductRegistry(_registryAddress);
    }

    // Función para ordenar productos
    function orderProduct(uint _productId, uint _quantity) public payable {
        // Verificar que el producto existe
        ( , uint price, uint stock) = registry.products(_productId); // Usar _ para omitir el nombre
        require(price != 0, unicode"El producto no está disponible.");

        // Verificar que la cantidad solicitada no exceda el stock disponible
        require(_quantity <= stock, "Cantidad solicitada excede el stock disponible.");

        // Calcular el total a pagar
        uint totalPrice = price * _quantity;

        // Verificar que el pago sea correcto
        require(msg.value == totalPrice, "Pago incorrecto.");

        // Procesar la orden (actualizar stock)
        uint newStock = stock - _quantity; // Calcular nuevo stock

        // Actualizar el producto usando updateProduct
        registry.updateProduct(_productId, "", -1, int(newStock)); // Pasar nombre vacío y precio -1

        // Emitir un evento o realizar acciones adicionales si es necesario
    }
}
