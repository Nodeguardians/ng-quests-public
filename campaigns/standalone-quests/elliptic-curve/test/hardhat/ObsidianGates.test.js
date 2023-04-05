const { expect } = require("chai");

const { testAffine } = require("./testsuites/testAffine.js");
const input = require("../data/affineConversions.json");

describe("Obsidian Gates (Part 3)", function() {
  testAffine("Public Test 1", input);
  
  describe("Opening the Gates...", function () {

    let obsidianGates;

    before(async function () {
      let ObsidianGates = await ethers.getContractFactory("ObsidianGates");

      obsidianGates = await ObsidianGates.deploy();
      await obsidianGates.deployed()
    });

    it("Gates opened!", async function () {
      const recoveredKey = await obsidianGates.recoverSignature(
        "0x0e91c7239c2640d7d28a3e39d4583fa63c0bc0a5df64a4fe672e573045ca78965df65c3b550dba221a22733bb8e0bd6d7e68833575e7a5ae138046543140ad5585811d39bb743f28439794607b06d52b8a249c47830a37d221db656c94a7ab55"
      );

      expect(recoveredKey.qx).to.equal("0xb9bece41d23c23b76398c555600a7e5825004cb222cc8ece4114646efbd4cc59");
      expect(recoveredKey.qy).to.equal("0x5063a07aed87cf15be539c4c8a89f513139b45e625793949ac1d5a5089a40ffd");
    });

  });
});
