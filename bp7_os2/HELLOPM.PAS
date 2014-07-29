Program HelloPresentationManager; {$F+}
{--- 1993 Matthias Withopf / c't ---}

Type
  MResult = Pointer;
  HWnd	  = Pointer;
  MParam  = Pointer;
  HPS	  = Pointer;
  HAB	  = Pointer;
  HMQ	  = Pointer;
  PointL  = Record
	      x,y : LongInt;
	    End;
  PRectL  = ^RectL;
  RectL   = Record
	      xLeft,yBottom,xRight,yTop : LongInt;
	    End;
  QMsg	  = Record
	      Window  : HWND;
	      Msg     : Word;
	      mp1,mp2 : MParam;
	      Time    : LongInt;
	      Ptl     : PointL;
	    End;
Const
  WM_CREATE	     = $0001;
  WM_DESTROY	     = $0002;
  WM_COMMAND	     = $0020;
  WM_PAINT	     = $0023;
  WM_QUIT	     = $002A;
  WS_VISIBLE	     = $80000000;
  FCF_TITLEBAR	     = $0001;
  FCF_SYSMENU	     = $0002;
  FCF_MENU	     = $0004;
  FCF_SIZEBORDER     = $0008;
  FCF_MINBUTTON      = $0010;
  FCF_MAXBUTTON      = $0020;
  FCF_SHELLPOSITION  = $0400;
  FCF_TASKLIST	     = $0800;
  MB_ICONEXCLAMATION = $0020;
  MB_MOVEABLE	     = $4000;

  Function DosBeep(Freq,Duration : Word) : Word;
    External 'DOSCALLS' Index 50;
  Function WinRegisterClass(ab : HAB;ClassName : PChar;WndProc : Pointer;
			    Style : LongInt;WinData : Word) : Boolean;
    External 'PMWIN' Index 3;
  Function WinDestroyWindow(Window : HWND) : Boolean;
    External 'PMWIN' Index 7;
  Function WinQueryWindowRect(Window : HWND;R : PRECTL) : Boolean;
    External 'PMWIN' Index 26;
  Function WinBeginPaint(Window : HWND;PS : HPS;R : PRECTL) : HPS;
    External 'PMWIN' Index 45;
  Function WinEndPaint(PS : HPS) : Boolean;
    External 'PMWIN' Index 46;
  Function WinCreateMsgQueue(ab : HAB;Size : Word) : HMQ;
    External 'PMWIN' Index 58;
  Function WinDestroyMsgQueue(mq : HMQ) : Boolean;
    External 'PMWIN' Index 59;
  Function WinGetMsg(ab : HAB;Var Msg : QMsg;Filter : HWND;
		     Fist,Last : Word) : Boolean;
    External 'PMWIN' Index 65;
  Function WinDispatchMsg(ab : HAB;Var Msg : QMsg) : LongInt;
    External 'PMWIN' Index 68;
  Function WinPostMsg(hWnd : HWND;Msg : Word;mp1,mp2 : MParam) : Word;
    External 'PMWIN' Index 69;
  Function WinMessageBox(Parent,Owner : HWND;Text,Caption : PChar;
			 WindowID,Style : Word) : Word;
    External 'PMWIN' Index 139;
  Function WinCreateStdWindow(Parent : HWND;Style : LongInt;
			      Var CreateFlags : LongInt;
			      ClassName : PChar;Title : PChar;
			      ClientStyle : LongInt;
			      Module : Word;Res : Word;
			      Var ClientWnd : HWND) : HWND;
    External 'PMWIN' Index 140;
  Function WinDefWindowProc(Window : HWND;Msg : Word;
			    mp1,mp2 : MParam) : MResult;
    External 'PMWIN' Index 178;
  Function WinInitialize(Option : Word) : HAB;
    External 'PMWIN' Index 246;
  Function WinTerminate(ab : HAB) : Boolean;
    External 'PMWIN' Index 247;
  Function WinDrawText(PS : HPS;StrLen : Integer;Str : PChar;R : PRECTL;
		       FG,BG : LongInt;Cmd : Word) : HPS;
    External 'PMWIN' Index 267;

Var
  Frame,Client : HWND;
  ab	       : HAB;
  mq	       : HMQ;
  Msg	       : QMSG;
Const
  FrameFlags   : LongInt = FCF_TITLEBAR+FCF_SYSMENU+FCF_MENU+
			   FCF_SIZEBORDER+FCF_MINBUTTON+FCF_MAXBUTTON+
			   FCF_SHELLPOSITION+FCF_TASKLIST;

  Function ClientWndProc(Window : HWND;Msg : Word;
			 mp1,mp2 : MParam) : MResult; Export;
  Const
    Text = 'Hello, OS/2 Presentation Manager !';
  Var
    ps	: HPS;
    rcl : RECTL;
  Begin
     ClientWndProc := Nil;
     Case Msg of
       WM_CREATE : DosBeep(200,10);
	WM_PAINT : Begin
		     ps := WinBeginPaint(Window,Nil,Nil);
		     WinQueryWindowRect(Window,@rcl);
		     WinDrawText(ps,-1,Text,@rcl,0,7,$8500);
		     WinEndPaint(ps);
		   End;
      WM_COMMAND : Case Word(mp1) of
		     101 : DosBeep(4500,40);
		     109 : WinPostMsg(Nil,WM_QUIT,Nil,Nil);
		     201 : WinMessageBox(Frame,Window,
			    'HelloPM by Matthias Withopf / c''t',
			    'About...',0,MB_ICONEXCLAMATION+MB_MOVEABLE);
		   End;
      WM_DESTROY : DosBeep(500,10);
		 else
		   ClientWndProc := WinDefWindowProc(Window,Msg,mp1,mp2);
     End;
  End;

Begin
  ab := WinInitialize(0);
  mq := WinCreateMsgQueue(ab,0);
  WinRegisterClass(ab,'HELLOPM',@ClientWndProc,4,0);
  Frame := WinCreateStdWindow(HWND(1),WS_VISIBLE,FrameFlags,'HELLOPM',
			      Nil,0,0,1,Client);
  While (WinGetMsg(ab,Msg,Nil,0,0)) do WinDispatchMsg(ab,Msg);
  WinDestroyWindow(Frame);
  WinDestroyMsgQueue(mq);
  WinTerminate(ab);
End.
