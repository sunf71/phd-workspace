#! /bin/bash

image_name=$1
siftscone=$2

data_location=/home/fahad/Datasets/Temp/

cd $data_location

	echo $image_name
	 /home/fahad/Matlab_code/Dorko_code/text2corners detector_points.txt log.corns
	 /home/fahad/Matlab_code/Dorko_code/ComputeDescriptor -dtype sift -siftscone $siftscone $image_name log.corns points.temp
	 /home/fahad/Matlab_code/Dorko_code/corners2text -adddescr points.temp points.txt
	
cd ..