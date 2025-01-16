// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;
import "./03MembershipBase.sol";

contract PremiumMembership is MembershipBase {
    constructor(uint256 _fee) MembershipBase(_fee) {}

    function accessPremiumContent() public view returns (string memory) {
        require(msg.sender == owner, "Access restricted to Premium Members.");
        return "Premium Content Access Granted";
    }
}
