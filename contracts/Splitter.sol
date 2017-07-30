pragma solidity ^0.4.4;

contract Splitter {
	address	public 	owner;
	address	public 	bob;
	address public 	carol;

	mapping(address => uint) public balances;

	function Splitter(
		address _bob,
		address _carol) {

		owner = msg.sender;
		bob = _bob;
		carol = _carol;
	}

	function split() 
		payable 
		returns (bool)
	{
		if(msg.value == 0) throw;
		if(msg.sender == bob || msg.sender == carol) throw;
		
		var bobSplit = msg.value / 2;
		var carolSplit = msg.value - bobSplit;
		
		if( !bob.send(bobSplit) ) throw;
		balances[bob] += bobSplit;

		if( !carol.send(carolSplit) ) throw;
        balances[carol] += carolSplit;

		return true;
	}
	
}