// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Counter {
    uint count;

    //cuesta GAS solo si se interactua con un contrato que modifica el estado de la Blockchain
    function get() public view returns(uint) {
        return count;
    }

    function inc() public {
        count += 1;
    }

    function dec() public {
        count -= 1;
    }
}