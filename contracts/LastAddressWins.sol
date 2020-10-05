pragma solidity >=0.4.16 <0.8.0;

contract LastAddressWins {
    uint public lastBlockNumber=0;
    address public lastComptetior;
    
    event Deposit(address indexed _from, uint256 _value);
    event Withdraw(address indexed _to, uint256 _value);

    function enterCompetition() public payable {
        require(msg.value > 0, "You need to send funds to enter the competiton!");
        lastBlockNumber = block.number;
        lastComptetior = msg.sender;
        emit Deposit(msg.sender, msg.value);
    }
    
    function withdrawFunds() public {
        require(block.number - lastBlockNumber >=5,"Funds are only withdrawable after 100 blocks");
        require(msg.sender==lastComptetior,"You need to be the last person to send funds to the contract in order to claim funds!");
        require(address(this).balance>0,"No funds to withdraw!");
        uint256 fundsToSend = address(this).balance;
        (bool success, ) = msg.sender.call{value:fundsToSend}("");
        require(success,"Sending failed!");
        emit Withdraw(msg.sender,fundsToSend);
    }
}