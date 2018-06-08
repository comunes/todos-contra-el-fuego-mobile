#!/bin/bash

BASE=../../../../../images/logo-1024.png
IOS=../../../../../ios/Runner/Assets.xcassets/LaunchImage.imageset
IOSICON=../../../../../ios/Runner/Assets.xcassets/AppIcon.appiconset

# ls $BASE
# ls $IOS

convert $BASE -resize 48x mipmap-mdpi/launch_image.png
convert $BASE -resize 72x mipmap-hdpi/launch_image.png
convert $BASE -resize 96x mipmap-xhdpi/launch_image.png
convert $BASE -resize 144x mipmap-xxhdpi/launch_image.png
convert $BASE -resize 192x mipmap-xxxhdpi/launch_image.png

cp mipmap-mdpi/launch_image.png $IOS/LaunchImage.png
cp mipmap-xhdpi/launch_image.png $IOS/LaunchImage@2x.png
cp mipmap-xxhdpi/launch_image.png $IOS/LaunchImage@3x.png
cp mipmap-xxxhdpi/launch_image.png $IOS/LaunchImage@4x.png

convert $BASE -resize 1024x1024 $IOSICON/Icon-App-1024x1024@1x.png
convert $BASE -resize 20x20 $IOSICON/Icon-App-20x20@1x.png
convert $BASE -resize 40x40 $IOSICON/Icon-App-20x20@2x.png
convert $BASE -resize 60x60 $IOSICON/Icon-App-20x20@3x.png
convert $BASE -resize 29x29 $IOSICON/Icon-App-29x29@1x.png
convert $BASE -resize 58x58 $IOSICON/Icon-App-29x29@2x.png
convert $BASE -resize 87x87 $IOSICON/Icon-App-29x29@3x.png
convert $BASE -resize 40x40 $IOSICON/Icon-App-40x40@1x.png
convert $BASE -resize 80x80 $IOSICON/Icon-App-40x40@2x.png
convert $BASE -resize 120x120 $IOSICON/Icon-App-40x40@3x.png
convert $BASE -resize 120x120 $IOSICON/Icon-App-60x60@2x.png
convert $BASE -resize 180x180 $IOSICON/Icon-App-60x60@3x.png
convert $BASE -resize 76x76 $IOSICON/Icon-App-76x76@1x.png
convert $BASE -resize 152x152 $IOSICON/Icon-App-76x76@2x.png
convert $BASE -resize 167x167 $IOSICON/Icon-App-83.5x83.5@2x.png
