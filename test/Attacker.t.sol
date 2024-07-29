// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {NaughtCoin, NaughtCoinSolver } from "../contracts/ethernaut/NaughtCoin.sol";

contract AttackTest is Test {

    address public player;
    uint256 public playerKey;
    NaughtCoin coin;
    NaughtCoinSolver solver;

    function setUp() public {
        (address _player, uint256 _playerKey) = makeAddrAndKey("player");
        player = _player;
        playerKey = _playerKey;

        coin = new NaughtCoin(_player);
        solver = new NaughtCoinSolver();
    }

    function test_Attack() public {
        vm.prank(player);
        coin.approve(address(solver), 1000000 * (10 ** uint256(18)));
        solver.solve(player, address(coin));
        assertEq(0, coin.balanceOf(player));
    }
}
