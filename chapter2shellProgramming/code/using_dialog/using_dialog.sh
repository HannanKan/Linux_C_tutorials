#!/bin/bash

#ask questions and collect the answer

gdialog --title "question" --msgbox "Welcome to my simple survey" 9 18

gdialog --title "Confirm" --yesno "Are you willing to take part?" 9 18
if [ $? !=0 ] ; then
    gdialog --infobox "Thank you anyway" 5 20
    sleep 2
    gdialog --clear
    exit 0
fi
