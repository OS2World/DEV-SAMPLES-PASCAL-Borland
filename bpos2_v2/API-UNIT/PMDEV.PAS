{| Unit: pmdev
 | Version: 1.00
 | translated from file pmdev.H
 | Original translation: Peter Sawatzki (ps)
 | Contributing:
 |   (fill in)
 |
 | change history:
 | Date:    Ver: Author:
 | 11/19/93 1.00 ps     original translation by ps
}
Unit pmdev;
Interface
Uses
  Os2Def;
{**************************************************************************\
*
* Module Name: PMDEV.H
*
* OS/2 Presentation Manager Device Context constants, types and
* function declarations
*
\**************************************************************************}

Type
  { pointer data for DevOpenDC }
  pDevOpenData = ^PSZ;

{ General DEV return values }

Const
  DEV_ERROR                        = 0 ;
  DEV_OK                           = 1 ;

{ DC type for DevOpenDC }
  OD_QUEUED                        = 2 ;
  OD_DIRECT                        = 5 ;
  OD_INFO                          = 6 ;
  OD_METAFILE                      = 7 ;
  OD_MEMORY                        = 8 ;
  OD_METAFILE_NOQUERY              = 9 ;

{ codes for DevQueryCaps }
  CAPS_FAMILY                      = 0 ;
  CAPS_IO_CAPS                     = 1 ;
  CAPS_TECHNOLOGY                  = 2 ;
  CAPS_DRIVER_VERSION              = 3 ;
  CAPS_WIDTH                       = 4 ;                    { pels            }
  CAPS_HEIGHT                      = 5 ;                    { pels            }
  CAPS_WIDTH_IN_CHARS              = 6 ;
  CAPS_HEIGHT_IN_CHARS             = 7 ;
  CAPS_HORIZONTAL_RESOLUTION       = 8 ;                    { pels per meter  }
  CAPS_VERTICAL_RESOLUTION         = 9 ;                    { pels per meter  }
  CAPS_CHAR_WIDTH                  = 10 ;                   { pels            }
  CAPS_CHAR_HEIGHT                 = 11 ;                   { pels            }
  CAPS_SMALL_CHAR_WIDTH            = 12 ;                   { pels            }
  CAPS_SMALL_CHAR_HEIGHT           = 13 ;                   { pels            }
  CAPS_COLORS                      = 14 ;
  CAPS_COLOR_PLANES                = 15 ;
  CAPS_COLOR_BITCOUNT              = 16 ;
  CAPS_COLOR_TABLE_SUPPORT         = 17 ;
  CAPS_MOUSE_BUTTONS               = 18 ;
  CAPS_FOREGROUND_MIX_SUPPORT      = 19 ;
  CAPS_BACKGROUND_MIX_SUPPORT      = 20 ;
  CAPS_DEVICE_WINDOWING            = 31 ;
  CAPS_ADDITIONAL_GRAPHICS         = 32 ;
  CAPS_VIO_LOADABLE_FONTS          = 21 ;
  CAPS_WINDOW_BYTE_ALIGNMENT       = 22 ;
  CAPS_BITMAP_FORMATS              = 23 ;
  CAPS_RASTER_CAPS                 = 24 ;
  CAPS_MARKER_HEIGHT               = 25 ;                   { pels            }
  CAPS_MARKER_WIDTH                = 26 ;                   { pels            }
  CAPS_DEVICE_FONTS                = 27 ;
  CAPS_GRAPHICS_SUBSET             = 28 ;
  CAPS_GRAPHICS_VERSION            = 29 ;
  CAPS_GRAPHICS_VECTOR_SUBSET      = 30 ;
  CAPS_PHYS_COLORS                 = 33 ;
  CAPS_COLOR_INDEX                 = 34 ;
  CAPS_GRAPHICS_CHAR_WIDTH         = 35 ;
  CAPS_GRAPHICS_CHAR_HEIGHT        = 36 ;
  CAPS_HORIZONTAL_FONT_RES         = 37 ;
  CAPS_VERTICAL_FONT_RES           = 38 ;
  CAPS_DEVICE_FONT_SIM             = 39 ;

{ Constants for CAPS_IO_CAPS }
  CAPS_IO_DUMMY                    = 1 ;
  CAPS_IO_SUPPORTS_OP              = 2 ;
  CAPS_IO_SUPPORTS_IP              = 3 ;
  CAPS_IO_SUPPORTS_IO              = 4 ;

{ Constants for CAPS_TECHNOLOGY }
  CAPS_TECH_UNKNOWN                = 0 ;
  CAPS_TECH_VECTOR_PLOTTER         = 1 ;
  CAPS_TECH_RASTER_DISPLAY         = 2 ;
  CAPS_TECH_RASTER_PRINTER         = 3 ;
  CAPS_TECH_RASTER_CAMERA          = 4 ;
  CAPS_TECH_POSTSCRIPT             = 5 ;

{ Constants for CAPS_COLOR_TABLE_SUPPORT }
  CAPS_COLTABL_RGB_8               = 1 ;
  CAPS_COLTABL_RGB_8_PLUS          = 2 ;
  CAPS_COLTABL_TRUE_MIX            = 4 ;
  CAPS_COLTABL_REALIZE             = 8 ;

{ Constants for CAPS_FOREGROUND_MIX_SUPPORT }
  CAPS_FM_OR                       = 1 ;
  CAPS_FM_OVERPAINT                = 2 ;
  CAPS_FM_XOR                      = 8 ;
  CAPS_FM_LEAVEALONE               = 16 ;
  CAPS_FM_AND                      = 32 ;
  CAPS_FM_GENERAL_BOOLEAN          = 64 ;

{ Constants for CAPS_BACKGROUND_MIX_SUPPORT }
  CAPS_BM_OR                       = 1 ;
  CAPS_BM_OVERPAINT                = 2 ;
  CAPS_BM_XOR                      = 8 ;
  CAPS_BM_LEAVEALONE               = 16 ;

{ Constants for CAPS_DEVICE_WINDOWING }
  CAPS_DEV_WINDOWING_SUPPORT       = 1 ;

{ Constants for CAPS_ADDITIONAL_GRAPHICS }
  CAPS_GRAPHICS_KERNING_SUPPORT    = 2 ;
  CAPS_FONT_OUTLINE_DEFAULT        = 4 ;
  CAPS_FONT_IMAGE_DEFAULT          = 8 ;
{ bits represented by values 16L and 32L are reserved }
  CAPS_SCALED_DEFAULT_MARKERS      = 64 ;

{ Constants for CAPS_WINDOW_BYTE_ALIGNMENT }
  CAPS_BYTE_ALIGN_REQUIRED         = 0 ;
  CAPS_BYTE_ALIGN_RECOMMENDED      = 1 ;
  CAPS_BYTE_ALIGN_NOT_REQUIRED     = 2 ;

{ Constants for CAPS_RASTER_CAPS }
  CAPS_RASTER_BITBLT               = 1 ;
  CAPS_RASTER_BANDING              = 2 ;
  CAPS_RASTER_BITBLT_SCALING       = 4 ;
  CAPS_RASTER_SET_PEL              = 16 ;
  CAPS_RASTER_FONTS                = 32 ;

  Function DevOpenDC (hab: HAB; lType: LongInt; pszToken: PSZ; lCount: LongInt;pdopData: PDEVOPENDATA;
                      hdcComp: HDC): HDC;
  Function DevCloseDC (hdc: HDC): HMF;
  Function DevQueryCaps (hdc: HDC;lStart,lCount: LongInt;alArray: PLONG): BOOL;


{ structures for DEVESC_QUERYVIOCELLSIZES }

Type
  VIOSIZECOUNT = Record                 { vios }
    maxcount,
    count: LongInt
  End;
  pVIOSIZECOUNT = ^VIOSIZECOUNT;

  VIOFONTCELLSIZE = Record              { viof }
    cx,
    cy: LongInt
  End;
  pVIOFONTCELLSIZE = ^VIOFONTCELLSIZE;

{ structure for DEVESC_GETCP }
  ESCGETCP = Record                     { escgcp }
    options: ULONG;
    codepage,
    fontid: USHORT
  End;
  pESCGETCP = ^ESCGETCP;

{ structure for DEVESC_GETSCALINGFACTOR }
  SFACTORS = Record                     { sfactors }
    x,
    y: LongInt
  End;
  pSFACTORS = ^SFACTORS;

{ structure for DEVESC_NEXTBAND }
  BANDRECT = Record                     { bandrect }
    xleft,
    ybottom,
    xright,
    ytop: LongInt
  End;
  pBANDRECT = ^BANDRECT;

{ return codes for DevEscape }

Const
  DEVESC_ERROR            = (-1 );
  DEVESC_NOTIMPLEMENTED            = 0 ;

{ codes for DevEscape }
  DEVESC_QUERYESCSUPPORT           = 0 ;
  DEVESC_GETSCALINGFACTOR          = 1 ;
  DEVESC_QUERYVIOCELLSIZES         = 2 ;
  DEVESC_GETCP                     = 8000 ;

  DEVESC_STARTDOC                  = 8150 ;
  DEVESC_ENDDOC                    = 8151 ;
  DEVESC_NEXTBAND                  = 8152 ;
  DEVESC_ABORTDOC                  = 8153 ;

  DEVESC_NEWFRAME                  = 16300 ;
  DEVESC_DRAFTMODE                 = 16301 ;
  DEVESC_FLUSHOUTPUT               = 16302 ;
  DEVESC_RAWDATA                   = 16303 ;
  DEVESC_SETMODE                   = 16304 ;
  DEVESC_DBE_FIRST                 = 24450 ;
  DEVESC_DBE_LAST                  = 24455 ;

{ DevEscape codes for adding extra space to character strings }
  DEVESC_CHAR_EXTRA                = 16998 ;
  DEVESC_BREAK_EXTRA               = 16999 ;

{ codes for DevEscape PM_Q_ESC spool files }
  DEVESC_STD_JOURNAL               = 32600 ;

{ return codes for DevPostDeviceModes }
  DPDM_ERROR                       = (-1 );
  DPDM_NONE                        = 0 ;

{ codes for DevPostDeviceModes }
  DPDM_POSTJOBPROP                 = 0 ;
  DPDM_CHANGEPROP                  = 1 ;
  DPDM_QUERYJOBPROP                = 2 ;

Type
{ string types for DevQueryDeviceNames }
  STR16 = Array[0..15] Of Char;     { str16 }
  pSTR16 = ^STR16;
  STR32 = Array[0..31] Of Char;     { str32 }
  pSTR32 = ^PSTR32;
  STR64 = Array[0..63] Of Char;     { str64 }
  pSTR64 = ^STR64;

Const
{ return code for DevQueryHardcopyCaps }
  DQHC_ERROR                       = (-1 );
{ codes for DevQueryHardcopyCaps }
  HCAPS_CURRENT                    = 1 ;
  HCAPS_SELECTABLE                 = 2 ;

{ structure for DevQueryHardcopyCaps }

Type
  HCINFO = Record                       { hci }
    szFormname: Array[0..31] Of Char;
    cx,
    cy,
    xLeftClip,
    yBottomClip,
    xRightClip,
    yTopClip,
    xPels,
    yPels,
    flAttributes: LongInt
  End;
  pHCINFO = ^HCINFO;

{ structure for DEVESC_SETMODE }
  ESCSETMODE = Record                   { escsm }
    mode: ULONG;
    codepage: USHORT
  End;
  pESCSETMODE = ^ESCSETMODE;

  Function DevEscape (hdc: HDC;lCode,lInCount: LongInt;pbInData: PBYTE;plOutCount: PLONG;pbOutData: PBYTE): LongInt;
  Function DevQueryDeviceNames (hab: HAB;pszDriverName: PSZ;pldn: PLONG;aDeviceName: PSTR32;
                                aDeviceDesc: PSTR64;pldt: PLONG;aDataType: PSTR16): BOOL;
  Function DevQueryHardcopyCaps (hdc: HDC;lStartForm,lForms: LongInt;phciHcInfo: PHCINFO): LongInt;
  Function DevPostDeviceModes (hab: HAB;pdrivDriverData: PDRIVDATA;pszDriverName,pszDeviceName,
                               pszName: PSZ;flOptions: ULONG): LongInt;

{ AAB error codes for the DEV - same as GPI errors at present }

Implementation
  Function DevCloseDC;                    External 'PMGPI'    Index    2;
  Function DevEscape;                     External 'PMGPI'    Index    4;
  Function DevOpenDC;                     External 'PMGPI'    Index    1;
  Function DevPostDeviceModes;            External 'PMGPI'    Index    3;
  Function DevQueryCaps;                  External 'PMGPI'    Index    6;
  Function DevQueryDeviceNames;           External 'PMGPI'    Index  165;
  Function DevQueryHardcopyCaps;          External 'PMGPI'    Index    5;
End.
