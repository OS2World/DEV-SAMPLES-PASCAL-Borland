Program PatchBP; {--- 1993 Matthias Withopf / c't ---}

Var
  f : File of Byte;
  s : String;
  c : Byte;
  BP701 : Boolean;
  Error : Boolean;

  Procedure Chg(O1,O1a,O2,O2a,O3,O3a : LongInt;
		OldVal,NewVal : Array of Char);
  Var
    b : Byte;
    i : Integer;
    O : LongInt;
  Begin
    If BP701 then
      Case c of 1 : O := O1a; 2 : O := O2a; 3 : O := O3a; End
    else
      Case c of 1 : O := O1; 2 : O := O2; 3 : O := O3; End;
    If O <> 0 then
      Begin
	For i := Low(OldVal) to High(OldVal) do
	  Begin
	    Seek(f,O); Read(f,b); Seek(f,O);
	    If (b = Ord(OldVal[i])) or (b = Ord(NewVal[i])) then
	      Begin
		b := Ord(NewVal[i]); Write(f,b)
	      End
	    else
	      Begin
		WriteLn('Error applying patches! Aborted.');
		Close(f); Halt(50);
	      End;
	    Inc(O);
	  End;
      End;
  End;

Begin
  Error := True;
  If ParamCount >= 2 then
    Begin
      s := ParamStr(2) + ' ';
      c := Pos(UpCase(s[1]),'CIR');
      If c > 0 then Error := False;
      BP701 := ParamStr(3) = '701';
    End;
  If Error then
    Begin
      WriteLn('Syntax: PatchBP <Filename> C [701]  for BPC.EXE');
      WriteLn('        PatchBP <Filename> I [701]  for BP.EXE');
      WriteLn('        PatchBP <Filename> R [701]  for BP.RES');
      Halt(10);
    End;
  Assign(f,ParamStr(1)); Reset(f);
  { One InitTask() at Programmstart. }
  Chg($086F9,$08706,$1BBEF,$1BB30,$0	,$0    ,#6,#2);
  { Application Flags = 2. }
  Chg($0D3FE,$0D421,$20CAF,$20C06,$0	,$0    ,#3,#2);
  { (Compatible with Windowing API). }
  Chg($0D408,$0D42B,$20CB9,$20C10,$0	,$0    ,#$83,#$82);
  { Operating System = OS/2. }
  Chg($0D48B,$0D4AE,$20D3C,$20C93,$0	,$0    ,#2,#1);
  { Stub says 'This program requires OS/2' aus. }
  Chg($0E5AA,$0E5AA,$11BEC,$11AEC,$0	,$0,'Microso','OS/2'#13#10'$');
  { Compiler to report 'Version 7OS2'. }
  Chg($14C19,$14C19,$010C3,$010C3,$0	,$0    ,'.0 ','OS2');
  { Commandline parameter -CO = OS/2 target. }
  Chg($14D4B,$14D4B,$0	  ,$0	 ,$0	,$0    ,'W','O');
  Chg($14D4F,$14D4F,$0	  ,$0	 ,$0	,$0    ,'Windows','OS/2   ');
  Chg($01376,$01375,$0	  ,$0	 ,$0	,$0    ,'W','O');
  { Standard unit extension is 'TPO'. }
  Chg($15391,$15391,$617A7,$617A7,$0	,$0    ,'W','O');
  { 'OS2' written to the Symbol definitions. }
  Chg($1645E,$1645E,$61882,$61882,$0	,$0    ,#7'WINDO',#3'OS2'#0#2);
  { Compiler|Target = 'OS/2'. }
  Chg($0    ,$0    ,$6D290,$6D390,$02B9C,$02B9C,'W~indows','O~S/2   ');
  { Options|Compiler = 'OS/2'. }
  Chg($0    ,$0    ,$6D788,$6D888,$030D9,$030D9,'Windows','OS/2   ');
  { Options| = 'OS/2'. }
  Chg($0    ,$0    ,$6D949,$6DA49,$03298,$03298,'Windows','OS/2   ');
  { Standard library is 'OS2.TPL'. }
  Chg($1525A,$1525A,$6E86E,$6E96E,$04251,$04251,'TPW','OS2');
  { Compiler|Settings for = 'OS/2'. }
  Chg($0    ,$0    ,$70311,$70411,$06396,$06396,'Windows','OS/2   ');
  { Compiler machine = 'OS/2'. }
  Chg($0    ,$0    ,$779B5,$77AB5,$0E034,$0E034,'Windows','OS/2   ');
  WriteLn('Patch ok.');
  Close(f);
End.
