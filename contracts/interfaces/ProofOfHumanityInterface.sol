// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// Interface for isRegistered function of ProofOfHumanity
// https://github.com/Proof-Of-Humanity/Proof-Of-Humanity/blob/master/contracts/ProofOfHumanity.sol
interface ProofOfHumanityInterface {
  function isRegistered(address _submissionID) external view returns (bool);
}
