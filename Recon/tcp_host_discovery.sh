#!/bin/bash

# First run the SYN scan, save results into file

#echo "First arg: $1"
#echo "Second arg: $2"

# Make a setting so the script can detect if you are sending an individual ip address or a range of ip addresses. This versatility will prove useful in the future.
# atm this only supports ranges.

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    have_args=0
  else
    echo "Scanning via TCP for hosts within: $1"
    have_args=1
fi

if [ "$have_args" = "1" ]
 then

	# SYN Scan:

    RESULT=$(nmap -sP -PS -n $1 |grep 'for' | cut -b 22-31)
	#This clears whatever was previously in tcp.txt
	echo 'foo' > tcp.txt

	# Multiline comment

	
	for item in $RESULT
	do
		#echo "SYN Scan: $item"
		echo "$item" >> tcp.txt
	done

	echo "Finished SYN scans"

	# Now that I have all of the results from the SYN scan,
	# we can now read the ip addresses identified in tcp.txt
	# and compare them to those that are returned from the
	# ACK scan.

    ACK_RESULT=$(nmap -sP -PA -n $1 |grep 'for' | cut -b 22-31)

	#echo $ACK_RESULT

	for item in $ACK_RESULT
	do
		# echo "SYN Scan: $item"
		echo "$item" >> tcp.txt
	done

	echo "Finished ACK scans"

	# Hoping to do some port discovery via some other protocols,
	# however this file only pertains to TCP, so we will stop here

	#UNIQUE=$(sort tcp.txt | uniq -u | wc -l)
	UNIQUE=$(sort tcp.txt | uniq )


	#echo $UNIQUE

	ARRAY=()

	for item in $UNIQUE
	do
		ARRAY+=("$item")
		#echo "Added $item to array"
	done	

	#echo $UNIQUE

	#echo ${ARRAY[@]} > tcp.txt

	#echo "${ARRAY[@]}"

	# If there are items in the array, write the first item
	# to the output file, then append the rest of the items
	# the said file. This way we should have a clean file
	# of sorts that only has the unique hosts.

	echo 'foo' > tcp.txt

	for i in "${ARRAY[@]}"
	do
		echo $i	>> tcp.txt
	done


	$(sed -i '/foo/d' ./tcp.txt)

	echo "Hosts Detected:"

	cat tcp.txt

fi















