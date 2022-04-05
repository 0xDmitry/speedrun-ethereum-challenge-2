pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

    event SellTokens(
        address seller,
        uint256 amountOfETH,
        uint256 amountOfTokens
    );

    YourToken public yourToken;

    uint256 public constant tokensPerEth = 100;

    constructor(address tokenAddress) {
        yourToken = YourToken(tokenAddress);
    }

    function buyTokens() public payable {
        uint256 amountOfTokens = msg.value * tokensPerEth;
        yourToken.transfer(msg.sender, amountOfTokens);

        emit BuyTokens(msg.sender, msg.value, amountOfTokens);
    }

    // function withdraw() public onlyOwner {
    //     uint256 amount = address(this).balance;
    //     (bool success, ) = owner().call{value: amount}("");
    //     require(success, "Failed to send Ether");
    // }

    function sellTokens(uint256 amount) public {
        yourToken.transferFrom(msg.sender, address(this), amount);

        uint256 amountOfEth = amount / tokensPerEth;
        (bool success, ) = msg.sender.call{value: amountOfEth}("");
        require(success, "Failed to send Ether");

        emit SellTokens(msg.sender, amountOfEth, amount);
    }
}
