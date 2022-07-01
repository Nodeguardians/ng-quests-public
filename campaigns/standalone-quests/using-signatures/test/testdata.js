const { parseEther } = require("ethers/lib/utils");

module.exports.blessings = [
    {
        recipient: '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266',
        amount: parseEther("1"), 
        ctr: 0,
        signingKey: '0x405787fa12a823e0f2b7631cc41b3ba8828b3321ca811111fa75cd3aa3bb5ace',
        signature: '0x04c3b43414ca637498d349378dda35ee0fcee1dc76e7df454b69c0295dcd0a135d6f85e2ab1c205b9b7518b52235acddf19bb20ccc33bb722bbb46085c66bee91c'
    },
    {
        recipient: '0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc', 
        amount: parseEther("1"), 
        ctr: 0,
        signingKey: '0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6',
        signature:     '0x05bb0876ee2f576967991f5dc7cdf10b9455c6e659e6d78d656efc1c587fe4c4115963e206b40b18f37ecb192d851927510255be4feae265b1325e0033a8ca631b'
    },
    {
        recipient: '0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc',
        amount: parseEther("1.1"), 
        ctr: 0,
        signingKey: '0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e563',
        signature:     '0xfdfa66ced5292b9a52144d71381c856d7fce104683e68cc228d9791489d582c43f01e161297df6d06fd08bc8cc0acbf9ee1df3b8fabb29bf54f589d5c0ab33ea1c'
    },
    {
        recipient: '0x14dC79964da2C08b23698B3D3cc7Ca32193d9955',
        amount: parseEther("1"), 
        ctr: 11,
        signingKey: '0x8a35acfbc15ff81a39ae7d344fd709f28e8600b4aa8c65c6b64bfe7fe36bd19b',
        signature:
        '0x9dc82a90812239866aec39cc882e14d5e4ce27c9c665c3d90e2db0580a0781286fc77a2c1224497ffb4da5039cc3d60ff5f49d3a6da03bf48f7d4da0d14f08551b'
    },
]

module.exports.invitations = [
    {
        recipient:'0x14dC79964da2C08b23698B3D3cc7Ca32193d9955',
        signingKey: '0x8a35acfbc15ff81a39ae7d344fd709f28e8600b4aa8c65c6b64bfe7fe36bd19b',
        signature: '0x48f7599c65fef84eaf9b5f2c9c5f021cbd5ee3d72a981bc459c5f1d9cf30d74655e23cea5158f56030f226a144023811bc64d5df7ea205ffb00e9ecf3c6e8fad1c'
    },
    {
        recipient: '0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc',
        signingKey: '0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6',
        signature: '0x766c18e34ad1b4a08f4a2fa2ee67dc40c1dab4ab60065df0c287c829680bc59e22f8972dbccab5f878461dcfd6c0acfb0b83a9d7a28d9d14d45b3d99056d72251c'
    },
    {
        recipient: '0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc',
        signingKey: '0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e563',
        signature: '0x6af2e07beb6ee2baea959d60f2e451cf30ca51985324623bf8880c7bb1f2fd4739955fb515b56ef3b49ea8eb4c2782272d8e352372ff6d1b0482453bfdc8024a1b'
    },
    {
        recipient: '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266',
        signingKey: '0x405787fa12a823e0f2b7631cc41b3ba8828b3321ca811111fa75cd3aa3bb5ace',
        signature: '0x0e5631dcc38fffd6f5d2c8a292d3ae10fb7422c2cb497d1327267fe5cc51e0ee48f3c85eecbb9892608e0fb87a36d9900641ccd1b9ba73a87f7453260c04af911c'
    }
]