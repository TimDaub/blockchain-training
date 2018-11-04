pragma solidity ^0.4.20;

contract MyToken {
    /* 3.1 This creates an array with all balances */
    mapping (address => uint256) balanceOf;

    /* 3.2 Give your contract a name */
    string name = "MyToken"

    /* Initializes contract with initial supply tokens to the creator of the contract */
    constructor (
        uint256 initialSupply
        ) public {
        /* 3.3 Giving the creator all the coins */
        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
    }

    /* Send coins */
    function transfer(address _to, uint256 _value) {
        require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
        /* 3.4 The transfer method */
        require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
        balanceOf[msg.sender] -= _value;                    // Subtract from the sender
        balanceOf[_to] += _value;                           // Add the same to the recipient
    }
}
