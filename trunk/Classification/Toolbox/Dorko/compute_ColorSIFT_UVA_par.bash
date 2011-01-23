#! /bin/bash

#image_path=$1
#image_name=$2
#siftscone=$3

#data_location=/home/fahad/Datasets/Temp/

#cd $data_location

	#echo $image_name
   # echo $image_path
	# /home/fahad/Matlab_code/Dorko_code/text2corners $image_name.detector_points.txt $image_name.log.corns
	#/home/fahad/Matlab_code/Dorko_code/ComputeDescriptor -dtype sift -siftscone $siftscone $image_name.pgm $image_name.log.corns $image_name.points.temp
	# /home/fahad/Matlab_code/Dorko_code/corners2text -adddescr $image_name.points.temp $image_name.siftpoints.txt
	
#cd ..


#! /bin/bash

image_path=$1
image_name=$2
siftscone=$3


data_location=/home/fahad/Datasets/Temp/

cd $data_location

	echo $image_name
    echo $image_path
	 /home/fahad/Matlab_code/UVA_Color_Descriptor/colorDescriptor $image_path --detector densesampling --descriptor rgsift --output $image_name.ColorUVApoints.txt
	
	
cd ..

