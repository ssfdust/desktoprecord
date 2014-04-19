#!/bin/bash

sound=`pactl list | grep -A2 'Source #'| grep -oP " .*?analog-stereo.monitor"`
#get system sound output
help_menu()
{
	echo -e "\n\nUsage: $0 -s [RESOLUTION] -f [FRAMERATE] -o [FILENAME]\n"
	echo -e "-s set your resolution for you desktop like 1366x768\n"
	echo -e "-f set frame rate\n"
	echo -e "-o set output file name\n"
	exit 1
}
while getopts "s:f:o:" args
do
	case $args in
	s) 
		resolution="$OPTARG" ;;
	f) 
		freq="$OPTARG" ;;
	o)
		output="$OPTARG" ;;
	?) 
		echo "unknow argument"; help_menu ;;
esac
done

sleep 5; ffmpeg -y -f x11grab -s $resolution -framerate $freq -i $DISPLAY -f pulse -i $sound -c:v libx264 -profile:v high444 -preset:v veryfast -qp:v 0 -pix_fmt yuv444p -c:a flac -threads 4 $output
