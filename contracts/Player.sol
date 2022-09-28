//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Player is Ownable {
    using SafeMath for uint256;

    struct Bet {
        address sender;
        uint256 amount;
    }

    Bet[] public winBets;
    Bet[] public loseBets;

    uint256 pot;
    uint256 winPot;
    uint256 lostPot;

    bool inGame = false;

    error TransferFailed();

    constructor() {
        pot = 0;
        winPot = 0;
        lostPot = 0;
        inGame = false;
    }

    function markInGame() public onlyOwner {
        inGame = true;
    }

    function makeWinBet(uint256 amount) public {
        // check if player is in game
        require(inGame, "You can't make a bet while player is ingame");

        bool transfer = IERC20(token).transferFrom(
            msg.sender,
            address.this,
            amount
        );
        if (!transfer) revert TransferFailed();

        // add bet to bets array, increase value of pots
        winBets.push(Bet(msg.sender, amount));
        winPot.add(amount);
        pot.add(amount);
    }

    function makeLoseBet(uint256 amount) public {
        // check if player is in game
        require(inGame, "You can't make a bet while player is ingame");

        bool transfer = IERC20(token).transferFrom(
            msg.sender,
            address.this,
            amount
        );
        if (!transfer) revert TransferFailed();

        // add bet to bets array, increase value of pots
        loseBets.push(Bet(msg.sender, amount));
        lostPot.add(amount);
        pot.add(amount);
    }

    function payoutWin() public onlyOwner {
        for (uint256 i = 0; i < winBets.length; i++) {
            uint256 payout;
            payout = (winBets[i].amount.div(winBets)).mul(loseBets);
            IERC20(token).transfer(winBets[i].sender, payout);
        }
        inGame = false;
    }

    function payoutWin() public onlyOwner {
        for (uint256 i = 0; i < loseBets.length; i++) {
            uint256 payout;
            payout = (loseBets[i].amount.div(loseBets)).mul(winBets);
            IERC20(token).transfer(loseBets[i].sender, payout);
        }
        inGame = false;
    }

    function returnAllBets() public onlyOwner {
        for (uint256 i = 0; i < winBets.length; i++) {
            // uint256 payout;
            // payout = (bets[i].amount / winBets) * loseBets;
            IERC20(token).transfer(winBets[i].sender, winBets[i].amount);
        }
        for (uint256 i = 0; i < loseBets.length; i++) {
            // uint256 payout;
            // payout = (bets[i].amount / winBets) * loseBets;
            IERC20(token).transfer(loseBets[i].sender, loseBets[i].amount);
        }
    }
}
