pragma solidity =0.5.15;

import '../TrueswapERC20.sol';

contract ERC20 is TrueswapERC20 {
    constructor(uint _totalSupply) public {
        _mint(msg.sender, _totalSupply);
    }
}
