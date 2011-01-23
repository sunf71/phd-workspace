#! /bin/bash

image_name=$1


data_location=/media/DATA/Datasets/Texture_own/Temp/

cd $data_location

	echo $image_name
     /media/DATA/Matlab_code/Dorko_code/Detect -old -dt dense -gridstep 0.5 -scalestep 1.3 -minscale 5 -maxscale 200 $image_name  points.dog
     /media/DATA/Matlab_code/Dorko_code/corners2text points.dog DoGDorkopoints.txt 
	 
	
cd ..


 