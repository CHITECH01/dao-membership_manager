# DAO Membership Manager

## Overview

The **DAO Membership Manager** is a Clarity smart contract designed to manage memberships in a Decentralized Autonomous Organization (DAO). It provides functionalities for adding and removing members, setting membership limits, and querying membership status. The contract ensures that membership operations are performed securely and efficiently by enforcing necessary constraints and checks.

## Features

- **Add Members**: Allow authorized administrators to add new members to the DAO.
- **Remove Members**: Enable the removal of members from the DAO.
- **Membership Limits**: Set and enforce a maximum limit on the number of DAO members.
- **Membership Queries**: Check if a user is an active member of the DAO.
- **Error Handling**: Comprehensive error codes to ensure secure and predictable operations.

## Contract Details

### Constants and Error Codes

| Constant                 | Description                              |
|--------------------------|------------------------------------------|
| `CONTRACT_ADMIN`         | Default contract administrator, initialized as the transaction sender during deployment. |
| `ERR_NOT_ADMIN`          | Error code `u200`: Caller is not the admin. |
| `ERR_ALREADY_MEMBER`     | Error code `u201`: User is already a member. |
| `ERR_NOT_MEMBER`         | Error code `u202`: User is not a member. |
| `ERR_MEMBER_LIMIT_REACHED` | Error code `u203`: Member limit has been reached. |
| `ERR_INVALID_USER`       | Error code `u204`: Invalid user provided. |
| `ERR_INVALID_LIMIT`      | Error code `u205`: Invalid membership limit provided. |

### Data Variables

| Variable                | Type    | Default Value | Description                            |
|-------------------------|---------|---------------|----------------------------------------|
| `current-member-count`  | `uint`  | `u0`          | Tracks the current number of DAO members. |
| `max-member-limit`      | `uint`  | `u100`        | Sets the maximum allowable DAO members. |

### Data Structures

| Structure              | Type                | Description                            |
|------------------------|---------------------|----------------------------------------|
| `MEMBERSHIP_REGISTRY`  | `map (principal -> bool)` | Maps principals to their membership status (`true` for member, `false` otherwise). |

## Functions

### Private Utility Functions

#### `is-active-member(user)`
- **Description**: Checks if a user is an active member of the DAO.
- **Input**: 
  - `user` (`principal`): User to be checked.
- **Output**: Returns `true` if the user is a member, `false` otherwise.

#### `add-member(new-member)`
- **Description**: Adds a new member to the DAO after performing validations.
- **Input**:
  - `new-member` (`principal`): Principal to be added as a member.
- **Output**: Returns `true` on successful addition.

#### `remove-member(member)`
- **Description**: Removes a member from the DAO.
- **Input**:
  - `member` (`principal`): Principal to be removed.
- **Output**: Returns `true` on successful removal.

#### `fetch-member-count()`
- **Description**: Retrieves the current count of DAO members.
- **Output**: Returns the number of members as `uint`.

### Public Functions

#### `add-dao-member(new-member)`
- **Description**: Validates input and adds a new member to the DAO.
- **Input**:
  - `new-member` (`principal`): Principal to be added.
- **Validations**:
  - Ensure the input is valid (not `null` or the admin itself).
  - Caller must be the contract admin.
  - Membership limit must not be exceeded.
- **Output**: Returns `true` on successful addition.

## Deployment and Usage

### Prerequisites

- Clarity 2.0-compatible environment (e.g., Stacks blockchain).
- A wallet or address with administrative rights to deploy the contract.

### Deployment

1. Deploy the contract using the Clarity development environment or the Stacks CLI.
2. During deployment, the deploying principal is set as the `CONTRACT_ADMIN`.

### Usage Examples

#### Add a Member
```clarity
;; Adding a new member to the DAO
(add-dao-member 'SP1234567890ABCDEF1234567890ABCDEF12345678)
```

#### Check Membership Status
```clarity
;; Check if a user is an active member
(is-active-member 'SP1234567890ABCDEF1234567890ABCDEF12345678)
```

#### Remove a Member
```clarity
;; Remove a member from the DAO
(remove-member 'SP1234567890ABCDEF1234567890ABCDEF12345678)
```

## Error Handling

The contract provides descriptive error codes to indicate issues during execution:

| Error Code            | Description                              |
|-----------------------|------------------------------------------|
| `ERR_NOT_ADMIN`       | Caller is not the admin.                |
| `ERR_ALREADY_MEMBER`  | User is already a member.               |
| `ERR_NOT_MEMBER`      | User is not a member.                   |
| `ERR_MEMBER_LIMIT_REACHED` | Member limit has been reached.    |
| `ERR_INVALID_USER`    | Invalid user provided.                  |
| `ERR_INVALID_LIMIT`   | Invalid membership limit provided.      |

## Development Notes

- This contract is designed to be simple yet extendable. Additional features like role-based permissions or dynamic member limits can be added as needed.
- Ensure robust testing for edge cases such as the maximum member limit or invalid user inputs.

## License

This contract is open-source and available under the [MIT License](LICENSE).
```

This `README.md` provides a rich overview, making it suitable for developers and stakeholders alike. It is structured, easy to follow, and detailed.