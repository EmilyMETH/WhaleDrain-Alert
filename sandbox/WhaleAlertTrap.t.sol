// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./WhaleAlertTrap.sol";

contract ERC20Mock {
    mapping(address => uint256) public balances;

    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }

    function setBalance(address account, uint256 amount) external {
        balances[account] = amount;
    }
}

contract WhaleAlertTrapTest is Test {
    WhaleAlertTrap trap;
    ERC20Mock token;
    address whale = address(0xBEEF);

    function setUp() public {
        token = new ERC20Mock();
        token.setBalance(whale, 20_000 ether); // Initial balance
        trap = new WhaleAlertTrap(whale, address(token));
    }

    function testNoWhaleMove() public {
        bytes memory result = trap.collect();
        (uint256 currentBalance, bool whaleMoved) = abi.decode(result, (uint256, bool));
        assertEq(whaleMoved, false);
    }

    function testWhaleMoveDetected() public {
        // Simulate whale sending 11,000 tokens
        token.setBalance(whale, 9_000 ether);
        bytes memory result = trap.collect();
        (uint256 currentBalance, bool whaleMoved) = abi.decode(result, (uint256, bool));
        assertEq(whaleMoved, true);
    }

    function testShouldRespondTrue() public {
        bytes ;
        data[0] = abi.encode(uint256(9000 ether), true);
        (bool shouldRespond, ) = trap.shouldRespond(data);
        assertTrue(shouldRespond);
    }

    function testShouldRespondFalse() public {
        bytes ;
        data[0] = abi.encode(uint256(20_000 ether), false);
        (bool shouldRespond, ) = trap.shouldRespond(data);
        assertFalse(shouldRespond);
    }
}
