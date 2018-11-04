pragma solidity ^0.4.20;

contract MyToken {
    /* 3.1 This creates an array with all balances */

    /* Initializes contract with initial supply tokens to the creator of the contract */
    constructor (uint256 initialSupply) {
        /* 3.2 Giving the creator all the coins */
    }

    /* Send coins */
    function transfer(address _to, uint256 _value) {
        require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
        /* 3.3 The transfer method */
    }
}
