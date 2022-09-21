const { testCursedGrimoires } = require("./testsuites/testCursedGrimoires");

inputs = [
  {
    name: "Public Test 1",
    privateKey: "0x57173ed12749cb1caa617093347859b95749e4057229b932e3fe79d9932c83f3",
    secret: "0x403a41de",
    tokenId: 11
  },
  {
    name: "Public Test 2",
    privateKey: "0x86311f85063cdb22febd2f6f5127af300c0933feb395189c5088c50dd68963dc",
    secret: "0x947abcd31b",
    tokenId: 12
  }
]

describe("Cursed Grimoires (Part 1)", function() {

  inputs.forEach(testCursedGrimoires);

});