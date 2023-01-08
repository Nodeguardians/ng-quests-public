const { BigNumber } = require("ethers");
const { getAddress: checksumAddress, hexDataSlice, keccak256 } = require("ethers/lib/utils");
const { Point } = require('@noble/secp256k1');
const { parentPort, workerData } = require('worker_threads');

// Calculate new point `P` from seed key `p`
const seedKey = workerData.seedKey;
let newPoint = Point.fromPrivateKey(seedKey);

for (let i = 1; ; i++) {

  // Increment new point `P` (i.e. `P <- P + G`)
  newPoint = newPoint.add(Point.BASE);
  
  // Infer address of `P`
  const newAddress = hexDataSlice(keccak256(
    hexDataSlice('0x' + newPoint.toHex(), 1)
  ), 12);

  // If address is vanity address...
  if (newAddress.startsWith("0x0dead")) {

    // Infer the private key (i.e. `p + i`)
    const deadKey = BigNumber.from(seedKey).add(i);

    // Send back to parent process to print
    parentPort.postMessage(
      `\nPrivate Key: ${deadKey.toHexString()}\
       \nAddress: ${checksumAddress(newAddress)}`
    );

  }

}
