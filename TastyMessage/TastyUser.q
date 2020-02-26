//display help message explaining functionality
help:{	
	1"\n---------------Welcome to TastyMessage---------------\n
	COMMANDS
	send[\"Message\";`recipient1`recipient2]\tSend message
	inbox\t\t\t\t\tSee received messages
	sent\t\t\t\t\tSee sent messages
	online\t\t\t\t\tSee who else is online
	changePassword[\"old\";\"new\";\"new\"]\tChange password
	help[]\t\t\t\t\tDisplay this again\n\n";
 };

//set message so that if central server disconnects user knows
.z.pc:{show "Central message process dead! Sorry"};

//internal handling of incoming message
receive:{[x] 				/get in format (message;sender;recipients)
	inbox::reverse inbox;		/insert at top of inbox table
	`inbox insert x;
	inbox::reverse inbox;
	show (string x[1]),": ",x[0];	/print new message alert
 };

//function for user to send a message
send:{[m;r] 				/message string; recipients symbol list
	sent::reverse sent;		/insert at top of sent table
	`sent insert (m;r); 
	sent::reverse sent;
	(neg h)(`message;user;r;m);	/send to central server with message function
 };

//allow user to modify own password, send passwords encrypted
changePassword:{[old;new1;new2] 	/all strings input
	(neg h)(`changeUserPassword;user;{raze string md5 x} each (old;new1;new2))
 };

//get local username and ecrypted password
user:`$.z.x[1]; 					/username - 2nd argument of q call
password:raze string md5 .z.x[2]; 			/password,encrypted - 3rd argument of q call
h:hopen hsym `$.z.x[0],":",(string user),":", password;	/open connection to central server

//initialise inbox and sent messages tables - need starting message to set types
inbox:([] Message:enlist ("Welcome!");Sender:`Sender;SentTo:enlist (`person1`person2));
sent:([] Message:enlist ("Welcome!");SentTo:enlist (`person1`person2));

online:`$(); 						/initialise online list - updated by central server
help[] 							/display initial help message

