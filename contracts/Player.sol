//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Player {
    struct Bet {
        address sender;
        uint256 amount;
    }

    Bet[] public winBets;
    Bet[] public loseBets;

    uint256 pot;
    uint256 winpot;
    uint256 losepot;

    bool inGame = false;

    error TransferFailed();

    // bets = array[ {mapping: "betAmount", sender: sender.address}]

    // pot     = uint256 <- contract.balance in DAI
    // winPot = uint256 <- sum(betsWin."amount")
    // losePot  = uint256 <- sum(bestLose."amount")

    // inGame = bool
    //
    // admins = array[] <- admin wallets
    // constructor (
    //      bluePlayers: [5 contracts],
    //      blueChampions: [5 addresses],
    //      redPlayers: [5 contracts],
    //      redChampions: [5 addresses],
    //      block.number,
    //      initialAmount: int )
    //      {
    //      betsBlue = {}
    //      betsRed = {}
    //      bluePot = 0
    //      redPot = 0
    //      pot = msg.value
    //      }

    constructor() {
        pot = 0;
        winpot = 0;
        losepot = 0;
        inGame = false;
    }

    function markInGame() public onlyowner {
        inGame = true;
    }

    function makeWinBet(uint256 amount) public {
        // check if player is in game
        require(inGame, "You can't make a bet while player is in a game");

        bool transfer = IERC20(token).transferFrom(
            msg.sender,
            address.this,
            amount
        );
        if (!transfer) revert TransferFailed();

        // add bet to bets array, increase value of pots
        winBets.push(Bet(msg.sender, amount));
        winpot += amount;
        pot += amount;
    }

    function makeLoseBet(uint256 amount) public {
        // check if player is in game
        require(inGame, "You can't make a bet while player is in a game");

        bool transfer = IERC20(token).transferFrom(
            msg.sender,
            address.this,
            amount
        );
        if (!transfer) revert TransferFailed();

        // add bet to bets array, increase value of pots
        loseBets.push(Bet(msg.sender, amount));
        losepot += amount;
        pot += amount;
    }

    function payoutWin() public onlyOwner {
        for (uint256 i = 0; i < bets.length; i++) {
            uint256 payout;
            payout = (bets[i].amount / winBets) * loseBets;
            IERC20(token).transfer(bets[i].sender, payout);
        }
        inGame = false;
    }
}
