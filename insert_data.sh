#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams") 
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # insert TEAM table data
  # Winner Team 
  # Opponent Team
  
  if [[ $YEAR != "year" ]]
  then
    WINNER_NAME=$($PSQL "SELECT name FROM teams WHERE name = '$WINNER'")
    # if the name wasnt find
    if [[ -z $WINNER_NAME ]]
    then
      INSERT_WINNER_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_WINNER_NAME == "INSERT 0 1" ]]
      then
        echo "Inserted $WINNER"
      fi
    fi
  fi

  
  if [[ $OPPONENT != "opponent" ]]
  then
    OPPONENT_NAME=$($PSQL "SELECT name FROM teams WHERE name = '$OPPONENT'")
    # if the name wasnt find
    if [[ -z $OPPONENT_NAME ]]
    then
      INSERT_OPPONENT_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_OPPONENT_NAME == "INSERT 0 1" ]]
      then
        echo "Inserted $OPPONENT"
      fi
    fi
  fi
  ## Insert games data to games table
  if [[ $YEAR != "year" ]]
  # GET ID of teams 
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")

    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

    INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  fi

    if [[ $INSERT_GAMES == "INSERT 0 1" ]]
    then
      echo "Inserting..."
    fi

done
