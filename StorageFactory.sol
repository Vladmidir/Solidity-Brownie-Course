// SPDX-License-Identifier: MIT

//Contract that deploys another contract
//Must be in the same folder with SimpleStorage
pragma solidity >=0.6.0 <0.9.0;

//import the function definitions from a different contract
import "./SimpleStorage.sol";

//'is' - inheritance. StorageFactory is now a child of SimpleStorage
contract StorageFactory is SimpleStorage {
    //Array of SimpleStorage contracts.
    SimpleStorage[] public simpleStorageArray;

    //QUESTION: Does this contain the storage addresses or the whole objects?
    //ANSWER: Looks like it contains storage addresses
    //QUESTION: What happends when I don't call address() on the array object?
    //ANSWER: My best guess is that calling address() returns a reference to the object (smart contract) at that address.
    //Research this question further

    //generate a contract using another contract
    function createSimpleStorageContract() public {
        //create a SimpleStorage contract instance (this should append a block to the blockchain)
        //QUESTION: Does this acctually append a block to the blockchain? YES
        //QUESTION: If it does append a block to the blockchain, is it a permanent change? YES
        //QUESTION: Where excatly is this being stored? Every node of the blockchain? YES
        /*Theoreticall this transaction (creating a contract) would use gas, thus limiting the number of 
        the contracts we can create to the amount of gas we have.*/
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
    }

    function sfStore(
        uint256 _simpleStorageIndex,
        uint256 _simpleStorageNumber
    ) public {
        //When interacting with a contract we need to things:
        //1. Adress of the contract (in the array)
        //2. The ABI (Application Binary Interface. We get it from the import)
        SimpleStorage simpleStorage = SimpleStorage(
            address(simpleStorageArray[_simpleStorageIndex])
        );
        simpleStorage.store(_simpleStorageNumber);
    }

    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {
        //dont really need to save it in a variable, but still do for clean code.
        SimpleStorage simpleStorage = SimpleStorage(
            address(simpleStorageArray[_simpleStorageIndex])
        );
        return simpleStorage.retrieve();
    }
}
