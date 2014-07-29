
(*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*)
(*                                                                   *)
(*     Borland Pascal OS/2 API                                       *)
(*                                                                   *)
(*     OS2SUBS  - Subsystem API - video, mouse, and keyboard         *)
(*                                                                   *)
(*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*)

unit OS2Subs;

interface

uses
  OS2Def;

(* -------------------------- SUBSYSTEMS ---------------------------------- *)

const
  IO_WAIT                                 = 0;
  IO_NOWAIT                               = 1;

  KBDSTF_RIGHTSHIFT                       = $0001;
  KBDSTF_LEFTSHIFT                        = $0002;
  KBDSTF_CONTROL                          = $0004;
  KBDSTF_ALT                              = $0008;
  KBDSTF_SCROLLLOCK_ON                    = $0010;
  KBDSTF_NUMLOCK_ON                       = $0020;
  KBDSTF_CAPSLOCK_ON                      = $0040;
  KBDSTF_INSERT_ON                        = $0080;
  KBDSTF_LEFTCONTROL                      = $0100;
  KBDSTF_LEFTALT                          = $0200;
  KBDSTF_RIGHTCONTROL                     = $0400;
  KBDSTF_RIGHTALT                         = $0800;
  KBDSTF_SCROLLLOCK                       = $1000;
  KBDSTF_NUMLOCK                          = $2000;
  KBDSTF_CAPSLOCK                         = $4000;
  KBDSTF_SYSREQ                           = $8000;

  KBDTRF_SHIFT_KEY_IN                     = $01;
  KBDTRF_EXTENDED_CODE                    = $02;
  KBDTRF_CONVERSION_REQUEST               = $20;
  KBDTRF_FINAL_CHAR_IN                    = $40;
  KBDTRF_INTERIM_CHAR_IN                  = $80;

  KEYBOARD_ECHO_ON                        = $0001;
  KEYBOARD_ECHO_OFF                       = $0002;
  KEYBOARD_BINARY_MODE                    = $0004;
  KEYBOARD_ASCII_MODE                     = $0008;
  KEYBOARD_MODIFY_STATE                   = $0010;
  KEYBOARD_MODIFY_INTERIM                 = $0020;
  KEYBOARD_MODIFY_TURNAROUND              = $0040;
  KEYBOARD_2B_TURNAROUND                  = $0080;
  KEYBOARD_SHIFT_REPORT                   = $0100;

  KR_KBDCHARIN                            = $00000001;
  KR_KBDPEEK                              = $00000002;
  KR_KBDFLUSHBUFFER                       = $00000004;
  KR_KBDGETSTATUS                         = $00000008;
  KR_KBDSETSTATUS                         = $00000010;
  KR_KBDSTRINGIN                          = $00000020;
  KR_KBDOPEN                              = $00000040;
  KR_KBDCLOSE                             = $00000080;
  KR_KBDGETFOCUS                          = $00000100;
  KR_KBDFREEFOCUS                         = $00000200;
  KR_KBDGETCP                             = $00000400;
  KR_KBDSETCP                             = $00000800;
  KR_KBDXLATE                             = $00001000;
  KR_KBDSETCUSTXT                         = $00002000;

type
  HKBD = Word;
  PHKBD = ^HKBD;

  TKBDKEYINFO = record
    chChar : Char;
    chScan : Char;
    fbStatus : Byte;
    bNlsShift : Char;
    fsState : Word;
    time : Longint;
  end;
  PKBDKEYINFO = ^TKBDKEYINFO;

  TKBDINFO = record
    cb : Word;
    fsMask : Word;
    chTurnAround : Word;
    fsInterim : Word;
    fsState : Word;
  end;
  PKBDINFO = ^TKBDINFO;

  TKBDHWID = record
    cb : Word;
    idKbd : Word;
    usReserved1 : Word;
    usReserved2 : Word;
  end;
  PKBDHWID = ^TKBDHWID;

  TKBDTRANS = record
    chChar : Char;
    chScan : Char;
    fbStatus : Char;
    bNlsShift : Char;
    fsState : Word;
    time : Longint;
    fsDD : Word;
    fsXlate : Word;
    fsShift : Word;
    sZero : Word;
  end;
  PKBDTRANS = ^TKBDTRANS;

  TSTRINGINBUF = record
    cb : Word;
    cchIn : Word;
  end;
  PSTRINGINBUF = ^TSTRINGINBUF;

function KbdCharIn(var kbci : TKBDKEYINFO; fWait : Word; hkbd : HKBD) : Word;
function KbdClose(hkbd : HKBD) : Word;
function KbdDeRegister : Word;
function KbdFlushBuffer(hkbd : HKBD) : Word;
function KbdFreeFocus(hkbd : HKBD) : Word;
function KbdGetCp(ulReserved : Longint; var idCP : Word; hkbd : HKBD) : Word;
function KbdGetFocus(fWait : Word; hkbd : HKBD) : Word;
function KbdGetHWID(var kbdhwid : TKBDHWID; hkbd : HKBD) : Word;
function KbdGetStatus(var kbdinfo : TKBDINFO; hkbd : HKBD) : Word;
function KbdOpen(var hkbd : HKBD) : Word;
function KbdPeek(var kbci : TKBDKEYINFO; hkbd : HKBD) : Word;
function KbdRegister(pszModName : CONSTPSZ; pszEntryName : CONSTPSZ;
    ulFunMask : Longint) : Word;
function KbdSetCp(usReserved : Word; idCP : Word; hkbd : HKBD) : Word;
function KbdSetCustXt(var usCodePage : Word; hkbd : HKBD) : Word;
function KbdSetFgnd : Word;
function KbdSetHWID(pkbdhwid : PKBDHWID; hkbd : HKBD) : Word;
function KbdSetStatus(var kbdinfo : TKBDINFO; hkbd : HKBD) : Word;
function KbdStringIn(pch : PCH; pchIn : PSTRINGINBUF; fWait : Word; hkbd : HKBD) : Word;
function KbdSynch(fWait : Word) : Word;
function KbdXlate(const kbdtrans : TKBDTRANS; hkbd : HKBD) : Word;

const
  ANSI_OFF                                = 0;
  ANSI_ON                                 = 1;

  COLORS_2                                = $01;
  COLORS_4                                = $02;
  COLORS_16                               = $04;

  VGMT_OTHER                              = $01;
  VGMT_GRAPHICS                           = $02;
  VGMT_DISABLEBURST                       = $04;

  VP_NOWAIT                               = $0000;
  VP_WAIT                                 = $0001;
  VP_OPAQUE                               = $0000;
  VP_TRANSPARENT                          = $0002;

  VMWR_POPUP                              = 0;
  VMWN_POPUP                              = 0;

  VSRWI_SAVEANDREDRAW                     = 0;
  VSRWI_REDRAW                            = 1;

  VSRWN_SAVE                              = 0;
  VSRWN_REDRAW                            = 1;

  UNDOI_GETOWNER                          = 0;
  UNDOI_RELEASEOWNER                      = 1;

  UNDOK_ERRORCODE                         = 0;
  UNDOK_TERMINATE                         = 1;

  LOCKIO_NOWAIT                           = 0;
  LOCKIO_WAIT                             = 1;

  LOCK_SUCCESS                            = 0;
  LOCK_FAIL                               = 1;

  VCC_SBCSCHAR                            = 0;
  VCC_DBCSFULLCHAR                        = 1;
  VCC_DBCS1STHALF                         = 2;
  VCC_DBCS2NDHALF                         = 3;

  VGFI_GETCURFONT                         = 0;
  VGFI_GETROMFONT                         = 1;

  VIO_CONFIG_CURRENT                      = 0;
  VIO_CONFIG_PRIMARY                      = 1;
  VIO_CONFIG_SECONDARY                    = 2;

  DISPLAY_MONOCHROME                      = 0;
  DISPLAY_CGA                             = 1;
  DISPLAY_EGA                             = 2;
  DISPLAY_VGA                             = 3;
  DISPLAY_8514A                           = 7;
  DISPLAY_IMAGEADAPTER                    = 8;
  DISPLAY_XGA                             = 9;

  MONITOR_MONOCHROME                      = $0000;
  MONITOR_COLOR                           = $0001;
  MONITOR_ENHANCED                        = $0002;
  MONITOR_8503                            = $0003;
  MONITOR_851X_COLOR                      = $0004;
  MONITOR_8514                            = $0009;
  MONITOR_FLATPANEL                       = $000a;
  MONITOR_8507_8604                       = $000b;
  MONITOR_8515                            = $000c;
  MONITOR_9515                            = $000f;
  MONITOR_9517                            = $0011;
  MONITOR_9518                            = $0012;

  VR_VIOGETCURPOS                         = $00000001;
  VR_VIOGETCURTYPE                        = $00000002;
  VR_VIOGETMODE                           = $00000004;
  VR_VIOGETBUF                            = $00000008;
  VR_VIOGETPHYSBUF                        = $00000010;
  VR_VIOSETCURPOS                         = $00000020;
  VR_VIOSETCURTYPE                        = $00000040;
  VR_VIOSETMODE                           = $00000080;
  VR_VIOSHOWBUF                           = $00000100;
  VR_VIOREADCHARSTR                       = $00000200;
  VR_VIOREADCELLSTR                       = $00000400;
  VR_VIOWRTNCHAR                          = $00000800;
  VR_VIOWRTNATTR                          = $00001000;
  VR_VIOWRTNCELL                          = $00002000;
  VR_VIOWRTTTY                            = $00004000;
  VR_VIOWRTCHARSTR                        = $00008000;
  VR_VIOWRTCHARSTRATT                     = $00010000;
  VR_VIOWRTCELLSTR                        = $00020000;
  VR_VIOSCROLLUP                          = $00040000;
  VR_VIOSCROLLDN                          = $00080000;
  VR_VIOSCROLLLF                          = $00100000;
  VR_VIOSCROLLRT                          = $00200000;
  VR_VIOSETANSI                           = $00400000;
  VR_VIOGETANSI                           = $00800000;
  VR_VIOPRTSC                             = $01000000;
  VR_VIOSCRLOCK                           = $02000000;
  VR_VIOSCRUNLOCK                         = $04000000;
  VR_VIOSAVREDRAWWAIT                     = $08000000;
  VR_VIOSAVREDRAWUNDO                     = $10000000;
  VR_VIOPOPUP                             = $20000000;
  VR_VIOENDPOPUP                          = $40000000;
  VR_VIOPRTSCTOGGLE                       = $80000000;

  VR_VIOMODEWAIT                          = $00000001;
  VR_VIOMODEUNDO                          = $00000002;
  VR_VIOGETFONT                           = $00000004;
  VR_VIOGETCONFIG                         = $00000008;
  VR_VIOSETCP                             = $00000010;
  VR_VIOGETCP                             = $00000020;
  VR_VIOSETFONT                           = $00000040;
  VR_VIOGETSTATE                          = $00000080;
  VR_VIOSETSTATE                          = $00000100;


type
  HVIO = Word;
  PHVIO = ^HVIO;


  TVIOMODEINFO = record
    cb : Word;
    fbType : Char;
    color : Char;
    col : Word;
    row : Word;
    hres : Word;
    vres : Word;
    fmt_ID : Char;
    attrib : Char;
    buf_addr : Longint;
    buf_length : Longint;
    full_length : Longint;
    partial_length : Longint;
    ext_data_addr : PCH;
  end;
  PVIOMODEINFO = ^TVIOMODEINFO;

  TVIOCONFIGINFO = record
    cb : Word;
    adapter : Word;
    display : Word;
    cbMemory : Longint;
    Configuration : Word;
    VDHVersion : Word;
    Flags : Word;
    HWBufferSize : Longint;
    FullSaveSize : Longint;
    PartSaveSize : Longint;
    EMAdaptersOFF : Word;
    EMDisplaysOFF : Word;
  end;
  PVIOCONFIGINFO = ^TVIOCONFIGINFO;

  TVIOPHYSBUF = record
    pBuf : PBYTE;
    cb : Longint;
    asel : array[0..1-1] of SEL;
  end;
  PVIOPHYSBUF = ^TVIOPHYSBUF;

  TVIOPALSTATE = record
    cb : Word;
    _type : Word;
    iFirst : Word;
    acolor : array[0..1-1] of Word;
  end;
  PVIOPALSTATE = ^TVIOPALSTATE;

  TVIOOVERSCAN = record
    cb : Word;
    _type : Word;
    color : Word;
  end;
  PVIOOVERSCAN = ^TVIOOVERSCAN;

  TVIOINTENSITY = record
    cb : Word;
    _type : Word;
    fs : Word;
  end;
  PVIOINTENSITY = ^TVIOINTENSITY;

  TVIOCOLORREG = record
    cb : Word;
    _type : Word;
    firstcolorreg : Word;
    numcolorregs : Word;
    colorregaddr : PCH;
  end;
  PVIOCOLORREG = ^TVIOCOLORREG;

  TVIOSETULINELOC = record
    cb : Word;
    _type : Word;
    scanline : Word;
  end;
  PVIOSETULINELOC = ^TVIOSETULINELOC;

  TVIOSETTARGET = record
    cb : Word;
    _type : Word;
    defaultalgorithm : Word;
  end;
  PVIOSETTARGET = ^TVIOSETTARGET;

  TVIOCURSORINFO = record
    yStart : Word;
    cEnd : Word;
    cx : Word;
    attr : Word;
  end;
  PVIOCURSORINFO = ^TVIOCURSORINFO;

  TVIOFONTINFO = record
    cb : Word;
    _type : Word;
    cxCell : Word;
    cyCell : Word;
    pbData : Longint;
    cbData : Word;
  end;
  PVIOFONTINFO = ^TVIOFONTINFO;


function VioCheckCharType(pType : PWord; usRow : Word; usColumn : Word;
    hvio : HVIO) : Word;
function VioDeRegister : Word;
function VioEndPopUp(hvio : HVIO) : Word;
function VioGetAnsi(var fAnsi : Word; hvio : HVIO) : Word;
function VioGetBuf(var LVB : Pointer; var cbLVB : Word; hvio : HVIO) : Word;
function VioGetConfig(usConfigId : Word; var vioin : TVIOCONFIGINFO; hvio : HVIO) : Word;
function VioGetCp(usReserved : Word; var usCodePage : Word; hvio : HVIO) : Word;
function VioGetCurPos(var usRow, usColumn : Word; hvio : HVIO) : Word;
function VioGetCurType(var vioCursorInfo : TVIOCURSORINFO; hvio : HVIO) : Word;
function VioGetFont(var viofi : TVIOFONTINFO; hvio : HVIO) : Word;
function VioGetMode(var vioModeInfo : TVIOMODEINFO; hvio : HVIO) : Word;
function VioGetPhysBuf(var vioPhysBuf : TVIOPHYSBUF; usReserved : Word) : Word;
function VioGlobalReg(pszModName : CONSTPSZ; pszEntryName : CONSTPSZ;
    ulFunMask1 : Longint; ulFunMask2 : Longint; usReturn : Word) : Word;
function VioModeUndo(usOwnerInd : Word; usKillInd : Word; usReserved : Word) : Word;
function VioModeWait(usReqType : Word; var NotifyType : Word; usReserved : Word) : Word;
function VioPopUp(var fWait : Word; hvio : HVIO) : Word;
function VioPrtSc(hvio : HVIO) : Word;
function VioPrtScToggle(hvio : HVIO) : Word;
function VioReadCellStr(pchCellStr : PCH; var cb : Word; usRow : Word;
    usColumn : Word; hvio : HVIO) : Word;
function VioReadCharStr(pch : PCH; var cb : Word; usRow : Word; usColumn : Word;
    hvio : HVIO) : Word;
function VioRegister(pszModName : CONSTPSZ; pszEntryName : CONSTPSZ;
    ulFunMask1 : Longint; ulFunMask2 : Longint) : Word;
function VioSavRedrawUndo(usOwnerInd : Word; usKillInd : Word;
    usReserved : Word) : Word;
function VioSavRedrawWait(usRedrawInd : Word; var pusNotifyType : Word;
    usReserved : Word) : Word;
function VioScrLock(fWait : Word; var fNotLocked : Char; hvio : HVIO) : Word;
function VioScrollDn(usTopRow, usLeftCol, usBotRow, usRightCol : Word;
    cbLines : Word; var Cell; hvio : HVIO) : Word;
function VioScrollLf(usTopRow, usLeftCol, usBotRow, usRightCol : Word;
    cbCol : Word; var Cell; hvio : HVIO) : Word;
function VioScrollRt(usTopRow, usLeftCol, usBotRow, usRightCol : Word;
    cbCol : Word; var Cell; hvio : HVIO) : Word;
function VioScrollUp(usTopRow, usLeftCol, usBotRow, usRightCol : Word;
    cbLines : Word; var Cell; hvio : HVIO) : Word;
function VioScrUnLock(hvio : HVIO) : Word;
function VioSetAnsi(fAnsi : Word; hvio : HVIO) : Word;
function VioSetCp(usReserved : Word; usCodePage : Word; hvio : HVIO) : Word;
function VioSetCurPos(usRow, usColumn : Word; hvio : HVIO) : Word;
function VioSetCurType(var vioCursorInfo : TVIOCURSORINFO; hvio : HVIO) : Word;
function VioSetFont(var viofi : TVIOFONTINFO; hvio : HVIO) : Word;
function VioSetMode(var vioModeInfo : TVIOMODEINFO; hvio : HVIO) : Word;
function VioShowBuf(offLVB : Word; cb : Word; hvio : HVIO) : Word;
function VioWrtCellStr(pchCellStr : CONSTPCH; cb : Word; usRow : Word;
    usColumn : Word; hvio : HVIO) : Word;
function VioWrtCharStr(pch : CONSTPCH; cb : Word; usRow : Word; usColumn : Word;
    hvio : HVIO) : Word;
function VioWrtCharStrAtt(pch : CONSTPCH; cb : Word; usRow : Word;
    usColumn : Word; var Attr; hvio : HVIO) : Word;
function VioWrtNAttr(pAttr : PBYTE; cb : Word; usRow : Word;
    usColumn : Word; hvio : HVIO) : Word;
function VioWrtNCell(var Cell; cb : Word; usRow : Word;
    usColumn : Word; hvio : HVIO) : Word;
function VioWrtNChar(pch : CONSTPCH; cb : Word; usRow : Word; usColumn : Word;
    hvio : HVIO) : Word;
function VioWrtTTY(pch : CONSTPCH; cb : Word; hvio : HVIO) : Word;

const
  MHK_BUTTON1                             = $0001;
  MHK_BUTTON2                             = $0002;
  MHK_BUTTON3                             = $0004;

  MOU_NOWAIT                              = $0000;
  MOU_WAIT                                = $0001;

  MOUSE_MOTION                            = $0001;
  MOUSE_MOTION_WITH_BN1_DOWN              = $0002;
  MOUSE_BN1_DOWN                          = $0004;
  MOUSE_MOTION_WITH_BN2_DOWN              = $0008;
  MOUSE_BN2_DOWN                          = $0010;
  MOUSE_MOTION_WITH_BN3_DOWN              = $0020;
  MOUSE_BN3_DOWN                          = $0040;

  MOUSE_QUEUEBUSY                         = $0001;
  MOUSE_BLOCKREAD                         = $0002;
  MOUSE_FLUSH                             = $0004;
  MOUSE_UNSUPPORTED_MODE                  = $0008;
  MOUSE_DISABLED                          = $0100;
  MOUSE_MICKEYS                           = $0200;

  MOU_NODRAW                              = $0001;
  MOU_DRAW                                = $0000;
  MOU_MICKEYS                             = $0002;
  MOU_PELS                                = $0000;

  MR_MOUGETNUMBUTTONS                     = $00000001;
  MR_MOUGETNUMMICKEYS                     = $00000002;
  MR_MOUGETDEVSTATUS                      = $00000004;
  MR_MOUGETNUMQUEEL                       = $00000008;
  MR_MOUREADEVENTQUE                      = $00000010;
  MR_MOUGETSCALEFACT                      = $00000020;
  MR_MOUGETEVENTMASK                      = $00000040;
  MR_MOUSETSCALEFACT                      = $00000080;
  MR_MOUSETEVENTMASK                      = $00000100;
  MR_MOUOPEN                              = $00000800;
  MR_MOUCLOSE                             = $00001000;
  MR_MOUGETPTRSHAPE                       = $00002000;
  MR_MOUSETPTRSHAPE                       = $00004000;
  MR_MOUDRAWPTR                           = $00008000;
  MR_MOUREMOVEPTR                         = $00010000;
  MR_MOUGETPTRPOS                         = $00020000;
  MR_MOUSETPTRPOS                         = $00040000;
  MR_MOUINITREAL                          = $00080000;
  MR_MOUSETDEVSTATUS                      = $00100000;


type
  HMOU = Word;
  PHMOU = ^HMOU;


  TMOUEVENTINFO = record
    fs : Word;
    time : Longint;
    row : Integer;
    col : Integer;
  end;
  PMOUEVENTINFO = ^TMOUEVENTINFO;

  TMOUQUEINFO = record
    cEvents : Word;
    cmaxEvents : Word;
  end;
  PMOUQUEINFO = ^TMOUQUEINFO;

  TPTRLOC = record
    row : Word;
    col : Word;
  end;
  PPTRLOC = ^TPTRLOC;

  TNOPTRRECT = record
    row : Word;
    col : Word;
    cRow : Word;
    cCol : Word;
  end;
  PNOPTRRECT = ^TNOPTRRECT;

  TPTRSHAPE = record
    cb : Word;
    col : Word;
    row : Word;
    colHot : Word;
    rowHot : Word;
  end;
  PPTRSHAPE = ^TPTRSHAPE;

  TSCALEFACT = record
    rowScale : Word;
    colScale : Word;
  end;
  PSCALEFACT = ^TSCALEFACT;

  TTHRESHOLD = record
    Length : Word;
    Level1 : Word;
    Lev1Mult : Word;
    Level2 : Word;
    lev2Mult : Word;
  end;
  PTHRESHOLD = ^TTHRESHOLD;


function MouClose(hmou : HMOU) : Word;
function MouDeRegister : Word;
function MouDrawPtr(hmou : HMOU) : Word;
function MouFlushQue(hmou : HMOU) : Word;
function MouGetDevStatus(var fsDevStatus : Word; hmou : HMOU) : Word;
function MouGetEventMask(var fsEvents : Word; hmou : HMOU) : Word;
function MouGetNumButtons(var cButtons : Word; hmou : HMOU) : Word;
function MouGetNumMickeys(var cMickeys : Word; hmou : HMOU) : Word;
function MouGetNumQueEl(var mouqi : TMOUQUEINFO; hmou : HMOU) : Word;
function MouGetPtrPos(var mouLoc : TPTRLOC; hmou : HMOU) : Word;
function MouGetPtrShape(var Buf; var moupsInfo : TPTRSHAPE; hmou : HMOU) : Word;
function MouGetScaleFact(var mouscFactors : TSCALEFACT; hmou : HMOU) : Word;
function MouGetThreshold(var threshold : TTHRESHOLD; hmou : HMOU) : Word;
function MouInitReal(pszDriverName : CONSTPSZ) : Word;
function MouOpen(pszDvrName : CONSTPSZ; var hmou : HMOU) : Word;
function MouReadEventQue(var mouevEvent : TMOUEVENTINFO; var fWait : Word; hmou : HMOU) : Word;
function MouRegister(pszModName : CONSTPSZ; pszEntryName : CONSTPSZ;
    ulFunMask : Longint) : Word;
function MouRemovePtr(var mourtRect : TNOPTRRECT; hmou : HMOU) : Word;
function MouSetDevStatus(var fsDevStatus : Word; hmou : HMOU) : Word;
function MouSetEventMask(var fsEvents : Word; hmou : HMOU) : Word;
function MouSetPtrPos(const mouLoc : TPTRLOC; hmou : HMOU) : Word;
function MouSetPtrShape(var Buf; var moupsInfo : TPTRSHAPE; hmou : HMOU) : Word;
function MouSetScaleFact(const mouscFactors : TSCALEFACT; hmou : HMOU) : Word;
function MouSetThreshold(var threshold : TTHRESHOLD; hmou : HMOU) : Word;
function MouSynch(fWait : Word) : Word;


implementation

function KBDCHARIN; external 'KBDCALLS' index 4;
function KBDCLOSE; external 'KBDCALLS' index 17;
function KBDDEREGISTER; external 'KBDCALLS' index 20;
function KBDFLUSHBUFFER; external 'KBDCALLS' index 13;
function KBDFREEFOCUS; external 'KBDCALLS' index 18;
function KBDGETCP; external 'KBDCALLS' index 3;
function KBDGETFOCUS; external 'KBDCALLS' index 12;
function KBDGETHWID; external 'KBDCALLS' index 24;
function KBDGETSTATUS; external 'KBDCALLS' index 10;
function KBDOPEN; external 'KBDCALLS' index 23;
function KBDPEEK; external 'KBDCALLS' index 22;
function KBDREGISTER; external 'KBDCALLS' index 8;
function KBDSETCP; external 'KBDCALLS' index 5;
function KBDSETCUSTXT; external 'KBDCALLS' index 1;
function KBDSETFGND; external 'KBDCALLS' index 21;
function KBDSETHWID; external 'KBDCALLS' index 25;
function KBDSETSTATUS; external 'KBDCALLS' index 11;
function KBDSTRINGIN; external 'KBDCALLS' index 9;
function KBDSYNCH; external 'KBDCALLS' index 7;
function KBDXLATE; external 'KBDCALLS' index 14;
function MOUCLOSE; external 'MOUCALLS' index 9;
function MOUDEREGISTER; external 'MOUCALLS' index 14;
function MOUDRAWPTR; external 'MOUCALLS' index 26;
function MOUFLUSHQUE; external 'MOUCALLS' index 7;
function MOUGETDEVSTATUS; external 'MOUCALLS' index 22;
function MOUGETEVENTMASK; external 'MOUCALLS' index 15;
function MOUGETNUMBUTTONS; external 'MOUCALLS' index 8;
function MOUGETNUMMICKEYS; external 'MOUCALLS' index 3;
function MOUGETNUMQUEEL; external 'MOUCALLS' index 13;
function MOUGETPTRPOS; external 'MOUCALLS' index 19;
function MOUGETPTRSHAPE; external 'MOUCALLS' index 1;
function MOUGETSCALEFACT; external 'MOUCALLS' index 6;
function MOUGETTHRESHOLD; external 'MOUCALLS' index 30;
function MOUINITREAL; external 'MOUCALLS' index 27;
function MOUOPEN; external 'MOUCALLS' index 17;
function MOUREADEVENTQUE; external 'MOUCALLS' index 20;
function MOUREGISTER; external 'MOUCALLS' index 24;
function MOUREMOVEPTR; external 'MOUCALLS' index 18;
function MOUSETDEVSTATUS; external 'MOUCALLS' index 25;
function MOUSETEVENTMASK; external 'MOUCALLS' index 16;
function MOUSETPTRPOS; external 'MOUCALLS' index 21;
function MOUSETPTRSHAPE; external 'MOUCALLS' index 2;
function MOUSETSCALEFACT; external 'MOUCALLS' index 11;
function MOUSETTHRESHOLD; external 'MOUCALLS' index 29;
function MOUSYNCH; external 'MOUCALLS' index 23;
function VIOCHECKCHARTYPE; external 'VIOCALLS' index 75;
function VIODEREGISTER; external 'VIOCALLS' index 6;
function VIOENDPOPUP; external 'VIOCALLS' index 1;
function VIOGETANSI; external 'VIOCALLS' index 3;
function VIOGETBUF; external 'VIOCALLS' index 31;
function VIOGETCONFIG; external 'VIOCALLS' index 46;
function VIOGETCP; external 'VIOCALLS' index 40;
function VIOGETCURPOS; external 'VIOCALLS' index 9;
function VIOGETCURTYPE; external 'VIOCALLS' index 27;
function VIOGETFONT; external 'VIOCALLS' index 29;
function VIOGETMODE; external 'VIOCALLS' index 21;
function VIOGETPHYSBUF; external 'VIOCALLS' index 2;
function VIOGLOBALREG; external 'VIOCALLS' index 70;
function VIOMODEUNDO; external 'VIOCALLS' index 35;
function VIOMODEWAIT; external 'VIOCALLS' index 37;
function VIOPOPUP; external 'VIOCALLS' index 11;
function VIOPRTSC; external 'VIOCALLS' index 8;
function VIOPRTSCTOGGLE; external 'VIOCALLS' index 50;
function VIOREADCELLSTR; external 'VIOCALLS' index 24;
function VIOREADCHARSTR; external 'VIOCALLS' index 30;
function VIOREGISTER; external 'VIOCALLS' index 45;
function VIOSAVREDRAWUNDO; external 'VIOCALLS' index 28;
function VIOSAVREDRAWWAIT; external 'VIOCALLS' index 25;
function VIOSCRLOCK; external 'VIOCALLS' index 23;
function VIOSCROLLDN; external 'VIOCALLS' index 47;
function VIOSCROLLLF; external 'VIOCALLS' index 44;
function VIOSCROLLRT; external 'VIOCALLS' index 12;
function VIOSCROLLUP; external 'VIOCALLS' index 7;
function VIOSCRUNLOCK; external 'VIOCALLS' index 18;
function VIOSETANSI; external 'VIOCALLS' index 5;
function VIOSETCP; external 'VIOCALLS' index 42;
function VIOSETCURPOS; external 'VIOCALLS' index 15;
function VIOSETCURTYPE; external 'VIOCALLS' index 32;
function VIOSETFONT; external 'VIOCALLS' index 33;
function VIOSETMODE; external 'VIOCALLS' index 22;
function VIOSHOWBUF; external 'VIOCALLS' index 43;
function VIOWRTCELLSTR; external 'VIOCALLS' index 10;
function VIOWRTCHARSTR; external 'VIOCALLS' index 13;
function VIOWRTCHARSTRATT; external 'VIOCALLS' index 48;
function VIOWRTNATTR; external 'VIOCALLS' index 26;
function VIOWRTNCELL; external 'VIOCALLS' index 52;
function VIOWRTNCHAR; external 'VIOCALLS' index 53;
function VIOWRTTTY; external 'VIOCALLS' index 19;

end.
