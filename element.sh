#!/bin/bash
if [[ $1 ]]
then
  PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
	if [[ $1 =~ ^[0-9]+$ ]]
  then
    # Get element info
    ELEMENT=$($PSQL "SELECT t1.atomic_number as atomic_number, t1.name, t1.symbol, t3.type, t2.atomic_mass, t2.melting_point_celsius, t2.boiling_point_celsius FROM elements t1 INNER JOIN properties t2 on t1.atomic_number = t2.atomic_number INNER JOIN types t3 on t2.type_id=t3.type_id WHERE t1.atomic_number=$1")
  #if it is a symbol or type
	else
    ELEMENT=$($PSQL "SELECT t1.atomic_number, t1.name, t1.symbol, t3.type, t2.atomic_mass, t2.melting_point_celsius, t2.boiling_point_celsius FROM elements t1 INNER JOIN properties t2 on t1.atomic_number = t2.atomic_number INNER JOIN types t3 on t2.type_id=t3.type_id WHERE symbol='$1'OR name='$1'")
	fi
  # if element doesn't exist
  if [[ -z $ELEMENT ]]
  then
		echo "I could not find that element in the database."
	else
		echo "$ELEMENT" | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS
    do
     	echo The element with atomic number "$ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done
	fi
else
  echo "Please provide an element as an argument."
fi
