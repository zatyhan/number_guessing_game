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
  echo -e "\nWelcome back, $username! You have played $games_played games, and your best game took $best_game guesses."
fi

random_number=$((RANDOM % (1000 - 1 + 1) + 1))
echo -e "\nGuess the secret number between 1 and 1000:"
read guess
echo $random_number
num_guess=1

while [ ! $guess == $random_number ];
do 
  num_guess=$((num_guess+1))
  if [[ ! $guess =~ ^[0-9]+$ ]]
  then 
    echo -e "\nThis is not an integer, guess again:"
    read guess
  elif [[ $guess > $random_number ]]
  then 
    echo -e "\nIt's lower than that, guess again:"
    read guess
  else [[ $guess < $random_number ]]
    echo -e "\nIt's higher than that, guess again:"
    read guess
  fi
done

echo -e "\nYou guessed it in $num_guess tries. The secret number was $random_number. Nice job!"
