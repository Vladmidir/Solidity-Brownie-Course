// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// would have to import the oracle contract address
// Need to add the dependency to the brownie-config.yaml file.
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
//is it ok if I import v0.8 contract alogside v0.6?
import "@chainlink/contracts/src/v0.8/vrf/VRFV2WrapperConsumerBase.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Lottery is Ownable, VRFV2WrapperConsumerBase {
    //QUESTION: What is this payable array all about?
    //ANSWER: It is an array of payable addresses.
    address payable[] public players;
    address payable public recentWinner;
    uint256 public recentRandom;
    uint256 public usdEntryFee;
    AggregatorV3Interface internal ethUsdPriceFeed;
    enum LOTTERY_STATE {
        //enum - user defined type that can be represented with INTs
        OPEN,
        CLOSED,
        CALCULATING_WINNER
    }
    LOTTERY_STATE public lottery_state;
    //arguments for requestRandomness()
    uint16 requestConfimations;
    uint32 callbackGasLimit;
    uint32 numWords;

    //call the VRFV2WrapperConsumerBase (parent) constructor
    constructor(
        address _priceFeedAddress,
        address _vrfWrapper,
        address _linkToken,
        uint16 _requestConfimations,
        uint32 _callbackGasLimit,
        uint32 _numWords
    ) VRFV2WrapperConsumerBase(_linkToken, _vrfWrapper) {
        usdEntryFee = 50;
        ethUsdPriceFeed = AggregatorV3Interface(_priceFeedAddress);
        lottery_state = LOTTERY_STATE.CLOSED; //since repsented by nums, could do lottery_state = 1;
        requestConfimations = _requestConfimations; //minimum = 3
        callbackGasLimit = _callbackGasLimit; //just random. Figure out how to decide on this one!
        numWords = _numWords;
    }

    function enter() public payable {
        require(lottery_state == LOTTERY_STATE.OPEN);
        //50$ minimum
        require(msg.value >= getEntranceFee(), "Not enough ETH");
        players.push(payable(msg.sender)); // cast to payable
        //QUESTION: What is this casting address to payable all about?
        //ANSWER: Looks like we convert a regular address to a payable one.
        //QUESTION: Does that mean we can send money to that address? Or they can send us money?
        //QUESTION: Can I only cast addresses to payable? I doubt I can cans strings and ints.
        //ANSWER: Looks like I can only cast Address to AddressPayable
    }

    function getEntranceFee() public view returns (uint256) {
        //$ price for 1ETH, with 8 decimals
        (, int256 price, , , ) = ethUsdPriceFeed.latestRoundData(); //would have to get these methods directly from the repo or documentation.
        uint256 adjustedPrice = uint256(price);
        //5 000 000 000 000 000 000 / 185 551 851 240
        //BUG: I get zero, because the  quotient < 0
        //FIX: Add 8 extra zeroes to the entry fee.
        uint256 costEnter = uint256(usdEntryFee * 10 ** 17) / adjustedPrice; //DIVIDE by the adjusted price
        //The cost to enter in Gwei
        return costEnter;
    }

    function startLottery() public onlyOwner {
        require(
            lottery_state == LOTTERY_STATE.CLOSED,
            "Can't start a new lottery yet!"
        );
        lottery_state = LOTTERY_STATE.OPEN;
    }

    function endLottery() public onlyOwner {
        //uint256(
        //    keccak256(
        //        abi.encodePacked(
        //            nonce, //predictable
        //            msg.sender, //predictable
        //            block.difficulty, //can be manipulated by the miners
        //            block.timestamp //predictable
        //        )
        //    )
        //) % players.length;
        // ^ bad way of getting a random numeber.
        //#THE PROPER WAY:
        //We will get our random number from the Chainlink oracle.
        //For this we will have to pay some Chainlink gas (LINK token).
        //We did not have to do this for the price oracle, because the 'sponsors' paid the gas fee for us.

        lottery_state = LOTTERY_STATE.CALCULATING_WINNER;
        //Inherited function!
        uint256 requestId = requestRandomness(
            callbackGasLimit,
            requestConfimations,
            numWords
        );
    }

    //Overwriting the callback function of the VRF contract
    //make sure to add the `override` keyword!
    //QUESTION: What happens if I don't add `override`?
    function fulfillRandomWords(
        uint256 _requestId,
        uint256[] memory _randomWords
    ) internal override {
        require(
            lottery_state == LOTTERY_STATE.CALCULATING_WINNER,
            "You aren't there yet!"
        );
        require(_randomWords[_requestId] > 0, "random not found");

        uint256 indexOfWinner = _randomWords[_requestId] % players.length;
        recentWinner = players[indexOfWinner];
        recentWinner.transfer(address(this).balance);
        //Reset
        players = new address payable[](0);
        lottery_state = LOTTERY_STATE.CLOSED;
        recentRandom = _randomWords[_requestId];
    }
}
