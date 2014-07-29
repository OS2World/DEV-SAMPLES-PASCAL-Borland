Program HelloOS2;  {$R-,I-,S-,Q-}
{--- 1993 Matthias Withopf / c't ---}

  Procedure DosWrite(Handle : Word;Str : PChar;
		     Count : Word;Var WCount : Word); Far;
    External 'DOSCALLS' Index 138;
  Procedure DosExit(x : Word;ExitCode : Word); Far;
    External 'DOSCALLS' Index 5;

Var
  w : Word;
Begin
  DosWrite(1,'Hello, OS/2!'^M^J,14,w);
  DosExit(1,0);
End.
