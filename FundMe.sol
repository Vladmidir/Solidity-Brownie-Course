// SPDX-License-Identifier: MIT


pragma solidity >=0.6.6 < 0.9.0;
//Chainlink - modular decentralized oracle network
//import the chainlink interface (ABI - application binary interface). Basic OOP 
//This is an npm pachage (https://www.npmjs.com/package/@chainlink/contracts)
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
//not needed for sol >= 0.8. (Overflow prevention). This a library btw.
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

//Hybrid Smart contract
//People would have to 'fund' our things on the chain
//That is why we need the 'fund' function
contract FundMe {
    //not needed for sol >= 0.8
    using SafeMathChainlink for uint256;
    //keep track of who sent us money.
    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    address public owner;

    //contract constructor
    constructor() public {
        //the sender, in this case, is whoever deploys the contract 
        owner = msg.sender;
    }

    //payable - can send value with the function.
    function fund() public payable {

        uint256 minimumUSD = 50 * 10 ** 8; //minimum sending amount (50$ with 8 decimals)
        //if not met, stop executing (revert the transaction, give the money back).
        require(getConversionRate(msg.value) >= minimumUSD, "Minimum is 50$!"); 

        //mgs.sender - sender of the function call; msg.value - how much they sent
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender); //redundant if someone pushes multiple times. Ignore for now.
    }

    function getVersion() public view returns (uint256){
        //initialize the contract from the interface (paste the ETH to USD contract address)
        //This line says "define a contract with that interface, located at that address".
        //make sure to use the right test network address! (https://docs.chain.link/data-feeds/price-feeds/addresses/#Sepolia%20Testnet)
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
        
    }

    function getPrice() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);

        //tuple destructing. Discard the empty comas
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer); //type casting
        //has eight decimals
        //x, xxx.xxxxxxxx
    }

    //weird function. The decimals confuse me. Think I figured it out now!
    function getConversionRate(uint256 ethAmount) public view returns(uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountUsd = (ethPrice * ethAmount) / 10**8;
        return ethAmountUsd;
        //1892,7980274
    }
 
    //middleware! modifier = middleware. Amazing!
    modifier onlyOwner {
        //only the owner of the contract can withdrawl funds
        require(msg.sender == owner);
        _;
    }

    function withdraw() payable onlyOwner public {
        //transfer is sending to the msg.sender's address; 'this' refers to this contract
        msg.sender.transfer(address(this).balance);
        //basic for loop. Reset everyone's funds to zero.
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex ++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0); //set funders to empty list.

    }
}
