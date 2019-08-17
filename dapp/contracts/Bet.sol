pragma solidity ^0.5.2;

contract Bet{
    
  mapping(uint256=>uint256)private collctedFunds;
  mapping(uint256=>mapping(address=>bool))public allowed;
  mapping(uint256=>mapping(address=>bool))private claimedStatus;
  mapping(uint256=>uint256)private members;
  
  modifier isAllowed(uint256 _id){
      require(allowed[_id][msg.sender]==true,"You are not allowed to play the game");
      _;
  }
  modifier isClaimed(uint256 _id){
      require(claimedStatus[_id][msg.sender]==false,"You have already claimed your reward");
      _;
  }
  modifier memberLimit(uint256 _id){
      require(members[_id]<2,"Players limit exceeded");
      _;
  }
  function startBet(uint256 _id) payable external memberLimit(_id){
      require(msg.value>=0.01 ether && allowed[_id][msg.sender]==false);
      members[_id]+=1;
      allowed[_id][msg.sender]=true;
    collctedFunds[_id]+=msg.value;
      
  }
   
  function withdrawRewards(uint256 _id,address payable winner) isAllowed(_id) isClaimed(_id) public{
      claimedStatus[_id][winner]=true;
        uint amount=collctedFunds[_id];
        collctedFunds[_id]=0;
      winner.transfer(amount);
     
      
  }
    
    
}