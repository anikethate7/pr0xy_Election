//SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract voting{
     struct Candidate {
        uint256 id;
        string name;
        uint256 numberofvotes;
     }
     Candidate[] public candidates;
     //This will be the voters address
     address public owner;

     //map all voter address
     mapping(address => bool) public voters;

     //list all user
     address[] public listofVoters;
     uint256 public votingStart;
     uint256 public votingEnd;

     bool public electionStarted;

     modifier onlyowner() {
        require(msg.sender == owner,"You are not authorized to start the election");
        _;
     }

     modifier electionongoing() {
        require(electionStarted,"No ELection Yet");
        _;
     }

     constructor() {
        owner = msg.sender;
     }

     function startElection(string[] memory _candidates, uint256 _votingDuration) public onlyowner {
      require(electionStarted == false, "Election ongoing");
      delete candidates;
      resetAllvoterStaus();

      for(uint256 i=0; i<_candidates.length;i++){
         candidates.push(
            Candidate({ id: i, name:_candidates[i],numberofvotes:0})
         );
      }
      electionStarted = true;
      votingStart = block.timestamp;
      votingEnd = block.timestamp + (_votingDuration * 1 minutes);

     }

     function addCandidate(string memory _name) public onlyowner electionongoing{
      require(checkElectionPeriod(), "Election period has been ended");
      candidates.push(
         Candidate({
            id: candidates.length,
            name: _name, 
            numberofvotes: 0
         })
      );     
     }

     function voterStatus(address _voter) public view electionongoing returns (bool){
      if(voters[_voter] == true){
         return true;
      }
      return false;
     }
     //vote function

     function voteTo(uint256 _id) public electionongoing{
      require(checkElectionPeriod(),"Election Period has been ended");
      require(!voterStatus(msg.sender),"You have Already Voted youcan only vote once");
      candidates[_id].numberofvotes++;
      voters[msg.sender] = true;
      listofVoters.push(msg.sender);
     }

     //no.of votes

     function retrieveVotes() public view returns (Candidate[] memory){
      return candidates;
     }


   function electionTimer() public view electionongoing returns (uint256) {
      if(block.timestamp >= votingEnd){
         return 0;
      }
      return (votingEnd - block.timestamp);
   }

   function checkElectionPeriod() public returns(bool){
      if(electionTimer() > 0){
         return true;
      }
      electionStarted = false;
      return false;
   }
   
   function resetAllvoterStaus() public onlyowner{
      for(uint256 i =0; i < listofVoters.length; i++){
         voters[listofVoters[i]] = false;
      }
      delete listofVoters;
   }
}