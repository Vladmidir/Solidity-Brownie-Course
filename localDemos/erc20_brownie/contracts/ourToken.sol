// contracts/ourToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ourToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("ourToken", "ORT") {
        //NOTE: The initial supply is specified in ETHER
        _mint(msg.sender, initialSupply); //_minst allocates the supply to the sender
    }
}
