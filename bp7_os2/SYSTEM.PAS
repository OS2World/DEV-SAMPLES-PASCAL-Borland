{//////////////////////////////////////////////////////}
{/                                                    /}
{/ Run-time Library fÅr Borland Pascal 7.0 unter OS/2 /}
{/ System-Unit.                                       /}
{/                                                    /}
{/ 1993 Matthias Withopf / c't                        /}
{/ Originalversion (c) 1988,92 Borland International  /}
{/                                                    /}
{//////////////////////////////////////////////////////}

Unit System;

{$C MOVEABLE PRELOAD PERMANENT}

Interface

Const
  CmdLine        : PChar   = Nil;  { Zeiger auf Kommandozeile.              }
  HeapList       : Word    = 0;    { Selektor der Heapliste.                }
  HeapLimit      : Word    = 1024; { Grenze fÅr 'Small Blocks'.             }
  HeapBlock      : Word    = 8192; { Grî·e eines globalen Heap-Blocks.      }
  HeapAllocFlags : Word    = 0;    { Heap-Allozierungsflags, SEG_NONSHARED. }
  HeapError      : Pointer = Nil;  { Zeiger auf HeapError-Funktion.         }
  ExitProc       : Pointer = Nil;  { Zeiger auf Exit-Prozedur.              }
  ExitCode       : Integer = 0;    { Exit-Code des Programms.               }
  ErrorAddr      : Pointer = Nil;  { Adresse des Runtime-Errors.            }
  EnvironmentSeg : Word    = 0;    { Selektor des Environment-Blocks.       }
  InOutRes       : Integer = 0;    { Fehlercode der I/O-Operationen.        }
  RandSeed       : Longint = 0;    { Startwert fÅr Zufallsgenerator.        }
  SelectorInc    : Word    = 0;    { Selektor-Inkrement-Wert.               }
  Test8086       : Byte    = 0;    { Prozessortyp.                          }
  FileMode       : Word    = $0040;{ Dateimodus, OPEN_SHARE_DENYNONE.       }

Var
  Input          : Text;           { Standard-Eingabe.                      }
  Output         : Text;           { Standard-Ausgabe.                      }
  SaveInt00      : Pointer;        { Alter Vektor fÅr INT $00.              }
  SaveInt0C      : Pointer;        { Alter Vektor fÅr INT $0C.              }
  SaveInt0D      : Pointer;        { Alter Vektor fÅr INT $0D.              }

Implementation

  Procedure InitTurbo;   External {WAPP};
  Procedure HaltError;   External {WEND};
  Procedure HaltTurbo;   External {WEND};
  Procedure BlockMove;   External {VARH};
  Procedure LongMul;     External {LONG};
  Procedure LongDiv;     External {LONG};
  Procedure LongShr;     External {LONG};
  Procedure LongShl;     External {LONG};
  Procedure LongMulOvf;  External {LOVF};
  Procedure Overflow;    External {ERRC};
  Procedure SLoad;       External {STRH};
  Procedure SStore;      External {STRH};
  Procedure RangeError;  External {ERRC};
  Procedure SCopy;       External {STRH};
  Procedure SConcat;     External {STRH};
  Procedure SPos;        External {STRH};
  Procedure SCompare;    External {STRH};
  Procedure SChar;       External {STRH};
  Procedure SPacked;     External {STRH};
  Procedure SInsert;     External {STRH};
  Procedure SDelete;     External {STRH};
  Procedure ZLoad;       External {SETH};
  Procedure ZStore;      External {SETH};
  Procedure ZBitMask;    External {SETH};
  Procedure FTrunc;      External {F87H};
  Procedure FRound;      External {F87H};
  Procedure FInt;        External {F87H};
  Procedure FSqrt;       External {F87H};
  Procedure FSin;        External {F87H};
  Procedure FCos;        External {F87H};
  Procedure FArcTan;     External {F87H};
  Procedure FLn;         External {F87H};
  Procedure FExp;        External {F87H};
  Procedure NewPtr;      External {WMEM};
  Procedure DisposePtr;  External {WMEM};
  Procedure MarkPtr;     External {WMEM};
  Procedure ReleasePtr;  External {WMEM};
  Procedure GetFreMem;   External {WMEM};
  Procedure GetFreMax;   External {WMEM};
  Procedure ZWordLoad;   External {SETH};
  Procedure ZAddComp;    External {SETH};
  Procedure ZAddRange;   External {SETH};
  Procedure ZUnion;      External {SETH};
  Procedure ZDifference; External {SETH};
  Procedure ZIntersect;  External {SETH};
  Procedure ZEqual;      External {SETH};
  Procedure ZRelation;   External {SETH};
  Procedure GetParCnt;   External {WPAR};
  Procedure GetIORes;    External {ERRC};
  Procedure InOutCheck;  External {ERRC};
  Procedure RangeCheck;  External {ERRC};
  Procedure StackCheck;  External {ERRC};
  Procedure WriteFloat;  External {TF87};
  Procedure WriteStr;    External {TSTR};
  Procedure WriteInt;    External {TINT};
  Procedure WriteBool;   External {TBOL};
  Procedure WriteChar;   External {TCHR};
  Procedure WriteLine;   External {TCTL};
  Procedure WriteEnd;    External {TCTL};
  Procedure WriteFile;   External {FCTL};
  Procedure ReadFloat;   External {TF87};
  Procedure ReadStr;     External {TSTR};
  Procedure ReadInt;     External {TINT};
  Procedure ReadChar;    External {TCHR};
  Procedure ReadLine;    External {TCTL};
  Procedure ReadEnd;     External {TCTL};
  Procedure ReadFile;    External {FCTL};
  Procedure InitRand;    External {RAND};
  Procedure AssignText;  External {TCTL};
  Procedure ResetText;   External {TCTL};
  Procedure RewriteText; External {TCTL};
  Procedure CloseText;   External {TCTL};
  Procedure AssignFile;  External {FCTL};
  Procedure ResetFile;   External {FCTL};
  Procedure RewriteFile; External {FCTL};
  Procedure CloseFile;   External {FCTL};
  Procedure EraseFile;   External {FDIR};
  Procedure RenameFile;  External {FDIR};
  Procedure GetSEoln;    External {TFUN};
  Procedure GetSEof;     External {TFUN};
  Procedure GetTEoln;    External {TFUN};
  Procedure GetTEof;     External {TFUN};
  Procedure ReadBlock;   External {FCTL};
  Procedure WriteBlock;  External {FCTL};
  Procedure SeekFile;    External {FCTL};
  Procedure GetFPos;     External {FFUN};
  Procedure GetFSize;    External {FFUN};
  Procedure GetFEof;     External {FFUN};
  Procedure FFrac;       External {F87H};
  Procedure UpperCase;   External {CHAR};
  Procedure TruncFile;   External {FCTL};
  Procedure FillMem;     External {MEMH};
  Procedure RandInt;     External {RAND};
  Procedure RandFloat;   External {RAND};
  Procedure GetParStr;   External {WPAR};
  Procedure MoveMem;     External {MEMH};
  Procedure StrInt;      External {SINT};
  Procedure ValInt;      External {SINT};
  Procedure StrFloat;    External {SF87};
  Procedure ValFloat;    External {SF87};
  Procedure DirGet;      External {DIRH};
  Procedure DirSet;      External {DIRH};
  Procedure DirCreate;   External {DIRH};
  Procedure DirRemove;   External {DIRH};
  Procedure AppendText;  External {TCTL};
  Procedure FlushText;   External {TCTL};
  Procedure BufferText;  External {TCTL};
  Procedure FRealExt;    External {F87H};
  Procedure FExtReal;    External {F87H};
  Procedure RAdd;        External {F48H};
  Procedure RSub;        External {F48H};
  Procedure RMul;        External {F48H};
  Procedure RDiv;        External {F48H};
  Procedure RCmp;        External {F48H};
  Procedure RFloat;      External {F48H};
  Procedure RTrunc;      External {F48H};
  Procedure RRound;      External {F48H};
  Procedure RSqr;        External {F48H};
  Procedure WriteReal;   External {TF48};
  Procedure ReadReal;    External {TF48};
  Procedure StrReal;     External {SF48};
  Procedure ValReal;     External {SF48};
  Procedure RInt;        External {F48F};
  Procedure RFrac;       External {F48F};
  Procedure RSqrt;       External {F48F};
  Procedure RSin;        External {F48F};
  Procedure RCos;        External {F48F};
  Procedure RLn;         External {F48F};
  Procedure RExp;        External {F48F};
  Procedure RArcTan;     External {F48F};
  Procedure RandReal;    External {RAND};
  Procedure InitEM86;    External {EI86};
  Procedure InitEM87;    External {EI87};
  Procedure Construct;   External {OBJH};
  Procedure Destruct;    External {OBJH};
  Procedure CopyObject;  External {OBJH};
  Procedure MethodCheck; External {OBJH};
  Procedure FindMethod;  External {DMTH};
  Procedure CallMethod;  External {DMTH};
  Procedure ReadPChar;   External {TPCH};
  Procedure WritePChar;  External {TPCH};
  Procedure AssignTextC; External {TCTL};
  Procedure AssignFileC; External {FCTL};
  Procedure RenameFileC; External {FDIR};
  Procedure StrIntC;     External {CINT};
  Procedure ValIntC;     External {CINT};
  Procedure StrFloatC;   External {CF87};
  Procedure ValFloatC;   External {CF87};
  Procedure StrRealC;    External {CF48};
  Procedure ValRealC;    External {CF48};
  Procedure LibEntry;    External {WLIB};
  Procedure LibExit;     External {WLIB};
  Procedure LibExitProc; Export; External {WLIB};

  Procedure DosExit; Far;         External 'DOSCALLS' Index $0005;
  Procedure DosGetDateTime; Far;  External 'DOSCALLS' Index $0021;
  Procedure DosAllocSeg; Far;     External 'DOSCALLS' Index $0022;
  Procedure DosFreeSeg; Far;      External 'DOSCALLS' Index $0027;
  Procedure DosGetHugeShift; Far; External 'DOSCALLS' Index $0029;
  Procedure DosChDir; Far;        External 'DOSCALLS' Index $0039;
  Procedure DosChgFilePtr; Far;   External 'DOSCALLS' Index $003A;
  Procedure DosClose; Far;        External 'DOSCALLS' Index $003B;
  Procedure DosDelete; Far;       External 'DOSCALLS' Index $003C;
  Procedure DosMkDir; Far;        External 'DOSCALLS' Index $0042;
  Procedure DosMove; Far;         External 'DOSCALLS' Index $0043;
  Procedure DosNewSize; Far;      External 'DOSCALLS' Index $0044;
  Procedure DosOpen; Far;         External 'DOSCALLS' Index $0046;
  Procedure DosQCurDir;  Far;     External 'DOSCALLS' Index $0047;
  Procedure DosQCurDisk; Far;     External 'DOSCALLS' Index $0048;
  Procedure DosQHandType; Far;    External 'DOSCALLS' Index $004D;
  Procedure DosRmDir; Far;        External 'DOSCALLS' Index $0050;
  Procedure DosSelectDisk; Far;   External 'DOSCALLS' Index $0051;
  Procedure DosSetVec; Far;       External 'DOSCALLS' Index $0059;
  Procedure DosGetEnv; Far;       External 'DOSCALLS' Index $005B;
  Procedure DosMemAvail; Far;     External 'DOSCALLS' Index $007F;
  Procedure DosRead; Far;         External 'DOSCALLS' Index $0089;
  Procedure DosWrite; Far;        External 'DOSCALLS' Index $008A;
  Procedure __FPMath; far;        External 'WIN87EM'  Index $0001;

{$L WAPP.OBW} {$L WLIB.OBW} {$L WEND.OBW} {$L WMEM.OBW} {$L ERRC.OBW} 
{$L OBJH.OBW} {$L DF87.OBW} {$L TCTL.OBW} {$L TGPC.OBW} {$L TCHR.OBW} 
{$L TSTR.OBW} {$L TPCH.OBW} {$L TBOL.OBW} {$L TINT.OBW} {$L TF48.OBW} 
{$L TF87.OBW} {$L TFUN.OBW} {$L FCTL.OBW} {$L FDIR.OBW} {$L CINT.OBW}
{$L CF48.OBW} {$L CF87.OBW} {$L WPAR.OBW} {$L DIRH.OBW} {$L WI87.OBW} 
{$L WE87.OBW} {$L WF87.OBJ} {$L VARH.OBJ} {$L LONG.OBJ} {$L LOVF.OBJ} 
{$L STRH.OBJ} {$L SETH.OBJ} {$L FP48.OBJ} {$L F48H.OBJ} {$L F48F.OBJ} 
{$L RAND.OBJ} {$L DINT.OBJ} {$L DF48.OBJ} {$L SINT.OBJ} {$L SF48.OBJ} 
{$L SF87.OBJ} {$L FFUN.OBJ} {$L MEMH.OBJ} {$L CHAR.OBJ} {$L DMTH.OBJ} 

End.
