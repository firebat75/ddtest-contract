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

    uint256 basePot = 0;
    uint256 winPot = 0;
    uint256 losePot = 0;

    bool inGame = false;

    error TransferFailed();

    // constructor() {
    //     basePot = 0;
    //     winPot = 0;
    //     losePot = 0;
    //     inGame = false;
    // }

    function markInGame() public onlyOwner {
        inGame = true;
    }

    function markNotInGame() public onlyOwner {
        inGame = false;
    }

    function addPot(uint256 amount, address token) public {
        bool transfer = IERC20(token).transferFrom(
            msg.sender,
            address(this),
            amount
        );
        if (!transfer) revert TransferFailed();

        basePot.add(amount);
    }

    function makeWinBet(uint256 amount, address token) public {
        // check if player is in game
        require(inGame, "You can't make a bet while player is ingame");

        bool transfer = IERC20(token).transferFrom(
            msg.sender,
            address(this),
            amount
        );
        if (!transfer) revert TransferFailed();

        // add bet to bets array, increase value of pots
        winBets.push(Bet(msg.sender, amount));
        winPot.add(amount);
    }

    function makeLoseBet(uint256 amount, address token) public {
        // check if player is in game
        require(inGame, "You can't make a bet while player is ingame");

        bool transfer = IERC20(token).transferFrom(
            msg.sender,
            address(this),
            amount
        );
        if (!transfer) revert TransferFailed();

        // add bet to bets array, increase value of pots
        loseBets.push(Bet(msg.sender, amount));
        losePot.add(amount);
    }

    function payoutWin(address token) public onlyOwner {
        for (uint256 i = 0; i < winBets.length; i++) {
            uint256 payout;
            payout = ((winBets[i].amount).mul(winBets[i].amount.div(winPot)))
                .mul(losePot + basePot);
            IERC20(token).transfer(winBets[i].sender, payout);
        }
        inGame = false;
    }

    function payoutLose(address token) public onlyOwner {
        for (uint256 i = 0; i < loseBets.length; i++) {
            uint256 payout;
            payout = ((loseBets[i].amount).mul(loseBets[i].amount.div(losePot)))
                .mul(winPot + basePot);
            IERC20(token).transfer(loseBets[i].sender, payout);
        }
        inGame = false;
    }

    function returnAllBets(address token) public onlyOwner {
        for (uint256 i = 0; i < winBets.length; i++) {
            IERC20(token).transfer(winBets[i].sender, winBets[i].amount);
        }
        for (uint256 i = 0; i < loseBets.length; i++) {
            IERC20(token).transfer(loseBets[i].sender, loseBets[i].amount);
        }

        IERC20(token).transfer(msg.sender, basePot);
    }
}
