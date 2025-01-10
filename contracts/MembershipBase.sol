// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract MembershipBase {
    uint256 public fee;
    address public owner;

    constructor(uint256 _fee) {
        owner = msg.sender;
        fee = _fee;
    }

    function payFee() public payable {
        require(msg.value == fee, "Please submit the exact fee.");
    }
}
