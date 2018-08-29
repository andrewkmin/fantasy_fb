var Draft = artifacts.require('Draft')

/** expectThrow is a function written by OpenZeppelin to indicate when tests are to fail. */
var expectThrow = require('./expectThrow');

/** These tests are designed to test the basic functionality of my dApp and its smart contract. 
 * I have also included tests to ensure that certain actions will lead to failures (revert()) and will not go through.
 */
contract('Draft', function(accounts) {

    const alice = accounts[0]
    const bob = accounts[1];

    it("buy in tests", async() => {
        const draft = await Draft.deployed()
        var eventEmitted = false
        var event = draft.eventBoughtIn()
        await event.watch((err, res) => {
            eventEmitted = true
        })

        await draft.buyIn({from: alice, value: 100});
        assert.equal(eventEmitted, true, 'adding an item should emit a Bought In event')

        // trying to buy in again should yield an error
        await expectThrow.expectThrow(draft.buyIn({from: alice, value: 100}));

        // balance should be correct
        var balance = await draft.getBalance(alice);
        assert.equal(balance, 10);
    })

    it("multi buy in", async() => {
        const draft = await Draft.deployed()
        await draft.buyIn({from: bob, value: 100});

        // balances should be correct
        var aliceBal = await draft.getBalance(alice);
        assert.equal(aliceBal, 10);

        var bobBal = await draft.getBalance(bob);
        assert.equal(bobBal, 10);
    })

    it("draft player", async() => {
        const draft = await Draft.deployed()

        var eventEmitted = false
        var event = draft.eventDraft()
        await event.watch((err, res) => {
            eventEmitted = true
        })

        var rand = await draft.draftPlayer(0, 4);
        assert.equal(eventEmitted, true, 'drafting should yield event')

        // draft player 0, with a cost of 4 (fantasy balance, not ETH value)
        var outcome = await draft.draftPlayer.call(0, 4);
        var result = outcome.c[0];
        // 10 - 4 - 4 = 2
        assert.equal(result, 2);
        
        var newBalance = await draft.getBalance(alice);
        assert.equal(newBalance, 6);

        var firstOwner = await draft.getOwners();
        assert.equal(firstOwner[0], alice);
    })

    it("manually declare winner", async() => {
        const draft = await Draft.deployed()

        var eventEmitted = false
        var event = draft.eventDeclareWinner()
        await event.watch((err, res) => {
            eventEmitted = true
        })

        await draft.declareWinner(alice);
        assert.equal(eventEmitted, true, 'declare winner should yield event');

        var outcome = await draft.getStatus();
        assert.equal(outcome, false);

        var winner = await draft.getWinner();
        assert.equal(winner, alice);

        // confirm that league is inactive
        await expectThrow.expectThrow(draft.buyIn({from: bob, value: 100}));
    })

    it("test emergency return", async() => {
        const draft = await Draft.deployed()
        await draft.makeActive();
        await draft.emergencyReturn();

        // should not run
        await expectThrow.expectThrow(draft.declareWinner(alice));
    })

    it("test complete kill", async() => {
        const draft = await Draft.deployed()
        await draft.kill();

        // nothing should work
        await expectThrow.expectThrow(draft.buyIn({from: bob, value: 100}));
    })
});
