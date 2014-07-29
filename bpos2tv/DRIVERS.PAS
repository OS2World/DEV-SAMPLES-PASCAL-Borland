
{*******************************************************}
{                                                       }
{       Turbo Pascal Version 7.0                        }
{       Turbo Vision Unit                               }
{                                                       }
{       Copyright (c) 1992 Borland International        }
{                                                       }
{*******************************************************}

unit Drivers;

{$X+,I-,S-,P-}

interface

uses Objects, OS2Def, BSESub, BSEDos;

{ ******** EVENT MANAGER ******** }

const

{ Event codes }

  evMouseDown = $0001;
  evMouseUp   = $0002;
  evMouseMove = $0004;
  evMouseAuto = $0008;
  evKeyDown   = $0010;
  evCommand   = $0100;
  evBroadcast = $0200;

{ Event masks }

  evNothing   = $0000;
  evMouse     = $000F;
  evKeyboard  = $0010;
  evMessage   = $FF00;

{ Extended key codes }

  kbEsc       = $011B;  kbAltSpace  = $0200;  kbCtrlIns   = $9200;
  kbShiftIns  = $5230;  kbCtrlDel   = $9300;  kbShiftDel  = $532E;
  kbBack      = $0E08;  kbCtrlBack  = $0E7F;  kbShiftTab  = $0F00;
  kbTab       = $0F09;  kbAltQ      = $1000;  kbAltW      = $1100;
  kbAltE      = $1200;  kbAltR      = $1300;  kbAltT      = $1400;
  kbAltY      = $1500;  kbAltU      = $1600;  kbAltI      = $1700;
  kbAltO      = $1800;  kbAltP      = $1900;  kbCtrlEnter = $1C0A;
  kbEnter     = $1C0D;  kbAltA      = $1E00;  kbAltS      = $1F00;
  kbAltD      = $2000;  kbAltF      = $2100;  kbAltG      = $2200;
  kbAltH      = $2300;  kbAltJ      = $2400;  kbAltK      = $2500;
  kbAltL      = $2600;  kbAltZ      = $2C00;  kbAltX      = $2D00;
  kbAltC      = $2E00;  kbAltV      = $2F00;  kbAltB      = $3000;
  kbAltN      = $3100;  kbAltM      = $3200;  kbF1        = $3B00;
  kbF2        = $3C00;  kbF3        = $3D00;  kbF4        = $3E00;
  kbF5        = $3F00;  kbF6        = $4000;  kbF7        = $4100;
  kbF8        = $4200;  kbF9        = $4300;  kbF10       = $4400;
  kbHome      = $4700;  kbUp        = $4800;  kbPgUp      = $4900;
  kbGrayMinus = $4A2D;  kbLeft      = $4B00;  kbRight     = $4D00;
  kbGrayPlus  = $4E2B;  kbEnd       = $4F00;  kbDown      = $5000;
  kbPgDn      = $5100;  kbIns       = $5200;  kbDel       = $5300;
  kbShiftF1   = $5400;  kbShiftF2   = $5500;  kbShiftF3   = $5600;
  kbShiftF4   = $5700;  kbShiftF5   = $5800;  kbShiftF6   = $5900;
  kbShiftF7   = $5A00;  kbShiftF8   = $5B00;  kbShiftF9   = $5C00;
  kbShiftF10  = $5D00;  kbCtrlF1    = $5E00;  kbCtrlF2    = $5F00;
  kbCtrlF3    = $6000;  kbCtrlF4    = $6100;  kbCtrlF5    = $6200;
  kbCtrlF6    = $6300;  kbCtrlF7    = $6400;  kbCtrlF8    = $6500;
  kbCtrlF9    = $6600;  kbCtrlF10   = $6700;  kbAltF1     = $6800;
  kbAltF2     = $6900;  kbAltF3     = $6A00;  kbAltF4     = $6B00;
  kbAltF5     = $6C00;  kbAltF6     = $6D00;  kbAltF7     = $6E00;
  kbAltF8     = $6F00;  kbAltF9     = $7000;  kbAltF10    = $7100;
  kbCtrlPrtSc = $7200;  kbCtrlLeft  = $7300;  kbCtrlRight = $7400;
  kbCtrlEnd   = $7500;  kbCtrlPgDn  = $7600;  kbCtrlHome  = $7700;
  kbAlt1      = $7800;  kbAlt2      = $7900;  kbAlt3      = $7A00;
  kbAlt4      = $7B00;  kbAlt5      = $7C00;  kbAlt6      = $7D00;
  kbAlt7      = $7E00;  kbAlt8      = $7F00;  kbAlt9      = $8000;
  kbAlt0      = $8100;  kbAltMinus  = $8200;  kbAltEqual  = $8300;
  kbCtrlPgUp  = $8400;  kbAltBack   = $0E00;  kbNoKey     = $0000;

{ Keyboard state and shift masks }

  kbRightShift  = $0001;
  kbLeftShift   = $0002;
  kbCtrlShift   = $0004;
  kbAltShift    = $0008;
  kbScrollState = $0010;
  kbNumState    = $0020;
  kbCapsState   = $0040;
  kbInsState    = $0080;

{ Mouse button state masks }

  mbLeftButton   = $01;
  mbRightButton  = $02;
  mbMiddleButton = $04;

type

{ Event record }

  PEvent = ^TEvent;
  TEvent = record
    What: Word;
    case Word of
      evNothing: ();
      evMouse: (
        Buttons: Byte;
        Double: Boolean;
        Where: TPoint);
      evKeyDown: (
        case Integer of
	  0: (KeyCode: Word);
          1: (CharCode: Char;
              ScanCode: Byte));
      evMessage: (
        Command: Word;
        case Word of
          0: (InfoPtr: Pointer);
          1: (InfoLong: Longint);
          2: (InfoWord: Word);
          3: (InfoInt: Integer);
          4: (InfoByte: Byte);
          5: (InfoChar: Char));
  end;

const

{ Initialized variables }

  HMouse: HMOU = 0;
  ButtonCount: Word = 0;
  MouseEvents: Boolean = False;
  MouseReverse: Boolean = False;
  DoubleDelay: Word = 8;
  RepeatDelay: Word = 8;
  RepeatSpacing: Word = 55; { msecs between autoticks }

{var

{ Uninitialized variables }

{  MouseIntFlag: Byte;
  MouseButtons: Byte;
  MouseWhere: TPoint;

{ Event manager routines }

procedure InitEvents;
procedure DoneEvents;
procedure ShowMouse;
procedure HideMouse;
procedure GetMouseEvent(var Event: TEvent);
procedure GetKeyEvent(var Event: TEvent);
function GetShiftState: Word;

{ ******** SCREEN MANAGER ******** }

const

{ Screen modes }

  smBW80    = $0002;
  smCO80    = $0003;
  smMono    = $0007;
  smFont8x8 = $0100;

const

{ Initialized variables }

  StartupMode: Word = $FFFF;
  CheckSnow : boolean = false;

var

{ Uninitialized variables }

  ScreenMode: Word;
  ScreenWidth: Byte;
  ScreenHeight: Byte;
  HiResScreen: Boolean;
  ScreenBuffer: pointer;
  ScreenLen: Word;
  CursorLines: Word;

{ Screen manager routines }

procedure InitVideo;
procedure DoneVideo;
procedure SetVideoMode(Mode: Word);
function SetCrtMode(Cols, Rows, NumColors : byte) : boolean;
procedure ClearScreen;

{ ******** SYSTEM ERROR HANDLER ******** }

type

{ System error handler function type }

  TSysErrorFunc = function(ErrorCode: Integer; Drive: Byte): Integer;

{ Default system error handler routine }

function SystemError(ErrorCode: Integer; Drive: Byte): Integer;

const

{ Initialized variables }

  SaveInt09: Pointer = nil;
  SysErrorFunc: TSysErrorFunc = SystemError;
  SysColorAttr: Word = $4E4F;
  SysMonoAttr: Word = $7070;
  CtrlBreakHit: Boolean = False;
  SaveCtrlBreak: Boolean = False;
  SysErrActive: Boolean = False;
  FailSysErrors: Boolean = False;

{ System error handler routines }

procedure InitSysError;
procedure DoneSysError;

{ ******** UTILITY ROUTINES ******** }

{ Keyboard support routines }

function GetAltChar(KeyCode: Word): Char;
function GetAltCode(Ch: Char): Word;
function GetCtrlChar(KeyCode: Word): Char;
function GetCtrlCode(Ch: Char): Word;
function CtrlToArrow(KeyCode: Word): Word;

{ String routines }

procedure FormatStr(var Result: String; const Format: String; var Params);
procedure PrintStr(const S: String);

{ Buffer move routines }

procedure MoveBuf(var Dest; var Source; Attr: Byte; Count: Word);
procedure MoveChar(var Dest; C: Char; Attr: Byte; Count: Word);
procedure MoveCStr(var Dest; const Str: String; Attrs: Word);
procedure MoveStr(var Dest; const Str: String; Attr: Byte);
function CStrLen(const S: String): Integer;

implementation

{ ******** EVENT MANAGER ******** }

const

{ Event manager constants }

  EventQSize = 16;

var

{ Event manager variables }

  LastButtons: Byte;
  DownButtons: Byte;
  LastDouble: Boolean;
  LastWhere: TPoint;
  DownWhere: TPoint;
  DownTicks: Word;
  AutoTicks: Word;
  AutoDelay: Word;
  EventCount: Word;
  EventQHead: Word;
  EventQTail: Word;
  EventQueue: array[0..EventQSize - 1] of TEvent;
  EventQLast: record end;

{ Detect mouse driver }

procedure DetectMouse; near;
begin
  if MouOpen(nil, @HMouse) = 0 then begin
    MouGetNumButtons(@ButtonCount, HMouse);
    MouClose(HMouse);
  end;
  HMouse := 0;
end;

procedure InitEvents;
var
  ZeroPos : PtrLoc;
begin
  if MouOpen(nil, @HMouse) = 0 then begin
    ZeroPos.col := 0;
    ZeroPos.row := 0;
    MouDrawPtr(HMouse);
    MouSetPtrPos(@ZeroPos, HMouse);
    MouseEvents := true;
  end;
end;

procedure DoneEvents;
begin
  MouClose(HMouse);
end;

procedure ShowMouse;
begin
  if HMouse <> 0 then
    MouDrawPtr(HMouse);
end;

procedure HideMouse;
var
  Rect : NoPtrRect;
begin
  if HMouse <> 0 then begin
    with Rect do begin
      row := 0;
      col := 0;
      crow := ScreenHeight-1;
      ccol := ScreenWidth-1;
    end;
    MouRemovePtr(@Rect, HMouse);
  end;
end;

function EvenBits(n : word) : byte; assembler;
asm
        XOR     AX,AX
	MOV	BX,N
        MOV     DX,1
@@1:    OR      BX,BX
        JE      @@2
	TEST    BX,3
        JZ      @@3
        OR      AX,DX
@@3:
        SHL     DX,1
        SHR	BX,1
        SHR	BX,1
        JMP     @@1
@@2:
end;

const
  MouseButtons : byte = 0;
  MouseDblClick : boolean = false;
  MouseQEvent : TEvent = (What:evNothing);
var
  MouseLastClickTime : longint;

procedure GetMouseEvent(var Event: TEvent);
const
  Wait : word = 0;
var
  Info : MouEventInfo;
  GlobInfo, LocalInfo : SEL;
  gtime : longint;
begin
  if MouseQEvent.What <> evNothing then begin
    Event := MouseQEvent;
    MouseQEvent.What := evNothing;
    Exit;
  end; { use queued event if there is one }
  MouseQEvent.What := evNothing;
  Event.What := evNothing;
  if (HMouse = 0) then Exit;
  while (MouReadEventQue(@Info, @Wait, HMouse) = 0) and (Info.time <> 0) do
  with Info do begin
    MouseQEvent.Double := false;
    MouseQEvent.Where.X := col;
    MouseQEvent.Where.Y := row;
    MouseQEvent.Buttons := EvenBits(fs shr 1);
    if fs and $54 > 0 then begin { a button's down }
      MouseQEvent.What := evMouseDown;
      MouseButtons := MouseQEvent.Buttons;
      MouseQEvent.Double := MouseDblClick and
        (time-MouseLastClickTime < DoubleDelay*55);
      MouseDblClick := not MouseQEvent.Double;
      MouseLastClickTime := time;
      AutoDelay := RepeatDelay*55;
      Break;
    end else begin
      if MouseButtons xor MouseQEvent.Buttons <> 0 then begin { button changed }
        MouseQEvent.What := evMouseUp;
        MouseButtons := MouseQEvent.Buttons;
        Break;
      end else begin { just moved the mouse }
        Event := MouseQEvent;
        Event.What := evMouseMove;
        MouseDblClick := false;
      end;
    end;
  end;
  if Event.What = evNothing then begin { if no mouse movement }
    if MouseQEvent.What = evNothing then begin
      DosGetInfoSeg(@GlobInfo, @LocalInfo);
      with PGINFOSEG(Ptr(GlobInfo, 0))^ do begin
        gtime := msecs;
        while gtime <> msecs do gtime := msecs; { wait for it to stop changing }
      end;
      { no event at all, check for auto repeat }
      if (MouseButtons > 0) and
      (gtime-MouseLastClickTime >= AutoDelay) then
      begin { auto repeat }
        MouseLastClickTime := gtime;
        MouseQEvent.What := evMouseAuto;
        MouseButtons := MouseQEvent.Buttons;
        AutoDelay := RepeatSpacing;
      end;
    end;
    Event := MouseQEvent;
    MouseQEvent.What := evNothing; { use the queued event }
  end;
end;

procedure GetKeyEvent(var Event: TEvent);
var
  Info : KbdKeyInfo;
begin
  Event.What := evNothing;
  Event.ScanCode := 0;
  Info.chScan := 0;
  if (KbdCharIn(@Info, IO_NOWAIT, 0) = 0) and
      (Info.fbStatus <> 0) then
  begin
    Event.What := evKeyDown;
    if Info.chChar = 224 then
      Event.CharCode := #0
    else
      Event.CharCode := chr(Info.chChar);
    Event.ScanCode := byte(Info.chScan);
    if Event.ScanCode = 224 then Event.ScanCode := 28;
  end;
end;

function GetShiftState: Word;
var
  Info : KbdInfo;
begin
  Info.cb := sizeof(KbdInfo);
  if KbdGetStatus(@Info, 0) = 0 then begin
    GetShiftState := Info.fsState;
  end else
    GetShiftState := 0;
end;

{ ******** SCREEN MANAGER ******** }

{ Save registers and call video interrupt }

procedure VideoInt; near; assembler;
asm
	PUSH	BP
	PUSH	ES
	INT	10H
	POP	ES
	POP	BP
end;

{ Set CRT data areas and mouse range }

procedure SetCrtData; near;
var
  Info : VioModeInfo;
begin
  Info.cb := sizeof(Info);
  VioGetMode(@Info, 0);
  with Info do begin
    ScreenWidth := col;
    ScreenHeight := row;
  end;
end;

var
  DefVioMode : VioModeInfo;

procedure DetectVideo;
begin
  DefVioMode.cb := sizeof(DefVioMode);
  VioGetMode(@DefVioMode, 0);
end;

function SetCrtMode(Cols, Rows, NumColors : byte) : boolean;
var
  info : VIOMODEINFO;
  cursinfo : VIOCURSORINFO;
begin
  SetCrtMode := true;
  VioGetBuf(@ScreenBuffer, @ScreenLen, 0);
  info.cb := sizeof(info);
  if (VioGetMode(@info, 0) <> 0) then begin
    SetCrtMode := false;
    Exit;
  end;
  with info do begin
    if (col <> cols) or (row <> rows) or (color <> numcolors) then begin
      info.col := cols;
      info.row := rows;
      info.color := numcolors;
      if VioSetMode(@info, 0) <> 0 then
        SetCrtMode := false;
    end;
  end;
  ScreenWidth := info.col;
  ScreenHeight := info.row;
  VioGetCurType(@cursinfo, 0);
  with cursinfo do
    CursorLines := cEnd+yStart shl 8;
  cursinfo.attr := $FFFF;
  VioSetCurType(@cursinfo, 0);
end;

procedure SetVideoMode(Mode: Word);
var
  Cols, Rows, Colors : byte;
begin
  if (Mode = smBW80) or (Mode = smMono) then Colors := 1 else Colors := 4;
  if Mode >= smFont8x8 then Rows := 43 else Rows := 25;
  Cols := 80;
  SetCrtMode(Cols, Rows, Colors);
  ScreenMode := Mode;
end;

procedure InitVideo;
begin
  SetVideoMode(ScreenMode);
end;

procedure DoneVideo;
begin
  ClearScreen;
  VioSetMode(@DefVioMode, 0);
end;

procedure ClearScreen;
const
  Cell : word = $0720;
begin
  VioScrollUp(0, 0, $FFFF, $FFFF, $FFFF, PByte(@Cell), 0);
end;

{ ******** SYSTEM ERROR HANDLER ******** }
(*
{$L SYSINT.OBO}
*)
const

{ System error messages }

  SCriticalError:  string[31] = 'Critical disk error on drive %c';
  SWriteProtected: string[35] = 'Disk is write-protected in drive %c';
  SDiskNotReady:   string[29] = 'Disk is not ready in drive %c';
  SDataIntegrity:  string[32] = 'Data integrity error on drive %c';
  SSeekError:      string[22] = 'Seek error on drive %c';
  SUnknownMedia:   string[30] = 'Unknown media type in drive %c';
  SSectorNotFound: string[28] = 'Sector not found on drive %c';
  SOutOfPaper:     string[20] = 'Printer out of paper';
  SWriteFault:     string[23] = 'Write fault on drive %c';
  SReadFault:      string[22] = 'Read fault on drive %c';
  SGeneralFailure: string[28] = 'Hardware failure on drive %c';
  SBadImageOfFAT:  string[32] = 'Bad memory image of FAT detected';
  SDeviceError:    string[19] = 'Device access error';
  SInsertDisk:     string[27] = 'Insert diskette in drive %c';
  SRetryOrCancel:  string[27] = '~Enter~ Retry  ~Esc~ Cancel';

{ Critical error message translation table }

  ErrorString: array[0..15] of Word = (
    Ofs(SWriteProtected),
    Ofs(SCriticalError),
    Ofs(SDiskNotReady),
    Ofs(SCriticalError),
    Ofs(SDataIntegrity),
    Ofs(SCriticalError),
    Ofs(SSeekError),
    Ofs(SUnknownMedia),
    Ofs(SSectorNotFound),
    Ofs(SOutOfPaper),
    Ofs(SWriteFault),
    Ofs(SReadFault),
    Ofs(SGeneralFailure),
    Ofs(SBadImageOfFAT),
    Ofs(SDeviceError),
    Ofs(SInsertDisk));

{ System error handler routines }

procedure InitSysError;
begin
end;

procedure DoneSysError;
begin
end;

procedure SwapStatusLine(var Buffer); near; assembler;
asm
	MOV	CL,ScreenWidth
	XOR	CH,CH
	MOV	AL,ScreenHeight
	DEC	AL
	MUL	CL
	SHL	AX,1
	LES	DI,ScreenBuffer
	ADD	DI,AX
	PUSH	DS
	LDS	SI,Buffer
@@1:	MOV	AX,ES:[DI]
	MOVSW
	MOV	DS:[SI-2],AX
	LOOP	@@1
	POP	DS
end;

function SelectKey: Integer; near; assembler;
asm
	MOV	AH,3
	MOV	BH,0
	CALL	VideoInt
	PUSH	CX
	MOV	AH,1
	MOV	CX,2000H
	CALL	VideoInt
@@1:	MOV	AH,1
	INT	16H
	PUSHF
	MOV	AH,0
	INT	16H
	POPF
	JNE	@@1
	XOR	DX,DX
	CMP	AL,13
	JE	@@2
	INC	DX
	CMP	AL,27
	JNE	@@1
@@2:	POP	CX
	PUSH	DX
	MOV	AH,1
	CALL	VideoInt
	POP	AX
end;

{$V-}

function SystemError(ErrorCode: Integer; Drive: Byte): Integer;
var
  C: Word;
  P: Pointer;
  S: string[63];
  B: array[0..79] of Word;
begin
  if FailSysErrors then
  begin
    SystemError := 1;
    Exit;
  end;

  if Lo(ScreenMode) = smMono then
    C := SysMonoAttr else
    C := SysColorAttr;
  P := Pointer(Drive + Ord('A'));
  FormatStr(S, PString(Ptr(DSeg, ErrorString[ErrorCode]))^, P);
  MoveChar(B, ' ', Byte(C), 80);
  MoveCStr(B[1], S, C);
  MoveCStr(B[79 - CStrLen(SRetryOrCancel)], SRetryOrCancel, C);
  SwapStatusLine(B);
  SystemError := SelectKey;
  SwapStatusLine(B);
end;

{$V+}

{ ******** UTILITY ROUTINES ******** }

{ Keyboard support routines }

const

  AltCodes1: array[$10..$32] of Char =
    'QWERTYUIOP'#0#0#0#0'ASDFGHJKL'#0#0#0#0#0'ZXCVBNM';

  AltCodes2: array[$78..$83] of Char =
    '1234567890-=';

function GetAltChar(KeyCode: Word): Char;
begin
  GetAltChar := #0;
  if Lo(KeyCode) = 0 then
    case Hi(KeyCode) of
      $02: GetAltChar := #240;
      $10..$32: GetAltChar := AltCodes1[Hi(KeyCode)];
      $78..$83: GetAltChar := AltCodes2[Hi(KeyCode)];
    end;
end;

function GetAltCode(Ch: Char): Word;
var
  I: Word;
begin
  GetAltCode := 0;
  if Ch = #0 then Exit;
  Ch := UpCase(Ch);
  if Ch = #240 then
  begin
    GetAltCode := $0200;
    Exit;
  end;
  for I := $10 to $32 do
    if AltCodes1[I] = Ch then
    begin
      GetAltCode := I shl 8;
      Exit;
    end;
  for I := $78 to $83 do
    if AltCodes2[I] = Ch then
    begin
      GetAltCode := I shl 8;
      Exit;
    end;
end;

function GetCtrlChar(KeyCode: Word): Char;
begin
  GetCtrlChar := #0;
  if (Lo(KeyCode) <> 0) and (Lo(KeyCode) <= Byte('Z') - Byte('A') + 1) then
    GetCtrlChar := Char(Lo(KeyCode) + Byte('A') - 1);
end;

function GetCtrlCode(Ch: Char): Word;
begin
  GetCtrlCode := GetAltCode(Ch) or (Byte(UpCase(Ch)) - Byte('A') + 1);
end;

function CtrlToArrow(KeyCode: Word): Word;
const
  NumCodes = 11;
  CtrlCodes: array[0..NumCodes-1] of Char = ^S^D^E^X^A^F^G^V^R^C^H;
  ArrowCodes: array[0..NumCodes-1] of Word =
    (kbLeft, kbRight, kbUp, kbDown, kbHome, kbEnd, kbDel, kbIns,
     kbPgUp, kbPgDn, kbBack);
var
  I: Integer;
begin
  CtrlToArrow := KeyCode;
  for I := 0 to NumCodes - 1 do
    if WordRec(KeyCode).Lo = Byte(CtrlCodes[I]) then
    begin
      CtrlToArrow := ArrowCodes[I];
      Exit;
    end;
end;

{ String formatting routines }

{$L FORMAT.OBJ}

procedure FormatStr(var Result: String; const Format: String; var Params);
external {FORMAT};

procedure PrintStr(const S: String);
var
  Result : word;
begin
  DosWrite(1 {STDOUT}, (PChar(@S)+1), length(S), @Result);
end;

{ Buffer move routines }

procedure MoveBuf(var Dest; var Source; Attr: Byte; Count: Word); assembler;
asm
	MOV	CX,Count
	JCXZ	@@5
	MOV	DX,DS
	LES	DI,Dest
	LDS	SI,Source
	MOV	AH,Attr
	CLD
	OR	AH,AH
	JE	@@3
@@1:	LODSB
	STOSW
	LOOP	@@1
	JMP	@@4
@@2:	INC	DI
@@3:	MOVSB
	LOOP	@@2
@@4:	MOV	DS,DX
@@5:
end;

procedure MoveChar(var Dest; C: Char; Attr: Byte; Count: Word); assembler;
asm
	MOV	CX,Count
	JCXZ	@@4
	LES	DI,Dest
	MOV	AL,C
	MOV	AH,Attr
	CLD
	OR	AL,AL
	JE	@@1
	OR	AH,AH
	JE	@@3
	REP	STOSW
	JMP	@@4
@@1:	MOV	AL,AH
@@2:	INC	DI
@@3:	STOSB
	LOOP	@@2
@@4:
end;

procedure MoveCStr(var Dest; const Str: String; Attrs: Word); assembler;
asm
	MOV	DX,DS
	LDS	SI,Str
	CLD
	LODSB
	MOV	CL,AL
	XOR	CH,CH
	JCXZ	@@3
	LES	DI,Dest
	MOV	BX,Attrs
	MOV	AH,BL
@@1:	LODSB
	CMP	AL,'~'
	JE	@@2
	STOSW
	LOOP	@@1
	JMP	@@3
@@2:	XCHG	AH,BH
	LOOP	@@1
@@3:	MOV	DS,DX
end;

procedure MoveStr(var Dest; const Str: String; Attr: Byte); assembler;
asm
	MOV	DX,DS
	LDS	SI,Str
	CLD
	LODSB
	MOV	CL,AL
	XOR	CH,CH
	JCXZ	@@4
	LES	DI,Dest
	MOV	AH,Attr
	OR	AH,AH
	JE	@@3
@@1:	LODSB
	STOSW
	LOOP	@@1
	JMP	@@4
@@2:	INC	DI
@@3:	MOVSB
	LOOP	@@2
@@4:	MOV	DS,DX
end;

function CStrLen(const S: String): Integer; assembler;
asm
	LES	DI,S
	MOV	CL,ES:[DI]
	INC	DI
	XOR	CH,CH
	MOV	BX,CX
        JCXZ    @@2
	MOV	AL,'~'
        CLD
@@1:	REPNE	SCASB
	JNE	@@2
	DEC	BX
	JMP	@@1
@@2:	MOV	AX,BX
end;

{ Drivers unit initialization and shutdown }

var
  SaveExit: Pointer;

procedure ExitDrivers; far;
begin
  DoneSysError;
  DoneEvents;
  ExitProc := SaveExit;
end;

begin
  DetectMouse;
  DetectVideo;
  SaveExit := ExitProc;
  ExitProc := @ExitDrivers;
end.
