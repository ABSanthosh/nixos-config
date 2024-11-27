#!/bin/bash
TMPFILE=`mktemp -u /tmp/screenshotclip.XXXXXXXX.png`
gnome-screenshot -af $TMPFILE && xclip $TMPFILE -selection clipboard -target image/png; rm $TMPFILE || echo ""