const { ethers } = require('hardhat');
const { diamonds } = require("@ngquests/test-helpers");

async function deployDiamond () {
  const contractOwner = await ethers.getSigner();

  // deploy DiamondCutFacet
  const DiamondCutFacet = await ethers.getContractFactory('DiamondCutFacet');
  let diamondCutFacet = await DiamondCutFacet.deploy()
  await diamondCutFacet.deployed()

  // deploy Diamond
  const Diamond = await ethers.getContractFactory('Diamond')
  let diamond = await Diamond.deploy(contractOwner.address, diamondCutFacet.address)
  await diamond.deployed()

  // deploy facets
  const FacetNames = [
    'DiamondLoupeFacet',
    'OwnershipFacet'
  ]
  const cut = []
  for (const FacetName of FacetNames) {
    const Facet = await ethers.getContractFactory(FacetName)
    const facet = await Facet.deploy()
    await facet.deployed()

    cut.push({
      facetAddress: facet.address,
      action: diamonds.FacetCutAction.Add,
      functionSelectors: diamonds.getSelectors(facet)
    })
  }
  
  // upgrade diamond with facets
  diamondCutFacet = await ethers.getContractAt("DiamondCutFacet", diamond.address);
  await diamondCutFacet.diamondCut(
    cut,
    ethers.constants.AddressZero, 
    '0x', 
    { gasLimit: 1000000 }
  );

  return diamond;
}

exports.deployDiamond = deployDiamond
