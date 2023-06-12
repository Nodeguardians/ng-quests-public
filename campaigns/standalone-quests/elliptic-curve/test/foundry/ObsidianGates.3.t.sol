// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestAffine.sol";
import "../../contracts/ObsidianGates.sol";

contract PublicTest1 is TestAffine {
    string PATH = "test/data/affineConversions.json";
    constructor() TestAffine(PATH) { }
}

contract OpeningObsidianGates is Test {

    bytes signature = hex"0e91c7239c2640d7d28a3e39d4583fa63c0bc0a5df64a4fe672e573045ca78965df65c3b550dba221a22733bb8e0bd6d7e68833575e7a5ae138046543140ad5585811d39bb743f28439794607b06d52b8a249c47830a37d221db656c94a7ab55";

    uint256 expectedX = 0xb9bece41d23c23b76398c555600a7e5825004cb222cc8ece4114646efbd4cc59;
    uint256 expectedY = 0x5063a07aed87cf15be539c4c8a89f513139b45e625793949ac1d5a5089a40ffd;

    function test_gates_opened() external {
        ObsidianGates gates = new ObsidianGates();

        (Felt actualX, Felt actualY) 
            = gates.recoverSignature(signature);

        assertEq(Felt.unwrap(actualX), expectedX);
        assertEq(Felt.unwrap(actualY), expectedY);
    }

}