//Store data on the blockchain

// SPDX-License-Identifier: MIT
// QUESTION: What is this license? Does it matter which one I use?
// ANSWER: Probably use MIT (anyone can use)

//QUESTION: How to deploy these things?
//ANSWER: Need a test wallet. Watch how to set it up here: https://youtu.be/5dcRMHUhA20?t=2039

//ALL THIS CODE GETS COMPILED TO EVM  (Ethereum virtual machine)

//solidity version
pragma solidity >=0.6.0 < 0.9.0;


//define a contract (similar to class)
contract SimpleStorage {
    //VARIABLES
    //uint - unisgned
    //int - signed 
    //uint256 - integer of 256 bits (unsigned, int256 for signed)
    //bool - true or false
    //string - regular string of text
    //address - some type of ethereum adress  (0x9D47bDbb7E556fF317E88CB7d0066a5e2985Dd01)
    //bytes32 - variable of 32 bytes (any variable)

    //just save the number. Blank initialize to null value (in this case it is zero).
    uint256 public favouriteNumber;

    //struct defines new data types
    struct Person {
        uint256 favouriteNumber;
        string name;
    }
    //object declaration
    //People public person = People({favouriteNumber: 2, name: "John"});

    //array declaration (dynamic array (mutable size)). Immutable is People[1]. Limited to 1 person
    Person[] public people;
    //mapping - dictionary. Map string to int
    mapping(string => uint256) public nameToFavNumber;

    //function that sets the favouriteNumber propery. It is really a property? YES
    //EVERY TIME WE MAKE A STATE CHANGE ON THE BLOCKCHAIN, WE HAVE TO PAY GAS
    //EVERY YOU CALL A FUNCTION OR A STATE CHANGE, YOU ARE MAKING A TRANSACTION 
    function store(uint256 _favoriteNumber) public {
        favouriteNumber = _favoriteNumber;
    }

    //view defines read only
    //pure defines math only functions (no state change)
    function retrieve() public view returns(uint256) {
        return favouriteNumber;
    }

    //In solidity there are 2 ways to store objects
    //Either in 'memory' or in 'storage'
    //Memory is only during the execution of the function. When creating a 'Person' we make a new copy of the string.
    //QUESTION: Strings are passed by value, but are objects passed by reference? 
    //Storage keeps the variable (I guess it is used for objects passed by reference).
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        //append to the array
        //shorthand constructor (by index)
        people.push(Person(_favoriteNumber,_name));
        //add the mapping (dict)
        nameToFavNumber[_name] = _favoriteNumber;

    }

    //external variable type: can not can be called inside the contract
    //internal variable type: called by other functions inside the contract (or derived contract)
    //private is only visible to the contract defined in (not derived)
    //default is 'internal'

}
