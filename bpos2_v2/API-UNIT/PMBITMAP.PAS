{| Unit: PmBitmap
 | Version: 1.00
 | translated from file PmBitmap.H
 | Original translation: Peter Sawatzki (ps)
 | Contributing:
 |   (fill in)
 |
 | change history:
 | Date:    Ver: Author:
 | 11/13/93 1.00 ps     original translation by ps
}
Unit PmBitmap;
Interface
Uses
  Os2Def,
  PmGpi;

{**************************************************************************\
*
* OS/2 Presentation Manager Bit Map, Icon and Pointer type declarations.
*
\**************************************************************************}

{
 * This is the file format structure for Bit Maps, Pointers and Icons
 * as stored in the resource file of a PM application.
 *
 * Notes on file format:
 *   Each BITMAPFILEHEADER entry is immediately followed by the color table
 *   for the bit map bits it references.
 *   Icons and Pointers contain two BITMAPFILEHEADERs for each ARRAYHEADER
 *   item.  The first one is for the ANDXOR mask, the second is for the
 *   COLOR mask.  All offsets are absolute based on the start of the FILE.
 }

Type
  BITMAPFILEHEADER = Record             { bfh }
    usType: USHORT;
    cbSize: ULONG;
    xHotspot,
    yHotspot: SHORT;
    offBits: ULONG;
    bmp: BITMAPINFOHEADER
  End;
  pBITMAPFILEHEADER = ^BITMAPFILEHEADER;

{
 * This is the 1.2 device independent format header
 }
  BITMAPARRAYFILEHEADER = Record        { bafh }
    usType: USHORT;
    cbSize,
    offNext: ULONG;
    cxDisplay,
    cyDisplay: USHORT;
    bfh: BITMAPFILEHEADER
  End;
  pBITMAPARRAYFILEHEADER = ^BITMAPARRAYFILEHEADER;

{
 * These are the identifying values that go in the usType field of the
 * BITMAPFILEHEADER and BITMAPARRAYFILEHEADER.
 }

Const
  BFT_ICON                =  $4349;                { 'IC' }
  BFT_BMAP                         =  $4d42;                { 'BM' }
  BFT_POINTER                      =  $5450;                { 'PT' }
  BFT_COLORICON                    =  $4943;                { 'CI' }
  BFT_COLORPOINTER                 =  $5043;                { 'CP' }
  BFT_BITMAPARRAY                  =  $4142;                { 'BA' }
Implementation
End.
