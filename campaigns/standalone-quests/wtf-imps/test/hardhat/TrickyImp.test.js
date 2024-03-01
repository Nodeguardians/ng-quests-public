const { expect } = require("chai");

const Target = { Villager: 0, Self: 1 };

describe("Tricky Imps (Part 1)", function() {

  describe("Public Test 1", function() {
    it("Should attack itself", async function() {
      let trickyImp = await ethers.getContractFactory("TrickyImp");
      trickyImp = await trickyImp.deploy();

      await trickyImp.deployed();

      let result = await trickyImp.attack();

      expect(result).to.equal(Target.Self);
    });

  });

});
