Generally speaking, my contract is not overly complex -- I don't chain value transfers or call on external functions that might lead to my contract becoming vulnerable. That being said, there were a few specific cases that I'm aware of:

#### Integer overfow/underflow
Integer overflow/underflow is mitigated by my usage of OpenZeppelin's SafeMath library, in which certain mathematical operations will not proceed if the parameters would yield an invalid result.

#### Reentrancy
I've avoided reentrancy by using modifiers to only perform certain operations depending on the state of the contract. In addition, I am careful to change variables in such a fashion that multiple calls will not transfer an incorrectly large amount to a certain party, for example.

#### Last-resort
In the case of an emergency, this contract can be killed.