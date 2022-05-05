// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "./interfaces/ProofOfHumanityInterface.sol";

contract RealHumanVerifier {
    address POHAddress;
    address private _owner;
    ProofOfHumanityInterface proofOfHumanityContract;

    constructor() {
        // Set POH mainnet contract address as default 
        POHAddress = 0xC5E9dDebb09Cd64DfaCab4011A0D5cEDaf7c9BDb;
        proofOfHumanityContract = ProofOfHumanityInterface(POHAddress);
        _owner = msg.sender;
    }

    /** 
     * @dev Allow the owner to change the address of POH contract. Needed to change
     * beetween mainnet and testnets.
     * Mainnet address: 0xC5E9dDebb09Cd64DfaCab4011A0D5cEDaf7c9BDb
     * Kovan address: 0x73bcce92806bce146102c44c4d9c3b9b9d745794
     * POH Frontend on Kovan: https://app-kovan.poh.dev/
     * @param _newAddress The new address of of POH contract.
     */
    function setPOHAddress(address _newAddress) external {
        require(msg.sender == _owner, 'Only the owner can change the POH address');
        POHAddress = _newAddress;
        proofOfHumanityContract = ProofOfHumanityInterface(POHAddress);
    }

    /** 
     * @dev validates if the contract caller is registered in POH
     * @return bool true if the voter is registered, false if he/she is not.
     */
    function validateAddress() internal view returns (bool) {
        return proofOfHumanityContract.isRegistered(msg.sender);
    }
}
