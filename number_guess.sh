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

# INIT_GAME=$($PSQL "INSERT INTO games_played(user_id) VALUES ($USER_ID)")
# GAME_ID=$($PSQL "SELECT MAX(game_id) FROM games_played WHERE user_id=$USER_ID")
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
# UPDATE_GUESSES=$($PSQL "UPDATE games_played SET guesses=$num_guess WHERE game_id=$GAME_ID")
# You guessed it in $num_guess tries. The secret number was $random_number. Nice job!
echo -e "You guessed it in $num_guess tries. The secret number was $random_number. Nice job!"

# #!/bin/bash

# # variable to query database
# PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"


# # promp player for username
# echo -e "\nEnter your username:"
# read USERNAME

# # get username data
# USERNAME_RESULT=$($PSQL "SELECT username FROM users WHERE username='$USERNAME'")
# # get user id
# USER_ID_RESULT=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

# # if player is not found
# if [[ -z $USERNAME_RESULT ]]
#   then
#     # greet player
#     echo -e "\nWelcome, $USERNAME! It looks like this is your first time here.\n"
#     # add player to database
#     INSERT_USERNAME_RESULT=$($PSQL "INSERT INTO users(username) VALUES ('$USERNAME')")
    
#   else
    
#     GAMES_PLAYED=$($PSQL "SELECT COUNT(game_id) FROM games_played LEFT JOIN users USING(user_id) WHERE username='$USERNAME'")
#     BEST_GAME=$($PSQL "SELECT MIN(number_of_guesses) FROM games_played LEFT JOIN users USING(user_id) WHERE username='$USERNAME'")

#     echo Welcome back, $USERNAME\! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses.
# fi

# # generate random number between 1 and 1000
# SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))

# # variable to store number of guesses/tries
# GUESS_COUNT=0

# # prompt first guess
# echo "Guess the secret number between 1 and 1000:"
# read USER_GUESS


# # loop to prompt user to guess until correct
# until [[ $USER_GUESS == $SECRET_NUMBER ]]
# do
  
#   # check guess is valid/an integer
#   if [[ ! $USER_GUESS =~ ^[0-9]+$ ]]
#     then
#       # request valid guess
#       echo -e "\nThat is not an integer, guess again:"
#       read USER_GUESS
#       # update guess count
#       ((GUESS_COUNT++))
    
#     # if its a valid guess
#     else
#       # check inequalities and give hint
#       if [[ $USER_GUESS < $SECRET_NUMBER ]]
#         then
#           echo "It's higher than that, guess again:"
#           read USER_GUESS
#           # update guess count
#           ((GUESS_COUNT++))
#         else 
#           echo "It's lower than that, guess again:"
#           read USER_GUESS
#           #update guess count
#           ((GUESS_COUNT++))
#       fi  
#   fi

# done

# # loop ends when guess is correct so, update guess
# ((GUESS_COUNT++))

# # get user id
# USER_ID_RESULT=$($PSQL "SELECT user_id FROM players WHERE username='$USERNAME'")
# # add result to game history/database
# INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(user_id, secret_number, number_of_guesses) VALUES ($USER_ID_RESULT, $SECRET_NUMBER, $GUESS_COUNT)")

# # winning message
# echo You guessed it in $GUESS_COUNT tries. The secret number was $SECRET_NUMBER. Nice job\!