#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams,games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $WINNER != "winner" ]] 
then 
 WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'" )
 OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'" )
  if [[ -z $WINNER_ID ]] 
   then
   INSERT_WR=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
   if [[ $INSERT_WR == "INSERT 0 1" ]] 
     then
     echo inserted into teams:$WINNER
     fi
   WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'") 
   fi
 if [[ -z $OPPONENT_ID ]] 
   then
   INSERT_OR=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
   if [[ $INSERT_OR == "INSERT 0 1" ]] 
     then
     echo inserted into teams:$OPPONENT
     fi
   OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'") 
   fi
fi
if [[ $YEAR != "year" ]] 
 then
 GAME_ID=$($PSQL "SELECT game_id FROM games WHERE winner_id=$WINNER_ID AND opponent_id=$OPPONENT_ID") 
 if [[ -z $GAME_ID ]]
   then
   INSERT_GR=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
   if [[ $INSERT_GR == "INSERT 0 1" ]] 
     then
     echo inserted into games:$YEAR,$ROUND,$WINNER,$OPPONENT,$WINNER_GOALS,$OPPONENT_GOALS
     fi
  fi
fi
done