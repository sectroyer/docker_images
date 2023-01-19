#!/bin/bash

source color.sh

if [ -z "$1" ]
then
	echo "Usage: <http[s]://server/path/javax.faces.resource/[folder/]file.jsf"
	exit -1
fi

function check_url(){
	curl -i -v -k "$1" -s 2>&1  |grep "^HTTP" | grep 200 -q
	if [ $? -eq 0 ]
	then
		printgn "YES"
		return 0
	else
		printrn "NO"
	fi
	return 1
}
function qprint(){
	printf "%-60s" "$1"
}
jsfurl="$1"

echo -e "\nJSF Version Checker v0.4 by sectroyer\n"

#echo -e -n  "Checking if url is ok...\t\t"
qprint "Checking if url is ok..."
check_url "$jsfurl"
if [ $? -ne 0 ]
then
	echo -e "Provided url doesn't work :(\n"
	exit -1
fi

if [[ "$jsfurl" =~ "ln=" ]]
then
	echo -e "\nDetected complex url. Normalizing...\n"
	ln_param=$(echo "$jsfurl" | tr '/' '@' | grep 'ln=[^&]*' -o)
	ln_value=$(echo "$ln_param" | sed 's/ln=//')
	jsfurl=$(echo "$jsfurl" | tr '/' '@' | sed "s/$ln_param//" | sed "s/faces.resource/faces.resource@$ln_value/" | tr '@' '/')
	if [ "${jsfurl: -1}" == "?" ]
	then
		len_of_jsfurl=${#jsfurl}
		jsfurl=${jsfurl::$len_of_jsfurl-1}
	fi
	echo -e "Normalized url: $jsfurl\n"
	qprint "Checking if normalized url is ok..."
	check_url "$jsfurl"
	if [ $? -ne 0 ]
	then
		echo -e "Normalized url doesn't work :(\n"
		exit -1
	fi
fi

echo ""
qprint "Checking if we are dealing with Apache MyFaces..."
myfaces_url="$jsfurl?ln"
check_url "$myfaces_url"
is_myfaces=$?
if [ $is_myfaces -eq 0 ]
then
	echo -e  "Apache MyFaces detected...\n"
	exit 0
fi

echo -e "\nMojarra detected :)\n"

qprint "Checking if Mojarra version is in range 2.3.0-2.3.13..."
mojarra_url="${jsfurl/resource/resource\/resources}?loc=./.."
check_url "$mojarra_url"
if [ $? -ne 0 ]
then
	echo -e "\nMojarra version higher than 2.3.13 or lower than 2.3.0 :(\n"
else
	echo -e "\nMojarra version is in range 2.3.0-2.3.13 :D\n"
	exit 0
fi

qprint "Checking if Mojarra version is lower than 2.2.7..."
mojarra_url="$jsfurl?ln=."
check_url "$mojarra_url"
if [ $? -ne 0 ]
then
	echo -e "\nMojarra version higher than 2.2.6\n"
	exit -1
fi
	
echo -e "\nMojarra version is lower than 2.2.7 :D\n"

qprint "Checking if Mojarra version is lower than 2.2.5..."
mojarra_url="${jsfurl/resource/resource\/resources}?ln=./.."
check_url "$mojarra_url"
if [ $? -ne 0 ]
then
	echo -e "\nMojarra version higher than 2.2.4 :)\n"
	exit 0 
fi
	
echo -e "\nMojarra version is lower than 2.2.5 :D\n"

echo ""
