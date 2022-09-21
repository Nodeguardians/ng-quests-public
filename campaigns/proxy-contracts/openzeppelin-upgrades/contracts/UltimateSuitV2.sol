// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract UltimateSuitV2 is ERC721 {

    event Detonate(uint256 bombId);

    enum Status {
        CONFIRMED_BY_A,
        CONFIRMED_BY_B,
        LAUNCHED,
        DETONATED
    }

    struct BombStats {
        address initialTarget;
        uint256 damage;
        uint8 transfersLeft; // Transfers before bomb detonates
        Status status;
    }

    uint8 constant TRANSFERS = 3;

    address private pilotA;
    address private pilotB;

    mapping (uint => BombStats) private bombStats;
    uint256 public bombCount;

    modifier isPilot(address _address) {
        require(_address == pilotA || _address == pilotB, "Not a pilot");
        _; 
    }

    modifier isUnconfirmed(uint256 _bombId, address _pilot) {
        require(_bombId < bombCount, "Bomb not initialized");

        Status expectedStatus = msg.sender == pilotA 
            ? Status.CONFIRMED_BY_B 
            : Status.CONFIRMED_BY_A;
        require(bombStats[_bombId].status == expectedStatus, "msg.sender already confirmed bomb");

        _; 
    }

    constructor() ERC721("Ultimate Suit", "SUIT") {}

    function createBomb(
        address _initialTarget, 
        uint256 _damage
    ) public isPilot(msg.sender) returns (uint256 bombId) {
        _mint(address(this), bombCount);
        BombStats storage stats = bombStats[bombCount];
        stats.initialTarget = _initialTarget;
        stats.damage = _damage;
        stats.status = msg.sender == pilotA
            ? Status.CONFIRMED_BY_A
            : Status.CONFIRMED_BY_B;

        return bombCount++;
    }

    function confirmBomb(uint256 bombId) public 
        isPilot(msg.sender) 
        isUnconfirmed(bombId, msg.sender)
    {
        bombStats[bombId].status = Status.LAUNCHED;
        bombStats[bombId].transfersLeft = TRANSFERS;
        _transfer(
            address(this), 
            bombStats[bombId].initialTarget,
            bombId
        );
    }

    function getPilots() external view returns (address, address) {
        return (pilotA, pilotB);
    }
    
    function _transfer(
        address from, 
        address to, 
        uint256 bombId
    ) internal override {
        require(bombStats[bombId].status != Status.DETONATED, "Bomb already detonated");

        bombStats[bombId].transfersLeft--;
        if (bombStats[bombId].transfersLeft == 0) {
            emit Detonate(bombId);
            bombStats[bombId].status = Status.DETONATED;
        }
        super._transfer(from, to, bombId);
    }

}