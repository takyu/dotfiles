#!/bin/bash

# Function to get a timestamp
set_timestamp_timesecond()
{
	local time_second sec min hrs timestamp

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
	revolver --style 'simpleDots' start
	sleep 5;clear
	revolver stop
}

# oha
_set_wake-up_time()
{
	local last_line bed_time wakeup_time sleep_timestamp_timesecond timestamp timesecond

	last_line="$(sed -n '$p' "$HOME/Documents/times/sleep_time.txt")" 2>/dev/null
	if [ "$(echo "$last_line" | awk '{print $1,$2}')" != "Bed Time:" ] ; then
		display_error "${ESC}[31mYou didn't enter the command 'oya' last night, did you?${ESC}[m"
		return 0
	fi
	bed_time="$(sed -n '$p' "$HOME/Documents/times/sleep_time.txt" | awk '{print $3,$5}')"
	wakeup_time="$(date +'%Y/%m/%d %H:%M:%S')"
	date +'Wake-up Time: %Y/%m/%d %A %H:%M:%S' >> "$HOME"/Documents/times/sleep_time.txt
	sleep_timestamp_timesecond="$(set_timestamp_timesecond "$wakeup_time" "$bed_time")"
	timestamp="$(echo "$sleep_timestamp_timesecond" | awk '{print $2}')"
	timesecond="$(echo "$sleep_timestamp_timesecond" | awk '{print $4}')"
	if [ "$timesecond" -ge $(( 7*60*60 )) ] ; then
		echo "Sleep Time: ${ESC}[32m${timestamp}${ESC}[m" >> "$HOME"/Documents/times/sleep_time.txt
	else
		echo "Sleep Time: ${ESC}[31m${timestamp}${ESC}[m" >> "$HOME"/Documents/times/sleep_time.txt
	fi
	clear
	pokemonsay -n -p Wigglytuff "GoodMornig, $USER!" && figlet -f slant "time $timestamp"
	if _ask_yn "enter 'y' to initialize the display, or 'n' to exit not to initialize it." ; then
		_custom_cd
	fi
	_search_on_google_engine https://www.japantimes.co.jp/ 1>/dev/null
}
# oya
_set_bed_time()
{
	local last_line

	last_line="$(sed -n '$p' "$HOME/Documents/times/sleep_time.txt")" 2>/dev/null
	if [ "$(echo "$last_line" | awk '{print $1,$2}')" != "Sleep Time:" ] && [ "$last_line" != "" ] ; then
		display_error "${ESC}[31mYou didn't enter the command 'oha' this morning, did you?${ESC}[m"
		return 0
	fi
	date +"%nBed Time: %Y/%m/%d %A %H:%M:%S" >> "$HOME"/Documents/times/sleep_time.txt
	_quit_app_by_apple_script "Brave Browser"
	clear
	pokemonsay -n -p Jigglypuff "Goodsleep, $USER."
	_purge_cache 1>/dev/null
	revolver --style 'arrow2' start
	echo "${ESC}[34mSleep after 5 seconds...${ESC}[m"
	sleep 5;revolver stop && _manipulate_sleep on && pmset sleepnow
}
# stst
_set_start_time_for_studying()
{
	local last_line

	last_line="$(sed -n '$p' "$HOME/Documents/times/study_time.txt")" 2>/dev/null
	if [ "$(echo "$last_line" | awk '{print $1,$2}')" != "Study Time:" ] && [ "$last_line" != "" ] ; then
		display_error "${ESC}[31mYou didn't enter the command 'fist' when you had finished studying, did you?${ESC}[m"
		return 0
	fi
	date +'%nStart Study Time: %Y/%m/%d %A %H:%M:%S' >> "$HOME"/Documents/times/study_time.txt
	clear
	pokemonsay -n -p Vulpix "Study hard, $USER!"
	_break_line_before_echo "${ESC}[34mInitialize the terminal display after 5 seconds...${ESC}[m"
	revolver --style 'arrow2' start
	sleep 5;revolver stop && _custom_cd
}
# fist
_set_finish_time_for_studying()
{
	local last_line start_time finish_time study_timestamp_timesecond timestamp timesecond

	last_line="$(sed -n '$p' "$HOME/Documents/times/study_time.txt")" 2>/dev/null
	if [ "$(echo "$last_line" | awk '{print $1,$2,$3}')" != "Start Study Time:" ] ; then
		display_error "${ESC}[31mYou hadn't entered the command 'stst' before you studied, had you?${ESC}[m"
		return 0
	fi
	start_time="$(sed -n '$p' "$HOME/Documents/times/study_time.txt" | awk '{print $4,$6}')"
	finish_time="$(date +'%Y/%m/%d %H:%M:%S')"
	date +'Finish Study Time: %Y/%m/%d %A %H:%M:%S' >> "$HOME"/Documents/times/study_time.txt
	study_timestamp_timesecond="$(set_timestamp_timesecond "$finish_time" "$start_time")"
	timestamp="$(echo "$study_timestamp_timesecond" | awk '{print $2}')"
	timesecond="$(echo "$study_timestamp_timesecond" | awk '{print $4}')"
	if [ "$timesecond" -ge $(( 2*60*60 )) ] ; then
		echo "Study Time: ${ESC}[32m${timestamp}${ESC}[m" >> "$HOME"/Documents/times/study_time.txt
	else
		echo "Study Time: ${ESC}[31m${timestamp}${ESC}[m" >> "$HOME"/Documents/times/study_time.txt
	fi
	clear
	pokemonsay -n -p Ninetales "Good work, $USER." && figlet -f slant "time $timestamp"
	if _ask_yn "enter 'y' to initialize the display, or 'n' to exit not to initialize it." ; then
		_custom_cd
	fi
}