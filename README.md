defaultmailer
==============

Command line script for getting and setting a default mailer (mailto: URL scheme handler) in Mac OS X.

As there seems no other elegant way of doing it you need some Objective-C code.

The code uses Launch Services. More info on 
[Launch Services Reference](https://developer.apple.com/library/mac/documentation/Carbon/Reference/LaunchServicesReference/Reference/reference.html)

Usage
-----

Open the XCode project and build it or download the build/defaultmailer and put it somewhere
in your path. `chmod +x defaultmailer` is probably also necessary.

You can set the default mailer with:

    defaultmailer -set mailmate

Running defaultmailer without arguments shows the current setting.