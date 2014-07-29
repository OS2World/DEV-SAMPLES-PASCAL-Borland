
OS/2 API FOR BPOS2 (Borland Pascal OS/2 patch)
----------------------------------------------

These Borland Pascal units are meant to be used with the great
patch for BP 7.x which allows you to create native OS/2 programs
in Pascal. The patch is courtesy of the German magazine c't, and
is available on this site for downloading (BP7-OS2.ZIP).

The original source files did not include the full OS/2 API.
I have translated the C header files to Pascal in order to
produce units that BP can use. This archive contains four files:

        OS2DEF.PAS    - System types, constants, and conversion
                        routines
        OS2SUBS.PAS   - Subsystem API - video, mouse, keyboard
                        routines
        DOSPROCS.PAS  - System functions
        DOSTYPES.PAS  - System types and constants

I have also changed the CRT, DOS, and COMPATIB units to make them
use the new API files and to fix a few errors/omissions.

These units have not been very well tested, so use them at your own
risk. I also admit than I am not all that familiar with the
OS/2 API, so you may find a few misplaced VAR statements or
what not.

Please drop me a line and let me know how things work. Also please
send me any errors/omissions you may find in the units, and I'll
include them in the next release.

Coming soon: PM API.

-----------------------------------------------
Steven E. Hugg           sehugg@freenet.fsu.edu
Florida State University
11/18/93
