// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
//This is an npm pachage (https://www.npmjs.com/package/@chainlink/contracts)
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

//Hybrid Smart contract
//People would have to 'fund' our things on the chain
//That is why we need the 'fund' function
contract FundMe {
    //keep track of who sent us money.
    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    //deployer of the contract
    address public owner;
    AggregatorV3Interface public priceFeed;

    constructor(address _priceFeed) public {
        owner = msg.sender;
        priceFeed = AggregatorV3Interface(_priceFeed);
    }

    /**
     * Entrance fee in ETH (wei)
     */
    function getEntranceFee() public view returns (uint256) {
        uint256 minimum_usd = 50 * 10 ** 26; //26 decimals divided by 8 decimals = 18 decimals
        // xusd = usd/eth
        uint256 price = getPrice();
        uint256 wei_fee = minimum_usd / price;
        return wei_fee;
    }

    //payable - can send value with the function.
    function fund() public payable {
        uint256 minimumUSD = 50 * 10 ** 8; //minimum sending amount (50$ with 8 decimals)
        require(getConversionRate(msg.value) >= minimumUSD, "Minimum is 50$!");

        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender); //redundant if someone pushes multiple times. Ignore for now.
    }

    function getVersion() public view returns (uint256) {
        return priceFeed.version();
    }

    /**
     * Dollars per eth (8 decimals)
     */
    function getPrice() public view returns (uint256) {
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        return uint256(answer);
    }

    function getConversionRate(
        uint256 ethAmount
    ) public view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountUsd = (ethPrice * ethAmount) / 10 ** 8;
        return ethAmountUsd;
        //1892,7980274
    }

    //middleware! modifier = middleware. Amazing!
    modifier onlyOwner() {
        //only the owner of the contract can withdrawl funds
        require(msg.sender == owner);
        _; // <= is specifies when the function that is modified should be executed (think callback).
    }

    function withdraw() public payable onlyOwner {
        //the owner can withdraw all the money
        address payable valid_reciever = payable(msg.sender);
        valid_reciever.call{value: address(this).balance}("");
        //reset everyone's funds to zero
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0); //set funders to empty list.
    }
}
