const HumanVotingSystem = artifacts.require('HumanVotingSystem');
const {
    expectEvent,  // Assertions for emitted events
    expectRevert, // Assertions for transactions that should fail
  } = require('@openzeppelin/test-helpers');

contract('HumanVotingSystem', (accounts) => {

    beforeEach(async () => {
        this.instance = await HumanVotingSystem.new();
    });

    it('getPollsTotal should should be 0 when contract deployed and 1 after a poll is created', async () => {
        assert.equal(await this.instance.getPollsTotal(), 0);
        await this.instance.createFixedVotersPoll('test poll',['candidate1', 'candidate2'], [accounts[0],accounts[1]], false);
        assert.equal(await this.instance.getPollsTotal(), 1);
    });

    it('createFixedVotersPoll should fail if no candidates are provided', async () => {
        await expectRevert(
            this.instance.createFixedVotersPoll('test poll',[], [accounts[0],accounts[1]], false),
            'There should be more than 1 candidate',
        );
    });

    it('createFixedVotersPoll should fail if 1 candidate is provided', async () => {
        await expectRevert(
            this.instance.createFixedVotersPoll('test poll',['candidate1'], [accounts[0],accounts[1]], false),
            'There should be more than 1 candidate',
          );
    });

    it('createFixedVotersPoll should fail if no votes are provided', async () => {
        await expectRevert(
            this.instance.createFixedVotersPoll('test poll',['candidate1', 'candidate2'],[], false),
            'There should be more than 1 voter',
          );
    });

    it('createFixedVotersPoll should fail if 1 voter is provided', async () => {
        await expectRevert(
            this.instance.createFixedVotersPoll('test poll',['candidate1', 'candidate2'],[accounts[0]], false),
            'There should be more than 1 voter',
          );
    });

    it('createFixedVotersPoll should create poll and emit event if params are OK', async () => {
        assert.equal(await this.instance.getPollsTotal(), 0);
        const createdPoll = await this.instance.createFixedVotersPoll('test poll',['candidate1', 'candidate2'], [accounts[0],accounts[1]], false);
        expectEvent(createdPoll, 'NewPollCreated', {
            name: 'test poll',
            candidates: ['candidate1', 'candidate2'],
            creator: accounts[0],
            id: await this.instance.polls(0)
        });
        assert.equal(await this.instance.getPollsTotal(), 1);
    });

    it('createHumansPoll should fail if no candidates are provided', async () => {
        await expectRevert(
            this.instance.createHumansPoll('test poll',[], false),
            'There should be more than 1 candidate',
          );
    });

    it('createHumansPoll should fail if 1 candidate is provided', async () => {
        await expectRevert(
            this.instance.createHumansPoll('test poll',['candidate1'], false),
            'There should be more than 1 candidate',
          );
    });

    it('createHumansPoll should create poll and emit event if params are OK', async () => {
        const createdPoll = await this.instance.createHumansPoll('test poll',['candidate1', 'candidate2'], false);
        expectEvent(createdPoll, 'NewPollCreated', {
            name: 'test poll',
            candidates: ['candidate1', 'candidate2'],
            creator: accounts[0],
            id: await this.instance.polls(0)
        });
        assert.equal(await this.instance.getPollsTotal(), 1);
    });
});
