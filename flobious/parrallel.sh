#!/bin/bash
# Define the range of frames for each OpenSCAD instance
start=$1   # Start frame passed as the first argument
end=$2     # End frame passed as the second argument
model=$3   # Path to the OpenSCAD model file

# Loop over the range from start to end
for i in $(seq $start $end); do
    echo "Rendering frame $i"
    openscad -o frame_$i.png --imgsize=800,600 --autocenter --background=rgba(1,1,1,0) --colorscheme=Tomorrow \
             -D'$t='$(echo "$i / $end" | bc -l) $model &
done

wait
echo "All frames rendered."
