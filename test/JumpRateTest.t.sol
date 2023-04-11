// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;

import { console2 } from "forge-std/console2.sol";
import { TestHelper } from "./utils/TestHelper.sol";

contract JumpRateTest is TestHelper {
  function setUp() external {
    _setUp();
  }

  function testGetBorrowRate() external {
    uint256 borrowed_liquidity = 1e18;
    uint256 total_liquidity = 20e18;

    uint256 borrowRate = lendgine.getBorrowRate(borrowed_liquidity, total_liquidity);
    uint256 expectedRate = 68750000000000000;

    // console2.log("borrowRate: ", borrowRate);
    // console2.log("expectedRate: ", expectedRate);

    assertEq(borrowRate, expectedRate);
  }

  function testGetSupplyRate() external {
    uint256 borrowed_liquidity = 1e18;
    uint256 total_liquidity = 20e18;

    uint256 supplyRate = lendgine.getSupplyRate(borrowed_liquidity, total_liquidity);
    uint256 expectedRate = 3437500000000000;

    // console2.log("supplyRate: ", supplyRate);
    // console2.log("expectedRate: ", expectedRate);

    assertEq(supplyRate, expectedRate);
  }
}
