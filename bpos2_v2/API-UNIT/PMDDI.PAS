{| Unit: pmddi
 | Version: 1.00
 | translated from file pmddi.H
 | Original translation: Peter Sawatzki (ps)
 | Contributing:
 |   (fill in)
 |
 | change history:
 | Date:    Ver: Author:
 | 11/13/93 1.00 ps     original translation by ps
}
Unit pmddi;
Interface
Uses
  Os2Def,
  PmGpi,
  BseDos;
{**************************************************************************\
*
* Module Name: PMDDI.H
*
* OS/2 Presentation Manager Graphics Engine entry point, macro and type
* declarations.
*
* Copyright
*
* =========================================================================
*
* Further defines must be made to specify which of the GRE function macros
* should be defined.  INCL_GREALL causes all of them to be defined.
*
*     INCL_GRE_ARCS        - Arcs functions
*     INCL_GRE_LINES       - Line functions
*     INCL_GRE_MARKERS     - etc.
*     INCL_GRE_SCANS
*     INCL_GRE_BITMAPS
*     INCL_GRE_STRINGS
*     INCL_GRE_PATHS
*     INCL_GRE_PICK
*     INCL_GRE_CLIP
*     INCL_GRE_REGIONS
*     INCL_GRE_XFORMS
*     INCL_GRE_DEVMISC
*     INCL_GRE_COLORTABLE
*     INCL_GRE_DEVICE
*     INCL_GRE_DCS
*     INCL_GRE_SETID
*     INCL_GRE_FONTS
*     INCL_GRE_JOURNALING
*     INCL_GRE_LCID
*     INCL_GRE_DEVSUPPORT
\**************************************************************************}

{ exported Engine DDI functions }

  Function SetDriverInfo (Par1: ULONG; Par2: LHANDLE; Par3: ULONG; hDC: HDC): ULONG;
  Function GetDriverInfo (Par1: LHANDLE; Par2: ULONG; hDC: HDC): ULONG;
  Function PostDeviceModes (Par1: PDRIVDATA; Par2, Par3, Par4: PSZ; Par5: ULONG): ULONG;
  Function GreInitialize: BOOL;

{ define common types in the Engine and DDI }


Type
  RECTS = Record                        { rcs }
    pts1,
    pts2: POINTS
  End;
  pRECTS = ^RECTS;

  POINTFX = Record                      { ptfx }
    x,
    y: FIXED
  End;
  pPOINTFX = ^POINTFX;

  RECTFX = Record                       { rcfx }
    ptfx1,
    ptfx2: POINTFX
  End;

  pRECTFX = ^PRECTFX;

  XFORM = Record                        { xform }
    fxM11,
    fxM12,
    fxM21,
    fxM22: FIXED;
    lM41,
    lM42: LongInt
  End;
  pXFORM = ^PXFORM;

  LCID = LONG;      { locally-coded id }
  pLCID = ^LCID;
  PHID = LONG;      { path id          }

{ get GRE function macros }
{ have INCL_GREALL defined to get all of these }

{ Command Flags for high word of FunN }

Const
  COM_DRAW                =  $0001;
  COM_BOUND                        =  $0002;
  COM_CORRELATE                    =  $0004;
  COM_ALT_BOUND                    =  $0008;
  COM_AREA                         =  $0010;
  COM_PATH                         =  $0020;
  COM_TRANSFORM                    =  $0040;
  COM_RECORDING                    =  $0080;
  COM_DEVICE                       =  $0100;

{ BoxBoundary }
{ BoxInterior }
{ BoxBoth }

Type
  BOXPARAMS = Record                    { boxp }
    ptl: POINTL;
    sizl: SIZEL
  End;
  pBOXPARAMS = ^BOXPARAMS;

{ CopyClipRegion }

Const
  COPYCRGN_ALLINTERSECT   = 0 ;
  COPYCRGN_VISRGN                  = 1 ;
  COPYCRGN_CLIPRGN                 = 2 ;

{ SetupDC }

  SETUPDC_VISRGN                   =  $00000001 ;
  SETUPDC_ORIGIN                   =  $00000002 ;
  SETUPDC_ACCUMBOUNDSON            =  $00000004 ;
  SETUPDC_ACCUMBOUNDSOFF           =  $00000008 ;
  SETUPDC_RECALCCLIP               =  $00000010 ;
  SETUPDC_SETOWNER                 =  $00000020 ;
  SETUPDC_CLEANDC                  =  $00000040 ;

{ QueryViewportSize }
Type
  VIEWPORTSIZE = Record                 { vs }
    cx,
    cy: ULONG
  End;
  pVIEWPORTSIZE = ^VIEWPORTSIZE;

{ Constants for GreInitializeAttributes }

Const
  INAT_DEFAULTATTRIBUTES  = 1 ;
  INAT_CURRENTATTRIBUTES           = 2 ;

{ InvalidateVisRegion }


Type
  DC_BLOCK = Record                     { ivr }
    hdc,
    hddc: ULONG
  End;
  pDC_BLOCK = ^DC_BLOCK;

{ Display information resource structure }

  DISPLAYINFO = Record                  { dspinfo }
    cb: USHORT;
    cxIcon,
    cyIcon,
    cxPointer,
    cyPointer,
    cxBorder,
    cyBorder,
    cxHSlider,
    cyVSlider,
    cxSizeBorder,
    cySizeBorder,
    cxDeviceAlign,
    cyDeviceAlign: SHORT
  End;
  pDISPLAYINFO = ^DISPLAYINFO;

{ Parameters for the DC Enable function }

  DENPARAMS = Record                    { den }
    ulStateInfo,
    ulType,
    ulHDC: ULONG
  End;
  pDENPARAMS = ^DENPARAMS;


  STYLERATIO = Record                   { sr }
    dx,
    dy: BYTE
  End;
  pSTYLERATIO = ^STYLERATIO;

{ Options flags for SetGlobalAttribute }


Const
  GATTR_DEFAULT           = 1 ;

{ Attribute Types for SetGlobalAttribute }

  ATYPE_COLOR                      = 1 ;
  ATYPE_BACK_COLOR                 = 2 ;
  ATYPE_MIX_MODE                   = 3 ;
  ATYPE_BACK_MIX_MODE              = 4 ;

{ Options for CharStringPos }

  CHS_START_XY                     =  $00000020 ;
  CHS_ATTR_INFO                    =  $00000040 ;


Type
  CSP_INFO = Record                     { csp }
    cSize,
    lColor,
    lBackColor: LongInt
  End;
  pCSP_INFO = ^CSP_INFO;

{ Set/GetProcessControl }


Const
  PCTL_DRAW               =  $00000001 ;
  PCTL_BOUND                       =  $00000002 ;
  PCTL_CORRELATE                   =  $00000004 ;
  PCTL_USERBOUNDS                  =  $00000008 ;
  PCTL_AREA                        =  $00000010 ;

{ ResetBounds }

  RB_GPI                           =  $00000001 ;
  RB_USER                          =  $00000002 ;

{ GetBoundsData }

  GBD_GPI                          = 0 ;
  GBD_USER                         = 1 ;

{ EndArea Cancel Option }

  EA_DRAW                          =  $00000000 ;
  EA_CANCEL                        =  $00000001 ;

{ Bitblt Style }

  BLTMODE_SRC_BITMAP               =  $00010000 ;
  BLTMODE_ATTRS_PRES               =  $00020000 ;
  BBO_TARGWORLD                    =  $00000100 ;


Type
  BITBLTPARAMETERS = Record             { bbp }
    rclTarg,
    rclSrc: RECTL
  End;
  pBITBLTPARAMETERS = ^BITBLTPARAMETERS;

  BITBLTATTRS = Record                  { bba }
    cSize,
    lColor,
    lBackColor: LongInt
  End;
  pBITBLTATTRS = ^BITBLTATTRS;

{ LCIDs }


Const
  LCID_AVIO_1             = (-2 );
  LCID_AVIO_2                      = (-3 );
  LCID_AVIO_3                      = (-4 );

  LCID_RANGE_GPI                   = 1 ;
  LCID_RANGE_AVIO                  = 2 ;
  LCID_RANGE_BOTH                  = 3 ;
  LCID_GRAPHICS_MIN                = 1;
  LCID_GRAPHICS_MAX                = 254;

{ ResetDC }

  RDC_RGBMODE                      =  $1 ;
  RDC_SETOWNERTOSHELL              =  $2 ;

{ SetRandomXform }

  SX_UNITY                         = 0 ;
  SX_CAT_AFTER                     = 1 ;
  SX_CAT_BEFORE                    = 2 ;
  SX_OVERWRITE                     = 3 ;

{ Transform accelerators                                                   }
{ These bits are only valid if the MATRIX_SIMPLE bit is set.               }
{ The X and Y negate flags are only meaningful if MATRIX_UNITS is set.     }

  MATRIX_SIMPLE                    =  $0001 ;               { two entries are zero      }
  MATRIX_UNITS                     =  $0002 ;               { all entries are +1 or -1  }
  MATRIX_XY_EXCHANGE               =  $0004 ;               { zeros are on the diagonal }
  MATRIX_X_NEGATE                  =  $0008 ;               { X is hit by negative      }
  MATRIX_Y_NEGATE                  =  $0010 ;               { Y is hit by negative      }
  MATRIX_TRANSLATION               =  $0020 ;               { non-zero translation      }

{ NotifyClipChange }

  NCC_CLEANDC                      =  $0002 ;               { clear DC dirty bit        }

{ NotifyTransformChange }


Type
  NOTIFYTRANSFORMDATA = Record          { ntd }
    usType: USHORT;
    xform: XFORM
  End;
  pNOTIFYTRANSFORMDATA = ^NOTIFYTRANSFORMDATA;


{ ColorTable }
Const
  LCOL_SYSCOLORS          =  $0010 ;

{ query device caps }
Type
  QCDARRAY = Record                     { qcd }
    iFormat,
    iSmallest,
    iLargest,
    cAvailable,
    cSpecifiable,
    iMax: LongInt
  End;
  pQCDARRAY = ^QCDARRAY;


Const
  CAPS_MIX_OR             =  $00000001 ;
  CAPS_MIX_COPY                    =  $00000002 ;
  CAPS_MIX_UNDERPAINT              =  $00000004 ;
  CAPS_MIX_XOR                     =  $00000008 ;
  CAPS_MIX_INVISIBLE               =  $00000010 ;
  CAPS_MIX_AND                     =  $00000020 ;
  CAPS_MIX_OTHER                   =  $00000040 ;

{ for CAPS_DEVICE_FONT_SIM }
  CAPS_DEV_FONT_SIM_BOLD           = 1 ;
  CAPS_DEV_FONT_SIM_ITALIC         = 2 ;
  CAPS_DEV_FONT_SIM_UNDERSCORE     = 4 ;
  CAPS_DEV_FONT_SIM_STRIKEOUT      = 8 ;

  CAPS_BACKMIX_OR                  =  $00000001 ;
  CAPS_BACKMIX_COPY                =  $00000002 ;
  CAPS_BACKMIX_UNDERPAINT          =  $00000004 ;
  CAPS_BACKMIX_XOR                 =  $00000008 ;
  CAPS_BACKMIX_INVISIBLE           =  $00000010 ;


{ #define CAPS_RASTER_BITBLT      0x00000001L    defined in pmdev.h }
{ #define CAPS_RASTER_BANDING     0x00000002L                       }
{ #define CAPS_RASTER_STRETCHBLT  0x00000004L                       }
{ #define CAPS_RASTER_SETPEL      0x00000010L                       }
  CAPS_FONT_OUTLINE_MANAGE         = 16 ;
  CAPS_FONT_IMAGE_MANAGE           = 32 ;
  SFONT_RASTER                     = 100;
  SFONT_OUTLINE                    = 101;
  FONT                             = 1000;                  { must not conflict with RT_XXX }
                                            { constants in BSEDOS.H         }

{ DCCaps }

  DCCAPS_LINE                      =  $0100;
  DCCAPS_CURVE                     =  $0200;
  DCCAPS_AREA                      =  $0400;
  DCCAPS_MARKER                    =  $0800;
  DCCAPS_TEXT                      =  $1000;

{ DeviceDeleteBitmap }
  BITMAP_USAGE_TRANSLATE           =  $0004;

{ DeleteBitmap return structure }

Type
  DELETERETURN = Record                 { dr }
    pInfo,
    pBits: ULONG
  End;
  pDELETERETURN = ^DELETERETURN;

{ Short Line Header }


Const
  SLH_FORMAT_IS_16_DOT_16 = 1;
  PSL_YMAJOR                       =  $8000;                { bit mask for usStyle }


Type
  pSHORTLINEHEADER = ^SHORTLINEHEADER;
  SHORTLINEHEADER = Record              { slh }
    usStyle,
    usFormat: USHORT;
    ptsStart,
    ptsStop: POINTS;
    sxLeft,
    sxRight: SHORT;
    pslhNext,
    pslhPrev: pSHORTLINEHEADER
  End;

{ Short Line }

  SHORTLINE = Record                    { sl }
    slh: SHORTLINEHEADER;
    ax: Array[0..0] Of SHORT
  End;
  pSHORTLINE = ^SHORTLINE;

  SCANDATA = Record                     { sd }
    pslFirstLeft,
    pslLastLeft,
    pslFirstRight,
    pslLastRight: PSHORTLINE;
    c: ULONG;
    rclBound: RECTL
  End;
  pSCANDATA = ^SCANDATA;

{ Index for Set/GetDriverInfo }


Const
  DI_HDC                  =  $00000000 ;
  DI_HBITMAP                       =  $00000001 ;

{ RealizeFont }

  REALIZE_FONT                     = 1;
  REALIZE_ENGINE_FONT              = 2;
  DELETE_FONT                      = 3;

{ Device Line Bundle }


Type
  LINEDEFS = Record                     { ldef }
    defType: ULONG
  End;
  pLINEDEFS = ^LINEDEFS;

  DLINEBUNDLE = Record                  { dlbnd }
    cAttr,
    cDefs: SHORT;
    lbnd: LINEBUNDLE;
    ldef: LINEDEFS
  End;
  pDLINEBUNDLE = ^DLINEBUNDLE;

{ Device Area Bundle }

  AREADEFS = Record                     { adef }
    defSet: ULONG;
    fFlags,
    CodePage: UINT
  End;
  pAREADEFS = ^AREADEFS;

  DAREABUNDLE = Record                  { dabnd }
    cAttr,
    cDefs: SHORT;
    abnd: AREABUNDLE;
    adef: AREADEFS
  End;
  pDAREABUNDLE = ^DAREABUNDLE;

{ Device Character Bundle }

  CHARDEFS = Record                     { cdef }
    defSet: ULONG;
    fFlags,
    CodePage,
    charSpacing: UINT
  End;
  pCHARDEFS = ^CHARDEFS;

  DCHARBUNDLE = Record                  { dcbnd }
    cAttr,
    cDefs: SHORT;
    cbnd: CHARBUNDLE;
    cdef: CHARDEFS
  End;
  pDCHARBUNDLE = ^DCHARBUNDLE;

{ Device Image Bundle }

{$ifdef BOGUS}
  IMAGEDEFS = Record
  End;
{$EndIf}

  DIMAGEBUNDLE = Record                 { dibnd }
    cAttr,
    cDefs: SHORT;
    ibnd: IMAGEBUNDLE                   {    IMAGEDEFS idef; }
  End;
  pDIMAGEBUNDLE = ^DIMAGEBUNDLE;

{ Device Marker Bundle }

  MARKERDEFS = Record                   { mdef }
    defSet: ULONG;
    fFlags,
    CodePage: UINT
  End;
  pMARKERDEFS = ^MARKERDEFS;

  DMARKERBUNDLE = Record                { dmbnd }
    cAttr,
    cDefs: SHORT;
    mbnd: MARKERBUNDLE;
    mdef: MARKERDEFS
  End;
  pDMARKERBUNDLE = ^DMARKERBUNDLE;


{ Signatures of Path data structures }

Const
  CURVE_IDENTIFIER        =  $43;
  SUBPATH_IDENTIFIER               =  $53;
  PATH_IDENTIFIER                  =  $50;
  PATHSEGMENT_IDENTIFIER           =  $5350;

{ Curve types }

  LINE_IDENTIFIER                  =  $4C;
  FILLET_SHARP_IDENTIFIER          =  $46;
  FILLET_EQN_IDENTIFIER            =  $45;
  CURVEATTR_IDENTIFIER             =  $41;

{ Subpath types }

  SUBPATH_CLOSED                   =  $43;
  SUBPATH_OPEN                     =  $4F;

{ Path types }

  BEGINAREA_IDENTIFIER             =  $41;
  BEGINPATH_IDENTIFIER             =  $50;
  PATHSEGMENT_FORMAT_16_16         = 1;

{ Flags for curve data structures }

  CURVE_FIRST_IN_SUBPATH           =  $0001;
  CURVE_DO_FIRST_PEL               =  $0002;
  CURVE_GOES_UP                    =  $0004;
  CURVE_IS_HORIZONTAL              =  $0008;
  CURVE_IS_X_MAJOR                 =  $0010;
  CURVE_GOES_LEFT                  =  $0020;
  CURVE_FIRST_CARVED               =  $0040;
  CURVE_HALF_COOKED                =  $0400;
{ Flags for SubPath data structures }

  SUBPATH_DO_FIRST_PEL             =  $0002;

{ Flags for Path data structures }

  PATH_HAS_LINES_PRESENT           =  $4000;
  PATH_HAS_CONICS_PRESENT          =  $8000;

{ Data structures to support the Path API }


Type
  pCURVE   = ^CURVE;
  CURVE = Record                        { cv }
    bIdent,
    bType: BYTE;
    usStyle,
    fs: USHORT;
    npcvNext,
    npcvPrev,
    npcvAttrs: pCURVE; {**** UNSURE}
    ptfxA,
    ptfxC: POINTFX;
    Reserved2: Array[0..15] Of BYTE
  End;

  LINE = Record                         { ln }
    bIdent,
    bType: BYTE;
    usStyle,
    fs: USHORT;
    npcvNext,
    npcvPrev,
    npcvAttrs: pCURVE;
    ptfxA,
    ptfxC: POINTFX;
    ptsA,
    ptsC: POINTS;
    lRslope: FIXED;
    Reserved2: Array[0..3] Of BYTE
  End;
  pLINE    = ^LINE;

  FILLETEQN = Record                    { fse }
    bIdent,
    bType: BYTE;
    usReferences: USHORT;
    ptsA,
    ptsC,
    ptsB: POINTS;
    usNumerator,
    usDenominator: USHORT;
    lAlpha,
    lBeta,
    lGamma,
    lDelta,
    lEpsilon,
    lZeta: LongInt
  End;
  pFILLETEQN = ^FILLETEQN;

  FILLETSHARP = Record                  { fs }
    bIdent,
    bType: BYTE;
    usStyle,
    fs: USHORT;
    npcvNext,
    npcvPrev,
    npcvAttrs: pCURVE;
    ptfxA,
    ptfxC,
    ptfxB: POINTFX;
    lSharpness: FIXED;
    npEquation: ^FILLETEQN;
    Reserved2: Array[0..1] Of BYTE
  End;
  pFILLETSHARP = ^FILLETSHARP;

  CURVEATTR = Record                    { cva }
    bIdent,
    bType: BYTE;
    flAttrs: ULONG;
    Reserved1: Array[0..3] Of BYTE;
    npcvAttrs: pCURVE;
    flDefs: ULONG;
    lbnd: LINEBUNDLE;
    Reserved2: Array[0..1] Of BYTE
  End;
  pCURVEATTR = ^CURVEATTR;

  pSUBPATH = ^SUBPATH;
  SUBPATH = Record                      { sp }
    bIdent,
    bType: BYTE;
    usStyle,
    fs: USHORT;
    npspNext,
    npspPrev: pSUBPATH;
    ccv: USHORT;
    flFlags: ULONG;
    npcvFirst,
    npcvLast: pCURVE;
    rcsBounding: RECTS;
    npcvAttrs: pCURVE;
    Reserved1: Array[0..13] Of BYTE
  End;


Const
  PH_FORMAT_IS_16_DOT_16  = 1;


Type
  PATH = Record                         { ph }
    bIdent,
    bType: BYTE;
    usFormat,
    usStyle,
    fs: USHORT;
    npspFirst,
    npspLast: pSUBPATH;
    csp: USHORT;
    flFlags: ULONG;
    usDimension: USHORT;
    bSubpathType: BYTE;
    alColor: LongInt;
    ausMixMode,
    ausDefault: USHORT;
    aptlRefPoint: POINTL;
    npcvAttrs: pCURVE;
    Reserved1: Array [0..6] Of BYTE
  End;
  pPATH    = ^PATH;

  PATHSEGMENT = Record                  { phs }
    usIdent: USHORT;
    Reserved0: SHORT;
    npcvFree: pCURVE;
    ccvFree,
    cReferences,
    usSize: USHORT;
    npph: pPATH;
    Reserved1: Array[0..1] Of BYTE;
    fsrs: DosFSRSEM {UNSURE: was "FSRSEM"}
  End;
  pPATHSEGMENT = ^PATHSEGMENT;

{ Argument to DrawCookedPath, etc. }

  PIPELINEINFO = Record                 { pi }
    pcv: pCURVE;
    ccv: ULONG
  End;
  pPIPELINEINFO = ^PIPELINEINFO;

Const
  JNL_TEMP_FILE           =  $00000001 ;
  JNL_PERM_FILE                    =  $00000002 ;
  JNL_ENGINERAM_FILE               =  $00000004 ;
  JNL_USERRAM_FILE                 =  $00000008 ;
  JNL_DRAW_OPTIMIZATION            =  $00000010 ;
  JNL_BOUNDS_OPTIMIZATION          =  $00000020 ;

{ QueryDeviceBitmaps }


Type
  BITMAPFORMAT = Record                 { bmf }
    cPlanes,
    cBitCount: ULONG
  End;
  pBITMAPFORMAT = ^BITMAPFORMAT;

Implementation
  Function GetDriverInfo;                 External 'PMGRE'    Index   30;
  Function GreInitialize;                 External 'PMGRE'    Index    4;
  Function PostDeviceModes;               External 'PMGRE'    Index   32;
  Function SetDriverInfo;                 External 'PMGRE'    Index   31;
End.

