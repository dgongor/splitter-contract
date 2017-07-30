pragma solidity ^0.4.4;

contract Splitter {
	address	public 	owner;  // alice
	address	public 	bob;
	address public 	carol;

	uint	public	bobBalance;
	uint 	public 	carolBalance;

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
		if(msg.sender != owner) throw;
		
		var bobSplit = msg.value / 2;
		var carolSplit = msg.value - bobSplit;
		
		if( !bob.send(bobSplit) ) throw;
		bobBalance += bobSplit;
		
		if( !carol.send(carolSplit) ) throw;
        carolBalance += carolSplit;

		return true;
	}
}