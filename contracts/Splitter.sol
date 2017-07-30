pragma solidity ^0.4.4;

contract Splitter {
    address public  alice;
	address	public 	bob;
	address public 	carol;

    struct SplitTx {
        address sender;
        uint amount;
    }
    
    SplitTx[] history;

	function Splitter(
		address _bob,
		address _carol) {

        alice = msg.sender;
		bob = _bob;
		carol = _carol;
	}
	
	function getContractBalance() 
	    constant
	    returns (uint)
	{
	    return this.balance;        
	}
	
	function getAliceBalance() 
	    constant
	    returns (uint) 
	{
	    return alice.balance;
	}
	
	function getBobBalance() 
	    constant
	    returns (uint)
	{
	    return bob.balance;        
	}
	
	function getCarolBalance() 
	    constant
	    returns (uint)
	{
	    return carol.balance;        
	}

	function split() 
		payable 
		returns (bool)
	{
		if(msg.sender != alice) throw;
		if(msg.value == 0) throw;
		
		var amount = msg.value / 2;
		
		var successBob = bob.send(amount);
		if(!successBob) throw;
		SplitTx memory bobTx;
		bobTx.sender = msg.sender;
		bobTx.amount = amount;
		history.push(bobTx);
		
		var successCarol = carol.send(amount);
		if(!successCarol) throw;
        SplitTx memory carolTx;
		carolTx.sender = msg.sender;
		carolTx.amount = amount;
		history.push(carolTx);

		return true;
	}
	
	function killSwitch() 
	    returns (bool) 
	{
	    selfdestruct(alice);
	    return true;
	}
	
}