// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Counter2 {

    uint count;
    address owner;

    error notOwner();

    constructor(){
        owner = msg.sender;
    }

    function get() public view returns (uint){
        return count;
    }

    function inc() public{
        require(msg.sender == owner, "Not Owner");
        count += 1; 
    }
    
    function dec() public {
        if (msg.sender != owner){
            revert notOwner();
        }
        count -= 1;
    }
}