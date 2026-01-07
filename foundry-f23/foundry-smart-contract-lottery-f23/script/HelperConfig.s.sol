// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

abstract contract CodeConstants {
    uint256 public constant ETH_SEPOLIA_CHAIN_ID = 11155111;
    uint256 public constant LOCAL_CHAIN_ID = 31337;
}

contract HelperConfig is CodeConstants{
    error HelperConfig__InvalidChainId();

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
        networkConfig[ETH_SEPOLIA_CHAIN_ID] = getSepoliaEthConfig();
        localNetworkConfig = getLocalEthConfig();
    }

    function getConfigByChainId(uint256 chainId) public view returns(NetWorkConfig memory) {
        if (networkConfig[chainId].vrfCoordinator != address(0)) {
            return networkConfig[chainId];
        } else if (chainId == LOCAL_CHAIN_ID) {
            return getOrCreateAnvilEthConfig();
        } else {
            revert HelperConfig__InvalidChainId();
        }
    }

    function getOrCreateAnvilEthConfig() public returns(NetWorkConfig momery) {
        if (localNetworkConfig.vrfCoordinator != address(0)) {
            return localNetworkConfig
        }
    }

    function getSepoliaEthConfig() public pure returns(NetWorkConfig memory) {
        return NetWorkConfig({
            entranceFee: 0.01 ether,
            interval: 30,
            vrfCoordinator: 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625,
            gasLane: 0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c,
            callbackGasLimit: 500000,
            subscriptionId: 0
        })
    }
    function getLocalEthConfig() public pure returns(NetWorkConfig memory) {
        return NetWorkConfig({
            entranceFee: 0.01 ether,
            interval: 30,
            vrfCoordinator: address(0),
            gasLane: '',
            callbackGasLimit: 500000,
            subscriptionId: 0
        })
    }
}
