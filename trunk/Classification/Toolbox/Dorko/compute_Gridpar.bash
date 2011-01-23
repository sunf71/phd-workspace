#!/bin/bash

image_path=$1
image_name=$2
data_location=$3
base_dir=$4

echo $image_name
echo $image_path
echo $data_location
echo $base_dir

$base_dir/Detect -old -dt dense -gridstep 2 -scalestep 1.2 -minscale 3 -maxscale 40 $data_location/$image_name.pgm $data_location/$image_name.points.grid
$base_dir/corners2text $data_location/$image_name.points.grid $data_location/$image_name.Gridpoints.txt

