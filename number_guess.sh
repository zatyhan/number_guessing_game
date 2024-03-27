#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo Enter your username: 
read username

USER_EXIST=$($PSQL "SELECT * FROM user_activity WHERE username='$username'")
if [[ -z $USER_EXIST ]]
then 
  INSERT_USER=$($PSQL "INSERT INTO user_activity(username) VALUES ('$username')")
  echo "Welcome, $username! It looks like this is your first time here."
else 
  games_played=$($PSQL "SELECT games_played FROM user_activity WHERE username='$username'")
  best_game=$($PSQL "SELECT best_game FROM user_activity WHERE username='$username'")
  echo "Welcome back, $username! You have played $games_played games, and your best game took $best_game guesses."
fi
