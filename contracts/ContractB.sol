// SPDX-License-Identifier: MIT LICENSE

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract ContractB is AccessControl {
    bytes32 public constant ownerRole = keccak256("ownerRole");
    //Mapping from account to token balances
    mapping(address => mapping(address => uint256)) private balances;
    address private addressOfContractA = address(0);
    event Deposit(
        address _depositorAddress,
        address _tokenAddress,
        uint256 _tokenAmount
    );

    constructor() {
        // Grant the minter role to a deployer of contract
        _setupRole(ownerRole, msg.sender);
    }

    /**
     * @dev add owner of contract
     */
    function addOwner(address ownerAddress) public {
        _setupRole(ownerRole, ownerAddress);
    }

    /**
     * @dev checking address is owner of contract
     */
    function isOwner(address owner) public view returns (bool) {
        return hasRole(ownerRole, owner);
    }

    /**
     * @dev set address of ContractA to new one
     */
    function setAddressOfContractA(address addressA) public {
        // Check that the calling account has the owner role
        require(
            hasRole(ownerRole, msg.sender),
            "Caller is not a owner of contract"
        );

        addressOfContractA = addressA;
    }

    /**
     * @dev get address of initialized ContractA
     */
    function getAddressOfContractA() public view returns (address) {
        return addressOfContractA;
    }

    /**
     * @dev record new deposit by ContractA
     */
    function record(
        address depositorAddress,
        address tokenAddress,
        uint256 tokenAmount
    ) public {
        require(
            msg.sender == addressOfContractA,
            "ContractB: the sender address is not an address of ContractA"
        );
        require(
            depositorAddress != address(0),
            "ContractB: depositor address cannot be the zero address"
        );
        require(
            tokenAddress != address(0),
            "ContractB: token address cannot be the zero address"
        );

        balances[tokenAddress][depositorAddress] += tokenAmount;
        emit Deposit(depositorAddress, tokenAddress, tokenAmount);
    }

    /**
     * @dev record new deposit by owner
     */
    function manualRecord(
        address depositorAddress,
        address tokenAddress,
        uint256 tokenAmount
    ) public {
        require(
            hasRole(ownerRole, msg.sender),
            "Caller is not a owner of contract"
        );
        require(
            depositorAddress != address(0),
            "ContractB: depositor address cannot be the zero address"
        );
        require(
            tokenAddress != address(0),
            "ContractB: token address cannot be the zero address"
        );

        balances[tokenAddress][depositorAddress] += tokenAmount;
        emit Deposit(depositorAddress, tokenAddress, tokenAmount);
    }

    /**
     * @dev return balance of specified erc20-token of depositor
     */
    function balanceOf(address depositorAddress, address tokenAddress)
        public
        view
        returns (uint256)
    {
        return balances[tokenAddress][depositorAddress];
    }
}
