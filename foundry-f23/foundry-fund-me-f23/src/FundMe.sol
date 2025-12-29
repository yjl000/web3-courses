// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";
// import {MathLibrary} from "./MathLibrary.sol";

error NotOwner();

contract FundMe {
    // send funds into our contract
    uint256 public myValue = 1;
    AggregatorV3Interface private s_priceFeed;

    struct FundInfo {
        uint256 amountFunded;
        uint256 fundNums;
    }
    using PriceConverter for uint256;
    // using MathLibrary for uint256;
    address[] private s_funders;
    mapping(address => FundInfo) private s_addressToFundInfo;
    uint256 public constant MINIMUM_USD = 5 * 10 ** 18;

    // AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);

    address public /* immutable */ i_owner;

    constructor(address priceFeedAddress) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    function fund() public payable {
        myValue = myValue + 1;
        // require(msg.value > 1e18, "didn't send enough ETH");
        require(msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD, "didn't send enough ETH");
        s_addressToFundInfo[msg.sender].amountFunded += msg.value;
        s_addressToFundInfo[msg.sender].fundNums += 1;
        s_funders.push(msg.sender);
    }

    /**
     * Network: Sepolia
     * Data Feed: ETH/USD
     * Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
     */

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(s_priceFeed);
        return priceFeed.version();
    }

    function decimals() external view returns (uint8) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(s_priceFeed);
        return priceFeed.decimals();
    }

    function getLatestPrice() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(s_priceFeed);
        (, int256 answer,,,) = priceFeed.latestRoundData();
        require(answer >= 0, "answer is negative");
        return uint256(answer) * 1e10;
    }

    // function calculateSum(uint256 num1, uint256 num2) public pure returns(uint256) {
    //     return num1.sum(num2);
    // }

    modifier onlyOwner() {
        // require(msg.sender == i_owner, "must be owner");
        if (msg.sender != i_owner) revert NotOwner();
        _;
    }

    // owner can withdraw funds
    function withdraw() public onlyOwner {
        for (uint256 funderIndex = 0; funderIndex < s_funders.length; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_addressToFundInfo[funder].amountFunded = 0;
        }
        s_funders = new address[](0);

        // transfer
        // payable(msg.sender).transfer(address(this).balance);

        // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");

        // call
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    function cheaperWithdraw() public onlyOwner {
      uint256 fundersLength = s_funders.length;
      for (uint256 funderIndex = 0; funderIndex < fundersLength; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_addressToFundInfo[funder].amountFunded = 0;
        }
        s_funders = new address[](0);
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    function getAddressToAmountFunded(address fundingAddress) public view returns (uint256) {
        return s_addressToFundInfo[fundingAddress].amountFunded;
    }

    function getFunder(uint256 index) public view returns (address) {
        return s_funders[index]; 
    }

    function getOwner() public view returns(address) {
      return i_owner;
    }

    function getPriceFeed() public view returns(AggregatorV3Interface) {
      return s_priceFeed;
    }

    // Ether is sent to contract
    //      is msg.data empty?
    //          /   \
    //         yes  no
    //         /     \
    //    receive()?  fallback() // fallback handler msg.data:  emit FallbackCalled(msg.data);
    //     /   \
    //   yes   no
    //  /        \
    //receive()  fallback()

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }
}
