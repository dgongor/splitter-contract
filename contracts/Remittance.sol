pragma solidity ^0.4.4;

contract Remittance {
    address public owner;
    address public carol;
    bool public validated;
    uint public amount;
    bool public released;
    
    function Remittance(
        address _carol) 
    {
        owner = msg.sender;
        carol = _carol;
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
    
    function releaseEther()
        payable 
        returns (bool success)
    {
        if(msg.sender != owner) throw;
        if(released) throw;
        if(!validated) throw;
        if(msg.value == 0) throw;
        
        amount = msg.value;
        if(!carol.send(amount)) throw;
        released = true;
        
        return true;   
    }
    
    function validateTransfer(
        string emailPassword,
        string smsPassword)
        returns (bool success)
    {
        if(msg.sender != carol) throw;
        if(released) throw;
        if(validated) throw;
        if(compare("email1", emailPassword) != 0 && compare("sms1", smsPassword) != 0) throw;  
        
        validated = true;
        
        return true;
    }
	
}