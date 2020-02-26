#!/bin/bash

#edit this line to add IP address of hub (and port if not default)
connection=[IP address of TastyHub]:4242
read -p 'Username: ' user
read -sp 'Password: ' pass
#if cannot call q from inside a script, below replace 'q' with path to your q exectuable
rlwrap -r q TastyUser.q $connection $user $pass
