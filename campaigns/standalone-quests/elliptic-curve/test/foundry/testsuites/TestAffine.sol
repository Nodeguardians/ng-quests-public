// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../../contracts/test/CurveProbe.sol";

abstract contract TestAffine is Test {

    using stdJson for string;

    struct AffinePoint {
        Felt x;
        Felt y;
    }

    string jsonData;

    CurveProbe curveProbe;

    constructor(string memory _testDataPath) {
        jsonData = vm.readFile(_testDataPath);
        curveProbe = new CurveProbe();
    }


    function test_convert_Affine_to_Jacobian() external {
        AffinePoint[] memory affToJacTests = abi.decode(
            jsonData.parseRaw(".affToJacTests"),
            (AffinePoint[])
        );

        for (uint i = 0; i < affToJacTests.length; i++) {
            AffinePoint memory test = affToJacTests[i];
            uint256 gas = curveProbe.testAffineToJac(test.x, test.y);

            assertLt(gas, 400, "Too gas inefficient");
        }
    }

    function test_convert_Jacobian_to_Affine() external {
        JacPoint[] memory jacToAffineTests = abi.decode(
            jsonData.parseRaw(".jacToAffTests"),
            (JacPoint[])
        );

        for (uint i = 0; i < jacToAffineTests.length; i++) {
            uint256 gas = curveProbe.testJacToAffine(jacToAffineTests[i]);
            
            assertLt(gas, 80000, "Too gas inefficient");
        }
    }

}
