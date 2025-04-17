#!/bin/bash

# Create folders for Android sizes
mkdir -p android/ldpi
mkdir -p android/mdpi
mkdir -p android/hdpi
mkdir -p android/xhdpi
mkdir -p android/xxhdpi
mkdir -p android/xxxhdpi

# Create folders for iOS sizes
mkdir -p ios/1x
mkdir -p ios/2x
mkdir -p ios/3x

# Create folders for Web sizes
mkdir -p web/8
mkdir -p web/16
mkdir -p web/24
mkdir -p web/32
mkdir -p web/58
mkdir -p web/64
mkdir -p web/128
mkdir -p web/256
mkdir -p web/512
mkdir -p web/2048

# Function to calculate the proportional height based on the original aspect ratio
calculate_proportional_height() {
    local original_width=$1
    local original_height=$2
    local target_width=$3

    echo $((original_height * target_width / original_width))
}

# Function to resize images for Android
resize_for_android() {
    local file=$1
    local dimensions
    dimensions=$(identify -format "%wx%h" "$file")
    local original_width=${dimensions%x*}
    local original_height=${dimensions#*x}

    declare -A android_sizes=(
        ["ldpi"]=384
        ["mdpi"]=512
        ["hdpi"]=768
        ["xhdpi"]=1024
        ["xxhdpi"]=1536
        ["xxxhdpi"]=2048
    )

    for resolutionPath in "${!android_sizes[@]}"; do
        target_width=${android_sizes[$resolutionPath]}
        target_height=$(calculate_proportional_height $original_width $original_height $target_width)
        convert "$file" -resize "${target_width}x${target_height}" "android/$resolutionPath/$(basename "$file" .png)-${target_width}x${target_height}.png"
    done
}

# Function to resize images for iOS
resize_for_ios() {
    local file=$1
    local dimensions
    dimensions=$(identify -format "%wx%h" "$file")
    local original_width=${dimensions%x*}
    local original_height=${dimensions#*x}

    declare -A ios_sizes=(
        ["1x"]=683
        ["2x"]=1366
        ["3x"]=2048
    )

    for resolutionPath in "${!ios_sizes[@]}"; do
        target_width=${ios_sizes[$resolutionPath]}
        target_height=$(calculate_proportional_height $original_width $original_height $target_width)
        convert "$file" -resize "${target_width}x${target_height}" "ios/$resolutionPath/$(basename "$file" .png)-${target_width}x${target_height}.png"
    done
}

# Function to resize images for Web
resize_for_web() {
    local file=$1
    local dimensions
    dimensions=$(identify -format "%wx%h" "$file")
    local original_width=${dimensions%x*}
    local original_height=${dimensions#*x}

    for target_width in 8 16 24 32 58 64 128 256 512 2048; do
        target_height=$(calculate_proportional_height $original_width $original_height $target_width)
        convert "$file" -resize "${target_width}x${target_height}" "web/$target_width/$(basename "$file" .png)-${target_width}x${target_height}.png"
    done
}

# Main loop to process each image file in the directory
for file in *.png; do
    if [[ -f "$file" ]]; then
        echo "Processing $file"
        resize_for_android "$file"
        resize_for_ios "$file"
        resize_for_web "$file"
    else
        echo "No PNG files found in the directory."
    fi
done

echo "Image resizing and organization complete."

