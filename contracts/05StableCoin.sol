// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract StableCoin is ERC20 {
    constructor(uint256 initialSupply) ERC20("StableCoin", "STC") {
        _mint(msg.sender, initialSupply);
    }

    /*Permite a los titulares de tokens destruir una cantidad específica de sus tokens,
    reduciendo así el suministro total.*/
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }
}
