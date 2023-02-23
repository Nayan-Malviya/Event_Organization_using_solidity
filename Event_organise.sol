 //SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;
contract EventOrgan{
struct Event
{   address Organizer;
    string eventName;
    uint date;
    uint ticketPrice;
    uint ticketCount;
    uint ticketRemain;
}
mapping(uint=>Event) public eventsList;
mapping(address=>mapping(uint=>uint)) public tickets;
uint public nextid;
function createEvent(string memory name,uint date,uint price,uint ticketcount)external{
    require (date>block.timestamp,"You can Oraganise your Event For Future date");
    require (ticketcount>5,"ticketCount should be greator than 5 to organize a Event");

    eventsList[nextid]=Event(msg.sender,name,date,price,ticketcount,ticketcount);
    nextid++;
}
modifier datechcker(uint id){
    require(eventsList[id].date!=0,"Please Select any Event");
    require(eventsList[id].date>block.timestamp,"Event has Already Occured");
    _;
}
function buyTicket(uint id,uint quantity) external payable{
    require(eventsList[id].date!=0,"Please Select any Event");
    require(eventsList[id].date>block.timestamp,"Event has Already Occured");
    Event storage _event=eventsList[id];
    require(_event.ticketCount>=quantity,"Not enought Tickets Left");
    require(msg.value==(_event.ticketPrice*quantity),"Ethers are not Enough");
    _event.ticketRemain-=quantity;
    tickets[msg.sender][id]+=quantity;
}
function transferTicker(uint id ,uint quantity,address toT) external datechcker(id){
    require(tickets[msg.sender][id]>=quantity,"You do not have enough Tickets to Transfer");
    tickets[msg.sender][id]-=quantity;
    tickets[toT][id]+=quantity;
}
}
