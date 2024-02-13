const { ethers } = require("hardhat");
const { expect } = require("chai");
const { ast } = require("@node-guardians/ng-quests-helpers");
const parser = require("@solidity-parser/parser");
const fs = require("fs");

const { testSuitV1 } = require("./testsuites/testSuitV1.js");

const OPENZEPPELIN_ERC721UPGRADEABLE_PATH 
  = "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";

inputs = [
  {
    name: "Public Test 3",
    pilotIds: [0, 1],
    steps: [
      { action: "createBomb", senderId: 0, targetId: 3, dmg: 100001, reverted: false },
      { action: "createBomb", senderId: 2, targetId: 5, dmg: 20000, reverted: true },
      { action: "confirmBomb", bombId: 0, senderId: 1, reverted: false },
      { action: "confirmBomb", bombId: 1, senderId: 1, reverted: true }
    ]
  },
  {
    name: "Public Test 4",
    pilotIds: [1, 2],
    steps: [
      { action: "createBomb", senderId: 1, targetId: 3, dmg: 0, reverted: false },
      { action: "createBomb", senderId: 2, targetId: 0, dmg: 10000000, reverted: false },
      { action: "confirmBomb", bombId: 0, senderId: 1, reverted: true },
      { action: "confirmBomb", bombId: 1, senderId: 1, reverted: false },
      { action: "confirmBomb", bombId: 0, senderId: 0, reverted: true },
      { action: "confirmBomb", bombId: 2, senderId: 1, reverted: true },
      { action: "confirmBomb", bombId: 0, senderId: 2, reverted: false }
    ]   
  }
]

describe("UltimateSuitV1 (Part 1)", function() {

  describe("Public Test 1", function () {

    it("Should be upgrade-safe", async function () {
      const [pilot1, pilot2] = await ethers.getSigners();
      const Suit = await ethers.getContractFactory("UltimateSuitV1");
      await upgrades.validateImplementation(
        Suit, 
        [pilot1.address, pilot2.address]
      );
    });

  });

  describe("Public Test 2", function () {

    let solutionAst;

    before(async function () {
      const solutionContent = fs.readFileSync("contracts/UltimateSuitV1.sol", { encoding: "utf8"});
      solutionAst = ast.toAst(solutionContent);
    });

    it("Should inherit OpenZeppelin's ERC721 (Upgradeable)", async function () {
      let hasImport = false;
      let inherits = false;
      parser.visit(solutionAst, {
        ImportDirective: function(node) {
          if (node.path != OPENZEPPELIN_ERC721UPGRADEABLE_PATH) return;    
          hasImport = true;
        },
        InheritanceSpecifier: function(node) {
          if (node.baseName.namePath != "ERC721Upgradeable") return;
          inherits = true;
        }
      });

      expect(hasImport && inherits).to.be.true;
    });

    it("Should have Status enum", async function () {
      let hasStatusEnum = false;
      parser.visit(solutionAst, {
        EnumDefinition: function(node) {
          if (node.name != "Status") return;
          hasStatusEnum = true;
        }
      })
      expect(hasStatusEnum).to.be.true;
    });
  
    it("Should have BombStats struct", async function () {
      let hasStatsStruct = false;
      parser.visit(solutionAst, {
        StructDefinition: function(node) {
          if (node.name != "BombStats") return;
          hasStatsStruct = true;
        }
      })
      expect(hasStatsStruct).to.be.true;
    });

  });

  inputs.forEach(testSuitV1);
});

