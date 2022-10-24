#!/bin/bash

echo "What's your name?"

read name

echo "How old are you?"

read age

echo "You are $name, and you are $age years old."

sleep 1

echo "The shell is: $SHELL, the print working directory is: $PWD, the user 
is: $USER, who am I is: $whoamI, Random is: $RANDOM"

richTime=$((( $RANDOM % 15) + $age ))

echo "You will be rich at age: $richTime"


