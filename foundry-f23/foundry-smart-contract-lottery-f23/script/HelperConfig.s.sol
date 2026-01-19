// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {LinkToken} from "test/mocks/LinkToken.sol";
// import {VRFCoordinatorV2_5Mock} from "chainlink/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";

import {VRFCoordinatorV2_5Mock} from "chainlink/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";

abstract contract CodeConstants {
    uint256 public constant ETH_SEPOLIA_CHAIN_ID = 11155111;
    uint256 public constant LOCAL_CHAIN_ID = 31337;
    address public constant FOUNDRY_DEFAULT_SENDER =
        0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38;
}

contract HelperConfig is CodeConstants, Script {
    error HelperConfig__InvalidChainId();

    uint96 public constant MOCK_BASE_FEE = 0.25 ether;
    uint96 public constant MOCK_GAS_PRICE_LINK = 1e9;
    int256 public constant MOCK_WEI_PER_UNIT_LINK = 4e15;

    struct NetWorkConfig {
        uint256 entranceFee;
        uint256 interval;
        address vrfCoordinatorV2_5;
        bytes32 gasLane;
        uint256 subscriptionId;
        uint32 callbackGasLimit;
        address link;
        address account;
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
        if (networkConfig[chainId].vrfCoordinatorV2_5 != address(0)) {
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
        if (localNetworkConfig.vrfCoordinatorV2_5 != address(0)) {
            return localNetworkConfig;
        }
        vm.startBroadcast();
        VRFCoordinatorV2_5Mock vrfCoordinatorMock = new VRFCoordinatorV2_5Mock(
            MOCK_BASE_FEE,
            MOCK_GAS_PRICE_LINK,
            MOCK_WEI_PER_UNIT_LINK
        );
        uint256 subscriptionId = vrfCoordinatorMock.createSubscription();
        LinkToken linkToken = new LinkToken();
        vm.stopBroadcast();
        localNetworkConfig = NetWorkConfig({
            entranceFee: 0.01 ether,
            interval: 30,
            vrfCoordinatorV2_5: address(vrfCoordinatorMock),
            gasLane: 0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15,
            callbackGasLimit: 500000,
            subscriptionId: subscriptionId,
            link: address(linkToken),
            account: FOUNDRY_DEFAULT_SENDER
        });
        return localNetworkConfig;
    }

    function getSepoliaEthConfig() public pure returns (NetWorkConfig memory) {
        return
            NetWorkConfig({
                entranceFee: 0.01 ether,
                interval: 30,
                vrfCoordinatorV2_5: 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B,
                gasLane: 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae,
                callbackGasLimit: 2500000,
                subscriptionId: 0,
                link: 0x779877A7B0D9E8603169DdbD7836e478b4624789,
                account: 0x7778D008b49e58a5B952e48a4E17CCC673cBD2A6
            });
    }

    // function getLocalEthConfig() public pure returns (NetWorkConfig memory) {
    //     return
    //         NetWorkConfig({
    //             entranceFee: 0.01 ether,
    //             interval: 30,
    //             vrfCoordinatorV2_5: address(0),
    //             gasLane: "",
    //             callbackGasLimit: 500000,
    //             subscriptionId: 0
    //         });
    // }
}
