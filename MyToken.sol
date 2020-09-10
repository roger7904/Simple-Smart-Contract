pragma solidity ^0.4.16;


contract TokenERC20 {
    string public name;
    string public symbol;
    uint8 public decimals = 18;
    uint256 public totalSupply;

    // 陣列存放餘額
    mapping (address => uint256) public _balanceOf;
    mapping (address => mapping (address => uint256)) public _allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    event Burn(address indexed from, uint256 value);

    constructor() public {
        totalSupply = 1e4 * (1e18);  
        _balanceOf[msg.sender] = totalSupply;               
        name = "RogerToken";                                   
        symbol = "RG";                          
    }
    
    function totalSupply() public view returns(uint256){
        return totalSupply;
    }
    
    function balanceOf(address account) public view returns(uint256){
        return _balanceOf[account];
    }
    function _transfer(address _from, address _to, uint _value) internal {
        //避免轉帳到地址0x0，使用burn替代
        require(_to != 0x0);
        //確認餘額足夠
        require(_balanceOf[_from] >= _value);
        //避免溢位
        require(_balanceOf[_to] + _value > _balanceOf[_to]);
        _balanceOf[_from] -= _value;
        _balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        _transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= _allowance[_from][msg.sender]);
        _allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }
    
    function allowance(address owner,address spender) public view returns(uint256){
        return _allowance[owner][spender];
    } 
    
    function approve(address _spender, uint256 _value) public
        returns (bool success) {
        _allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }


    function burn(uint256 _value) public returns (bool success) {
        require(_balanceOf[msg.sender] >= _value);   
        _balanceOf[msg.sender] -= _value;           
        totalSupply -= _value;                      
        emit Burn(msg.sender, _value);
        return true;
    }


    function burnFrom(address _from, uint256 _value) public returns (bool success) {
        require(_balanceOf[_from] >= _value);                
        require(_value <= _allowance[_from][msg.sender]);    //確認額度
        _balanceOf[_from] -= _value;                        
        _allowance[_from][msg.sender] -= _value;            
        totalSupply -= _value;                             
        emit Burn(_from, _value);
        return true;
    }
}
