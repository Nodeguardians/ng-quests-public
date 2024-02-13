const { ethers } = require('hardhat')
const { expect } = require('chai')
const { diamonds } = require('@node-guardians/ng-quests-helpers')
const { deployDiamond } = require('./diamonds/deploy.js')
const { testUndo } = require('./testsuites/testUndo.js')
const inputs = require('../data/cuts.json')

describe('Diamond with undo() (Part 2)', async function () {

  describe('Public Test 1', async function () {
    it('Should have undo() in loupe', async () => {
      diamond = await deployDiamond();
      diamondLoupeFacet = await ethers.getContractAt('DiamondLoupeFacet', diamond.address);

      let undoSelector = diamonds.getSelector("undo()");
      let undoAddress = await diamondLoupeFacet.facetAddress(undoSelector);

      expect(await diamondLoupeFacet.facetFunctionSelectors(undoAddress))
        .to.include(undoSelector);
      
    })
  });

  testUndo("Public Test 2", "Should undo add", inputs["undoAdd"]);
  testUndo("Public Test 3", "Should undo remove", inputs["undoRemove"]);
  testUndo("Public Test 4", "Should undo replace", inputs["undoReplace"]);
  testUndo("Public Test 5", "Should allow multiple undos", inputs["undoMultiple"]);

})
