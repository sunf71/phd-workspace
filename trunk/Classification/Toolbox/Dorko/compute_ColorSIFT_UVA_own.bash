#! /bin/bash

image_name=$1
siftscone=$2

data_location=/media/DATA/Datasets/Texture_own/Temp/

cd $data_location

	echo $image_name
	 /media/DATA/Matlab_code/UVA_Color_Descriptor/colorDescriptor $image_name --loadRegions DoG_milan.txt --descriptor opponentsift --output milan1.txt


	
	
cd ..


