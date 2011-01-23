#!/bin/bash

image_path=$1
image_name=$2
data_location=$3
base_dir=$4

echo $image_name
echo $image_path
echo $data_location
echo $base_dir

$base_dir/Detect -dt dog $data_location/$image_name.pgm $data_location/$image_name.points.dog
$base_dir/corners2text $data_location/$image_name.points.dog $data_location/$image_name.DOGDorkopoints.txt

