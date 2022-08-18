const { testApproveInvitation, testApproveBlessing } = require("./testsuites/testSign");

inviteInputs = [
  {
    name: 'Public Test 1',
    recipient: '0x14dC79964da2C08b23698B3D3cc7Ca32193d9955',
    signingKey: '0x8a35acfbc15ff81a39ae7d344fd709f28e8600b4aa8c65c6b64bfe7fe36bd19b',
    signature: '0x48f7599c65fef84eaf9b5f2c9c5f021cbd5ee3d72a981bc459c5f1d9cf30d74655e23cea5158f56030f226a144023811bc64d5df7ea205ffb00e9ecf3c6e8fad1c'
  },
  {
    name: 'Public Test 2',
    recipient: '0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc',
    signingKey: '0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6',
    signature: '0x766c18e34ad1b4a08f4a2fa2ee67dc40c1dab4ab60065df0c287c829680bc59e22f8972dbccab5f878461dcfd6c0acfb0b83a9d7a28d9d14d45b3d99056d72251c'
  }
]

blessingInputs = [
  {
    name: 'Public Test 1',
    recipient: '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266',
    amount: ethers.utils.parseEther("1"), 
    ctr: 0,
    signingKey: '0x405787fa12a823e0f2b7631cc41b3ba8828b3321ca811111fa75cd3aa3bb5ace',
    signature: '0x04c3b43414ca637498d349378dda35ee0fcee1dc76e7df454b69c0295dcd0a135d6f85e2ab1c205b9b7518b52235acddf19bb20ccc33bb722bbb46085c66bee91c'
  },
  {
    name: 'Public Test 2',
    recipient: '0x14dC79964da2C08b23698B3D3cc7Ca32193d9955',
    amount: ethers.utils.parseEther("1"), 
    ctr: 11,
    signingKey: '0x8a35acfbc15ff81a39ae7d344fd709f28e8600b4aa8c65c6b64bfe7fe36bd19b',
    signature:
    '0x9dc82a90812239866aec39cc882e14d5e4ce27c9c665c3d90e2db0580a0781286fc77a2c1224497ffb4da5039cc3d60ff5f49d3a6da03bf48f7d4da0d14f08551b'
  }
]

describe("ApproveInvitation() (Part 1)", function() {
  inviteInputs.forEach(testApproveInvitation)
});

describe("ApproveBlessing() (Part 1)", function() {
  blessingInputs.forEach(testApproveBlessing)
});