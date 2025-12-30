// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title A sample Raffle Contract * @title 一个示例抽奖合约
 * @author yangjingli
 * @notice This contract is for creating a sample raffle
 * @notice 本合约用于创建一个示例抽奖活动
 * @dev It implements Chainlink VRFv2.5 and Chainlink Automation
 * @dev 它实现了Chainlink VRFv2.5和Chainlink自动化功能
 */

// Layout of the contract file:
// version
// imports
// errors
// interfaces, libraries, contract

// Inside Contract:
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

error Raffle__NotEnoughEthSend();

contract Raffle {
    uint256 private immutable i_entranceFee;

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }

    /** 用external 因为只有外部调用，合约内部步调用此函数 */
    function enterRaffle() external payable {
        if (msg.value < i_entranceFee) revert Raffle__NotEnoughEthSend();
    }

    function pickWinner() public {}

    /** Getter Function */
    function getEntranceFee() public view returns (uint256) {
        return i_entranceFee;
    }
}
