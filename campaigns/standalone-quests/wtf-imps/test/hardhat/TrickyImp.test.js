const { expect } = require("chai");

const Target = { Villager: 0, Self: 1 };

describe("Tricky Imps (Part 1)", function() {

  describe("Public Test 1", function() {
    it("Should attack itself", async function() {

      const TrickyImp = await ethers.getContractFactory("TrickyImp");
      const trickyImp = await TrickyImp.deploy();
      await trickyImp.deployed();

      const TestImp = await ethers.getContractFactory("TestImp");
      const testImp = await TestImp.deploy();
      await testImp.deployed();

      const actual = await trickyImp.attack();
      const expected = await testImp.self();

      expect(actual).to.equal(expected);
    });

  });

});
