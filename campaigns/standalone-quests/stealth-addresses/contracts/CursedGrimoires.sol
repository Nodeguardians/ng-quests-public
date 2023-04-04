// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./interfaces/IGrimoires.sol";

contract CursedGrimoires is IGrimoires, ERC721 {

    constructor() ERC721("Cursed Grimoires", "GRIM") { }

    // Implement IGrimores interface...

}
