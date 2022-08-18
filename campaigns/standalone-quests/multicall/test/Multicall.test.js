const { testSuite2 } = require("./testsuites/testsuite2");

// Dummy address
const ALICE = "0x0c7213bac2B9e7b99ABa344243C9de84227911Be";

function getData(record) { return record.data; }
function getAuthor(record) { return record.author; }

input = {
  name: "Public Test 1",
  callee: "GreaterArchives",
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
      call: (x) => x.historyRecords(1).then(getData),
      result: "0x123412341234"
    },
    {
      call: (x) => x.musicScrolls(ALICE), 
      result: "0xfeedfeedfeedfeed"
    },
    {
      call: (x) => x.scienceScrolls(ALICE),
      result: "0xbebebebe"
    },
    // Author should be original msg.sender
    {
      call: (x) => x.historyRecords(0).then(getAuthor),
      result: "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
    },
  ]
}

describe("Multicall (Part 2)", function() {
  testSuite2(input);
});