#!/bin/bash
for item in assets/**/*.png; do 
	echo "Handling" $item;
	make ${item%.png}.2bpp
done
