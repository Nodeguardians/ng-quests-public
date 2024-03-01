// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../../../contracts/Doubloon.sol";

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
}

abstract contract TestDoubloonCreation is Test {

    using stdJson for string;

    IERC20Metadata doubloon;

    struct Input {
        uint256 supply;
    }

    Input input;

    constructor(string memory _testDataPath, string memory _testDataKey) {
        string memory jsonData = vm.readFile(_testDataPath);
        input = abi.decode(jsonData.parseRaw(_testDataKey), (Input));

        doubloon = IERC20Metadata(address(new Doubloon(input.supply)));
    }

    function test_have_name() external {
        assertEq(doubloon.name(), "Doubloon");
    }

    function test_have_symbol() external {
        assertEq(doubloon.symbol(), "DBL");
    }

    function test_have_totalSupply() external {
        assertEq(doubloon.totalSupply(), input.supply);
    }
}
