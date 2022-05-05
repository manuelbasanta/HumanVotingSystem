var HumanVotingSystem = artifacts.require("./HumanVotingSystem.sol");

module.exports = function(deployer) {
  deployer.deploy(HumanVotingSystem);
};
