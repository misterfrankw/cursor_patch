#!/bin/bash -ex

BINDIR=$HOME/bin
TEMPDIR=/tmp/cursor

mkdir -p $TEMPDIR
pushd $TEMPDIR

wget https://downloads.cursor.com/production/client/linux/x64/appimage/Cursor-0.47.7-33ec0dad159bc0ad620f6bbda539efe90c39748d.deb.glibc2.25-x86_64.AppImage -O $TEMPDIR/cursor.AppImage.original
chmod +x $TEMPDIR/cursor.AppImage.original

# Išskleisti AppImage
$TEMPDIR/cursor.AppImage.original --appimage-extract
cp $TEMPDIR/squashfs-root/cursor.png $HOME/.icons/

wget https://raw.githubusercontent.com/misterfrankw/cursor_patch/refs/heads/main/cursor-update.sh -O $BINDIR/cursor-update.sh

cat <<EOF > $HOME/.local/share/applications/cursor.desktop
[Desktop Entry]
Name=Cursor
Exec=$BINDIR/cursor --enable-features=UseOzonePlatform --ozone-platform-hint=wayland %F
Path=$BINDIR
Icon=$HOME/.icons/cursor.png
Type=Application
Categories=Utility;Development;
StartupWMClass=Cursor
X-AppImage-Version=latest
Comment=Cursor is an AI-first coding environment.
MimeType=x-scheme-handler/cursor;

[Desktop Action new-empty-window]
Exec=$BINDIR/cursor --enable-features=UseOzonePlatform --ozone-platform-hint=wayland --new-window %F
EOF

chmod +x $BINDIR/cursor-update.sh

$BINDIR/cursor-update.sh
popd
