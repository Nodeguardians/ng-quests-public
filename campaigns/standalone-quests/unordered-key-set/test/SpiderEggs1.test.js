const { testEggs } = require("./testsuite/testEggs1");

input = {
  name: "Public Test 1",
  eggs: [
    { id: 284759285912343, size: 1939283597, strength: 102191 },
    { id: 9825293891, size: 235423, strength: 9851321 },
    { id: 82345124521234, size: 28359098918, strength: 93992929919 },
    { id: 98095711, size: 34576811, strength: 7637149512741093 },
    { id: 507624405, size: 85249614380, strength: 321712},
    { id: 246805378679, size: 33311293147581, strength: 8798911673541627},
    { id: 28359098918, size:235423, strength: 1021912000012143},
    { id: 54678984, size: 79746679326, strength: 274658187},
    { id: 8898846, size: 1664311226, strength: 4718},
    { id: 0, size: 71264, strength: 0},
  ]
}

describe("SpiderEggs (Part 1)", function() {
  testEggs(input)
});