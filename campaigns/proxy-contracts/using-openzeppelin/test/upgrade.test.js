const { expect } = require("chai");

const { deploy } = require("../scripts/deploy.js");
const { upgrade } = require("../scripts/upgrade.js");

describe("upgrade() (Part 2)", function () {
  const THRESHOLD = ethers.utils.parseEther("1");

  let suit;

  it("Should upgrade with OpenZeppelin", async function () {
    suit = await deploy(THRESHOLD);

    let oldImpl = await upgrades.erc1967.getImplementationAddress(suit.address);

    suit = await upgrade(suit.address, THRESHOLD);

    let newImpl = await upgrades.erc1967.getImplementationAddress(suit.address);

    expect(newImpl).to.not.equal(oldImpl);
  });

});
