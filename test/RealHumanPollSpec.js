const RealHumanPoll = artifacts.require('RealHumanPoll');
const {
    expectRevert, // Assertions for transactions that should fail
  } = require('@openzeppelin/test-helpers');

contract('RealHumanPoll', (accounts) => {

    // TODO: Test interactioin with POH contract
    beforeEach(async () => {
        this.instance = await RealHumanPoll.new('test poll', ['candidate1', 'candidate2'], false);
    });

    it('New instance should have candidates', async () => {
        const candidate1 = await this.instance.candidates(0);
        const candidate2 = await this.instance.candidates(1);

        assert.equal(candidate1[0].toNumber(), 0);
        assert.equal(candidate1[1], 'candidate1');
        assert.equal(candidate1[2].toNumber(), 0);

        assert.equal(candidate2[0].toNumber(), 1);
        assert.equal(candidate2[1], 'candidate2');
        assert.equal(candidate2[2].toNumber(), 0);
    });

    it('msg.sender should not be able to vote if candidate is not valid', async () => {
        await expectRevert(
            this.instance.vote(2),
            'Invalid candidate',
        );
    });
});
