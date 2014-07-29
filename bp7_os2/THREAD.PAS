Program ThreadTest;  {--- 1993 Matthias Withopf / c't ---}

Uses
  Crt;

  Function DosCreateThread(Proc : Pointer;Var TID : Word;
			   Stack : Pointer) : Word; Far;
    External 'DOSCALLS' Index 145;
  Function DosWrite(Handle : Word;Str : PChar;Count : Word;
		    Var WCount : Word) : Word; Far;
    External 'DOSCALLS' Index 138;
  Function DosExit(x : Word;ExitCode : Word) : Word; Far;
    External 'DOSCALLS' Index 5;

Const
  Thread1Terminated : Boolean = False;

{$S-} { Stack checking off, this will have a seperate stack space. }

  Procedure Thread1; Far;
  Const
    Str = 'This is Thread1 active.'^M^J;
  Var
    w : Word;
  Begin
    Repeat
      DosWrite(1,Str,Length(Str),w);
      Delay(700);
      If KeyPressed then
	Begin
	  Thread1Terminated := True;
	  DosExit(0,0);  { Terminate only Thread1, not the program. }
	End;
    Until False;
  End;

{$S+} { Stack Checking on, this will be in the main stack. }

Const
  StackSize = 8192;
Var
  Thread1ID : Word;
  Stack1    : Pointer;
Begin
  GetMem(Stack1,StackSize);		 { Allocate a stack for Thread1. }
  DosCreateThread(@Thread1,		 { Address of procedure Thread1 }
		  Thread1ID,
		  { And the stack pointer to initialize SS:SP. }
		  @PChar(Stack1)[StackSize]);
  Repeat
    WriteLn('The main program unit is active.');
    Delay(1100);
  Until Thread1Terminated;
  FreeMem(Stack1,StackSize);		 { Free memory for Thread1's stack. }
  WriteLn('Program ends');
End.
