# rc-vbhax
A hack that enables virtual backgrounds on RingCentral (macOS) without needing a compatible processor.
~~(Should work on all versions of RingCentral)~~ Broken as of 3/24/21

### __❗ If the injection doesn't appear to be working you may have to disable SIP (System Integrity Protection) ❗__

## How to use
Once you build the project you will end up with a `vbhax.dylib` in the `build` folder. 

To inject this into RingCentral, you can run this command:

`DYLD_INSERT_LIBRARIES=build/vbhax.dylib [path to RingCentral]`

If you have RingCentral in your Applications folder (where it should be), the command is:

`DYLD_INSERT_LIBRARIES=build/vbhax.dylib /Applications/RingCentral.app/Contents/MacOS/RingCentral`

## Known issues
* The localized strings in the settings window are broken.
