// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;

import { console2 } from "forge-std/console2.sol";
import { TestHelper } from "./utils/TestHelper.sol";

contract PairTest is TestHelper {
  function setUp() external {
    _setUp();
  }

  function testInvariant() external {
    assertEq(lendgine.invariant(0, 0, 0), true);
    assertEq(lendgine.invariant(1 ether, 0, 0), false);
    assertEq(lendgine.invariant(1 ether, 1 ether, 0), false);
    assertEq(lendgine.invariant(1 ether, 1 ether, 1e18), false);
    assertEq(lendgine.invariant(124.999999 ether, 0, 5 ether), false);
    assertEq(lendgine.invariant(125 ether, 0, 5 ether), true);
    assertEq(lendgine.invariant(125 ether, 10 ether, 5 ether), true);
    
    vm.expectRevert();
    lendgine.invariant(125 ether, 100 ether, 5 ether);

  }
}
