Program MakePM;  {--- 1993 Matthias Withopf / c't ---}
Var
  f : File of Byte;
  b : Byte;
Begin
  If ParamCount <> 1 then
    Begin
      WriteLn('Syntax: MAKEPM <TEST.EXE>');
      Halt(20);
    End;
  Assign(f,ParamStr(1)); Reset(f);
  Seek(f,$010D); Read(f,b);
  If b in [2,3] then
    Begin
      Seek(f,$010D); b := 3; Write(f,b);
    End
  else
    Begin
      WriteLn('Error in setting the application flags.');
      WriteLn('Possibly not an OS/2 program.');
    End;
  Close(f);
End.
