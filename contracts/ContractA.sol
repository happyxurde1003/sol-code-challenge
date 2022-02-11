// SPDX-License-Identifier: MIT LICENSE

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./ContractB.sol";

contract ContractA is AccessControl {
    bytes32 public constant ownerRole = keccak256("ownerRole");
    address private addressOfContractB = address(0);

    constructor() {
        // Grant the owner role to a deployer of contract
        _setupRole(ownerRole, msg.sender);
    }

    /**
     * @dev set address of ContractB to new one
     */
    function setAddressOfContractB(address addressB) public {
        // Check that the calling account has the owner role
        require(
            hasRole(ownerRole, msg.sender),
            "Caller is not a owner of contract"
        );
        addressOfContractB = addressB;
    }

    /**
     * @dev get address of initialized ContractA
     */
    function getAddressOfContractB() public view returns (address) {
        return addressOfContractB;
    }

    /**
     * @dev checking address is owner of contract
     */
    function isOwner(address owner) public view returns (bool) {
        return hasRole(ownerRole, owner);
    }

    /**
     * @dev deposit ERC20 token from user account to ContractA
     */
    function deposit(address tokenAddress, uint256 tokenAmount) public {
        // Checking if ContractB is initialized and token amount is correct
        require(
            addressOfContractB != address(0),
            "ContractB address is not initialized yet"
        );
        require(tokenAmount > 0, "You need to deposit at least some tokens");
        // Creating instance of ERC20 and ContractB
        ERC20 erc20Token = ERC20(tokenAddress);
        ContractB contractB = ContractB(addressOfContractB);
        //Checking msg.sender token balance is enough
        require(
            erc20Token.balanceOf(msg.sender) > tokenAmount,
            "ERC20: token balance is not enough for depositing"
        );
        //Checking msg.sender token allowance is enough
        uint256 allowance = erc20Token.allowance(msg.sender, address(this));
        require(allowance >= tokenAmount, "Check the ERC20 token allowance");
        //Checking msg.sender is same with initialized ContractA address
        require(
            contractB.getAddressOfContractA() == address(this),
            "ContractB: the sender is not an address of ContractA"
        );
        erc20Token.transferFrom(msg.sender, address(this), tokenAmount);
        contractB.record(msg.sender, tokenAddress, tokenAmount);
    }
}
