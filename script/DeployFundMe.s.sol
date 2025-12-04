// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {FundMe} from "../src/FunMe.sol";

contract DeployFundMe is Script {
    function run() public returns (FundMe) {
        vm.startBroadcast();
        HelperConfig helperConfig = new HelperConfig();
        address ethUsdPriceFeed = helperConfig.activeNetworkConfig();
        /* 用 address 类型变量接收时，Solidity 会按规则自动取结构体的「第一个字段」——
         而 NetworkConfig 结构体恰好只有一个字段 priceFeed（address），所以最终就拿到了这个地址
         类似javaScript中的解构赋值
         */
        console.log("ethUsdPriceFeed: ", ethUsdPriceFeed);
        // FundMe fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        FundMe fundMe = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}
