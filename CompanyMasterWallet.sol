pragma solidity ^0.4.0;
import "StringUtils";

contract CompanyMasterWallet{
    address public creator;
    address user;
    address public user1;
    address public user2;
    address public user3;
    string month;
    
    mapping (address => uint) public balances;
    mapping (address => uint) public claimAmount;
    mapping (address => uint) public count;
    mapping (address => uint) public salary;

    event Paid(address from, address to , uint token);
    event Claimed(address from, uint token);

    function CompanyMasterWallet(uint token){
        creator = msg.sender;
        balances[creator] = token;
    }
    
    //This function creates the UserWallet based on an id which can be generated or
    //can be taken from input along with initialSalary. 
    
    function createUserWallet(address receiver, uint salaryInitial, uint id){
        if(msg.sender!=creator) throw;
        salary[receiver] = salaryInitial;
        if(id ==1) user1 = receiver;
        if(id ==2) user2 = receiver;
        if(id ==3) user3 = receiver;
    }
    
    function pay(address receiver){
        uint token =salary[receiver];
        if(balances[msg.sender]<token) throw;
        balances[msg.sender] -= token;
        claimAmount[receiver] += token;
        Paid(msg.sender,receiver,token);
    }

    //The  month can be taken from timestamps and then decoded to get the accurate the values, this is just an implementation of how its done. 
    
    function claim(uint id, uint amount, string month){
        if(id == 1) user =user1;
        if(id == 2) user =user2;
        if(id == 3) user =user3;
        if(id>3 || msg.sender!=user || count[user]>3 ||claimAmount[user]<amount ) throw;
        balances[user] +=  amount;
        claimAmount[user]-=amount;
        Claimed(user,amount);
        count[user]+=1;
        if(StringUtils.equal(month,"new")) {
            count[user] = 0;
            month = "old";
        }
    }
    
    function raise(address employee, uint amount){
        if(msg.sender!=creator) throw;
        salary[employee] += amount;
    }
    
    function quit(uint id){
        if(msg.sender!=creator) throw;
        if(id == 1) {user =user1;user1=0;}
        if(id == 2) {user =user2; user2=0;}
        if(id == 3) {user =user3; user3 = 0;}
        balances[user] += claimAmount[user];
        claimAmount[user] = 0;
        salary[user]=0;
        count[user]=0;
    }
}