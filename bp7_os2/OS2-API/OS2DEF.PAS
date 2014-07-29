
(*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*)
(*                                                                   *)
(*     Borland Pascal OS/2 API                                       *)
(*                                                                   *)
(*     OS2DEF   - System types, constants and macros                 *)
(*                                                                   *)
(*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*)

unit OS2DEF;
{$IFNDEF OS2}

'Can only compile this unit with OS/2 target.'

{$ENDIF}

interface

(* ------------------------ CONSTANTS AND TYPES --------------------------- *)

const
  NULLHANDLE                              = (0);
  NULLSHANDLE                             = (0);

  NULL                                    = nil;

type

{  INT = Integer;
  UINT = Word;
  APIRET = Integer;}

  BOOL = WordBool;
  PBOOL = ^BOOL;

  BOOL32 = LongBool;
  PBOOL32 = ^BOOL32;

  PPCHAR = ^PChar;

  PUCHAR = ^Char;

  PBYTE = ^Byte;

  PInteger = ^Integer;

  PWord = ^Word;

  PLongint = ^Longint;

  PPVOID = ^Pointer;

  PCH = PChar;
  PPSZ = ^PChar;
  CONSTPCH = PChar;

  CONSTPVOID = Pointer;
  CONSTPSZ = PChar;

  STR8 = array[0..8-1] of Char;
  PSTR8 = ^STR8;

  STR16 = array[0..16-1] of Char;
  PSTR16 = ^STR16;
  STR32 = array[0..32-1] of Char;
  PSTR32 = ^STR32;
  STR64 = array[0..64-1] of Char;
  PSTR64 = ^STR64;

  SHANDLE = Word;
  LHANDLE = Pointer;

  HFILE = SHANDLE;
  PHFILE = ^HFILE;

  HPIPE = SHANDLE;
  PHPIPE = ^HPIPE;

  HQUEUE = SHANDLE;
  PHQUEUE = ^HQUEUE;

  HMODULE = SHANDLE;
  PHMODULE = ^HMODULE;

  PID = Longint;
  PPID = ^PID;

  TID = Longint;
  PTID = ^TID;

  TFN = function : Longint;
  PFN = ^TFN;
  PPFN = ^PFN;

  COLOR = Longint;
  PCOLOR = ^COLOR;

  HPAL = LHANDLE;
  PHPAL = ^HPAL;

  HBITMAP = LHANDLE;
  PHBITMAP = ^HBITMAP;

  HMF = LHANDLE;
  PHMF = ^HMF;

  ERRORID = Longint;
  PERRORID = ^ERRORID;

  SEL = Word;
  PSEL = ^SEL;
{
const
  FIELDOFFSET                             = (t,f)  ((Integer) and (((t *)0)->field));

  MAKETYPE                                = (v,t)     (*((t *) and v));

  MAKEUSHORT                              = (l,h)   (((Word)(l))  or  ((Word)(h)) shl 8);
  MAKESHORT                               = (l,h)    ((Integer)MAKEUSHORT(l, h));

  MAKEULONG                               = (l,h)    ((Longint)(((Word)(l))  or  ((Longint)((Word)(h))) shl 16));
  MAKELONG                                = (l, h)    ((Longint)MAKEULONG(l, h));

  LOUCHAR                                 = (w)        ((Char)(w));
  HIUCHAR                                 = (w)        ((Char)((Word)(w) shr 8));

  LOBYTE                                  = (x)         LOUCHAR(x);
  HIBYTE                                  = (x)         HIUCHAR(x);

  LOUSHORT                                = (x)       ((Word)((Longint)(x)));
  HIUSHORT                                = (x)       ((Word)((Longint)(x) shr 16));
}

{ Various inline and wrapper routines }

function MakeLong(A, B: Word): LongInt;
inline(
  $5A/    { POP DX }
  $58);   { POP AX }

function LoWord(A: LongInt): Word;
inline(
  $58/    { POP AX }
  $5A);   { POP DX }

function HiWord(A: LongInt): Word;
inline(
  $5A/    { POP DX }
  $58);   { POP AX }

function LoByte(A: Word): Byte;
inline(
  $58/       { POP AX    }
  $32/$E4);  { XOR AH,AH }

function HiByte(A: Word): Byte;
inline(
  $58/       { POP AX    }
  $8A/$C4/   { MOV AL,AH }
  $32/$E4);  { XOR AH,AH }

implementation

end.
