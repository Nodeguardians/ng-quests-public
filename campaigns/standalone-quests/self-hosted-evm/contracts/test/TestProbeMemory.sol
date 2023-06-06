// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "../libraries/Memory.sol";

bytes32 constant ONE = bytes32(uint256(1));
bytes32 constant TWO = bytes32(uint256(1));

bytes32 constant HELLO_WORLD = ":______hello pretty world______:";
bytes32 constant HELLO_UNIVERSE = ":______hello big universe______:";

contract TestProbeMemory {
    using MemoryLib for Memory;

    function _testStoreAndLoad() public pure {
        Memory memory mem = MemoryLib.init(0x40);
        mem.store(0, ONE);
        mem.store(0x20, TWO);

        require(mem.load(0) == ONE, "invalid result");
        require(mem.load(0x20) == TWO, "invalid result");

        mem.store(0, TWO);
        require(mem.load(0) == TWO, "invalid result");
    }

    function _testStoreOutOfRange() public pure {
        Memory memory mem = MemoryLib.init(0x20);
        mem.store(0x20, bytes32(uint256(1)));
        revert("stored out of range");
    }

    function _testStore8() public pure {
        Memory memory mem = MemoryLib.init(0x40);
        mem.store8(30, 0x11);
        mem.store8(31, 0xff);

        require(mem.load(0) == bytes32(uint256(0x11ff)), "invalid store8");
    }

    function _testStore8OutOfRange() public pure {
        Memory memory mem = MemoryLib.init(0x20);
        mem.store8(0x20, uint8(1));
        revert("stored out of range");
    }

    function _testLoadOutOfRange() public pure {
        Memory memory mem = MemoryLib.init(0x20);
        mem.load(0x20);
        revert("loaded out of range");
    }

    function _testInject() public pure {
        Memory memory mem = MemoryLib.init(0x40);
        bytes memory data = abi.encode(HELLO_WORLD, HELLO_UNIVERSE);
        uint256 src;

        assembly {
            src := add(data, 0x20)
        }

        mem.inject(src, 0, data.length);

        require(mem.load(0) == HELLO_WORLD, "invalid inject data");
        require(mem.load(0x20) == HELLO_UNIVERSE, "invalid inject data");
    }

    function _testInjectOutOfRange() public pure {
        Memory memory mem = MemoryLib.init(0x40);
        bytes memory data = new bytes(33);
        uint256 src;

        assembly {
            src := add(data, 0x20)
        }

        mem.inject(src, 0x20, data.length);
        revert("injected out of range");
    }

    function _testExtract() public pure {
        Memory memory mem = MemoryLib.init(0x40);
        mem.store(0, HELLO_WORLD);
        mem.store(0x20, HELLO_UNIVERSE);

        bytes memory extracted = mem.extract(0, 0x40);

        require(extracted.length == 0x40, "invalid length");
        (bytes32 first, bytes32 second) = abi.decode(extracted, (bytes32, bytes32));
        
        require(first == HELLO_WORLD, "invalid extract data");
        require(second == HELLO_UNIVERSE, "invalid extract data");
    }

    function _testExtractOutOfRange() public pure {
        Memory memory mem = MemoryLib.init(0x40);
        mem.store(0, HELLO_WORLD);
        mem.store(0x20, HELLO_UNIVERSE);

        mem.extract(0x20, 0x40);
        revert("extracted out of range");
    }
}
