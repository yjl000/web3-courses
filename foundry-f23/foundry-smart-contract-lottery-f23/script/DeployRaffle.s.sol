// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {VRFCoordinatorV2_5Mock} from "chainlink/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {Raffle} from "../src/Raffle.sol";
import {CreateSubscription, AddConsumer, FundSubscription} from "./Interactions.s.sol";

contract DeployRaffle is Script {
    function run() external returns (Raffle, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig();
        AddConsumer addComsumer = new AddConsumer();
        HelperConfig.NetWorkConfig memory config = helperConfig.getConfig();
        uint256 entranceFee = config.entranceFee;
        uint256 interval = config.interval;
        address vrfCoordinatorV2_5 = config.vrfCoordinatorV2_5;
        bytes32 gasLane = config.gasLane;
        uint256 subscriptionId = config.subscriptionId;
        uint32 callbackGasLimit = config.callbackGasLimit;
        address link = config.link;
        address account = config.account;

        // if (subscriptionId == 0) {
        CreateSubscription createSubscription = new CreateSubscription();
        (subscriptionId, ) = createSubscription.createSubscription(
            vrfCoordinatorV2_5,
            account
        );
        FundSubscription fundSubscription = new FundSubscription();
        fundSubscription.fundSubScription(
            vrfCoordinatorV2_5,
            subscriptionId,
            link
        );
        // }

        vm.startBroadcast();
        Raffle raffle = new Raffle(
            entranceFee,
            interval,
            vrfCoordinatorV2_5,
            gasLane,
            subscriptionId,
            callbackGasLimit
        );
        vm.stopBroadcast();
        addComsumer.addConsumer(
            address(raffle),
            vrfCoordinatorV2_5,
            subscriptionId
        );
        return (raffle, helperConfig);
    }

    function deployContract() internal returns (Raffle, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig();
        HelperConfig.NetWorkConfig memory config = helperConfig.getConfig();
        uint256 entranceFee = config.entranceFee;
        uint256 interval = config.interval;
        address vrfCoordinator = config.vrfCoordinatorV2_5;
        bytes32 gasLane = config.gasLane;
        uint256 subscriptionId = config.subscriptionId;
        uint32 callbackGasLimit = config.callbackGasLimit;
        vm.startBroadcast();
        Raffle raffle = new Raffle(
            entranceFee,
            interval,
            vrfCoordinator,
            gasLane,
            subscriptionId,
            callbackGasLimit
        );
        vm.stopBroadcast();
        return (raffle, helperConfig);
    }
}
