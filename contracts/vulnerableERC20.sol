pragma solidity ^0.6.0;

contract VulnerableToken {
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    event AssertionFailed(string message);

    struct vars0 {
        uint256 old_0;
        uint256 old_1;
        uint256 old_2;
    }

    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    constructor() public {
        _totalSupply = 1000000;
        _balances[msg.sender] = 1000000;
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _owner) external view returns (uint256) {
        return _balances[_owner];
    }

    function allowance(address _owner, address _spender) external view returns (uint256) {
        return _allowances[_owner][_spender];
    }

    function transfer(address _to, uint256 _value) external returns (bool RET_0) {
        vars0 memory _v;
        _v.old_0 = _balances[_to];
        _v.old_1 = _balances[msg.sender];
        _v.old_2 = _balances[_to];
        RET_0 = _original_VulnerableToken_transfer(_to, _value);
        if (!((!(_to != msg.sender)) || (_balances[_to] == (_v.old_0 + _value)))) {
            emit AssertionFailed("0: ");
            assert(false);
        }
        if (!((!(_to != msg.sender)) || (_balances[msg.sender] == (_v.old_1 - _value)))) {
            emit AssertionFailed("1: ");
            assert(false);
        }
        if (!((!(_to == msg.sender)) || (_balances[msg.sender] == _v.old_2))) {
            emit AssertionFailed("2: sending to self doesn't mutate asnything");
            assert(false);
        }
        if (!(_balances[msg.sender] >= _value)) {
            emit AssertionFailed("3: ");
            assert(false);
        }
    }

    function _original_VulnerableToken_transfer(address _to, uint256 _value) private returns (bool) {
        address from = msg.sender;
        require(_value <= _balances[from]);
        uint256 newBalanceFrom = _balances[from] - _value;
        uint256 newBalanceTo = _balances[_to] + _value;
        _balances[from] = newBalanceFrom;
        _balances[_to] = newBalanceTo;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) external returns (bool) {
        address owner = msg.sender;
        _allowances[owner][_spender] = _value;
        emit Approval(owner, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {
        uint256 allowed = _allowances[_from][msg.sender];
        require(_value <= allowed);
        require(_value <= _balances[_from]);
        _balances[_from] -= _value;
        _balances[_to] += _value;
        _allowances[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
}