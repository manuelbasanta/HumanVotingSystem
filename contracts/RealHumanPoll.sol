// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "./RealHumanVerifier.sol";
import "./abstracts/BasePoll.sol";

contract RealHumanPoll is BasePoll, RealHumanVerifier {
    // A map of valid voters
    mapping (address => Voter) private voters;
    struct Voter {
        bool voted; // Has de voter already voted
        string vote; // Who did the voter vote for
    }

    /**
     * @dev Constructor.
     * @param _name string Name of de Poll
     * @param _candidates string[] Array of candidate names
     * @param _secret bool If the voting is secret or public
     */
    constructor(string memory _name, string[] memory _candidates, bool _secret) {
        name = _name;
        creator = msg.sender;
        secret = _secret;

        for(uint i = 0; i < _candidates.length; i++) {
            candidates.push(Candidate(i, _candidates[i], 0));
        }
    }

    /** 
     * @dev Verifies that the voter is registered in Proof of Humanity, and that
     * he/she has not voted.
     * Adds a vote to candidate, sets the voter as already voted and who
     * he/she voted for.
     * @param _candidateId The id of the candidate to vote for.
     */
    function vote(uint _candidateId) public override isCandidate(_candidateId) {
        Voter storage voter = voters[msg.sender];
        require(!voter.voted && validateAddress());
        voter.voted = true;
        voter.vote = candidates[_candidateId].name;
        candidates[_candidateId].votes++;
        emitVote(_candidateId);
    }
}