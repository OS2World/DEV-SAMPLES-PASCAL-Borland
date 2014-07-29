Unit Crt;  {$R-,I-,S-,Q-}

Interface

Const
  Black         =  0;
  Blue          =  1;
  Green         =  2;
  Cyan          =  3;
  Red           =  4;
  Magenta       =  5;
  Brown         =  6;
  LightGray     =  7;
  DarkGray      =  8;
  LightBlue     =  9;
  LightGreen    = 10;
  LightCyan     = 11;
  LightRed      = 12;
  LightMagenta  = 13;
  Yellow        = 14;
  White         = 15;
  Blink         = 128;
  LastMode      = $07;

Var
  TextAttr : Byte;

  Function KeyPressed : Boolean;
  Function ReadKey : Char;

  Procedure ClrScr;
  Procedure GotoXY(x,y : Byte);
  Function WhereX : Byte;
  Function WhereY : Byte;
  Procedure TextMode(Mode : Integer);
  Procedure TextColor(Color : Byte);
  Procedure TextBackground(Color : Byte);
  Procedure LowVideo;
  Procedure NormVideo;
  Procedure HighVideo;


  Procedure Delay(ms : Word);

  Procedure AssignCrt(Var f : Text);

Implementation

Uses
  Dos;

Type
  TKbdKeyInfo = Record
                  chChar    : Char;
                  chScan    : Char;
                  fbStatus  : Byte;
                  bNlsShift : Byte;
                  fsState   : Word;
                  time      : LongInt;
                End;

  Function KbdCharIn(Var KeyInfo : TKbdKeyInfo;Wait : Word;KbdHandle : Word) : Word; Far;
    External 'KBDCALLS' Index 4;
  Function KbdPeek(Var KeyInfo : TKbdKeyInfo;KbdHandle : Word) : Word; Far;
    External 'KBDCALLS' Index 22;

  Function DosSleep(Time : LongInt) : Word; Far;
    External 'DOSCALLS' Index 32;

  Function VioScrollUp(TopRow,LeftCol,BotRow,RightCol : Word;Lines : Word;Var Cell;VioHandle : Word) : Word; Far;
    External 'VIOCALLS' Index 7;
  Function VioGetCurPos(Var Row,Column : Word;VioHandle : Word) : Word; Far;
    External 'VIOCALLS' Index 9;
  Function VioSetCurPos(Row,Column : Word;VioHandle : Word) : Word; Far;
    External 'VIOCALLS' Index 15;
  Function VioWrtTTY(s : PChar;Len : Word;VioHandle : Word) : Word; Far;
    External 'VIOCALLS' Index 19;
  Function VioWrtCharStrAtt(s : PChar;Len : Word;Row,Col : Word;Var Attr : Byte;VioHandle : Word) : Word; Far;
    External 'VIOCALLS' Index 48;

Const
  ExtKeyChar : Char = #0;

  Function KeyPressed : Boolean;
  Var
    KeyInfo : TKbdKeyInfo;
  Begin
    KbdPeek(KeyInfo,0);
    KeyPressed:= (ExtKeyChar <> #0) or ((KeyInfo.fbStatus And $40) <> 0);
  End;

  Function ReadKey : Char;
  Var
    KeyInfo : TKbdKeyInfo;
  Begin
    If ExtKeyChar <> #0 then
      Begin
        ReadKey:= ExtKeyChar;
        ExtKeyChar:= #0
      End
    else
      Begin
        KbdCharIn(KeyInfo,0,0);
        If KeyInfo.chChar = #0 then
          ExtKeyChar:= KeyInfo.chScan;
        ReadKey:= KeyInfo.chChar;
      End;
  End;

  Procedure ClrScr;
  Var
    Cell : Record
             c,a : Byte;
           End;
  Begin
    Cell.c:= $20;
    Cell.a:= TextAttr;
    VioScrollUp(0,0,24,79,25,Cell,0);
    GotoXY(1,1);
  End;

  Procedure GotoXY(x,y : Byte);
  Begin
    VioSetCurPos(y  - 1,x - 1,0);
  End;

  Function WhereX : Byte;
  Var
    x,y : Word;
  Begin
    VioGetCurPos(y,x,0);
    WhereX:= x + 1;
  End;

  Function WhereY : Byte;
  Var
    x,y : Word;
  Begin
    VioGetCurPos(y,x,0);
    WhereY:= y + 1;
  End;

  Procedure TextMode(Mode : Integer);
  Begin
    TextAttr:= $07;
  End;

  Procedure TextColor(Color : Byte);
  Begin
    TextAttr:= (TextAttr And $70) or (Color and $0F) + Ord(Color > $0F) * $80;
  End;

  Procedure TextBackground(Color : Byte);
  Begin
    TextAttr:= (TextAttr And $8F) or ((Color And $07) Shl 4);
  End;

  Procedure LowVideo;
  Begin
    TextAttr:= TextAttr And $F7;
  End;

  Procedure NormVideo;
  Begin
    TextAttr:= $07;
  End;

  Procedure HighVideo;
  Begin
    TextAttr:= TextAttr Or $08;
  End;

  Procedure Delay(ms : Word);
  Begin
    DosSleep(ms);
  End;

  Procedure WritePChar(s : PChar;Len : Word);
  Var
    x,y  : Word;
    c    : Char;
    i    : Integer;
    Cell : Word;
  Begin
    For i:= 0 to Len - 1 do
      Begin
        If s[i] in [#$08,^G,^M,^J] then
          VioWrtTTY(@s[i],1,0)
        else
          Begin
            VioGetCurPos(y,x,0);
            VioWrtCharStrAtt(@s[i],1,y,x,TextAttr,0);
            Inc(x);
            If x > 79 then
              Begin
                x:= 0; Inc(y);
              End;
            If y > 24 then
              Begin
                Cell:= $20 + TextAttr Shl 8;
                VioScrollUp(0,0,24,79,25,Cell,0);
                y:= 24;
              End;
            VioSetCurPos(y,x,0);
          End;
      End;
  End;

  Function CrtRead(Var f : Text) : Word; Far;
  Var
    Max    : Integer;
    CurPos : Integer;
    c      : Char;
    i      : Integer;
    c1     : Array[0..2] of Char;
  Begin
    With TextRec(f) do
      Begin
        Max:= BufSize - 2;
        CurPos:= 0;
        Repeat
          c:= ReadKey;
          Case c of
         #8 : Begin
                If CurPos > 0 then
                  Begin
                    c1:= #8' '#8; WritePChar(@c1,3);
                    Dec(CurPos);
                  End;
              End;
         ^M : Begin
                BufPtr^[CurPos]:= #$0D; Inc(CurPos);
                BufPtr^[CurPos]:= #$0A; Inc(CurPos);
                BufPos:= 0;
                BufEnd:= CurPos;
                Break;
              End;
  #32..#255 : If CurPos < Max then
                Begin
                  BufPtr^[CurPos]:= c; Inc(CurPos);
                  WritePChar(@c,1);
                End;
          End;
        Until False;
      End;
    CrtRead:= 0;
  End;

  Function CrtWrite(Var f : Text) : Word; Far;
  Begin
    With TextRec(f) do
      Begin
        WritePChar(PChar(BufPtr),BufPos);
        BufPos:= 0;
      End;
    CrtWrite:= 0;
  End;

  Function CrtReturn(Var f : Text) : Word; Far;
  Begin
    CrtReturn:= 0;
  End;

  Function CrtOpen(Var f : Text) : Word; Far;
  Var
    InOut,
    Flush,
    Close : Pointer;
  Begin
    With TextRec(f) do
      Begin
        If Mode = fmInput then
          Begin
            InOut:= @CrtRead;
            Flush:= @CrtReturn;
            Close:= @CrtReturn;
          End
        else
          Begin
            Mode:= fmOutput;
            InOut:= @CrtWrite;
            Flush:= @CrtWrite;
            Close:= @CrtReturn;
          End;

        InOutFunc:= InOut;
        FlushFunc:= Flush;
        CloseFunc:= Close;
      End;
    CrtOpen:= 0;
  End;

  Procedure AssignCrt(Var f : Text);
  Begin
    With TextRec(f) do
      Begin
        Mode:= fmClosed;
        BufSize:= 128;
        BufPtr:= @Buffer;
        OpenFunc:= @CrtOpen;
      End;
  End;

Begin
  TextAttr:= LightGray;
  AssignCrt(Input);
  Reset(Input);
  AssignCrt(Output);
  Rewrite(Output);
End.
