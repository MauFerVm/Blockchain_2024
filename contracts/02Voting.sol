// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Voting {
    //Cambie votesReceived a private ya que las variables deben
    //accederse a traves de metodos (Encapsulamiento) y no directamente
    mapping (string => uint256) private votesReceived;
    
    //Pensando en un votación donde la cantidad de tokens que dispongo
    //indica el peso de mi voto agregue una variable que los representaria
    function voteForCandidate(string memory candidate, uint tokens) public {
        votesReceived[candidate] += tokens;
    }

    function totalVotesFor(string memory candidate) public view returns (uint256) {
        return votesReceived[candidate];
    }
}
