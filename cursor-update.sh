#!/bin/bash -ex

BINDIR=$HOME/bin
TEMPDIR=/tmp/cursor

mkdir -p $TEMPDIR
pushd $TEMPDIR

wget https://downloads.cursor.com/production/client/linux/x64/appimage/Cursor-0.47.8-82ef0f61c01d079d1b7e5ab04d88499d5af500e3.deb.glibc2.25-x86_64.AppImage -O $TEMPDIR/cursor.AppImage.original
chmod +x $TEMPDIR/cursor.AppImage.original

# Extract the AppImage
$TEMPDIR/cursor.AppImage.original --appimage-extract
rm $TEMPDIR/cursor.AppImage.original

# Fix it by replacing all occurrences of ",minHeight" with ",frame:false,minHeight"
TARGET_FILE="squashfs-root/resources/app/out/main.js"
sed -i 's/,minHeight/,frame:false,minHeight/g' "$TARGET_FILE"

# Download latest appimagetool
wget https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage -O $TEMPDIR/appimagetool-x86_64.AppImage
chmod +x $TEMPDIR/appimagetool-x86_64.AppImage

# Repackage the AppImage using appimagetool
rm -f $BINDIR/cursor
$TEMPDIR/appimagetool-x86_64.AppImage squashfs-root/ $BINDIR/cursor
chmod +x $BINDIR/cursor

popd
# Cleaning Up
rm -rf $TEMPDIR
