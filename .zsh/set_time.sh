#!/bin/bash

# Function to get a timestamp
set_timestamp_timesecond()
{
	time_second=$(( $(date -j -f "%Y/%m/%d %H:%M:%S" "$1" +%s) - $(date -j -f "%Y/%m/%d %H:%M:%S" "$2" +%s) ))

	sec=$((time_second%60))
	min=$(((time_second%3600)/60))
	hrs=$((time_second/3600))

	timestamp="$(printf "%d:%02d:%02d" $hrs $min $sec)"
	echo "timestamp: $timestamp timesecond: $time_second"
}

display_error()
{
	cowsay -f ghostbusters 'Oops, something is wrong..'
	_break_line_before_echo "$1"
	sleep 4;clear
}

# oha
_set_wake-up_time()
{
	last_line="$(sed -n '$p' "$HOME/Documents/sleep_time.txt")" 2>/dev/null
	if [ "$(echo "$last_line" | awk '{print $1,$2}')" != "Bed Time:" ] ; then
		display_error "${ESC}[31mYou didn't enter the command 'oya' last night, did you?${ESC}[m"
		return 0
	fi
	bed_time="$(sed -n '$p' "$HOME/Documents/sleep_time.txt" | awk '{print $3,$5}')"
	wakeup_time="$(date +'%Y/%m/%d %H:%M:%S')"
	date +'Wake-up Time: %Y/%m/%d %A %H:%M:%S' >> "$HOME"/Documents/sleep_time.txt
	sleep_timestamp_timesecond="$(set_timestamp_timesecond "$wakeup_time" "$bed_time")"
	timestamp="$(echo "$sleep_timestamp_timesecond" | awk '{print $2}')"
	timesecond="$(echo "$sleep_timestamp_timesecond" | awk '{print $4}')"
	if [ "$timesecond" -ge $(( 7*60*60 )) ] ; then
		echo "Sleep Time: ${ESC}[32m${timestamp}${ESC}[m" >> "$HOME"/Documents/sleep_time.txt
	else
		echo "Sleep Time: ${ESC}[31m${timestamp}${ESC}[m" >> "$HOME"/Documents/sleep_time.txt
	fi
	clear
	cowsay -f hellokitty GoodMornig, Taku!
	figlet -f slant sleep_time "$timestamp"
	if _ask_yn "enter 'y' to initialize the display, or 'n' to exit not to initialize it." ; then
		_custom_cd
	fi
}
# oya
_set_bed_time()
{
	last_line="$(sed -n '$p' "$HOME/Documents/sleep_time.txt")" 2>/dev/null
	if [ "$(echo "$last_line" | awk '{print $1,$2}')" != "Sleep Time:" ] && [ "$last_line" != "" ] ; then 
		display_error "${ESC}[31mYou didn't enter the command 'oha' this morning, did you?${ESC}[m"
		return 0
	fi
	date +"%nBed Time: %Y/%m/%d %A %H:%M:%S" >> "$HOME"/Documents/sleep_time.txt
	clear
	cowsay -f tux Goodsleep, Taku
	echo "${ESC}[34mSleep after 3 seconds...${ESC}[m"
	sleep 3;pmset displaysleepnow
}
# stst
_set_start_time_for_studying()
{
	last_line="$(sed -n '$p' "$HOME/Documents/study_time.txt")" 2>/dev/null
	if [ "$(echo "$last_line" | awk '{print $1,$2}')" != "Study Time:" ] && [ "$last_line" != "" ] ; then 
		display_error "${ESC}[31mYou didn't enter the command 'fist' when you had finished studying, did you?${ESC}[m"
		return 0
	fi
	date +'%nStart Study Time: %Y/%m/%d %A %H:%M:%S' >> "$HOME"/Documents/study_time.txt
	clear
	cowsay -f stimpy Study hard, Taku!
	_break_line_before_echo "${ESC}[34mInitialize the terminal display after 3 seconds...${ESC}[m"
	sleep 3;_custom_cd
}
# fist
_set_finish_time_for_studying()
{
	last_line="$(sed -n '$p' "$HOME/Documents/study_time.txt")" 2>/dev/null
	if [ "$(echo "$last_line" | awk '{print $1,$2,$3}')" != "Start Study Time:" ] ; then
		display_error "${ESC}[31mYou hadn't entered the command 'stst' before you studied, had you?${ESC}[m"
		return 0
	fi
	start_time="$(sed -n '$p' "$HOME/Documents/study_time.txt" | awk '{print $4,$6}')"
	finish_time="$(date +'%Y/%m/%d %H:%M:%S')"
	date +'Finish Study Time: %Y/%m/%d %A %H:%M:%S' >> "$HOME"/Documents/study_time.txt
	study_timestamp_timesecond="$(set_timestamp_timesecond "$finish_time" "$start_time")"
	timestamp="$(echo "$study_timestamp_timesecond" | awk '{print $2}')"
	timesecond="$(echo "$study_timestamp_timesecond" | awk '{print $4}')"
	if [ "$timesecond" -ge $(( 2*60*60 )) ] ; then
		echo "Study Time: ${ESC}[32m${timestamp}${ESC}[m" >> "$HOME"/Documents/study_time.txt
	else
		echo "Study Time: ${ESC}[31m${timestamp}${ESC}[m" >> "$HOME"/Documents/study_time.txt
	fi
	clear
	cowsay -f koala Good work, Taku.
	figlet -f slant study_time "$timestamp"
	if _ask_yn "enter 'y' to initialize the display, or 'n' to exit not to initialize it." ; then
		_custom_cd
	fi
}