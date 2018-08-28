// owner/commisioner gets special permissions on the web interface
// Draft
// trade
// release
// consider multisig later

pragma solidity ^0.4.0;

contract Draft {
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
    
    // add events
    // add modifiers
    
    modifier verifyCommissioner(address _account) {
        require(_account == owner, "Not authorized");
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
    
    // Retrieving the owners
    function getOwners() public view returns(address[24]) {
        return owners;
    }
    
    function getBalances(address _account) public view returns(uint) {
        return balances[_account];
    }
    
    // Draft a player
    function draft(uint playerId, uint cost) public returns(uint) {
        require(playerId >= 0 && playerId <= 23, "Invalid player selected.");

        owners[playerId] = msg.sender;

        // make this safe
        balances[msg.sender] -= cost;

        return playerId;
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