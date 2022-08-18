# Frequently Asked Questions

Q: Why is my hash function in javascript not matching the hash function in Solidity? 

For example, the two code snippets yield different results.
```javascript
// In Javacript
ethers.utils.keccak256("0xdeadbeefdeadbeefdeadbeef");
```

```
// In Solidity
keccak256(0xdeadbeefdeadbeefdeadbeef);
```

A: In `ethers.js`, bytes are represented as strings. To properly hash them as hex bytes, and not as strings, we can use `arrayify()` to properly convert them into an array of bytes first.

```javascript
// In Javacript
ethers.utils.keccak256(
    ethers.utils.arrayify("0xdeadbeefdeadbeefdeadbeef")
);
```
___

Q: Why is `ethers.Signer.signMessage()` not behaving as expected?

A: `ethers.Signer.signMessage(message)` does the following:

1. Takes in an **array of bytes** (not a hexstring) as an input.
2. Prepend `"\x19Ethereum Signed Message:\n32"` to the input
3. Hash the prepended message using `keccak256`
4. Use ECDSA secp256k1 to sign the hash.

___

Q: Why is OpenZepppelin's `bytes32.toEthSignedMessageHash()` not behaving as expected?

A: `toEthSignedSignedMessageHash()` does the following:

1. Prepend `"\x19Ethereum Signed Message:\n32"` to the hash.
2. Hash the message again.