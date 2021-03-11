pragma solidity =0.5.15;

import './interfaces/ITrueswapFactory.sol';
import './TrueswapPair.sol';

contract TrueswapFactory is ITrueswapFactory {
    address public feeTo;
    address public feeToSetter;

    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs;

    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    constructor(address _feeToSetter) public {
        feeToSetter = _feeToSetter;
    }

    function allPairsLength() external view returns (uint) {
        return allPairs.length;
    }

    function createPair(address tokenA, address tokenB) external returns (address pair) {
        require(tokenA != tokenB, 'Trueswap: IDENTICAL_ADDRESSES');
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'Trueswap: ZERO_ADDRESS');
        require(getPair[token0][token1] == address(0), 'Trueswap: PAIR_EXISTS'); // single check is sufficient
        bytes memory bytecode = type(TrueswapPair).creationCode;
        // @TRONMOD
        // salt not needed for create operation
        // bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        assembly {
            // @TRONMOD
            // pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
            // @TODO: ensure changing create2 to create doesn't alter logic
            pair := create(0, add(bytecode, 32), mload(bytecode))
        }
        ITrueswapPair(pair).initialize(token0, token1);
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);
        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    function setFeeTo(address _feeTo) external {
        require(msg.sender == feeToSetter, 'Trueswap: FORBIDDEN');
        feeTo = _feeTo;
    }

    function setFeeToSetter(address _feeToSetter) external {
        require(msg.sender == feeToSetter, 'Trueswap: FORBIDDEN');
        feeToSetter = _feeToSetter;
    }
}
