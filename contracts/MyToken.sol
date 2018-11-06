pragma solidity ^0.4.20;

contract MyToken {
    /* 3.1 This creates a mapping with all balances */

    /* 3.2 Give your contract a name */

    /* Initializes contract with initial supply tokens to the creator of the contract */
    constructor (uint256 initialSupply) public {
        /* 3.3 Giving the creator all the coins */
    }

    /* Send coins */
    function transfer(address _to, uint256 _value) public {
        require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
        /* 3.4 The transfer method */
    }
}
