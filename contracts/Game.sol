//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Game {
    // blueSide = mapping{ "players":array[5], "champions":array[5] }
    // redSide  = mapping{ "players":array[5], "champions":array[5] }
    // betsBlue = mapping { "block":block.number, "sender":sender.wallet, "amount":uint256 }
    // betsRed  = mapping { "block":block.number, "sender":sender.wallet, "amount":uint256 }
    // pot     = uint256 <- contract.balance in DAI
    // bluePot = uint256 <- sum(betsBlue."ammount")
    // redPot  = uint256 <- sum(bestRed."ammount")
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

    constructor()
}
