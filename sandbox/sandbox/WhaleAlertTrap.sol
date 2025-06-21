// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ITrap} from "drosera-contracts/interfaces/ITrap.sol";

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract WhaleAlertTrap is ITrap {
    address public targetWallet;
    IERC20 public token;
    uint256 public lastBalance;
    uint256 public whaleThreshold = 10_000 * 1e18;

    constructor(address _wallet, address _token) {
        targetWallet = _wallet;
        token = IERC20(_token);
        lastBalance = token.balanceOf(_wallet);
    }

    function collect() external view override returns (bytes memory) {
        uint256 currentBalance = token.balanceOf(targetWallet);
        uint256 diff = lastBalance > currentBalance
            ? lastBalance - currentBalance
            : currentBalance - lastBalance;
        bool whaleMoved = diff >= whaleThreshold;
        return abi.encode(currentBalance, whaleMoved);
    }

    function shouldRespond(bytes[] calldata data) external pure override returns (bool, bytes memory) {
        (, bool whaleMoved) = abi.decode(data[0], (uint256, bool));
        return (whaleMoved, "");
    }
}
