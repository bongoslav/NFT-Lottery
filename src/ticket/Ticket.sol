// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// TODO: deploy script
// TODO: select & reward winner
// TODO: add NatSpec
contract Ticket is ERC721 {
    uint256 private constant SURPRISE_WINNER_REWARD_PERCENTAGE = 50;
    uint256 private constant TICKET_PRICE = 1 ether;

    uint256 private _tockenCounter;

    uint256 public immutable purchaseStartTime;
    uint256 public immutable purchaseEndTime;

    mapping(uint256 => address) public ticketOwners;
    mapping(uint256 => uint256) public ticketPrices;

    uint256 public prizePool;
    address public winner;

    event TicketPurchased(uint256 indexed _tokenId, address indexed _buyer);

    modifier onlyDuringPurchaseWindow() {
        require(
            block.timestamp >= purchaseStartTime && block.timestamp <= purchaseEndTime,
            "Ticket: Purchase window closed"
        );
        _;
    }

    constructor(
        string memory name,
        string memory symbol,
        uint256 _purchaseStartTime,
        uint256 _purchaseEndTime
    ) ERC721(name, symbol) {
        purchaseStartTime = _purchaseStartTime;
        purchaseEndTime = _purchaseEndTime;
    }

    function buyTicket() external payable onlyDuringPurchaseWindow {
        require(msg.value == TICKET_PRICE, "Not enough eth to buy a ticket");

        _tockenCounter++;
				// @audit tokenURI instead of tokenId ?
        uint256 tokenId = _tockenCounter;
        _safeMint(msg.sender, tokenId);

        // Additional logic for handling ticket purchase (e.g., updating ticketOwners, ticketPrices, and prizePool)

        emit TicketPurchased(tokenId, msg.sender);
    }

    function pickRandomWinner() private view {}

    function rewardWinner() public payable {
        // payable(winner).transfer(prizePool * SURPRISE_WINNER_REWARD_PERCENTAGE / 100, address(this));
    }
}
