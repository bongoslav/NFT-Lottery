// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.24;

import {Test, console2} from "forge-std/Test.sol";
import {Ticket} from "../src/Ticket.sol";

contract TicketTest is Test {
    Ticket public ticket;

    address USER = makeAddr("user");
    string constant NAME = "Ticket";
    string constant SYMBOL = "TKT";

    function setUp() public {
        uint256 s_purchaseStartTime = block.timestamp;
        uint256 s_purchaseEndTime = block.timestamp + 60 seconds;
        ticket = new Ticket(NAME, SYMBOL, s_purchaseStartTime, s_purchaseEndTime);
        vm.deal(USER, 1 ether);
    }

    function test_buyTicket_InsufficientBalance() public {
        vm.startPrank(USER);
        vm.expectRevert(bytes("Not enough eth to buy a ticket"));
        ticket.buyTicket{value: 0}();
        vm.stopPrank();
    }

    function test_buyTicket_SufficientBalance() public {
        uint256 tokenId = 1;

        vm.startPrank(USER);
        ticket.buyTicket{value: USER.balance}();
        vm.stopPrank();

        assertTrue(ticket.ownerOf(tokenId) == USER, "Token was not minted to the correct owner");
    }

    function test_buyTicket_OutsidePurchaseWindow() public {
        vm.warp(ticket.purchaseStartTime() - 1); 

        vm.startPrank(USER);
        vm.expectRevert();
        ticket.buyTicket{value: USER.balance}();
        vm.stopPrank();
    }
}
