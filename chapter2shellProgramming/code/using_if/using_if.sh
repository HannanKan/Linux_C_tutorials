#!/bin/bash

echo "Is it morning? please answer yes or no"
read timeofday

if [ $timeofday = 'yes' ]; then
    echo "Good morning"
elif test $timeofday = 'no';then
    echo "Good afternoon"
else
    echo "Sorry, $timeofday not recognized, Enter yes or no"
    exit 1
fi

exit 0
