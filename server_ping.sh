#!/usr/bin/bash

# server_ping - pings servers listed in a given file and returns the results

# defined variables

green=`tput setaf 2`
red=`tput setaf 1`
valid_path_selected=false

# defined functions

test_ip() { # takes an IP
    if ping -c 5 -i 2 $1 &> /dev/null; # ping the server 5 times at an interval of 2 seconds
    then
	echo $green$1: UP # return the IP in green text with UP
    else
	echo $red$1: DOWN # return the IP in green text with UP
    fi
}

# script start

while ! $valid_path_selected; # ensure that a valid path is given
do
    read -p "Choose a file to read the IP addresses from: " -i "$HOME" -e file_path
    if [ -f "$file_path" ];
    then
	valid_path_selected=true
    else
	echo Invalid path. Try again
    fi
done

number_of_lines=$({ cat $file_path; echo ''; } | wc -l) # count the number of lines
server_ips=$(cat $file_path) # read the contents of the file into a variable

read -p "There are $number_of_lines IP addresses in server_ips. Test them all at once? (y/n) " user_response
if [ "$user_response" = "y" ]; # batch test IPs
then
    for ip in $server_ips
    do
	test_ip $ip
    done
else
    for ip in $server_ips # test IPs individually
    do
	read -p "Test $ip? (y/n) " user_response
	if [ "$user_response" = "y" ];
	then
	    test_ip $ip
	else
	    :
	fi
	tput sgr0
    done
fi
