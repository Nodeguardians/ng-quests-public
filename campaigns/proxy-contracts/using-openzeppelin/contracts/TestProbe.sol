// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract TestProbe {

    bytes32 private constant LASER_HASH = keccak256("KSHAAAKKKKKK!!!");
    PowerSource A;
    PowerSource B;

    constructor() {
        A = new PowerSource();
        B = new PowerSource();
    }

    function test1(UltimateSuit target) external payable {
        require(msg.value == 150 gwei);

        require(target.totalEnergy() == 0);
        A.offerPower{ value: 50 gwei }(target);
        B.offerPower{ value: 50 gwei }(target);
        require(target.totalEnergy() == 100 gwei);
        require(target.energyAmount(address(A)) == 50 gwei);
        require(target.energyAmount(address(B)) == 50 gwei);
    
        try target.fireLaser() {
            revert();
        } catch {
            // Do nothing
        }
        
        A.offerPower{ value: 50 gwei }(target);
        require(target.totalEnergy() == 150 gwei);
        require(target.energyAmount(address(A)) == 100 gwei);
        require(target.fireLaser() == LASER_HASH);
        
    }

    function test2(UltimateSuit target) external payable {
        require(msg.value == 250 gwei);

        A.offerPower{ value: 50 gwei }(target);
        B.offerPower{ value: 100 gwei }(target);

        require(B.withdrawPower(target) == 100 gwei);
        require(target.totalEnergy() == 50 gwei);
        require(target.energyAmount(address(B)) == 0);
        
        try target.fireLaser() {
            revert();
        } catch {
            // Do nothing
        }

        B.offerPower{ value: 100 gwei }(target);
        require(target.fireLaser() == LASER_HASH);

        try B.withdrawPower(target) {
            revert();
        } catch {
            // Do nothing
        }

        require(target.totalEnergy() == 0);
        
    }

}

contract PowerSource {

    function offerPower(UltimateSuit target) external payable {
        target.offerPower{ value: msg.value }();
    }

    function withdrawPower(UltimateSuit target) external returns (uint256) {
        uint256 initialFunds = address(this).balance;
        target.withdrawPower();
        return address(this).balance - initialFunds;
    }

    receive() external payable { }

}

interface UltimateSuit {

    function totalEnergy() external returns (uint256);
    function energyAmount(address) external returns (uint256);
    function offerPower() external payable;
    function withdrawPower() external;
    function fireLaser() external returns (bytes32);

}