#!/bin/bash
# using_control_structure
# use this file to practice how to use different controlling structure


echo "first log your account(account is \"Mr Handsome\"):"
read account
echo "your password(password is 123456):"
read password

while [ "$account"!="Mr Handsome" || "$password"!="123456" ]
    do
        if test "$account"="Mr Handsome" && "$password"!="123456"; then
            echo "wrong password!"
            echo "input your password(password is 123456):"
            read password
        elif test "$account"="Mr Handsome" && "$password"="123456";then
            echo "successfully logged on"
            break
        else
            echo "wrong account, please try again!"
            echo "first log your account(account is \"Mr Handsome\"):"
            read account
            echo "your password(password is 123456):"
            read password
        fi

    done
echo "Successfully logged in!"

echo "let's play guessing major game"

echo "input your major secretly: "
read major

clear

echo "Now, AI will ask your info and guess your major"
echo "are you from zhangjiang campus?(y or n)"
read from
until test "$from"=[yYNn]; do
    echo "wrong answer! input again"
    echo "are you from zhangjiang campus?(y or n)"
    read from
done

case "$from" in
    [yY] ) 
        for major in Computer_Science Software engineering Chemistry MircoEletronic
        do
            echo "your major is $major (y or n):"
            read ans
            if test "$ans"=[yY]; then
            break;
            fi
        done
        ;;
    * )
        echo "sorry, i have no idea!"
        ;;
esac

echo "bye!"
exit 0






