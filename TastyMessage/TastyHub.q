//check username and encrypted password are correct on sign-in
//parameters [username;encrypted password]
.z.pw:{( x in key users)&(y~users x)};

//function when user signs in - update handles dictionary and online info 
.z.po:{[x] /parameter is new handle to user
	newUser:.z.u;				/get username
	handles[newUser]::x;			/update handles dictionary
	show (string newUser)," joined";	/display message
	(neg x)(show;"Connected");		/display to user
	updateOnline[];				/update all users' online information
 };

//function when user leaves - update handles dictionary and online info
.z.pc:{[x] /parameter is handle of leaving user
	leaver:handles?x;			/get name of leaving user
	handles::leaver _ handles;		/update handles dictionary
	show (string leaver)," left";		/display message
	updateOnline[];				/update all users' online information
 };

//function when central server closes - save down user info
.z.exit:{`:users.txt set users}

//update info so users know who else is online - no arguments
updateOnline:{{[h] (neg h)({online::x};key handles)}'[value handles]}

//function when user sends message - delivers to specified users, or all
//if no valid recipients given, returns message
message:{[s;r;m] /sender symbol;recipients symbol list; message string
	`messages insert (s;r;m);					/update central message log
	$[`all in r;							/if `all in recipients, send to all
		r2:key handles;
		r2:r
	];
	if[0b = max r2 in key handles;
		(neg handles s)(show;"Sorry that didn't go to anyone - check recipients");
		: ::;	
	];
	dhandles:$[1=count r2;						/get handles to deliver to
		handles r2;		
		handles r2 where r2 in key handles
	];
	{[s;r;m;h] (neg h)(`receive;(m;s;r))}[s;r;m]'[dhandles];	/perform delivery of messages
 };

//function called when user changes password
changeUserPassword:{[user;ps] /username symbol; list of encrypted passwords: (old;new1;new2) 
	if[max (ps[0]<>users user),(ps[1]<>ps[2]);: ::];		/if things don't match do nothing
	users[user]::ps[1];						/else update user/password list
 };

//function to add new user to service - initial password "changeme"
addUser:{[u] /username symbol
	$[u in key users;						/if user already present display error
		show "This user already exists! Please pick a new username";
		users[u]::(raze string md5 "changeme")			/otherwise add default password
	];
 };

//function to remove user from service
deleteUser:{[user] /username symbol
	users::user _users;		/drop from users dictionary
	hclose handles user;		/close handle to deleted user
	handles:: user _ handles;	/drop from handles dictionary
	updateOnline[];			/update users' online info
 };


\p 4242		/initialise port - fixed value must be in users' login file
handles:()!()	/initialise handles dictionary
/initialise central messages table
messages:([] Sender:`Sender;Sent_to:enlist (`person1`person2);Message:enlist ("Welcome!"));
/get users username/password dictionary if it exists
users: @[{get x};`:users.txt;()!()];
/Check if there are no users - may be users.txt issue
if [users ~ ()!();show "No users - add with addUser[`name]"]
/welcome message
1"TastyMessage hub up and running...\n";
