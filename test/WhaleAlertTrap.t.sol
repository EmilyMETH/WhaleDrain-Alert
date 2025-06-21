// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../sandbox/WhaleAlertTrap.sol";
import "./MockERC20.sol"; 

contract WhaleAlertTrapTest is Test {
    WhaleAlertTrap trap;
    MockERC20 token;
    address wallet = address(0x123); 

    function setUp() public {
        token = new MockERC20("MockToken", "MTK");
        trap = new WhaleAlertTrap(wallet, address(token));
    }

    function testCollect() public view {
        (bytes memory data) = trap.collect();
        (uint256 balance, bool whaleMoved) = abi.decode(data, (uint256, bool));
        assertEq(balance, 0, "Initial balance should be 0");
        assertFalse(whaleMoved, "Whale should not have moved");
    }
}
