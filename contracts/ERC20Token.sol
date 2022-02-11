// SPDX-License-Identifier: MIT LICENSE

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20Token is ERC20 {
    constructor() ERC20("ERC20Token", "TEST") {
        _mint(msg.sender, 1200 * (10**decimals()));
    }
}
