#!/bin/bash
export LD_LIBRARY_PATH=/usr/lib64:$LD_LIBRARY_PATH
convert -strip $1 $2
