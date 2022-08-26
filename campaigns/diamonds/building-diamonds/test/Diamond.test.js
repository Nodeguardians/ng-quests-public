const { deployDiamond } = require('./diamonds/deploy.js')
const { ethers } = require('hardhat')
const { expect } = require('chai')
const { diamonds } = require('@ngquests/test-helpers')

describe('Diamond (Part 1)', async function () {
  let diamond;
  let diamondCutFacet;
  let diamondLoupeFacet;
  let ownershipFacet;
  let result;
  const addresses = [];

  before(async function () {
    diamond = await deployDiamond();
    diamondCutFacet = await ethers.getContractAt('DiamondCutFacet', diamond.address);
    diamondLoupeFacet = await ethers.getContractAt('DiamondLoupeFacet', diamond.address);
    ownershipFacet = await ethers.getContractAt('OwnershipFacet', diamond.address);
  })

  it('Should have three facets', async () => {
    for (const address of await diamondLoupeFacet.facetAddresses()) {
      addresses.push(address)
    };

    expect(addresses.length).to.equal(3);
  })

  it('Should have the expected function selectors', async () => {
    let selectors = diamonds.getSelectors(diamondCutFacet);
    result = await diamondLoupeFacet.facetFunctionSelectors(addresses[0]);
    expect(result).to.have.members(selectors);

    selectors = diamonds.getSelectors(diamondLoupeFacet);
    result = await diamondLoupeFacet.facetFunctionSelectors(addresses[1]);
    expect(result).to.have.members(selectors);

    selectors = diamonds.getSelectors(ownershipFacet);
    result = await diamondLoupeFacet.facetFunctionSelectors(addresses[2]);
    expect(result).to.have.members(selectors);
  })

  it('Selectors should be associated to facets correctly', async () => {
    expect(addresses[0]).to.equal(
      await diamondLoupeFacet.facetAddress('0x1f931c1c')
    );
    expect(addresses[1]).to.equal(
      await diamondLoupeFacet.facetAddress('0xcdffacc6')
    );
    expect(addresses[2]).to.equal(
      await diamondLoupeFacet.facetAddress('0xf2fde38b')
    );
  })

  it('Should add functions', async () => {
    const HeadFacet = await ethers.getContractFactory('HeadFacet');
    const headFacet = await HeadFacet.deploy(11);
    await headFacet.deployed();
    addresses.push(headFacet.address);
    
    await diamondCutFacet.diamondCut(
      [{
        facetAddress: headFacet.address,
        action: diamonds.FacetCutAction.Add,
        functionSelectors: diamonds.getSelectors(headFacet)
      }],
      ethers.constants.AddressZero, '0x', { gasLimit: 800000 }
    );
    
    result = await diamondLoupeFacet.facetFunctionSelectors(headFacet.address);
    expect(result).to.have.members(diamonds.getSelectors(headFacet));

    expect(await headFacet.func1()).to.equals(11);
  })

  it('Should remove some functions', async () => {
    const headFacet = await ethers.getContractAt('HeadFacet', diamond.address);
    const selectorsToKeep = ['func1()', 'func2()'].map(diamonds.getSelector);
    const selectorsToRemove = diamonds.getSelectors(headFacet)
      .filter(sel => !selectorsToKeep.includes(sel));

    await diamondCutFacet.diamondCut(
      [{
        facetAddress: ethers.constants.AddressZero,
        action: diamonds.FacetCutAction.Remove,
        functionSelectors: selectorsToRemove
      }],
      ethers.constants.AddressZero, '0x', { gasLimit: 800000 }
    );

    result = await diamondLoupeFacet.facetFunctionSelectors(addresses[3]);
    expect(result).to.have.members(result, selectorsToKeep);
    for (let sel of selectorsToRemove) {
      expect(result).to.not.include(sel);
    }
  })

})
