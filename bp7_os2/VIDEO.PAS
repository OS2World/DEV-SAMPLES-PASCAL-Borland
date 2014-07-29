Program DirectVideoAccess;  {--- 1993 Matthias Withopf / c't ---}

  Function VioGetBuf(Var Buf : PChar;Var BufSize : Word;
		     VioHandle : Word) : Word; Far;
    External 'VIOCALLS' Index 31;
  Function VioShowBuf(BufOfs : Word;BufSize : Word;
		      VioHandle : Word) : Word; Far;
    External 'VIOCALLS' Index 43;

Var
  Screen  : PChar;
  ScrSize : Word;
  i,x,y   : Integer;
Begin
  VioGetBuf(Screen,ScrSize,0); { Load address of the logical video buffer.}
  For i := 0 to 24 do
    Begin
      x := i; y := i;
      Screen[y * 160 + x * 2	] := Chr(Ord('A') + i);
      Screen[y * 160 + x * 2 + 1] := Chr(7 + i And 7);
    End;
  VioShowBuf(0,ScrSize,0);     { Build the actual visual screen. }
End.
