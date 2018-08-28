/** 
* FUTURE PLANS: 
* owner/commisioner gets special permissions on the web interface
* Draft, trade, release, add, multisig (later)
*/

pragma solidity ^0.4.22;

// use OpenZeppelin's SafeMath library to prevent over/underflow on Integer operations
import "./SafeMath.sol";

/** @title owned contract. */
contract owned {
    constructor() public { owner = msg.sender; }
    address owner;
}

/** @title mortal contract. */
contract mortal is owned {
    /** @dev Emergency stop/kill method */
    function kill() public {
        if (msg.sender == owner) selfdestruct(owner);
    }
}

contract Draft is owned, mortal{

    // array matching owners to players
    address[24] public owners;
    
    uint public individualDeposit;
    uint public totalPot;
    
    // commisioner
    address public owner;
    
    // league winner
    address public winner;
    
    // is the league active?
    bool public active;
    
    // can users claim funds?
    bool public claimable;
    
    // mapping of all participants (true or false)
    mapping(address => bool) participants;
    
    // figure out how much each owner can pay; separate from pot
    // unclear if this needs to be in contract
    mapping(address => uint) public balances;
    
    constructor() public {
        owner = msg.sender;
        individualDeposit = 5;
        active = true;
        claimable = false;
    }
    
    // events
    event eventBoughtIn(address _account);
    event eventDeclareWinner(address _account);
    event eventDraft(uint playerId);


    // modifiers
    modifier verifyCommissioner(address _account) {
        require(_account == owner, "Not authorized");
        _;
    }

    modifier verifyInactive() {
        require(active == false, "League active");
        _;
    }
    
    modifier verifyActive() {
        require(active == true, "League inactive");
        _;
    }
    
    modifier preventDuplicate(address _account) {
        require(participants[_account] != true, "Already bought in");
        _;
    }
    
    modifier boughtIn(address _account) {
        require(participants[_account] == true, "Have not bought in");
        _;
    }

    /** @dev Returns the current league status.
      * @return active The boolean representing whether the league is active or not.
      */
    function getStatus() public view returns (bool) {
        return active;
    }
    
    /** @dev Retrieves the owners of fantasy players
      * @return owners The array of owners, with indices representing IDs of fantasy players.
      */
    function getOwners() public view returns(address[24]) {
        return owners;
    }

    /** @dev Retrieves the winner of the league
      * @return winner Self-explanatory.
      */
    function getWinner() public view returns(address) {
        return winner;
    }
    
    /** @dev Returns the balance of a given address
      * @param _account an address
      * @return bal A uint representing an address' balance.
      */
    function getBalance(address _account) 
        public 
        view 
        boughtIn(_account)
        returns(uint) 
    {
        uint bal = balances[_account];
        return bal;
    }
    
    /** @dev Draft a specific player and deduct their cost. Emits draft event.
      * @param playerId A uint representing the ID of the player (specified in players.json file located in src folder)
      * @param cost A uint representing how much it "costs" to draft this player
      * @return newBalance A uint representing the updated balance of the owner of this freshly drafted player.
      */
    function draftPlayer(uint playerId, uint cost) 
        public 
        boughtIn(msg.sender)
        verifyActive()
        returns(uint) 
    {
        require(playerId >= 0 && playerId <= 23, "Invalid player selected.");
        emit eventDraft(playerId);
        owners[playerId] = msg.sender;

        uint newBalance = SafeMath.sub(balances[msg.sender], cost);
        balances[msg.sender] = newBalance;
        return newBalance;
    }
    
    /** @dev Allows users to buy into the league. Handles potential for a user to buy in multiple times. Default balance allocation
      * is 10. Emits boughtIn event.
      */
    function buyIn() 
        public
        payable 
        preventDuplicate(msg.sender)
        verifyActive()
    {
        // return change; refer to old contracts/modifiers
        require(msg.value >= individualDeposit, "Insufficient funds"); 
        emit eventBoughtIn(msg.sender);
        uint newBalance = SafeMath.add(totalPot, individualDeposit);
        totalPot = newBalance;
        participants[msg.sender] = true;
        balances[msg.sender] = 10;
    }
    
    /** @dev Declare winner and pay him/her. Emit declareWinner event.
      * @param _account The account of the winner.
      */
    function declareWinner(address _account) 
        public
        verifyCommissioner(msg.sender)
        verifyActive()
    {
        emit eventDeclareWinner(_account);
        active = false;
        winner = _account;
        winner.transfer(totalPot);
        totalPot = 0;
    }
    
    /** @dev Return funds (aka buy-in) to users in case of emergency. TO-DO: loop through and return funds.
      */
    function emergencyReturn() 
        public
        verifyCommissioner(msg.sender)
        verifyActive()
    {
        active = false; // ensures method can't be called multi times
        claimable = true;
    }
    
    /** @dev Allows users to withdraw funds. TO-DO: rethink this function; possibly require multisig to enable this.
      */
    function withdrawFunds()
        public
    {
        require(claimable == true, "Cannot withdraw");
        uint newAmount = SafeMath.sub(totalPot, individualDeposit);
        totalPot = newAmount;
        msg.sender.transfer(individualDeposit);
    }
}