# Frequently Asked Questions

Q: Why is my deployed `Vault` contract not passing the `_isVault()` check in `Oldmancer`?

A: `Vault`'s deployed bytecode must match the version accepted by `Oldmancer`. The way Solidity compiler compiles code into bytecode is dependent on lines in the code (even comments), the compiler version, the optimizer settings, the EVM version, and the source file. 

To compile `Vault` such that it matches the version, compile it with the following settings:

- Do not change any lines in `Vault.sol`.
- Solidity version: 0.8.9+commit.e5eed63a
- EVM version: London
- Optimizer: disabled
- Source name: "./contracts_/Vault.sol"

If you are using Remix IDE to compile and deploy `Vault.sol`, by default, the source name will be "./contracts/Vault.sol" (which is incorrect).