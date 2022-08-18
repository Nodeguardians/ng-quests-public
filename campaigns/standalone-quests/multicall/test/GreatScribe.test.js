const { testSuite1 } = require("./testsuites/testsuite1");

// Dummy address
const ALICE = "0x0c7213bac2B9e7b99ABa344243C9de84227911Be";

function getData(record) { return record.data; }

input = {
  name: "Public Test 1",
  callee: "GreatArchives",
  testWrites: [
    { sig: "recordHistory", args: ["0xdeadbeefdeadbeef"] },
    { sig: "writeMusic", args: [ALICE, "0xfeedfeedfeedfeed"] },
    { sig: "writeScience", args: [ALICE, "0xbebebebe"] },
    { sig: "recordHistory", args: ["0x123412341234"] },
  ],
  verifyWrites: [
    {
      call: (x) => x.historyRecords(0).then(getData),
      result: "0xdeadbeefdeadbeef"
    },
    {
      call: (x) => x.musicScrolls(ALICE), 
      result: "0xfeedfeedfeedfeed"
    },
    {
      call: (x) => x.scienceScrolls(ALICE),
      result: "0xbebebebe"
    },
    {
      call: (x) => x.historyRecords(1).then(getData),
      result: "0x123412341234"
    }
  ],
  beforeRead: 
    async function(archives) {
      await archives.recordMagic("0xabacabacabacabac");
      await archives.recordMagic("0xabacabacabacabacabacabac");
      await archives.writeScience(ALICE, "0xdeadbeefbeefdead");
    },
  testReads: [
    { sig: "magicRecords", args: [0] },
    { sig: "scienceScrolls", args: [ALICE] },
    { sig: "magicRecords", args: [1] }
  ],
}

describe("GreatScribe (Part 1)", function() {
  testSuite1(input);
});