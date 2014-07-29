{**************************************************************************\
*
* Module Name: PMWIN.PAS
*
* OS/2 Presentation Manager Window Manager include file
*
* Copyright (c) International Business Machines Corporation 1981, 1988-1990
*
\**************************************************************************}
{| Version:   1.00
 | Original translation: Peter Sawatzki (ps)
 | Contributing:
 |   Peter Singer (PSi)
 |   Peter Sawatzki (ps)
 |
 | change history:
 | Date:    Ver: Author:
 | 11/11/93 1.00 ps     original translation by ps
}

{*************************************************************************}
{**        General Window Management types, constants and macros        **}
Unit PmWin;
Interface
Uses
  Os2Def;
Type
  MPARAM  = Pointer;  {mp}
  pMPARAM = ^MPARAM;  {pmp}
  MRESULT = Pointer;  {mres}
  pMRESULT = ^MRESULT; {pmres}

{ Macros to make an MPARAM from standard types. }
  MPFROMP = MPARAM;
  MPFROMHWND = MPARAM;
  MPFROMCHAR = MPARAM;
  MPFROMSHORT = MPARAM;
  MPFROMLONG  = MPARAM;
  Function MPFROM2SHORT(s1, s2: SHORT): MPARAM;
    Inline(PopDx/PopAx);
  Function MPFROMSH2CH (s: SHORT; uch1, uch2: UCHAR): MPARAM;
    Inline(PopDx/PopBx/ $88/$DA {Mov Dl,Bl} / PopAx);

{ Macros to extract standard types from an MPARAM }
Type
  PVOIDFROMMP = Pointer;
  HWNDFROMMP  = HWND;
  LONGFROMMP  = LONG;
  CHAR1FROMMP = Char;

  Function Char2FromMP(mp: MPARAM): UCHAR;
    InLine(PopDx/ PopBx / $31/$C0 {Xor Ax,Ax} / $88/$F8 {Mov Al,Bh});
  Function Char3FromMP(mp: MPARAM): UCHAR;
    Inline(PopAx/ PopBx/ $30/$E4 {Xor Ah,Ah});
  Function Char4FromMP(mp: MPARAM): UCHAR;
    Inline(PopAx/PopBx/ $31/$C0 {XChg Al,Ah} / $40/$E4 {Xor Ah,Ah});
  Function Short1FromMP(mp: MPARAM): Short;
    Inline(PopAx/PopDx);
  Function Short2FromMP(mp: MPARAM): Short;
    Inline(PopDx/PopAx);

{ Macros to make an MRESULT from standard types. }
Type
  MRFROMP = MRESULT;
  MRFROMSHORT = MRESULT;
  MRFROMLONG = MRESULT;
  Function MRFROM2SHORT(s1, s2: SHORT): MRESULT;
    Inline(PopDx/PopAx);

{ Macros to extract standard types from an MRESULT }
Type
  PVOIDFROMMR = Pointer;
  LONGFROMMR = ULONG;
  Function Short1FromMR(mr: MRESULT): Short;
    Inline(PopAx/PopDx);
  Function Short2FromMR(mr: MRESULT): Short;
    Inline(PopDx/PopAx);

Type
  FnWP = Function (aWND: HWND; aUSHORT: USHORT; m1, m2: MPARAM): MRESULT;
  pFnWP = ^FnWp;

Const

  HWND_DESKTOP             =  HWND(1);
  HWND_OBJECT              =  HWND(2);
  HWND_TOP                 =  HWND(3);
  HWND_BOTTOM              =  HWND(4);
  HWND_THREADCAPTURE       =  HWND(5);

{ Standard Window Styles }

  WS_VISIBLE               = $80000000;
  WS_DISABLED              = $40000000;
  WS_CLIPCHILDREN          = $20000000;
  WS_CLIPSIBLINGS          = $10000000;
  WS_PARENTCLIP            = $08000000;
  WS_SAVEBITS              = $04000000;
  WS_SYNCPAINT             = $02000000;
  WS_MINIMIZED             = $01000000;
  WS_MAXIMIZED             = $00800000;

{ Dialog manager styles }

  WS_GROUP                 = $00010000;
  WS_TABSTOP               = $00020000;
  WS_MULTISELECT           = $00040000;

{ Class styles }

  CS_MOVENOTIFY            = $00000001;
  CS_SIZEREDRAW            = $00000004;
  CS_HITTEST               = $00000008;
  CS_PUBLIC                = $00000010;
  CS_FRAME                 = $00000020;
  CS_CLIPCHILDREN          = $20000000;
  CS_CLIPSIBLINGS          = $10000000;
  CS_PARENTCLIP            = $08000000;
  CS_SAVEBITS              = $04000000;
  CS_SYNCPAINT             = $02000000;

{*************************************************************************}
{***       Window Manager Subsection part 1                            ***}

Function WinRegisterClass(_hab: HAB; pszClassName: PSZ; pfnWndProc: PFNWP;
                          flStyle: ULONG; cbWindowData: USHORT): BOOL;
Function WinDefWindowProc(aWnd: HWND; msg: USHORT; mp1, mp2: MPARAM): MRESULT;
Function WinDestroyWindow(aWnd: HWND): BOOL;
Function WinShowWindow(aWnd: HWND; fShow: BOOL): BOOL;
Function WinQueryWindowRect(aWnd: HWND; prclDest: PRECTL): BOOL;
Function WinGetPS(aWnd: HWND): HPS;
Function WinReleasePS(aPS: HPS): BOOL;
Function WinEndPaint(aPS: HPS): BOOL;
Function WinGetClipPS(aWnd: HWND; ClipWnd: HWND; fs: USHORT): HPS;
Function WinIsWindowShowing(aWnd: HWND): BOOL;
Function WinBeginPaint(aWnd: HWND; ahps: HPS; prclPaint: PRECTL): HPS;
Function WinOpenWindowDC(aWnd: HWND): HDC;
Function WinScrollWindow(aWnd: HWND; dx, dy: SHORT;
                         prclScroll, prclClip: pRECTL; hrgnUpdate: HRGN; prclUpdate: pRECTL;
                         rgfsw: USHORT): SHORT;
Const
{ WinGetClipPS() flags }

  PSF_LOCKWINDOWUPDATE     = $0001;
  PSF_CLIPUPWARDS          = $0002;
  PSF_CLIPDOWNWARDS        = $0004;
  PSF_CLIPSIBLINGS         = $0008;
  PSF_CLIPCHILDREN         = $0010;
  PSF_PARENTCLIP           = $0020;

{ WinScrollWindow() flags }

  SW_SCROLLCHILDREN        = $0001;
  SW_INVALIDATERGN         = $0002;

Function WinFillRect(aPS: HPS; prcl: PRECTL; lColor: LONG): BOOL;

{ WinInitialize/WinTerminate Interface declarations }
Type
  QVERSDATA = Record
    environment,
    version: USHORT
  End;
  PQVERSDATA = ^QVERSDATA;

Const
  QV_OS2                   = $0000;
  QV_CMS                   = $0001;
  QV_TSO                   = $0002;
  QV_TSOBATCH              = $0003;
  QV_OS400                 = $0004;

Function WinQueryVersion(aAB: hAB): ULONG;
Function WinInitialize(aShort: USHORT): HAB;
Function WinTerminate(aAB: hAB): BOOL;
Function WinQueryAnchorBlock(aWnd: HWND): HAB;
Function WinCreateWindow(hwndParent: HWND; pszClass, pszName: PSZ;
                         flStyle: ULONG; x, y, cx, cy: SHORT; hwndOwner, hwndInsertBehind: HWND;
                         id: USHORT; pCtlData, pPresParams: PVOID): HWND;
Function WinEnableWindow(aWnd: HWND; fEnable: BOOL): BOOL;
Function WinIsWindowEnabled(aWnd: HWND): BOOL;
Function WinEnableWindowUpdate(aWnd: HWND; fEnable: BOOL): BOOL;
Function WinIsWindowVisible(aWnd: HWND): BOOL;
Function WinQueryWindowText(aWnd: HWND; cchBufferMax: SHORT; pchBuffer: pCH): SHORT;
Function WinSetWindowText(aWnd: HWND; pszText: PSZ): BOOL;
Function WinQueryWindowTextLength(aWnd: HWND): SHORT;
Function WinWindowFromID(aWndParent: HWND; id: USHORT): HWND;
Function WinIsWindow(aAB: hAB; aWnd: HWND): BOOL;
Function WinQueryWindow(aWnd: HWND; cmd: SHORT; fLock: BOOL): HWND;
Function WinMultWindowFromIDs(hwndParent: HWND; prghwnd: pHWND;
                              idFirst, idLast: USHORT): SHORT;

Const
{WinQueryWindow() codes}

  QW_NEXT       = 0;
  QW_PREV       = 1;
  QW_TOP        = 2;
  QW_BOTTOM     = 3;
  QW_OWNER      = 4;
  QW_PARENT     = 5;
  QW_NEXTTOP    = 6;
  QW_PREVTOP    = 7;
  QW_FRAMEOWNER = 8;

Function WinSetParent(aWnd, aWndNewParent: HWND; fRedraw: BOOL): BOOL;
Function WinIsChild(aWnd, aWndParent: HWND): BOOL;
Function WinSetOwner(aWnd: HWND; WndNewOwner: HWND): BOOL;
Function WinQueryWindowProcess(aWnd: HWND; apPID: pPID; apTID: pTID): BOOL;
Function WinQueryObjectWindow(hWndDesktop: HWND): HWND;
Function WinQueryDesktopWindow(aAB: hAB; aDC: hDC): HWND;

{** Window positioning functions }

{ WinSetMultWindowPos() structure }
Type
  SWP = Record
    fs: USHORT;
    cy, cx, y, x: SHORT;
    hwndInsertBehind,
    aWnd: HWND
  End;
  pSWP = ^SWP;

Function WinSetWindowPos(aWnd, hwndInsertBehind: HWND; x, y, cx, cy: SHORT;
                         fs: USHORT): BOOL;
Function WinQueryWindowPos(aWnd: HWND; aSWP: pSWP): BOOL;
Function WinSetMultWindowPos(aAB: hAB; aSWP: pSWP; cswp: USHORT): BOOL;

Const
{ Values returned from WM_ADJUSTWINDOWPOS and passed to WM_WINDOWPOSCHANGED }

  AWP_MINIMIZED            = $00010000;
  AWP_MAXIMIZED            = $00020000;
  AWP_RESTORED             = $00040000;
  AWP_ACTIVATE             = $00080000;
  AWP_DEACTIVATE           = $00100000;

{ WinSetWindowPos() flags }

  SWP_SIZE                 = $0001;
  SWP_MOVE                 = $0002;
  SWP_ZORDER               = $0004;
  SWP_SHOW                 = $0008;
  SWP_HIDE                 = $0010;
  SWP_NOREDRAW             = $0020;
  SWP_NOADJUST             = $0040;
  SWP_ACTIVATE             = $0080;
  SWP_DEACTIVATE           = $0100;
  SWP_EXTSTATECHANGE       = $0200;
  SWP_MINIMIZE             = $0400;
  SWP_MAXIMIZE             = $0800;
  SWP_RESTORE              = $1000;
  SWP_FOCUSACTIVATE        = $2000;
  SWP_FOCUSDEACTIVATE      = $4000;

{ Window painting }

Function WinUpdateWindow(aWnd: HWND): BOOL;
Function WinInvalidateRect(aWnd: HWND; pwrc: PRECTL; fIncludeChildren: BOOL): BOOL;
Function WinInvalidateRegion(aWnd: HWND; aRgn: HRGN; fIncludeChildren: BOOL): BOOL;

{ Drawing helpers }

Function WinInvertRect(aPS: HPS; prcl: PRECTL): BOOL;
Function WinDrawBitmap(hpsDst: HPS; hbm: HBITMAP; pwrcSrc: pRECTL;
                       pptlDst: pPOINTL; clrFore, clrBack: LONG; fs: USHORT): BOOL;

Const
{ WinDrawBitmap() flags }

  DBM_NORMAL               = $0000;
  DBM_INVERT               = $0001;
  DBM_HALFTONE             = $0002;
  DBM_STRETCH              = $0004;
  DBM_IMAGEATTRS           = $0008;

Function WinDrawText(aPS: HPS; cchText: SHORT; lpchText: PCH; prcl: PRECTL;
                     clrFore, clrBack: LONG; rgfCmd: USHORT): SHORT;
{* WinDrawText() codes:
 * From DT_LEFT to DT_EXTERNALLEADING, the codes are designed to be OR'ed with
 * SS_TEXT to create variations of the basic text static item.}
Const
  DT_LEFT                  = $0000;
  DT_EXTERNALLEADING       = $0080;
  DT_CENTER                = $0100;
  DT_RIGHT                 = $0200;
  DT_TOP                   = $0000;
  DT_VCENTER               = $0400;
  DT_BOTTOM                = $0800;
  DT_HALFTONE              = $1000;
  DT_MNEMONIC              = $2000;
  DT_WORDBREAK             = $4000;
  DT_ERASERECT             = $8000;
  DT_QUERYEXTENT           = $0002;
  DT_TEXTATTRS             = $0040;


Function WinDrawBorder(aPS: HPS; prcl: PRECTL; cx, cy: SHORT;
                       clrFore, clrBack: LONG; rgfCmd: USHORT): BOOL;

Const
{ WinDrawBorder() flags }

  DB_PATCOPY               = $0000;
  DB_PATINVERT             = $0001;
  DB_DESTINVERT            = $0002;
  DB_AREAMIXMODE           = $0003;

  DB_ROP                   = $0007;
  DB_INTERIOR              = $0008;
  DB_AREAATTRS             = $0010;
  DB_STANDARD              = $0100;
  DB_DLGBORDER             = $0200;



{* Resource loading functions }

Function WinLoadString(_hab: HAB; hmod: HMODULE; id: USHORT; cchMax: SHORT;
                       pchBuffer: PSZ): SHORT;
Function WinLoadMessage(_hab: HAB; hmod: HMODULE; id: USHORT; cchMax: SHORT;
                        pchBuffer: PSZ): SHORT;

{*************************************************************************}
{***                 Window Manager Subsection part 2                  ***}

Function WinSetActiveWindow(hWndDesktop, aWnd: HWND): BOOL;

{ WM_CREATE structure }

Type
  CreateStruct = Record
    pPresParams,
    pCtlData: pVoid;
    id: USHORT;
    hwndInsertBehind,
    hwndOwner: HWND;
    cy,
    cx,
    y,
    x: SHORT;
    flStyle: ULONG;
    pszText,
    pszClass: pSZ;
    hwndParent: HWND
  End;
  pCreateStruct = ^CreateStruct;

{ WinQueryClassInfo() structure }
  ClassInfo = Record
    flClassStyle: ULONG;
    pfnWindowProc: pFnWp;
    cbWindowData: USHORT
  End;
  pClassInfo = ^ClassInfo;

Function WinSubclassWindow(aWnd: HWND; _pfnwp: PFNWP): PFNWP;
Function WinQueryClassName(aWnd: HWND; cchMax: SHORT; _pch: PCH): SHORT;
Function WinQueryClassInfo(_hab: HAB; pszClassName: PSZ; _pClassInfo: PCLASSINFO): BOOL;
Function WinQueryActiveWindow(hWndDesktop: HWND; fLock: BOOL): HWND;
Function WinIsThreadActive(aAB: hAB): BOOL;
Function WinQuerySysModalWindow(hWndDesktop: HWND; fLock: BOOL): HWND;
Function WinLockWindow(aWnd: HWND; fLock: BOOL): HWND;
Function WinRegisterWindowDestroy(aWnd: HWND; fRegister: BOOL): BOOL;
Function WinSetSysModalWindow(hWndDesktop, aWnd: HWND): BOOL;
Function WinQueryWindowLockCount(aWnd: HWND): SHORT;
Function WinQueryWindowUShort(aWnd: HWND; index: SHORT): USHORT;
Function WinSetWindowUShort(aWnd: HWND; index: SHORT; us: USHORT): BOOL;
Function WinQueryWindowULong(aWnd: HWND; index: SHORT): ULONG;
Function WinSetWindowULong(aWnd: HWND; index: SHORT; ul: ULONG): BOOL;
Function WinQueryWindowPtr(aWnd: HWND; index: SHORT): PVOID;
Function WinSetWindowPtr(aWnd: HWND; index: SHORT; p: PVOID): BOOL;
Function WinSetWindowBits(aWnd: HWND; index: SHORT; flData, flMask: ULONG): BOOL;

Const
{ Standard WinQueryWindowUShort/ULong() indices }
  QWS_USER                 = 0;
  QWS_ID                   = -1;
  QWS_MIN                  = -1;

  QWL_USER                 = 0;
  QWL_STYLE                = -2;
  QWP_PFNWP                = -3;
  QWL_HMQ                  = -4;
  QWL_MIN                  = -4;

{ WC_FRAME WinQueryWindowUShort/ULong() indices }

  QWL_HHEAP                = $0004;
  QWLaWndFOCUSSAVE        = $0018;

  QWS_FLAGS                = $0008;
  QWS_RESULT               = $000a;
  QWS_XRESTORE             = $000c;
  QWS_YRESTORE             = $000e;
  QWS_CXRESTORE            = $0010;
  QWS_CYRESTORE            = $0012;
  QWS_XMINIMIZE            = $0014;
  QWS_YMINIMIZE            = $0016;


{ Window enumeration }

Type
  HENUM = LHANDLE;

Function WinBeginEnumWindows(aWnd: HWND): HENUM;
Function WinGetNextWindow(_henum: HENUM): HWND;
Function WinEndEnumWindows(_henum: HENUM): BOOL;
Function WinWindowFromPoint(aWnd: hWnd; pptl: pPOINTL; fChildren, fLock: BOOL): BOOL;
Function WinMapWindowPoints(hWndFrom, hWndTo: HWND; prgptl: pPOINTL; cwpt: SHORT): BOOL;

{ More window painting functions }

Function WinValidateRect(aWnd: HWND; prcl: PRECTL; fIncludeChildren: BOOL): BOOL;
Function WinValidateRegion(aWnd: HWND; _hrgn: HRGN; fIncludeChildren: BOOL): BOOL;
Function WinWindowFromDC(aDC: hDC): HWND;
Function WinQueryWindowDC(aWnd: HWND): HDC;
Function WinGetScreenPS(hWndDesktop: HWND): HPS;
Function WinLockWindowUpdate(hWndDesktop, aWndLockUpdate: HWND): BOOL;
Function WinLockVisRegions(hWndDesktop: HWND; fLock: BOOL): BOOL;
Function WinQueryUpdateRect(aWnd: HWND; prcl: PRECTL): BOOL;
Function WinQueryUpdateRegion(aWnd: HWND; _hrgn: HRGN): SHORT;
Function WinExcludeUpdateRegion(aPS: HPS; aWnd: HWND): SHORT;

Type
{ QMSG structure }

  QMsg = Record
    aWnd: HWND;
    msg: USHORT;
    mp1, mp2: MPARAM;
    time: ULONG;
    ptl: POINTL
  End;
  pQMsg = ^QMsg;
  HMQ = LHANDLE;

{
** This is the standard function definition for window procedures.
** Typically they are names like "XxxxxxxxWndProc", where the prefix
** "Xxxxxxxxx" is replaced by some name descriptive of the window procedure
** being declared.  Window procedures must be EXPORTED in the definitions
** file used by the linker.
**
** MRESULT EXPENTRY MyclassWndProc(HWND hwnd,   ** window handle        **
**                                 USHORT msg,  ** message number       **
**                                 MPARAM mp1,  ** 1st (packed) parms   **
**                                 MPARAM mp2); ** 2nd (packed) parms   **
}

Const
{ Standard Window Messages }
  WM_NULL                  = $0000;
  WM_CREATE                = $0001;
  WM_DESTROY               = $0002;
  WM_OTHERWINDOWDESTROYED  = $0003;
  WM_ENABLE                = $0004;
  WM_SHOW                  = $0005;
  WM_MOVE                  = $0006;
  WM_SIZE                  = $0007;
  WM_ADJUSTWINDOWPOS       = $0008;
  WM_CALCVALIDRECTS        = $0009;
  WM_SETWINDOWPARAMS       = $000a;
  WM_QUERYWINDOWPARAMS     = $000b;
  WM_HITTEST               = $000c;
  WM_ACTIVATE              = $000d;
  WM_SETFOCUS              = $000f;
  WM_SETSELECTION          = $0010;

{ language support Winproc }
  WM_PPAINT                = $0011;
  WM_PSETFOCUS             = $0012;
  WM_PSYSCOLORCHANGE       = $0013;
  WM_PSIZE                 = $0014;
  WM_PACTIVATE             = $0015;
  WM_PCONTROL              = $0016;
  WM_COMMAND               = $0020;
  WM_SYSCOMMAND            = $0021;
  WM_HELP                  = $0022;
  WM_PAINT                 = $0023;
  WM_TIMER                 = $0024;
  WM_SEM1                  = $0025;
  WM_SEM2                  = $0026;
  WM_SEM3                  = $0027;
  WM_SEM4                  = $0028;
  WM_CLOSE                 = $0029;
  WM_QUIT                  = $002a;
  WM_SYSCOLORCHANGE        = $002b;
  WM_SYSVALUECHANGED       = $002d;
  WM_APPTERMINATENOTIFY    = $002e;
  WM_PRESPARAMCHANGED      = $002f;

{ Control notification messages }

  WM_CONTROL               = $0030;
  WM_VSCROLL               = $0031;
  WM_HSCROLL               = $0032;
  WM_INITMENU              = $0033;
  WM_MENUSELECT            = $0034;
  WM_MENUEND               = $0035;
  WM_DRAWITEM              = $0036;
  WM_MEASUREITEM           = $0037;
  WM_CONTROLPOINTER        = $0038;
  WM_CONTROLHEAP           = $0039;
  WM_QUERYDLGCODE          = $003a;
  WM_INITDLG               = $003b;
  WM_SUBSTITUTESTRING      = $003c;
  WM_MATCHMNEMONIC         = $003d;
  WM_SAVEAPPLICATION       = $003e;

{ Reserve a range of messages for help manager.  This range includes  }
{ public messages, defined below, and private ones, which need to be  }
{ reserved here to prevent clashing with application messages         }

  WM_HELPBASE              = $0F00;{ Start of msgs for help manager   }
  WM_HELPTOP               = $0FFF;{ End of msgs for help manager     }

  WM_USER                  = $1000;

{ WM_COMMAND msg source codes }

  CMDSRC_PUSHBUTTON        = 1;
  CMDSRC_MENU              = 2;
  CMDSRC_ACCELERATOR       = 3;
  CMDSRC_OTHER             = 0;

Type
{ The following structure and macro are used to access the
  WM_COMMAND, WM_HELP, and WM_SYSCOMMAND message parameters: }
  CmdMsg = Record
    source,          { mp2 }
    fMouse,
    cmd,             { mp1 }
    unused: USHORT
  End;
{ -CANT-
  COMMANDMSG(pmsg) \
        ((struct _COMMANDMSG FAR *)((PBYTE)pmsg - sizeof(MPARAM) * 2))
}

{
 * The following structure is used by the WinQueryQueueInfo() routine
 }
 MQInfo = Record
   cb:   {$IfDef Use13} USHORT {$Else} ULONG {$EndIf};
   _pid: PID;
   _tid: TID;
   cmsgs: {$IfDef Use13} USHORT {$Else} ULONG {$EndIf};
   pReserved: pVoid
 End;
  pMQInfo = ^MQInfo;

Function WinSendMsg(aWnd: HWND; msg: USHORT; mp1, mp2: MPARAM): MRESULT;
Function WinCreateMsgQueue(aAB: hAB; cmsg: SHORT): HMQ;
Function WinDestroyMsgQueue(_hmq: HMQ): BOOL;
Function WinQueryQueueInfo(_hmq: HMQ; pmqi: PMQINFO; cbCopy: USHORT): BOOL;
Function WinCancelShutdown(_hmq: HMQ; fCancelAlways: BOOL): BOOL;
Function WinGetMsg(_hab: HAB; _pqmsg: PQMSG; hwndFilter: HWND;
                   msgFilterFirst, msgFilterLast: USHORT): BOOL;
Function WinPeekMsg(_hab: HAB; _pqmsg: PQMSG; hwndFilter: HWND;
                    msgFilterFirst, msgFilterLast, fs: USHORT): BOOL;
Function WinDispatchMsg(aAB: hAB; _pqmsg: PQMSG): MRESULT;
Function WinPostMsg(aWnd: HWND; msg: USHORT; mp1, mp2: MPARAM): BOOL;
Function WinRegisterUserMsg(_hab: HAB; msgid: USHORT;
                            datatype1, dir1, datatype2, dir2, datatyper: SHORT): BOOL;
Function WinRegisterUserDatatype(_hab: HAB; datatype, count: SHORT; types: PSHORT): BOOL;
Function WinSetMsgMode(_hab: HAB; classname: PSZ; control: SHORT): BOOL;
Function WinSetSynchroMode(aAB: hAB; mode: SHORT): BOOL;

Const
{ WinPeekMsg() constants }

  PM_REMOVE                = $0001;
  PM_NOREMOVE              = $0000;

{ WinRegisterUserDatatype datatypes defined in separate file }

{ WinRegisterUserMsg direction codes }

Const
  RUM_IN                   = 1;
  RUM_OUT                  = 2;
  RUM_INOUT                = 3;

{ WinSetMsgMode constants }

  SMD_DELAYED              = $0001;
  SMD_IMMEDIATE            = $0002;

{ WinSetSynchroMode constants }

  SSM_SYNCHRONOUS          = $0001;
  SSM_ASYNCHRONOUS         = $0002;
  SSM_MIXED                = $0003;

{ WM_CALCVALIDRECTS return flags }

  CVR_ALIGNLEFT            = $0001;
  CVR_ALIGNBOTTOM          = $0002;
  CVR_ALIGNRIGHT           = $0004;
  CVR_ALIGNTOP             = $0008;
  CVR_REDRAW               = $0010;


{ WM_HITTEST return codes }

  HT_NORMAL               =  0;
  HT_TRANSPARENT          = -1;
  HT_DISCARD              = -2;
  HT_ERROR                = -3;


Type
{ WM_SET/QUERYWINDOWPARAMS structures and flags }

  WndParams = Record
    fsStatus,
    cchText: USHORT;
    pszText: pSZ;
    cbPresParams: USHORT;
    pPresParams: pVoid;
    cbCtlData: USHORT;
    pCtlData: pVoid
  End;
  pWndParams = ^WndParams;

Const
{ Flags used by WM_SET/QUERYWINDOWPARAMS }

  WPM_TEXT                 = $0001;
  WPM_CTLDATA              = $0002;
  WPM_PRESPARAMS           = $0004;
  WPM_CCHTEXT              = $0008;
  WPM_CBCTLDATA            = $0010;
  WPM_CBPRESPARAMS         = $0020;

Function WinInSendMsg(aAB: hAB): BOOL;
Function WinBroadcastMsg(aWnd: HWND; msg: USHORT; mp1, mp2: MPARAM; rgf: USHORT): BOOL;

Const
{ WinBroadcastMsg codes }

  BMSG_POST                = $0000;
  BMSG_SEND                = $0001;
  BMSG_POSTQUEUE           = $0002;
  BMSG_DESCENDANTS         = $0004;
  BMSG_FRAMEONLY           = $0008;



Function WinWaitMsg(aAB: hAB; msgFirst, msgLast: USHORT): BOOL;
Function WinQueryQueueStatus(hWndDesktop: HWND): ULONG;

Const
{ WinQueryQueueStatus() constants }
  QS_KEY                   = $0001;
  QS_MOUSEBUTTON           = $0002;
  QS_MOUSEMOVE             = $0004;
  QS_MOUSE                 = $0006;  { QS_MOUSEMOVE|QS_MOUSEBUTTON }
  QS_TIMER                 = $0008;
  QS_PAINT                 = $0010;
  QS_POSTMSG               = $0020;
  QS_SEM1                  = $0040;
  QS_SEM2                  = $0080;
  QS_SEM3                  = $0100;
  QS_SEM4                  = $0200;
  QS_SENDMSG               = $0400;


Function WinQueryMsgPos(aAB: hAB; pptl: PPOINTL): BOOL;
Function WinQueryMsgTime(aAB: hAB): ULONG;

Function WinMsgSemWait(_hsem: HSEM; dtTimeout: LONG): USHORT;
Function WinMsgMuxSemWait(pisemCleared: PUSHORT; pmxsl: PVOID; dtTimeout: LONG): USHORT;
Function WinPostQueueMsg(_hmq: HMQ; msg: USHORT; mp1, mp2: MPARAM): BOOL;


Const
{ WinSetMsgInterest()/WinSetClassMsgInterest() constants }
  SMIM_ALL                 = $0EFF;
  SMI_NOINTEREST           = $0001;
  SMI_INTEREST             = $0002;
  SMI_RESET                = $0004;
  SMI_AUTODISPATCH         = $0008;

Function WinSetMsgInterest(aWnd: HWND; msg_class: USHORT; control: SHORT): BOOL;
Function WinSetClassMsgInterest(_hab: HAB; pszClassName: PSZ;
                                msg_class: USHORT; control: SHORT): BOOL;

{** Keyboard and mouse }

{** Keyboard and mouse input COMMON subsection }
Function WinSetFocus(hWndDesktop, aWndSetFocus: HWND): BOOL;
Function WinFocusChange(hwndDesktop, hwndSetFocus: HWND; fsFocusChange: USHORT): BOOL;

Const
  FC_NOSETFOCUS            = $0001;
  FC_NOBRINGTOTOP          = FC_NOSETFOCUS;
  FC_NOLOSEFOCUS           = $0002;
  FC_NOBRINGTOPFIRSTWINDOW = FC_NOLOSEFOCUS;
  FC_NOSETACTIVEFOCUS      = $0003;
  FC_NOSETACTIVE           = $0004;
  FC_NOLOSEACTIVE          = $0008;
  FC_NOSETSELECTION        = $0010;
  FC_NOLOSESELECTION       = $0020;

  QFC_NEXTINCHAIN          = $0001;
  QFC_ACTIVE               = $0002;
  QFC_FRAME                = $0003;
  QFC_SELECTACTIVE         = $0004;

Function WinSetCapture(hWndDesktop, aWnd: HWND): BOOL;
Function WinQueryCapture(hWndDesktop: HWND; fLock: BOOL): HWND;

Const
{ Mouse input messages }

  WM_MOUSEFIRST            = $0070;
  WM_MOUSELAST             = $0079;
  WM_BUTTONCLICKFIRST      = $0071;
  WM_BUTTONCLICKLAST       = $0079;
  WM_MOUSEMOVE             = $0070;

  WM_BUTTON1DOWN           = $0071;

  WM_BUTTON1UP             = $0072;
  WM_BUTTON1DBLCLK         = $0073;
  WM_BUTTON2DOWN           = $0074;
  WM_BUTTON2UP             = $0075;
  WM_BUTTON2DBLCLK         = $0076;
  WM_BUTTON3DOWN           = $0077;
  WM_BUTTON3UP             = $0078;
  WM_BUTTON3DBLCLK         = $0079;

Function WinQueryFocus(hWndDesktop: HWND; fLock: BOOL): HWND;


Const
{ Key/Character input messages }

  WM_CHAR                  = $007a;
  WM_VIOCHAR               = $007b;

{ WM_CHAR fs field bits }

  KC_CHAR                  = $0001;
  KC_VIRTUALKEY            = $0002;
  KC_SCANCODE              = $0004;

  KC_SHIFT                 = $0008;
  KC_CTRL                  = $0010;
  KC_ALT                   = $0020;
  KC_KEYUP                 = $0040;
  KC_PREVDOWN              = $0080;
  KC_LONEKEY               = $0100;
  KC_DEADKEY               = $0200;
  KC_COMPOSITE             = $0400;
  KC_INVALIDCOMP           = $0800;
  KC_TOGGLE                = $1000;
  KC_INVALIDCHAR           = $2000;
  KC_DBCSRSRVD1            = $4000;
  KC_DBCSRSRVD2            = $8000;

Type
{
 * The following structure and macro are used to access the
 * WM_MOUSEMOVE, and WM_BUTTON message parameters
 }
 MSeMsg = Record
   codeHitTest,    {mp2}
   unused: USHORT;
   x,              {mp1}
   y: USHORT
 End;
{ -CANT-
  MOUSEMSG(pmsg) \
        ((struct _MOUSEMSG FAR *)((PBYTE)pmsg - sizeof(MPARAM) * 2))
}

{
 * The following structure and macro are used to access the
 * WM_CHAR message parameters.
 }
CHRMSG = Record
  chr,        {mp2}
  vkey,
  fs: USHORT; {mp1}
  cRepeat,
  scancode: UCHAR
End;

{ -CANT-
  CHARMSG(pmsg) \
        ((struct _CHARMSG FAR *)((PBYTE)pmsg - sizeof(MPARAM) * 2))
}

Const
{** Virtual key values }

  VK_BUTTON1               = $01;
  VK_BUTTON2               = $02;
  VK_BUTTON3               = $03;
  VK_BREAK                 = $04;
  VK_BACKSPACE             = $05;
  VK_TAB                   = $06;
  VK_BACKTAB               = $07;
  VK_NEWLINE               = $08;
  VK_SHIFT                 = $09;
  VK_CTRL                  = $0A;
  VK_ALT                   = $0B;
  VK_ALTGRAF               = $0C;
  VK_PAUSE                 = $0D;
  VK_CAPSLOCK              = $0E;
  VK_ESC                   = $0F;
  VK_SPACE                 = $10;
  VK_PAGEUP                = $11;
  VK_PAGEDOWN              = $12;
  VK_END                   = $13;
  VK_HOME                  = $14;
  VK_LEFT                  = $15;
  VK_UP                    = $16;
  VK_RIGHT                 = $17;
  VK_DOWN                  = $18;
  VK_PRINTSCRN             = $19;
  VK_INSERT                = $1A;
  VK_DELETE                = $1B;
  VK_SCRLLOCK              = $1C;
  VK_NUMLOCK               = $1D;
  VK_ENTER                 = $1E;
  VK_SYSRQ                 = $1F;
  VK_F1                    = $20;
  VK_F2                    = $21;
  VK_F3                    = $22;
  VK_F4                    = $23;
  VK_F5                    = $24;
  VK_F6                    = $25;
  VK_F7                    = $26;
  VK_F8                    = $27;
  VK_F9                    = $28;
  VK_F10                   = $29;
  VK_F11                   = $2A;
  VK_F12                   = $2B;
  VK_F13                   = $2C;
  VK_F14                   = $2D;
  VK_F15                   = $2E;
  VK_F16                   = $2F;
  VK_F17                   = $30;
  VK_F18                   = $31;
  VK_F19                   = $32;
  VK_F20                   = $33;
  VK_F21                   = $34;
  VK_F22                   = $35;
  VK_F23                   = $36;
  VK_F24                   = $37;


  VK_MENU                  = VK_F10;
  VK_DBCSFIRST             = $0080;
  VK_DBCSLAST              = $00ff;

  VK_USERFIRST             = $0100;
  VK_USERLAST              = $01ff;

Function WinGetKeyState(hWndDesktop: HWND; vkey: SHORT): SHORT;
Function WinGetPhysKeyState(hWndDesktop: HWND; sc: SHORT): SHORT;
Function WinEnablePhysInput(hWndDesktop: HWND; fEnable: BOOL): BOOL;
Function WinIsPhysInputEnabled(hWndDesktop: HWND): BOOL;
Function WinSetKeyboardStateTable(hwndDesktop: HWND; pKeyStateTable: PBYTE;
                                  fSet: BOOL): BOOL;

Const
{ Journal Notification messages  }
  WM_JOURNALNOTIFY         = $007c;

{** Define the valid commands (lParm1) for journal notify message }
  JRN_QUEUESTATUS          = $00000001;
  JRN_PHYSKEYSTATE         = $00000002;

{*** Dialog Manager }

{*** Dialog Manager COMMON subsection }

{
** This is the standard function definition for dialog procedures.
** Typically they are names like "XxxxxxxxDlgProc", where the prefix
** "Xxxxxxxxx" is replaced by some name descriptive of the dialog procedure
** being declared.  Dialog procedures must be EXPORTED in the definitions
** file used by the linker.  The dialog procedure declaration is identical
** to that for window procedures.
**
** MRESULT EXPENTRY MydialogDlgProc(HWND hwnd,   ** window handle        **
**                                  USHORT msg,  ** message number       **
**                                  MPARAM mp1,  ** 1st (packed) parms   **
**                                  MPARAM mp2); ** 2nd (packed) parms   **
}

Function WinGetDlgMsg(hWndDlg: HWND; _pqmsg: PQMSG): BOOL;
Function WinLoadDlg(hwndParent, hwndOwner: HWND; pfnDlgProc: PFNWP;
                    hmod: HMODULE; idDlg: USHORT; pCreateParams: PVOID): HWND;
Function WinDlgBox(hwndParent, hwndOwner: HWND; pfnDlgProc: PFNWP;
                   hmod: HMODULE; idDlg: USHORT; pCreateParams: PVOID): USHORT;
Function WinDismissDlg(hWndDlg: HWND; usResult: USHORT): BOOL;
Function WinQueryDlgItemShort(hwndDlg: HWND; idItem: USHORT; pResult: PSHORT;
                              fSigned: BOOL): BOOL;
Function WinSetDlgItemShort(hwndDlg: HWND; idItem, usValue: USHORT;
                            fSigned: BOOL): BOOL;
Function WinSetDlgItemText(hWndDlg: HWND; Item: USHORT; pszText: PSZ): BOOL;
Function WinQueryDlgItemText(hwndDlg: HWND; idItem: USHORT;
                             cchBufferMax: SHORT; pchBuffer: PSZ): BOOL;
Function WinQueryDlgItemTextLength(hWndDlg: HWND; idItem: USHORT): SHORT;
Function WinDefDlgProc(hwndDlg: HWND; msg: USHORT; mp1, mp2: MPARAM): MRESULT;

{ Special item IDs }

Const
  DID_OK    = 1;
  DID_CANCEL= 2;
  DID_ERROR = $ffff;

Function WinAlarm(hWndDesktop: HWND; rgfType: USHORT): BOOL;

{ WinAlarm Codes }
Const
  WA_WARNING               = 0;
  WA_NOTE                  = 1;
  WA_ERROR                 = 2;
  WA_CWINALARMS            = 3;

Function WinMessageBox(hwndParent, hwndOwner: HWND; pszText, pszCaption: PSZ;
                       idWindow, flStyle: USHORT): USHORT;

{ Message box types }
Const
  MB_OK                    = $0000;
  MB_OKCANCEL              = $0001;
  MB_RETRYCANCEL           = $0002;
  MB_ABORTRETRYIGNORE      = $0003;
  MB_YESNO                 = $0004;
  MB_YESNOCANCEL           = $0005;
  MB_CANCEL                = $0006;
  MB_ENTER                 = $0007;
  MB_ENTERCANCEL           = $0008;

  MB_NOICON                = $0000;
  MB_CUANOTIFICATION       = $0000;
  MB_ICONQUESTION          = $0010;
  MB_ICONEXCLAMATION       = $0020;
  MB_CUAWARNING            = $0020;
  MB_ICONASTERISK          = $0030;
  MB_ICONHAND              = $0040;
  MB_CUACRITICAL           = $0040;
  MB_QUERY                 = MB_ICONQUESTION;
  MB_WARNING               = MB_CUAWARNING;
  MB_INFORMATION           = MB_ICONASTERISK;
  MB_CRITICAL              = MB_CUACRITICAL;
  MB_ERROR                 = MB_CRITICAL;

  MB_DEFBUTTON1            = $0000;
  MB_DEFBUTTON2            = $0100;
  MB_DEFBUTTON3            = $0200;

  MB_APPLMODAL             = $0000;
  MB_SYSTEMMODAL           = $1000;
  MB_HELP                  = $2000;
  MB_MOVEABLE              = $4000;


{ Message box return codes }

  MBID_OK                  = 1;
  MBID_CANCEL              = 2;
  MBID_ABORT               = 3;
  MBID_RETRY               = 4;
  MBID_IGNORE              = 5;
  MBID_YES                 = 6;
  MBID_NO                  = 7;
  MBID_HELP                = 8;
  MBID_ENTER               = 9;
  MBID_ERROR               = $ffff;

{ Dialog codes: returned by WM_QUERYDLGCODE msg     }

  DLGC_ENTRYFIELD  = $0001; { Entry field item understands EM_SETSEL) }
  DLGC_BUTTON      = $0002; { Button item                             }
  DLGC_RADIOBUTTON = $0004; { Radio button                            }
  DLGC_STATIC      = $0008; { Static item                             }
  DLGC_DEFAULT     = $0010; { Default push button                     }
  DLGC_PUSHBUTTON  = $0020; { Normal (Non-default) push button        }
  DLGC_CHECKBOX    = $0040; { Check box button control                }
  DLGC_SCROLLBAR   = $0080; { Scroll bar                              }
  DLGC_MENU        = $0100; { Menu                                    }
  DLGC_TABONCLICK  = $0200;
  DLGC_MLE         = $0400; { Multiple Line Entry                     }


Function WinProcessDlg(hWndDlg: HWND): USHORT;
Function WinStartDlg(hWndDlg: HWND): USHORT;
Function WinSendDlgItemMsg(hwndDlg: HWND; idItem, msg: USHORT; mp1, mp2: MPARAM): MRESULT;
Function WinMapDlgPoints(hwndDlg: HWND; prgwptl: PPOINTL; cwpt: USHORT;
                         fCalcWindowCoords: BOOL): BOOL;
Function WinEnumDlgItem(hwndDlg, aWnd: HWND; code: USHORT; fLock: BOOL): HWND;
Function WinSubstituteStrings(aWnd: HWND; pszSrc: PSZ; cchDstMax: SHORT;
                              pszDst: PSZ): SHORT;
Const
{ WinEnumDlgItem() constants
 *
 * In OS/2 1.2, WinEnumDlgItem() can enumerate a window such that the
 * selection cursor may be moved  according to CUA (Common User Access)
 * rules.
 }

  EDI_FIRSTTABITEM         = 0;
  EDI_LASTTABITEM          = 1;
  EDI_NEXTTABITEM          = 2;
  EDI_PREVTABITEM          = 3;
  EDI_FIRSTGROUPITEM       = 4;
  EDI_LASTGROUPITEM        = 5;
  EDI_NEXTGROUPITEM        = 6;
  EDI_PREVGROUPITEM        = 7;

{** Dialog template definitions }

Type
{ Variable-sized dialog template items: }

  DlgTItem = Record
    fsItemStatus,
    cChildren,
    cchClassName,
    offClassName,
    cchText,
    offText: USHORT;
    flStyle: ULONG;
    x,
    y,
    cx,
    cy: SHORT;
    id,
    offPresParams,
    offCtlData: USHORT
  End;
  pDlgTItem = ^DlgTItem;

{ Dialog Template structure }
  DlgTemplate = Record
    cbTemplate,
    dlgtype,
    codepage,
    offadlgti,
    fsTemplateStatus,
    iItemFocus,
    coffPresParams: USHORT;
    dlgti: Array[0..0] Of DlgTItem
  End;
  pDlgTemplate = ^DlgTemplate;

Function WinCreateDlg(hwndParent, hwndOwner: HWND; pfnDlgProc: PFNWP;
                      pdlgt: PDLGTEMPLATE; pCreateParams: PVOID): HWND;

{** Static Control Manager }

Const
{ Static control styles:
 *
 * NOTE: the top 9 bits of the LOWORD of the window flStyle are used for
 * DT_* flags.  The lower 7 bits are for SS_* styles.  This gives us up
 * to 128 distinct static control types (we currently use 11 of them).
 }
  SS_TEXT                  = $0001;
  SS_GROUPBOX              = $0002;
  SS_ICON                  = $0003;
  SS_BITMAP                = $0004;
  SS_FGNDRECT              = $0005;
  SS_HALFTONERECT          = $0006;
  SS_BKGNDRECT             = $0007;
  SS_FGNDFRAME             = $0008;
  SS_HALFTONEFRAME         = $0009;
  SS_BKGNDFRAME            = $000a;
  SS_SYSICON               = $000b;

{ Static control class name }

  WC_STATIC            = pChar($ffff0005);

{ Static control messages }

  SM_SETHANDLE             = $0100;
  SM_QUERYHANDLE           = $0101;

{*** Button Controls Subsection }

{ Button control styles }

  BS_PUSHBUTTON            = 0;
  BS_CHECKBOX              = 1;
  BS_AUTOCHECKBOX          = 2;
  BS_RADIOBUTTON           = 3;
  BS_AUTORADIOBUTTON       = 4;
  BS_3STATE                = 5;
  BS_AUTO3STATE            = 6;
  BS_USERBUTTON            = 7;

  BS_HELP                  = $0100;
  BS_SYSCOMMAND            = $0200;
  BS_DEFAULT               = $0400;
  BS_NOPOINTERFOCUS        = $0800;
  BS_NOBORDER              = $1000;
  BS_NOCURSORSELECT        = $2000;


{ Button class name }

  WC_BUTTON       = pChar($ffff0003);


Type
  BTNCDATA = Record
    cb,
    fsCheckState,
    fsHiliteState: USHORT
  End;
  pBTNCDATA = ^BTNCDATA;

{ User button structure (passed in WM_CONTROL msg) }

  USERBUTTON = Record
    aWnd: HWND;
    _hps: HPS;
    fsState,
    fsStateOld: USHORT
  End;
  pUSERBUTTON = ^USERBUTTON;

Const
{ Button control messages }

  BM_CLICK                 = $0120;
  BM_QUERYCHECKINDEX       = $0121;
  BM_QUERYHILITE           = $0122;
  BM_SETHILITE             = $0123;
  BM_QUERYCHECK            = $0124;
  BM_SETCHECK              = $0125;
  BM_SETDEFAULT            = $0126;

{ Button notification codes }

  BN_CLICKED               = 1;
  BN_DBLCLICKED            = 2;
  BN_PAINT                 = 3;

{ BN_PAINT button draw state codes (must be in high byte) }

  BDS_HILITED              = $0100;
  BDS_DISABLED             = $0200;
  BDS_DEFAULT              = $0400;

{*** Entryfield controls Subsection }

{ Entry field  styles }

  ES_LEFT                  = $00000000;
  ES_CENTER                = $00000001;
  ES_RIGHT                 = $00000002;
  ES_AUTOSCROLL            = $00000004;
  ES_MARGIN                = $00000008;
  ES_AUTOTAB               = $00000010;
  ES_READONLY              = $00000020;
  ES_COMMAND               = $00000040;
  ES_UNREADABLE            = $00000080;
  ES_PICTUREMASK           = $00000100;
  ES_ANY                   = $00000000;
  ES_SBCS                  = $00001000;
  ES_DBCS                  = $00002000;
  ES_MIXED                 = $00003000;  { ES_SBCS | ES_DBCS }

  WC_COMBOBOX          = pChar($ffff0002);

{ combo box styles }
  CBS_SIMPLE               = $0001;
  CBS_DROPDOWN             = $0002;
  CBS_DROPDOWNLIST         = $0004;

{ IDs of combobox entry field and listbox. }
  CBID_LIST                = $029A;
  CBID_EDIT                = $029B;

  CBM_SHOWLIST             = $0170;
  CBM_HILITE               = $0171;
  CBM_ISLISTSHOWING        = $0172;

  CBN_EFCHANGE             = 1;
  CBN_EFSCROLL             = 2;
  CBN_MEMERROR             = 3;
  CBN_LBSELECT             = 4;
  CBN_LBSCROLL             = 5;
  CBN_SHOWLIST             = 6;
  CBN_ENTER                = 7;

  WC_ENTRYFIELD        = pChar($ffff0006);

Type
  ENTRYFDATA = Record
    cb,
    cchEditLimit,
    ichMinSel,
    ichMaxSel: USHORT
  End;
  pENTRYFDATA = ^ENTRYFDATA;

Const
{ Entry Field  messages }

  EM_QUERYCHANGED          = $0140;
  EM_QUERYSEL              = $0141;
  EM_SETSEL                = $0142;
  EM_SETTEXTLIMIT          = $0143;
  EM_CUT                   = $0144;
  EM_COPY                  = $0145;
  EM_CLEAR                 = $0146;
  EM_PASTE                 = $0147;
  EM_QUERYFIRSTCHAR        = $0148;
  EM_SETFIRSTCHAR          = $0149;
  EM_QUERYREADONLY         = $014a;
  EM_SETREADONLY           = $014b;
  EM_SETINSERTMODE         = $014c;

{ Entry Field notification messages }

  EN_SETFOCUS              = $0001;
  EN_KILLFOCUS             = $0002;
  EN_CHANGE                = $0004;
  EN_SCROLL                = $0008;
  EN_MEMERROR              = $0010;
  EN_OVERFLOW              = $0020;
  EN_INSERTMODETOGGLE      = $0040;

{  Multiple Line Entrys }
  WC_MLE     = pChar($ffff000a);

{*** Listboxes }
Const
{ List box styles }

  LS_MULTIPLESEL           = $00000001;
  LS_OWNERDRAW             = $00000002;
  LS_NOADJUSTPOS           = $00000004;
  LS_HORZSCROLL            = $00000008;


{ Listbox class name }

  WC_LISTBOX           = pChar($ffff0007);

{ List box notification messages }

  LN_SELECT                = 1;
  LN_SETFOCUS              = 2;
  LN_KILLFOCUS             = 3;
  LN_SCROLL                = 4;
  LN_ENTER                 = 5;

{ List box messages }

  LM_QUERYITEMCOUNT        = $0160;
  LM_INSERTITEM            = $0161;
  LM_SETTOPINDEX           = $0162;
  LM_DELETEITEM            = $0163;
  LM_SELECTITEM            = $0164;
  LM_QUERYSELECTION        = $0165;
  LM_SETITEMTEXT           = $0166;
  LM_QUERYITEMTEXTLENGTH   = $0167;
  LM_QUERYITEMTEXT         = $0168;

  LM_SETITEMHANDLE         = $0169;
  LM_QUERYITEMHANDLE       = $016a;
  LM_SEARCHSTRING          = $016b;
  LM_SETITEMHEIGHT         = $016c;
  LM_QUERYTOPINDEX         = $016d;
  LM_DELETEALL             = $016e;

{ List box constants }

  LIT_ERROR                = -3;
  LIT_MEMERROR             = -2;
  LIT_NONE                 = -1;
  LIT_FIRST                = -1;

{ For LM_INSERTITEM msg }

  LIT_END                  = -1;
  LIT_SORTASCENDING        = -2;
  LIT_SORTDESCENDING       = -3;

{ For LM_SEARCHSTRING msg }

  LSS_SUBSTRING            = $0001;
  LSS_PREFIX               = $0002;
  LSS_CASESENSITIVE        = $0004;


{*** Menu Manager Subsection }

{ Menu control styles }

  MS_ACTIONBAR             = $00000001;
  MS_TITLEBUTTON           = $00000002;
  MS_VERTICALFLIP          = $00000004;

Function WinLoadMenu(hWndFrame: HWND; hmod: HMODULE; idMenu: USHORT): HWND;

Const
{ Menu class name }
  WC_MENU              = pChar($ffff0004);

{ Menu control messages }
  MM_INSERTITEM            = $0180;
  MM_DELETEITEM            = $0181;
  MM_QUERYITEM             = $0182;
  MM_SETITEM               = $0183;
  MM_QUERYITEMCOUNT        = $0184;
  MM_STARTMENUMODE         = $0185;
  MM_ENDMENUMODE           = $0186;
  MM_DISMISSMENU           = $0187;
  MM_REMOVEITEM            = $0188;
  MM_SELECTITEM            = $0189;
  MM_QUERYSELITEMID        = $018a;
  MM_QUERYITEMTEXT         = $018b;
  MM_QUERYITEMTEXTLENGTH   = $018c;
  MM_SETITEMHANDLE         = $018d;
  MM_SETITEMTEXT           = $018e;
  MM_ITEMPOSITIONFROMID    = $018f;
  MM_ITEMIDFROMPOSITION    = $0190;
  MM_QUERYITEMATTR         = $0191;
  MM_SETITEMATTR           = $0192;
  MM_ISITEMVALID           = $0193;

Function WinCreateMenu(hWndParent: HWND; lpmt: PVOID): HWND;

{ Owner Item Structure (Also used for listboxes) }

Type
  OWNERITEM = Record
    aWnd: HWND;
    _hps: HPS;
    fsState,
    fsAttribute,
    fsStateOld,
    fsAttributeOld: USHORT;
    rclItem: RECTL;
    idItem: SHORT; { This field contains idItem for menus, iItem for lb. }
    hItem: ULONG
  End;
  pOWNERITEM = ^OWNERITEM;

{ Menu item }

  MENUITEM = Record
    iPosition: SHORT;
    afStyle,
    afAttribute,
    id: USHORT;
    hwndSubMenu: HWND;
    hItem: ULONG
  End;
  pMENUITEM = ^MENUITEM;

Const
  MIT_END                  = -1;
  MIT_NONE                 = -1;
  MIT_MEMERROR             = -1;
  MIT_ERROR                = -1;
  MID_NONE                 = MIT_NONE;
  MID_ERROR                = -1;

{ Menu item styles & attributes }

  MIS_TEXT                 = $0001;
  MIS_BITMAP               = $0002;
  MIS_SEPARATOR            = $0004;
  MIS_OWNERDRAW            = $0008;
  MIS_SUBMENU              = $0010;
  MIS_MULTMENU             = $0020;     { multiple choice submenu     }
  MIS_SYSCOMMAND           = $0040;
  MIS_HELP                 = $0080;
  MIS_STATIC               = $0100;
  MIS_BUTTONSEPARATOR      = $0200;
  MIS_BREAK                = $0400;
  MIS_BREAKSEPARATOR       = $0800;
  MIS_GROUP                = $1000;     { multiple choice group start }
{ In multiple choice submenus a style of 'single' denotes the item is a
** radiobutton.  Absence of this style defaults the item to a checkbox.       }
  MIS_SINGLE               = $2000;

  MIA_NODISMISS            = $0020;
  MIA_FRAMED               = $1000;
  MIA_CHECKED              = $2000;
  MIA_DISABLED             = $4000;
  MIA_HILITED              = $8000;

{** Scroll Bar controls Subsection }

{ Scroll Bar styles }

  SBS_HORZ                 = 0;
  SBS_VERT                 = 1;
  SBS_THUMBSIZE            = 2;
  SBS_AUTOTRACK            = 4;

{ Scroll bar class name }


  WC_SCROLLBAR         = pChar($ffff0008);

{ Scroll Bar messages }

  SBM_SETSCROLLBAR         = $01a0;
  SBM_SETPOS               = $01a1;
  SBM_QUERYPOS             = $01a2;
  SBM_QUERYRANGE           = $01a3;
  SBM_SETTHUMBSIZE         = $01a6;

{ Scroll Bar Commands }

  SB_LINEUP                = 1;
  SB_LINEDOWN              = 2;
  SB_LINELEFT              = 1;
  SB_LINERIGHT             = 2;
  SB_PAGEUP                = 3;
  SB_PAGEDOWN              = 4;
  SB_PAGELEFT              = 3;
  SB_PAGERIGHT             = 4;
  SB_SLIDERTRACK           = 5;
  SB_SLIDERPOSITION        = 6;
  SB_ENDSCROLL             = 7;


Type
  SBCDATA = Record
    cb,
    sHilite: USHORT;      { reserved, should be set to zero }
    posFirst,
    posLast,
    posThumb,
    cVisible,
    cTotal: SHORT
  End;
  pSBCDATA = ^SBCDATA;

{** Frame Manager Common subsection }
  FRAMECDATA = Record
    cb: USHORT;
    flCreateFlags: ULONG;
    hmodResources: USHORT;
    idResources: USHORT
  End;
  pFRAMECDATA = ^FRAMECDATA;

Const
{ Frame window styles }

  FCF_TITLEBAR             = $00000001;
  FCF_SYSMENU              = $00000002;
  FCF_MENU                 = $00000004;
  FCF_SIZEBORDER           = $00000008;
  FCF_MINBUTTON            = $00000010;
  FCF_MAXBUTTON            = $00000020;
  FCF_MINMAX               = $00000030;{ minmax means BOTH buttons }
  FCF_VERTSCROLL           = $00000040;
  FCF_HORZSCROLL           = $00000080;
  FCF_DLGBORDER            = $00000100;
  FCF_BORDER               = $00000200;
  FCF_SHELLPOSITION        = $00000400;
  FCF_TASKLIST             = $00000800;
  FCF_NOBYTEALIGN          = $00001000;
  FCF_NOMOVEWITHOWNER      = $00002000;
  FCF_ICON                 = $00004000;
  FCF_ACCELTABLE           = $00008000;
  FCF_SYSMODAL             = $00010000;
  FCF_SCREENALIGN          = $00020000;
  FCF_MOUSEALIGN           = $00040000;
{ New values to enable multiple palettes.  Note that if none of the four   }
{ styles specified below are used then we default to the 'system' palette  }
  FCF_PALETTE_NORMAL       = $00080000;{ normal palette            }
  FCF_PALETTE_HELP         = $00100000;{ help palette              }
  FCF_PALETTE_POPUPODD     = $00200000;{ odd level popup palette   }
  FCF_PALETTE_POPUPEVEN    = $00400000;{ even level popup palette  }
{ FCF_ $00800000L is reserved }
  FCF_DBE_APPSTAT          = $80000000;

{ FCF_TITLEBAR | FCF_SYSMENU | FCF_MENU | FCF_SIZEBORDER | FCF_MINMAX |
   FCF_ICON | FCF_ACCELTABLE | FCF_SHELLPOSITION | FCF_TASKLIST | FCF_PALETTE_NORMAL }
  FCF_STANDARD             = $0008CC3F;


  FS_ICON                  = $00000001;
  FS_ACCELTABLE            = $00000002;
  FS_SHELLPOSITION         = $00000004;
  FS_TASKLIST              = $00000008;
  FS_NOBYTEALIGN           = $00000010;
  FS_NOMOVEWITHOWNER       = $00000020;
  FS_SYSMODAL              = $00000040;
  FS_DLGBORDER             = $00000080;
  FS_BORDER                = $00000100;
  FS_SCREENALIGN           = $00000200;
  FS_MOUSEALIGN            = $00000400;
  FS_SIZEBORDER            = $00000800;
  FS_DBE_APPSTAT           = $00008000;

{ FS_ICON | FS_ACCELTABLE | FS_SHELLPOSITION | FS_TASKLIST }
  FS_STANDARD              = $0000000F;


{ Frame Window Flags accessed via WinSet/QueryWindowUShort(QWS_FLAGS) }

  FF_FLASHWINDOW           = $0001;
  FF_ACTIVE                = $0002;
  FF_FLASHHILITE           = $0004;
  FF_OWNERHIDDEN           = $0008;
  FF_DLGDISMISSED          = $0010;
  FF_OWNERDISABLED         = $0020;
  FF_SELECTED              = $0040;
  FF_NOACTIVATESWP         = $0080;

Function WinCreateStdWindow(hwndParent: HWND; flStyle: ULONG;
                            pflCreateFlags: PULONG; pszClientClass, pszTitle: PSZ; styleClient: ULONG;
                            hmod: HMODULE; idResources: USHORT; phwndClient: PHWND): HWND;

Function WinFlashWindow(hWndFrame: HWND; fFlash: BOOL): BOOL;

Const
{ Frame window related messages }

  WM_FLASHWINDOW           = $0040;
  WM_FORMATFRAME           = $0041;
  WM_UPDATEFRAME           = $0042;
  WM_FOCUSCHANGE           = $0043;

  WM_SETBORDERSIZE         = $0044;
  WM_TRACKFRAME            = $0045;
  WM_MINMAXFRAME           = $0046;
  WM_SETICON               = $0047;
  WM_QUERYICON             = $0048;
  WM_SETACCELTABLE         = $0049;
  WM_QUERYACCELTABLE       = $004a;
  WM_TRANSLATEACCEL        = $004b;
  WM_QUERYTRACKINFO        = $004c;
  WM_QUERYBORDERSIZE       = $004d;
  WM_NEXTMENU              = $004e;
  WM_ERASEBACKGROUND       = $004f;
  WM_QUERYFRAMEINFO        = $0050;
{ Note $0051/5 are reserved }
  WM_QUERYFOCUSCHAIN       = $0051;
  WM_CALCFRAMERECT         = $0053;
  WM_WINDOWPOSCHANGED      = $0055;
  WM_QUERYFRAMECTLCOUNT    = $0059;
{ Note $005A is reserved }
  WM_QUERYHELPINFO         = $005B;
  WM_SETHELPINFO           = $005C;
  WM_ERROR                 = $005D;


{ WM_QUERYFRAMEINFO constants }

  FI_FRAME                 = $00000001;
  FI_OWNERHIDE             = $00000002;
  FI_ACTIVATEOK            = $00000004;
  FI_NOMOVEWITHOWNER       = $00000008;

{ Frame class name }
  WC_FRAME             = pChar($ffff0001);

Function WinCreateFrameControls(hwndFrame: HWND; pfcdata: PFRAMECDATA; pszTitle: PSZ): BOOL;
Function WinCalcFrameRect(hWndFrame: HWND; prcl: PRECTL; fClient: BOOL): BOOL;
Function WinGetMinPosition(aWnd: HWND; aSWP: pSWP; pptl: PPOINTL): BOOL;
Function WinGetMaxPosition(aWnd: HWND; aSWP: pSWP): BOOL;

Const
{ Frame control IDs    }

  FID_SYSMENU              = $8002;
  FID_TITLEBAR             = $8003;
  FID_MINMAX               = $8004;
  FID_MENU                 = $8005;
  FID_VERTSCROLL           = $8006;
  FID_HORZSCROLL           = $8007;
  FID_CLIENT               = $8008;
{ Note $8009 is reserved }
  FID_DBE_APPSTAT          = $8010;
  FID_DBE_KBDSTAT          = $8011;
  FID_DBE_PECIC            = $8012;
  FID_DBE_KKPOPUP          = $8013;

{ Standard WM_SYSCOMMAND command values }

  SC_SIZE                  = $8000;
  SC_MOVE                  = $8001;
  SC_MINIMIZE              = $8002;
  SC_MAXIMIZE              = $8003;
  SC_CLOSE                 = $8004;
  SC_NEXT                  = $8005;
  SC_APPMENU               = $8006;
  SC_SYSMENU               = $8007;
  SC_RESTORE               = $8008;
  SC_NEXTFRAME             = $8009;
  SC_NEXTWINDOW            = $8010;
  SC_TASKMANAGER           = $8011;
  SC_HELPKEYS              = $8012;
  SC_HELPINDEX             = $8013;
  SC_HELPEXTENDED          = $8014;
  SC_SWITCHPANELIDS        = $8015;
  SC_DBE_FIRST             = $8018;
  SC_DBE_LAST              = $801F;

{** Frame controls }

{ Title bar controls }

{ Title bar control class name }

  WC_TITLEBAR          = pChar($ffff0009);

{ Title bar control messages }

  TBM_SETHILITE            = $01e3;
  TBM_QUERYHILITE          = $01e4;
  TBM_TRACKMOVE            = $01e5;

{** Rectangle routines }

Function WinCopyRect(aAB: hAB; prclDst: PRECTL; prclSrc: PRECTL): BOOL;
Function WinSetRect(_hab: HAB; prcl: PRECTL; xLeft, yBottom, xRight, yTop: SHORT): BOOL;
Function WinIsRectEmpty(aAB: hAB; prcl: PRECTL): BOOL;
Function WinEqualRect(aAB: hAB; prcl1, prcl2: PRECTL): BOOL;
Function WinSetRectEmpty(aAB: hAB; prcl: PRECTL): BOOL;
Function WinOffsetRect(aAB: hAB; prcl: PRECTL; cx, cy: SHORT): BOOL;
Function WinInflateRect(aAB: hAB; prcl: PRECTL; cx, cy: SHORT): BOOL;
Function WinPtInRect(aAB: hAB; prcl: PRECTL; pptl: PPOINTL): BOOL;
Function WinIntersectRect(_hab: HAB; prclDst, prclSrc1, prclSrc2: PRECTL): BOOL;
Function WinUnionRect(_hab: HAB; prclDst, prclSrc1, prclSrc2: PRECTL): BOOL;
Function WinSubtractRect(_hab: HAB; prclDst, prclSrc1, prclSrc2: PRECTL): BOOL;
Function WinMakeRect(aAB: hAB; pwrc: PWRECT): BOOL;
Function WinMakePoints(aAB: hAB; pwpt: PWPOINT; cwpt: USHORT): BOOL;

{** System values }

Function WinQuerySysValue(hWndDesktop: HWND; iSysValue: SHORT): LONG;
Function WinSetSysValue(hWndDesktop: HWND; iSysValue: SHORT; lValue: LONG): BOOL;

Const
  SV_SWAPBUTTON            = 0;
  SV_DBLCLKTIME            = 1;
  SV_CXDBLCLK              = 2;
  SV_CYDBLCLK              = 3;
  SV_CXSIZEBORDER          = 4;
  SV_CYSIZEBORDER          = 5;
  SV_ALARM                 = 6;
  SV_RESERVEDFIRST1        = 7;
  SV_RESERVEDLAST1         = 8;
  SV_CURSORRATE            =  9;
  SV_FIRSTSCROLLRATE       = 10;
  SV_SCROLLRATE            = 11;
  SV_NUMBEREDLISTS         = 12;
  SV_WARNINGFREQ           = 13;
  SV_NOTEFREQ              = 14;
  SV_ERRORFREQ             = 15;
  SV_WARNINGDURATION       = 16;
  SV_NOTEDURATION          = 17;
  SV_ERRORDURATION         = 18;
  SV_RESERVEDFIRST         = 19;
  SV_RESERVEDLAST          = 19;
  SV_CXSCREEN              = 20;
  SV_CYSCREEN              = 21;
  SV_CXVSCROLL             = 22;
  SV_CYHSCROLL             = 23;
  SV_CYVSCROLLARROW        = 24;
  SV_CXHSCROLLARROW        = 25;
  SV_CXBORDER              = 26;
  SV_CYBORDER              = 27;
  SV_CXDLGFRAME            = 28;
  SV_CYDLGFRAME            = 29;
  SV_CYTITLEBAR            = 30;
  SV_CYVSLIDER             = 31;
  SV_CXHSLIDER             = 32;
  SV_CXMINMAXBUTTON        = 33;
  SV_CYMINMAXBUTTON        = 34;
  SV_CYMENU                = 35;
  SV_CXFULLSCREEN          = 36;
  SV_CYFULLSCREEN          = 37;
  SV_CXICON                = 38;
  SV_CYICON                = 39;
  SV_CXPOINTER             = 40;
  SV_CYPOINTER             = 41;
  SV_DEBUG                 = 42;
  SV_CMOUSEBUTTONS         = 43;
  SV_POINTERLEVEL          = 44;
  SV_CURSORLEVEL           = 45;
  SV_TRACKRECTLEVEL        = 46;
  SV_CTIMERS               = 47;
  SV_MOUSEPRESENT          = 48;
  SV_CXBYTEALIGN           = 49;
  SV_CYBYTEALIGN           = 50;

{ The following value enables any greater value to be set by WinSetSysVlaue. }
{ Values of 51-55 are spare for extra non-settable system values             }
{ This is to enable the setting of SV_EXTRAKEYBEEP by applications.          }

  SV_NOTRESERVED           = 56;
  SV_EXTRAKEYBEEP          = 57;

{ The following system value controls whether PM controls the keyboard      }
{ lights for light key keystrokes (else applications will)                  }
  SV_SETLIGHTS             = 58;
  SV_INSERTMODE            = 59;


  SV_MENUROLLDOWNDELAY     = 64;
  SV_MENUROLLUPDELAY       = 65;
  SV_ALTMNEMONIC           = 66;
  SV_TASKLISTMOUSEACCESS   = 67;
{ The following is the total number of system values }
  SV_CSYSVALUES            = 68;

  SV_CPOINTERBUTTONS       = 69;
  SV_CXALIGN               = 70;
  SV_CYALIGN               = 71;
  SV_MNEMONICSENABLED      = 72;

Type
{ Presentation parameter structures. }
  PARAM = Record
    id,
    cb: ULONG;
    ab: Array[0..0] Of BYTE
  End;
  pPARAM = ^PARAM;
  npPARAM = ^PARAM; {-CANT-}

  PRESPARAMS = Record
    cb: ULONG;
    aparam: Array[0..0] Of PARAM
  End;
  pPRESPARAMS = ^PRESPARAMS;
  npPRESPARAMS = ^PRESPARAMS; {-CANT-}

{
 * Presentation parameter APIs
 }
Function WinSetPresParam(aWnd: HWND; id, cbParam: ULONG; pbParam: PVOID): BOOL;
Function WinQueryPresParam(aWnd: HWND; id1, id2: ULONG; pulId: PULONG;
                           cbBuf: ULONG; pbBuf: PVOID; fs: USHORT): ULONG;
Function WinRemovePresParam(aWnd: HWND; id: ULONG): BOOL;

{ Presentation parameter types. }

Const
  PP_FOREGROUNDCOLOR                =  1;
  PP_FOREGROUNDCOLORINDEX           =  2;
  PP_BACKGROUNDCOLOR                =  3;
  PP_BACKGROUNDCOLORINDEX           =  4;
  PP_HILITEFOREGROUNDCOLOR          =  5;
  PP_HILITEFOREGROUNDCOLORINDEX     =  6;
  PP_HILITEBACKGROUNDCOLOR          =  7;
  PP_HILITEBACKGROUNDCOLORINDEX     =  8;
  PP_DISABLEDFOREGROUNDCOLOR        =  9;
  PP_DISABLEDFOREGROUNDCOLORINDEX   = 10;
  PP_DISABLEDBACKGROUNDCOLOR        = 11;
  PP_DISABLEDBACKGROUNDCOLORINDEX   = 12;
  PP_BORDERCOLOR                    = 13;
  PP_BORDERCOLORINDEX               = 14;
  PP_FONTNAMESIZE                   = 15;
  PP_FONTHANDLE                     = 16;

{
 * Flags for WinQueryPresParams()
 }
  QPF_NOINHERIT          = $0001; { Don't inherit                      }
  QPF_ID1COLORINDEX      = $0002; { Convert id1 color index into RGB   }
  QPF_ID2COLORINDEX      = $0004; { Convert id2 color index into RGB   }
  QPF_PURERGBCOLOR       = $0008; { Return pure RGB colors             }
  QPF_VALIDFLAGS         = $000F; { Valid WinQueryPresParams() flags.  }

{** System color functions }

Function WinQuerySysColor(hWndDesktop: HWND; clr, lReserved: LONG): LONG;
Function WinSetSysColors(hwndDesktop: HWND; flOptions, flFormat: ULONG;
                         clrFirst: LONG; cclr: ULONG; pclr: PLONG): BOOL;
Const
  SYSCLR_BUTTONLIGHT             = -41;
  SYSCLR_BUTTONMIDDLE            = -40;
  SYSCLR_BUTTONDARK              = -39;
  SYSCLR_BUTTONDEFAULT           = -38;
  SYSCLR_TITLEBOTTOM             = -37;
  SYSCLR_SHADOW                  = -36;
  SYSCLR_ICONTEXT                = -35;
  SYSCLR_DIALOGBACKGROUND        = -34;
  SYSCLR_HILITEFOREGROUND        = -33;
  SYSCLR_HILITEBACKGROUND        = -32;
  SYSCLR_INACTIVETITLETEXTBGND   = -31;
  SYSCLR_ACTIVETITLETEXTBGND     = -30;
  SYSCLR_INACTIVETITLETEXT       = -29;
  SYSCLR_ACTIVETITLETEXT         = -28;
  SYSCLR_OUTPUTTEXT              = -27;
  SYSCLR_WINDOWSTATICTEXT        = -26;
  SYSCLR_SCROLLBAR               = -25;
  SYSCLR_BACKGROUND              = -24;
  SYSCLR_ACTIVETITLE             = -23;
  SYSCLR_INACTIVETITLE           = -22;
  SYSCLR_MENU                    = -21;
  SYSCLR_WINDOW                  = -20;
  SYSCLR_WINDOWFRAME             = -19;
  SYSCLR_MENUTEXT                = -18;
  SYSCLR_WINDOWTEXT              = -17;
  SYSCLR_TITLETEXT               = -16;
  SYSCLR_ACTIVEBORDER            = -15;
  SYSCLR_INACTIVEBORDER          = -14;
  SYSCLR_APPWORKSPACE            = -13;
  SYSCLR_HELPBACKGROUND          = -12;
  SYSCLR_HELPTEXT                = -11;
  SYSCLR_HELPHILITE              = -10;
  SYSCLR_CSYSCOLORS              =  32;

{*** Timer manager }

Function WinStartTimer(_hab: HAB; aWnd: HWND; idTimer, dtTimeout: USHORT): USHORT;
Function WinStopTimer(aAB: hAB; aWnd: HWND; idTimer: USHORT): BOOL;
Function WinGetCurrentTime(aAB: hAB): ULONG;

Const
  TID_CURSOR        = $ffff;  { Reserved cursor timer ID              }
  TID_SCROLL        = $fffe;  { Reserved scrolling timer ID           }
  TID_FLASHWINDOW   = $fffd;  { Reserved for window flashing timer ID }
  TID_USERMAX       = $7fff;  { Maximum user timer ID                 }

{*** Accelerator functions }

{ ACCEL fs bits
 *
 * NOTE: the first six AF_ code bits have the same value
 * as their KC_ counterparts
 }
  AF_CHAR                  = $0001;
  AF_VIRTUALKEY            = $0002;
  AF_SCANCODE              = $0004;
  AF_SHIFT                 = $0008;
  AF_CONTROL               = $0010;
  AF_ALT                   = $0020;
  AF_LONEKEY               = $0040;
  AF_SYSCOMMAND            = $0100;
  AF_HELP                  = $0200;

Type
  HACCEL = LHANDLE; { haccel }
  ACCEL = Record
    fs,
    key,
    cmd: USHORT
  End;
  pACCEL = ^ACCEL;

  ACCELTABLE = Record
    cAccel,
    codepage: USHORT;
    aaccel: Array[0..0] Of ACCEL
  End;
  pACCELTABLE = ^ACCELTABLE;

Function WinLoadAccelTable(aAB: hAB; hmod: HMODULE; idAccelTable: USHORT): HACCEL;
Function WinCreateAccelTable(aAB: hAB; _pAccelTable: PACCELTABLE): HACCEL;
Function WinDestroyAccelTable(_haccel: HACCEL): BOOL;
Function WinCopyAccelTable(_haccel: HACCEL; _pAccelTable: PACCELTABLE;
                           cbCopyMax: USHORT): USHORT;
Function WinTranslateAccel(_hab: HAB; aWnd: HWND; _haccel: HACCEL;
                           _pqmsg: PQMSG): BOOL;
Function WinSetAccelTable(aAB: hAB; _haccel: HACCEL; hWndFrame: HWND): BOOL;
Function WinQueryAccelTable(aAB: hAB; hWndFrame: HWND): HACCEL;

{*** Extended Attribute Flags (Association Table) }

Const
  EAF_DEFAULTOWNER         = $0001;
  EAF_UNCHANGEABLE         = $0002;
  EAF_REUSEICON            = $0004;

{** WinTrackRect() information }

{ WinTrackRect() tracking information structure }

Type
  TRACKINFO = Record
    cxBorder,
    cyBorder,
    cxGrid,
    cyGrid,
    cxKeyboard,
    cyKeyboard: SHORT;
    rclTrack,
    rclBoundary: RECTL;
    ptlMinTrackSize,
    ptlMaxTrackSize: POINTL;
    fs: USHORT
  End;
  pTRACKINFO = ^TRACKINFO;

Function WinTrackRect(aWnd: HWND; aPS: HPS; pti: PTRACKINFO): BOOL;
Function WinShowTrackRect(aWnd: HWND; fShow: BOOL): BOOL;

Const
{ WinTrackRect() flags }
  TF_LEFT                  = $0001;
  TF_TOP                   = $0002;
  TF_RIGHT                 = $0004;
  TF_BOTTOM                = $0008;
{ TF_MOVE = TF_LEFT | TF_TOP | TF_RIGHT | TF_BOTTOM }
  TF_MOVE                  = $000F;

  TF_SETPOINTERPOS         = $0010;
  TF_GRID                  = $0020;
  TF_STANDARD              = $0040;
  TF_ALLINBOUNDARY         = $0080;
  TF_VALIDATETRACKRECT     = $0100;
  TF_PARTINBOUNDARY        = $0200;

{*** Clipboard Manager }

{ Clipboard messages }

  WM_RENDERFMT             = $0060;
  WM_RENDERALLFMTS         = $0061;
  WM_DESTROYCLIPBOARD      = $0062;
  WM_PAINTCLIPBOARD        = $0063;
  WM_SIZECLIPBOARD         = $0064;
  WM_HSCROLLCLIPBOARD      = $0065;
  WM_VSCROLLCLIPBOARD      = $0066;
  WM_DRAWCLIPBOARD         = $0067;

{ Standard Clipboard formats }

  CF_TEXT                  = 1;
  CF_BITMAP                = 2;
  CF_DSPTEXT               = 3;
  CF_DSPBITMAP             = 4;
  CF_METAFILE              = 5;
  CF_DSPMETAFILE           = 6;

Function WinSetClipbrdOwner(aAB: hAB; aWnd: HWND): BOOL;
Function WinSetClipbrdData(aAB: hAB; ulData: ULONG; fmt, rgfFmtInfo: USHORT): BOOL;
Function WinQueryClipbrdData(aAB: hAB; fmt: USHORT): ULONG;
Function WinQueryClipbrdFmtInfo(_hab: HAB; fmt: USHORT; prgfFmtInfo: PUSHORT): BOOL;
Function WinSetClipbrdViewer(aAB: hAB; WndNewClipViewer: HWND): BOOL;

Const
{ WinSetClipbrdData() flags }

  CFI_OWNERFREE            = $0001;
  CFI_OWNERDISPLAY         = $0002;
  CFI_SELECTOR             = $0100;
  CFI_HANDLE               = $0200;

Function WinEnumClipbrdFmts(aAB: hAB; fmt: USHORT): USHORT;
Function WinEmptyClipbrd(aAB: hAB): BOOL;
Function WinOpenClipbrd(aAB: hAB): BOOL;
Function WinCloseClipbrd(aAB: hAB): BOOL;
Function WinQueryClipbrdOwner(aAB: hAB; fLock: BOOL): HWND;
Function WinQueryClipbrdViewer(aAB: hAB; fLock: BOOL): HWND;

{*** Cursor manager common subsection }

Function WinDestroyCursor(aWnd: HWND): BOOL;
Function WinShowCursor(aWnd: HWND; fShow: BOOL): BOOL;
Function WinCreateCursor(aWnd: HWND; x, y, cx, cy: SHORT; fs: USHORT;
                         prclClip: PRECTL): BOOL;

Const
{ WinCreateCursor() flags }

  CURSOR_SOLID             = $0000;
  CURSOR_HALFTONE          = $0001;
  CURSOR_FRAME             = $0002;
  CURSOR_FLASH             = $0004;
  CURSOR_SETPOS            = $8000;

Type
  CURSORINFO = Record
    aWnd: HWND;
    x,
    y,
    cx,
    cy: SHORT;
    fs: USHORT;
    rclClip: RECTL
  End;
  pCURSORINFO = ^CURSORINFO;

Function WinQueryCursorInfo(hWndDesktop: HWND; _pCursorInfo: PCURSORINFO): BOOL;

Type
  HPOINTER = LHANDLE;

{*** Pointer manager }

Function WinSetPointer(hWndDesktop: HWND; hptrNew: HPOINTER): BOOL;
Function WinShowPointer(hWndDesktop: HWND; fShow: BOOL): BOOL;
Function WinQuerySysPointer(hWndDesktop: HWND; iptr: SHORT; fLoad: BOOL): HPOINTER;


{ System pointers (NOTE: these are 1-based) }
Const
  SPTR_ARROW               =  1;
  SPTR_TEXT                =  2;
  SPTR_WAIT                =  3;
  SPTR_SIZE                =  4;
  SPTR_MOVE                =  5;
  SPTR_SIZENWSE            =  6;
  SPTR_SIZENESW            =  7;
  SPTR_SIZEWE              =  8;
  SPTR_SIZENS              =  9;
  SPTR_APPICON             = 10;
  SPTR_ICONINFORMATION     = 11;
  SPTR_ICONQUESTION        = 12;
  SPTR_ICONERROR           = 13;
  SPTR_ICONWARNING         = 14;
  SPTR_ILLEGAL             = 18;
  SPTR_FILE                = 19;
  SPTR_FOLDER              = 20;
  SPTR_MULTFILE            = 21;
  SPTR_PROGRAM             = 22;
  SPTR_PENFIRST            = 23;
  SPTR_PENLAST             = 39;
  SPTR_CPTR                = 39; {total # of system pointers}

{ backward compatibility }
  SPTR_HANDICON       = SPTR_ICONERROR;
  SPTR_QUESICON       = SPTR_ICONQUESTION;
  SPTR_BANGICON       = SPTR_ICONWARNING;
  SPTR_NOTEICON       = SPTR_ICONINFORMATION;

Function WinLoadPointer(hWndDesktop: HWND; hmod: HMODULE; idres: USHORT): HPOINTER;
Function WinDestroyPointer(hptr: HPOINTER): BOOL;
Function WinCreatePointer(hwndDesktop: HWND; hbmPointer: HBITMAP;
                          fPointer: BOOL; xHotspot, yHotspot: SHORT): HPOINTER;

Function WinQueryPointer(hWndDesktop: HWND): HPOINTER;
Function WinSetPointerPos(hWndDesktop: HWND; x, y: SHORT): BOOL;
Function WinQueryPointerPos(hWndDesktop: HWND; pptl: PPOINTL): BOOL;

Type
  POINTERINFO = Record
    fPointer: {$IfDef Use13} SHORT {$Else} ULONG {$EndIf};
    xHotspot,
    yHotspot: {$IfDef Use13} SHORT {$Else} LONG {$EndIf};
    hbmPointer,
    hbmColor: HBITMAP;
  {$IfNDef Use13}
    hbmMiniPointer,
    hbmMiniColor: HBITMAP
  {$EndIf}
  End;
  pPOINTERINFO = ^POINTERINFO;

Function WinCreatePointerIndirect(hWndDesktop: HWND; pptri: PPOINTERINFO): HPOINTER;
Function WinQueryPointerInfo(hptr: HPOINTER; _pPointerInfo: PPOINTERINFO): BOOL;
Function WinDrawPointer(aPS: HPS; x, y: SHORT; hptr: HPOINTER; fs: USHORT): BOOL;

Const
{ WinDrawPointer() constants }
  DP_NORMAL                = $0000;
  DP_HALFTONED             = $0001;
  DP_INVERTED              = $0002;

Function WinGetSysBitmap(hWndDesktop: HWND; ibm: USHORT): HBITMAP;

Const
{ System bitmaps (NOTE: these are 1-based) }
  SBMP_OLD_SYSMENU         =  1;
  SBMP_OLD_SBUPARROW       =  2;
  SBMP_OLD_SBDNARROW       =  3;
  SBMP_OLD_SBRGARROW       =  4;
  SBMP_OLD_SBLFARROW       =  5;
  SBMP_MENUCHECK           =  6;
  SBMP_CHECKBOXES          =  7;
  SBMP_BTNCORNERS          =  8;
  SBMP_OLD_MINBUTTON       =  9;
  SBMP_OLD_MAXBUTTON       = 10;
  SBMP_OLD_RESTOREBUTTON   = 11;
  SBMP_OLD_CHILDSYSMENU    = 12;
  SBMP_DRIVE               = 15;
  SBMP_FILE                = 16;
  SBMP_FOLDER              = 17;
  SBMP_TREEPLUS            = 18;
  SBMP_TREEMINUS           = 19;
  SBMP_PROGRAM             = 22;
  SBMP_MENUATTACHED        = 23;
  SBMP_SIZEBOX             = 24;
  SBMP_SYSMENU             = 25;
  SBMP_MINBUTTON           = 26;
  SBMP_MAXBUTTON           = 27;
  SBMP_RESTOREBUTTON       = 28;
  SBMP_CHILDSYSMENU        = 29;
  SBMP_SYSMENUDEP          = 30;
  SBMP_MINBUTTONDEP        = 31;
  SBMP_MAXBUTTONDEP        = 32;
  SBMP_RESTOREBUTTONDEP    = 33;
  SBMP_CHILDSYSMENUDEP     = 34;
  SBMP_SBUPARROW           = 35;
  SBMP_SBDNARROW           = 36;
  SBMP_SBLFARROW           = 37;
  SBMP_SBRGARROW           = 38;
  SBMP_SBUPARROWDEP        = 39;
  SBMP_SBDNARROWDEP        = 40;
  SBMP_SBLFARROWDEP        = 41;
  SBMP_SBRGARROWDEP        = 42;
  SBMP_SBUPARROWDIS        = 43;
  SBMP_SBDNARROWDIS        = 44;
  SBMP_SBLFARROWDIS        = 45;
  SBMP_SBRGARROWDIS        = 46;
  SBMP_COMBODOWN           = 47;

{*** Hook manager }

Function WinSetHook(_hab: HAB; _hmq: HMQ; iHook: SHORT; pfnHook: PFN;
                    hmod: HMODULE): BOOL;
Function WinReleaseHook(_hab: HAB; _hmq: HMQ; iHook: SHORT; pfnHook: PFN;
                        hmod: HMODULE): BOOL;
Function WinCallMsgFilter(aAB: hAB; _pqmsg: PQMSG; msgf: USHORT): BOOL;


Const
{ Hook codes }

  HK_SENDMSG               = 0;
    { VOID EXPENTRY SendMsgHook(HAB hab,               ** installer's hab      **
                                 PSMHSTRUCT psmh,       ** p send msg struct    **
                                 BOOL fInterTask);      ** between threads      }
  HK_INPUT                 = 1;
    { BOOL EXPENTRY InputHook(HAB hab,                 ** installer's hab      **
                               PQMSG pQmsg,             ** p qmsg               **
                               USHORT fs);              ** remove/noremove      }
  HK_MSGFILTER             = 2;
    { BOOL EXPENTRY MsgFilterHook(HAB hab,             ** installer's hab      **
                                   PQMSG pQmsg,         ** p qmsg               **
                                   USHORT msgf);        ** filter flag          }
  HK_JOURNALRECORD         = 3;
    { VOID EXPENTRY JournalRecordHook(HAB hab,         ** installer's hab      **
                                       PQMSG pQmsg);    ** p qmsg               }
  HK_JOURNALPLAYBACK       = 4;
    { ULONG EXPENTRY JournalPlaybackHook(HAB hab,      **installer's hab       **
                                          BOOL fSkip,   ** skip messages        **
                                          PQMSG pQmsg); ** p qmsg               }
  HK_HELP                  = 5;
    { BOOL EXPENTRY HelpHook(HAB hab,                  ** installer's hab      **
                              USHORT usMode,            ** mode                 **
                              USHORT idTopic,           ** main topic           **
                              USHORT idSubTopic,        ** sub topic            **
                              PRECTL prcPosition);      ** associated position  }

  HK_LOADER                = 6;
    { BOOL EXPENTRY LoaderHook(HAB hab,                ** installer's hab      **
                                SHORT idContext,        ** who called hook      **
                                PSZ pszLibname,         ** lib name string      **
                                PHLIB hlib,             ** p to lib handle      **
                                PSZ pszProcname,        ** procedure name       **
                                PFNWP wndProc);         ** window procedure     }
  HK_REGISTERUSERMSG       = 7;
    { BOOL EXPENTRY RegisterUserHook(HAB hab,          ** installer's hab      **
                                    ULONG cUshort,      ** entries in arRMP     **
                                    PUSHORT arRMP,      ** RMP array            **
                                    PBOOL fRegistered); ** msg parms already reg}
  HK_MSGCONTROL            = 8;
    { BOOL EXPENTRY MsgControlHook(HAB hab,            ** installer's hab      **
                                    SHORT idContext,    ** who called hook      **
                                    HWND hwnd,          ** SEI window handle    **
                                    PSZ pszClassname,   ** window class name    **
                                    USHORT usMsgclass,  ** interested msg class **
                                    SHORT idControl,    ** SMI_*                **
                                    PBOOL fSuccess);    ** mode already set     }
  HK_PLIST_ENTRY           = 9;
    { BOOL EXPENTRY ProgramListEntryHook(HAB hab,      ** installer's hab      **
                       PPRFHOOKPARMS pProfileHookParams,** data                 **
                       PBOOL fNoExecute);               ** cease hook processing}
  HK_PLIST_EXIT            = 10;
    { BOOL EXPENTRY ProgramListExitHook(HAB hab,       ** installer's hab      **
                PPRFHOOKPARMS pProfileHookParams);      ** data                 }
  HK_FINDWORD              = 11;
    { BOOL EXPENTRY FindWordHook(usCodepage,           ** code page to use     **
                                  PSZ pszText,          ** text to break        **
                                  ULONG cb,             ** maximum text size    **
                                  ULONG ich,            ** break 'near' here    **
                                  PULONG pichStart,     ** where break began    **
                                  PULONG pichEnd,       ** where break ended    **
                                  PULONG pichNext);     ** where next word begin}
  HK_CODEPAGECHANGED       = 12;
    { VOID EXPENTRY CodePageChangedHook(HMQ hmq,       ** msg q handle         **
                                  USHORT usOldCodepage, ** old code page        **
                                  USHORT usNewCodepage);** new code page        }

  HMQ_CURRENT        = HMQ(1);

{ WH_MSGFILTER context codes }

  MSGF_DIALOGBOX          = 1;
  MSGF_MESSAGEBOX         = 2;
  MSGF_TRACK              = 8;

{ HK_HELP Help modes }

  HLPM_FRAME             = -1;
  HLPM_WINDOW            = -2;
  HLPM_MENU              = -3;

Type
{ HK_SENDMSG structure }

  SMHSTRUCT = Record
    mp2,
    mp1: MPARAM;
    msg: USHORT;
    aWnd: HWND
  End;
  pSMHSTRUCT = ^SMHSTRUCT;

Const
{HK_LOADER context codes }

  LHK_DELETEPROC           = 1;
  LHK_DELETELIB            = 2;
  LHK_LOADPROC             = 3;
  LHK_LOADLIB              = 4;

{HK_MSGCONTROL context codes }

  MCHK_MSGINTEREST         = 1;
  MCHK_CLASSMSGINTEREST    = 2;
  MCHK_SYNCHRONISATION     = 3;
  MCHK_MSGMODE             = 4;

{HK_REGISTERUSERMSG conext codes }

  RUMHK_DATATYPE           = 1;
  RUMHK_MSG                = 2;

{ Include Shell API }
Function WinQueryCp(_hmq: HMQ): USHORT;
Function WinSetCp(_hmq: HMQ; idCodePage: USHORT): BOOL;
Function WinQueryCpList(aAB: hAB; ccpMax: USHORT; prgcp: PUSHORT): USHORT;
Function WinCpTranslateString(_hab: HAB; cpSrc: USHORT; pszSrc: PSZ;
                              cpDst, cchDestMax: USHORT; pchDest: PSZ): BOOL;
Function WinCpTranslateChar(_hab: HAB; cpSrc: USHORT; chSrc: UCHAR;
                            cpDst: USHORT): UCHAR;
Function WinUpper(aAB: hAB; idcp, idcc: USHORT; _psz: PSZ): USHORT;
Function WinUpperChar(aAB: hAB; idcp, idcc: USHORT; c: USHORT): USHORT;
Function WinNextChar(aAB: hAB; idcp, idcc: USHORT; _psz: PSZ): PSZ;
Function WinPrevChar(_hab: HAB; idcp, idcc: USHORT; pszStart, _psz: PSZ): PSZ;
Function WinCompareStrings(_hab: HAB; idcp, idcc: USHORT; psz1, psz2: PSZ;
                           reserved: USHORT): USHORT;
Const
  WCS_ERROR                = 0;
  WCS_EQ                   = 1;
  WCS_LT                   = 2;
  WCS_GT                   = 3;

{ Heap Manager Interface declarations }

Type HHEAP = LHANDLE;

Function WinCreateHeap(
                       selHeapBase, cbHeap, cbGrow, chMinDed, cbMaxDed, fOptions: USHORT): HHEAP;
Function WinDestroyHeap(_hHeap: HHEAP): HHEAP;
Function WinAvailMem(_hHeap: HHEAP; fCompact: BOOL; cbMinFree: USHORT): USHORT;
Function WinAllocMem(_hHeap: HHEAP; cb: USHORT): NPBYTE;
Function WinReallocMem(_hHeap: HHEAP; npMem: NPBYTE; cbOld, cbNew: USHORT): NPBYTE;
Function WinFreeMem(_hHeap: HHEAP; npMem: NPBYTE; cbMem: USHORT): NPBYTE;
Function WinLockHeap(_hHeap: HHEAP): PVOID;

Const
  HM_MOVEABLE              = $0001;     { Parameters to WinCreateHeap }
  HM_VALIDSIZE             = $0002;

{** Atom Manager Interface declarations }

Type
  HATOMTBL = LHANDLE;
  ATOM = USHORT;

Function WinQuerySystemAtomTable: HATOMTBL;
Function WinCreateAtomTable(cbInitial, cBuckets: USHORT): HATOMTBL;
Function WinDestroyAtomTable(_hAtomTbl: HATOMTBL): HATOMTBL;
Function WinAddAtom(_hAtomTbl: HATOMTBL; pszAtomName: PSZ): ATOM;
Function WinFindAtom(_hAtomTbl: HATOMTBL; pszAtomName: PSZ): ATOM;
Function WinDeleteAtom(_hAtomTbl: HATOMTBL; _atom: ATOM): ATOM;
Function WinQueryAtomUsage(_hAtomTbl: HATOMTBL; _atom: ATOM): USHORT;
Function WinQueryAtomLength(_hAtomTbl: HATOMTBL; _atom: ATOM): USHORT;
Function WinQueryAtomName(_hAtomTbl: HATOMTBL; _atom: ATOM; pchBuffer: PSZ;
                          cchBufferMax: USHORT): USHORT;

Function MakeIntAtom(a: Word): pChar;
  Inline(PopAx/ $BA/$FFFF {Mov Dx,$FFFF});

{** Catch/Throw Interface declarations }
Type
  CATCHBUF = Record
    reserved: Array[0..3] Of ULONG
  End;
  pCATCHBUF = ^CATCHBUF;

Function WinCatch(_pcatchbuf: PCATCHBUF): SHORT;
Procedure WinThrow(_pcatchbuf: PCATCHBUF; nThrowBack: SHORT);

Const
{ Error codes for debugging support
  $1001 - $1021, $1034, $1036 - $1060 are reserved}

  WINDBGaWnd_NOT_DESTROYED          = $1022;
  WINDBG_HPTR_NOT_DESTROYED         = $1023;
  WINDBG_HACCEL_NOT_DESTROYED       = $1024;
  WINDBG_HENUM_NOT_DESTROYED        = $1025;
  WINDBG_VISRGN_SEM_BUSY            = $1026;
  WINDBG_USER_SEM_BUSY              = $1027;
  WINDBG_DC_CACHE_BUSY              = $1028;
  WINDBG_HOOK_STILL_INSTALLED       = $1029;
  WINDBG_WINDOW_STILL_LOCKED        = $102a;
  WINDBG_UPDATEPS_ASSERTION_FAIL    = $102b;
  WINDBG_SENDMSG_WITHIN_USER_SEM    = $102c;
  WINDBG_USER_SEM_NOT_ENTERED       = $102d;
  WINDBG_PROC_NOT_EXPORTED          = $102e;
  WINDBG_BAD_SENDMSGaWnd           = $102f;
  WINDBG_ABNORMAL_EXIT              = $1030;
  WINDBG_INTERNAL_REVISION          = $1031;
  WINDBG_INITSYSTEM_FAILED          = $1032;
  WINDBG_HATOMTBL_NOT_DESTROYED     = $1033;
  WINDBG_WINDOW_UNLOCK_WAIT         = $1035;

{ Get/Set Error Information Interface declarations }

Type
  ERRINFO = Record
    cbFixedErrInfo: USHORT;
    idError: ERRORID;
    cDetailLevel,
    offaoffszMsg,
    offBinaryData: USHORT
  End;
  pERRINFO = ^ERRINFO;

Function WinGetLastError(aAB: hAB): ERRORID;
Function WinGetErrorInfo(aAB: hAB): PERRINFO;
Function WinFreeErrorInfo(_perrinfo: PERRINFO): BOOL;

{ include SetErrorInfo }
{.....$I pmsei.h}

{ Dynamic Data Exchange (DDE) Structure Declaration }

Type
  DDEINIT = Record
    cb: USHORT;
    pszAppName,
    pszTopic: pSZ
  End;
  pDDEINIT = ^DDEINIT;

  DDESTRUCT = Record
    cbData: ULONG;
    fsStatus,
    fsFormat,
    offszItemName,
    offabData: USHORT
  End;
  pDDESTRUCT = ^DDESTRUCT;

Const
{ DDE constants for wStatus field }
  DDE_FACK                 = $0001;
  DDE_FBUSY                = $0002;
  DDE_FNODATA              = $0004;
  DDE_FACKREQ              = $0008;
  DDE_FRESPONSE            = $0010;
  DDE_NOTPROCESSED         = $0020;
  DDE_FRESERVED            = $00C0;
  DDE_FAPPSTATUS           = $FF00;

{ DDE public formats }

  DDEFMT_TEXT              = $0001;

{ Dynamic Data Exchange (DDE) Routines }

Function WinDdeInitiate(hwndClient: HWND; pszAppName, pszTopicName: PSZ): BOOL;
Function WinDdeRespond(hwndClient, hwndServer: HWND;
                       pszAppName, pszTopicName: PSZ): MRESULT;
Function WinDdePostMsg(hwndTo, hwndFrom: HWND; wm: USHORT; pddeSt: PDDESTRUCT;
                       fRetry: BOOL): BOOL;

Const
{ Dynamic Data Exchange (DDE) Messages }

  WM_DDE_FIRST             = $00A0;
  WM_DDE_INITIATE          = $00A0;
  WM_DDE_REQUEST           = $00A1;
  WM_DDE_ACK               = $00A2;
  WM_DDE_DATA              = $00A3;
  WM_DDE_ADVISE            = $00A4;
  WM_DDE_UNADVISE          = $00A5;
  WM_DDE_POKE              = $00A6;
  WM_DDE_EXECUTE           = $00A7;
  WM_DDE_TERMINATE         = $00A8;
  WM_DDE_INITIATEACK       = $00A9;
  WM_DDE_LAST              = $00AF;

{ DDE helper macros }

  Function DDES_pszItemName(pddes: pDDESTRUCT): pSZ;
    Inline(PopDx/PopAx/
           $8E/$C2     {Mov Es,Dx} /$89/$C7 {Mov Di,Ax}/
           $83/$C7/8   {Add Di,4+2+2}/
           $26/$03/$05 {Add Ax,Es:[Di]});

  Function DDES_PABDATA (pddes: pDDESTRUCT): pBYTE;
    Inline(PopDx/PopAx/
           $8E/$C2     {Mov Es,Dx} /$89/$C7 {Mov Di,Ax}/
           $83/$C7/10  {Add Di,4+2+2+2}/
           $26/$03/$05 {Add Ax,Es:[Di]});

  Function SelTopDDES (Sel: Word): pDDESTRUCT;
    Inline(PopDx/ $31/$C0 {Xor Ax,Ax});
  Function pDDEStoSel(pddes: pDDESTRUCT): Word;
    Inline(PopDx/PopAx);
  Function pDDEItoSel(pddes: pDDEINIT): Word;
    Inline(PopDx/PopAx);

Const
  WM_QUERYCONVERTPOS       = $00b0;

{ Return values for WM_QUERYCONVERTPOS }
  QCP_CONVERT              = $0001;
  QCP_NOCONVERT            = $0000;

{Load/Delete Library/Procedure }

Type
  HLIB =  HMODULE;
  pHLIB = pHMODULE;

Function WinDeleteProcedure(aAB: hAB; wndproc: PFNWP): BOOL;
Function WinDeleteLibrary(aAB: hAB; libhandle: HLIB): BOOL;
Function WinLoadProcedure(aAB: hAB; libhandle: HLIB; procname: PSZ): PFNWP;
Function WinLoadLibrary(aAB: hAB; libname: PSZ): HLIB;

Const
  STR_DLLNAME              = 'keyremap';
  WM_DBCSFIRST             = $00b0;
  WM_DBCSLAST              = $00cf;
  WC_APPSTAT               = pChar($ffff0010);
  WC_KBDSTAT               = pChar($ffff0011);
  WC_PECIC                 = pChar($ffff0012);
  WC_DBE_KKPOPUP           = pChar($ffff0013);

Implementation

Function WinRegisterClass;               External 'PMWIN' Index   3;
Function WinDefWindowProc;               External 'PMWIN' Index 178;
Function WinDestroyWindow;               External 'PMWIN' Index   7;
Function WinShowWindow;                  External 'PMWIN' Index  13;
Function WinQueryWindowRect;             External 'PMWIN' Index  26;
Function WinGetPS;                       External 'PMWIN' Index  43;
Function WinReleasePS;                   External 'PMWIN' Index  44;
Function WinEndPaint;                    External 'PMWIN' Index  46;
Function WinGetClipPS;                   External 'PMWIN' Index 279;
Function WinIsWindowShowing;             External 'PMWIN' Index 614;
Function WinBeginPaint;                  External 'PMWIN' Index  45;
Function WinOpenWindowDC;                External 'PMWIN' Index  41;
Function WinScrollWindow;                External 'PMWIN' Index 153;
Function WinFillRect;                    External 'PMWIN' Index 173;
Function WinQueryVersion;                External 'PMWIN' Index 250;
Function WinInitialize;                  External 'PMWIN' Index 246;
Function WinTerminate;                   External 'PMWIN' Index 247;
Function WinQueryAnchorBlock;            External 'PMWIN' Index 609;
Function WinCreateWindow;                External 'PMWIN' Index   6;
Function WinEnableWindow;                External 'PMWIN' Index  11;
Function WinIsWindowEnabled;             External 'PMWIN' Index  12;
Function WinEnableWindowUpdate;          External 'PMWIN' Index  14;
Function WinIsWindowVisible;             External 'PMWIN' Index  15;
Function WinQueryWindowText;             External 'PMWIN' Index  17;
Function WinSetWindowText;               External 'PMWIN' Index  16;
Function WinQueryWindowTextLength;       External 'PMWIN' Index  18;
Function WinWindowFromID;                External 'PMWIN' Index  19;
Function WinIsWindow;                    External 'PMWIN' Index  21;
Function WinQueryWindow;                 External 'PMWIN' Index  25;
Function WinMultWindowFromIDs;           External 'PMWIN' Index  20;
Function WinSetParent;                   External 'PMWIN' Index  23;
Function WinIsChild;                     External 'PMWIN' Index  22;
Function WinSetOwner;                    External 'PMWIN' Index  24;
Function WinQueryWindowProcess;          External 'PMWIN' Index  27;
Function WinQueryObjectWindow;           External 'PMWIN' Index   2;
Function WinQueryDesktopWindow;          External 'PMWIN' Index   1;
Function WinSetWindowPos;                External 'PMWIN' Index   8;
Function WinQueryWindowPos;              External 'PMWIN' Index  10;
Function WinSetMultWindowPos;            External 'PMWIN' Index   9;
Function WinUpdateWindow;                External 'PMWIN' Index  53;
Function WinInvalidateRect;              External 'PMWIN' Index  47;
Function WinInvalidateRegion;            External 'PMWIN' Index  48;
Function WinInvertRect;                  External 'PMWIN' Index 172;
Function WinDrawBitmap;                  External 'PMWIN' Index 268;
Function WinDrawText;                    External 'PMWIN' Index 267;
Function WinDrawBorder;                  External 'PMWIN' Index 266;
Function WinLoadString;                  External 'PMWIN' Index 157;
Function WinLoadMessage;                 External 'PMWIN' Index 158;
Function WinSetActiveWindow;             External 'PMWIN' Index  79;
Function WinSubclassWindow;              External 'PMWIN' Index  37;
Function WinQueryClassName;              External 'PMWIN' Index   4;
Function WinQueryClassInfo;              External 'PMWIN' Index   5;
Function WinQueryActiveWindow;           External 'PMWIN' Index  80;
Function WinIsThreadActive;              External 'PMWIN' Index  83;
Function WinQuerySysModalWindow;         External 'PMWIN' Index  82;
Function WinLockWindow;                  External 'PMWIN' Index  38;
Function WinRegisterWindowDestroy;       External 'PMWIN' Index  40;
Function WinSetSysModalWindow;           External 'PMWIN' Index  81;
Function WinQueryWindowLockCount;        External 'PMWIN' Index  39;
Function WinQueryWindowUShort;           External 'PMWIN' Index  29;
Function WinSetWindowUShort;             External 'PMWIN' Index  28;
Function WinQueryWindowULong;            External 'PMWIN' Index  31;
Function WinSetWindowULong;              External 'PMWIN' Index  30;
Function WinQueryWindowPtr;              External 'PMWIN' Index 269;
Function WinSetWindowPtr;                External 'PMWIN' Index 270;
Function WinSetWindowBits;               External 'PMWIN' Index 278;
Function WinBeginEnumWindows;            External 'PMWIN' Index  32;
Function WinGetNextWindow;               External 'PMWIN' Index  33;
Function WinEndEnumWindows;              External 'PMWIN' Index  34;
Function WinWindowFromPoint;             External 'PMWIN' Index  35;
Function WinMapWindowPoints;             External 'PMWIN' Index  36;
Function WinValidateRect;                External 'PMWIN' Index  49;
Function WinValidateRegion;              External 'PMWIN' Index  50;
Function WinWindowFromDC;                External 'PMWIN' Index  57;
Function WinQueryWindowDC;               External 'PMWIN' Index 265;
Function WinGetScreenPS;                 External 'PMWIN' Index  42;
Function WinLockWindowUpdate;            External 'PMWIN' Index  55;
Function WinLockVisRegions;              External 'PMWIN' Index  56;
Function WinQueryUpdateRect;             External 'PMWIN' Index  51;
Function WinQueryUpdateRegion;           External 'PMWIN' Index  52;
Function WinExcludeUpdateRegion;         External 'PMWIN' Index  54;
Function WinSendMsg;                     External 'PMWIN' Index  61;
Function WinCreateMsgQueue;              External 'PMWIN' Index  58;
Function WinDestroyMsgQueue;             External 'PMWIN' Index  59;
Function WinQueryQueueInfo;              External 'PMWIN' Index 287;
Function WinCancelShutdown;              External 'PMWIN' Index 277;
Function WinGetMsg;                      External 'PMWIN' Index  65;
Function WinPeekMsg;                     External 'PMWIN' Index  66;
Function WinDispatchMsg;                 External 'PMWIN' Index  68;
Function WinPostMsg;                     External 'PMWIN' Index  69;
Function WinRegisterUserMsg;             External 'PMWIN' Index 608;
Function WinRegisterUserDatatype;        External 'PMWIN' Index 612;
Function WinSetMsgMode;                  External 'PMWIN' Index 605;
Function WinSetSynchroMode;              External 'PMWIN' Index 606;
Function WinInSendMsg;                   External 'PMWIN' Index  64;
Function WinBroadcastMsg;                External 'PMWIN' Index  63;
Function WinWaitMsg;                     External 'PMWIN' Index  67;
Function WinQueryQueueStatus;            External 'PMWIN' Index  60;
Function WinQueryMsgPos;                 External 'PMWIN' Index  71;
Function WinQueryMsgTime;                External 'PMWIN' Index  72;
Function WinMsgSemWait;                  External 'PMWIN' Index 274;
Function WinMsgMuxSemWait;               External 'PMWIN' Index 275;
Function WinPostQueueMsg;                External 'PMWIN' Index  70;
Function WinSetMsgInterest;              External 'PMWIN' Index  74;
Function WinSetClassMsgInterest;         External 'PMWIN' Index 292;
Function WinSetFocus;                    External 'PMWIN' Index  77;
Function WinFocusChange;                 External 'PMWIN' Index 286;
Function WinSetCapture;                  External 'PMWIN' Index  75;
Function WinQueryCapture;                External 'PMWIN' Index  76;
Function WinQueryFocus;                  External 'PMWIN' Index  78;
Function WinGetKeyState;                 External 'PMWIN' Index 211;
Function WinGetPhysKeyState;             External 'PMWIN' Index 212;
Function WinEnablePhysInput;             External 'PMWIN' Index 214;
Function WinIsPhysInputEnabled;          External 'PMWIN' Index 264;
Function WinSetKeyboardStateTable;       External 'PMWIN' Index 213;
Function WinGetDlgMsg;                   External 'PMWIN' Index 607;
Function WinLoadDlg;                     External 'PMWIN' Index 122;
Function WinDlgBox;                      External 'PMWIN' Index 125;
Function WinDismissDlg;                  External 'PMWIN' Index 126;
Function WinQueryDlgItemShort;           External 'PMWIN' Index 129;
Function WinSetDlgItemShort;             External 'PMWIN' Index 128;
Function WinSetDlgItemText;              External 'PMWIN' Index 134;
Function WinQueryDlgItemText;            External 'PMWIN' Index 135;
Function WinQueryDlgItemTextLength;      External 'PMWIN' Index 294;
Function WinDefDlgProc;                  External 'PMWIN' Index 179;
Function WinAlarm;                       External 'PMWIN' Index 138;
Function WinMessageBox;                  External 'PMWIN' Index 139;
Function WinProcessDlg;                  External 'PMWIN' Index 124;
{Function WinStartDlg;                    External 'PMWIN' Index    ;}
Function WinStartDlg; Begin End; {UNRESOLVED}
Function WinSendDlgItemMsg;              External 'PMWIN' Index 127;
Function WinMapDlgPoints;                External 'PMWIN' Index 130;
Function WinEnumDlgItem;                 External 'PMWIN' Index 133;
Function WinSubstituteStrings;           External 'PMWIN' Index 132;
Function WinCreateDlg;                   External 'PMWIN' Index 123;
Function WinLoadMenu;                    External 'PMWIN' Index 136;
Function WinCreateMenu;                  External 'PMWIN' Index 137;
Function WinCreateStdWindow;             External 'PMWIN' Index 140;
Function WinFlashWindow;                 External 'PMWIN' Index 144;
Function WinCreateFrameControls;         External 'PMWIN' Index 141;
Function WinCalcFrameRect;               External 'PMWIN' Index 143;
Function WinGetMinPosition;              External 'PMWIN' Index 146;
Function WinGetMaxPosition;              External 'PMWIN' Index 147;
Function WinCopyRect;                    External 'PMWIN' Index 161;
Function WinSetRect;                     External 'PMWIN' Index 160;
Function WinIsRectEmpty;                 External 'PMWIN' Index 162;
Function WinEqualRect;                   External 'PMWIN' Index 163;
Function WinSetRectEmpty;                External 'PMWIN' Index 159;
Function WinOffsetRect;                  External 'PMWIN' Index 165;
Function WinInflateRect;                 External 'PMWIN' Index 166;
Function WinPtInRect;                    External 'PMWIN' Index 164;
Function WinIntersectRect;               External 'PMWIN' Index 167;
Function WinUnionRect;                   External 'PMWIN' Index 168;
Function WinSubtractRect;                External 'PMWIN' Index 169;
Function WinMakeRect;                    External 'PMWIN' Index 170;
Function WinMakePoints;                  External 'PMWIN' Index 171;
Function WinQuerySysValue;               External 'PMWIN' Index 149;
Function WinSetSysValue;                 External 'PMWIN' Index 150;
Function WinSetPresParam;                External 'PMWIN' Index 301;
Function WinQueryPresParam;              External 'PMWIN' Index 302;
Function WinRemovePresParam;             External 'PMWIN' Index 303;
Function WinQuerySysColor;               External 'PMWIN' Index 152;
Function WinSetSysColors;                External 'PMWIN' Index 151;
Function WinStartTimer;                  External 'PMWIN' Index  84;
Function WinStopTimer;                   External 'PMWIN' Index  85;
Function WinGetCurrentTime;              External 'PMWIN' Index  86;
Function WinLoadAccelTable;              External 'PMWIN' Index 102;
Function WinCreateAccelTable;            External 'PMWIN' Index 103;
Function WinDestroyAccelTable;           External 'PMWIN' Index 104;
Function WinCopyAccelTable;              External 'PMWIN' Index 108;
Function WinTranslateAccel;              External 'PMWIN' Index 105;
Function WinSetAccelTable;               External 'PMWIN' Index 106;
Function WinQueryAccelTable;             External 'PMWIN' Index 107;
Function WinTrackRect;                   External 'PMWIN' Index 154;
Function WinShowTrackRect;               External 'PMWIN' Index 155;
Function WinSetClipbrdOwner;             External 'PMWIN' Index 114;
Function WinSetClipbrdData;              External 'PMWIN' Index 116;
Function WinQueryClipbrdData;            External 'PMWIN' Index 117;
Function WinQueryClipbrdFmtInfo;         External 'PMWIN' Index 119;
Function WinSetClipbrdViewer;            External 'PMWIN' Index 120;
Function WinEnumClipbrdFmts;             External 'PMWIN' Index 118;
Function WinEmptyClipbrd;                External 'PMWIN' Index 113;
Function WinOpenClipbrd;                 External 'PMWIN' Index 111;
Function WinCloseClipbrd;                External 'PMWIN' Index 112;
Function WinQueryClipbrdOwner;           External 'PMWIN' Index 115;
Function WinQueryClipbrdViewer;          External 'PMWIN' Index 121;
Function WinDestroyCursor;               External 'PMWIN' Index  99;
Function WinShowCursor;                  External 'PMWIN' Index 100;
Function WinCreateCursor;                External 'PMWIN' Index  98;
Function WinQueryCursorInfo;             External 'PMWIN' Index 101;
Function WinSetPointer;                  External 'PMWIN' Index  92;
Function WinShowPointer;                 External 'PMWIN' Index  94;
Function WinQuerySysPointer;             External 'PMWIN' Index  91;
Function WinLoadPointer;                 External 'PMWIN' Index  87;
Function WinDestroyPointer;              External 'PMWIN' Index  89;
Function WinCreatePointer;               External 'PMWIN' Index  88;
Function WinQueryPointer;                External 'PMWIN' Index  93;
Function WinSetPointerPos;               External 'PMWIN' Index  95;
Function WinQueryPointerPos;             External 'PMWIN' Index  96;
Function WinCreatePointerIndirect;       External 'PMWIN' Index 616;
Function WinQueryPointerInfo;            External 'PMWIN' Index 617;
Function WinDrawPointer;                 External 'PMWIN' Index 177;
Function WinGetSysBitmap;                External 'PMWIN' Index  97;
Function WinSetHook;                     External 'PMWIN' Index 109;
Function WinReleaseHook;                 External 'PMWIN' Index 110;
Function WinCallMsgFilter;               External 'PMWIN' Index  73;
Function WinQueryCp;                     External 'PMWIN' Index 216;
Function WinSetCp;                       External 'PMWIN' Index 215;
Function WinQueryCpList;                 External 'PMWIN' Index 217;
Function WinCpTranslateString;           External 'PMWIN' Index 218;
Function WinCpTranslateChar;             External 'PMWIN' Index 219;
Function WinUpper;                       External 'PMWIN' Index 221;
Function WinUpperChar;                   External 'PMWIN' Index 222;
Function WinNextChar;                    External 'PMWIN' Index 223;
Function WinPrevChar;                    External 'PMWIN' Index 224;
Function WinCompareStrings;              External 'PMWIN' Index 220;
Function WinCreateHeap;                  External 'PMWIN' Index 225;
Function WinDestroyHeap;                 External 'PMWIN' Index 226;
Function WinAvailMem;                    External 'PMWIN' Index 227;
Function WinAllocMem;                    External 'PMWIN' Index 228;
Function WinReallocMem;                  External 'PMWIN' Index 229;
Function WinFreeMem;                     External 'PMWIN' Index 230;
Function WinLockHeap;                    External 'PMWIN' Index 231;
Function WinQuerySystemAtomTable;        External 'PMWIN' Index 241;
Function WinCreateAtomTable;             External 'PMWIN' Index 233;
Function WinDestroyAtomTable;            External 'PMWIN' Index 234;
Function WinAddAtom;                     External 'PMWIN' Index 235;
Function WinFindAtom;                    External 'PMWIN' Index 236;
Function WinDeleteAtom;                  External 'PMWIN' Index 237;
Function WinQueryAtomUsage;              External 'PMWIN' Index 238;
Function WinQueryAtomLength;             External 'PMWIN' Index 239;
Function WinQueryAtomName;               External 'PMWIN' Index 240;
Function WinCatch;                       External 'PMWIN' Index 248;
Procedure WinThrow;                      External 'PMWIN' Index 249;
Function WinGetLastError;                External 'PMWIN' Index 243;
Function WinGetErrorInfo;                External 'PMWIN' Index 244;
Function WinFreeErrorInfo;               External 'PMWIN' Index 245;
Function WinDdeInitiate;                 External 'PMWIN' Index 297;
Function WinDdeRespond;                  External 'PMWIN' Index 298;
Function WinDdePostMsg;                  External 'PMWIN' Index 299;
Function WinDeleteProcedure;             External 'PMWIN' Index 604;
Function WinDeleteLibrary;               External 'PMWIN' Index 602;
Function WinLoadProcedure;               External 'PMWIN' Index 603;
Function WinLoadLibrary;                 External 'PMWIN' Index 615;

End.
