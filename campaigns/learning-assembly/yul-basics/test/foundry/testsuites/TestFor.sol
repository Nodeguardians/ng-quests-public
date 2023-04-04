// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../../contracts/For.sol";

abstract contract TestFor is Test {

    For forContract;

    using stdJson for string;

    uint256 beg;
    uint256 end;
    bytes8[] directions;

    constructor(
        string memory _testDataPath,
        string memory _testDataKey
    ) {
        string memory jsonData = vm.readFile(_testDataPath);
        beg = jsonData.readUint(string.concat(_testDataKey, ".beg"));
        end = jsonData.readUint(string.concat(_testDataKey, ".end"));

        forContract = new For();
    }

    function test_sum_elements() external {
        uint256 expected;
        for (uint i = beg; i < end; i++) {
            if (i % 5 == 0) continue;
            if (end % i == 0) break;
            expected += i;
        }
        
        uint256 actual = forContract.sumElements(beg, end);
        assertEq(actual, expected, "Unexpected Result");
    }

}