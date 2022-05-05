const FixedVotersPoll = artifacts.require('FixedVotersPoll');
const {
    expectEvent,  // Assertions for emitted events
    expectRevert, // Assertions for transactions that should fail
  } = require('@openzeppelin/test-helpers');

contract('FixedVotersPoll', (accounts) => {

    beforeEach(async () => {
        this.instance = await FixedVotersPoll.new('test poll', ['candidate1', 'candidate2'], [accounts[0],accounts[1]], false);
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

    it('msg.sender should not be able to vote if not registed', async () => {
        await expectRevert(
            this.instance.vote(0, { from: accounts[5] }),
            'Invalid vote',
        );
    });

    it('msg.sender should not be able to vote if already voted', async () => {
        await this.instance.vote(0);
        await expectRevert(
            this.instance.vote(0),
            'Invalid vote',
        );
    });

    it('msg.sender should not be able to vote if candidate is not valid', async () => {
        await expectRevert(
            this.instance.vote(2),
            'Invalid candidate',
        );
    });

    it('Candidate should have one more vote after msg.sender voted and an event emitted for public vote', async () => {
        const candidate1 = await this.instance.candidates(1);
        assert.equal(candidate1[2].toNumber(), 0); // 0 votes
        const vote = await this.instance.vote(1);

        expectEvent(vote, 'NewVote', {
            voter: accounts[0],
            candidateId: '1'
        });

        const candidate1AfterVote = await this.instance.candidates(1);
        assert.equal(candidate1AfterVote[2].toNumber(), 1); // 1 vote
    });

    it('Event emitted for secret vote', async () => {
        const vote = await this.instance.vote(1);
        expectEvent(vote, 'NewVote', {
            voter: accounts[0],
            candidateId: '1'
        });
    });

    it('Event emitted for secret vote', async () => {
        this.instance = await FixedVotersPoll.new('test poll', ['candidate1', 'candidate2'], [accounts[0],accounts[1]], true);
        const vote = await this.instance.vote(0);
        expectEvent(vote, 'NewSecretVote', {
            voter: accounts[0]
        });
    });
});
