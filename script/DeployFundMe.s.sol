// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FunMe.sol";

contract DeployFundMe is Script {
    function run() public {
        vm.startBroadcast();
        new FundMe();
        vm.stopBroadcast();
    }
}
