pragma solidity >=0.4.22 <0.7.0;

library GuestLibrary {

  enum InvitationStatus { Not_Invited, Invited , Accepted , Denied }
  enum TicketStatus { Locked, Unlocked, Used, Entered, Voted }
  enum VoteStatus{NotVoted, For, Against}
  struct Guest{
    uint8 name;
    InvitationStatus invitationStatus;
    TicketStatus ticketStatus;
    VoteStatus voteStatus;
  }
}
