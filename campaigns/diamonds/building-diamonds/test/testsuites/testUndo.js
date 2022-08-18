const { ethers } = require("hardhat");
const { expect } = require("chai");
const { diamonds, events } = require('@ngquests/test-helpers')
const { deployDiamond } = require("../diamonds/deploy");

const FacetCutAction = { Add: 0, Replace: 1, Remove: 2, Undo: 3, Commit: 4 }
const DIAMOND_CUT_EVENT = "DiamondCut((address,uint8,bytes4[])[],address,bytes)";
const SALTS = [15, 7654, 6992131, 25891, 2389232]

// Tests if a diamond cut has a given facet cut.
function hasFacetCut(diamondCut, expectedAction, expectedAddress, expectedSelector) {

  for (let facetCut of diamondCut) {
    if (facetCut.action != expectedAction) continue;
    if (facetCut.facetAddress != expectedAddress) continue;

    if (!facetCut.functionSelectors.includes(expectedSelector)) continue;

    return true;
  }

  return false;
}

// diamond should be a new diamond
function testUndo(input) {
  describe(input.name, function () {

    let diamond;
    let diamondCutFacet;
    let headFacet;
    let headFacets;

    before(async function () {
      const HeadFacet = await ethers.getContractFactory("HeadFacet");
  
      headFacets = [];
      for (let i = 0; i < 5; i++) {
        const facet = await HeadFacet.deploy(SALTS[i]);
        await facet.deployed();
        headFacets.push(facet.address);
      }

      diamond = await deployDiamond();
      diamondCutFacet = await ethers.getContractAt('DiamondCutFacet', diamond.address);
      headFacet = await ethers.getContractAt('HeadFacet', diamond.address);
  
    });
    
    it(input.descriptor, async function () {

      let diamondCut = []
      ctr = 0;
      for (let step of input.steps) {

        if (step.action == FacetCutAction.Commit) {
          await diamondCutFacet.diamondCut(
            diamondCut, 
            ethers.constants.AddressZero, 
            '0x', { gasLimit: 800000 }
          );

          diamondCut = [];
          continue;
        }

        if (step.action == FacetCutAction.Undo) {

          let tx = await diamondCutFacet.undo();

          for (let facetCut of step.expectedCuts) {

            let facetAddress = facetCut.facetId == undefined
              ? ethers.constants.AddressZero
              : headFacets[facetCut.facetId];

            let selector = diamonds.getSelector(facetCut.function);

            // Tests that transaction emits the expected DiamondCut event(s)
            await events.testEvent(
              tx,
              DIAMOND_CUT_EVENT, 
              (event) => {
                const diamondCut = event.args._diamondCut;
                return hasFacetCut(diamondCut, facetCut.action, facetAddress, selector)
              }
            );

            // Tests that functions are correctly linked.
            const testCall = headFacet[facetCut.function];
            if (facetCut.action == FacetCutAction.Remove) {
              await expect(testCall()).to.be.reverted;
            } else {
              expect(await testCall()).to.equal(SALTS[facetCut.facetId]);
            }
            
          }

          // Test that no extra DiamondCut Events were emitted.
          const loggedDiamondCut = await events.getArg(tx, DIAMOND_CUT_EVENT, '_diamondCut');
          let numSelectorsChanged = loggedDiamondCut.reduce(
            (sum, facetCut) => sum + facetCut.functionSelectors.length, 0
          );
          expect(numSelectorsChanged).to.equal(step.expectedCuts.length);

          continue;
        }

        const facetAddress = step.action == FacetCutAction.Remove 
          ? ethers.constants.AddressZero
          : headFacets[step.facetId];

        diamondCut.push({
          facetAddress: facetAddress,
          action: step.action,
          functionSelectors: step.functions.map(diamonds.getSelector)
        });

        previousStep = step;

      }
    });

  });

}

module.exports.testUndo = testUndo;