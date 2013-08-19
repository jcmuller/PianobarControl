[![Stories in Ready](https://badge.waffle.io/jcmuller/PianobarControl.png?label=ready)](https://waffle.io/jcmuller/PianobarControl)  
PianobarControl
===============

This is a wrapper around [pianobar](https://github.com/PromyLOPh/pianobar) for OS X. It currently depends on an appropriate `eventcmd` to be set in `$HOME/.config/pianobar/config` (I use `pianobar-notify-osx` from [here](https://github.com/jcmuller/pianobar-notify)).

There are many global hot keys:

*   b%b'P: Pop up `PianobarControl` drop down
*   b%b'O: Play/pause `pianobar`
*   b%b'N: Next song
*   b%b'I: Show `Growl` notification with song information
*   b%b'L: Love song (thumbs up)
*   b%b'B: Ban song (thumbs down)
*   b%b'S: Select different station
*   b%b'Y: Open default web browser with a google search for the current song's lyrics
*   b%b'Q: Quit `PianobarControl`

The multimedia keys work like: Play/Pause (as expected), Next (as expected), Previous -> show growl notification.

As a bonus feature, you can disallow your computer to go to sleep by selecting "Disable computer sleep" on the drop down menu.
