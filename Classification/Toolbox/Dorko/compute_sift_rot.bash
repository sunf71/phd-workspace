#! /bin/bash

image_path=$1
image_name=$2
siftscone=$3
data_location=$4
base_dir=$5

echo $image_name
echo $image_path
echo $data_location
echo $base_dir

$base_dir/text2corners $data_location/$image_name.detector_points.txt $data_location/$image_name.log.corns
$base_dir/ComputeDescriptor -dtype sift -an -siftscone $siftscone $data_location/$image_name.pgm $data_location/$image_name.log.corns $data_location/$image_name.points.temp
$base_dir/corners2text -adddescr $data_location/$image_name.points.temp $data_location/$image_name.siftrotpoints.txt

