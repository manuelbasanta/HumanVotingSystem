// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "./abstracts/BasePoll.sol";

contract FixedVotersPoll is BasePoll {
    // A map of valid voters
    mapping (address => Voter) private voters;
    struct Voter {
        bool voted; // Has de voter already voted
        string vote; // Who did the voter vote for
        bool isValue; // value used to determine whether the voter was explicitly added to voters pool
    }

    /**
     * @dev Constructor.
     * @param _name string Name of de Poll
     * @param _candidates string[] Array of candidate names
     * @param _voters address[] Array of valid voters addresses
     * @param _secret bool If the voting is secret or public
     */
    constructor(string memory _name, string[] memory _candidates, address[] memory _voters, bool _secret) {
        name = _name;
        creator = msg.sender;
        secret = _secret;

        for(uint i = 0; i < _candidates.length; i++) {
            candidates.push(Candidate(i, _candidates[i], 0));
        }

        for(uint i = 0; i < _voters.length; i++) {
            voters[_voters[i]] = Voter(false, '', true);
        }
    }

    /** 
     * @dev Verifies that the voter is registered as voter, has not voted
     * and is voting for a valid candidate.
     * Adds a vote to candidate, sets the voter as already voted and who
     * he/she voted for.
     * @param _candidateId The id of the candidate to vote for.
     */
    function vote(uint _candidateId) public override isCandidate(_candidateId) {
        Voter storage voter = voters[msg.sender];
        require(voter.isValue && !voter.voted, 'Invalid vote');
        voter.voted = true;
        voter.vote = candidates[_candidateId].name;
        candidates[_candidateId].votes++;
        emitVote(_candidateId);
    }
}