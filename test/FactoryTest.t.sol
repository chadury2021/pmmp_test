// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;

import { Factory } from "../src/core/Factory.sol";
import { Lendgine } from "../src/core/Lendgine.sol";
import { Test } from "forge-std/Test.sol";

import { LendgineAddress } from "../src/periphery/libraries/LendgineAddress.sol";

contract FactoryTest is Test {
  event LendgineCreated(
    address indexed token0,
    address indexed token1,
    uint256 token0Scale,
    uint256 token1Scale,
    uint256 indexed upperBound,
    address lendgine
  );

  Factory public factory;

  function setUp() external {
    factory = new Factory();
  }

  /// @notice Test that the factory holds the lendgine after creation and you can get it
  function testGetLendgine() external {
    address lendgine = factory.createLendgine(address(1), address(2), 18, 18, 1e18);

    assertEq(lendgine, factory.getLendgine(address(1), address(2), 18, 18, 1e18));
  }

  /// @notice Tests if factory computes the correct address for the lendgine
  function testDeployAddress() external {
    address lendgineEstimate = LendgineAddress.computeAddress(address(factory), address(1), address(2), 18, 18, 1e18);

    address lendgine = factory.createLendgine(address(1), address(2), 18, 18, 1e18);

    assertEq(lendgine, lendgineEstimate);
  }

  /// @notice Tests if factory forbids using the same token for pair in Lendgine
  function testSameTokenError() external {
    vm.expectRevert(Factory.SameTokenError.selector);
    factory.createLendgine(address(1), address(1), 18, 18, 1e18);
  }

  /// @notice Tests if factory forbids using zero address for tokens
  function testZeroAddressError() external {
    vm.expectRevert(Factory.ZeroAddressError.selector);
    factory.createLendgine(address(0), address(1), 18, 18, 1e18);

    vm.expectRevert(Factory.ZeroAddressError.selector);
    factory.createLendgine(address(1), address(0), 18, 18, 1e18);
  }

  /// @notice Tests if factory forbids creating the lendgine with the same parameters more than once
  function testDeployedError() external {
    factory.createLendgine(address(1), address(2), 18, 18, 1e18);

    vm.expectRevert(Factory.DeployedError.selector);
    factory.createLendgine(address(1), address(2), 18, 18, 1e18);
  }

  /// @notice Helper function to check if parameters are zeroed after lendgine creation
  function helpParametersZero() private {
    (address token0, address token1, uint256 token0Scale, uint256 token1Scale, uint256 upperBound) =
      factory.parameters();

    assertEq(address(0), token0);
    assertEq(address(0), token1);
    assertEq(0, token0Scale);
    assertEq(0, token1Scale);
    assertEq(0, upperBound);
  }

  /// @notice Tests if factory parameters are zeroed before and after lendgine creation
  function testParameters() external {
    helpParametersZero();

    factory.createLendgine(address(1), address(2), 18, 18, 1e18);

    helpParametersZero();
  }

  /// @notice Tests if factory emits the correct event
  function testFactoryEmit() external {
    address lendgineEstimate = LendgineAddress.computeAddress(address(factory), address(1), address(2), 18, 18, 1e18);

    // set up the expect emit
    vm.expectEmit(true, true, true, true, address(factory));
    emit LendgineCreated(address(1), address(2), 18, 18, 1e18, lendgineEstimate);
    
    // create the lendgine to check if the event was emitted
    factory.createLendgine(address(1), address(2), 18, 18, 1e18);
  }
}
