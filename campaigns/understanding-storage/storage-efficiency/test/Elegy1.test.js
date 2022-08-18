const { testElegy1 } = require("./testsuites/testElegy1");

input = {
  name: "Public Test 1",
  firstVerse: "0x0001020304050607",
  secondVerse: "0x101112131415161718191a1b1c1d1e1f101112131415161718191a1b1c1d1e1f",
  thirdVerse: "0x202122232425262728292a2b2c2d2e2f20212223",
  fourthVerse: "0x303132333435363738393a3b3c3d3e3f",
  fifthVerse: "0x404142434445464748494a4b"
}

describe("Elegy1 (Part 1)", function() {
  testElegy1(input);
});