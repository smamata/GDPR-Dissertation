// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title ConsentMinimalEvent
/// @notice Minimal on-chain storage; uses events as the primary log for operations.
contract ConsentMinimalEvent {
    // single bitset for consent to minimize storage: mapping(address => uint256) not needed; keep mapping for clarity
    mapping(address => bool) private consentBit;

    event Consent(address indexed user, bool consented);
    event Access(address indexed user);
    event Deletion(address indexed user);

    function setConsent(bool consented) external {
        consentBit[msg.sender] = consented;
        emit Consent(msg.sender, consented);
    }

    function emitAccess() external {
        emit Access(msg.sender);
    }

    function emitDeletion() external {
        emit Deletion(msg.sender);
    }

    function hasConsented(address user) external view returns (bool) {
        return consentBit[user];
    }
}



