#!/bin/bash

RED='\x1b[0;31m'
GREEN='\x1b[0;32m'
ORANGE='\x1b[0;33m'
BLUE='\x1b[0;34m'
MAGENTA='\x1b[0;35m'
CYAN='\x1b[0;36m'
NC='\x1b[0m' # No Color


function printrr(){
	echo -e -n "\r${RED}$1${NC}"
}
function printgr(){
	echo -e -n "\r${GREEN}$1${NC}"
}
function printor(){
	echo -e -n "\r${ORANGE}$1${NC}"
}
function printbr(){
	echo -e -n "\r${BLUE}$1${NC}"
}
function printmr(){
	echo -e -n "\r${MAGENTA}$1${NC}"
}
function printcr(){
	echo -e -n "\r${CYAN}$1${NC}"
}
function printrn(){
	echo -e "${RED}$1${NC}"
}
function printgn(){
	echo -e "${GREEN}$1${NC}"
}
function printon(){
	echo -e "${ORANGE}$1${NC}"
}
function printbn(){
	echo -e "${BLUE}$1${NC}"
}
function printmn(){
	echo -e "${MAGENTA}$1${NC}"
}
function printcn(){
	echo -e "${CYAN}$1${NC}"
}
function printr(){
	echo -e -n "${RED}$1${NC}"
}
function printg(){
	echo -e -n "${GREEN}$1${NC}"
}
function printo(){
	echo -e -n "${ORANGE}$1${NC}"
}
function printb(){
	echo -e -n "${BLUE}$1${NC}"
}
function printm(){
	echo -e -n "${MAGENTA}$1${NC}"
}
function printc(){
	echo -e -n "${CYAN}$1${NC}"
}
function tprintr(){
	echo -e -n "\t${RED}$1${NC}"
}
function tprintg(){
	echo -e -n "\t${GREEN}$1${NC}"
}
function tprinto(){
	echo -e -n "\t${ORANGE}$1${NC}"
}
function tprintb(){
	echo -e -n "\t${BLUE}$1${NC}"
}
function tprintm(){
	echo -e -n "\t${MAGENTA}$1${NC}"
}
function tprintc(){
	echo -e -n "\t${CYAN}$1${NC}"
}

function printc_res(){
	RES="RES"
	if [ -n "$2" ]
	then
		RES="$2"
	fi
	if [ $1 -eq 0 ]
	then
		printgn "$RES: $1"
	else
		printrn "$RES: $1"
	fi
}
function printc_len(){
	RES="LEN"
	if [ -n "$2" ]
	then
		RES="$2"
	fi
	if [ $1 -gt 0 ]
	then
		printgn "\r$RES: $1"
	else
		printrn "\r$RES: $1"
	fi
}
