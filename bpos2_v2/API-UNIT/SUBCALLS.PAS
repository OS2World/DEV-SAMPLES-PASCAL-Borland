{| Unit: subcalls
 | Version: 1.00
 | translated from file subcalls.H
 | Original translation: Peter Sawatzki (ps)
 | Contributing:
 |   (fill in)
 |
 | change history:
 | Date:    Ver: Author:
 | 11/13/93 1.00 ps     original translation by ps
}
Unit subcalls;
Interface
Uses
  Os2Def;
Type
  CursorData = Record
    cur_start,                          { Cursor start line }
    cur_end,                            { Cursor end line }
    cur_width,                          { Cursor width }
    cur_attribute: Word                 { Cursor attribute }
  End;
  KbdStatus = Record
    length,                             { length in words of data structure }
    bit_mask,                           { bit mask }
    turn_around_char,                   { turnaround character }
    interim_char_flags,                 { interim character flags }
    shift_state: Word                   { shift state }
  End;
  KbdTRANS = Record
    char_code,                          { ASCII character code }
    scan_code,                          { scan code }
    status,                             { indicates state of char }
    nls_shift: Byte;                    { reserved }
    shift_state: Word;                  { state of the shift keys }
    time: LongInt;                      { timestamp of keystroke }
    kbdDDflags,                         { flags for monitor packet }
    xlt_flags,                          { Xlate flags }
    xlt_shift_state,                    { Xlate shift state }
    xlt_rsrv_0: Word                    { reserved = 0 }
  End;
  pKeyData = ^KeyData;
  KeyData = Record
    char_code,                          { ASCII character code }
    scan_code,                          { scan code }
    status,                             { indicates state of the character }
    nls_shift: Byte;                    { reserved }
    shift_state: Word;                  { state of the shift keys }
    time: LongInt                       { time stamp of the keystroke }
  End;
  ModeData = Record
    length: Word;                       { Length of structure }
    _type,                              { Text or graphics }
    color: Byte;                        { Color or monochrome }
    col,                                { Column resolution }
    row,                                { Row resolution }
    hres,                               { horizontal resolution }
    vres: Word;                         { vertical resolution }
    fmt_ID,                             { Format ID }
    attrib: Byte;                       { Attribute count }
    buf_addr,                           { 32-bit Buffer Physical Address }
    buf_length,                         { Buffer Length }
    full_length,                        { Full Buffer Length }
    partial_length: LongInt;            { Partial Buffer Length }
    ext_data_addr: pChar                { Address of Extended Data Area }
  End;
  PVBData = Record
    pvb_size: Word;                     { size of the structure }
    pvb_ptr: LongInt;                   { returns pointer to the pvb buffer }
    pvb_length,                         { length of PVB }
    pvb_rows,                           { buffer dimension (rows) }
    pvb_cols: Word;                     { buffer dimension (cols) }
    pvb_type: Byte                      { color or mono }
  End;
  PhysBufData = Record
    buf_start,                          { Physical address of buffer }
    buf_length: LongInt;                { Size of buffer (in bytes) }
    selectors: Array[0..1] Of Word      { 1 or more selectors (assume 2) }
  End;
  ConfigData = Record
    length,                             { Length of the structure in bytes }
    adapter_type,                       { specifies the video adapter type }
    display_type: Word;                 { specifies the video display type }
    memory_size: LongInt;               { number of bytes in display memory }
    Configuration,                      { Configuration number }
    VDHVersion,                         { VDH version number }
    Flags: Word;                        { Flags }
    HWBufferSize,                       { Environment Buffer size }
    FullSaveSize,                       { Full save size }
    PartSaveSize: LongInt;              { Partial save size }
    EMAdaptersOFF,                      { Offset to emulated adapters }
    EMDisplaysOFF: Word                 { Offset to emulated displays }
  End;
  VIOFONT = Record
    length,                             { Length of the struct (14) }
    req_type,                           { 0=current font, 1=ROM font }
    pel_cols,                           { character cell width }
    pel_rows: Word;                     { character cell height }
    font_data: LongInt;                 { far ptr to font data area }
    font_len: Word                      { num. bytes of font data }
  End;
  VIOSTATE = Record
    length,                             { structure length (max 38) }
    req_type,                           { 0 = set palette regs }{ 1 = set overscan color }
    double_defined,                     { req_type = 0 : }
                                        {first palette reg to set }
                                        { req_type = 1 : }
                                        {  border (overscan) color }
    palette0,                           { color value }
    palette1,                           { color value }
    palette2,                           { color value }
    palette3,                           { color value }
    palette4,                           { color value }
    palette5,                           { color value }
    palette6,                           { color value }
    palette7,                           { color value }
    palette8,                           { color value }
    palette9,                           { color value }
    palette10,                          { color value }
    palette11,                          { color value }
    palette12,                          { color value }
    palette13,                          { color value }
    palette14,                          { color value }
    palette15: Word                     { color value }
  End;
  EventInfo = Record
    Mask: Word;
    Time: LongInt;
    Row,
    Col: Word
  End;
  NoPointer = Record
    Row,
    Col,
    Height,
    Width: Word
  End;
  PtrImage = Record
    TotLength,
    Col,
    Row,
    ColOffset,
    RowOffset: Word
  End;
  PtrLoc = Record
    RowPos,
    ColPos: Word
  End;
  QueInfo = Record
    Events,
    QSize: Word
  End;
  ScaleFact = Record
    RowScale,
    ColScale: Word
  End;
  KbdStringInLength = Record
    Length,
    LengthB: Word
  End;
  KbdHWID = Record
    length,
    kbd_id,
    reserved1,
    reserved2: Word
  End;
  Function KBDREGISTER (Par1,                               { Module name }
                        Par2: pChar;                        { Entry point name }
                        Par3: LongInt): Word;               { Function mask    }
  Function KBDDEREGISTER: Word;                             { No Parameters }
  Function KBDCHARIN (Var Par1: KeyData;                       { Buffer for character code }
                      Par2,                                 { I/O wait - 0=wait for a }{ character, 1=no wait }
                      Par3: Word): Word;                    { keyboard handle }
  Function KBDFLUSHBUFFER (Par1: Word): Word;                     { keyboard handle }
  Function KBDGETSTATUS (Var Par1: KbdStatus;          { data structure }
                         Par2: Word): Word;                     { Keyboard device handle }
  Function KBDPEEK (Var Par1: KeyData;                 { buffer for data }
                    Par2: Word): Word;                     { keyboard handle }
  Function KBDSETFGND: Word;                         { No Parameters }
  Function KBDSETSTATUS (Var Par1: KbdStatus;          { data structure }
                         Par2: Word): Word;                     { device handle }
  Function KBDSTRINGIN (Par1: pChar; Var Par2: KbdStringInLength; Par3,Par4: Word): Word;
  Function KBDOPEN (Var Par1: Word): Word;               { addr. of returned handle }
  Function KBDCLOSE (Par1: Word): Word;                     { keyboard handle }
  Function KBDGETFOCUS (Par1,                               { wait/nowait indicator }
                        Par2: Word): Word;                     { keyboard handle }
  Function KBDFREEFOCUS (Par1: Word): Word;                     { keyboard handle }
  Function KBDGETCP (Par1: LongInt;                         { reserved }
                     Var Par2: Word;                      { addr. of returned ID }
                     Par3: Word): Word;                     { keyboard handle }
  Function KBDSETCP (Par1,                                  { reserved }
                     Par2,                                  { translate table ID }
                     Par3: Word): Word;                     { keyboard handle }
  Function KBDXLATE (Var Par1: KbdTRANS;               { translation record }
                     Par2: Word): Word;                     { keyboard handle }
  Function KBDSETCUSTXT (Var Par1: Word;                  { translation table }
                         Par2: Word): Word;                     { keyboard handle }
  Function KBDSYNCH (Par1: Word): Word;                     { IOwait word 0 or 1              }
                                        { 0 = requestor will wait for the }
                                        { access to the router            }
                                        { 1 = requestor will not wait for }
                                        { access to the router            }
  Function KBDGETHWID (Var Par1: KbdHWID;              { Hardware record (returned) }
                       Par2: Word): Word;                     { keyboard handle }
  Function VIOREGISTER (Par1,                               { Module name }
                        Par2: pChar;                       { Entry Point name }
                        Par3,                               { Function mask 1 }
                        Par4: LongInt): Word;                { Function mask 2 }
  Function VIODEREGISTER: Word;                         { No Parameters }
  Function VIOGLOBALREG (Par1,                              { Module name }
                         Par2: pchar;                      { Entry Point name }
                         Par3,                              { Function mask 1 }
                         Par4,                              { Function mask 2 }
                         Par5: LongInt): Word;                         { Reserved (must be 0) }
  Function VIOGETBUF (Var Par1: LongInt;                { Will point to logical video buffer }
                      Var Par2: Word;                     { Length of Buffer }
                      Par3: Word): Word;                     { Vio Handle }
  Function VIOGETCURPOS (Var Par1,                              { Current row position }
                             Par2: Word;                  { Current column position }
                         Par3: Word): Word;                     { Vio Handle }
  Function VIOGETCURTYPE (Var Par1: CursorData;        { Cursor characteristics }
                          Par2: Word): Word;                     { Vio Handle }
  Function VIOGETMODE (Var Par1: ModeData;             { Length of Buffer }
                       Par2: Word): Word;                     { Vio Handle }
  Function VIOGETPHYSBUF (Var Par1: PhysBufData;       { VIO Physical Buffer Info }
                          Par2: Word): Word;                     { Reserved (must be 0) }
  Function VIOREADCELLSTR (Par1: pchar;                    { Character Buffer }
                           Var Par2: Word;                { Length of cell string buffer }
                           Par3,                            { Starting location (row) }
                           Par4,                            { Starting location (col) }
                           Par5: Word): Word;                     { Vio Handle }
  Function VIOREADCHARSTR (Par1: pchar;                    { Character Buffer }
                           Var Par2: Word;                { Length of cell string buffer }
                           Par3,                            { Starting location (row) }
                           Par4,                            { Starting location (col) }
                           Par5: Word): Word;                     { Vio Handle }
  Function VIOSCROLLDN (Par1,                               { Top row of section to scroll }
                        Par2,                               { Left column of section to scroll }
                        Par3,                               { Bottom row of section to scroll }
                        Par4,                               { Right column of section to scroll }
                        Par5: Word;                         { Number of blank lines at bottom }
                        Par6: pchar;                       { pointer to blank Char,Attr }
                        Par7: Word): Word;                     { Vio Handle }
  Function VIOSCROLLUP (Par1,                               { Top row of section to scroll }
                        Par2,                               { Left column of section to scroll }
                        Par3,                               { Bottom row of section to scroll }
                        Par4,                               { Right column of section to scroll }
                        Par5: Word;                         { Number of blank lines at bottom }
                        Par6: pchar;                       { pointer to blank Char,Attr }
                        Par7: Word): Word;                     { Vio Handle }
  Function VIOSCROLLLF (Par1,                               { Top row of section to scroll }
                        Par2,                               { Left column of section to scroll }
                        Par3,                               { Bottom row of section to scroll }
                        Par4,                               { Right column of section to scroll }
                        Par5: Word;                         { Number of blank columsn at right }
                        Par6: pchar;                       { pointer to blank Char,Attr }
                        Par7: Word): Word;                     { Vio Handle }
  Function VIOSCROLLRT (Par1,                               { Top row of section to scroll }
                        Par2,                               { Left column of section to scroll }
                        Par3,                               { Bottom row of section to scroll }
                        Par4,                               { Right column of section to scroll }
                        Par5: Word;                         { Number of blank columsn at left }
                        Par6: pchar;                       { pointer to blank Char,Attr }
                        Par7: Word): Word;                     { Vio Handle }
  Function VIOSETCURPOS (Par1,                              { Row return data }
                         Par2,                              { Column return data }
                         Par3: Word): Word;                     { Vio Handle }
  Function VIOSETCURTYPE (Var Par1: CursorData;        { Cursor characteristics }
                          Par2: Word): Word;                     { Vio Handle }
  Function VIOSETMODE (Var Par1: ModeData;             { Mode characteristics }
                       Par2: Word): Word;                     { Vio Handle }
  Function VIOSHOWBUF (Par1,                                { Offset into buffer }
                       Par2,                                { Length of area to be updated }
                       Par3: Word): Word;                     { Vio Handle }
  Function VIOWRTCELLSTR (Par1: pchar;                     { String to be written }
                          Par2,                             { Length of string }
                          Par3,                             { Starting position for output (row) }
                          Par4,                             { Starting position for output (col) }
                          Par5: Word): Word;                     { Vio Handle }
  Function VIOWRTCHARSTR (Par1: pchar;                     { String to be written }
                          Par2,                             { Length of string }
                          Par3,                             { Starting position for output (row) }
                          Par4,                             { Starting position for output (col) }
                          Par5: Word): Word;                     { Vio Handle }
  Function VIOWRTCHARSTRATT (Par1: pchar;                  { String to be written }
                             Par2,                          { Length of string }
                             Par3,                          { Starting position for output (row) }
                             Par4: Word;                    { Starting position for output (col) }
                             Par5: pchar;                  { Attribute to be replicated }
                             Par6: Word): Word;                     { Vio Handle }
  Function VIOWRTNATTR (Par1: pchar;                       { Attribute to be written }
                        Par2,                               { Length of write }
                        Par3,                               { Starting position for output (row) }
                        Par4,                               { Starting position for output (col) }
                        Par5: Word): Word;                     { Vio Handle }
  Function VIOWRTNCELL (Par1: pchar;                       { Cell to be written }
                        Par2,                               { Length of write }
                        Par3,                               { Starting position for output (row) }
                        Par4,                               { Starting position for output (col) }
                        Par5: Word): Word;                     { Vio Handle }
  Function VIOWRTNCHAR (Par1: pchar;                       { Character to be written }
                        Par2,                               { Length of write }
                        Par3,                               { Starting position for output (row) }
                        Par4,                               { Starting position for output (col) }
                        Par5: Word): Word;                     { Vio Handle }
  Function VIOWRTTTY (Par1: pchar;                         { String to be written }
                      Par2,                                 { Length of string }
                      Par3: Word): Word;                     { Vio Handle }
  Function VIOSETANSI (Par1,                                { ON (=1) or OFF (=0) indicator }
                       Par2: Word): Word;                     { Vio Handle }
  Function VIOGETANSI (Var Par1: Word;                    { ANSI state (returned) }
                       Par2: Word): Word;                     { Vio Handle }
  Function VIOPRTSC (Par1: Word): Word;                     { Vio Handle }
  Function VIOPRTSCTOGGLE (Par1: Word): Word;                     { Vio Handle }
  Function VIOSAVREDRAWWAIT (Par1: Word;                    { Save/Redraw Indicator }
                             Var Par2: Word;              { Notify type (returned) }
                             Par3: Word): Word;                     { Vio Handle }
  Function VIOSAVREDRAWUNDO (Par1,                          { Ownership Indicator }
                             Par2,                          { Terminate Indicator }
                             Par3: Word): Word;                     { Vio Handle }
  Function VIOMODEWAIT (Par1: Word;                         { Request type }
                        Var Par2: Word;                   { Notify type (returned) }
                        Par3: Word): Word;                     { Reserved (must be 0) }
  Function VIOMODEUNDO (Par1,                               { Ownership indicator }
                        Par2,                               { Terminate indicator }
                        Par3: Word): Word;                     { Reserved (must be 0) }
  Function VIOSCRLOCK (Par1: Word;                          { Wait Flag }
                       Var Par2: Word;               { Status of lock (returned) }
                       Par3: Word): Word;                     { Vio Handle }
  Function VIOSCRUNLOCK (Par1: Word): Word;                     { Vio Handle }
  Function VIOPOPUP (Var Par1: Word;                      { Wait/Nowait Bit flags }
                     Par2: Word): Word;                     { Vio Handle }
  Function VIOENDPOPUP (Par1: Word): Word;                     { Vio Handle }
  Function VIOGETCONFIG (Par1: Word;                        { Reserved - must be 0 }
                         Var Par2: ConfigData;         { Pointer to data buffer }
                         Par3: Word): Word;                     { VIO handle }
  Function VIOGETFONT (Var Par1: VIOFONT;              { request block }
                       Par2: Word): Word;                     { VIO handle }
  Function VIOGETCP (Par1: Word;                            { Reserved - must be 0 }
                     Var Par2: Word;                      { Ptr to returnd codepageID }
                     Par3: Word): Word;                     { VIO handle }
  Function VIOSETCP (Par1,                                  { Reserved - must be 0 }
                     Par2,                                  { codepage ID }
                     Par3: Word): Word;                     { VIO handle }
  Function VIOSETFONT (Var Par1: VIOFONT;              { request block }
                       Par2: Word): Word;                     { VIO handle }
  Function VIOGETSTATE (Var Par1: VIOSTATE;            { request block }
                        Par2: Word): Word;                     { VIO handle }
  Function VIOSETSTATE (Var Par1: VIOSTATE;            { request block }
                        Par2: Word): Word;                     { VIO handle }
  Function MOUREGISTER (Par1,                               { Module name }
                        Par2: pchar;                       { Entry Point name }
                        Par3: LongInt): Word;                { Function mask }
  Function MOUDEREGISTER: Word;                         { No Parameters }
  Function MOUFLUSHQUE (Par1: Word): Word;                     { Mouse device handle }
  Function MOUGETHOTKEY (Var Par1: Word;                  { mask of which key is the hot key }
                         Par2: Word): Word;                     { Mouse device handle }
  Function MOUSETHOTKEY (Var Par1: Word;                  { Mouse Button Mask }
                         Par2: Word): Word;                     { Mouse Device Handle }
  Function MOUGETPTRPOS (Var Par1: PtrLoc;             { Pointer Location Record (returned) }
                         Par2: Word): Word;                     { Mouse device handle }
  Function MOUSETPTRPOS (Var Par1: PtrLoc;             { Pointer Location Record }
                         Par2: Word): Word;                     { Mouse device handle }
  Function MOUGETPTRSHAPE (Par1: pchar;           { Pointer Shape Buffer (returned) }
                           Var Par2: PtrImage;         { Pointer Definition Record }
                           Par3: Word): Word;                     { Mouse device handle }
  Function MOUSETPTRSHAPE (Par1: pchar;           { Pointer Shape Buffer }
                           Var Par2: PtrImage;         { Pointer Definition Record }
                           Par3: Word): Word;                     { Mouse device handle }
  Function MOUGETDEVSTATUS (Var Par1: Word;               { Current status flags (returned) }
                            Par2: Word): Word;                     { Mouse Device Handle }
  Function MOUGETNUMBUTTONS (Var Par1: Word;              { Number of mouse buttons (returned) }
                             Par2: Word): Word;                     { Mouse Device Handle }
  Function MOUGETNUMMICKEYS (Var Par1: Word;              { Number of Mickeys/cm (returned) }
                             Par2: Word): Word;                     { Mouse Device Handle }
  Function MOUREADEVENTQUE (Var Par1: EventInfo;       { Event Queue Entry (returned) }
                            Var Par2: Word;               { Type of read operation }
                            Par3: Word): Word;                     { Mouse Device Handle }
  Function MOUGETNUMQUEEL (Var Par1: QueInfo;          { Queue Information (returned) }
                           Par2: Word): Word;                     { Mouse Device Handle }
  Function MOUGETEVENTMASK (Var Par1: Word;               { Event Mask (returned) }
                            Par2: Word): Word;                     { Mouse Device Handle }
  Function MOUSETEVENTMASK (Var Par1: Word;               { Event Mask }
                            Par2: Word): Word;                     { Mouse Device Handle }
  Function MOUGETSCALEFACT (Var Par1: ScaleFact;       { Scaling Factors (returned) }
                            Par2: Word): Word;                     { Mouse Device Handle }
  Function MOUSETSCALEFACT (Var Par1: ScaleFact;       { Scaling Factors }
                            Par2: Word): Word;                     { Mouse Device Handle }
  Function MOUOPEN (Par1: pchar;                           { Pointer draw device name }
                    Var Par2: Word): Word;               { Mouse Device Handle (returned) }
  Function MOUCLOSE (Par1: Word): Word;                     { Mouse Device Handle }
  Function MOUREMOVEPTR (Var Par1: NoPointer;          { Pointer Area }
                         Par2: Word): Word;                     { Mouse Device Handle }
  Function MOUDRAWPTR (Par1: Word): Word;                     { Mouse Device Handle }
  Function MOUSETDEVSTATUS (Var Par1: Word;               { status flags }
                            Par2: Word): Word;                     { Mouse Device Handle }
  Function MOUINITREAL (Par1: pChar): Word;                   { Pointer draw driver name }
  Function MOUSYNCH (Par1: Word): Word;                     { I/O Wait - indicate wait/nowait }

Implementation
  Function KBDCHARIN;                     External 'KBDCALLS' Index    4;
  Function KBDCLOSE;                      External 'KBDCALLS' Index   17;
  Function KBDDEREGISTER;                 External 'KBDCALLS' Index   20;
  Function KBDFLUSHBUFFER;                External 'KBDCALLS' Index   13;
  Function KBDFREEFOCUS;                  External 'KBDCALLS' Index   18;
  Function KBDGETCP;                      External 'KBDCALLS' Index    3;
  Function KBDGETFOCUS;                   External 'KBDCALLS' Index   12;
  Function KBDGETHWID;                    External 'KBDCALLS' Index   24;
  Function KBDGETSTATUS;                  External 'KBDCALLS' Index   10;
  Function KBDOPEN;                       External 'KBDCALLS' Index   23;
  Function KBDPEEK;                       External 'KBDCALLS' Index   22;
  Function KBDREGISTER;                   External 'KBDCALLS' Index    8;
  Function KBDSETCP;                      External 'KBDCALLS' Index    5;
  Function KBDSETCUSTXT;                  External 'KBDCALLS' Index    1;
  Function KBDSETFGND;                    External 'KBDCALLS' Index   21;
  Function KBDSETSTATUS;                  External 'KBDCALLS' Index   11;
  Function KBDSTRINGIN;                   External 'KBDCALLS' Index    9;
  Function KBDSYNCH;                      External 'KBDCALLS' Index    7;
  Function KBDXLATE;                      External 'KBDCALLS' Index   14;
  Function MOUCLOSE;                      External 'MOUCALLS' Index    9;
  Function MOUDEREGISTER;                 External 'MOUCALLS' Index   14;
  Function MOUDRAWPTR;                    External 'MOUCALLS' Index   26;
  Function MOUFLUSHQUE;                   External 'MOUCALLS' Index    7;
  Function MOUGETDEVSTATUS;               External 'MOUCALLS' Index   22;
  Function MOUGETEVENTMASK;               External 'MOUCALLS' Index   15;
  Function MOUGETHOTKEY;                  External 'MOUCALLS' Index    4;
  Function MOUGETNUMBUTTONS;              External 'MOUCALLS' Index    8;
  Function MOUGETNUMMICKEYS;              External 'MOUCALLS' Index    3;
  Function MOUGETNUMQUEEL;                External 'MOUCALLS' Index   13;
  Function MOUGETPTRPOS;                  External 'MOUCALLS' Index   19;
  Function MOUGETPTRSHAPE;                External 'MOUCALLS' Index    1;
  Function MOUGETSCALEFACT;               External 'MOUCALLS' Index    6;
  Function MOUINITREAL;                   External 'MOUCALLS' Index   27;
  Function MOUOPEN;                       External 'MOUCALLS' Index   17;
  Function MOUREADEVENTQUE;               External 'MOUCALLS' Index   20;
  Function MOUREGISTER;                   External 'MOUCALLS' Index   24;
  Function MOUREMOVEPTR;                  External 'MOUCALLS' Index   18;
  Function MOUSETDEVSTATUS;               External 'MOUCALLS' Index   25;
  Function MOUSETEVENTMASK;               External 'MOUCALLS' Index   16;
  Function MOUSETHOTKEY;                  External 'MOUCALLS' Index   10;
  Function MOUSETPTRPOS;                  External 'MOUCALLS' Index   21;
  Function MOUSETPTRSHAPE;                External 'MOUCALLS' Index    2;
  Function MOUSETSCALEFACT;               External 'MOUCALLS' Index   11;
  Function MOUSYNCH;                      External 'MOUCALLS' Index   23;
  Function VIODEREGISTER;                 External 'VIOCALLS' Index    6;
  Function VIOENDPOPUP;                   External 'VIOCALLS' Index    1;
  Function VIOGETANSI;                    External 'VIOCALLS' Index    3;
  Function VIOGETBUF;                     External 'VIOCALLS' Index   31;
  Function VIOGETCONFIG;                  External 'VIOCALLS' Index   46;
  Function VIOGETCP;                      External 'VIOCALLS' Index   40;
  Function VIOGETCURPOS;                  External 'VIOCALLS' Index    9;
  Function VIOGETCURTYPE;                 External 'VIOCALLS' Index   27;
  Function VIOGETFONT;                    External 'VIOCALLS' Index   29;
  Function VIOGETMODE;                    External 'VIOCALLS' Index   21;
  Function VIOGETPHYSBUF;                 External 'VIOCALLS' Index    2;
  Function VIOGETSTATE;                   External 'VIOCALLS' Index   49;
  Function VIOGLOBALREG; Begin Unknown('VIOGLOBALREG','SubCalls') End;
  Function VIOMODEUNDO;                   External 'VIOCALLS' Index   35;
  Function VIOMODEWAIT;                   External 'VIOCALLS' Index   37;
  Function VIOPOPUP;                      External 'VIOCALLS' Index   11;
  Function VIOPRTSC;                      External 'VIOCALLS' Index    8;
  Function VIOPRTSCTOGGLE;                External 'VIOCALLS' Index   50;
  Function VIOREADCELLSTR;                External 'VIOCALLS' Index   24;
  Function VIOREADCHARSTR;                External 'VIOCALLS' Index   30;
  Function VIOREGISTER;                   External 'VIOCALLS' Index   45;
  Function VIOSAVREDRAWUNDO;              External 'VIOCALLS' Index   28;
  Function VIOSAVREDRAWWAIT;              External 'VIOCALLS' Index   25;
  Function VIOSCRLOCK;                    External 'VIOCALLS' Index   23;
  Function VIOSCROLLDN;                   External 'VIOCALLS' Index   47;
  Function VIOSCROLLLF;                   External 'VIOCALLS' Index   44;
  Function VIOSCROLLRT;                   External 'VIOCALLS' Index   12;
  Function VIOSCROLLUP;                   External 'VIOCALLS' Index    7;
  Function VIOSCRUNLOCK;                  External 'VIOCALLS' Index   18;
  Function VIOSETANSI;                    External 'VIOCALLS' Index    5;
  Function VIOSETCP;                      External 'VIOCALLS' Index   42;
  Function VIOSETCURPOS;                  External 'VIOCALLS' Index   15;
  Function VIOSETCURTYPE;                 External 'VIOCALLS' Index   32;
  Function VIOSETFONT;                    External 'VIOCALLS' Index   33;
  Function VIOSETMODE;                    External 'VIOCALLS' Index   22;
  Function VIOSETSTATE;                   External 'VIOCALLS' Index   51;
  Function VIOSHOWBUF;                    External 'VIOCALLS' Index   43;
  Function VIOWRTCELLSTR;                 External 'VIOCALLS' Index   10;
  Function VIOWRTCHARSTR;                 External 'VIOCALLS' Index   13;
  Function VIOWRTCHARSTRATT;              External 'VIOCALLS' Index   48;
  Function VIOWRTNATTR;                   External 'VIOCALLS' Index   26;
  Function VIOWRTNCELL;                   External 'VIOCALLS' Index   52;
  Function VIOWRTNCHAR;                   External 'VIOCALLS' Index   53;
  Function VIOWRTTTY;                     External 'VIOCALLS' Index   19;
End.

