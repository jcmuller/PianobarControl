PianobarControl
===============

+[![Ready](https://badge.waffle.io/jcmuller/PianobarControl.png?label=ready)](https://waffle.io/jcmuller/PianobarControl)

This is a wrapper around [pianobar](https://github.com/PromyLOPh/pianobar) for OS X. It currently depends on an appropriate `eventcmd` to be set in `$HOME/.config/pianobar/config` (I use `pianobar-notify-osx` from [here](https://github.com/jcmuller/pianobar-notify)).

There are many global hot keys:

*   ⌥⇧P: Pop up `PianobarControl` drop down
*   ⌥⇧O: Play/pause `pianobar`
*   ⌥⇧N: Next song
*   ⌥⇧I: Show `Growl` notification with song information
*   ⌥⇧L: Love song (thumbs up)
*   ⌥⇧B: Ban song (thumbs down)
*   ⌥⇧S: Select different station
*   ⌥⇧Y: Open default web browser with a google search for the current song's lyrics
*   ⌥⇧Q: Quit `PianobarControl`

The multimedia keys work like: Play/Pause (as expected), Next (as expected), Previous -> show growl notification.

As a bonus feature, you can disallow your computer to go to sleep by selecting "Disable computer sleep" on the drop down menu.
