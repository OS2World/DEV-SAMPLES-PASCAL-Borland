Unit Dos;

Interface

uses
  DosTypes;

Const
  fmClosed = $D7B0;
  fmInput  = $D7B1;
  fmOutput = $D7B2;
  fmInOut  = $D7B3;

Const
  ReadOnly  = $01;
  Hidden    = $02;
  SysFile   = $04;
  VolumeID  = $08;
  Directory = $10;
  Archive   = $20;
  AnyFile   = $37;

Type
  ComStr  = String[127];
  PathStr = String[79];
  DirStr  = String[67];
  NameStr = String[8];
  ExtStr  = String[4];

Type
  FileRec = Record
              Handle   : Word;
              Mode     : Word;
              RecSize  : Word;
              Private  : Array[1..26] of Byte;
              UserData : Array[1..16] of Byte;
              Name     : Array[0..79] of Char;
            End;
Type
  TextBuf = Array[0..127] of Char;
  TextRec = Record
              Handle    : Word;
              Mode      : Word;
              BufSize   : Word;
              Private   : Word;
              BufPos    : Word;
              BufEnd    : Word;
              BufPtr    : ^TextBuf;
              OpenFunc  : Pointer;
              InOutFunc : Pointer;
              FlushFunc : Pointer;
              CloseFunc : Pointer;
              UserData  : Array[1..16] of Byte;
              Name      : Array[0..79] of Char;
              Buffer    : TextBuf;
            End;

Type
  SearchRec = Record
                Fill : Array[1..21] of Byte;
                Attr : Byte;
                Time : LongInt;
                Size : LongInt;
                Name : String[12];
              End;
  DateTime = record
    Year,Month,Day,Hour,Min,Sec: Word;
  end;

Const
  ExecFlags     : Word = 0;   { EXEC_SYNC }

Var
  DosError      : Integer;
  GlobalInfoSeg : PGlobalInfoSeg;
  LocalInfoSeg  : PLocalInfoSeg;

  Function  DosVersion : Word;
  Procedure GetDate(Var Year,Month,Day,DayofWeek : Word);
  Procedure SetDate(Year,Month,Day : Word);
  Procedure GetTime(Var Hour,Minute,Second,Sec100 : Word);
  Procedure SetTime(Hour,Minute,Second,Sec100 : Word);
  Procedure GetVerify(Var Verify : Boolean);
  Procedure SetVerify(Verify : Boolean);
  Function  DiskFree(Drive : Byte) : LongInt;
  Function  DiskSize(Drive : Byte) : LongInt;
  Procedure GetFAttr(Var f;Var Attr : Word);
  Procedure SetFAttr(Var f;Attr : Word);
  Procedure GetFTime(Var f;Var Time : LongInt);
  Procedure SetFTime(Var f;Time : LongInt);
  Procedure FindFirst(Path : PathStr;Attr : Word;Var S : SearchRec);
  Procedure FindNext(Var S : SearchRec);
  Procedure PackTime(Var T : DateTime;Var P : LongInt);
  Procedure UnpackTime(P : LongInt;Var T : DateTime);
  Function  FSearch(Path : PathStr;DirList : String) : PathStr;
  Function  FExpand(Path : PathStr) : PathStr;
  Procedure FSplit(Path : PathStr;Var Dir : DirStr;Var Name : NameStr;Var Ext : ExtStr);
  Function  EnvCount : Integer;
  Function  EnvStr(Index : Integer) : String;
  Function  GetEnv(EnvVar : String) : String;
  Procedure Exec(Path : PathStr;ComLine : ComStr);
  Function  DosExitCode : Word;
  Procedure PlaySound(Frequency,Duration : Word);

Implementation

uses
  DosProcs;

  Function DosVersion : Word;
  Var
    Version : Word;
  Begin
    DosGetVersion(Version);
    DosVersion := Version;
  End;

  Procedure GetDate(Var Year,Month,Day,DayofWeek : Word);
  Var
    DT : TDateTime;
  Begin
    DosGetDateTime(DT);
    Year      := DT.Year;
    Month     := DT.Month;
    Day       := DT.Day;
    DayOfWeek := DT.WeekDay;
  End;

  Procedure SetDate(Year,Month,Day : Word);
  Var
    DT : TDateTime;
  Begin
    DosGetDateTime(DT);
    If DosError = 0 then
      Begin
        DT.Year    := Year;
        DT.Month   := Month;
        DT.Day     := Day;
        DosSetDateTime(DT);
      End;
  End;

  Procedure GetTime(Var Hour,Minute,Second,Sec100 : Word);
  Var
    DT : TDateTime;
  Begin
    DosGetDateTime(DT);
    Hour   := DT.Hours;
    Minute := DT.Minutes;
    Second := DT.Seconds;
    Sec100 := DT.Hundredths;
  End;

  Procedure SetTime(Hour,Minute,Second,Sec100 : Word);
  Var
    DT : TDateTime;
  Begin
    DosGetDateTime(DT);
    DT.Hours      := Hour;
    DT.Minutes    := Minute;
    DT.Seconds    := Second;
    DT.Hundredths := Sec100;
    DosSetDateTime(DT);
  End;

  Procedure GetVerify(Var Verify : Boolean);
  Var
    V : Word;
  Begin
    DosError := DosQVerify(V);
    If DosError = 0 then
      Verify := Boolean(V)
    else
      Verify := False;
  End;

  Procedure SetVerify(Verify : Boolean);
  Begin
    DosError := DosSetVerify(Verify);
  End;

  Function DiskFree(Drive : Byte) : LongInt;
  Var
    FI : TFSAllocate;
  Begin
    DosError := DosQFSInfo(Drive,1,FI,sizeof(FI));
    If DosError = 0 then
      DiskFree := FI.cUnitAvail * FI.cSectorUnit * FI.cbSector
    else
      DiskFree := -1;
  End;

  Function DiskSize(Drive : Byte) : LongInt;
  Var
    FI : TFSAllocate;
  Begin
    DosError := DosQFSInfo(Drive,1,FI,sizeof(FI));
    If DosError = 0 then
      DiskSize := FI.cUnit * FI.cSectorUnit * FI.cbSector
    else
      DiskSize := -1;
  End;

  Procedure GetFAttr(Var f;Var Attr : Word);
  Var
    A : Word;
  Begin
    DosError := DosQFileMode(FileRec(f).Name,A,0);
    If DosError = 0 then
      Attr := A
    else
      Attr := 0;
  End;

  Procedure SetFAttr(Var f;Attr : Word);
  Begin
    DosError := DosSetFileMode(FileRec(f).Name,Attr,0);
  End;

  Procedure GetFTime(Var f;Var Time : LongInt);
  Var
    FI : TFileStatus;
    T1 : Record
           Time,Date : Word;
         End Absolute Time;
  Begin
    DosError := DosQFileInfo(FileRec(f).Handle,1,FI,SizeOf(FI));
    If DosError = 0 then
      Begin
        T1.Time := FI.fTimeLastWrite;
        T1.Date := FI.fDateLastWrite;
      End
    else
      Begin
        T1.Time := 0;
        T1.Date := 0;
      End;
  End;

  Procedure SetFTime(Var f;Time : LongInt);
  Var
    FI : TFileStatus;
    T1 : Record
           Time,Date : Word;
         End Absolute Time;
  Begin
    DosError := DosQFileInfo(FileRec(f).Handle,1,FI,SizeOf(FI));
    If DosError = 0 then
      Begin
        FI.fTimeLastWrite := T1.Time;
        FI.fDateLastWrite := T1.Date;
        DosError := DosSetFileInfo(FileRec(f).Handle,1,FI,SizeOf(FI));
      End;
  End;

  Procedure FindFirst(Path : PathStr;Attr : Word;Var S : SearchRec);
  Var
    FF    : TFileFindBuf;
    N     : String;
    Count : Word;
  Type
    PWord = ^Word;
  Begin
    N := Path + #0;
    Count := 1;
    PWord(@S)^ := $FFFF; { HDIR_CREATE }
    DosError := DosFindFirst(@N[1],PWord(@S)^,Attr,FF,SizeOf(FF),Count,0);
    If DosError = 0 then
      Begin
        S.Attr := FF.AttrFile;
        S.Time := (LongInt(FF.fDateLastWrite) Shl 16) + FF.fTimeLastWrite;
        S.Size := FF.cbFileAlloc;
        Move(FF.cchName,S.Name,SizeOf(S.Name))
      End;
  End;

  Procedure FindNext(Var S : SearchRec);
  Var
    FF    : TFileFindBuf;
    Count : Word;
  Type
    PWord = ^Word;
  Begin
    Count := 1;
    DosError := DosFindNext(PWord(@S)^,FF,SizeOf(FF),Count);
    If DosError = 0 then
      Begin
        S.Attr := FF.AttrFile;
        S.Time := (LongInt(FF.fDateLastWrite) Shl 16) + FF.fTimeLastWrite;
        S.Size := FF.cbFileAlloc;
        Move(FF.cchName,S.Name,SizeOf(S.Name))
      End
    else
      DosFindClose(PWord(@S)^);
  End;

  Procedure PackTime(Var T : DateTime;Var P : LongInt);
  Var
    P1 : Record
           Time,Date : Word;
         End Absolute P;
  Begin
    P1.Date := (T.Year - 1980) Shl 9 + T.Month Shl 5 + T.Day;
    P1.Time := T.Hour Shl 11 + T.Min Shl 5 + T.Sec Shr 1;
  End;

  Procedure UnpackTime(P : LongInt;Var T : DateTime);
  Var
    P1 : Record
           Time,Date : Word;
         End Absolute P;
  Begin
    T.Year  := P1.Date Shr 9 + 1980;
    T.Month := (P1.Date Shr 5) And 15;
    T.Day   := P1.Date And 31;
    T.Hour  := P1.Time Shr 11;
    T.Min   := (P1.Time Shr 5) And 63;
    T.Sec   := (P1.Time And 31) Shl 1;
  End;

  Function FSearch(Path : PathStr;DirList : String) : PathStr;
  Var
    Name   : String;
    Attrib : Word;
    p      : Byte;
  Begin
    FSearch := '';
    Name := Path;
    Repeat
      Name := Name + #0;
      DosError := DosQFileMode(@Name[1],Attrib,0);
      If (DosError = 0) and ((Attrib And $18) = 0) then
        Begin
          FSearch := Copy(Name,1,Length(Name) - 1);
          Break;
        End
      else
        Begin
          If DirList = '' then Break;
          p := Pos(';',DirList);
          If p <> 0 then
            Begin
              Name := Copy(DirList,1,p - 1) + '\' + Path;
              DirList := Copy(DirList,p + 1,255);
            End
          else
            Begin
              Name := DirList + '\' + Path;
              DirList := '';
            End;
        End;
    Until False;
  End;

  Function FExpand(Path : PathStr) : PathStr;
  Var
    s : String;
  Begin
    GetDir(0,s);
    If s <> '' then
      If s[Length(s) - 1] <> '\' then
        s := s + '\';
    FExpand := s + Path;
  End;

  Procedure FSplit(Path : PathStr;Var Dir : DirStr;Var Name : NameStr;Var Ext : ExtStr);
  Var
    l : Integer;
  Begin
    l := Length(Path);
    While Not(Path[l] in ['\',':']) and (l > 0) do Dec(l);
    Dir := Copy(Path,1,l);
    Path := Copy(Path,l + 1,255);
    l := Pos('.',Path);
    If l <> 0 then
      Begin
        Name := Copy(Path,1,l - 1);
        Ext  := Copy(Path,l,4);
      End
    else
      Begin
        Name := Path;
        Ext  := '';
      End;
  End;

  Function EnvCount : Integer;
  Var
    p   : PChar;
    i,l : Integer;
  Begin
    p := Ptr(EnvironmentSeg,0);
    i := 0;
    Repeat
      l := 0;
      While p^ <> #0 do
        Begin
          Inc(l); Inc(p);
        End;
      Inc(p);
      If l = 0 then Break;
      Inc(i);
    Until False;
    EnvCount := i;
  End;

  Function EnvStr(Index : Integer) : String;
  Var
    p : PChar;
    s : String;
    i : Integer;
  Begin
    p := Ptr(EnvironmentSeg,0);
    s := '';
    For i := 1 to Index do
      Begin
        s := '';
        While p^ <> #0 do
          Begin
            s := s + p^; Inc(p);
          End;
        Inc(p);
        If s = '' then Break;
      End;
    EnvStr := s;
  End;

  Function GetEnv(EnvVar : String) : String;
  Var
    Count,i : Integer;
    s       : String;
    p       : Byte;
  Begin
    Count := EnvCount;
    For i := 1 to Count do
      Begin
        s := EnvStr(i);
        p := Pos('=',s);
        If p <> 0 then
          If Copy(s,1,p - 1) = EnvVar then
            Begin
              GetEnv := Copy(s,p + 1,255);
              Exit;
            End;
      End;
    GetEnv := '';
  End;

Var
  ExecResult : TResultCodes;

  Procedure Exec(Path : PathStr;ComLine : ComStr);
  Var
    b : Array[0..255] of Char;
  Begin
    Path := Path + #0;
    ComLine := ComLine + #0#0;
    DosError := DosExecPgm(b,256,ExecFlags,@ComLine[1],Ptr(EnvironmentSeg,0),ExecResult,@Path[1]);
  End;

  Function DosExitCode : Word;
  Begin
    DosExitCode := ExecResult.CodeResult;
  End;

  Procedure PlaySound(Frequency,Duration : Word);
  Begin
    DosBeep(Frequency,Duration);
  End;

  Procedure DosInit;
  Var
    GlobalSel,LocalSel : Word;
  Begin
    If DosGetInfoSeg(GlobalSel,LocalSel) = 0 then
      Begin
        GlobalInfoSeg := Ptr(GlobalSel,0);
        LocalInfoSeg  := Ptr(LocalSel,0);
      End
    else
      Begin
        GlobalInfoSeg := Nil;
        LocalInfoSeg  := Nil;
      End;
  End;

Begin
  DosInit;
End.
