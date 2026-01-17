// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
// import {VRFCoordinatorV2_5Mock} from "chainlink/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";

import {VRFCoordinatorV2_5Mock} from "chainlink/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";

abstract contract CodeConstants {
    uint256 public constant ETH_SEPOLIA_CHAIN_ID = 11155111;
    uint256 public constant LOCAL_CHAIN_ID = 31337;
}

contract HelperConfig is CodeConstants, Script {
    error HelperConfig__InvalidChainId();

    uint96 public constant MOCK_BASE_FEE = 0.25 ether;
    uint96 public constant MOCK_GAS_PRICE_LINK = 1e9;
    int256 public constant MOCK_WEI_PER_UNIT_LINK = 4e15;

    struct NetWorkConfig {
        uint256 entranceFee;
        uint256 interval;
        address vrfCoordinator;
        bytes32 gasLane;
        uint64 subscriptionId;
        uint32 callbackGasLimit;
    }

    mapping(uint256 chainId => NetWorkConfig) public networkConfig;
    NetWorkConfig public localNetworkConfig;

    constructor() {
        if (block.chainid == 11155111) {
            localNetworkConfig = getSepoliaEthConfig();
        } else {
            localNetworkConfig = getOrCreateAnvilEthConfig();
        }
        // networkConfig[ETH_SEPOLIA_CHAIN_ID] = getSepoliaEthConfig();
        // localNetworkConfig = getLocalEthConfig();
    }

    function getConfig() public returns (NetWorkConfig memory) {
        return getConfigByChainId(block.chainid);
    }

    function getConfigByChainId(
        uint256 chainId
    ) public returns (NetWorkConfig memory) {
        if (networkConfig[chainId].vrfCoordinator != address(0)) {
            return networkConfig[chainId];
        } else if (chainId == LOCAL_CHAIN_ID) {
            return getOrCreateAnvilEthConfig();
        } else {
            revert HelperConfig__InvalidChainId();
        }
    }

    function getOrCreateAnvilEthConfig()
        public
        returns (NetWorkConfig memory anvilNetworkConfig)
    {
        if (localNetworkConfig.vrfCoordinator != address(0)) {
            return localNetworkConfig;
        }
        vm.startBroadcast();
        VRFCoordinatorV2_5Mock vrfCoordinatorMock = new VRFCoordinatorV2_5Mock(
            MOCK_BASE_FEE,
            MOCK_GAS_PRICE_LINK,
            MOCK_WEI_PER_UNIT_LINK
        );
        vm.stopBroadcast();
        return
            NetWorkConfig({
                entranceFee: 0.01 ether,
                interval: 30,
                vrfCoordinator: address(vrfCoordinatorMock),
                gasLane: 0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15,
                callbackGasLimit: 500000,
                subscriptionId: 0
            });
    }

    function getSepoliaEthConfig() public pure returns (NetWorkConfig memory) {
        return
            NetWorkConfig({
                entranceFee: 0.01 ether,
                interval: 30,
                vrfCoordinator: 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625,
                gasLane: 0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c,
                callbackGasLimit: 500000,
                subscriptionId: 0
            });
    }

    function getLocalEthConfig() public pure returns (NetWorkConfig memory) {
        return
            NetWorkConfig({
                entranceFee: 0.01 ether,
                interval: 30,
                vrfCoordinator: address(0),
                gasLane: "",
                callbackGasLimit: 500000,
                subscriptionId: 0
            });
    }
}
