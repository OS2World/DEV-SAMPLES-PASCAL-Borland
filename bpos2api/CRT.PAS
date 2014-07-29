Unit Crt;  {$R-,I-,S-,Q-,T-}

Interface

Uses
  OS2Def, OS2Subs;

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

  BW40     =   0;
  CO40     =   1;
  BW80     =   2;
  CO80     =   3;
  Mono     =   7;

  CheckBreak : boolean = true;

Var
  TextAttr : Byte;
  WindMin, WindMax : word;

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
  Procedure Window(X1, Y1, X2, Y2: Byte);
  Procedure ClrEol;
  Procedure DelLine;


  Procedure Delay(ms : Word);
  Procedure Sound(Hz: Word);
  Procedure NoSound;

  Procedure AssignCrt(Var f : Text);

Implementation

Uses
  Dos, DosProcs;
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
    VioScrollUp(hi(WindMin),lo(WindMin),hi(WindMax),lo(WindMax),
      hi(WindMax)-hi(WindMin)+1,Cell,0);
    GotoXY(1,1);
  End;

  Procedure GotoXY(x,y : Byte);
  Begin
    VioSetCurPos(y - 1 + hi(WindMin), x - 1 + lo(WindMin),0);
  End;

  Function WhereX : Byte;
  Var
    x,y : Word;
  Begin
    VioGetCurPos(y,x,0);
    WhereX:= x + 1 - lo(WindMin);
  End;

  Function WhereY : Byte;
  Var
    x,y : Word;
  Begin
    VioGetCurPos(y,x,0);
    WhereY:= y + 1 - hi(WindMin);
  End;

  Procedure Window(X1, Y1, X2, Y2: Byte);
  type
    WordRec = record lo,hi : byte end;
  begin
    WordRec(WindMin).lo := X1-1;
    WordRec(WindMin).hi := Y1-1;
    WordRec(WindMax).lo := X2-1;
    WordRec(WindMax).hi := Y2-1;
  end;

  procedure ClrEol;
  var
    Cell : Record
             c,a : Byte;
           End;
    x,y : word;
  begin
    Cell.c := ord(' ');
    Cell.a := TextAttr;
    VioGetCurPos(y,x,0);
    VioWrtNCell(Cell,lo(WindMax)-x+1,y,x,0);
  end;

  Procedure DelLine;
  begin

  end;

  procedure Sound(Hz: Word);
  begin
  end;

  procedure NoSound;
  begin
  end;

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
    VioGetCurPos(y,x,0);
    Cell := $20 + TextAttr Shl 8;
    i := 0;
    while (i < Len) do begin
      case s[i] of
        #8 : begin
               if x > lo(WindMin) then dec(x)
               else x := WindMax;
             end;
        ^G : ;
        ^M : x := lo(WindMin);
        ^J : inc(y);
      else
        VioWrtCharStrAtt(@s[i],1,y,x,TextAttr,0);
        inc(x);
      end;
      If x > lo(WindMax) then
        Begin
          x := 0; Inc(y);
        End;
      If y > hi(WindMax) then
        Begin
          VioScrollUp(hi(WindMin),lo(WindMin),hi(WindMax),lo(WindMax),
            1,Cell,0);
          y := hi(WindMax);
        End;
      inc(i);
    end;
    VioSetCurPos(y,x,0);
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
  WindMin := 0;
  WindMax := 79+24*256;
  AssignCrt(Input);
  Reset(Input);
  AssignCrt(Output);
  Rewrite(Output);
End.
