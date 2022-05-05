const RealHumanVerifier = artifacts.require('RealHumanVerifier');
const {
    expectRevert, // Assertions for transactions that should fail
  } = require('@openzeppelin/test-helpers');

contract('RealHumanVerifier', (accounts) => {
    beforeEach(async () => {
        this.instance = await RealHumanVerifier.new();
    });

    it('setPOHAddress shouls fail if sender is not the owner', async () => {
        await expectRevert(
            this.instance.setPOHAddress('0xC5E9dDebb09Cd64DfaCab4011A0D5cEDaf7c9BDb', {from: accounts[5]}),
            'Only the owner can change the POH address',
        );
    });
});
