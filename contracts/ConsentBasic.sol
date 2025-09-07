// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title ConsentBasic
/// @notice Baseline GDPR helper contract with straightforward storage. Designed for benchmarking gas usage.
contract ConsentBasic {
    mapping(address => bool) public hasConsented;
    mapping(address => uint256) public accessRequestCount;
    mapping(address => uint256) public deletionRequestCount;

    event ConsentUpdated(address indexed user, bool consented);
    event AccessRequested(address indexed user, uint256 totalRequests);
    event DeletionRequested(address indexed user, uint256 totalRequests);

    function giveConsent() external {
        hasConsented[msg.sender] = true;
        emit ConsentUpdated(msg.sender, true);
    }

    function revokeConsent() external {
        hasConsented[msg.sender] = false;
        emit ConsentUpdated(msg.sender, false);
    }

    function requestDataAccess() external {
        accessRequestCount[msg.sender] += 1;
        emit AccessRequested(msg.sender, accessRequestCount[msg.sender]);
    }

    function requestDeletion() external {
        deletionRequestCount[msg.sender] += 1;
        emit DeletionRequested(msg.sender, deletionRequestCount[msg.sender]);
    }
}



