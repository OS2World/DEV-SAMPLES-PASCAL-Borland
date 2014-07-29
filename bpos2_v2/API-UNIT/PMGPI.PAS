{ **************************************************************************\
*
* Module Name: PMGPI.H
*
* OS/2 Presentation Manager GPI constants, types and function declarations
*
* Copyright (c) International Business Machines Corporation 1981, 1988-1990
*
* =============================================================================
*
* The following symbols are used in this file for conditional sections.
*
*   INCL_GPI                Include all of the GPI
*   INCL_GPICONTROL         Basic PS control
*   INCL_GPICORRELATION     Picking, Boundary and Correlation
*   INCL_GPISEGMENTS        Segment Control and Drawing
*   INCL_GPISEGEDITING      Segment Editing via Elements
*   INCL_GPITRANSFORMS      Transform and Transform Conversion
*   INCL_GPIPATHS           Paths and Clipping with Paths
*   INCL_GPILOGCOLORTABLE   Logical Color Tables
*   INCL_GPIPRIMITIVES      Drawing Primitives and Primitive Attributes
*   INCL_GPILCIDS           Phyical and Logical Fonts with Lcids
*   INCL_GPIBITMAPS         Bitmaps and Pel Operations
*   INCL_GPIREGIONS         Regions and Clipping with Regions
*   INCL_GPIMETAFILES       Metafiles
*   INCL_GPIDEFAULTS        Default Primitive Attributes
*   INCL_GPIERRORS          defined if INCL_ERRORS defined
*
* There is a symbol used in this file called INCL_DDIDEFS. This is used to
* include only the definitions for the DDI. The programmer using the GPI
* can ignore this symbol
*
* There is a symbol used in this file called INCL_SAADEFS. This is used to
* include only the definitions for the SAA. The programmer using the GPI
* can ignore this symbol
*
\**************************************************************************}
{| Version:   1.00
 | Original translation: Peter Singer (PSi)
 }
Unit PmGPI;
Interface
Uses
  Os2Def;

CONST
 {  General GPI return values }
   GPI_ERROR                   =   0;
   GPI_OK                      =   1;
   GPI_ALTERROR                =  -1;

 {  fixed point number - implicit binary point between 2 and 3 hex digits }
TYPE
   FIXED  = LONG;             { fx }
   PFIXED = ^FIXED;

 {  fixed point number - implicit binary point between 1st and 2nd hex digits }
   FIXED88 = USHORT;         { fx88 }

 {  fixed point signed number - implicit binary point between bits 14 and 13. }
 {                              Bit 15 is the sign bit.                       }
 {                              Thus 1.0 is represented by 16384 (0x4000)     }
 {                              and -1.0 is represented by -16384 (0xc000)    }
   FIXED114 = USHORT;         { fx114 }

 {  make FIXED number from SHORT integer part and USHORT fractional part }
{***MC #define MAKEFIXED(intpart,fractpart) MAKELONG(fractpart,intpart)}
 {  extract fractional part from a fixed quantity }
{****MC #define FIXEDFRAC(fx)                (LOUSHORT(fx))}
 {  extract integer part from a fixed quantity }
{****MV #define FIXEDINT(fx)                 ((SHORT)HIUSHORT(fx))}

 {  structure for size parameters e.g. for GpiCreatePS }
TYPE
    SIZEL = record            {  sizl }
      cx,
      cy: LONG;
    end;
    PSIZEL =^SIZEL;

CONST
 {  return code on GpiQueryLogColorTable,GpiQueryRealColors and GpiQueryPel }
 CLR_NOINDEX               =  -254;


 {  units for GpiCreatePS and others }
 PU_ARBITRARY              = $0004;
 PU_PELS                   = $0008;
 PU_LOMETRIC               = $000C;
 PU_HIMETRIC               = $0010;
 PU_LOENGLISH              = $0014;
 PU_HIENGLISH              = $0018;
 PU_TWIPS                  = $001C;

 {  format for GpiCreatePS }
 GPIF_DEFAULT              =     0;
 GPIF_SHORT                = $0100;
 GPIF_LONG                 = $0200;


 {  PS type for GpiCreatePS }
 GPIT_NORMAL               =     0;
 GPIT_MICRO                = $1000;


 {  implicit associate flag for GpiCreatePS }
 GPIA_NOASSOC              =     0;
 GPIA_ASSOC                = $4000;

 {  return error for GpiQueryDevice }
 HDC_ERROR                = HDC(-1);

 {  common GPICONTROL functions }
Function GpiCreatePS(hab: HAB; hdc: HDC; psizlSize: PSIZEL; flOptions: ULONG): HPS;
Function GpiDestroyPS(hps: HPS): BOOL;
Function GpiAssociate(hps: HPS; hdc: HDC): BOOL;
Function GpiRestorePS(hps: HPS; lPSid: LONG): BOOL;
Function GpiSavePS(hps: HPS): LONG;
Function GpiErase(hps: HPS): BOOL;

Function GpiQueryDevice(hps: HPS): HDC;

CONST
 {  options for GpiResetPS }
 GRES_ATTRS                = $0001;
 GRES_SEGMENTS             = $0002;
 GRES_ALL                  = $0004;

 {  option masks for PS options used by GpiQueryPs }
 PS_UNITS                  = $00FC;
 PS_FORMAT                 = $0F00;
 PS_TYPE                   = $1000;
 PS_MODE                   = $2000;
 PS_ASSOCIATE              = $4000;
 PS_NORESET                = $8000;


 {  error context returned by GpiErrorSegmentData }
 GPIE_SEGMENT              =     0;
 GPIE_ELEMENT              =     1;
 GPIE_DATA                 =     2;


 {  control parameter for GpiSetDrawControl }
 DCTL_ERASE                =     1;
 DCTL_DISPLAY              =     2;
 DCTL_BOUNDARY             =     3;
 DCTL_DYNAMIC              =     4;
 DCTL_CORRELATE            =     5;

 {  constants for GpiSet/QueryDrawControl }
 DCTL_ERROR                =    -1;
 DCTL_OFF                  =     0;
 DCTL_ON                   =     1;

 {  constants for GpiSet/QueryStopDraw }
 SDW_ERROR                 =    -1;
 SDW_OFF                   =     0;
 SDW_ON                    =     1;


 {  drawing for GpiSet/QueryDrawingMode }
 DM_ERROR                  =     0;
 DM_DRAW                   =     1;
 DM_RETAIN                 =     2;
 DM_DRAWANDRETAIN          =     3;

 { ** other GPICONTROL functions }
Function GpiResetPS(hps: HPS; flOptions: ULONG): BOOL;

Function GpiSetPS(hps: HPS; psizlsize: PSIZEL; flOptions: ULONG): BOOL;


Function GpiQueryPS(hps: HPS; psizlSize: PSIZEL): ULONG;
Function GpiErrorSegmentData(hps: HPS; plSegment, plContext: PLONG): LONG;

Function GpiQueryDrawControl(hps: HPS; lControl: LONG): LONG;
Function GpiSetDrawControl(hps: HPS; lControl, lValue: LONG): BOOL;

Function GpiQueryDrawingMode(hps: HPS): LONG;
Function GpiSetDrawingMode(hps: HPS; lMode: LONG): BOOL;

Function GpiQueryStopDraw(hps: HPS): LONG;
Function GpiSetStopDraw(hps: HPS; lValue: LONG): BOOL;

CONST
 {  options for GpiSetPickApertureSize }
 PICKAP_DEFAULT              =   0;
 PICKAP_REC                  =   2;

 {  type of correlation for GpiCorrelateChain }
 PICKSEL_VISIBLE             =   0;
 PICKSEL_ALL                 =   1;

 {  return code to indicate correlate hit(s) }
 GPI_HITS                    =   2;

 { ** picking,  correlation and boundary functions }
Function GpiCorrelateChain(hps: HPS; lType: LONG; pptlPick: PPOINTL;
                           lMaxHits, lMaxDepth: LONG; pl2: PLONG): LONG;
Function GpiQueryTag(hps: HPS; plTag: PLONG): BOOL;
Function GpiSetTag(hps: HPS; lTag: LONG): BOOL;
Function GpiQueryPickApertureSize(hps: HPS; psizlSize: PSIZEL): BOOL;
Function GpiSetPickApertureSize(hps: HPS; lOptions: LONG; psizlSize: PSIZEL): BOOL;


Function GpiQueryPickAperturePosition(hps: HPS; pptlPoint: PPOINTL): BOOL;
Function GpiSetPickAperturePosition(hps: HPS; pptlPick: PPOINTL): BOOL;
Function GpiQueryBoundaryData(hps: HPS; prclBoundary: PRECTL): BOOL;
Function GpiResetBoundaryData(hps: HPS): BOOL;

Function GpiCorrelateFrom(hps: HPS; lFirstSegment, lLastSegment: LONG;
                          lType: LONG; pptlPick: PPOINTL;
                          lMaxHits, lMaxDepth: LONG; plSegTag: PLONG): LONG;
Function GpiCorrelateSegment(hps: HPS; lSegment, lType: LONG;
                             pptlPick: PPOINTL; lMaxHits, lMaxDepth: LONG;
                             alSegTag: PLONG): LONG;

CONST
 {  data formats for GpiPutData and GpiGetData }
 DFORM_NOCONV                 =  0;


 DFORM_S370SHORT              =  1;
 DFORM_PCSHORT                =  2;
 DFORM_PCLONG                 =  4;


 {  segment attributes used by GpiSet/QuerySegmentAttrs and others }
 ATTR_ERROR                   = -1;
 ATTR_DETECTABLE              =  1;
 ATTR_VISIBLE                 =  2;
 ATTR_CHAINED                 =  6;
 ATTR_DYNAMIC                 =  8;
 ATTR_FASTCHAIN               =  9;
 ATTR_PROP_DETECTABLE         = 10;
 ATTR_PROP_VISIBLE            = 11;

 {  attribute on/off values }
 ATTR_OFF                     =  0;
 ATTR_ON                      =  1;

 {  segment priority used by GpiSetSegmentPriority and others }
 LOWER_PRI                    = -1;
 HIGHER_PRI                   =  1;

 { ** segment control functions }
Function GpiOpenSegment(hps: HPS; lSegment: LONG): BOOL;
Function GpiCloseSegment(hps: HPS): BOOL;
Function GpiDeleteSegment(hps: HPS; lSegid: LONG): BOOL;
Function GpiQueryInitialSegmentAttrs(hps: HPS; lAttribute: LONG): LONG;
Function GpiSetInitialSegmentAttrs(hps: HPS; lAttribute, lValue: LONG): BOOL;
Function GpiQuerySegmentAttrs(hps: HPS; lSegid, lAttribute: LONG): LONG;
Function GpiSetSegmentAttrs(hps: HPS; lSegid, lAttribute: LONG;
                            lValue: LONG): BOOL;
Function GpiQuerySegmentPriority(hps: HPS; lRefSegid, lOrder: LONG): LONG;
Function GpiSetSegmentPriority(hps: HPS; lSegid, lRefSegid: LONG;
                               lOrder: LONG): BOOL;
Function GpiDeleteSegments(hps: HPS; lFirstSegment, lLastSegment: LONG): BOOL;
Function GpiQuerySegmentNames(hps: HPS; lFirstSegid, lLastSegid: LONG;
                              lMax: LONG; alSegids: PLONG): LONG;

 { ** draw functions for segments }
Function GpiGetData(hps: HPS; lSegid: LONG; plOffset: PLONG;
                    lFormat, lLength: LONG; pbData: PBYTE): LONG;
Function GpiPutData(hps: HPS; lFormat: LONG; plCount: PLONG; pbData: PBYTE): LONG;
Function GpiDrawChain(hps: HPS): BOOL;
Function GpiDrawFrom(hps: HPS; lFirstSegment, lLastSegment: LONG): BOOL;
Function GpiDrawSegment(hps: HPS; lSegment: LONG): BOOL;


Function GpiDrawDynamics(hps: HPS): BOOL;
Function GpiRemoveDynamics(hps: HPS; lFirstSegid, lLastSegid: LONG): BOOL;

CONST
 {  edit modes used by GpiSet/QueryEditMode }
 SEGEM_ERROR                       = 0;
 SEGEM_INSERT                      = 1;
 SEGEM_REPLACE                     = 2;

 { ** segment editing by element functions }
Function GpiBeginElement(hps: HPS; lType: LONG; pszDesc: PSZ): BOOL;
Function GpiEndElement(hps: HPS): BOOL;
Function GpiLabel(hps: HPS; lLabel: LONG): BOOL;
Function GpiElement(hps: HPS; lType: LONG; pszDesc: PSZ; lLength: LONG;
                    pbData: PBYTE): LONG;
Function GpiQueryElement(hps: HPS; lOff, lMaxLength: LONG; pbData: PBYTE): LONG;
Function GpiDeleteElement(hps: HPS): BOOL;
Function GpiDeleteElementRange(hps: HPS; lFirstElement: LONG;
                               lLastElement: LONG): BOOL;
Function GpiDeleteElementsBetweenLabels(hps: HPS; lFirstLabel: LONG;
                                        lLastLabel: LONG): BOOL;
Function GpiQueryEditMode(hps: HPS): LONG;
Function GpiSetEditMode(hps: HPS; lMode: LONG): BOOL;
Function GpiQueryElementPointer(hps: HPS): LONG;
Function GpiSetElementPointer(hps: HPS; lElement: LONG): BOOL;
Function GpiOffsetElementPointer(hps: HPS; loffset: LONG): BOOL;
Function GpiQueryElementType(hps: HPS; plType: PLONG; lLength: LONG;
                             pszData: PSZ): LONG;
Function GpiSetElementPointerAtLabel(hps: HPS; lLabel: LONG): BOOL;

CONST
 {  co-ordinates space for GpiConvert }
 CVTC_WORLD                    = 1;
 CVTC_MODEL                    = 2;
 CVTC_DEFAULTPAGE              = 3;
 CVTC_PAGE                     = 4;
 CVTC_DEVICE                   = 5;

 {  type of transformation for GpiSetSegmentTransformMatrix }
 TRANSFORM_REPLACE             = 0;
 TRANSFORM_ADD                 = 1;
 TRANSFORM_PREEMPT             = 2;

TYPE
 {  transform matrix }
    MATRIXLF = record           {  matlf }
      fxM11,
      fxM12  : FIXED;
      lM13   : LONG;
      fxM21,
      fxM22  : FIXED;
      lM23,
      lM31,
      lM32,
      lM33   : LONG;
    end;
    PMATRIXLF =^MATRIXLF;


   {** transform and transform conversion functions }
Function GpiQuerySegmentTransformMatrix(hps: HPS; lSegid, lCount: LONG;
                                        pmatlfArray: PMATRIXLF): BOOL;
Function GpiSetSegmentTransformMatrix(hps: HPS; lSegid, lCount: LONG;
                                      pmatlfarray: PMATRIXLF; lOptions: LONG): BOOL;
Function GpiConvert(hps: HPS; lSrc, lTarg, lCount: LONG;
                    aptlPoints: PPOINTL): BOOL;
Function GpiQueryModelTransformMatrix(hps: HPS; lCount: LONG;
                                      pmatlfArray: PMATRIXLF): BOOL;
Function GpiSetModelTransformMatrix(hps: HPS; lCount: LONG;
                                    pmatlfArray: PMATRIXLF; lOptions: LONG): BOOL;
Function GpiCallSegmentMatrix(hps: HPS; lSegment, lCount: LONG;
                              pmatlfArray: PMATRIXLF; lOptions: LONG): LONG;
Function GpiQueryDefaultViewMatrix(hps: HPS; lCount: LONG;
                                   pmatlfArray: PMATRIXLF): BOOL;
Function GpiSetDefaultViewMatrix(hps: HPS; lCount: LONG;
                                 pmatlfarray: PMATRIXLF; lOptions: LONG): BOOL;
Function GpiQueryPageViewport(hps: HPS; prclViewport: PRECTL): BOOL;
Function GpiSetPageViewport(hps: HPS; prclViewport: PRECTL): BOOL;
Function GpiQueryViewingTransformMatrix(hps: HPS; lCount: LONG;
                                        pmatlfArray: PMATRIXLF): BOOL;
Function GpiSetViewingTransformMatrix(hps: HPS; lCount: LONG;
                                      pmatlfArray: PMATRIXLF; lOptions: LONG): BOOL;

 { ** transform helper routines }
Function GpiTranslate(hps: HPS; pmatrixlf: PMATRIXLF; long: LONG; PPOINTL: PPOINTL): BOOL;
Function GpiScale(hps: HPS; pmatrixlf: PMATRIXLF; long: LONG; pfixed: PFIXED; ppointl: PPOINTL): BOOL;
Function GpiRotate(hps: HPS; pmatrixlf: PMATRIXLF; long: LONG; fixed: FIXED; ppointl: PPOINTL): BOOL;

 { ** general clipping functions }
Function GpiSetGraphicsField(hps: HPS; prclField: PRECTL): BOOL;
Function GpiQueryGraphicsField(hps: HPS; prclField: PRECTL): BOOL;
Function GpiSetViewingLimits(hps: HPS; prclLimits: PRECTL): BOOL;
Function GpiQueryViewingLimits(hps: HPS; prclLimits: PRECTL): BOOL;

CONST
 {  modes for GpiModifyPath }
 MPATH_STROKE                 =  6;

 {  modes for GpiFillPath }
 FPATH_ALTERNATE              =  0;
 FPATH_WINDING                =  2;

 {  modes for GpiSetClipPath }
 SCP_ALTERNATE                =  0;
 SCP_WINDING                  =  2;
 SCP_AND                      =  4;
 SCP_RESET                    =  0;


 { ** Path and Clip Path functions }
Function GpiBeginPath(hps: HPS; lPath: LONG): BOOL;
Function GpiEndPath(hps: HPS): BOOL;
Function GpiCloseFigure(hps: HPS): BOOL;
Function GpiModifyPath(hps: HPS; lPath, lMode: LONG): BOOL;
Function GpiFillPath(hps: HPS; lPath, lOptions: LONG): LONG;
Function GpiSetClipPath(hps: HPS; lPath, lOptions: LONG): BOOL;
Function GpiOutlinePath(hps: HPS; lPath, lOptions: LONG): LONG;

Function GpiStrokePath(hps: HPS; lPath: LONG; flOptions: ULONG): LONG;

CONST
 {  options for GpiCreateLogColorTable and others }
 LCOL_RESET                = $0001;
 LCOL_REALIZABLE           = $0002;
 LCOL_PURECOLOR            = $0004;

 {  format of logical lColor table for GpiCreateLogColorTable and others }
 LCOLF_DEFAULT             =     0;
 LCOLF_INDRGB              =     1;
 LCOLF_CONSECRGB           =     2;
 LCOLF_RGB                 =     3;

 {  options for GpiQueryRealColors and others }
 LCOLOPT_REALIZED          = $0001;
 LCOLOPT_INDEX             = $0002;


 {  return codes from GpiQueryLogColorTable to indicate it is in RGB mode }
 QLCT_ERROR                =    -1;
 QLCT_RGB                  =    -2;

 {  GpiQueryLogColorTable index returned for colors not explicitly loaded }
 QLCT_NOTLOADED            =    -1;


 {  return codes for GpiQueryColorData }
 QCD_LCT_FORMAT            =     0;
 QCD_LCT_LOINDEX           =     1;
 QCD_LCT_HIINDEX           =     2;


 { ** logical lColor table functions }
Function GpiCreateLogColorTable(hps: HPS; flOptions: ULONG; lFormat: LONG;
                                lStart, lCount: LONG; alTable: PLONG): BOOL;
Function GpiRealizeColorTable(hps: HPS): BOOL;
Function GpiUnrealizeColorTable(hps: HPS): BOOL;
Function GpiQueryColorData(hps: HPS; lCount: LONG; alArray: PLONG): BOOL;

Function GpiQueryLogColorTable(hps: HPS; flOptions: ULONG; lStart: LONG;
                               lCount: LONG; alArray: PLONG): LONG;

Function GpiQueryRealColors(hps: HPS; flOptions: ULONG; lStart: LONG;
                            lCount: LONG; alColors: PLONG): LONG;
Function GpiQueryNearestColor(hps: HPS; flOptions: ULONG; lRgbIn: LONG): LONG;
Function GpiQueryColorIndex(hps: HPS; flOptions: ULONG; lRgbColor: LONG): LONG;
Function GpiQueryRGBColor(hps: HPS; flOptions: ULONG; lColorIndex: LONG): LONG;


CONST
 {  default color table indices }

 CLR_FALSE             =        -5;
 CLR_TRUE              =        -4;

 CLR_ERROR             =      -255;
 CLR_DEFAULT           =        -3;
 CLR_WHITE             =        -2;
 CLR_BLACK             =        -1;
 CLR_BACKGROUND        =         0;
 CLR_BLUE              =         1;
 CLR_RED               =         2;
 CLR_PINK              =         3;
 CLR_GREEN             =         4;
 CLR_CYAN              =         5;
 CLR_YELLOW            =         6;
 CLR_NEUTRAL           =         7;

 CLR_DARKGRAY          =         8;
 CLR_DARKBLUE          =         9;
 CLR_DARKRED           =        10;
 CLR_DARKPINK          =        11;
 CLR_DARKGREEN         =        12;
 CLR_DARKCYAN          =        13;
 CLR_BROWN             =        14;
 CLR_PALEGRAY          =        15;

 {  rgb colors }
 RGB_ERROR             =      -255;
 RGB_BLACK             = $00000000;
 RGB_BLUE              = $000000FF;
 RGB_GREEN             = $0000FF00;
 RGB_CYAN              = $0000FFFF;
 RGB_RED               = $00FF0000;
 RGB_PINK              = $00FF00FF;
 RGB_YELLOW            = $00FFFF00;
 RGB_WHITE             = $00FFFFFF;

 {  control flags used by GpiBeginArea }
 BA_NOBOUNDARY             =     0;
 BA_BOUNDARY               = $0001;


 BA_ALTERNATE              =     0;
 BA_WINDING                = $0002;


 {  fill options for GpiBox/GpiFullArc }
 DRO_FILL                   =    1;
 DRO_OUTLINE                =    2;
 DRO_OUTLINEFILL            =    3;

 {  basic pattern symbols }
 PATSYM_ERROR               =   -1;
 PATSYM_DEFAULT             =    0;
 PATSYM_DENSE1              =    1;
 PATSYM_DENSE2              =    2;
 PATSYM_DENSE3              =    3;
 PATSYM_DENSE4              =    4;
 PATSYM_DENSE5              =    5;
 PATSYM_DENSE6              =    6;
 PATSYM_DENSE7              =    7;
 PATSYM_DENSE8              =    8;
 PATSYM_VERT                =    9;
 PATSYM_HORIZ               =   10;
 PATSYM_DIAG1               =   11;
 PATSYM_DIAG2               =   12;
 PATSYM_DIAG3               =   13;
 PATSYM_DIAG4               =   14;
 PATSYM_NOSHADE             =   15;
 PATSYM_SOLID               =   16;
 PATSYM_BLANK               =   64;
 PATSYM_HALFTONE            =   17;

 {  lcid values for GpiSet/QueryPattern and others }
 LCID_ERROR                 =   -1;
 LCID_DEFAULT               =    0;


 { ** global primitive functions }
Function GpiSetColor(hps: HPS; lColor: LONG): BOOL;
Function GpiQueryColor(hps: HPS): LONG;

 { ** line primitive functions }
Function GpiBox(hps: HPS; lControl: LONG; pptlPoint: PPOINTL;
                lHRound, lVRound: LONG): LONG;

Function GpiMove(hps: HPS; pptlPoint: PPOINTL): BOOL;
Function GpiLine(hps: HPS; pptlEndPoint: PPOINTL): LONG;
Function GpiPolyLine(hps: HPS; lCount: LONG; aptlPoints: PPOINTL): LONG;

 { ** area primitive functions }
Function GpiSetPattern(hps: HPS; lPatternSymbol: LONG): BOOL;
Function GpiQueryPattern(hps: HPS): LONG;
Function GpiBeginArea(hps: HPS; flOptions: ULONG): BOOL;
Function GpiEndArea(hps: HPS): LONG;

 { ** character primitive functions }
Function GpiCharString(hps: HPS; lCount: LONG; pchString: PCH): LONG;
Function GpiCharStringAt(hps: HPS; pptlPoint: PPOINTL; lCount: LONG;
                         pchString: PCH): LONG;

CONST
 {  mode for GpiSetAttrMode }
 AM_ERROR                =      -1;
 AM_PRESERVE             =       0;
 AM_NOPRESERVE           =       1;

 {  foreground mixes }
 FM_ERROR                =      -1;
 FM_DEFAULT              =       0;
 FM_OR                   =       1;
 FM_OVERPAINT            =       2;
 FM_LEAVEALONE           =       5;


 FM_XOR                  =       4;
 FM_AND                  =       6;
 FM_SUBTRACT             =       7;
 FM_MASKSRCNOT           =       8;
 FM_ZERO                 =       9;
 FM_NOTMERGESRC          =      10;
 FM_NOTXORSRC            =      11;
 FM_INVERT               =      12;
 FM_MERGESRCNOT          =      13;
 FM_NOTCOPYSRC           =      14;
 FM_MERGENOTSRC          =      15;
 FM_NOTMASKSRC           =      16;
 FM_ONE                  =      17;


 {  background mixes }
 BM_ERROR                =      -1;
 BM_DEFAULT              =       0;
 BM_OVERPAINT            =       2;
 BM_LEAVEALONE           =       5;


 BM_OR                   =       1;
 BM_XOR                  =       4;


 {  basic line type styles }
 LINETYPE_ERROR          =      -1;
 LINETYPE_DEFAULT        =       0;
 LINETYPE_DOT            =       1;
 LINETYPE_SHORTDASH      =       2;
 LINETYPE_DASHDOT        =       3;
 LINETYPE_DOUBLEDOT      =       4;
 LINETYPE_LONGDASH       =       5;
 LINETYPE_DASHDOUBLEDOT  =       6;
 LINETYPE_SOLID          =       7;
 LINETYPE_INVISIBLE      =       8;
 LINETYPE_ALTERNATE      =       9;

 {  cosmetic line widths }
 LINEWIDTH_ERROR         =      -1;
 LINEWIDTH_DEFAULT       =       0;
 LINEWIDTH_NORMAL      = $00010000;    {  MAKEFIXED(1,0) }

 {  actual line widths }
 LINEWIDTHGEOM_ERROR       =    -1;

 {  line end styles }
 LINEEND_ERROR             =    -1;
 LINEEND_DEFAULT           =     0;
 LINEEND_FLAT              =     1;
 LINEEND_SQUARE            =     2;
 LINEEND_ROUND             =     3;

 {  line join styles }
 LINEJOIN_ERROR            =    -1;
 LINEJOIN_DEFAULT          =     0;
 LINEJOIN_BEVEL            =     1;
 LINEJOIN_ROUND            =     2;
 LINEJOIN_MITRE            =     3;

 {  character directions }
 CHDIRN_ERROR              =    -1;
 CHDIRN_DEFAULT            =     0;
 CHDIRN_LEFTRIGHT          =     1;
 CHDIRN_TOPBOTTOM          =     2;
 CHDIRN_RIGHTLEFT          =     3;
 CHDIRN_BOTTOMTOP          =     4;

 {  character modes }
 CM_ERROR                  =    -1;
 CM_DEFAULT                =     0;
 CM_MODE1                  =     1;
 CM_MODE2                  =     2;
 CM_MODE3                  =     3;

 {  basic marker symbols }
 MARKSYM_ERROR             =    -1;
 MARKSYM_DEFAULT           =     0;
 MARKSYM_CROSS             =     1;
 MARKSYM_PLUS              =     2;
 MARKSYM_DIAMOND           =     3;
 MARKSYM_SQUARE            =     4;
 MARKSYM_SIXPOINTSTAR      =     5;
 MARKSYM_EIGHTPOINTSTAR    =     6;
 MARKSYM_SOLIDDIAMOND      =     7;
 MARKSYM_SOLIDSQUARE       =     8;
 MARKSYM_DOT               =     9;
 MARKSYM_SMALLCIRCLE       =    10;
 MARKSYM_BLANK             =    64;

 {  formatting options for GpiCharStringPosAt }
 CHS_OPAQUE                = $0001;
 CHS_VECTOR                = $0002;
 CHS_LEAVEPOS              = $0008;
 CHS_CLIP                  = $0010;

 {  bundle codes for GpiSetAttributes and GpiQueryAttributes }
 PRIM_LINE                 =     1;
 PRIM_CHAR                 =     2;
 PRIM_MARKER               =     3;
 PRIM_AREA                 =     4;
 PRIM_IMAGE                =     5;

 {  line bundle mask bits }
 LBB_COLOR                 = $0001;
 LBB_MIX_MODE              = $0004;
 LBB_WIDTH                 = $0010;
 LBB_GEOM_WIDTH            = $0020;
 LBB_TYPE                  = $0040;
 LBB_END                   = $0080;
 LBB_JOIN                  = $0100;

 {  character bundle mask bits }
 CBB_COLOR                 = $0001;
 CBB_BACK_COLOR            = $0002;
 CBB_MIX_MODE              = $0004;
 CBB_BACK_MIX_MODE         = $0008;
 CBB_SET                   = $0010;
 CBB_MODE                  = $0020;
 CBB_BOX                   = $0040;
 CBB_ANGLE                 = $0080;
 CBB_SHEAR                 = $0100;
 CBB_DIRECTION             = $0200;

 {  marker bundle mask bits }
 MBB_COLOR                 = $0001;
 MBB_BACK_COLOR            = $0002;
 MBB_MIX_MODE              = $0004;
 MBB_BACK_MIX_MODE         = $0008;
 MBB_SET                   = $0010;
 MBB_SYMBOL                = $0020;
 MBB_BOX                   = $0040;

 {  pattern bundle mask bits }
 ABB_COLOR                 = $0001;
 ABB_BACK_COLOR            = $0002;
 ABB_MIX_MODE              = $0004;
 ABB_BACK_MIX_MODE         = $0008;
 ABB_SET                   = $0010;
 ABB_SYMBOL                = $0020;
 ABB_REF_POINT             = $0040;

 {  image bundle mask bits }
 IBB_COLOR                 = $0001;
 IBB_BACK_COLOR            = $0002;
 IBB_MIX_MODE              = $0004;
 IBB_BACK_MIX_MODE         = $0008;

TYPE
 {  structure for GpiSetArcParams and GpiQueryArcParams }
    ARCPARAMS = record         {  arcp }
      lP,
      lQ,
      lR,
      lS: LONG;
    end;
    PARCPARAMS = ^ARCPARAMS;

 {  variation of SIZE used for FIXEDs }
    SIZEF = record            {  sizfx }
      cx,
      cy: FIXED;
    end;
    PSIZEF = ^SIZEF;

 {  structure for gradient parameters e.g. for GpiSetCharAngle }
    GRADIENTL = record          {  gradl }
      x,
      y: LONG;
    end;
    PGRADIENTL = ^GRADIENTL;

 {  line bundle for GpiSetAttributes and GpiQueryAttributes }
    LINEBUNDLE = record         {  lbnd }
      lColor,
      lReserved: LONG;
      usMixMode,
      usReserved: USHORT;
      fxWidth: FIXED;
      lGeomWidth: LONG;
      usType,
      usEnd,
      usJoin: USHORT
    end;

 {  character bundle for GpiSetAttributes and GpiQueryAttributes }
    CHARBUNDLE = record          {  cbnd }
      lColor,
      lBackColor: LONG;
      usMixMode,
      usBackMixMode,
      usSet,
      usPrecision: USHORT;
      sizfxCell: SIZEF;
      ptlAngle,
      ptlShear: POINTL;
      usDirection: USHORT;
    end;

 {  marker bundle for GpiSetAttributes and GpiQueryAttributes }
    MARKERBUNDLE = record        {  mbnd }
      lColor,
      lBackColor: LONG;
      usMixMode,
      usBackMixMode,
      usSet,
      usSymbol: USHORT;
      sizfxCell: SIZEF;
    end;

 {  pattern bundle for GpiSetAttributes and GpiQueryAttributes }
    AREABUNDLE = record      {  pbnd }
      lColor,
      lBackColor: LONG;
      usMixMode,
      usBackMixMode,
      usSet,
      usSymbol: USHORT;
      ptlRefPoint: POINTL;
    end;

 {  image bundle for GpiSetAttributes and GpiQueryAttributes }
    IMAGEBUNDLE = record         {  ibmd }
      lColor,
      lBackColor: LONG;
      usMixMode,
      usBackMixMode: USHORT;
    end;

 {  pointer to any bundle used by GpiSet/QueryAttrs }
    PBUNDLE = PVOID;

CONST
 {  array indices for GpiQueryTextBox }
 TXTBOX_TOPLEFT                = 0;
 TXTBOX_BOTTOMLEFT             = 1;
 TXTBOX_TOPRIGHT               = 2;
 TXTBOX_BOTTOMRIGHT            = 3;
 TXTBOX_CONCAT                 = 4;
 {  array count for GpiQueryTextBox }
 TXTBOX_COUNT                  = 5;

 {  return codes for GpiPtVisible }
 PVIS_ERROR                    = 0;
 PVIS_INVISIBLE                = 1;
 PVIS_VISIBLE                  = 2;

 {  return codes for GpiRectVisible }
 RVIS_ERROR                    = 0;
 RVIS_INVISIBLE                = 1;
 RVIS_PARTIAL                  = 2;
 RVIS_VISIBLE                  = 3;


 { ** attribute mode functions }
Function GpiSetAttrMode(hps: HPS; lMode: LONG): BOOL;
Function GpiQueryAttrMode(hps: HPS): LONG;
 { ** bundle primitive functions }
Function GpiSetAttrs(hps: HPS; lPrimType: LONG; flAttrMask: ULONG;
                     flDefMask: ULONG; ppbunAttrs: PBUNDLE): BOOL;


Function GpiQueryAttrs(hps: HPS; lPrimType: LONG; flAttrMask: ULONG;
                       ppbunAttrs: PBUNDLE): LONG;


 { ** global primitive functions }
Function GpiSetBackColor(hps: HPS; lColor: LONG): BOOL;
Function GpiQueryBackColor(hps: HPS): LONG;
Function GpiSetMix(hps: HPS; lMixMode: LONG): BOOL;
Function GpiQueryMix(hps: HPS): LONG;
Function GpiSetBackMix(hps: HPS; lMixMode: LONG): BOOL;
Function GpiQueryBackMix(hps: HPS): LONG;

 { ** line primitive functions }
Function GpiSetLineType(hps: HPS; lLineType: LONG): BOOL;
Function GpiQueryLineType(hps: HPS): LONG;
Function GpiSetLineWidth(hps: HPS; fxLineWidth: FIXED): BOOL;
Function GpiQueryLineWidth(hps: HPS): FIXED;

Function GpiSetLineWidthGeom(hps: HPS; lLineWidth: LONG): BOOL;
Function GpiQueryLineWidthGeom(hps: HPS): LONG;
Function GpiSetLineEnd(hps: HPS; lLineEnd: LONG): BOOL;
Function GpiQueryLineEnd(hps: HPS): LONG;
Function GpiSetLineJoin(hps: HPS; lLineJoin: LONG): BOOL;
Function GpiQueryLineJoin(hps: HPS): LONG;

Function GpiSetCurrentPosition(hps: HPS; pptlPoint: PPOINTL): BOOL;
Function GpiQueryCurrentPosition(hps: HPS; pptlPoint: PPOINTL): BOOL;

 { ** arc primitive functions }
Function GpiSetArcParams(hps: HPS; parcpArcParams: PARCPARAMS): BOOL;
Function GpiQueryArcParams(hps: HPS; parcpArcParams: PARCPARAMS): BOOL;

Function GpiPointArc(hps: HPS; pptl2: PPOINTL): LONG;

Function GpiFullArc(hps: HPS; lControl: LONG; fxMultiplier: FIXED): LONG;
Function GpiPartialArc(hps: HPS; pptlCenter: PPOINTL; fxMultiplier: FIXED;
                       fxStartAngle, fxSweepAngle: FIXED): LONG;
Function GpiPolyFillet(hps: HPS; lCount: LONG; aptlPoints: PPOINTL): LONG;
Function GpiPolySpline(hps: HPS; lCount: LONG; aptlPoints: PPOINTL): LONG;
Function GpiPolyFilletSharp(hps: HPS; lCount: LONG; aptlPoints: PPOINTL;
                            afxPoints: PFIXED): LONG;

 { ** area primitive functions }
Function GpiSetPatternSet(hps: HPS; lSet: LONG): BOOL;
Function GpiQueryPatternSet(hps: HPS): LONG;
Function GpiSetPatternRefPoint(hps: HPS; pptlRefPoint: PPOINTL): BOOL;
Function GpiQueryPatternRefPoint(hps: HPS; pptlRefPoint: PPOINTL): BOOL;

 { ** character primitive functions }

Function GpiQueryCharStringPos(hps: HPS; flOptions: ULONG; lCount: LONG;
                               pchString: PCH; alXincrements: PLONG; aptlPositions: PPOINTL): BOOL;
Function GpiQueryCharStringPosAt(hps: HPS; pptlStart: PPOINTL; flOptions: ULONG;
                                 lCount: LONG; pchString: PCH; alXincrements: PLONG;
                                 aptlPositions: PPOINTL): BOOL;
Function GpiQueryTextBox(hps: HPS; lCount1: LONG; pchString: PCH;
                         lCount2: LONG; aptlPoints: PPOINTL): BOOL;
Function GpiQueryDefCharBox(hps: HPS; psizlSize: PSIZEL): BOOL;
Function GpiSetCharSet(hps: HPS; llcid: LONG): BOOL;
Function GpiQueryCharSet(hps: HPS): LONG;
Function GpiSetCharBox(hps: HPS; psizfxBox: PSIZEF): BOOL;
Function GpiQueryCharBox(hps: HPS; psizfxSize: PSIZEF): BOOL;
Function GpiSetCharAngle(hps: HPS; pgradlAngle: PGRADIENTL): BOOL;
Function GpiQueryCharAngle(hps: HPS; pgradlAngle: PGRADIENTL): BOOL;
Function GpiSetCharShear(hps: HPS; pptlAngle: PPOINTL): BOOL;
Function GpiQueryCharShear(hps: HPS; pptlShear: PPOINTL): BOOL;
Function GpiSetCharDirection(hps: HPS; lDirection: LONG): BOOL;
Function GpiQueryCharDirection(hps: HPS): LONG;
Function GpiSetCharMode(hps: HPS; lMode: LONG): BOOL;
Function GpiQueryCharMode(hps: HPS): LONG;

Function GpiCharStringPos(hps: HPS; prclRect: PRECTL; flOptions: ULONG;
                          lCount: LONG; pchString: PCH; alAdx: PLONG): LONG;
Function GpiCharStringPosAt(hps: HPS; pptlStart: PPOINTL; prclRect: PRECTL;
                            flOptions: ULONG; lCount: LONG; pchString: PCH;
                            alAdx: PLONG): LONG;

 { ** marker primitive functions  }
Function GpiMarker(hps: HPS; pptlPoint: PPOINTL): LONG;
Function GpiPolyMarker(hps: HPS; lCount: LONG; aptlPoints: PPOINTL): LONG;
Function GpiSetMarker(hps: HPS; lSymbol: LONG): BOOL;
Function GpiSetMarkerBox(hps: HPS; psizfxSize: PSIZEF): BOOL;
Function GpiSetMarkerSet(hps: HPS; lSet: LONG): BOOL;
Function GpiQueryMarker(hps: HPS): LONG;
Function GpiQueryMarkerBox(hps: HPS; psizfxSize: PSIZEF): BOOL;
Function GpiQueryMarkerSet(hps: HPS): LONG;

 { ** image primitive functions }
Function GpiImage(hps: HPS; lFormat: LONG; psizlImageSize: PSIZEL;
                  lLength: LONG; pbData: PBYTE): LONG;

 { ** miscellaneous primitive functions }
Function GpiPop(hps: HPS; lCount: LONG): BOOL;
Function GpiPtVisible(hps: HPS; pptlPoint: PPOINTL): LONG;
Function GpiRectVisible(hps: HPS; prclRectangle: PRECTL): LONG;
Function GpiComment(hps: HPS; lLength: LONG; pbData: PBYTE): BOOL;

CONST
 {  return codes from GpiCreateLogFont }
 FONT_DEFAULT                 =  1;
 FONT_MATCH                   =  2;

 {  lcid type for GpiQuerySetIds }
 LCIDT_FONT                   =  6;

 LCIDT_BITMAP                 =  7;

 {  constant used to delete all lcids by GpiDeleteSetId }
 LCID_ALL                     = -1;

TYPE
 {  kerning data returned by GpiQueryKerningPairs }
    KERNINGPAIRS = record        {  krnpr }
      sFirstChar,
      sSecondChar,
      sKerningAmount: SHORT;
    end;
    PKERNINGPAIRS = ^KERNINGPAIRS;

CONST
 {  options for GpiQueryFonts }
 QF_PUBLIC                 = $0001;
 QF_PRIVATE                = $0002;

TYPE
 {  font file descriptions for GpiQueryFontFileDescriptions }
  FFDESCS = array[0..1, 0..FACESIZE-1] of char;  {  ffdescs }
  PFFDESCS = ^FFDESCS;


 { ** physical and logical font functions }
Function GpiCreateLogFont(hps: HPS; pName: PSTR8; lLcid: LONG;
                          pfatAttrs: PFATTRS): LONG;
Function GpiDeleteSetId(hps: HPS; lLcid: LONG): BOOL;
Function GpiLoadFonts(hab: HAB; pszFilename: PSZ): BOOL;
Function GpiUnloadFonts(hab: HAB; pszFilename: PSZ): BOOL;
Function GpiQueryFonts(hps: HPS; flOptions: ULONG; pszFacename: PSZ;
                       plReqFonts: PLONG; lMetricsLength: LONG;
                       afmMetrics: PFONTMETRICS): LONG;
Function GpiQueryFontMetrics(hps: HPS; lMetricsLength: LONG;
                             pfmMetrics: PFONTMETRICS): BOOL;
Function GpiQueryKerningPairs(hps: HPS; lCount: LONG;
                              akrnprData: PKERNINGPAIRS): LONG;
Function GpiQueryWidthTable(hps: HPS; lFirstChar, lCount: LONG;
                            alData: PLONG): BOOL;
Function GpiQueryNumberSetIds(hps: HPS): LONG;
Function GpiQuerySetIds(hps: HPS; lCount: LONG; alTypes: PLONG;
                        aNames: PSTR8; allcids: PLONG): BOOL;

Function GpiSetCp(hps: HPS; usCodePage: USHORT): BOOL;
Function GpiQueryCp(hps: HPS): USHORT;
Function GpiQueryFontFileDescriptions(hab: HAB; pszFilename: PSZ;
                                      plCount: PLONG; affdescsNames: PFFDESCS): LONG;

CONST
 {  rastor operations defined for GpiBitBlt }
 ROP_SRCCOPY               = $00CC;
 ROP_SRCPAINT              = $00EE;
 ROP_SRCAND                = $0088;
 ROP_SRCINVERT             = $0066;
 ROP_SRCERASE              = $0044;
 ROP_NOTSRCCOPY            = $0033;
 ROP_NOTSRCERASE           = $0011;
 ROP_MERGECOPY             = $00C0;
 ROP_MERGEPAINT            = $00BB;
 ROP_PATCOPY               = $00F0;
 ROP_PATPAINT              = $00FB;
 ROP_PATINVERT             = $005A;
 ROP_DSTINVERT             = $0055;
 ROP_ZERO                  = $0000;
 ROP_ONE                   = $00FF;

 {  Blt options for GpiBitBlt }
 BBO_OR                    =     0;
 BBO_AND                   =     1;
 BBO_IGNORE                =     2;

 {  error return for GpiSetBitmap }
 HBM_ERROR                 = HBITMAP(-1);


 { ** bitmap and pel functions }
Function GpiBitBlt(hpsTarget, hpsSource: HPS; lCount: LONG;
                   aptlPoints: PPOINTL; lRop: LONG; flOptions: ULONG): LONG;
Function GpiDeleteBitmap(hbm: HBITMAP): BOOL;
Function GpiLoadBitmap(hps: HPS; Resource: HMODULE; idBitmap: USHORT;
                       lWidth, lHeight: LONG): HBITMAP;
Function GpiSetBitmap(hps: HPS; hbm: HBITMAP): HBITMAP;
Function GpiWCBitBlt(hpsTarget: HPS; hbmSource: HBITMAP; lCount: LONG;
                     aptlPoints: PPOINTL; lRop: LONG; flOptions: ULONG): LONG;

CONST
 {  usage flags for GpiCreateBitmap }
 CBM_INIT       = $0004;

TYPE
 {  bitmap parameterization used by GpiCreateBitmap and others }
    BITMAPINFOHEADER = record          {  bmp }
      cbFix: ULONG;
      cx,
      cy,
      cPlanes,
      cBitCount: USHORT;
    end;
    PBITMAPINFOHEADER = ^BITMAPINFOHEADER;

 {  RGB data for _BITMAPINFO struct }
    RGB = record                {  rgb }
      bBlue,
      bGreen,
      bRed: BYTE;
    end;

 {  bitmap data used by GpiSetBitmapBits and others }
    BITMAPINFO = record        {  bmi }
      cbFix: ULONG;
      cx,
      cy,
      cPlanes,
      cBitCount: USHORT;
      argbColor: array [0..0] of RGB;
    end;
    PBITMAPINFO = ^BITMAPINFO;

CONST
 {  error return code for GpiSet/QueryBitmapBits }
 BMB_ERROR                   =  -1;


 { ** bitmap and pel functions }
Function GpiCreateBitmap(hps: HPS; pbmpNew: PBITMAPINFOHEADER;
                         flOptions: ULONG; pbInitData: PBYTE;
                         pbmiInfoTable: PBITMAPINFO): HBITMAP;
Function GpiSetBitmapBits(hps: HPS; lScanStart, lScans: LONG;
                          pbBuffer: PBYTE; pbmiInfoTable: PBITMAPINFO): LONG;
Function GpiSetBitmapDimension(hbm: HBITMAP; psizlBitmapDimension: PSIZEL): BOOL;
Function GpiSetBitmapId(hps: HPS; hbm: HBITMAP; lLcid: LONG): BOOL;
Function GpiQueryBitmapBits(hps: HPS; lScanStart, lScans: LONG;
                            pbBuffer: PBYTE; pbmiInfoTable: PBITMAPINFO): LONG;
Function GpiQueryBitmapDimension(hbm: HBITMAP; psizlBitmapDimension: PSIZEL): BOOL;
Function GpiQueryBitmapHandle(hps: HPS; lLcid: LONG): HBITMAP;
Function GpiQueryBitmapParameters(hbm: HBITMAP; pbmpData: PBITMAPINFOHEADER): BOOL;
Function GpiQueryDeviceBitmapFormats(hps: HPS; lCount: LONG;
                                     alArray: PLONG): BOOL;

Function GpiSetPel(hps: HPS; pptlPoint: PPOINTL): LONG;
Function GpiQueryPel(hps: HPS; pptlPoint: PPOINTL): LONG;

CONST
 {  options for GpiCombineRegion }
 CRGN_OR                      =  1;
 CRGN_COPY                    =  2;
 CRGN_XOR                     =  4;
 CRGN_AND                     =  6;
 CRGN_DIFF                    =  7;

 {  usDirection of returned region data for GpiQueryRegionRects }
 RECTDIR_LFRT_TOPBOT          =  1;
 RECTDIR_RTLF_TOPBOT          =  2;
 RECTDIR_LFRT_BOTTOP          =  3;
 RECTDIR_RTLF_BOTTOP          =  4;

TYPE
 {  control data for GpiQueryRegionRects }
    RGNRECT = record            {  rgnrc }
      ircStart,
      crc,
      crcReturned,
      usDirection: USHORT;
    end;
    PRGNRECT = ^RGNRECT;

CONST
 {  return code to indicate type of region for GpiCombineRegion and others }
 RGN_ERROR                   =   0;
 RGN_NULL                    =   1;
 RGN_RECT                    =   2;
 RGN_COMPLEX                 =   3;

 {  return codes for GpiPtInRegion }
 PRGN_ERROR                  =   0;
 PRGN_OUTSIDE                =   1;
 PRGN_INSIDE                 =   2;

 {  return codes for GpiRectInRegion }
 RRGN_ERROR                  =   0;
 RRGN_OUTSIDE                =   1;
 RRGN_PARTIAL                =   2;
 RRGN_INSIDE                 =   3;

 {  return codes for GpiEqualRegion }
 EQRGN_ERROR                 =   0;
 EQRGN_NOTEQUAL              =   1;
 EQRGN_EQUAL                 =   2;

 {  error return code for GpiSetRegion }
 HRGN_ERROR                  = HRGN(-1);


 { ** main region functions }
Function GpiCombineRegion(hps: HPS; hrgnDest, hrgnSrc1: HRGN;
                          hrgnSrc2: HRGN; lMode: LONG): LONG;
Function GpiCreateRegion(hps: HPS; lCount: LONG; arclRectangles: PRECTL): HRGN;
Function GpiDestroyRegion(hps: HPS; hrgn: HRGN): BOOL;
Function GpiEqualRegion(hps: HPS; hrgnSrc1, hrgnSrc2: HRGN): LONG;
Function GpiOffsetRegion(hps: HPS; Hrgn: HRGN; pptlOffset: PPOINTL): BOOL;
Function GpiPaintRegion(hps: HPS; hrgn: HRGN): LONG;
Function GpiPtInRegion(hps: HPS; hrgn: HRGN; pptlPoint: PPOINTL): LONG;
Function GpiQueryRegionBox(hps: HPS; hrgn: HRGN; prclBound: PRECTL): LONG;
Function GpiQueryRegionRects(hps: HPS; hrgn: HRGN; prclBound: PRECTL;
                             prgnrcControl: PRGNRECT; prclRect: PRECTL): BOOL;
Function GpiRectInRegion(hps: HPS; hrgn: HRGN; prclRect: PRECTL): LONG;
Function GpiSetRegion(hps: HPS; hrgn: HRGN; lcount: LONG;
                      arclRectangles: PRECTL): BOOL;

 { ** clip region functions }
Function GpiSetClipRegion(hps: HPS; hrgn: HRGN; phrgnOld: PHRGN): LONG;

Function GpiQueryClipRegion(hps: HPS): HRGN;
Function GpiQueryClipBox(hps: HPS; prclBound: PRECTL): LONG;

Function GpiExcludeClipRectangle(hps: HPS; prclRectangle: PRECTL): LONG;
Function GpiIntersectClipRectangle(hps: HPS; prclRectangle: PRECTL): LONG;

Function GpiOffsetClipRegion(hps: HPS; pptlPoint: PPOINTL): LONG;

CONST
 {  constants for index values of options array for GpiPlayMetafile }
 PMF_SEGBASE                 =   0;
 PMF_LOADTYPE                =   1;
 PMF_RESOLVE                 =   2;
 PMF_LCIDS                   =   3;
 PMF_RESET                   =   4;
 PMF_SUPPRESS                =   5;
 PMF_COLORTABLES             =   6;
 PMF_COLORREALIZABLE         =   7;
 PMF_DEFAULTS                =   8;

 {  options for GpiPlayMetafile }
 RS_DEFAULT                  =   0;
 RS_NODISCARD                =   1;
 LC_DEFAULT                  =   0;
 LC_NOLOAD                   =   1;
 LC_LOADDISC                 =   3;
 LT_DEFAULT                  =   0;
 LT_NOMODIFY                 =   1;
 LT_ORIGINALVIEW             =   4;
 RES_DEFAULT                 =   0;
 RES_NORESET                 =   1;
 RES_RESET                   =   2;
 SUP_DEFAULT                 =   0;
 SUP_NOSUPPRESS              =   1;
 SUP_SUPPRESS                =   2;
 CTAB_DEFAULT                =   0;
 CTAB_NOMODIFY               =   1;
 CTAB_REPLACE                =   3;
 CREA_DEFAULT                =   0;
 CREA_REALIZE                =   1;
 CREA_NOREALIZE              =   2;


 DDEF_DEFAULT                =   0;
 DDEF_IGNORE                 =   1;
 DDEF_LOADDISC               =   3;
 RSP_DEFAULT                 =   0;
 RSP_NODISCARD               =   1;


 { ** metafile functions }
Function GpiCopyMetaFile(hmf: HMF): HMF;
Function GpiDeleteMetaFile(hmf: HMF): BOOL;
Function GpiLoadMetaFile(hab: HAB; pszFilename: PSZ): HMF;
Function GpiPlayMetaFile(hps: HPS; hmf: HMF; lCount1: LONG;
                         alOptarray, plSegCount: PLONG; lCount2: LONG;
                         pszDesc: PSZ): LONG;
Function GpiQueryMetaFileBits(hmf: HMF; lOffset, lLength: LONG;
                              pbData: PBYTE): BOOL;
Function GpiQueryMetaFileLength(hmf: HMF): LONG;
Function GpiSaveMetaFile(hmf: HMF; pszFilename: PSZ): BOOL;

Function GpiSetMetaFileBits(hmf: HMF; lOffset, lLength: LONG;
                            pbBuffer: PBYTE): BOOL;


 { ** default functions }
Function GpiQueryDefArcParams(hps: HPS; parcpArcParams: PARCPARAMS): BOOL;
Function GpiQueryDefAttrs(hps: HPS; lPrimType: LONG; flAttrMask: ULONG;
                          ppbunAttrs: PBUNDLE): BOOL;
Function GpiQueryDefTag(hps: HPS; plTag: PLONG): BOOL;
Function GpiQueryDefViewingLimits(hps: HPS; prclLimits: PRECTL): BOOL;

Function GpiSetDefArcParams(hps: HPS; parcpArcParams: PARCPARAMS): BOOL;
Function GpiSetDefAttrs(hps: HPS; lPrimType: LONG; flAttrMask: ULONG;
                        ppbunAttrs: PBUNDLE): BOOL;
Function GpiSetDefTag(hps: HPS; lTag: LONG): BOOL;
Function GpiSetDefViewingLimits(hps: HPS; prclLimits: PRECTL): BOOL;


{**** #include <pmerr.h>}
Implementation

Function GpiSetColor;                          External 'PMWIN' Index 108;
Function GpiQueryRGBColor;                     External 'PMWIN' Index 107;
Function GpiQueryColorIndex;                   External 'PMWIN' Index 106;
Function GpiQueryNearestColor;                 External 'PMWIN' Index 105;
Function GpiQueryRealColors;                   External 'PMWIN' Index 104;
Function GpiQueryLogColorTable;                External 'PMWIN' Index 103;
Function GpiQueryColorData;                    External 'PMWIN' Index 102;
Function GpiUnrealizeColorTable;               External 'PMWIN' Index 101;
Function GpiRealizeColorTable;                 External 'PMWIN' Index 100;
Function GpiCreateLogColorTable;               External 'PMWIN' Index 99;
Function GpiStrokePath;                        External 'PMWIN' Index 270;
Function GpiOutlinePath;                       External 'PMWIN' Index 274;
Function GpiSetClipPath;                       External 'PMWIN' Index 233;
Function GpiFillPath;                          External 'PMWIN' Index 238;
Function GpiModifyPath;                        External 'PMWIN' Index 237;
Function GpiCloseFigure;                       External 'PMWIN' Index 236  ;
Function GpiEndPath;                           External 'PMWIN' Index 235  ;
Function GpiBeginPath;                         External 'PMWIN' Index 234  ;
Function GpiQueryViewingLimits;                External 'PMWIN' Index 92   ;
Function GpiSetViewingLimits;                  External 'PMWIN' Index 91   ;
Function GpiQueryGraphicsField;                External 'PMWIN' Index 90   ;
Function GpiSetGraphicsField;                  External 'PMWIN' Index 89   ;
Function GpiRotate;                            External 'PMWIN' Index 285  ;
Function GpiScale;                             External 'PMWIN' Index 284  ;
Function GpiTranslate;                         External 'PMWIN' Index 283  ;
Function GpiSetViewingTransformMatrix;         External 'PMWIN' Index 87   ;
Function GpiQueryViewingTransformMatrix;       External 'PMWIN' Index 88   ;
Function GpiSetPageViewport;                   External 'PMWIN' Index 85   ;
Function GpiQueryPageViewport;                 External 'PMWIN' Index 86   ;
Function GpiSetDefaultViewMatrix;              External 'PMWIN' Index 83   ;
Function GpiQueryDefaultViewMatrix;            External 'PMWIN' Index 84   ;
Function GpiCallSegmentMatrix;                 External 'PMWIN' Index 82   ;
Function GpiSetModelTransformMatrix;           External 'PMWIN' Index 80   ;
Function GpiQueryModelTransformMatrix;         External 'PMWIN' Index 81   ;
Function GpiConvert;                           External 'PMWIN' Index 93   ;
Function GpiSetSegmentTransformMatrix;         External 'PMWIN' Index 78   ;
Function GpiQuerySegmentTransformMatrix;       External 'PMWIN' Index 79   ;
Function GpiSetElementPointerAtLabel;          External 'PMWIN' Index 65   ;
Function GpiQueryElementType;                  External 'PMWIN' Index 67   ;
Function GpiOffsetElementPointer;              External 'PMWIN' Index 61   ;
Function GpiSetElementPointer;                 External 'PMWIN' Index 59   ;
Function GpiQueryElementPointer;               External 'PMWIN' Index 60   ;
Function GpiSetEditMode;                       External 'PMWIN' Index 57   ;
Function GpiQueryEditMode;                     External 'PMWIN' Index 58   ;
Function GpiDeleteElementsBetweenLabels;       External 'PMWIN' Index 66   ;
Function GpiDeleteElementRange;                External 'PMWIN' Index 63   ;
Function GpiDeleteElement;                     External 'PMWIN' Index 62   ;
Function GpiQueryElement;                      External 'PMWIN' Index 60   ;
Function GpiElement;                           External 'PMWIN' Index 69   ;
Function GpiLabel;                             External 'PMWIN' Index 64   ;
Function GpiEndElement;                        External 'PMWIN' Index 71   ;
Function GpiBeginElement;                      External 'PMWIN' Index 70   ;
Function GpiRemoveDynamics;                    External 'PMWIN' Index 24   ;
Function GpiDrawDynamics;                      External 'PMWIN' Index 25   ;
Function GpiDrawSegment;                       External 'PMWIN' Index 21   ;
Function GpiDrawFrom;                          External 'PMWIN' Index 20   ;
Function GpiDrawChain;                         External 'PMWIN' Index 19   ;
Function GpiPutData;                           External 'PMWIN' Index 29   ;
Function GpiGetData;                           External 'PMWIN' Index 28   ;
Function GpiQuerySegmentNames;                 External 'PMWIN' Index 49   ;
Function GpiDeleteSegments;                    External 'PMWIN' Index 48   ;
Function GpiSetSegmentPriority;                External 'PMWIN' Index 55   ;
Function GpiQuerySegmentPriority;              External 'PMWIN' Index 56   ;
Function GpiSetSegmentAttrs;                   External 'PMWIN' Index 53   ;
Function GpiQuerySegmentAttrs;                 External 'PMWIN' Index 54   ;
Function GpiSetInitialSegmentAttrs;            External 'PMWIN' Index 51   ;
Function GpiQueryInitialSegmentAttrs;          External 'PMWIN' Index 52   ;
Function GpiDeleteSegment;                     External 'PMWIN' Index 47   ;
Function GpiCloseSegment;                      External 'PMWIN' Index 46   ;
Function GpiOpenSegment;                       External 'PMWIN' Index 44   ;
Function GpiCorrelateSegment;                  External 'PMWIN' Index 38   ;
Function GpiCorrelateFrom;                     External 'PMWIN' Index 37   ;
Function GpiResetBoundaryData;                 External 'PMWIN' Index 42   ;
Function GpiQueryBoundaryData;                 External 'PMWIN' Index 43   ;
Function GpiSetPickAperturePosition;           External 'PMWIN' Index 32   ;
Function GpiQueryPickAperturePosition;         External 'PMWIN' Index 33   ;
Function GpiSetPickApertureSize;               External 'PMWIN' Index 30   ;
Function GpiQueryPickApertureSize;             External 'PMWIN' Index 31   ;
Function GpiSetTag;                            External 'PMWIN' Index 34   ;
Function GpiQueryTag;                          External 'PMWIN' Index 35   ;
Function GpiCorrelateChain;                    External 'PMWIN' Index 36   ;
Function GpiSetStopDraw;                       External 'PMWIN' Index 22   ;
Function GpiQueryStopDraw;                     External 'PMWIN' Index 23   ;
Function GpiSetDrawingMode;                    External 'PMWIN' Index 26   ;
Function GpiQueryDrawingMode;                  External 'PMWIN' Index 27   ;
Function GpiSetDrawControl;                    External 'PMWIN' Index 17   ;
Function GpiQueryDrawControl;                  External 'PMWIN' Index 18   ;
Function GpiErrorSegmentData;                  External 'PMWIN' Index 15   ;
Function GpiQueryPS;                           External 'PMWIN' Index 9    ;
Function GpiSetPS;                             External 'PMWIN' Index 248  ;
Function GpiResetPS;                           External 'PMWIN' Index 11   ;
Function GpiQueryDevice;                       External 'PMWIN' Index 201  ;
Function GpiErase;                             External 'PMWIN' Index 16   ;
Function GpiSavePS;                            External 'PMWIN' Index 12   ;
Function GpiRestorePS;                         External 'PMWIN' Index 13   ;
Function GpiAssociate;                         External 'PMWIN' Index 14   ;
Function GpiDestroyPS;                         External 'PMWIN' Index 10   ;
Function GpiCreatePS;                          External 'PMWIN' Index 7    ;
Function GpiSetDefViewingLimits;               External 'PMWIN' Index 279  ;
Function GpiSetDefTag;                         External 'PMWIN' Index 275  ;
Function GpiSetDefAttrs;                       External 'PMWIN' Index 277  ;
Function GpiSetDefArcParams;                   External 'PMWIN' Index 281  ;
Function GpiQueryDefViewingLimits;             External 'PMWIN' Index 280  ;
Function GpiQueryDefTag;                       External 'PMWIN' Index 276  ;
Function GpiQueryDefAttrs;                     External 'PMWIN' Index 278  ;
Function GpiQueryDefArcParams;                 External 'PMWIN' Index 282  ;
Function GpiSetMetaFileBits;                   External 'PMWIN' Index 231  ;
Function GpiSaveMetaFile;                      External 'PMWIN' Index 228  ;
Function GpiQueryMetaFileLength;               External 'PMWIN' Index 232  ;
Function GpiQueryMetaFileBits;                 External 'PMWIN' Index 230  ;
Function GpiPlayMetaFile;                      External 'PMWIN' Index 227  ;
Function GpiLoadMetaFile;                      External 'PMWIN' Index 225  ;
Function GpiDeleteMetaFile;                    External 'PMWIN' Index 229  ;
Function GpiCopyMetaFile;                      External 'PMWIN' Index 226  ;
Function GpiOffsetClipRegion;                  External 'PMWIN' Index 223  ;
Function GpiIntersectClipRectangle;            External 'PMWIN' Index 221  ;
Function GpiExcludeClipRectangle;              External 'PMWIN' Index 222  ;
Function GpiQueryClipBox;                      External 'PMWIN' Index 220  ;
Function GpiQueryClipRegion;                   External 'PMWIN' Index 219  ;
Function GpiSetClipRegion;                     External 'PMWIN' Index 218  ;
Function GpiSetRegion;                         External 'PMWIN' Index 209  ;
Function GpiRectInRegion;                      External 'PMWIN' Index 215  ;
Function GpiQueryRegionRects;                  External 'PMWIN' Index 217  ;
Function GpiQueryRegionBox;                    External 'PMWIN' Index 216  ;
Function GpiPtInRegion;                        External 'PMWIN' Index 214  ;
Function GpiPaintRegion;                       External 'PMWIN' Index 224  ;
Function GpiOffsetRegion;                      External 'PMWIN' Index 213  ;
Function GpiEqualRegion;                       External 'PMWIN' Index 212  ;
Function GpiDestroyRegion;                     External 'PMWIN' Index 210  ;
Function GpiCreateRegion;                      External 'PMWIN' Index 208  ;
Function GpiCombineRegion;                     External 'PMWIN' Index 211  ;
Function GpiQueryPel;                          External 'PMWIN' Index 207  ;
Function GpiSetPel;                            External 'PMWIN' Index 206  ;
Function GpiQueryDeviceBitmapFormats;          External 'PMWIN' Index 201  ;
Function GpiQueryBitmapParameters;             External 'PMWIN' Index 202  ;
Function GpiQueryBitmapHandle;                 External 'PMWIN' Index 143  ;
Function GpiQueryBitmapDimension;              External 'PMWIN' Index 200  ;
Function GpiQueryBitmapBits;                   External 'PMWIN' Index 204  ;
Function GpiSetBitmapId;                       External 'PMWIN' Index 142  ;
Function GpiSetBitmapDimension;                External 'PMWIN' Index 199  ;
Function GpiSetBitmapBits;                     External 'PMWIN' Index 203  ;
Function GpiCreateBitmap;                      External 'PMWIN' Index 196  ;
Function GpiWCBitBlt;                          External 'PMWIN' Index 269  ;
Function GpiSetBitmap;                         External 'PMWIN' Index 142  ;
Function GpiLoadBitmap;                        External 'PMWIN' Index 156  ;
Function GpiDeleteBitmap;                      External 'PMWIN' Index 197  ;
Function GpiBitBlt;                            External 'PMWIN' Index 205  ;
Function GpiQueryFontFileDescriptions;         External 'PMWIN' Index 167  ;
Function GpiQueryCp;                           External 'PMWIN' Index 163  ;
Function GpiSetCp;                             External 'PMWIN' Index 162  ;
Function GpiQuerySetIds;                       External 'PMWIN' Index 157  ;
Function GpiQueryNumberSetIds;                 External 'PMWIN' Index 156  ;
Function GpiQueryWidthTable;                   External 'PMWIN' Index 161  ;
Function GpiQueryKerningPairs;                 External 'PMWIN' Index 160  ;
Function GpiQueryFontMetrics;                  External 'PMWIN' Index 159  ;
Function GpiQueryFonts;                        External 'PMWIN' Index 158  ;
Function GpiUnloadFonts;                       External 'PMWIN' Index 153  ;
Function GpiLoadFonts;                         External 'PMWIN' Index 152  ;
Function GpiDeleteSetId;                       External 'PMWIN' Index 155  ;
Function GpiCreateLogFont;                     External 'PMWIN' Index 154  ;
Function GpiComment;                           External 'PMWIN' Index 268  ;
Function GpiRectVisible;                       External 'PMWIN' Index 133  ;
Function GpiPtVisible;                         External 'PMWIN' Index 132  ;
Function GpiPop;                               External 'PMWIN' Index 96   ;
Function GpiImage;                             External 'PMWIN' Index 192  ;
Function GpiQueryMarkerSet;                    External 'PMWIN' Index 185  ;
Function GpiQueryMarkerBox;                    External 'PMWIN' Index 189  ;
Function GpiQueryMarker;                       External 'PMWIN' Index 185  ;
Function GpiSetMarkerSet;                      External 'PMWIN' Index 184  ;
Function GpiSetMarkerBox;                      External 'PMWIN' Index 188  ;
Function GpiSetMarker;                         External 'PMWIN' Index 184  ;
Function GpiPolyMarker;                        External 'PMWIN' Index 191  ;
Function GpiMarker;                            External 'PMWIN' Index 190  ;
Function GpiCharStringPosAt;                   External 'PMWIN' Index 183  ;
Function GpiCharStringPos;                     External 'PMWIN' Index 182  ;
Function GpiQueryCharMode;                     External 'PMWIN' Index 179  ;
Function GpiSetCharMode;                       External 'PMWIN' Index 178  ;
Function GpiQueryCharDirection;                External 'PMWIN' Index 177  ;
Function GpiSetCharDirection;                  External 'PMWIN' Index 176  ;
Function GpiQueryCharShear;                    External 'PMWIN' Index 175  ;
Function GpiSetCharShear;                      External 'PMWIN' Index 174  ;
Function GpiQueryCharAngle;                    External 'PMWIN' Index 173  ;
Function GpiSetCharAngle;                      External 'PMWIN' Index 172  ;
Function GpiQueryCharBox;                      External 'PMWIN' Index 171  ;
Function GpiSetCharBox;                        External 'PMWIN' Index 170  ;
Function GpiQueryCharSet;                      External 'PMWIN' Index 169  ;
Function GpiSetCharSet;                        External 'PMWIN' Index 168  ;
Function GpiQueryDefCharBox;                   External 'PMWIN' Index 166  ;
Function GpiQueryTextBox;                      External 'PMWIN' Index 164  ;
Function GpiQueryCharStringPosAt;              External 'PMWIN' Index 246  ;
Function GpiQueryCharStringPos;                External 'PMWIN' Index 245  ;
Function GpiQueryPatternRefPoint;              External 'PMWIN' Index 149  ;
Function GpiSetPatternRefPoint;                External 'PMWIN' Index 148  ;
Function GpiQueryPatternSet;                   External 'PMWIN' Index 145  ;
Function GpiSetPatternSet;                     External 'PMWIN' Index 144  ;
Function GpiPolyFilletSharp;                   External 'PMWIN' Index 140  ;
Function GpiPolySpline;                        External 'PMWIN' Index 141  ;
Function GpiPolyFillet;                        External 'PMWIN' Index 139  ;
Function GpiPartialArc;                        External 'PMWIN' Index 138  ;
Function GpiFullArc;                           External 'PMWIN' Index 137  ;
Function GpiPointArc;                          External 'PMWIN' Index 136  ;
Function GpiQueryArcParams;                    External 'PMWIN' Index 135  ;
Function GpiSetArcParams;                      External 'PMWIN' Index 134  ;
Function GpiQueryCurrentPosition;              External 'PMWIN' Index 127  ;
Function GpiSetCurrentPosition;                External 'PMWIN' Index 126  ;
Function GpiQueryLineJoin;                     External 'PMWIN' Index 125  ;
Function GpiSetLineJoin;                       External 'PMWIN' Index 124  ;
Function GpiQueryLineEnd;                      External 'PMWIN' Index 123  ;
Function GpiSetLineEnd;                        External 'PMWIN' Index 122  ;
Function GpiQueryLineWidthGeom;                External 'PMWIN' Index 121  ;
Function GpiSetLineWidthGeom;                  External 'PMWIN' Index 120  ;
Function GpiQueryLineWidth;                    External 'PMWIN' Index 119  ;
Function GpiSetLineWidth;                      External 'PMWIN' Index 118  ;
Function GpiQueryLineType;                     External 'PMWIN' Index 117  ;
Function GpiSetLineType;                       External 'PMWIN' Index 116  ;
Function GpiQueryBackMix;                      External 'PMWIN' Index 115  ;
Function GpiSetBackMix;                        External 'PMWIN' Index 114  ;
Function GpiQueryMix;                          External 'PMWIN' Index 113  ;
Function GpiSetMix;                            External 'PMWIN' Index 112  ;
Function GpiQueryBackColor;                    External 'PMWIN' Index 111  ;
Function GpiSetBackColor;                      External 'PMWIN' Index 110  ;
Function GpiQueryAttrs;                        External 'PMWIN' Index 98   ;
Function GpiSetAttrs;                          External 'PMWIN' Index 97   ;
Function GpiQueryAttrMode;                     External 'PMWIN' Index 95   ;
Function GpiSetAttrMode;                       External 'PMWIN' Index 94   ;
Function GpiCharStringAt;                      External 'PMWIN' Index 181  ;
Function GpiCharString;                        External 'PMWIN' Index 180  ;
Function GpiEndArea;                           External 'PMWIN' Index 151  ;
Function GpiBeginArea;                         External 'PMWIN' Index 150  ;
Function GpiQueryPattern;                      External 'PMWIN' Index 145  ;
Function GpiSetPattern;                        External 'PMWIN' Index 144  ;
Function GpiPolyLine;                          External 'PMWIN' Index 130  ;
Function GpiLine;                              External 'PMWIN' Index 129  ;
Function GpiMove;                              External 'PMWIN' Index 128  ;
Function GpiBox;                               External 'PMWIN' Index 131  ;
Function GpiQueryColor;                        External 'PMWIN' Index 102  ;

begin
end.
