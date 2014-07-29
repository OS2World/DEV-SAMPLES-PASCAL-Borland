{***************************************************************************\
*
* Module Name: OS2DEF.H
*
* OS/2 Common Definitions file
*
* Copyright (c) International Business Machines Corporation 1981, 1988, 1989
* Copyright (c) Microsoft Corporation 1981, 1988, 1989
*
\**************************************************************************}

{| Version:   1.02
 | Original translation: Peter Singer (PSi)
 | Contributing:
 |   Peter Singer (PSi)
 |   Peter Sawatzki (ps)
 |
 | change history:
 | Date:    Ver: Author:
 | 11/08/93 1.00 PSi    original translation by PSi
 | 11/10/93 1.01 ps     added Inline macros
 | 11/11/93 1.02 ps     correct some bugs
}
{$Define USE13}
{ Comments:
  search for '***MC' for unresolved macros
  search for '***TC' for unresolved types and constants
  search for '-UNSURE-' for possibly incorrect translations
  search for '-CANT-' for types that can't be translated correctly
}
Unit Os2Def;
Interface
type
     SHANDLE    = word;
     LHANDLE    = pointer;
     Long       = LongInt;                {-ps-}

{***TC #define EXPENTRY pascal far _loadds
***TC #define APIENTRY pascal far}

     UCHAR      = Byte;
     USHORT     = Word;
     SHORT      = Integer;
     UINT       = Word;
     ULONG      = Longint;
     BOOL       = {$IfDef Use13} WordBool {$Else} LongInt {$EndIf}; {-ps-}

{ define NULL pointer value }
{ Echo the format of the ifdefs that stdio.h uses }

CONST NULL      = 0;


type PSZ        = pChar;                       {-ps-}
     NPSZ       = PSZ;      {-CANT-}           {-ps-}
     PCH        = Pointer;
     NPCH       = Pointer;  {-CANT-}

{typedef int   (pascal far  *PFN)();
 typedef int   (pascal near *NPFN)();}
  pFn = Function: Integer;                     {-ps-}
  npFn = Function: Integer;  {-CANT-}          {-ps-}

     PBYTE      = ^Byte;                       {-ps-}
     NPBYTE     = ^Byte;     {-CANT-}          {-ps-}
{    PCHAR      = Pointer;}                    {-ps-}
     PSHORT     = ^Integer;                    {-ps-}
     PLONG      = ^Longint;                    {-ps-}
     PINT       = ^Integer;                    {-ps-}
     PUCHAR     = PChar;                       {-ps-}
     PUSHORT    = PSHORT;                      {-ps-}
     PULONG     = PLONG;                       {-ps-}
     PUINT      = ^Word;
     PVOID      = Pointer;
     PBOOL      = ^Boolean;                    {-ps-}

CONST
     FALSE      = BOOL(0);
     TRUE       = BOOL(1);

Type
    SEL         = Word;
    PSEl        = Pointer;

Const
  PopAx = $58;
  PopDx = $5A;
  PopBx = $5B;
{** Useful Helper Macros }

{ Create untyped far pointer from selector and offset }
{#define MAKEP(sel, off)     ((PVOID)MAKEULONG(off, sel))}
Function MakeP(Sel,Off: Word): Pointer;        {-ps-}
  Inline(PopAx/PopDx);                         {-ps-}

{ Extract selector or offset from far pointer }
{#define SELECTOROF(p)       (((PUSHORT)&(p))[1])}
{#define OFFSETOF(p)         (((PUSHORT)&(p))[0])}
Function SelectorOf(p: Pointer): Word;         {-ps-}
  Inline(PopDx/PopAx);                         {-ps-}

Function OffsetOf(p: Pointer): Word;           {-ps-}
  Inline(PopAx/PopDx);                         {-ps-}

{ Cast any variable to an instance of the specified type. }
{***MC #define MAKETYPE(v, type)   (*((type far *)&v))}

{ Calculate the byte offset of a field in a structure of type type. }
{#define FIELDOFFSET(type, field)    ((SHORT)&(((type *)0)->field))}
{instead of the type of the structure, we pass the structure itself -PS}
Function FieldOffset (Var Structure; Var Field): Word;            {-ps-}
  Inline(PopBx/PopDx/PopAx/PopDx/ $29/$D8 {Sub Ax,Bx});           {-ps-}

{ Combine l & h to form a 32 bit quantity. }
{#define MAKEULONG(l, h)  ((ULONG)(((USHORT)(l)) | ((ULONG)((USHORT)(h))) << 16))}
{#define MAKELONG(l, h)   ((LONG)MAKEULONG(l, h))}
Function MakeLong(L, H: Word): Long;           {-ps-}
  Inline(PopDx/PopAx);                         {-ps-}

Function MakeULong(L, H: Word): ULong;         {-ps-}
  Inline(PopDx/PopAx);                         {-ps-}

{ Combine l & h to form a 16 bit quantity. }
{#define MAKEUSHORT(l, h) (((USHORT)(l)) | ((USHORT)(h)) << 8)}
{#define MAKESHORT(l, h)  ((SHORT)MAKEUSHORT(l, h))}
Function MakeShort (l,h: Byte): Short;                        {-ps-}
  Inline(PopBx/PopAx/ $88/$DC {Mov Ah,Bl});                   {-ps-}

Function MakeUShort (l,h: Byte): UShort;                      {-ps-}
  Inline(PopBx/PopAx/ $88/$DC {Mov Ah,Bl});                   {-ps-}

{ Extract high and low order parts of 16 and 32 bit quantity }
{#define LOBYTE(w)       LOUCHAR(w)                           }
{#define HIBYTE(w)       HIUCHAR(w)                           }
{#define LOUCHAR(w)      ((UCHAR)(w))                         }
{#define HIUCHAR(w)      ((UCHAR)(((USHORT)(w) >> 8) & 0xff)) }
{#define LOUSHORT(l)     ((USHORT)(l))                        }
{#define HIUSHORT(l)     ((USHORT)(((ULONG)(l) >> 16) & 0xffff))}
Function LoByte(w: Word): Byte;                                    {-ps-}
  Inline(PopAx / $32/$E4 {Xor Ah,Ah});                             {-ps-}
Function LoUByte(w: Word): UChar;                                  {-ps-}
  Inline(PopAx / $32/$E4 {Xor Ah,Ah});                             {-ps-}

Function HiByte(w: Word): Byte;                                    {-ps-}
  Inline(PopAx / $8A/$C4 {Mov Al,Ah} / $32/$E4 {Xor Ah,Ah});       {-ps-}
Function HiUChar(w: Word): UChar;                                  {-ps-}
  Inline(PopAx / $8A/$C4 {Mov Al,Ah} / $32/$E4 {Xor Ah,Ah});       {-ps-}

Function LoUShort(l: Long): UShort;                                {-ps-}
  Inline(PopAx/PopDx);                                             {-ps-}
Function HiUShort(l: Long): UShort;                                {-ps-}
  Inline(PopDx/PopAx);                                             {-ps-}

{** Common Error definitions ***}

type
     ERRORID    = Longint;   { ULONG ERRORID}
     PERRORID   = Pointer;

{ Combine severity and error code to produce ERRORID }
{#define MAKEERRORID(sev, error) (ERRORID)(MAKEULONG((error), (sev)))}
Function MakeErrorId(sev, error: UShort): ERRORID;          {-ps-}
  Inline(PopDx/PopAx);                                      {-ps-}
{ Extract error number from an errorid }
{#define ERRORIDERROR(errid)            (LOUSHORT(errid))}
Function ErrorIdError(errid: ERRORID): UShort;              {-ps-}
  Inline(PopAx/PopDx);                                      {-ps-}
{ Extract severity from an errorid }
{#define ERRORIDSEV(errid)              (HIUSHORT(errid))}
Function ErrorIdSev(errid: ERRORID): UShort;                {-ps-}
  Inline(PopDx/PopAx);                                      {-ps-}

{ Severity codes }
CONST
      SEVERITY_NOERROR         = $0000;
      SEVERITY_WARNING         = $0004;
      SEVERITY_ERROR           = $0008;
      SEVERITY_SEVERE          = $000C;
      SEVERITY_UNRECOVERABLE   = $0010;

{ Base component error values }

      WINERR_BASE              = $1000;  { Window Manager                  }
      GPIERR_BASE              = $2000;  { Graphics Presentation Interface }
      DEVERR_BASE              = $3000;  { Device Manager                  }
      SPLERR_BASE              = $4000;  { Spooler                         }

{** Common types used across components }

{** Common DOS types }

Type
    HMODULE             = {$IfDef Use13} Word {$Else} LongInt {$EndIf};
    PHMODULE            = ^HMODULE;
    PID                 = {$IfDef Use13} Word {$Else} LongInt {$EndIf};
    PPID                = ^PID;
    TID                 = {$IfDef Use13} Word {$Else} LongInt {$EndIf};
    PTID                = ^TID;
    HSEM                = Pointer;                     { hsem }
    PHSEM               = ^HSEM;

{** Common SUP types }

    HAB                 = LHANDLE;      { hab  }
    PHAB                = ^HAB;

{** Common GPI/DEV types }

    HPS                 = LHANDLE;      { hps  }
    PHPS                = ^HPS;

    HDC                 = LHANDLE;      { hdc  }
    PHDC                = ^HDC;

    HRGN                = LHANDLE;      { hrgn  }
    PHRGN               = ^HRGN;

    HBITMAP             = LHANDLE;      { hbm  }
    PHBITMAP            = ^HBITMAP;

    HMF                 = LHANDLE;      { hmf  }
    PHMF                = ^HMF;


    COLOR               = LONG;     { clr  }
    PCOLOR              = ^COLOR;

    POINTL   = record               { ptl  }
       x,
       y  : LONG;
    end;
    PPOINTL             = ^POINTL;
    NPPOINTL            = ^POINTL;  {-CANT-}

    POINTS   = record               { pts  }
       x,
       y  : Integer;
    end;
    PPOINTS             = ^POINTS;

    RECTL    = record              { rcl }
       xLeft,
       yBottom,
       xRight,
       yTop  : LONG;
    end;
    PRECTL              = ^RECTL;
    NPRECTL             = ^RECTL;   {-CANT-}

    STR8                = Array[0..7] Of Char;         {-ps-}
    PSTR8               = ^STR8;

{** common DEV/SPL types }

{ structure for Device Driver data }

    DRIVDATA   = record           { driv }
       cb,
       lVersion       : LONG;
       szDeviceName   : Array[0..31] Of Char;           {-ps-}
       abGeneralData  : Array[0..0] Of Char;            {-ps-}
    end;
    PDRIVDATA           = ^DRIVDATA;

{ array indices for array parameter for DevOpenDC, SplQmOpen or SplQpOpen }

CONST
      ADDRESS        = 0;
      DRIVER_NAME    = 1;
      DRIVER_DATA    = 2;
      DATA_TYPE      = 3;
      COMMENT        = 4;
      PROC_NAME      = 5;
      PROC_PARAMS    = 6;
      SPL_PARAMS     = 7;
      NETWORK_PARAMS = 8;

{ structure definition as an alternative of the array parameter }
TYPE
    DEVOPENSTRUC = record            { dop }
      pszLogAddress,
      pszDriverName   : PSZ;
      pdriv           : PDRIVDATA;
      pszDataType,
      pszComment,
      pszQueueProcName,
      pszQueueProcParams,
      pszSpoolerParams,
      pszNetworkParams  : PSZ;
    end;
    PDEVOPENSTRUC      = ^DEVOPENSTRUC;

{** common AVIO/GPI types }

{ values of fsSelection field of FATTRS structure }
CONST
      FATTR_SEL_ITALIC         = $0001;
      FATTR_SEL_UNDERSCORE     = $0002;
      FATTR_SEL_OUTLINE        = $0008;          { Hollow Outline Font }
      FATTR_SEL_STRIKEOUT      = $0010;
      FATTR_SEL_BOLD           = $0020;

{ values of fsType field of FATTRS structure }
      FATTR_TYPE_KERNING       = $0004;
      FATTR_TYPE_MBCS          = $0008;
      FATTR_TYPE_DBCS          = $0010;
      FATTR_TYPE_ANTIALIASED   = $0020;

{ values of fsFontUse field of FATTRS structure }
      FATTR_FONTUSE_NOMIX       = $0002;
      FATTR_FONTUSE_OUTLINE     = $0004;
      FATTR_FONTUSE_TRANSFORMABLE = $0008;


{ size for fields in the font structures }

      FACESIZE = 32;

{ font struct for Vio/GpiCreateLogFont }
TYPE
    FATTRS   = record            { fat }
      usRecordLength,
      fsSelection    : USHORT;
      lMatch         : LONG;
      szFacename     : Array[0..FACESIZE-1] Of Char;      {-ps-}
      idRegistry,
      usCodePage     : USHORT;
      lMaxBaselineExt,
      lAveCharWidth  : LONG;
      fsType,
      fsFontUse      : USHORT
    end;
    PFATTRS    = ^FATTRS;

{ values of fsType field of FONTMETRICS structure }
CONST
      FM_TYPE_FIXED            = $0001;
      FM_TYPE_LICENSED         = $0002;
      FM_TYPE_KERNING          = $0004;
      FM_TYPE_DBCS             = $0010;
      FM_TYPE_MBCS             = $0018;
      FM_TYPE_64K              = $8000;

{ values of fsDefn field of FONTMETRICS structure }
      FM_DEFN_OUTLINE          = $0001;
      FM_DEFN_GENERIC          = $8000;

{ values of fsSelection field of FONTMETRICS structure }
      FM_SEL_ITALIC            = $0001;
      FM_SEL_UNDERSCORE        = $0002;
      FM_SEL_NEGATIVE          = $0004;
      FM_SEL_OUTLINE           = $0008;          { Hollow Outline Font }
      FM_SEL_STRIKEOUT         = $0010;
      FM_SEL_BOLD              = $0020;

{ values of fsCapabilities field of FONTMETRICS structure }

      FM_CAP_NOMIX             = $0001;

{ font metrics returned by GpiQueryFonts and others }
Type
{$IfNDef Use13}
  _PANOSE = Record                                   {-ps-/2.1}
    bFamilyType,                                     {-ps-/2.1}
    bSerifStyle,                                     {-ps-/2.1}
    bWeight,                                         {-ps-/2.1}
    bProportion,                                     {-ps-/2.1}
    bContrast,                                       {-ps-/2.1}
    bStrokeVariation,                                {-ps-/2.1}
    bArmStyle,                                       {-ps-/2.1}
    bLetterform,                                     {-ps-/2.1}
    bMidline,                                        {-ps-/2.1}
    bXHeight,                                        {-ps-/2.1}
    fbPassedISO,                                     {-ps-/2.1}
    fbFailedISO: Byte                                {-ps-/2.1}
  End;                                               {-ps-/2.1}
{$EndIf}

     FONTMETRICS   =   Record       { fm }
       szFamilyname,
       szFacename       : Array[0..FACESIZE-1] Of Char;
       idRegistry,
       usCodePage        : USHORT;
       lEmHeight,
       lXHeight,
       lMaxAscender,
       lMaxDescender,
       lLowerCaseAscent,
       lLowerCaseDescent,
       lInternalLeading,
       lExternalLeading,
       lAveCharWidth,
       lMaxCharInc,
       lEmInc,
       lMaxBaselineExt   : LONG;
       sCharSlope,
       sInlineDir,
       sCharRot          : SHORT;
       usWeightClass,
       usWidthClass      : USHORT;
       sXDeviceRes,
       sYDeviceRes,
       sFirstChar,
       sLastChar,
       sDefaultChar,
       sBreakChar,
       sNominalPointSize,
       sMinimumPointSize,
       sMaximumPointSize        : SHORT;
       fsType,
       fsDefn,
       fsSelection,
       fsCapabilities           : USHORT;
       lSubscriptXSize,
       lSubscriptYSize,
       lSubscriptXOffset,
       lSubscriptYOffset,
       lSuperscriptXSize,
       lSuperscriptYSize,
       lSuperscriptXOffset,
       lSuperscriptYOffset,
       lUnderscoreSize,
       lUnderscorePosition,
       lStrikeoutSize,
       lStrikeoutPosition       : LONG;
       sKerningPairs,
       sFamilyClass             : SHORT;
       lMatch                   : LONG;
{$IfNDef Use13}
       FamilyNameAtom,                        {-ps-/2.1}
       FaceNameAtom: LONG;                    {-ps-/2.1}
       panose: _PANOSE                        {-ps-/2.1}
{$EndIf}
     end;
     PFONTMETRICS  = ^FONTMETRICS;

{** Common WIN types }

    HWND       = LHANDLE;       { hwnd }
    PHWND      = ^HWND;

    WRECT  = Record             { wrc }
      xLeft,
      dummy1,
      yBottom,
      dummy2,
      xRight,
      dummy3,
      yTop,
      dummy4  : SHORT;
    end;
    PWRECT      = ^WRECT;
    NPWRECT     = ^WRECT;           {-CANT-}

    WPOINT   = record    { wpt }
      x,
      dummy1,
      y,
      dummy2  : SHORT;
    end;
    PWPOINT     = ^WPOINT;
    NPWPOINT    = ^WPOINT;          {-CANT-}

  Procedure UnKnown (aFunc, aMod: pChar); {called for unkown functions}
Implementation
  Procedure UnKnown (aFunc, aMod: pChar);
  Begin
    WriteLn('### unknown function in Module ',aMod,': ',aFunc);
    Halt(255)
  End;
End.
