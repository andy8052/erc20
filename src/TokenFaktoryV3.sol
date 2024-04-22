// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./TokenFactory.sol";

contract TokenFactoryV3 is TokenFactory {

    constructor(address _owner) TokenFactory(_owner) {}

    // pool init parameters parameterize in function
    // tick0, tick1, poolAmount, ownerAmount, InitialPricePerEth, recipient
    function _deployWithManualParams(
        string memory _name,
        string memory _symbol,
        int24 tick0,
        int24 tick1,
        uint256 poolAmount,
        uint256 ownerAmount,
        uint256 initialPricePerEth,
        address recipient
    ) internal returns (InstantLiquidityToken, uint256) {

         // get the addresses per-chain
        (address weth, INonfungiblePositionManager nonfungiblePositionManager) = _getAddresses();
        address token;
        {
            Storage memory store = s;
            // deploy and initialize a new token
            token = Clones.cloneDeterministic(
                address(store.instantLiquidityToken),
                keccak256(abi.encode(block.chainid, store.deploymentNonce))
            );
            InstantLiquidityToken(token).initialize({
                _mintTo: address(this),
                _totalSupply: poolAmount + ownerAmount,
                _name: _name,
                _symbol: _symbol
            });
            s.deploymentNonce += 1;
        }

        // sort the tokens and the amounts
        (address token0, address token1) = token < weth ? (token, weth) : (weth, token);


        // approve the non-fungible position mgr for the pool liquidity amount
        InstantLiquidityToken(token).approve({
            spender: address(nonfungiblePositionManager),
            value: poolAmount
        });

        uint160 initialSquareRootPrice;

        bool tokenIsLessThanWeth = token < weth;
        (int24 tickLower, int24 tickUpper) =
            tokenIsLessThanWeth ? (int24(-220400), int24(0)) : (int24(0), int24(220400));
        (uint256 amt0, uint256 amt1) = tokenIsLessThanWeth
            ? (uint256(POOL_AMOUNT), uint256(0))
            : (uint256(0), uint256(POOL_AMOUNT));

        INonfungiblePositionManager.MintParams memory mintParams = INonfungiblePositionManager.MintParams({
            token0: token0,
            token1: token1,
            fee: 10_000, // 1% pool fee (From Constants.sol)
            tickLower: tick0,
            tickUpper: tick1,
            amount0Desired: poolAmount,
            amount0Min: poolAmount - (poolAmount / 1e18),
            amount1Desired: 0,
            amount1Min: 0,
            deadline: block.timestamp,
            recipient: address(this)
        });
        
        // create the pool
        nonfungiblePositionManager.createAndInitializePoolIfNecessary({
            token0: token0,
            token1: token1,
            fee: 10_000, // 1% pool fee (From Constants.sol)
            sqrtPriceX96: initialSquareRootPrice
        });

        // mint the position
        (uint256 lpTokenId,,,) = nonfungiblePositionManager.mint({params:  mintParams });

        // transfer the owner allocation
        InstantLiquidityToken(token).transfer({to: recipient, value: ownerAmount});

        return (InstantLiquidityToken(token), lpTokenId);
    } 
}
