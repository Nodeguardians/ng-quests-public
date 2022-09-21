const { ethers } = require("hardhat");
const { expect } = require("chai");
const { testGrandmasters } = require("./testsuites/testGrandmasters");

inputs = [
  {
    hint: "Should accept valid signatures",
    creatorId: 0,
    steps: [
      { 
        // Signature Info: | signerId: 0 | recipientId: 1 | amount: "100000000000000000" | ctr: 0 |
        action: "bless", 
        recipientId: 1,
        amount: "100000000000000000",
        signature: "0xd89a8df23a6d308b9e44e98dfbea1f147de2f5e434084b7ba24808016a9c65ed31a4eeccd608c6e0a915b4b6ae1303d7a831c2a545aeb0203481e425b86922861b", 
        reverted: false
      },
      { 
        // Signature Info: | signerId: 0 | recipientId: 1 |
        action: "invite", 
        recipientId: 1,
        signature: "0xb68bf4ea9c3dff4e69b088de3533b8d59ac647fac920fe6ec481963d3324f48376a9568197c1cbc3382f5697b8d33224efe033ab30d33b46700ad06c66d920a61b", 
        reverted: false
      },
      { 
        // Signature Info: | signerId: 1 | recipientId: 2 | amount: "1000000000000000" | ctr: 0 |
        action: 'bless', 
        recipientId: 2,
        amount: "1000000000000000",
        signature: "0x1771afb5de55f90d9863baf278f4d42dbe8a59d1bf852e5f8c9d3b6afe52c24729cd2e0760e8bf9fad867fa63fd04a47a81d7a00c49d922e1353c57109f015f31c", 
        reverted: false
      }
    ]
  },
  {
    hint: "Should reject invalid signatures",
    creatorId: 0,
    steps: [
      {
        // Signature Info: Not a signature
        action: "bless", 
        recipientId: 1,
        amount: "100000000000000000",
        signature: "0xd89a8df23a6d308b9e44e98dfdea1f147de2f5e434084b7ba24728016a9c65ed31a4eeccd608c6e0a915b4b6ae1303d7a831c2a545aeb0203481e425b86922861b", 
        reverted: true // Reason: Invalid signature
      },
      { 
        // Signature Info: Not a signature
        action: "invite", 
        recipientId: 1,
        signature: "0xb68bf4ea9c3dff4e69b088de3544b8d59ac647fac920fe6ec481963d3324f48376a9568197c1cbc3382f5697b8d33224efe033ab30d33b46700ad06c66d920a61c", 
        reverted: true // Reason: Invalid signature
      },
      {
        // Signature Info: | signerId: 1 | recipientId: 2 |
        action: "invite", 
        recipientId: 2,
        signature: "0x9d66152e5decd0ad8653b3d1e2abf8f92b409385b9ca2b3eff19a6c60b2a7a28644c03b50a74bc1e1f35bedd1a5f6c9b0039cf0a3a6e2fe6ceeb2704a884288d1c", 
        reverted: true // Reason: Signer not a grandmaster
      },
      {
        // Signature Info: | signerId: 1 | recipientId: 2 | amount: "100000000000000000" | ctr: 0 | 
        action: "bless", 
        recipientId: 2,
        amount: "100000000000000000",
        signature: "0x76cbc33c7b9c019409fb9585d2460402a88c190681a6918c21eacfb13bb7fd5175e878dc1ca8f749ca704688c276c119ae1975e500b670db08d69021bcb8c8f31b",
        reverted: true // Reason: Signer not a grandmaster
      },
      {
        // Signature Info: | signerId: 0 | recipientId: 2 | amount: ? | ctr: 0 | 
        action: "bless", 
        recipientId: 2,
        amount: "12000000000000",
        signature: "0x45717d08f820893944ffc53dbf7bedce217aa57f4c68c2a5aeb424891ccb72db62f67ee1e7b5b7b75688b18a85d1061e7fb76b02590a4895824d0a64750eef4e1c",
        reverted: true // Reason: Incorrect amount
      }
    ],
  },
  {
    hint: "Should resist ctr replay",
    creatorId: 0,
    steps: [
      {
        // Signature Info: | signerId: 0 | recipientId: 1 | amount: "100000000000000000" | ctr: 0 | 
        action: "bless", 
        recipientId: 1,
        amount: "100000000000000000",
        signature: "0xd89a8df23a6d308b9e44e98dfbea1f147de2f5e434084b7ba24808016a9c65ed31a4eeccd608c6e0a915b4b6ae1303d7a831c2a545aeb0203481e425b86922861b", 
        reverted: false
      },
      {
        // Signature Info: Same signature as before
        action: "bless", 
        recipientId: 1,
        amount: "100000000000000000",
        signature: "0xd89a8df23a6d308b9e44e98dfbea1f147de2f5e434084b7ba24808016a9c65ed31a4eeccd608c6e0a915b4b6ae1303d7a831c2a545aeb0203481e425b86922861b", 
        reverted: true // Reason: Replay
      }
    ]
  }
]

describe("Grandmasters (Part 2)", function() {

  describe("Public Test 1", function () {

    it("Should initially only have contract creator as grandmaster", async function () {

      let [ creator, other ] = await ethers.getSigners();

      GrandmastersFactory = await ethers.getContractFactory("Grandmasters");

      grandmasters = await GrandmastersFactory
        .connect(creator)
        .deploy({value: 100000000000000});

      await grandmasters.deployed();

      let result = await grandmasters.grandmasters(creator.address);
      expect(result).to.be.true;

      result = await grandmasters.grandmasters(other.address);
      expect(result).to.be.false;
    });

  });

  describe("Public Test 2", function () {
    inputs.forEach(testGrandmasters)
  });

});
