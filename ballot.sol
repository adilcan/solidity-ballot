pragma solidity ^0.4.24;

contract Ballot {
    
    struct Voter {
        address voterAddress;
        bool isVoted;
        bool isSigned;
        bool isAdult;
    }
    
    struct Candidate {
        address candidateAddress;
        bytes32 name;
        uint32 voteCount;
    }
    
    struct Nominee {
        address nomineeAddress;
        bytes32 name;
        uint32 signCount;
        bool isNomineed;
    }
    
    mapping(address => Voter) voters;
    Nominee[] nominees;
    Candidate[] candidates;

    uint totalVoteCount;
    // 06/24/2018 08.00 unix timestamp
    uint constant startTime = 1529827200;
    // 06/24/2018 17.00 unix timestamp
    uint constant endTime = 1529859600;
    
    function beNominee(string _origin, bytes32 _name, uint8 _age, bool _isGrad, uint _numOfPeriods){
        require(keccak256(_origin) == keccak256("TC"),
        "You should be a citizen of Republic of Turkey");
        
        require(_age >= 40,
        "You should be at least 40 years old.");
        
        require(_isGrad,
        "You should be graduated from a university.");
        
        require(_numOfPeriods < 2,
        "You can't be nominee for president if you've done the service for 2 periods.");
        
        Nominee nom;
        nom.name = _name;
        nom.nomineeAddress = msg.sender;
        nominees.push(nom);
    }
    
    function sign(uint _nomineeIndex) {
        
        Voter storage signer = voters[msg.sender];
        
        require(!signer.isSigned,
        "You already signed");
        
        require(signer.isAdult,
        "Only adults allowed to vote.");
        
        signer.isSigned = true;
        
        Nominee nominee = nominees[_nomineeIndex];
        
        nominee.signCount = nominee.signCount + 1;
    }
    
    function claimCandidate(uint _nomineeIndex) {
        Nominee nominee = nominees[_nomineeIndex];
        
        require(nominee.signCount > 100000,
        "You should get at least 100000 votes to be candidate.");
        Candidate candidate;
        candidate.name = nominee.name;
        candidate.candidateAddress = nominee.nomineeAddress;
        candidates.push(candidate);
        
    }

    function vote(uint _candidateIndex) {
        
        Voter storage sender = voters[msg.sender];
        
        require(_candidateIndex < candidates.length,
        "Not a valid candidate index.");

        require(now > startTime && now < endTime,
        "You should vote between start time and end time");
        
        require(sender.isAdult,
        "Only adults allowed to vote.");
        
        require(!sender.isVoted,
        "You already voted.");
        
        sender.isVoted = true;
        
        totalVoteCount = totalVoteCount + 1;
        
        Candidate storage candidate = candidates[_candidateIndex];
        candidate.voteCount = candidate.voteCount +1;
        
        
    }
    
    function announceWinner() returns (address) {
        require(now > endTime,
        "Wait until end time");
        
        for(uint i = 0; i < candidates.length; i++) {
            
            uint candidateVoteCount = candidates[i].voteCount;
            
            if((totalVoteCount/2) < candidateVoteCount){
                return candidates[i].candidateAddress;
                break;
            }
            
        }
    }
    
    
}
