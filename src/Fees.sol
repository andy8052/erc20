// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.20;

import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Fees is Ownable {

    address public constant WETH9 = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    constructor(address _owner) Ownable(_owner) {}

    function withdrawETH() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function withdrawWETH(uint256 amount) external onlyOwner {
        IERC20(WETH9).transfer(owner(), amount);
    }

    function burnERC20(address token, uint256 amount) external onlyOwner {
        IERC20(token).transfer(address(0x0), amount);
    }
}