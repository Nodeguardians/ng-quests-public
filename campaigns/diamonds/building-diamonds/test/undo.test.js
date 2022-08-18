const { ethers } = require('hardhat')
const { expect } = require('chai')
const { diamonds } = require('@ngquests/test-helpers')
const { deployDiamond } = require('./diamonds/deploy.js')
const { testUndo } = require('./testsuites/testUndo.js')

const FacetCutAction = { Add: 0, Replace: 1, Remove: 2, Undo: 3, Commit: 4 }

inputs = [
  {
    name: "Public Test 2",
    descriptor: "Should undo add",
    steps: [
      { action: FacetCutAction.Add, facetId: 0, functions: ["func1()"] },
      { action: FacetCutAction.Add, facetId: 1, functions: [ "func2()", "func3()" ] },
      { action: FacetCutAction.Commit },
      { action: FacetCutAction.Undo, 
        expectedCuts: [
          {action: FacetCutAction.Remove, function: "func2()"},
          {action: FacetCutAction.Remove, function: "func3()"},
        ]
      }
    ]
  },
  {
    name: "Public Test 3",
    descriptor: "Should undo remove",
    steps: [
      { action: FacetCutAction.Add, facetId: 0, functions: ["func1()", "func2()"] },
      { action: FacetCutAction.Add, facetId: 1, functions: ["func3()", "func4()"] },
      { action: FacetCutAction.Commit },
      { action: FacetCutAction.Remove, functions: ["func3()", "func2()"] },
      { action: FacetCutAction.Commit },
      { action: FacetCutAction.Undo, 
        expectedCuts: [
          {action: FacetCutAction.Add, facetId: 0, function: "func2()"},
          {action: FacetCutAction.Add, facetId: 1, function: "func3()"},
        ]
      }
    ]
  },
  {
    name: "Public Test 4",
    descriptor: "Should undo replace",
    steps: [
      { action: FacetCutAction.Add, facetId: 0, functions: ["func1()", "func2()", "func3()"] },
      { action: FacetCutAction.Commit },
      { action: FacetCutAction.Replace, facetId: 1, functions: ["func1()", "func2()"] },
      { action: FacetCutAction.Commit },
      { action: FacetCutAction.Undo, 
        expectedCuts: [
          {action: FacetCutAction.Replace, facetId: 0, function: "func2()"},
          {action: FacetCutAction.Replace, facetId: 0, function: "func1()"},
        ]
      }
    ]
  },
  {
    name: "Public Test 5",
    descriptor: "Should allow multiple undos",
    steps: [
      { action: FacetCutAction.Add, facetId: 0, functions: ["func1()", "func2()", "func3()"] },
      { action: FacetCutAction.Add, facetId: 1, functions: ["func4()", "func5()"] },
      { action: FacetCutAction.Commit },
      { action: FacetCutAction.Remove, functions: ["func1()"] },
      { action: FacetCutAction.Replace, facetId: 2, functions: ["func2()", "func5()"] },
      { action: FacetCutAction.Commit },
      { action: FacetCutAction.Replace, facetId: 3, functions: ["func5()"] },
      { action: FacetCutAction.Commit },
      { action: FacetCutAction.Undo,
        expectedCuts: [
          {action: FacetCutAction.Replace, facetId: 2, function: "func5()"},
        ] },
      { action: FacetCutAction.Undo,
        expectedCuts: [
          {action: FacetCutAction.Replace, facetId: 0, function: "func2()"},
          {action: FacetCutAction.Replace, facetId: 1, function: "func5()"},
        ] },
      { action: FacetCutAction.Replace, facetId: 4, functions: ["func2()", "func4()", "func5()"] },
      { action: FacetCutAction.Commit },
      { action: FacetCutAction.Undo,
        expectedCuts: [
          {action: FacetCutAction.Replace, facetId: 0, function: "func2()"},
          {action: FacetCutAction.Replace, facetId: 1, function: "func4()"},
          {action: FacetCutAction.Replace, facetId: 1, function: "func5()"},
        ] },
      { action: FacetCutAction.Undo,
        expectedCuts: [
          {action: FacetCutAction.Add, facetId: 0, function: "func1()"},
        ] },
      { action: FacetCutAction.Undo,
        expectedCuts: [
          {action: FacetCutAction.Remove, function: "func4()"},
          {action: FacetCutAction.Remove, function: "func5()"},
        ] },
      { action: FacetCutAction.Undo,
        expectedCuts: [
          {action: FacetCutAction.Remove, function: "func1()"},
          {action: FacetCutAction.Remove, function: "func2()"},
          {action: FacetCutAction.Remove, function: "func3()"},
        ] }
    ]
  }
]

describe('Diamond with undo() (Part 1)', async function () {

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

  for (let input of inputs) {
    testUndo(input);
  }

})
