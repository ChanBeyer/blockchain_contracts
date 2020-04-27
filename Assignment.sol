/**********************************************************************;
* Project           : Wedding Contract, Assignment 3
*
* Program name      : Assignment.sol
*
* Author            : Ignacio Puche Lara, Jérémy Puertolas, Chandler Beyer, Alexander Hofmann
*
* Date created      : 20191103
**********************************************************************/
pragma solidity >=0.4.22 <0.7.0;
import "./DateTime.sol";
import "./Guest.sol";

contract WeddingContract {
  // The time the Contractors have to start the ceremony after the wedding date has passed
  uint constant WEDDING_TIME_IN_SECONDS = 3600;

  address public Contractor1;
  address public Contractor2;

  // Date the wedding starts (UTC Time)
  uint weddingDate;
  // Date until the guest can accept the invitation (UTC Time)
  uint invitationDeadline;

  // Message said by the priest
  string message = "If anyone has an objection to these two being married, speak now of forever hold your peace.";

  // The Invitation
  string ticket = "You are invited to our wedding!";


  enum State { Created, Proposal , Canceled,  Denied , Engaged, Ceremony, Priest, Voting, Married , Failure }
  // State of the contract
  State public state;

  // List with all guests
  mapping(address => GuestLibrary.Guest) private guests;
  // Array of all guest addresses
  address[] private guestsAddresses;


  // Called by the Contractor1
  constructor() public {
    Contractor1 = msg.sender;
    state = State.Created;
  }


  // Define a modifier for a function that only the Contractor1 can call
  modifier onlyContractor1() {
    require( msg.sender == Contractor1 , "Only Contractor1 can call this.");
    _;
  }

  // Define a modifier for a function that only the Contractor2 can call
  modifier onlyContractor2() {
    require( msg.sender == Contractor2 , "Only Contractor2 can call this.");
    _;
  }

  // Define a modifier for a function that only Contractor1 or Contractor2 can call
  modifier onlyContractors() {
    require( (msg.sender == Contractor1) || (msg.sender == Contractor2) ,
    "Only Contractors can call this.");
    _;
  }

  // Define a modifier for a function that only Attendees (Contractor1, Contractor2 or Guests) can call
  modifier onlyAttendees(){
    require( (msg.sender == Contractor1) || (msg.sender == Contractor2) || (checkIfGuest(msg.sender)) ,
    "Only Attendees can call this.");
    _;
  }

  // Define a modifier for a function that only Guests can call
  modifier onlyGuests() {
    require( checkIfGuest(msg.sender) , "Only Guests can call this.");
    _;
  }

  // Define a modifier for a function that only Entered Guests in the wedding can call
  modifier onlyEnteredGuests() {
    require( checkIfEntered(msg.sender) , "Only entered guests can call this.");
    _;
  }
  //Define a modifier for a function that is in the specified state
  modifier inState(State _state) {
    require( state == _state , "Invalid state.");
    _;
  }

  // Define a modifier for a function that checks if the function is called on the wedding date
  modifier isWeddingDate(){
    require(weddingDate <= now && now <= (weddingDate + WEDDING_TIME_IN_SECONDS) , "Currently it is not the time of the wedding!");
    _;
  }

  // Returns if the given address is part of the quest list ignoring the InvitationStatus
  function checkIfGuest(address paramAddress) private view returns (bool) {
    for (uint i=0; i< guestsAddresses.length ; i++) {
      if (guestsAddresses[i] == paramAddress){
        return true;
      }
    }
    return false;
  }

  // Returns if the guests with the specified address has entered the ceremony.
  function checkIfEntered(address paramAddress) public view returns (bool){
    if(guests[paramAddress].ticketStatus == GuestLibrary.TicketStatus.Entered ){
      return true;
    }
    return false;
  }

  // Set the address of second Contractor after the contract has been created
  function setContractor(address paramContractor2) public onlyContractor1() inState(State.Created) {
    require( Contractor2 != paramContractor2 , "No valid address provided.");
    Contractor2 = paramContractor2;
  }

  // Set the wedding date after the contract has been created (UTC Time)
  function setWeddingDate(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second)
  public onlyContractor1() inState(State.Created) {
    // Converte the date into a timestamp
    uint timestamp = DateTimeLibrary.toTimestamp(year, month, day, hour, minute, second);
    setWeddingDate(timestamp);
  }


  function setWeddingDate(uint paramweddingDate) private inState(State.Created) {
    require(paramweddingDate > now , "The wedding date must be in the future.");
    weddingDate = paramweddingDate;
  }

  function getWeddingDate() private view returns (uint) {
    require(weddingDate > 0 , "The wedding date is not set");
    return weddingDate;
  }

  // Returns the wedding date
  function printWeddingDate() public onlyContractors() view returns (uint16 year, uint8 month,
     uint8 day, uint8 hour, uint8 minute, uint8 second) {
    require(weddingDate > 0 , "The wedding date is not set");
    year = DateTimeLibrary.getYear(weddingDate);
    month = DateTimeLibrary.getMonth(weddingDate);
    day = DateTimeLibrary.getDay(weddingDate);
    hour = DateTimeLibrary.getHour(weddingDate);
    minute = DateTimeLibrary.getMinute(weddingDate);
    second = DateTimeLibrary.getSecond(weddingDate);
  }

  // Set the invitation deadline after the contract has been created (UTC Time)
  function setInvitationDeadline(uint16 year, uint8 month, uint8 day, uint8 hour,
    uint8 minute, uint8 second) public onlyContractor1() inState(State.Created) {
    uint timestamp = DateTimeLibrary.toTimestamp(year, month, day, hour, minute, second);
    setInvitationDeadline(timestamp);
  }

  function setInvitationDeadline(uint paramInvitationDeadline) private inState(State.Created) {
    require(paramInvitationDeadline > now , "The invitation deadline must be in the future.");
    invitationDeadline = paramInvitationDeadline;
  }

  function getInvitationDeadline() private view returns (uint) {
    require(invitationDeadline > 0 , "The invitation date is not set");
    return invitationDeadline;
  }

  // Returns the invitation deadline
  function printInvitationDeadline() public onlyAttendees() view returns (uint16 year, uint8 month,
     uint8 day, uint8 hour, uint8 minute, uint8 second) {
    require(invitationDeadline > 0 , "The invitation date is not set");
    year = DateTimeLibrary.getYear(invitationDeadline);
    month = DateTimeLibrary.getMonth(invitationDeadline);
    day = DateTimeLibrary.getDay(invitationDeadline);
    hour = DateTimeLibrary.getHour(invitationDeadline);
    minute = DateTimeLibrary.getMinute(invitationDeadline);
    second = DateTimeLibrary.getSecond(invitationDeadline);
  }

  // Add a guest when the contract is created
  function addGuest(uint8 paramName, address paramGuestAddress) public onlyContractor1() inState(State.Created)
  {
    // Check if the guest has been invited already
    require(!checkIfGuest(paramGuestAddress), "Guest is already in the list");
    // Add the guest object to a mapping
    guests[paramGuestAddress] = GuestLibrary.Guest({name: paramName, invitationStatus: GuestLibrary.InvitationStatus.Invited, ticketStatus: GuestLibrary.TicketStatus.Locked, voteStatus: GuestLibrary.VoteStatus.NotVoted});
    // Add the guest address to the array guestsAddresses
    guestsAddresses.push(paramGuestAddress);
  }

  // Delete a guest before the contract is proposed
  function deleteAllGuests() public onlyContractor1() inState(State.Created) {
    for (uint i=guestsAddresses.length ; i>0 ; i--) {
      delete guests[guestsAddresses[i-1]];
      delete guestsAddresses[i-1];
   }
 }

  // Get a list of all guest addresses
  function getGuests() public onlyContractors() view returns (address[] memory)
  {
    return guestsAddresses;
  }

  // Get a list of all addresses of guests that have accepted the invitation
  function getAcceptedGuests() public onlyContractors() view returns (address[] memory)
  {
    address[] memory acceptedGuests = new address[](guestsAddresses.length);

    for (uint i=0; i< guestsAddresses.length ; i++) {
      if (guests[guestsAddresses[i]].invitationStatus == GuestLibrary.InvitationStatus.Accepted) {
        acceptedGuests[i] = guestsAddresses[i];
      }
    }
    return acceptedGuests;
  }

  // After all parameters of the contract has been set, Contractor1 will call the function
  // to propose the contract to Contractor2
  function sendProposal() public onlyContractor1() inState(State.Created)
  {
    require(weddingDate > 0, "The wedding date has not been set");
    require(invitationDeadline > 0, "The invitation deadline has not been set");
    require(Contractor2 != 0x0000000000000000000000000000000000000000, "The contractor 2 has not been set");
    require(invitationDeadline < weddingDate, "The invitation deadline must be before the wedding date");
    state = State.Proposal;
  }

  // Contractor1 can cancel the contract before Contractor2 has accepted the Proposal by calling this function
  function cancelProposal() public onlyContractor1() inState(State.Proposal)
  {
    state = State.Canceled;
  }

  // Contractor2 can accept or deny the contract of Contractor1
  function acceptProposal(bool confirmation) public onlyContractor2() inState(State.Proposal)
  {
    if(confirmation == true) {
      // The contract is valid and the coupe is engaged
      state = State.Engaged;
    } else {
      // The contract is terminated
      state = State.Denied;
    }
  }

  // This function can be called by everyone to check if they are invited
  function checkInviatationStatus () public view returns (GuestLibrary.InvitationStatus invitationStatus)
  {
    if(checkIfGuest(msg.sender)){
      return guests[msg.sender].invitationStatus;
    } else {
      return GuestLibrary.InvitationStatus.Not_Invited;
    }
  }

  // Guests can check their ticketStatus by calling this function
  function checkTicketStatus () public onlyGuests() view returns (GuestLibrary.TicketStatus ticketStatus)
  {
    return guests[msg.sender].ticketStatus;
  }

  // A invited guest can accept or reject their invitation by calling this function
  // until the invitation deadline is over
  function acceptInvitation (bool accept) public onlyGuests() inState(State.Engaged) returns (string memory) {
    require(guests[msg.sender].invitationStatus == GuestLibrary.InvitationStatus.Invited,
      "Not invited to the wedding or already accepted/denied.");
    require(getInvitationDeadline() > now, "The acceptance deadline is over.");
    if (accept == true) {
      guests[msg.sender].invitationStatus = GuestLibrary.InvitationStatus.Accepted;
      return ticket;
    }
    else {
      guests[msg.sender].invitationStatus = GuestLibrary.InvitationStatus.Denied;
      return "";
    }
  }

  // As soon as the wedding date has come, the Contractors can call this function to start the Ceremony
  // Afterward this function is called, no one can enter the ceremony anymore.
  // The Contractors have WEDDING_TIME_IN_SECONDS to do so.
  function startCeremony() public onlyContractors() isWeddingDate() inState(State.Engaged) {
     for (uint i=0 ; i<guestsAddresses.length ; i++) {
       if (guests[guestsAddresses[i]].ticketStatus == GuestLibrary.TicketStatus.Entered ){
        state = State.Ceremony;
        return;
       }
    }
    require(false, "The ceremony cannot starts without the guests.");
  }

  // This function is called by the contract in order to release the Priest's message
  function startPriest() public onlyContractors() inState(State.Ceremony){
    state = State.Priest;
  }

  // Get the message from the Priest by calling this function
  function showMessage() public view onlyGuests() inState(State.Priest) returns (string memory){
      return message;
  }

  // The Guest can vote for the	marriage if an objection was raised by calling this function
  function voteFor() public onlyGuests() inState(State.Voting){
    require(guests[msg.sender].ticketStatus == GuestLibrary.TicketStatus.Entered, "The guest has not entered");
    guests[msg.sender].voteStatus = GuestLibrary.VoteStatus.For;
    guests[msg.sender].ticketStatus = GuestLibrary.TicketStatus.Voted;
  }

  // The Guest can vote against the	marriage if an objection was raised by calling this function
  function voteAgainst() public onlyGuests() inState(State.Voting){
    require(guests[msg.sender].ticketStatus == GuestLibrary.TicketStatus.Entered, "The guest has not entered");
    guests[msg.sender].voteStatus = GuestLibrary.VoteStatus.Against;
    guests[msg.sender].ticketStatus = GuestLibrary.TicketStatus.Voted;
  }

  // This function is called by the contractors in order to finish the wedding.
  // It can be called after priest statement or after the voting has taken place.
  function finishWedding() public onlyContractors(){
    require(state == State.Voting || state == State.Priest, "We are neither in Voting nor Ceremony state.");
    uint againstCounter = 0;
    uint forCounter = 0;
    uint notVotedCounter = 0;
    if(state == State.Voting){
      (againstCounter, forCounter, notVotedCounter) = countVotes();
      // All guests are required to vote
      if(notVotedCounter == 0)
      {
        // If there are more votes for the marriage than against, then the couple is Married.
        if( forCounter >= againstCounter ){
          state = State.Married;
        // If there are more votes against the marriage than for, then the whole ceremony will stop.
        } else if (againstCounter > forCounter){
          state = State.Failure;

      } else {
        require(notVotedCounter == 0, "Not everyone has voted");
      }
    } else if (state == State.Priest){
      state = State.Married;
    }
   }
  }

   //This fucntion returns the number of votes for each category
   function countVotes() private returns (uint againstCounter, uint forCounter, uint notVotedCounter)
   {
     againstCounter = 0;
     forCounter = 0;
     notVotedCounter = 0;

     for (uint i=0 ; i<guestsAddresses.length ; i++) {
       if (guests[guestsAddresses[i]].voteStatus == GuestLibrary.VoteStatus.Against ){
         againstCounter = againstCounter + 1;
       }
       if (guests[guestsAddresses[i]].voteStatus == GuestLibrary.VoteStatus.For ){
         forCounter = forCounter + 1;
       }
       if (guests[guestsAddresses[i]].voteStatus == GuestLibrary.VoteStatus.NotVoted ){
         notVotedCounter = notVotedCounter + 1;
       }
     }
     return (againstCounter,forCounter,notVotedCounter);
   }

   // This function is called by the Contractors to allow the guests who arrive at the wedding to check-in
  function unlockTicket(uint guestId) public onlyContractors()
  {
   address[] memory acceptedGuests = getAcceptedGuests();
    require(guestId >= 0 &&  guestId < acceptedGuests.length, "The guestId needs to be inside the boundaries.");
    unlockTicket(acceptedGuests[guestId]);
  }

  // This function is called by the Contractors to allow the guests who arrive at the wedding to check-in
  function unlockTicket(address guestAddress) public onlyContractors() {
    require(checkIfGuest(guestAddress), "The guest was not invited.");
    require(guests[guestAddress].invitationStatus == GuestLibrary.InvitationStatus.Accepted, "The attendee has not accepted the invitation.");
    require(guests[guestAddress].ticketStatus == GuestLibrary.TicketStatus.Locked, "The ticket is not locked.");
    guests[guestAddress].ticketStatus = GuestLibrary.TicketStatus.Unlocked;
  }

  // Guest call this function to get into the wedding after their ticket has been unlocked by the contractors
  function validateTicket() public onlyGuests()
  {
    require(checkIfGuest(msg.sender), "The guest was not invited.");
    require(guests[msg.sender].invitationStatus == GuestLibrary.InvitationStatus.Accepted, "The attendee has not accepted the invitation.");
    require(guests[msg.sender].ticketStatus == GuestLibrary.TicketStatus.Unlocked, "The ticket is not unlocked.");
    guests[msg.sender].ticketStatus = GuestLibrary.TicketStatus.Used;
  }

  // Contractors can call this function to check if a guest has checked-in
  function finalCheckIn(uint guestId) public onlyContractors() returns (bool) {
    return finalCheckIn(guestsAddresses[guestId]);
  }

  // Contractors can call this function to check if a guest has checked-in
  function finalCheckIn(address guestAddress) public onlyContractors() returns (bool){
    require(checkIfGuest(guestAddress), "The address does not correspond to any guest.");
    if(guests[guestAddress].ticketStatus == GuestLibrary.TicketStatus.Used){
      guests[guestAddress].ticketStatus = GuestLibrary.TicketStatus.Entered;
      guests[guestAddress].voteStatus = GuestLibrary.VoteStatus.NotVoted;
      return true;
    }
    return false;
  }
//Stop the wedding if one of the guests has an objection.
function weddingObjection() public onlyGuests()
{
  require(guests[msg.sender].ticketStatus == GuestLibrary.TicketStatus.Entered, "The guest must have entered.");
  require(state == State.Priest, "The priest has not asked the question." );
  state = State.Voting;
}



  // TODO: Delete before deployment
  function initiateTestValaues() public {
  	Contractor1 = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;
  	Contractor2 = 0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C;
    setWeddingDate(2019, 4, 13, 12,0, 0); // Date: 13.04.2020 at 12:00
    setInvitationDeadline(2020, 4, 13, 11, 0, 0);
   // deleteAllGuests();
  	addGuest(0, 0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB);
    state = State.Created;


  }
}
