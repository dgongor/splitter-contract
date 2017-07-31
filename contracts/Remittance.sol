pragma solidity ^0.4.4;

contract Remittance {
    address public owner;
    address public carol;
    
    uint public deadline;
    bool public submitted;
    bool public released;
    
    function Remittance(
        address _carol,
        uint _duration) 
    {
        if(_duration > 25) throw;
        
        owner = msg.sender;
        carol = _carol;
        deadline = block.number + _duration;
    }
    
    function compare(string _a, string _b) returns (int) {
        bytes memory a = bytes(_a);
        bytes memory b = bytes(_b);
        uint minLength = a.length;
        if (b.length < minLength) minLength = b.length;
    
        //@todo unroll the loop into increments of 32 and do full 32 byte comparisons
        for (uint i = 0; i < minLength; i ++) {
            if (a[i] < b[i]) return -1;
            else if (a[i] > b[i]) return 1;
        }
        
        if (a.length < b.length) return -1;
        else if (a.length > b.length) return 1;
        
        return 0;
    }
    
    function reclaimEther()
        payable
        returns (bool)
    {
        if(msg.sender != owner) throw;
        if(released) throw;
        if(!submitted) throw;
        if(block.number > deadline) throw;
        if(this.balance == 0) throw;
        
        if(!owner.send(this.balance)) throw;
        released = true;
        
        return true;
    }
    
    function submitEther()
        payable 
        returns (bool)
    {
        if(msg.sender != owner) throw;
        if(released) throw;
        if(submitted) throw;
        if(msg.value == 0) throw;
        
        submitted = true;
        
        return true;
    }
    
    function getBalance()
        constant
        returns (uint)
    {
        return this.balance; 
    }
    
    function releaseEther(
        string emailPassword,
        string smsPassword)
        payable
        returns (bool)
    {
        if(msg.sender != carol) throw;
        if(released) throw;
        if(!submitted) throw;
        if(compare("email1", emailPassword) != 0 && compare("sms1", smsPassword) != 0) throw;  
        
        if(!carol.send(this.balance)) throw;
        released = true;
        
        return true;
    }
	
}