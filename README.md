# fun-stuff

Side projects and fun things

## [Noughts and Crosses - xo.q](xo.q)

Play noughts and crosses against a 'perfect' (minmaxing) player - just run with `q xo.q`

## [Neural Net Back Propagation - BP.q](BP.q)

A set of functions for performing basic machine learning, performing back propagation to calculate the gradient of error function wrt weights, and stepping based on that. It assumes a sigmoid function at nodes, with error function as sum of square differences

## [TastyMessage: kdb chatroom](TastyMessage)

Built to practise IPC

### Setup

- Hub: just run `q TastyHub.q`. Default port to run on is 4242 - to change edit line `\p 4242` to port of your choice
- User: need to edit login.sh file to add IP address of hub being used (may need to change port if default not being used by hub). Depending on q implementation, may also need to add explicit path to where the q executable is stored. To start run `bash login.sh` (TastyUser.q must be in same directory).

### Features

- All IPC asynchronous
- All passwords are passed to hub as md5 encrypted - passwords not seen by hub in plain text
- Hub saves user info between sessions

### Warning

No query parsing is implemented by hub - users have an open handle to the hub q process and can break things/spy on others if they really want. Trust your users!
