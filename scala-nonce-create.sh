#! /bin/bash

PATH_TO_SCALA_FILE="/Users/takipimbp1/temp-hod/site/scala-play/app/controllers"
SCALA_FILE="$PATH_TO_SCALA_FILE/Application.scala"
TEST_SCALA_FILE="$PATH_TO_SCALA_FILE/test.txt"
PATH_TO_ROUTES="/Users/takipimbp1/temp-hod/site/scala-play/conf"
ROUTES_FILE="$PATH_TO_ROUTES/routes"
TEST_ROUTES_FILE="$PATH_TO_ROUTES/test.txt"
CURRENT_NAME="index1"
SITE="http://localhost:9000/"

set -x

# This function get int value (number from the "cuurent name") and return this number+1
function counter()
{
  echo `expr $1 + 1`
}

# This function get as value the current name and return only the number
function get_only_num()
{
  CURRENT_NAME=$1
  echo $CURRENT_NAME | grep -o '[0-9]\+'
}

# This function get as value the current name and return only the letters
function get_only_name()
{
  CURRENT_NAME=$1
  echo $CURRENT_NAME | grep -o '[a-z,A-Z,_]\+'
}

# This function get as value the current name and return the new name
function get_new_name()
{
 CURRENT_NAME=$1

 COUNTER=$(counter `get_only_num   $CURRENT_NAME`)
 NAME=$(get_only_name $CURRENT_NAME)
 NEW_NAME=$NAME$COUNTER
 echo $NEW_NAME
}

# This function check if entered current name as $3 argument for this script
function check_if_entered_name()
{
  if [ "$1" ]; then
    CURRENT_NAME=$1
  fi
}

# This function change the current name to the new
function change()
{
  CURRENT_NAME=$1
  NEW_NAME=$2

  cp $SCALA_FILE $TEST_SCALA_FILE
  sed "s/$CURRENT_NAME/$NEW_NAME/g" $TEST_SCALA_FILE > $SCALA_FILE

  cp $ROUTES_FILE $TEST_ROUTES_FILE
  sed "s/$CURRENT_NAME/$NEW_NAME/g" $TEST_ROUTES_FILE > $ROUTES_FILE
}

# This function use curl for browse to site
function run_scala_program
{
  curl -i $SITE
  sleep 10
}

# This function clears the java file before execution
function clear()
{
  CURRENT_NAME=$1
  FIRST_NAME=$2

  change $CURRENT_NAME $FIRST_NAME
}

# This function kill the procces of scala activator
function close()
{
  # PID=ps -ef | grep activator | awk '{print $2}' | head -n 1
  # kill -9 $PID
  kill -9 `ps -ef | grep activator | awk '{print $2}' | head -n 1`
}

function run()
{
  CURRENT_NAME=$1
  NUM=$2

  NEW_NAME=$(get_new_name $CURRENT_NAME)
  change $CURRENT_NAME $NEW_NAME
  run_scala_program
}

function main()
{
  TIMES="$1"
  A="$2"
  check_if_entered_name $A
  FIRST_NAME=$CURRENT_NAME
  for i in `seq 1 $TIMES`;
  do
    echo run number: $i
    run $CURRENT_NAME $i
    CURRENT_NAME=$NEW_NAME
  done

  clear $CURRENT_NAME $FIRST_NAME
  close
#  keep_run
}

main $@
