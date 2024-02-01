// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import {Ticket} from "../src/Ticket.sol";
import {console} from "forge-std/console.sol";
import {WinnerPicker} from "../src/WinnerPicker.sol";

contract DeployTicket is Script {
    uint256 public deployerKey;
    uint256 public DEFAULT_ANVIL_PRIVATE_KEY =
        0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;

    function run() external returns (Ticket) {
        if (block.chainid == 31337) {
            deployerKey = DEFAULT_ANVIL_PRIVATE_KEY;
        } else {
            deployerKey = vm.envUint("PRIVATE_KEY");
        }

				WinnerPicker winnerPicker = new WinnerPicker(); // TODO: pass the arguments from network config

        vm.startBroadcast(deployerKey);
        Ticket ticket = new Ticket(
            "Ticket", "TKT", block.timestamp, block.timestamp + 60 seconds, address(winnerPicker)
        );
        vm.stopBroadcast();
        return ticket;
    }
}
