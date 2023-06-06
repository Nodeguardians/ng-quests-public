const { BigNumber } = require("ethers");
const { arrayify, keccak256, zeroPad } = require("ethers/lib/utils");
const { Worker } = require('worker_threads');
const { CURVE } = require('@noble/secp256k1');

const MAX_UINT16 = 65535;
const NUM_OF_THREADS = 3;
const K = "0xc01ddeadc01ddeadc01ddead"

// Generate a random private key `p`
const seed = Math.floor(Math.random() * MAX_UINT16);
const privateKey = BigNumber.from(keccak256(seed));

console.log(`Seed: ${seed}`);

// Start threads running `find-dead.js`
for (let i = 0; i < NUM_OF_THREADS; i++) {

  // Each thread is given a private key `p + (i * K)`
  const delta = BigNumber.from(K).mul(i);
  const seedKey = zeroPad(arrayify(privateKey.add(delta).mod(CURVE.n)), 32);

  const thread = new Worker(
    "./find-dead.js", 
    { workerData: { seedKey: seedKey }}
  );

  thread.on('message', (msg) => {
    console.log(msg);
  });
  
}
