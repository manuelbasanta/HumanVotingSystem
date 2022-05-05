// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

/**
* @dev Base class for all poll types.
*/
abstract contract BasePoll {
    string name; // Name of the poll
    Candidate[] public candidates; // Array of poll candidates
    address public creator; // Creator od the poll
    bool secret; // Wether the vote is secret or not

    struct Candidate {
        uint id;
        string name;
        uint votes;
    }

    event NewSecretVote(address voter); // Event to be fired everytime a new secret vote is made
    event NewVote(address voter, uint candidateId); // Event to be fired everytime a new public vote is made

    // Evaluates if a candidates id is valid
    modifier isCandidate(uint _candidateId) {
        require( _candidateId < candidates.length, 'Invalid candidate');
        _;
    } 

    // Functions to be used every time a vote is made
    function emitVote(uint _candidateId) internal {
        if(secret) {
            emit NewSecretVote(msg.sender);
        } else {
            emit NewVote(msg.sender, _candidateId);
        }
    }

    function vote(uint _candidateId) virtual public;
}