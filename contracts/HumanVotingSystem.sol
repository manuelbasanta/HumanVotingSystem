/**
 *  @author: manuel basanta
 */
// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import './interfaces/ProofOfHumanityInterface.sol';
import './RealHumanPoll.sol';
import './FixedVotersPoll.sol';
import "./abstracts/BasePoll.sol";

// KOVAN ADDRESS: 0x43Cb27E38a6Ec276c2e9b283a055dfC60501e6B2

/**
 *  @title HumanVotingSystem
 *  This contract is used to generate polls. Polls can either be open to any real human
 *  that is registered in Proof of humanity or to any address that is pre-registered
 *  by the creator of the poll. The new polls are contracts themselves and their addresses
 *  are stored in the polls array.
 */
contract HumanVotingSystem {
    address private _owner;
    BasePoll[] public polls; // List of all created polls addresses

    // Event to be fired everytime a new poll is created
    event NewPollCreated(string name, string[] candidates, address creator, BasePoll id);

    constructor() {
        _owner = msg.sender;
    }

    // Validates if more than one candiidate is added to poll 
    modifier validCandidates(string[] memory _candidates) {
        require(_candidates.length > 1, 'There should be more than 1 candidate');
        _;
    }

    /**
     * @dev Getter for the total amount of polls.
     */
    function getPollsTotal() public view returns(uint){
        return polls.length;
    }

    /**
     * @dev Creates a poll in which all voters have to be registered in POH.
     * Anyone registered should be able to vote.
     * Emits an event with poll information
     * @param _name string Name of de Poll
     * @param _candidates string[] Array of candidate names
     * @param _secret bool If the voting is secret or public
    */
    function createHumansPoll(string memory _name, string[] memory _candidates, bool _secret) public validCandidates(_candidates) {
        polls.push(new RealHumanPoll(_name, _candidates, _secret));
        emit NewPollCreated(_name, _candidates, msg.sender, polls[polls.length - 1]);
    }

    /**
     * @dev Creates a poll with a set of provided voters.
     * Anyone outside of the voters set will not be able to vote.
     * Emits an event with poll information
     * @param _name string Name of de Poll
     * @param _candidates string[] Array of candidate names
     * @param _voters address[] Array of posible voters
     * @param _secret bool If the voting is secret or public
    */
    function createFixedVotersPoll(string memory _name, string[] memory _candidates, address[] memory _voters, bool _secret) public validCandidates(_candidates) {
        require(_voters.length > 1, 'There should be more than 1 voter');
        polls.push(new FixedVotersPoll(_name, _candidates, _voters, _secret));
        emit NewPollCreated(_name, _candidates, msg.sender, polls[polls.length - 1]);
    }
}
