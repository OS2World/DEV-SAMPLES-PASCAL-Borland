{***************************************************************************\
*
* Module Name: PMTYPES.H
*
* OS/2 Presentation Manager Datatypes include file
*
* This is conditionally included from PMWIN.H
*
* Copyright (c) International Business Machines Corporation 1981, 1988-1990
*
*****************************************************************************}
{| Version:   1.00
 | Original translation: Peter Sawatzki ps
 | Contributing:
 |   Peter Sawatzki ps
 |
 | change history:
 | Date:    Ver: Author:
 | 11/11/93 1.00 ps     original translation by ps
}
Unit PmTypes;
Interface
Const
  DTYP_USER            =  16384;
  DTYP_CTL_ARRAY       =  1;
  DTYP_CTL_PARRAY      =  -1;
  DTYP_CTL_OFFSET      =  2;
  DTYP_CTL_LENGTH      =  3;


{********************************************************************}
{ Ordinary datatypes                                                 }
{********************************************************************}

  DTYP_ACCEL            = 28;
  DTYP_ACCELTABLE       = 29;
  DTYP_ARCPARAMS        = 38;
  DTYP_AREABUNDLE       = 139;
  DTYP_ATOM             = 90;
  DTYP_BITMAPINFO       = 60;
  DTYP_BITMAPINFOHEADER = 61;
  DTYP_BIT16            = 20;
  DTYP_BIT32            = 21;
  DTYP_BIT8             = 19;
  DTYP_BOOL             = 18;
  DTYP_BTNCDATA         = 35;
  DTYP_BYTE             = 13;
  DTYP_CATCHBUF         = 141;
  DTYP_CHAR             = 15;
  DTYP_CHARBUNDLE       = 135;
  DTYP_CLASSINFO        = 95;
  DTYP_COUNT2           = 93;
  DTYP_COUNT2B          = 70;
  DTYP_COUNT2CH         = 82;
  DTYP_COUNT4           = 152;
  DTYP_COUNT4B          = 42;
  DTYP_CPID             = 57;
  DTYP_CREATESTRUCT     = 98;
  DTYP_CURSORINFO       = 34;
  DTYP_DEVOPENSTRUC     = 124;
  DTYP_DLGTEMPLATE      = 96;
  DTYP_DLGTITEM         = 97;
  DTYP_ENTRYFDATA       = 127;
  DTYP_ERRORID          = 45;
  DTYP_FATTRS           = 75;
  DTYP_FFDESCS          = 142;
  DTYP_FIXED            = 99;
  DTYP_FONTMETRICS      = 74;
  DTYP_FRAMECDATA       = 144;
  DTYP_GRADIENTL        = 48;
  DTYP_HAB              = 10;
  DTYP_HACCEL           = 30;
  DTYP_HAPP             = 146;
  DTYP_HATOMTBL         = 91;
  DTYP_HBITMAP          = 62;
  DTYP_HCINFO           = 46;
  DTYP_HDC              = 132;
  DTYP_HENUM            = 117;
  DTYP_HHEAP            = 109;
  DTYP_HINI             = 53;
  DTYP_HLIB             = 147;
  DTYP_HMF              = 85;
  DTYP_HMQ              = 86;
  DTYP_HPOINTER         = 106;
  DTYP_HPROGRAM         = 131;
  DTYP_HPS              = 12;
  DTYP_HRGN             = 116;
  DTYP_HSEM             = 140;
  DTYP_HSPL             = 32;
  DTYP_HSWITCH          = 66;
  DTYP_HVPS             = 58;
  DTYP_HWND             = 11;
  DTYP_IDENTITY         = 133;
  DTYP_IDENTITY4        = 169;
  DTYP_IMAGEBUNDLE      = 136;
  DTYP_INDEX2           = 81;
  DTYP_IPT              = 155;
  DTYP_KERNINGPAIRS     = 118;
  DTYP_LENGTH2          = 68;
  DTYP_LENGTH4          = 69;
  DTYP_LINEBUNDLE       = 137;
  DTYP_LONG             = 25;
  DTYP_MARKERBUNDLE     = 138;
  DTYP_MATRIXLF         = 113;
  DTYP_MLECTLDATA       = 161;
  DTYP_MLEMARGSTRUCT    = 157;
  DTYP_MLEOVERFLOW      = 158;
  DTYP_OFFSET2B         = 112;
  DTYP_OWNERITEM        = 154;
  DTYP_PID              = 92;
  DTYP_PIX              = 156;
  DTYP_POINTERINFO      = 105;
  DTYP_POINTL           = 77;
  DTYP_PROGCATEGORY     = 129;
  DTYP_PROGRAMENTRY     = 128;
  DTYP_PROGTYPE         = 130;
  DTYP_PROPERTY2        = 88;
  DTYP_PROPERTY4        = 89;
  DTYP_QMSG             = 87;
  DTYP_RECTL            = 121;
  DTYP_RESID            = 125;
  DTYP_RGB              = 111;
  DTYP_RGNRECT          = 115;
  DTYP_SBCDATA          = 159;
  DTYP_SEGOFF           = 126;
  DTYP_SHORT            = 23;
  DTYP_SIZEF            = 101;
  DTYP_SIZEL            = 102;
  DTYP_STRL             = 17;
  DTYP_STR16            = 40;
  DTYP_STR32            = 37;
  DTYP_STR64            = 47;
  DTYP_STR8             = 33;
  DTYP_SWBLOCK          = 63;
  DTYP_SWCNTRL          = 64;
  DTYP_SWENTRY          = 65;
  DTYP_SWP              = 31;
  DTYP_TID              = 104;
  DTYP_TIME             = 107;
  DTYP_TRACKINFO        = 73;
  DTYP_UCHAR            = 22;
  DTYP_ULONG            = 26;
  DTYP_USERBUTTON       = 36;
  DTYP_USHORT           = 24;
  DTYP_WIDTH4           = 108;
  DTYP_WNDPARAMS        = 83;
  DTYP_WNDPROC          = 84;
  DTYP_WPOINT           = 59;
  DTYP_WRECT            = 55;
  DTYP_XYWINSIZE        = 52;


{********************************************************************}
{ Pointer datatypes                                                  }
{********************************************************************}

  DTYP_PACCEL           = -28;
  DTYP_PACCELTABLE      = -29;
  DTYP_PARCPARAMS       = -38;
  DTYP_PAREABUNDLE      = -139;
  DTYP_PATOM            = -90;
  DTYP_PBITMAPINFO      = -60;
  DTYP_PBITMAPINFOHEADER= -61;
  DTYP_PBIT16           = -20;
  DTYP_PBIT32           = -21;
  DTYP_PBIT8            = -19;
  DTYP_PBOOL            = -18;
  DTYP_PBTNCDATA        = -35;
  DTYP_PBYTE            = -13;
  DTYP_PCATCHBUF        = -141;
  DTYP_PCHAR            = -15;
  DTYP_PCHARBUNDLE      = -135;
  DTYP_PCLASSINFO       = -95;
  DTYP_PCOUNT2          = -93;
  DTYP_PCOUNT2B         = -70;
  DTYP_PCOUNT2CH        = -82;
  DTYP_PCOUNT4          = -152;
  DTYP_PCOUNT4B         = -42;
  DTYP_PCPID            = -57;
  DTYP_PCREATESTRUCT    = -98;
  DTYP_PCURSORINFO      = -34;
  DTYP_PDEVOPENSTRUC    = -124;
  DTYP_PDLGTEMPLATE     = -96;
  DTYP_PDLGTITEM        = -97;
  DTYP_PENTRYFDATA      = -127;
  DTYP_PERRORID         = -45;
  DTYP_PFATTRS          = -75;
  DTYP_PFFDESCS         = -142;
  DTYP_PFIXED           = -99;
  DTYP_PFONTMETRICS     = -74;
  DTYP_PFRAMECDATA      = -144;
  DTYP_PGRADIENTL       = -48;
  DTYP_PHAB             = -10;
  DTYP_PHACCEL          = -30;
  DTYP_PHAPP            = -146;
  DTYP_PHATOMTBL        = -91;
  DTYP_PHBITMAP         = -62;
  DTYP_PHCINFO          = -46;
  DTYP_PHDC             = -132;
  DTYP_PHENUM           = -117;
  DTYP_PHHEAP           = -109;
  DTYP_PHINI            = -53;
  DTYP_PHLIB            = -147;
  DTYP_PHMF             = -85;
  DTYP_PHMQ             = -86;
  DTYP_PHPOINTER        = -106;
  DTYP_PHPROGRAM        = -131;
  DTYP_PHPS             = -12;
  DTYP_PHRGN            = -116;
  DTYP_PHSEM            = -140;
  DTYP_PHSPL            = -32;
  DTYP_PHSWITCH         = -66;
  DTYP_PHVPS            = -58;
  DTYP_PHWND            = -11;
  DTYP_PIDENTITY        = -133;
  DTYP_PIDENTITY4       = -169;
  DTYP_PIMAGEBUNDLE     = -136;
  DTYP_PINDEX2          = -81;
  DTYP_PIPT             = -155;
  DTYP_PKERNINGPAIRS    = -118;
  DTYP_PLENGTH2         = -68;
  DTYP_PLENGTH4         = -69;
  DTYP_PLINEBUNDLE      = -137;
  DTYP_PLONG            = -25;
  DTYP_PMARKERBUNDLE    = -138;
  DTYP_PMATRIXLF        = -113;
  DTYP_PMLECTLDATA      = -161;
  DTYP_PMLEMARGSTRUCT   = -157;
  DTYP_PMLEOVERFLOW     = -158;
  DTYP_POFFSET2B        = -112;
  DTYP_POWNERITEM       = -154;
  DTYP_PPID             = -92;
  DTYP_PPIX             = -156;
  DTYP_PPOINTERINFO     = -105;
  DTYP_PPOINTL          = -77;
  DTYP_PPROGCATEGORY    = -129;
  DTYP_PPROGRAMENTRY    = -128;
  DTYP_PPROGTYPE        = -130;
  DTYP_PPROPERTY2       = -88;
  DTYP_PPROPERTY4       = -89;
  DTYP_PQMSG            = -87;
  DTYP_PRECTL           = -121;
  DTYP_PRESID           = -125;
  DTYP_PRGB             = -111;
  DTYP_PRGNRECT         = -115;
  DTYP_PSBCDATA         = -159;
  DTYP_PSEGOFF          = -126;
  DTYP_PSHORT           = -23;
  DTYP_PSIZEF           = -101;
  DTYP_PSIZEL           = -102;
  DTYP_PSTRL            = -17;
  DTYP_PSTR16           = -40;
  DTYP_PSTR32           = -37;
  DTYP_PSTR64           = -47;
  DTYP_PSTR8            = -33;
  DTYP_PSWBLOCK         = -63;
  DTYP_PSWCNTRL         = -64;
  DTYP_PSWENTRY         = -65;
  DTYP_PSWP             = -31;
  DTYP_PTID             = -104;
  DTYP_PTIME            = -107;
  DTYP_PTRACKINFO       = -73;
  DTYP_PUCHAR           = -22;
  DTYP_PULONG           = -26;
  DTYP_PUSERBUTTON      = -36;
  DTYP_PUSHORT          = -24;
  DTYP_PWIDTH4          = -108;
  DTYP_PWNDPARAMS       = -83;
  DTYP_PWNDPROC         = -84;
  DTYP_PWPOINT          = -59;
  DTYP_PWRECT           = -55;
  DTYP_PXYWINSIZE       = -52;
Implementation
End.
