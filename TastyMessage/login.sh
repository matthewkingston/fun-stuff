#!/bin/bash
connection=[IP address of TastyHub]:4242
read -p 'Username: ' user
read -sp 'Password: ' pass
rlwrap -r q TastyUser.q $connection $user $pass
