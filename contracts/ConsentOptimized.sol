// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title ConsentOptimized
/// @notice Uses packed storage and batch operations to reduce gas.
contract ConsentOptimized {
    struct UserState {
        // slot 0
        bool consent; // 1 byte
        uint8 reserved; // padding for future flags
        uint32 accessCount; // 4 bytes
        uint32 deletionCount; // 4 bytes
        // remaining space in slot; solidity will pack into minimal slots
    }

    mapping(address => UserState) internal userState;

    event ConsentUpdated(address indexed user, bool consented);
    event AccessBatch(address indexed caller, uint256 usersProcessed);
    event DeletionBatch(address indexed caller, uint256 usersProcessed);

    function setConsent(bool consented) external {
        UserState storage s = userState[msg.sender];
        s.consent = consented;
        emit ConsentUpdated(msg.sender, consented);
    }

    function batchRecordAccess(address[] calldata users) external {
        uint256 len = users.length;
        for (uint256 i = 0; i < len; i++) {
            UserState storage s = userState[users[i]];
            unchecked {
                s.accessCount += 1;
            }
        }
        emit AccessBatch(msg.sender, len);
    }

    function batchRecordDeletion(address[] calldata users) external {
        uint256 len = users.length;
        for (uint256 i = 0; i < len; i++) {
            UserState storage s = userState[users[i]];
            unchecked {
                s.deletionCount += 1;
            }
        }
        emit DeletionBatch(msg.sender, len);
    }

    function getUserState(address user) external view returns (bool consent, uint32 accessCount, uint32 deletionCount) {
        UserState storage s = userState[user];
        return (s.consent, s.accessCount, s.deletionCount);
    }
}



