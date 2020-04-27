# blockchain_smart_contracts
Norwegian University of Science and Technology
TTM4195 Blockchain Technology and Cryptocurrencies 
Fall Semester 2019
Completed by Chandler Beyer, Alexander Hofmann, Inaki Puche Lara, and Jeremey Puertolas


Solidity is a high-level programming language whose syntax is similar to JavaScript, Python or other similar object-oriented languages. 
It is designed to compile code that runs on the Ethereum Virtual Machine, which is hosted on Ethereum nodes 
(the computers connected peer-to-peer which constitute an Ethereum network) that are connected to the blockchain.


Smart contracts
Smart contracts are the analogue of classes in object-oriented languages. In each contract we can find 6 types of elements:
1. State variables, which are variables whose values are permanently stored. If a variable is declared as constant, then it has to be assigned from an expression which is a constant at compile time.
2. Enum types, the way in which a user can define custom types. 
3. Struct types, custom defined types that can group several variables. Note that they differ from Enums since they cannot contain functions but variables only;
4. Functions,executable code units that can be called both internally and externally,
according to the visibility they have. 
5. function Modifiers, that can be used to easily change the behaviour of functions
(e.g. automatically check conditions on values, on ownerships, . . . ). 
6. Events, which are nothing more than their analogues in OOP languages.

Assignment: 
For this assignment, write in Solidity a smart contract for a wedding. The description is deliberately general, in order to give you more implementation freedom. The structure of your code should resemble the following one:
1. two people decide to get married. They write it on a register, together with the date (day and time) of the ceremony, and the guest list;
2. any invited guest will accept or reject the invitation. In case of acceptance, a “ticket” will be released;
3. when the day comes, all participants must “log in” to the wedding by showing the ticket. We need a way to verify that the ticket matches the identity of the participant;
4. a function will implement the sentence “if anyone has an objection to these two being married, speak now or forever hold your peace”. In case of any objection, the whole ceremony will stop and a failure will be registered on the blockchain. In the other case, the wedding will be written forever.
5. (optional) an objection will not cause an immediate failure, but a voting process will take place instead. The validity of the objection will be decided by the ma- jority of the participants.

