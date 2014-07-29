Unit Compatib;

Interface

Const
  FCarry     = $0001;
  FParity    = $0004;
  FAuxiliary = $0010;
  FZero      = $0040;
  FSign      = $0080;
  FOverflow  = $0800;

Type
  Registers = Record
                Case Integer of
                  0: (AX,BX,CX,DX,BP,SI,DI,DS,ES,Flags : Word);
                  1: (AL,AH,BL,BH,CL,CH,DL,DH          : Byte);
              End;

  { Only the interrupt vectors for INT 0,4,5,6,7,$10 can }
  { be accessed easily.                                  }

  Procedure GetIntVec(IntNo : Byte;Var Vector : Pointer);
  Procedure SetIntVec(IntNo : Byte;Vector : Pointer);
  Procedure Intr(IntNo : Byte;Var Regs : Registers);
  Procedure MsDos(Var Regs : Registers);

Implementation

  Function VioWrtTTY(s : PChar;Len : Word;VioHandle : Word) : Word; Far;
    External 'VIOCALLS' Index 19;
  Function DosSetVec(VecNum : Word;Handler : Pointer;Var PrevHandler : Pointer) : Word; Far;
    External 'DOSCALLS' Index 89;
  Procedure DosWrite(Handle : Word;Var Buf;Count : Word;Var WCount : Word); Far;
    External 'DOSCALLS' Index 138;

Type
  TKbdKeyInfo = Record
                  chChar    : Char;
                  chScan    : Char;
                  fbStatus  : Byte;
                  bNlsShift : Byte;
                  fsState   : Word;
                  time      : LongInt;
                End;

  Function KbdPeek(Var KeyInfo : TKbdKeyInfo;KbdHandle : Word) : Word; Far;
    External 'KBDCALLS' Index 22;

  Procedure GetIntVec(IntNo : Byte;Var Vector : Pointer);
  Var
    p : Pointer;
  Begin
    Vector := Nil;
    If DosSetVec(IntNo,Nil,p) = 0 then
      Begin
        Vector := p;
        DosSetVec(IntNo,p,p);
      End;
  End;

  Procedure SetIntVec(IntNo : Byte;Vector : Pointer);
  Var
    p : Pointer;
  Begin
    DosSetVec(IntNo,Vector,p);
  End;

  Procedure Intr(IntNo : Byte;Var Regs : Registers);
  Var
    w : Word;
    KeyInfo : TKbdKeyInfo;
  Begin
    Case IntNo of
      $16 : Case Regs.AH of
              $01 : Begin  { Check for keystroke. }
                      KbdPeek(KeyInfo,0);
                      If (KeyInfo.fbStatus And $40) <> 0 then
                        Begin
                          Regs.Flags := Regs.Flags And Not(FZero);
                          Regs.AL    := Ord(KeyInfo.chChar);
                          Regs.AH    := Ord(KeyInfo.chScan);
                        End
                      else
                        Regs.Flags := Regs.Flags Or FZero;
                      Exit;
                    End;
            End;
      $21 : Case Regs.AH of
              $09 : Begin  { Write string to standard output. }
                      w := 0;
                      While Mem[Regs.DS:Regs.DX + w] <> Ord('$') do Inc(w);
                      DosWrite(1,Ptr(Regs.DS,Regs.DX)^,w,w);
                      Exit;
                    End;
            End;
    End;
    VioWrtTTY('Unsupported INT'^M^J,17,0);
    RunError(99);
  End;

  Procedure MsDos(Var Regs : Registers);
  Begin
    Intr($21,Regs);
  End;

End.
