#! /bin/bash

image_name=$1


data_location=/home/fahad/Datasets/Temp/

cd $data_location

	echo $image_name
      /home/fahad/Matlab_code/Dorko_code/Detect -old -dt dense -gridstep 2 -scalestep 1.2 -minscale 3 -maxscale 40 $image_name  points.dog
     # /home/fahad/Matlab_code/Dorko_code/Detect -old -dt dense -gridstep 1.5 -scalestep 1.2 -minscale 2 -maxscale 30 $image_name  points.dog
    # /home/fahad/Matlab_code/Dorko_code/Detect -old -dt dense -gridstep 3 -scalestep 1.2 -minscale 4 -maxscale 60 $image_name  points.dog
     /home/fahad/Matlab_code/Dorko_code/corners2text points.dog DoGDorkopoints.txt 
	 
	
cd ..


