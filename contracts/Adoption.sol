pragma solidity ^ 0.4 .17;

contract Adoption {
    address[24] public adopters;

    // Adopting a pet
    function adopt(uint petId) public returns(uint) {
        require(petId >= 0 && petId <= 23);

        adopters[petId] = msg.sender;

        return petId;
    }

    // Retrieving the adopters
    function getAdopters() public view returns(address[24]) {
        return adopters;
    }
}