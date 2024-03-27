#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo Enter your username: 
read username

USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$username'")
if [[ -z $USER_ID ]]
then 
  INSERT_USER=$($PSQL "INSERT INTO users(username) VALUES ('$username')")
  USER_ID=$($PSQL "SELECT user_id from users WHERE username='$username'")
  # USER_ID= $(echo $($PSQL "INSERT INTO users(username) VALUES ('$username') RETURNING user_id") | awk '{print $1}')
  echo "Welcome, $username! It looks like this is your first time here. Your id is $USER_ID."
else 
  NUM_GAMES=$($PSQL "SELECT COUNT(game_id) FROM games_played WHERE user_id=$USER_ID")
  BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games_played WHERE user_id=$USER_ID")
  echo -e "\nWelcome back, $username! You have played $NUM_GAMES games, and your best game took $BEST_GAME guesses. "
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
    echo -e "\nThat is not an integer, guess again:"
    read guess
  else
    if [[ $guess -gt $random_number ]]
    then 
      echo -e "\nIt's lower than that, guess again:"
      read guess
    else [[ $guess -lt $random_number ]]
      echo -e "\nIt's higher than that, guess again:"
      read guess
    fi
  fi
done

INSERT_RESULT=$($PSQL "INSERT INTO games_played(user_id, guesses) VALUES ($USER_ID, $num_guess)")

echo -e "You guessed it in $num_guess tries. The secret number was $random_number. Nice job!"
