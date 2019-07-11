#!/bin/sh
iosBase=$PWD/assets/brand/logo-1024-ios.png
androidBase=$PWD/assets/brand/logo-1024-android.png
xcassetsPath=$PWD/Images.xcassets/AppIcon.appiconset
androidPath=$PWD

if [ ! -f "$iosBase" ]
then
    echo "[error] File $iosBase does not exist"
    exit
fi

if [ ! -f "$androidBase" ]
then
    echo "[error] File $androidBase does not exist"
    exit
fi


## https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_ref-Asset_Catalog_Format/AppIconType.html
echo 'creating iOS icons...'
convert "$iosBase" -resize '20x20'      -unsharp 1x4 "$xcassetsPath/Icon-20.png"
convert "$iosBase" -resize '29x29'      -unsharp 1x4 "$xcassetsPath/Icon-29.png"
convert "$iosBase" -resize '58x58'      -unsharp 1x4 "$xcassetsPath/Icon-29@2x.png"
convert "$iosBase" -resize '87x87'      -unsharp 1x4 "$xcassetsPath/Icon-29@3x.png"
convert "$iosBase" -resize '40x40'      -unsharp 1x4 "$xcassetsPath/Icon-40.png"
convert "$iosBase" -resize '80x80'      -unsharp 1x4 "$xcassetsPath/Icon-40@2x.png"
convert "$iosBase" -resize '120x120'    -unsharp 1x4 "$xcassetsPath/Icon-40@3x.png"
convert "$iosBase" -resize '60x60'      -unsharp 1x4 "$xcassetsPath/Icon-60.png"
convert "$iosBase" -resize '120x120'    -unsharp 1x4 "$xcassetsPath/Icon-60@2x.png"
convert "$iosBase" -resize '180x180'    -unsharp 1x4 "$xcassetsPath/Icon-60@3x.png"
convert "$iosBase" -resize '76x76'      -unsharp 1x4 "$xcassetsPath/Icon-76.png"
convert "$iosBase" -resize '152x152'    -unsharp 1x4 "$xcassetsPath/Icon-76@2x.png"
convert "$iosBase" -resize '167x167'    -unsharp 1x4 "$xcassetsPath/Icon-167.png"
convert "$iosBase" -resize '1024x1024'  -unsharp 1x4 "$xcassetsPath/Icon-1024.png"
echo "created iOS icons in $xcassetsPath/"

## -----------------------------------------------------------------------------
echo 'creating android icons...'
convert "$androidBase" -resize '36x36'     -unsharp 1x4 "$androidPath/Icon-ldpi.png"
convert "$androidBase" -resize '48x48'     -unsharp 1x4 "$androidPath/Icon-mdpi.png"
convert "$androidBase" -resize '72x72'     -unsharp 1x4 "$androidPath/Icon-hdpi.png"
convert "$androidBase" -resize '96x96'     -unsharp 1x4 "$androidPath/Icon-xhdpi.png"
convert "$androidBase" -resize '144x144'   -unsharp 1x4 "$androidPath/Icon-xxhdpi.png"
convert "$androidBase" -resize '192x192'   -unsharp 1x4 "$androidPath/Icon-xxxhdpi.png"
echo "created iOS icons in $androidPath/"

echo 'done!'
