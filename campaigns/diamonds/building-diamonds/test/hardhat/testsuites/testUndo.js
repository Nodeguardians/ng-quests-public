const { ethers } = require("hardhat");
const { expect } = require("chai");
const { diamonds, events } = require('@node-guardians/ng-quests-helpers')
const { deployDiamond } = require("../diamonds/deploy");

const FacetCutAction = { Add: 0, Replace: 1, Remove: 2, Undo: 3, Commit: 4 }
const StepAction = { Cut: 0, Undo: 1 }
const DIAMOND_CUT_EVENT = "DiamondCut((address,uint8,bytes4[])[],address,bytes)";
const SALTS = [0, 15, 7654, 6992131, 25891, 2389232]

// diamond should be a new diamond
function testUndo(subsuiteName, testName, input) {
  describe(subsuiteName, function () {

    let diamond;
    let diamondCutFacet;
    let headFacet;
    let headFacets;

    function parseInputCut(inputCut) {
      return {
        facetAddress: headFacets[inputCut.facetId],
        action: inputCut.action,
        functionSelectors: inputCut.functions.map(diamonds.getSelector)
      };
    }

    function hasFacetCut(diamondCut, queryCut) {

      for (let facetCut of diamondCut) {
        if (facetCut.action != queryCut.action
            || facetCut.facetAddress != queryCut.facetAddress) {
          continue;
        }

        if (facetCut.functionSelectors
            .includes(queryCut.functionSelectors[0])) { 
          return true; 
        }

      }

      return false;
    }


    async function expectUndo(undoTx, expectedCuts) {

      for (let expectedCut of expectedCuts) {
    
        // Tests that transaction emits the expected DiamondCut event(s)
        await events.testEvent(
          undoTx,
          DIAMOND_CUT_EVENT, 
          (event) => {
            const diamondCut = event.args._diamondCut;
            return hasFacetCut(diamondCut, parseInputCut(expectedCut))
          }
        );
    
        // Tests that functions are correctly linked.
        const testCall = headFacet[expectedCut.functions[0]]
        if (expectedCut.action == FacetCutAction.Remove) {
          await expect(testCall()).to.be.reverted;
        } else {
          expect(await testCall()).to.equal(SALTS[expectedCut.facetId]);
        }
    
      }
    
    }

    before(async function () {
      const HeadFacet = await ethers.getContractFactory("HeadFacet");
  
      headFacets = [ ethers.constants.AddressZero ];
      for (let i = 1; i <= 5; i++) {
        const facet = await HeadFacet.deploy(SALTS[i]);
        await facet.deployed();
        headFacets.push(facet.address);
      }

      diamond = await deployDiamond();
      diamondCutFacet = await ethers.getContractAt('DiamondCutFacet', diamond.address);
      headFacet = await ethers.getContractAt('HeadFacet', diamond.address);
  
    });
    
    it(testName, async function () {

      for (const step of input.steps) {

        if (step.action == StepAction.Cut) {

          await diamondCutFacet.diamondCut(
            step.cuts.map(parseInputCut), 
            ethers.constants.AddressZero, 
            '0x', 
            { gasLimit: 800000 }
          );

        } else {

          let tx = await diamondCutFacet.undo();
          await expectUndo(tx, step.cuts);
        }
      }
    });

  });

}

module.exports.testUndo = testUndo;