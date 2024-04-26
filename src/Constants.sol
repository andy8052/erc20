// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// 1% pool fee
uint24 constant POOL_FEE = 10_000;

// pool gets 1 billion tokens
// inital price ~ ~.000001 usd (given an eth price of 4k)
// average ftv: $200,000 usd after pool initialization
uint256 constant POOL_AMOUNT = 1_000_000_000 ether;
uint256 constant OWNER_ALLOCATION = 0 ether;

bytes32 constant LIQUIDITY_TOKEN_SALT = keccak256("INSTANT_LIQUIDITY_TOKEN_V3");
bytes32 constant TOKEN_FACTORY_SALT = keccak256("TOKEN_FACTORY_V3");
bytes32 constant TOKEN_FACTORYV2_SALT = keccak256("TOKEN_FACTORY_AIRDROP_VARIANT");
