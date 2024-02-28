// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

uint256 constant POOL_AMOUNT = 10_000_000_000 ether;
uint256 constant OWNER_ALLOCATION = 1_000_000_000 ether;

bytes32 constant LIQUIDITY_TOKEN_SALT = keccak256("INSTANT_LIQUIDITY_TOKEN");
bytes32 constant TOKEN_DEPLOYER_SALT = keccak256("METAL_DEPLOYER");