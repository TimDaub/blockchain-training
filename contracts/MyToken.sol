pragma solidity >=0.4.21 <0.6.0;

contract MyToken {
    /* 3.1 This creates a mapping with all balances */
    // Task: Add mapping

    /* 3.2 Give your contract a name */
    // Task: Add name

    /* Initializes contract with initial supply tokens to the creator of the contract */
    constructor (uint256 initialSupply) public {
        /* 3.3 Giving the creator all the coins */
        // Task: Give the creator all initial tokens
    }

    /* Send coins */
    function transfer(address _to, uint256 _value) public {
        /* 3.4 The transfer method */
        // Task: Check if the sender has enough
        // Task: Subtract from the sender
        // Task: Add the same to the recipient
    }
}
