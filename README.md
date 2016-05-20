# Twinklr

`twinklr_pde` is a Processing application that is the core of "Twinklr", a physical, digital musicbox.

It's designed to be run fullscreen on a Raspberry Pi with touchscreen, though it'll work on any desktop computer running Processing.

## REQUIREMENTS

Twinklr is written for Processing 3.0.

You'll need the following libraries, installable through the Processing library manager:

* Beads
* The MidiBus
* Ani
* IO

You'll also need [Pui][pui] installed in your `libraries` directory.

Once Twinklr has loaded, you can either use it with a mousewheel, or, if running it on a Pi, a quadrature encoder connected to pins 17 and 27.

[pui]: https://github.com/martinleopold/pUI

## PI-IFYING IT

To make Twinklr run on a Raspberry Pi with 7" touchscreen, there are a few obvious tweaks you'll need to do.

1. Uncomment the import of `processing.io.*` in the main file
2. Comment out the `size` directive in the same file
3. Uncomment the `fullScreen` and `noCursor` directives in the same file
4. Uncomment all the `GPIO` directives in the same file
5. rename `io.pde.pi` to `io.pde`

Then, the whole application should compile and run fullscreen on the Raspberry Pi.

## Shutdown script

`shutdown.py` should be run at startup on the Pi. It waits for pin 18 to go low, and when
it does, it shuts the Pi down.


## License

See `license.txt` for details.

## Authors

This software was written by Tom Armitage, tom [at] infovore dot org

## Copyright

Copyright 2016 Tom Armitage.
