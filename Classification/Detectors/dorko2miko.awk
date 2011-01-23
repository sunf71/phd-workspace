#!/bin/sh
filename_name=$1

 
awk '{print $1" "$2" "$5/$3**2" "$6/$3**2" "$7/$3**2}'<$filename_name



