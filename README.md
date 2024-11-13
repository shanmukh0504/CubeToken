# Cube Token (CBT) Smart Contract

## Overview

The **Cube Token (CBT)** is an ERC-20 compliant token deployed on the Ethereum blockchain. This smart contract includes standard ERC-20 functions such as transferring, approving, and allowing token transfers. Additionally, it features a minting and burning mechanism, as well as the ability to pause and unpause the contract. The token is designed to be easily integrated into decentralized applications (dApps), and can be used for a variety of purposes, including swaps and transactions.

This repository provides the Cube Token's Solidity contract and its associated features. 

For more information and to interact with the Cube Token, visit our [official website](https://cubetoken.netlify.app/).

## Token Contract Address

The Cube Token (CBT) contract is deployed at the following address:

- **Contract Address**: [0x98aaF9098b9052Ae49d632d5ce88B14ABe58843A](https://sepolia.etherscan.io/address/0x98aaF9098b9052Ae49d632d5ce88B14ABe58843A)

Use this address to view the token on Etherscan, check transactions, and interact with the contract.

## Features

- **ERC-20 Compliance**: Implements all standard ERC-20 functions, including `transfer`, `approve`, `transferFrom`, and `allowance`.
- **Minting and Burning**: The contract owner can mint new tokens (up to a specified max supply) and users can burn their tokens.
- **Pausing**: The contract owner can pause and unpause token transfers, adding an additional layer of control.
- **Swaps via GardenSDK**: Our [web application](https://cubetoken.netlify.app/) supports swaps between TBTC and WBTC (Testnet) using GardenSDK.

## Key Functions

### 1. `mint(uint tokens)`

The owner of the contract can mint new tokens, up to a maximum supply limit (`maxSupply`).

- **Parameters**: 
  - `tokens` (uint): Number of tokens to mint.
- **Returns**: 
  - `bool`: Returns `true` if minting is successful.

### 2. `burn(uint tokens)`

Users can burn their tokens, reducing the total supply. The amount burned is deducted from the user's balance.

- **Parameters**: 
  - `tokens` (uint): Number of tokens to burn.
- **Returns**: 
  - `bool`: Returns `true` if burning is successful.

### 3. `pause()` and `unpause()`

The contract owner can pause or unpause the contract, temporarily halting token transfers if needed.

- **Access**: Only the contract owner can call this function.

### 4. `transfer(address to, uint tokens)`

Transfers tokens from the caller’s address to another address.

- **Parameters**:
  - `to` (address): The recipient address.
  - `tokens` (uint): The number of tokens to send.
- **Returns**:
  - `bool`: Returns `true` if the transfer is successful.

### 5. `approve(address spender, uint tokens)` & `transferFrom(address from, address to, uint tokens)`

Allows a spender to transfer tokens on behalf of the token owner.

- **Parameters**:
  - `spender` (address): The address allowed to spend tokens on behalf of the owner.
  - `tokens` (uint): The number of tokens to approve for spending.
- **Returns**:
  - `bool`: Returns `true` if the approval is successful.

### 6. `increaseAllowance(address spender, uint256 addValue)` & `decreaseAllowance(address spender, uint256 subValue)`

Allows the owner to increase or decrease the spending allowance of a spender.

### 7. `balanceOf(address tokenOwner)`

Returns the balance of tokens for a given address.

- **Parameters**:
  - `tokenOwner` (address): The address whose balance is being queried.
- **Returns**:
  - `balance` (uint): The balance of the given address.

### 8. `allowance(address tokenOwner, address spender)`

Returns the allowance set for a spender by the token owner.

- **Parameters**:
  - `tokenOwner` (address): The address of the token owner.
  - `spender` (address): The address of the spender.
- **Returns**:
  - `remaining` (uint): The remaining allowance for the spender.

### 9. `pause()` and `unpause()`

These functions are available only to the contract owner, allowing them to pause and resume all token transfers.

### 10. `receive()` (fallback function)

Rejects all incoming ETH transactions with a revert message.

---

## Token Details

- **Symbol**: `CBT`
- **Name**: `Cube Token`
- **Decimals**: `18`
- **Initial Supply**: `5,000,000 CBT`
- **Max Supply**: `10,000,000 CBT`
- **Owner**: Address that deploys the contract.
- **Paused**: Initially set to `false`.

---

## Getting Started

### 1. Deploying the Token

To deploy the Cube Token contract, simply deploy the `CubeToken` contract to an Ethereum testnet or mainnet using Remix IDE or any other Ethereum development tool.

### 2. Interacting with the Contract

You can interact with the Cube Token contract via:

- **Remix IDE**: Use Remix IDE to interact with the contract functions directly.
- **Web3 Libraries**: Use web3.js or ethers.js to interact programmatically with the contract.

### 3. Swapping TBTC for WBTC (Testnet)

Visit our [web application](https://cubetoken.netlify.app/) to swap TBTC for WBTC on the Ethereum testnet using GardenSDK. The process is simple:

- Connect your wallet (MetaMask or any supported wallet).
- Select TBTC as the source token and WBTC as the destination token.
- Enter the amount to swap.
- Confirm the transaction and enjoy your WBTC!

---

## Security Considerations

- **Access Control**: Only the contract owner can mint, burn, and pause/unpause the contract.
- **Token Supply**: Minting is restricted by the `maxSupply`, ensuring the total supply does not exceed the specified cap.
- **Reentrancy Attacks**: This contract is designed to prevent reentrancy attacks by using simple state-changing functions with minimal external calls.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Contact

For support or inquiries, reach out to us at [shanmukh@hashira.io](mailto:shanmukh@hashira.io).

---

Thank you for using Cube Token!
