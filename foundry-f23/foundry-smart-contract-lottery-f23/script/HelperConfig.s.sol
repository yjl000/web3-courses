// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract HelperConfig {
    function getConfig()
        public
        view
        returns (uint256, uint256, address, bytes32, uint64, uint32)
    {
        return (0, 0, address(0), bytes32(0), 0, 0);
    }
}
