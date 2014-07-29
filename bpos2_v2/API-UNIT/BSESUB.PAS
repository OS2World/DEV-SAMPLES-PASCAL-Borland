{| Unit: BseSub
 | Version: 1.00
 | translated from file BseSub.H
 | Original translation: Peter Sawatzki (ps)
 | Contributing:
 |   (fill in)
 |
 | change history:
 | Date:    Ver: Author:
 | 11/23/93 1.00 ps     original translation by ps
}
Unit BseSub; { OS/2 Base Include File }
Interface
Uses
  Os2Def;
Type
  HKBD  = SHANDLE;
  pHKBD = ^PHKBD;

{**   KbdRegister - register keyboard subsystem within a session }

  Function KbdRegister (pszModName,                         { dynamic link module name }
                        pszEntryPt: PSZ;                    { entry point name }
                        FunMask: ULONG): USHORT;    { function mask of functions being registered }


Const
  KR_KBDCHARIN                     =  $00000001 ;
  KR_KBDPEEK                       =  $00000002 ;
  KR_KBDFLUSHBUFFER                =  $00000004 ;
  KR_KBDGETSTATUS                  =  $00000008 ;
  KR_KBDSETSTATUS                  =  $00000010 ;
  KR_KBDSTRINGIN                   =  $00000020 ;
  KR_KBDOPEN                       =  $00000040 ;
  KR_KBDCLOSE                      =  $00000080 ;
  KR_KBDGETFOCUS                   =  $00000100 ;
  KR_KBDFREEFOCUS                  =  $00000200 ;
  KR_KBDGETCP                      =  $00000400 ;
  KR_KBDSETCP                      =  $00000800 ;
  KR_KBDXLATE                      =  $00001000 ;
  KR_KBDSETCUSTXT                  =  $00002000 ;

  IO_WAIT                          = 0;
  IO_NOWAIT                        = 1;


{**   KbdDeRegister - Deregister keyboard subsytem
 *
 *     Deregisters a keyboard subsystem previously registered within a session.
 *     Only the process that issued the KbdRegister may issue KbdDeRegister.
 *
 }

  Function KbdDeRegister: USHORT;

{ KBDKEYINFO structure, for KbdCharIn and KbdPeek                      }


Type
  KBDKEYINFO = Record
    chChar,                             { ASCII character code }
    chScan,                             { Scan Code }
    fbStatus,                           { State of the character }
    bNlsShift: UCHAR;                   { Reserved (must equal 0) }
    fsState: USHORT;                    { state of the shift keys }
    time: ULONG                         { time stamp of key stroke (ms since ipl) }
  End;
  pKBDKEYINFO = ^PKBDKEYINFO;


{**   KbdCharIn - Read character, Scan code                            }

  Function KbdCharIn (pkbci: PKBDKEYINFO;                   { structure indicated just above }
                      fWait: USHORT;                        { 0=wait for character, 1=no wait }
                      hkbd: HKBD): USHORT;      { keyboard handle                      }


{**   KbdPeek - Peek at character, scan code
 *
 *     Returns the character data record, if available, from the keyboard
 *     without removing it from the buffer.
 *
 }

  Function KbdPeek (pkbci: PKBDKEYINFO;                     { structure indicated just above }
                    hkbd: HKBD): USHORT;    { keyboard handle                      }

{ structure for KbdStringIn }


Type
  STRINGINBUF = Record
    cb,                                 { input buffer length }
    cchIn: USHORT                       { received input length }
  End;
  pSTRINGINBUF = ^PSTRINGINBUF;


{**   KbdStringIn - Read character string
 *
 *     Reads a character string
 *
 }

  Function KbdStringIn (pch: PCH;                           { buffer for the character string }
                        pchIn: PSTRINGINBUF;                { structure indicated just above }
                        fsWait: USHORT;                     { indicated if wait for character }
                        hkbd: HKBD): USHORT;  { keyboard handle                      }


{**   KbdFlushBuffer - Flush key stroke buffer
 *
 *     clears the key stroke buffer
 *
 }

  Function KbdFlushBuffer (hkbd: HKBD): USHORT;             { keyboard handle                      }

{ KBDINFO structure, for KbdSet/GetStatus }

Type
  KBDINFO = Record
    cb,                                 { length in bytes of this structure }
    fsMask,                             { bit mask of functions to be altered }
    chTurnAround,                       { define TurnAround character }
    fsInterim,                          { interim character flags }
    fsState: USHORT                     { shift states }
  End;
  pKBDINFO = ^PKBDINFO;


{**   KbdSetStatus - Set keyboard status
 *
 *     Sets the characteristics of the keyboard
 *
 }

  Function KbdSetStatus (pkbdinfo: PKBDINFO;                { data structure indicated above }
                         hkbd: HKBD): USHORT;     { keyboard handle                      }


{**   KbdGetStatus - Get keyboard status
 *
 *      Gets the current state of the keyboard.
 *
 }

  Function KbdGetStatus (pkbdinfo: PKBDINFO;                { data structure indicated above }
                         hdbd: HKBD): USHORT;    { keyboard handle                      }


{**   KbdSetCp - Set the code page
 *
 *     Allows the process to set the code page used to translate key strokes
 *     received from the keyboard.
 *
 }

  Function KbdSetCp (usReserved,                            { reserved (set to 0) }
                     pidCP: USHORT;                         { code page ID }
                     hdbd: HKBD): USHORT;         { keyboard handle                      }


{**   KbdGetCp - Get loaded code page ID's
 *
 *     Allows a process to query the code page currently in use to translate
 *     scan codes to ASCII characters.
 *
 }

  Function KbdGetCp (ulReserved: ULONG;                     { reserved (set to 0) }
                     pidCP: PUSHORT;                        { code page ID }
                     hkbd: HKBD): USHORT;        { keyboard handle                      }


{**   KbdOpen - Open a logical Keyboard
 *
 *     Creates a new logical keyboard.
 *
 }

  Function KbdOpen (phkbd: PHKBD): USHORT;           { keyboard handle                      }


{**   Kbdclose - Close a logical keyboard
 *
 *     Ends the existing logical keyboard identified by the keyboard handle.
 *
 }

  Function KbdClose (hkbd: HKBD): USHORT;              { keyboard handle                     }


{**   KbdGetFocus - Get keyboard focus
 *
 *     Binds the logical keyboard to the physical keyboard.
 *
 }

  Function KbdGetFocus (fWait: USHORT;                      { indicate if wait }
                        hkbd: HKBD): USHORT;          { keyboard handle                      }


{**   KbdFreeFocus - Free keyboard focus
 *
 *     Frees the logical to physical keyboard bond created by KbdGetFocus.
 *
 }

  Function KbdFreeFocus (hkbd: HKBD): USHORT;             { Keyboard handle                      }


{**   KbdSynch - Synchronize keyboard access
 *
 *     Synchronizes access for a keyboard subsystem to the keyboard device
 *     driver.
 *
 }

  Function KbdSynch (fsWait: USHORT): USHORT;   { indicate if wait for access to the device driver}

{** KbdSetFgnd - Set foreground keyboard priority
 *
 *   Raises the priority of the foreground keyboard's thread.
 *
 }

  Function KbdSetFgnd: USHORT;


{ structure for KbdGetHWID}

Type
  KBDHWID = Record                      { kbhw }
    cb,                                 { length in byte of the structure }
    idKbd,                              { attached keyboard's hardware id }
    usReserved1,                        { reserved (set to 0) }
    usReserved2: USHORT                 { reserved (set to 0) }
  End;
  pKBDHWID = ^PKBDHWID;

{** KbdGetHWID - Get Keyboard Hardware ID
 *
 *   Returns the attached keyboards hardware generated inentification value
 *
 }
  Function KbdGetHWID (pkbdhwid: PKBDHWID;                  { Keyboard ID structure (returned) }
                       hkbd: HKBD): USHORT;                     { keyboard handle                  }

{ structure for KbdXlate }

Type
  KBDTRANS = Record
    chChar,                             { ASCII character code }
    chScan,                             { scan code }
    fbStatus,                           { State of the character }
    bNlsShift: UCHAR;                   { shift status (reserved set to 0) }
    fsState: USHORT;                    { shift state }
    time: ULONG;
    fsDD,
    fsXlate,
    fsShift,
    sZero: USHORT
  End;
  pKBDTRANS = ^PKBDTRANS;


{**   KbdXlate - Translate scan code
 *
 *     Translates scan code and shift states into ASCII code.
 *
 }

  Function KbdXlate (pkbdtrans: PKBDTRANS;                  { Translation record (format as above) }
                     hkbd: HKBD): USHORT;      { keyboard handle                      }


{**   KbdSetCustXt - Set custom code page
 *
 *     Installs on the specified handle the code page pointed to in this call.
 *     This code page will affect only this handle.
 *
 }

  Function KbdSetCustXt (usCodePage: PUSHORT;               { Translation table }
                         hkbd: HKBD): USHORT;        { keyboard handle                      }

Type
  HVIO = SHANDLE;
  pHVIO = ^PHVIO;

{ first parameter registration constants }

Const
  VR_VIOGETCURPOS         =  $00000001 ;
  VR_VIOGETCURTYPE                 =  $00000002 ;
  VR_VIOGETMODE                    =  $00000004 ;
  VR_VIOGETBUF                     =  $00000008 ;
  VR_VIOGETPHYSBUF                 =  $00000010 ;
  VR_VIOSETCURPOS                  =  $00000020 ;
  VR_VIOSETCURTYPE                 =  $00000040 ;
  VR_VIOSETMODE                    =  $00000080 ;
  VR_VIOSHOWBUF                    =  $00000100 ;
  VR_VIOREADCHARSTR                =  $00000200 ;
  VR_VIOREADCELLSTR                =  $00000400 ;
  VR_VIOWRTNCHAR                   =  $00000800 ;
  VR_VIOWRTNATTR                   =  $00001000 ;
  VR_VIOWRTNCELL                   =  $00002000 ;
  VR_VIOWRTTTY                     =  $00004000 ;
  VR_VIOWRTCHARSTR                 =  $00008000 ;

  VR_VIOWRTCHARSTRATT              =  $00010000 ;
  VR_VIOWRTCELLSTR                 =  $00020000 ;
  VR_VIOSCROLLUP                   =  $00040000 ;
  VR_VIOSCROLLDN                   =  $00080000 ;
  VR_VIOSCROLLLF                   =  $00100000 ;
  VR_VIOSCROLLRT                   =  $00200000 ;
  VR_VIOSETANSI                    =  $00400000 ;
  VR_VIOGETANSI                    =  $00800000 ;
  VR_VIOPRTSC                      =  $01000000 ;
  VR_VIOSCRLOCK                    =  $02000000 ;
  VR_VIOSCRUNLOCK                  =  $04000000 ;
  VR_VIOSAVREDRAWWAIT              =  $08000000 ;
  VR_VIOSAVREDRAWUNDO              =  $10000000 ;
  VR_VIOPOPUP                      =  $20000000 ;
  VR_VIOENDPOPUP                   =  $40000000 ;
  VR_VIOPRTSCTOGGLE                =  $80000000 ;

{ second parameter registration constants }
  VR_VIOMODEWAIT                   =  $00000001 ;
  VR_VIOMODEUNDO                   =  $00000002 ;
  VR_VIOGETFONT                    =  $00000004 ;
  VR_VIOGETCONFIG                  =  $00000008 ;
  VR_VIOSETCP                      =  $00000010 ;
  VR_VIOGETCP                      =  $00000020 ;
  VR_VIOSETFONT                    =  $00000040 ;
  VR_VIOGETSTATE                   =  $00000080 ;
  VR_VIOSETSTATE                   =  $00000100 ;


{**   VioRegister - Register video subsystem
 *
 *     Registers an alternate video subsystem within a session.
 *
 }

  Function VioRegister (pszModName,                         { dynamic link module name }
                        pszEntryName: PSZ;                  { entry point name }
                        flFun1,                             { bit mask (each bit id's a video function }
                        flFun2: ULONG): USHORT;         { bit mask (each bit id's a video function }

{**   VioDeRegister - DeRegister video subsystem
 *
 *     Deregisters a video subsystem previously registered within a session.
 *     VioDeRegister must be issued by the same process that issued the
 *     previous VioRegister. After VioDeRegister is issued, subsequent video
 *     calls are processed by the base video subsystem.
 *
 }

  Function VioDeRegister: USHORT;


{**   VioGlobalReg - Register video subsystem for all fullscreen sessions
 *
 *     Registers an alternate video subsystem for all fullscreen sessions.
 *
 }

  Function VioGlobalReg (pszModName,                        { dynamic link module name }
                         pszEntryName: PSZ;                 { entry point name }
                         flFun1,                            { bit mask (each bit id's a video function }
                         flFun2: ULONG;                     { bit mask (each bit id's a video function }
                         viorsvd: LongInt): USHORT;          { reserved, must be 0                      }

{**   VioGetBuf - Get Logical video buffer address
 *
 *     VioGetBuf returns the address of the logical video buffer
 *
 }

  Function VioGetBuf (pLVB: PULONG;                         { pointer to logical video buffer }
                      pcbLVB: PUSHORT;                      { length of buffer }
                      hvio: HVIO): USHORT;       { vio handle                           }


{**   VioGetCurPos - Get cursor position
 *
 *     Returns the cursor position.
 *
 }

  Function VioGetCurPos (pusRow,                            { Current row position of cursor }
                         pusColumn: PUSHORT;                { current column position of cursor }
                         hvio: HVIO): USHORT;      { vio handle                           }


{**   VioSetCurPos - Set cursor position
 *
 *     Sets the cursor position.
 *
 }

  Function VioSetCurPos (usRow,                             { new cursor row position }
                         usColumn: USHORT;                  { new cursor column position }
                         hvio: HVIO): USHORT;          { video handle                         }

{ structure for VioSet/GetCurType }

Type
  VIOCURSORINFO = Record
    yStart,                             { cursor start line }
    cEnd,                               { cursor end line }
    cx,                                 { cursor width }
    attr: USHORT                        { -1=hidden cursor, any other=normal cursor }
  End;
  pVIOCURSORINFO = ^PVIOCURSORINFO;


{**   VioGetCurType - Get cursor type
 *
 *     Returns the cursor type.
 *
 }

  Function VioGetCurType (pvioCursorInfo: PVIOCURSORINFO;   { structure indicated above (returned) }
                          hvio: HVIO): USHORT;         { Vio handle                           }


{**   VioSetCurType - Set the cursor type
 *
 *     Sets the cursor type
 *
 }

  Function VioSetCurType (pvioCursorInfo: PVIOCURSORINFO;   { structure indicated just above }
                          hvio: HVIO): USHORT;         { video handle                   }

{ structure for VioSet/GetMode }

Type
  VIOMODEINFO = Record
    cb: USHORT;                         { length of the entire data structure }
    fbType,                             { bit mask of mode being set }
    color: UCHAR;                       { number of colors (power of 2) }
    col,                                { number of text columns }
    row,                                { number of text rows }
    hres,                               { horizontal resolution }
    vres: USHORT;                       { vertical resolution }
    fmt_ID,                             { attribute format }
    attrib: UCHAR;                      { number of attributes }
    buf_addr,
    buf_length,
    full_length,
    partial_length: ULONG;
    ext_data_addr: PCH
  End;
  pVIOMODEINFO = ^PVIOMODEINFO;


Const
  VGMT_OTHER              =  $01;
  VGMT_GRAPHICS                    =  $02;
  VGMT_DISABLEBURST                =  $04;


{**   VioGetMode - Get display mode                                    }

  Function VioGetMode (pvioModeInfo: PVIOMODEINFO;          { structure defined above (returned) }
                       hvio: HVIO): USHORT;         { vio handle                           }


{**   VioSetMode - Set display mode                                    }

  Function VioSetMode (pvioModeInfo: PVIOMODEINFO;          { structure defined just above }
                       hvio: HVIO): USHORT;         { video handle                    }

{ structure for VioGetPhysBuf }


Type
  VIOPHYSBUF = Record
    pBuf: PBYTE;                        { Buffer start address }
    cb: ULONG;                          { buffer length }
    asel: Array[0..0] Of SEL            { selector list }
  End;
  pVIOPHYSBUF = ^PVIOPHYSBUF;


{**   VioGetPhysBuf - Get physical display buffer
 *
 *     Gets addressability to the physical display buffer.
 *
 }

  Function VioGetPhysBuf (pvioPhysBuf: PVIOPHYSBUF;         { Data structure defined above }
                          usReserved: USHORT): USHORT;  { reserved (must be 0)               }


{**   VioReadCelStr - Read char/attr string
 *
 *     Reads a string of character-attribute pairs
 *     starting at the specified location.
 *
 }

  Function VioReadCellStr (pchCellStr: PCH;                 { Cell string buffer }
                           pcb: PUSHORT;                    { length of cell string buffer }
                           usRow,                           { starting row location }
                           usColumn: USHORT;                { starting column location }
                           hvio: HVIO): USHORT;       { video handle                         }


{**   VioReadCharStr - Read character string
 *
 *     Reads a character string from the display starting at the specified
 *     location.
 *
 }

  Function VioReadCharStr (pchCellStr: PCH;                 { character buffer }
                           pcb: PUSHORT;                    { length of buffer }
                           usRow,                           { starting row location }
                           usColumn: USHORT;                { starting column location }
                           hvio: HVIO): USHORT;       { video handle                         }


{**   VioWrtCellStr - Write char/attr string
 *
 *     Writes a string of character-attribute pairs
 *
 }

  Function VioWrtCellStr (pchCellStr: PCH;                  { string to be written }
                          cb,                               { length of string }
                          usRow,                            { starting row position for output }
                          usColumn: USHORT;                 { starting column position for output }
                          hvio: HVIO): USHORT;        { video handle                         }


{**   VioWrtCharStr - Write character string to display                }

  Function VioWrtCharStr (pchStr: PCH;                      { string to be written }
                          cb,                               { length of string }
                          usRow,                            { starting row position for output }
                          usColumn: USHORT;                 { starting column position for output }
                          hvio: HVIO): USHORT;        { video handle                         }


{**   VioScrollDn - Scroll screen down
 *
 *     Scrolls the entire display buffer
 *     buffer) down.
 *
 }

  Function VioScrollDn (usTopRow,                           { Top row of the area to scroll }
                        usLeftCol,                          { left column of the area to scroll }
                        usBotRow,                           { bottom row of the area to scroll }
                        usRightCol,                         { right column of the area to scroll }
                        cbLines: USHORT;                    { number of lines to be inserted at top of screen }
                        pCell: PBYTE;                       { fill character on inserted lines }
                        hvio: HVIO): USHORT;     { video handle                                   }



{**   VioScrollUp - Scroll screen up                                   }

  Function VioScrollUp (usTopRow,                           { Top row of the area to scroll }
                        usLeftCol,                          { left column of the area to scroll }
                        usBotRow,                           { bottom row of the area to scroll }
                        usRightCol,                         { right column of the area to scroll }
                        cbLines: USHORT;                    { number of lines to be inserted at bottom of screen }
                        pCell: PBYTE;                       { fill character on inserted lines }
                        hvio: HVIO): USHORT;         { video handle                               }


{**   VioScrollLf - Scroll screen left                                       }

  Function VioScrollLf (usTopRow,                           { Top row of the area to scroll }
                        usLeftCol,                          { left column of the area to scroll }
                        usBotRow,                           { bottom row of the area to scroll }
                        usRightCol,                         { right column of the area to scroll }
                        cbCol: USHORT;                      { number of columns to be inserted at right of screen }
                        pCell: PBYTE;                       { fill character on inserted lines }
                        hvio: HVIO): USHORT;         { video handle                               }


{**   VioScrollRt - Scroll screen right                                      }

  Function VioScrollRt (usTopRow,                           { Top row of the area to scroll }
                        usLeftCol,                          { left column of the area to scroll }
                        usBotRow,                           { bottom row of the area to scroll }
                        usRightCol,                         { right column of the area to scroll }
                        cbCol: USHORT;                      { number of columns to be inserted at left of screen }
                        pCell: PBYTE;                       { fill character on inserted lines }
                        hvio: HVIO): USHORT;           { video handle                             }


{**   VioWrtNAttr - Write n attributes
 *
 *     Writes an attribute to the display a specified number of times.
 *
 }

  Function VioWrtNAttr (pAttr: PBYTE;                       { Attribute to be written }
                        cb,                                 { repeat count }
                        usRow,                              { starting row position for output }
                        usColumn: USHORT;                   { starting column postion for output }
                        hvio: HVIO): USHORT;       { video handle                         }


{**   VioWrtNCell - Write n char/attr
 *
 *     Writes a cell
 *     number of times.
 *
 }

  Function VioWrtNCell (pCell: PBYTE;                       { cell to be written }
                        cb,                                 { repeat count }
                        usRow,                              { starting row position for output }
                        usColumn: USHORT;                   { starting column postion for output }
                        hvio: HVIO): USHORT;         { video handle                         }


{**   VioWrtNChar - Write a character to the display a specified number of
 *                   times
 }

  Function VioWrtNChar (pchChar: PCH;                       { character to be written }
                        cb,                                 { repeat count }
                        usRow,                              { starting row position for output }
                        usColumn: USHORT;                   { starting column postion for output }
                        hvio: HVIO): USHORT;         { video handle                         }


{**   VioWrtTTY - Write TTY string
 *
 *     Writes a character string to the display starting at the current cursor
 *     position. At the completion of the write, the cursor is positioned at the
 *     first position beyond the end of the string
 *
 }

  Function VioWrtTTY (pch: PCH;                             { String to be written }
                      cb: USHORT;                           { length of string }
                      hvio: HVIO): USHORT;         { video handle                         }


{**   VioWrtCharStrAtt - Write character string with repeated attribute to the
 *                        display.
 }

  Function VioWrtCharStrAtt (pch: PCH;                      { string to be written }
                             cb,                            { length of string }
                             usRow,                         { starting row position for output }
                             usColumn: USHORT;              { starting column position for output }
                             pAttr: PBYTE;                  { attribute to be replicated }
                             hvio: HVIO): USHORT;      { video handle                         }


{**   VioShowBuf - updates the physical display buffer with the logical video
 *                  buffer.
 }

  Function VioShowBuf (offLVB,                              { offset into the logical video buffer }
                       cb: USHORT;                          { length of the area to be updated to the screen }
                       hvio: HVIO): USHORT;   { video handle                                   }



Const
  ANSI_ON                 = 1;
  ANSI_OFF                         = 0;


{**   VioSetAnsi - Activates or deactivates ansi support               }

  Function VioSetAnsi (fAnsi: USHORT;                       { 0=deactivate ansi, 1=activate ansi }
                       hvio: HVIO): USHORT;        { video handle                         }


{**   VioGetAnsi - Get the ansi On/Off status                          }

  Function VioGetAnsi (pfAnsi: PUSHORT;                     { 0=ansi inactive, 1=ansi active }
                       hvio: HVIO): USHORT;        { vio handle                           }


{**   VioPrtSc - Copies the screen to the printer                      }

  Function VioPrtSc (hvio: HVIO): USHORT;             { vio handle                           }


{**   VioPrtScToggle - Toggle print screen
 *
 *     Called by the session manager when the operator presses Ctrl_PrtSc.
 *
 }

  Function VioPrtScToggle (hvio: HVIO): USHORT;             { vio handle                           }


Const
  VSRWI_SAVEANDREDRAW     = 0;
  VSRWI_REDRAW                     = 1;

  VSRWN_SAVE                       = 0;
  VSRWN_REDRAW                     = 1;

  UNDOI_GETOWNER                   = 0;
  UNDOI_RELEASEOWNER               = 1;

  UNDOK_ERRORCODE                  = 0;
  UNDOK_TERMINATE                  = 1;


{**   VioSavRedrawWait - Screen save redraw wait
 *
 *     Notifies a graphics mode application when it must save or redraw its
 *     screen image. The return from this function call provides the
 *     notification. The thread that issues the call performs the save or redraw
 *     and then re-issues VioSavRedrawWait to wait until its screen image must
 *     be saved or redrawn again.
 *
 }

  Function VioSavRedrawWait (usRedrawInd: USHORT;           { 0=Save and redraw, 1=redraw only }
                             pNotifyType: PUSHORT;          { 0=save screen image, 1=restore screen image }
                             usReserved: USHORT): USHORT;  { video handle (must be zero )                }


{**   VioSavRedrawUndo - Screen save redraw undo
 *
 *     Allows one thread within a process to cancel a VioSavRedrawWait issued by
 *     another thread within the same process.
 *
 }

  Function VioSavRedrawUndo (usOwnerInd,                    { 0=reserve ownership, 1=give up ownership }
                             usKillInd,                     { 0=return error code, 1=terminate thread }
                             usReserved: USHORT): USHORT;  { video handle (must be zero)              }


Const
  VMWR_POPUP              = 0;
  VMWN_POPUP                       = 0;


{**   VioModeWait - Restore mode wait
 *
 *     Allows a graphics mode application to be notified when it must restore
 *     its video mode, state, and modified display adapter registers. The return
 *     from this function call provides the notification.
 *
 }

  Function VioModeWait (usReqType: USHORT;                  { request type }
                        pNotifyType: PUSHORT;               { notify type (returned) }
                        usReserved: USHORT): USHORT;  { reserved (must be 0)                 }


{**   VioModeUndo - Restore mode undo
 *
 *     Allows one thread within a process to cancel a VioModeWait issued by
 *     another thread within the same process.
 *
 }

  Function VioModeUndo (usOwnerInd,                         { 0=reserve ownership, 1=give up ownership }
                        usKillInd,                          { 0=return error code, 1=terminate thread }
                        usReserved: USHORT): USHORT;  { video handle                             }


Const
  LOCKIO_NOWAIT           = 0;
  LOCKIO_WAIT                      = 1;

  LOCK_SUCCESS                     = 0;
  LOCK_FAIL                        = 1;


{**   VioScrLock - Lock screen - requests ownership of
 *                  display buffer
 }

  Function VioScrLock (fWait: USHORT;                       { 0=return if screen unavailable, 1=wait }
                       pfNotLocked: PUCHAR;                 { lock status (returned) }
                       hvio: HVIO): USHORT;      { video handle                           }


{**   VioScrUnLock - Unlock screen - releases ownership
 *                    physical display buffer.
 }

  Function VioScrUnLock (hvio: HVIO): USHORT;        { video handle                         }


Const
  VP_NOWAIT               =  $0000;
  VP_WAIT                          =  $0001;
  VP_OPAQUE                        =  $0000;
  VP_TRANSPARENT                   =  $0002;

{** VioPopUp - Allocate a pop-up display screen
 *
 * This call is issued by an application process when it requires a temporary
 * screen to display a momentary message to the user.
 *
 }

  Function VioPopUp (pfWait: PUSHORT;                       { Option flags }
                     hvio: HVIO): USHORT;        { Vio handle                           }


{**   VioEndPopUp - Deallocate pop-up display screen
 *
 *     Issued by the application when it no longer requires the temporary screen
 *     obtained through a previous VioPopUp call.
 *
 }

  Function VioEndPopUp (hvio: HVIO): USHORT;            { vio device handle                    }

{ structure for VioGetConfig }
Type
  VIOCONFIGINFO = Record
    cb,                                 { length of this data structure }
    adapter,                            { display adapter type }
    display: USHORT;                    { display/monitor type }
    cbMemory: ULONG;                    { amount of memory on the adapter in bytes }
    Configuration,
    VDHVersion,
    Flags: USHORT;
    HWBufferSize,
    FullSaveSize,
    PartSaveSize: ULONG;
    EMAdaptersOFF,
    EMDisplaysOFF: USHORT
  End;
  pVIOCONFIGINFO = ^PVIOCONFIGINFO;


{**   VioGetConfig - get video display configuration                   }

  Function VioGetConfig (usConfigId: USHORT;                { Reserved (must be 0) }
                         pvioin: PVIOCONFIGINFO;            { structure defined above }
                         hvio: HVIO): USHORT;      { vio handle                       }

{ structure for VioGet/SetFont }
Type
  VIOFONTINFO = Record                  { viofi }
    cb,                                 { length of this structure }
    _type,                               { request type }
    cxCell,                             { pel columns in character cell }
    cyCell: USHORT;                     { pel rows in character cell }
    pbData: PVOID;                      { requested font table (returned) }
    cbData: USHORT                      { length of caller supplied data area (in bytes) }
  End;
  pVIOFONTINFO = ^PVIOFONTINFO;


Const
  VGFI_GETCURFONT         = 0;
  VGFI_GETROMFONT                  = 1;


{**   VioGetFont - Returns either the font table of the size specified, or the
 *                  font currently in use.
 }

  Function VioGetFont (pviofi: PVIOFONTINFO;                { data structure defined above }
                       hvio: HVIO): USHORT;   { vio handle                           }


{**   VioSetFont - Set font
 *
 *     Downloads a display font. The font being set must be compatible with the
 *     current mode.
 *
 }

  Function VioSetFont (pviofi: PVIOFONTINFO;                { data structure defined just above }
                       hvio: HVIO): USHORT;  { video handle                         }


{**   VioGetCp - Get code page
 *
 *     Allows a process to query the code page currently used to display text
 *     data.
 *
 }

  Function VioGetCp (usReserved: USHORT;                    { reserved (zero's) }
                     pIdCodePage: PUSHORT;                  { code page ID }
                     hvio: HVIO): USHORT;       { video handle                         }


{**   VioSetCp - Set code page
 *
 *     Allows a process to set the code page used to display text data on the
 *     screen.
 *
 }

  Function VioSetCp (usReserved,                            { reserved (zero's) }
                     idCodePage: USHORT;                    { code page id }
                     hvio: HVIO): USHORT;        { video handle                         }


Type
  VIOPALSTATE = Record
    cb,                                 { length of this structure in bytes }
    _type,                               { request type=0 get palette registers }
    iFirst,                             { first palette register to return }
    acolor: Array[0..0] Of USHORT                   { color value pallete register }
  End;
  pVIOPALSTATE = ^PVIOPALSTATE;

  VIOOVERSCAN = Record
    cb,                                 { length of this structure }
    _type,                               { request type=1 get overscan (border) color }
    color: USHORT                       { color value }
  End;
  pVIOOVERSCAN = ^PVIOOVERSCAN;

  VIOINTENSITY = Record
    cb,                                 { length of this structure }
    _type,                               { request type=2 get blink/background intensity switch }
    fs: USHORT                          { value of blink/background switch }
  End;
  pVIOINTENSITY = ^PVIOINTENSITY;


  VIOCOLORREG = Record                  { viocreg }
    cb,
    _type,
    firstcolorreg,
    numcolorregs: USHORT;
    colorregaddr: PCH
  End;
  pVIOCOLORREG = ^PVIOCOLORREG;

  VIOSETULINELOC = Record               { viouline }
    cb,
    _type,
    scanline: USHORT
  End;
  pVIOSETULINELOC = ^VIOSETULINELOC;

  VIOSETTARGET = Record                 { viosett }
    cb,
    _type,
    defaultalgorithm: USHORT
  End;
  pVIOSETTARGET = ^VIOSETTARGET;


{**   VioGetState - Get video state
 *
 *     Returns the current settings of the palette registers, overscan
 *     color or blink/background intensity switch.
 *
 }


  Function VioGetState (pState: PVOID;                      { one of the 3 structures defined above }
                        hvio: HVIO): USHORT;        { vio handle                            }


{**   VioSetState - Set video state
 *
 *     Performs one of the following functions, sets paletted registers, sets
 *     the overscan
 *
 }


  Function VioSetState (pState: PVOID;                      { one of the 3 structures defined above }
                        hvio: HVIO): USHORT;        { video handle                         }

Type
  HMOU = SHANDLE;
  pHMOU = ^HMOU;

Const
  MR_MOUGETNUMBUTTONS     =  $00000001 ;
  MR_MOUGETNUMMICKEYS              =  $00000002 ;
  MR_MOUGETDEVSTATUS               =  $00000004 ;
  MR_MOUGETNUMQUEEL                =  $00000008 ;
  MR_MOUREADEVENTQUE               =  $00000010 ;
  MR_MOUGETSCALEFACT               =  $00000020 ;
  MR_MOUGETEVENTMASK               =  $00000040 ;
  MR_MOUSETSCALEFACT               =  $00000080 ;
  MR_MOUSETEVENTMASK               =  $00000100 ;
  MR_MOUOPEN                       =  $00000800 ;
  MR_MOUCLOSE                      =  $00001000 ;
  MR_MOUGETPTRSHAPE                =  $00002000 ;
  MR_MOUSETPTRSHAPE                =  $00004000 ;
  MR_MOUDRAWPTR                    =  $00008000 ;
  MR_MOUREMOVEPTR                  =  $00010000 ;
  MR_MOUGETPTRPOS                  =  $00020000 ;
  MR_MOUSETPTRPOS                  =  $00040000 ;
  MR_MOUINITREAL                   =  $00080000 ;
  MR_MOUSETDEVSTATUS               =  $00100000 ;

{**   MouRegister - Register a mouse subsystem within a session.       }

  Function MouRegister (pszModName,                         { Dynamic link module name }
                        pszEntryName: PSZ;                  { dynamic link entry point }
                        flFuns: ULONG): USHORT; { bit mask (each bit represents a mouse function) }

{**   MouDeRegister - Deregister a mouse subsystem                     }

  Function MouDeRegister: USHORT;


{**   MouFlushQue - flush the mouse event queue for this session
 *
 *     Directs the mouse driver to flush
 *     session
 *
 }

  Function MouFlushQue (hmou: HMOU): USHORT;            { Mouse device handle }



Const
  MHK_BUTTON1             =  $0001;
  MHK_BUTTON2                      =  $0002;
  MHK_BUTTON3                      =  $0004;

{ structure for MouGet/SetPtrPos }
Type
  PTRLOC = Record
    row,                                { pointer row coordinate screen position }
    col: USHORT                         { pointer column coordinate screen position }
  End;
  pPTRLOC = ^PTRLOC;


{**   MouGetPtrPos - Query mouse pointer position
 *
 *     Queries the mouse driver to determine the current row and column
 *     coordinate position of the mouse pointer shape.
 *
 }

  Function MouGetPtrPos (pmouLoc: PPTRLOC;                  { pointer to structure indicated above }
                         hmou: HMOU): USHORT;        { mouse device handle                  }


{**   MouSetPtrPos - Set mouse pointer position
 *
 *     Directs the mouse driver to set a new current row and column coordinate
 *     position for the mouse pointer shape.
 *
 }

  Function MouSetPtrPos (pmouLoc: PPTRLOC;                  { pointer to structure indicated above }
                         hmou: HMOU): USHORT;        { mouse device handle                  }

{ structure for MouGet/SetPtrShape }

Type
  PTRSHAPE = Record
    cb,                                 { total length necessary to build image }
    col,                                { # of columns in mouse shape }
    row,                                { number of rows in mouse shape }
    colHot,                             { column coordinate of pointer image hotspot }
    rowHot: USHORT                      { row coordinate of pointer image hotspot }
  End;
  pPTRSHAPE = ^PTRSHAPE;


{**   MouSetPtrShape - Set mouse pointer shape
 *
 *     Allows a process to set the pointer shape and size to be used as the
 *     mouse device driver pointer image for all applications in a session.
 *
 }

  Function MouSetPtrShape (pBuf: PBYTE;                     { bit image of the pointer shape }
                           pmoupsInfo: PPTRSHAPE;           { pointer to structure defined above }
                           hmou: HMOU): USHORT;       { mouse device handle                  }


{**   MouGetPtrShape - Get pointer shape
 *
 *     Allows a process to get
 *
 }

  Function MouGetPtrShape (pBuf: PBYTE;                     { pointer bit image (returned) }
                           pmoupsInfo: PPTRSHAPE;           { pointer to structure defined above }
                           hmou: HMOU): USHORT;       { mouse device handle                  }


{**   MouGetDevStatus - Get mouse device status
 *
 *     Returns status flags for the mouse device driver currently installed.
 *
 }

  Function MouGetDevStatus (pfsDevStatus: PUSHORT;          { current status flags }
                            hmou: HMOU): USHORT;        { mouse device handle                  }


{**   MouGetNumButtons - Get number of mouse buttons
 *
 *     Returns the number of buttons supported on the mouse driver currently
 *     installed.
 *
 }

  Function MouGetNumButtons (pcButtons: PUSHORT;            { number of mouse buttons }
                             hmou: HMOU): USHORT;        { mouse device handle                  }


{**   MouGetNumMickeys - Get number of mouse mickeys
 *
 *     Returns the number of mickeys per centimeter for the mouse driver
 *     currently installed.
 *
 }

  Function MouGetNumMickeys (pcMickeys: PUSHORT;            { number of mickeys per centimeter }
                             hmou: HMOU): USHORT;        { mouse device handle                  }

{ structure for MouReadEventQue }
Type
  MOUEVENTINFO = Record
    fs: USHORT;                         { State of mouse at the time the event was reported }
    time: ULONG;                        { time since boot in milliseconds }
    row,                                { absolute/relative row position }
    col: USHORT                         { absolute/relative column position }
  End;
  pMOUEVENTINFO = ^MOUEVENTINFO;


{**   MouReadEventQue - read mouse event queue
 *
 *     Reads an event from the mouse device FIFO event queue, and places it in
 *     a structure provided by the application.
 *
 }

  Function MouReadEventQue (pmouevEvent: PMOUEVENTINFO;     { pointer to structure defined above }
                            pfWait: PUSHORT;                { 0=no wait for data, 1= wait for data }
                            hmou: HMOU): USHORT;       { mouse device handle                  }

{ structure for MouGetNumQueEl }

Type
  MOUQUEINFO = Record
    cEvents,                            { current number of event queue elements }
    cmaxEvents: USHORT                  { MaxNumQueElements value }
  End;
  pMOUQUEINFO = ^MOUQUEINFO;


{**   MouGetNumQueEl - Get Event queue status
 *
 *     Returns the current status for the mouse device driver event queue.
 *
 }

  Function MouGetNumQueEl (qmouqi: PMOUQUEINFO;             { pointer to structure defined above }
                           hmou: HMOU): USHORT;    { mouse device handle                  }


{**   MouGetEventMask - Get the current value of the mouse event queue mask}

  Function MouGetEventMask (pfsEvents: PUSHORT;             { current mouse event mask (returned) }
                            hmou: HMOU): USHORT;        { mouse device handle                  }


{**   MouSetEventMask - Assign a new event mask to the current mouse device
 *                       driver.
 }

  Function MouSetEventMask (pfsEvents: PUSHORT;             { mouse event mask }
                            hmou: HMOU): USHORT;        { mouse device handle                  }

{ structure for MouGet/SetScaleFact }

Type
  SCALEFACT = Record
    rowScale,                           { row scaling factor }
    colScale: USHORT                    { column coordinate scaling factor }
  End;
  pSCALEFACT = ^SCALEFACT;


{**   MouGetScaleFact - Get mouse scaling factors.                     }

  Function MouGetScaleFact (pmouscFactors: PSCALEFACT;      { pointer to structure indicated above }
                            hmou: HMOU): USHORT;        { mouse device handle                  }


{**   MouSetScaleFact - Set mouse scaling factor.                      }

  Function MouSetScaleFact (pmouscFactors: PSCALEFACT;      { pointer to structure indicated above }
                            hmou: HMOU): USHORT;        { mouse device handle                  }


{**   MouOpen - Open the mouse device for the current session.         }

  Function MouOpen (pszDvrname: PSZ;                        { pointer to name of mouse draw device driver }
                    phmou: PHMOU): USHORT;      { mouse device handle                         }


{**   MouClose - Close the mouse device for the current session.}

  Function MouClose (hmou: HMOU): USHORT;            { mouse device handle                  }


{ structure for MouRemovePtr }
Type
  NOPTRRECT = Record
    row,                                { upper left row coodinates }
    col,                                { upper left column coodinates }
    cRow,                               { Lower right row coordinates }
    cCol: USHORT                        { Lower right column coordinates }
  End;
  pNOPTRRECT = ^NOPTRRECT;


{**   MouRemovePtr - Remove mouse pointer
 *
 *     Allows a process to notify the mouse device driver that the area defined
 *     by the passed parameters is for the exclusive use of the application.
 *     This area is defined as the 'collision' area and is not available to the
 *     mouse device driver when drawing pointer images.
 *
 }

  Function MouRemovePtr (pmourtRect: PNOPTRRECT;            { Address of pointer data block }
                         hmou: HMOU): USHORT;      { mouse device handle                  }


{**   MouDrawPtr - Mouse draw pointer
 *
 *     Allows a process to notify the mouse device driver that an area
 *     previously restricted to the pointer image is now available to the mouse
 *     device driver.
 *
 }

  Function MouDrawPtr (hmou: HMOU): USHORT;            { mouse device handle                  }


Const
  MOU_NODRAW              =  $0001;
  MOU_DRAW                         =  $0000;
  MOU_MICKEYS                      =  $0002;
  MOU_PELS                         =  $0000;


{**   MouSetDevStatus - Set mouse device status
 *
 *     Sets the mouse device driver status flags for the mouse device driver
 *     currently installed. The status flags are a 2 byte set of bit flags.
 *
 }

  Function MouSetDevStatus (pfsDevStatus: PUSHORT;          { mouse device status flags }
                            hmou: HMOU): USHORT;        { mouse device handle                  }


{**   MouInitReal - Initialize the DOS mode mouse device driver        }

  Function MouInitReal (Par1: PSZ): USHORT;                  { pointer to name of mouse draw driver }

{** MouSynch - Get synchronous access
 *
 *   Provides synchronous access for a mouse subsystem to the mouse device
 *   driver.
 *
 }

  Function MouSynch (pszDvrName: USHORT): USHORT;    { Indicate wait/no wait              }

Implementation
  Function KbdCharIn;                     External 'KBDCALLS' Index    4;
  Function KbdClose;                      External 'KBDCALLS' Index   17;
  Function KbdDeRegister;                 External 'KBDCALLS' Index   20;
  Function KbdFlushBuffer;                External 'KBDCALLS' Index   13;
  Function KbdFreeFocus;                  External 'KBDCALLS' Index   18;
  Function KbdGetCp;                      External 'KBDCALLS' Index    3;
  Function KbdGetFocus;                   External 'KBDCALLS' Index   12;
  Function KbdGetHWID;                    External 'KBDCALLS' Index   24;
  Function KbdGetStatus;                  External 'KBDCALLS' Index   10;
  Function KbdOpen;                       External 'KBDCALLS' Index   23;
  Function KbdPeek;                       External 'KBDCALLS' Index   22;
  Function KbdRegister;                   External 'KBDCALLS' Index    8;
  Function KbdSetCp;                      External 'KBDCALLS' Index    5;
  Function KbdSetCustXt;                  External 'KBDCALLS' Index    1;
  Function KbdSetFgnd;                    External 'KBDCALLS' Index   21;
  Function KbdSetStatus;                  External 'KBDCALLS' Index   11;
  Function KbdStringIn;                   External 'KBDCALLS' Index    9;
  Function KbdSynch;                      External 'KBDCALLS' Index    7;
  Function KbdXlate;                      External 'KBDCALLS' Index   14;
  Function MouClose;                      External 'MOUCALLS' Index    9;
  Function MouDeRegister;                 External 'MOUCALLS' Index   14;
  Function MouDrawPtr;                    External 'MOUCALLS' Index   26;
  Function MouFlushQue;                   External 'MOUCALLS' Index    7;
  Function MouGetDevStatus;               External 'MOUCALLS' Index   22;
  Function MouGetEventMask;               External 'MOUCALLS' Index   15;
  Function MouGetNumButtons;              External 'MOUCALLS' Index    8;
  Function MouGetNumMickeys;              External 'MOUCALLS' Index    3;
  Function MouGetNumQueEl;                External 'MOUCALLS' Index   13;
  Function MouGetPtrPos;                  External 'MOUCALLS' Index   19;
  Function MouGetPtrShape;                External 'MOUCALLS' Index    1;
  Function MouGetScaleFact;               External 'MOUCALLS' Index    6;
  Function MouInitReal;                   External 'MOUCALLS' Index   27;
  Function MouOpen;                       External 'MOUCALLS' Index   17;
  Function MouReadEventQue;               External 'MOUCALLS' Index   20;
  Function MouRegister;                   External 'MOUCALLS' Index   24;
  Function MouRemovePtr;                  External 'MOUCALLS' Index   18;
  Function MouSetDevStatus;               External 'MOUCALLS' Index   25;
  Function MouSetEventMask;               External 'MOUCALLS' Index   16;
  Function MouSetPtrPos;                  External 'MOUCALLS' Index   21;
  Function MouSetPtrShape;                External 'MOUCALLS' Index    2;
  Function MouSetScaleFact;               External 'MOUCALLS' Index   11;
  Function MouSynch;                      External 'MOUCALLS' Index   23;
  Function VioDeRegister;                 External 'VIOCALLS' Index    6;
  Function VioEndPopUp;                   External 'VIOCALLS' Index    1;
  Function VioGetAnsi;                    External 'VIOCALLS' Index    3;
  Function VioGetBuf;                     External 'VIOCALLS' Index   31;
  Function VioGetConfig;                  External 'VIOCALLS' Index   46;
  Function VioGetCp;                      External 'VIOCALLS' Index   40;
  Function VioGetCurPos;                  External 'VIOCALLS' Index    9;
  Function VioGetCurType;                 External 'VIOCALLS' Index   27;
  Function VioGetFont;                    External 'VIOCALLS' Index   29;
  Function VioGetMode;                    External 'VIOCALLS' Index   21;
  Function VioGetPhysBuf;                 External 'VIOCALLS' Index    2;
  Function VioGetState;                   External 'VIOCALLS' Index   49;
  Function VioGlobalReg; Begin UnKnown('VioGlobalReg','BseSub') End;
  Function VioModeUndo;                   External 'VIOCALLS' Index   35;
  Function VioModeWait;                   External 'VIOCALLS' Index   37;
  Function VioPopUp;                      External 'VIOCALLS' Index   11;
  Function VioPrtSc;                      External 'VIOCALLS' Index    8;
  Function VioPrtScToggle;                External 'VIOCALLS' Index   50;
  Function VioReadCellStr;                External 'VIOCALLS' Index   24;
  Function VioReadCharStr;                External 'VIOCALLS' Index   30;
  Function VioRegister;                   External 'VIOCALLS' Index   45;
  Function VioSavRedrawUndo;              External 'VIOCALLS' Index   28;
  Function VioSavRedrawWait;              External 'VIOCALLS' Index   25;
  Function VioScrLock;                    External 'VIOCALLS' Index   23;
  Function VioScrUnLock;                  External 'VIOCALLS' Index   18;
  Function VioScrollDn;                   External 'VIOCALLS' Index   47;
  Function VioScrollLf;                   External 'VIOCALLS' Index   44;
  Function VioScrollRt;                   External 'VIOCALLS' Index   12;
  Function VioScrollUp;                   External 'VIOCALLS' Index    7;
  Function VioSetAnsi;                    External 'VIOCALLS' Index    5;
  Function VioSetCp;                      External 'VIOCALLS' Index   42;
  Function VioSetCurPos;                  External 'VIOCALLS' Index   15;
  Function VioSetCurType;                 External 'VIOCALLS' Index   32;
  Function VioSetFont;                    External 'VIOCALLS' Index   33;
  Function VioSetMode;                    External 'VIOCALLS' Index   22;
  Function VioSetState;                   External 'VIOCALLS' Index   51;
  Function VioShowBuf;                    External 'VIOCALLS' Index   43;
  Function VioWrtCellStr;                 External 'VIOCALLS' Index   10;
  Function VioWrtCharStr;                 External 'VIOCALLS' Index   13;
  Function VioWrtCharStrAtt;              External 'VIOCALLS' Index   48;
  Function VioWrtNAttr;                   External 'VIOCALLS' Index   26;
  Function VioWrtNCell;                   External 'VIOCALLS' Index   52;
  Function VioWrtNChar;                   External 'VIOCALLS' Index   53;
  Function VioWrtTTY;                     External 'VIOCALLS' Index   19;
End.
