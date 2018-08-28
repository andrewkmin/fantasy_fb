// owner/commisioner gets special permissions on the web interface
// Draft
// trade
// release
// consider multisig later

pragma solidity ^0.4.22;

// use OpenZeppelin's SafeMath library to prevent over/underflow on Integer operations
import "./SafeMath.sol";

contract owned {
    constructor() public { owner = msg.sender; }
    address owner;
}

// Emergency stop/kill method
contract mortal is owned {
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

    function getStatus() public view returns (bool) {
        return active;
    }
    
    // Retrieving the owners
    function getOwners() public view returns(address[24]) {
        return owners;
    }

    // get winner
    function getWinner() public view returns(address) {
        return winner;
    }
    
    function getBalance(address _account) 
        public 
        view 
        boughtIn(_account)
        returns(uint) 
    {
        uint bal = balances[_account];
        return bal;
    }
    
    // Draft a player
    function draftPlayer(uint playerId, uint cost) 
        public 
        returns(uint) 
    {
        require(playerId >= 0 && playerId <= 23, "Invalid player selected.");

        emit eventDraft(playerId);

        owners[playerId] = msg.sender;

        // make this safe
        // balances[msg.sender] -= cost;

        uint newBalance = SafeMath.sub(balances[msg.sender], cost);

        balances[msg.sender] = newBalance;

        return newBalance;
    }
    
    // deposit funds 
    function buyIn() 
        public
        payable 
        preventDuplicate(msg.sender)
        verifyActive()
    {
        // return change; refer to old contracts/modifiers
        require(msg.value >= individualDeposit, "Insufficient funds"); 
        emit eventBoughtIn(msg.sender);
        totalPot += individualDeposit;
        participants[msg.sender] = true;
        balances[msg.sender] = 10;
    }

    // declare winner and pay him/her
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
    
    // return funds in case of emergency
    function emergencyReturn() 
        public
        verifyCommissioner(msg.sender)
        verifyActive()
    {
        active = false; // ensures method can't be called multi times
        claimable = true;
    }
    
    function withdrawFunds()
        public
    {
        require(claimable == true, "Cannot withdraw");
        totalPot -= individualDeposit;
        uint val = balances[msg.sender];
        balances[msg.sender] = 0;
        msg.sender.transfer(val);
    }
}