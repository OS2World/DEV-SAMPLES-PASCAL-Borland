{*****************************************************************************\
*
* Module Name: PMSHL.H
*
* OS/2 Presentation Manager Shell constants, types, messages and
* function declarations
*
* Copyright (c) International Business Machines Corporation 1981, 1988-1990
*
\*****************************************************************************}
{| Version:   1.00
 | Original translation: Peter Sawatzki ps
 | Contributing:
 |   Peter Sawatzki ps
 |
 | change history:
 | Date:    Ver: Author:
 | 11/11/93 1.00 ps     original translation by ps
}
Unit PmShl;
Interface
Uses
  Os2Def,
  PmWin;
Const
{ common types, constants and function declarations             }
{ maximum title length }
  MAXNAMEL = 60;
Type
{ window size structure }
  XYWINSIZE = Record
    x,y,cx,cy: SHORT;
    fsWindow: USHORT
  End;
  pXYWINSIZE = ^XYWINSIZE;

Const
{ Definitions for fsWindow }
  XYF_NOAUTOCLOSE= $0008;
  XYF_MINIMIZED  = $0004;                           { D23914 }
  XYF_MAXIMIZED  = $0002;                           { D23914 }
  XYF_INVISIBLE  = $0001;
  XYF_NORMAL     = $0000;

Type
{ program handle }
  HPROGRAM = LHANDLE;       { hprog }
  pHPROGRAM = ^HPROGRAM;

{ ini file handle }
  HINI = LHANDLE;           { hini }
  pHINI = ^HINI;

Const
  HINI_PROFILE         = NULL;
  HINI_USERPROFILE     = -1;
  HINI_SYSTEMPROFILE   = -2;
  HINI_USER    = HINI_USERPROFILE;
  HINI_SYSTEM  = HINI_SYSTEMPROFILE;

Type
  PRFPROFILE = Record
    cchUserName: ULONG;
    pszUserName: pSZ;
    cchSysName: ULONG;
    pszSysName: pSZ
  End;
  pPRFPROFILE = ^PRFPROFILE;

Const
{ maximum path length }
  MAXPATHL = 128;

{ root group handle }
  SGH_ROOT      = HPROGRAM(-1);

Type
  HPROGARRAY = Record
    ahprog: Array[0..0] Of HPROGRAM
  End;
  pHPROGARRAY = ^HPROGARRAY;
  PROGCATEGORY = Char;
  pPROGCATEGORY = pChar;

Const
{ values acceptable for PROGCATEGORY for PM groups }
  PROG_DEFAULT            = PROGCATEGORY(0  );
  PROG_FULLSCREEN         = PROGCATEGORY(1  );
  PROG_WINDOWABLEVIO      = PROGCATEGORY(2  );
  PROG_PM                 = PROGCATEGORY(3  );
  PROG_GROUP              = PROGCATEGORY(5  );
  PROG_REAL               = PROGCATEGORY(4  );{ was 7 }
  PROG_DLL                = PROGCATEGORY(6  );
  PROG_RESERVED           = PROGCATEGORY(255);

{ visibility flag for PROGTYPE structure }
  SHE_VISIBLE   = $00;
  SHE_INVISIBLE = $01;
  SHE_RESERVED  = $FF;

{ Protected group flag for PROGTYPE structure }
  SHE_UNPROTECTED = $00;
  SHE_PROTECTED   = $02;

Type
  PROGTYPE = Record
    progc: PROGCATEGORY;
    fbVisible: UCHAR
  End;
  pPROGTYPE = ^PROGTYPE;

  PROGRAMENTRY = Record
    hprog: HPROGRAM;
    progt: PROGTYPE;
    szTitle: Array[0..MAXNAMEL] Of Char
  End;
  pPROGRAMENTRY = ^PROGRAMENTRY;

  PIBSTRUCT = Record
    progt: PROGTYPE;
    szTitle: Array[0..MAXNAMEL] Of Char;
    szIconFileName,
    szExecutable,
    szStartupDir: Array[0..MAXPATHL] Of Char;
    xywinInitial: XYWINSIZE;
    res1: USHORT;
    res2: LHANDLE;
    cchEnvironmentVars: USHORT;
    pchEnvironmentVars: pCH;
    cchProgramParameter: USHORT;
    pchProgramParameter: pCH
  End;
  pPIBSTRUCT = ^PIBSTRUCT;

{****************************************************************************}
{                                                                            }
{  Structures associated with 'Prf' calls                                    }
{                                                                            }
{****************************************************************************}

  PROGDETAILS = Record
    _Length: ULONG;        { set this to sizeof(PROGDETAILS)  }
    progt: PROGTYPE;
    pad1: Array[0..2] Of USHORT;     { ready for 32-bit PROGTYPE        }
    pszTitle,              { any of the pointers can be NULL  }
    pszExecutable,
    pszParameters,
    pszStartupDir,
    pszIcon,
    pszEnvironment:pSZ;        { this is terminated by  /0/0     }
    swpInitial: SWP;            { this replaces XYWINSIZE         }
    pad2: Array[0..4] Of USHORT;{ ready for 32-bit SWP            }
  End;
  pPROGDETAILS = ^PROGDETAILS;

  PROGTITLE = Record
    hprog: HPROGRAM;
    progt: PROGTYPE;
    pad1: Array[0..2] Of USHORT; { padding ready for 32-bit PROGTYPE }
    pszTitle: pSZ
  End;
  pPROGTITLE = ^PROGTITLE;

  QFEOUTBLK = Record
    Total,
    Count: USHORT;
    ProgramArr: Array[0..0] Of HPROGRAM
  End;
  pQFEOUTBLK = ^QFEOUTBLK;

{ Program List API Function Definitions }
{**  Program Use }
Function WinQueryProgramTitles(_hab: HAB; hprogGroup: HPROGRAM;
                               aprogeBuffer: PPROGRAMENTRY; usBufferLen: USHORT; pusTotal: PUSHORT): BOOL;

{**  Single Program Manipulation }
Function WinAddProgram(_hab: HAB; ppibProgramInfo: PPIBSTRUCT;
                       hprogGroupHandle: HPROGRAM): HPROGRAM;
Function WinQueryDefinition(_hab: HAB; hprogProgHandle: HPROGRAM;
                            ppibProgramInfo: PPIBSTRUCT; usMaxLength: USHORT): USHORT;

{**  Group Manipulation }
Function WinCreateGroup(_hab: HAB; pszTitle: PSZ; ucVisibility: UCHAR;
                        flres1, flres2: ULONG): HPROGRAM;
{****************************************************************************}
{                                                                            }
{  Program List API available 'Prf' calls                                    }
{                                                                            }
{****************************************************************************}

Function PrfQueryProgramTitles(_hini: HINI; hprogGroup: HPROGRAM;
                               pTitles: PPROGTITLE; cchBufferMax: ULONG; pulCount: PULONG): ULONG;

{***************************************************************************}
{                                                                           }
{  NOTE: string information is concatanated after the array of PROGTITLE    }
{        structures so you need to allocate storage greater than            }
{        sizeof(PROGTITLE)*cPrograms to query programs in a group           }
{                                                                           }
{  PrfQueryProgramTitles recommended usage to obtain titles of all progams  }
{  in a group (Hgroup=SGH_ROOT is for all groups):                          }
{                                                                           }
{  BufLen = PrfQueryProgramTitles( Hini, Hgroup                             }
{                                          , (PPROGTITLE)NULL, 0, &Count);  }
{                                                                           }
{  Alocate buffer of  Buflen                                                }
{                                                                           }
{  Len = PrfQueryProgramTitles( Hini, Hgroup, (PPROGTITLE)pBuffer, BufLen   }
{                                                                , pCount); }
{                                                                           }
{***************************************************************************}

Function PrfAddProgram (_hini: HINI; pDetails: PPROGDETAILS;
                        hprogGroup: HPROGRAM): HPROGRAM;
Function PrfChangeProgram (_hini: HINI; hprog: HPROGRAM; pDetails: PPROGDETAILS): BOOL;

{*************************************************************************}
{  when adding/changing programs the PROGDETAILS Length field should be   }
{  set to sizeof(PROGDETAILS)                                             }
{*************************************************************************}

Function PrfQueryDefinition (_hini: HINI; hprog: HPROGRAM;
                             pDetails: PPROGDETAILS; cchBufferMax: ULONG): ULONG;

{***************************************************************************}
{                                                                           }
{  NOTE: string information is concatanated after the PROGDETAILS field     }
{        structure so you need to allocate storage greater than             }
{        sizeof(PROGDETAILS) to query programs                              }
{                                                                           }
{  PrfQueryDefinition recomended usage:                                     }
{                                                                           }
{  bufferlen = PrfQueryDefinition( Hini, Hprog, (PPROGDETAILS)NULL, 0)      }
{                                                                           }
{  Alocate buffer of bufferlen bytes                                        }
{  set Length field (0 will be supported)                                   }
{                                                                           }
{  (PPROGDETAILS)pBuffer->Length=sizeof(PPROGDETAILS)                       }
{                                                                           }
{  len = PrfQueryDefinition(Hini, Hprog, (PPROGDETAILS)pBuffer, bufferlen)  }
{                                                                           }
{***************************************************************************}

Function PrfRemoveProgram(_hini: HINI; hprog: HPROGRAM): BOOL;
Function PrfQueryProgramHandle (_hini: HINI; pszExe: PSZ;
                                _phprogArray: PHPROGARRAY; cchBufferMax: ULONG; pulCount: PULONG): ULONG;
Function PrfCreateGroup(_hini: HINI; pszTitle: PSZ;
                        chVisibility: UCHAR): HPROGRAM;
Function PrfDestroyGroup(_hini: HINI; hprogGroup: HPROGRAM): BOOL;
Function PrfQueryProgramCategory(_hini: HINI; pszExe: PSZ): PROGCATEGORY;

Type
  HSWITCH = LHANDLE;        { hsw }
  pHSWITCH = ^HSWITCH;
Const
{ visibility flag for SWCNTRL structure }
  SWL_VISIBLE   = $04;
  SWL_INVISIBLE = $01;
  SWL_GRAYED    = $02;

{ visibility flag for SWCNTRL structure }
  SWL_JUMPABLE    = $02;
  SWL_NOTJUMPABLE = $01;
Type
  SWCNTRL = Record
    hwnd,
    hwndIcon: HWND;
    hprog: HPROGRAM;
    idProcess,
    idSession: USHORT;
    uchVisibility,
    fbJump: UCHAR;
    szSwtitle: Array[0..MAXNAMEL] Of Char;
    fReserved: BYTE        { To align on word boundary }
  End;
  pSWCNTRL = ^SWCNTRL;

{** Switching Program functions }
{E}Function WinAddSwitchEntry(_PSWCNTRL: PSWCNTRL): HSWITCH;
{E}Function WinRemoveSwitchEntry(_HSWITCH: HSWITCH): USHORT;

Type
  SWENTRY = Record
    _hswitch: HSWITCH;
    swctl: SWCNTRL
  End;
  pSWENTRY = ^SWENTRY;

  SWBLOCK = Record
    cswentry: USHORT;
    aswentry: Array[0..0] Of SWENTRY
  End;
  pSWBLOCK = ^SWBLOCK;

Function WinChangeSwitchEntry(hswitchSwitch: HSWITCH;
                                 pswctlSwitchData: PSWCNTRL): USHORT;
Function WinCreateSwitchEntry(_HAB: HAB; _PSWCNTRL: PSWCNTRL): HSWITCH;
Function WinQuerySessionTitle(_hab: HAB; usSession: USHORT;
                                 pszTitle: PSZ; usTitlelen: USHORT): USHORT;
Function WinQuerySwitchEntry(hswitchSwitch: HSWITCH; pswctlSwitchData: PSWCNTRL): USHORT;
Function WinQuerySwitchHandle(_hwnd: HWND; usProcess: PID): HSWITCH;
Function WinQuerySwitchList(_hab: HAB; pswblkSwitchEntries: PSWBLOCK;
                               usDataLength: USHORT): USHORT;
Function WinQueryTaskSizePos(_hab: HAB; usScreenGroup: USHORT;
                                pswpPositionData: PSWP): USHORT;
Function WinQueryTaskTitle(usSession: USHORT; pszTitle: PSZ;
                              usTitlelen: USHORT): USHORT;
Function WinSwitchToProgram(hswitchSwHandle: HSWITCH): USHORT;

{ if error definitions are required then allow Shell errors }

{** OS2.INI Access functions }
Function WinQueryProfileInt(hab: HAB; pszAppName: PSZ; pszKeyName: PSZ;
                            sDefault: SHORT): SHORT;
Function WinQueryProfileString(hab: HAB; pszAppName, pszKeyName: PSZ;
                               pszDefault: PSZ; pProfileString: PVOID; usMaxPstring: USHORT): USHORT;
Function WinWriteProfileString(hab: HAB; pszAppName, pszKeyName: PSZ;
                               pszValue: PSZ): BOOL;
Function WinQueryProfileSize(hab: HAB; pszAppName, pszKeyName: PSZ;
                             pusValue: PUSHORT): USHORT;
Function WinQueryProfileData(hab: HAB; pszAppName, pszKeyName: PSZ;
                             pValue: PVOID; pusSize: PUSHORT): BOOL;
Function WinWriteProfileData(hab: HAB; pszAppName, pszKeyName: PSZ;
                             pValue: PVOID; usSize: USHORT): BOOL;

{****************************************************************************}
{                                                                            }
{  INI file access API available calls 'Prf'                                 }
{                                                                            }
{****************************************************************************}

Function PrfQueryProfileInt(hini: HINI; pszApp, pszKey: PSZ;
                            sDefault: SHORT): SHORT;
Function PrfQueryProfileString(hini: HINI; pszApp, pszKey: PSZ;
                               pszDefault: PSZ; pBuffer: PVOID; cchBufferMax: ULONG): ULONG;
Function PrfWriteProfileString(hini: HINI; pszApp, pszKey, pszData: PSZ): BOOL;
Function PrfQueryProfileSize(hini: HINI; pszApp, pszKey: PSZ; pulReqLen: PULONG): BOOL;
Function PrfQueryProfileData(hini: HINI; pszApp, pszKey: PSZ;
                             pBuffer: PVOID; pulBuffLen: PULONG): BOOL;
Function PrfWriteProfileData(hini: HINI; pszApp, pszKey: PSZ;
                             pData: PVOID; cchDataLen: ULONG): BOOL;
Function PrfOpenProfile(hab: HAB; pszFileName: PSZ): HINI;
Function PrfCloseProfile(hini: HINI): BOOL;
Function PrfReset(hab: HAB; pPrfProfile: PPRFPROFILE): BOOL;
Function PrfQueryProfile(hab: HAB; pPrfProfile: PPRFPROFILE): BOOL;

Const
{ new public message, broadcast on WinReset }
  PL_ALTERED = $008E;  { WM_SHELLFIRST + 0E }

Type
  HAPP = LHANDLE;
  ppSZ = ^pSZ;

  Function WinInstStartApp (hini: HINI;hwndNotifyWindow: HWND;cCount: USHORT;Var aszApplication: PSZ;
                            pszCmdLine: PSZ;pData: PVOID;fsOptions: USHORT): HAPP;

  Function WinTerminateApp (happ: HAPP): BOOL;

Const
{ bit values for Options parameter of WinInstStartAppl }
  SAF_VALIDFLAGS = $001F;
  SAF_INSTALLEDCMDLINE= $0001; { use installed parameters }
  SAF_STARTCHILDAPP= $0002; { related application      }
  SAF_MAXIMIZED = $0004;  { Start App maximized }
  SAF_MINIMIZED = $0008;  { Start App minimized, if !SAF_MAXIMIZED }
  SAF_BACKGROUND= $0010;  { Start app in the background }

Implementation
  Function PrfAddProgram;                 External 'PMSHAPI'  Index   50;
  Function PrfChangeProgram;              External 'PMSHAPI'  Index   52;
  Function PrfCloseProfile;               External 'PMSHAPI'  Index   39;
  Function PrfCreateGroup;                External 'PMSHAPI'  Index   55;
  Function PrfDestroyGroup;               External 'PMSHAPI'  Index   60;
  Function PrfOpenProfile;                External 'PMSHAPI'  Index   38;
  Function PrfQueryDefinition;            External 'PMSHAPI'  Index   53;
  Function PrfQueryProfile;               External 'PMSHAPI'  Index   43;
  Function PrfQueryProfileData;           External 'PMSHAPI'  Index   36;
  Function PrfQueryProfileInt;            External 'PMSHAPI'  Index   32;
  Function PrfQueryProfileSize;           External 'PMSHAPI'  Index   35;
  Function PrfQueryProfileString;         External 'PMSHAPI'  Index   33;
  Function PrfQueryProgramCategory;       External 'PMSHAPI'  Index   59;
  Function PrfQueryProgramHandle;         External 'PMSHAPI'  Index   58;
  Function PrfQueryProgramTitles;         External 'PMSHAPI'  Index   54;
  Function PrfRemoveProgram;              External 'PMSHAPI'  Index   51;
  Function PrfReset;                      External 'PMSHAPI'  Index   42;
  Function PrfWriteProfileData;           External 'PMSHAPI'  Index   37;
  Function PrfWriteProfileString;         External 'PMSHAPI'  Index   34;
  Function WinAddProgram;                 External 'PMSHAPI'  Index   12;
  Function WinAddSwitchEntry;             External 'OS2SM'    Index    9;
  Function WinChangeSwitchEntry;          External 'OS2SM'    Index   10;
  Function WinCreateGroup;                External 'PMSHAPI'  Index   17;
  Function WinCreateSwitchEntry;          External 'OS2SM'    Index    7;
  Function WinInstStartApp;               External 'OS2SM'    Index    5;
  Function WinQueryDefinition;            External 'PMSHAPI'  Index   15;
  Function WinQueryProfileData;           External 'PMSHAPI'  Index    6;
  Function WinQueryProfileInt;            External 'PMSHAPI'  Index    2;
  Function WinQueryProfileSize;           External 'PMSHAPI'  Index    5;
  Function WinQueryProfileString;         External 'PMSHAPI'  Index    3;
  Function WinQueryProgramTitles;         External 'PMSHAPI'  Index   16;
  Function WinQuerySessionTitle;          External 'OS2SM'    Index    8;
  Function WinQuerySwitchEntry;           External 'OS2SM'    Index   11;
  Function WinQuerySwitchHandle;          External 'OS2SM'    Index   12;
  Function WinQuerySwitchList;            External 'OS2SM'    Index   15;
  Function WinQueryTaskSizePos;           External 'OS2SM'    Index   14;
  Function WinQueryTaskTitle;             External 'OS2SM'    Index   13;
  Function WinRemoveSwitchEntry;          External 'OS2SM'    Index   16;
  Function WinSwitchToProgram;            External 'OS2SM'    Index   17;
  Function WinTerminateApp;               External 'OS2SM'    Index    6;
  Function WinWriteProfileData;           External 'PMSHAPI'  Index    7;
  Function WinWriteProfileString;         External 'PMSHAPI'  Index    4;
End.
