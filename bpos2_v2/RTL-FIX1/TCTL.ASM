;//////////////////////////////////////////////////////
;/                                                    /
;/ Run-time Library f�r Borland Pascal 7.0 unter OS/2 /
;/ Routinen f�r Text-Dateien.                         /
;/                                                    /
;/ 1993 Matthias Withopf / c't                        /
;/ Originalversion (c) 1988,92 Borland International  /
;/                                                    /
;//////////////////////////////////////////////////////

                .286p                                         

                _NOMACROS_ = 1                  ; keine Macros definieren
                INCLUDE SE.ASM
                INCLUDE OS2.ASM

DATA            SEGMENT WORD PUBLIC
                EXTRN   FileMode:WORD,InOutRes:WORD
DATA            ENDS

CODE            SEGMENT BYTE PUBLIC
                ASSUME  CS:CODE,DS:DATA

                EXTRN   ConvErrCode:NEAR

                ;
                ; Assign(Var f;Name : PChar);
                ;

                PUBLIC  AssignTextC
AssignTextC     PROC    PASCAL FAR
                MOV     DL,1                    ; setze Flag f�r PChar-Argument
                JMP     SHORT Assign
AssignTextC     ENDP

                ;        
                ; Assign(Var f;Name : String);
                ;

                PUBLIC  AssignText
AssignText      PROC    PASCAL FAR
                XOR     DX,DX                   ; l�sche Flag f�r PChar-Argument
AssignText      ENDP

                ;
                ; Allgemeine Assign-Prozedur.
                ;

Assign          PROC    PASCAL FAR 
                ARG     A_File : DWORD,  \
                        A_Name : DWORD
                PUSH    DS                      ; rette Datensegment
                LES     DI,A_File               ; lese Zeiger auf TextRec
                LDS     SI,A_Name               ; lese Zeiger auf Namen
                MOV     ES:[DI].fHandle,0       ; markiere Handle als ung�ltig
                MOV     ES:[DI].fMode,fmClosed  ; Datei ist geschlossen
                MOV     ES:[DI].fBufSize,128    ; setze Standardgr��e des Buffers
                MOV     ES:[DI].fPrivate,0      ; init. private Daten
                MOV     ES:[DI].fBufPos,0       ; l�sche den
                MOV     ES:[DI].fBufEnd,0       ; Datei-Buffer
                LEA     AX,[DI].fBuffer         ; initialisiere Zeiger
                MOV     ES:[DI].fBufPtr.offs,AX ; auf Buffer innerhalb
                MOV     ES:[DI].fBufPtr.segm,ES ; TextRec
                MOV     ES:[DI].fOpenProc.offs,OFFSET FileOpen ; definiere die
                MOV     ES:[DI].fOpenProc.segm,CS              ; Open-Funktion
                XOR     AX,AX                   ; l�sche die 
                MOV     CX,(fName-fInOutProc)/2 ; restlichen 
                ADD     DI,fInOutProc           ; Funktionszeiger
                CLD                             ; und
                REP     STOSW                   ; UserData
                MOV     CX,79                   ; lese max. L�nge des Dateinamens
                OR      DX,DX                   ; ist es PChar-Routine ?
                JNE     @@CopyNameLoop          ; ja -> weiter
                LODSB                           ; lese L�ngenbyte des Namens
                CMP     CL,AL                   ; ist max. L�nge �berschritten ?
                JBE     @@CopyNameLoop          ; nein -> ok, weiter
                MOV     CL,AL                   ; schneide Namen ab
                JCXZ    @@CopyNameEnd           ; falls Namen Leerstring -> weiter
@@CopyNameLoop: LODSB                           ; lese Zeichen aus angegebenem Dateinamen
                OR      AL,AL                   ; Ende erreicht (bei PChar-Routine) ?
                JE      @@CopyNameEnd           ; ja -> Kopieren des Namens beenden
                STOSB                           ; speichere Zeichen in TextRec
                LOOP    @@CopyNameLoop          ; gesamten Namen kopieren
@@CopyNameEnd:  XOR     AL,AL                   ; schlie�e Namen in TextRec
                STOSB                           ; mit Nullbyte ab
                POP     DS                      ; stelle Datensegment wieder her
                RET     
Assign          ENDP

                ;        
                ; Procedure SetTextBuf(var F : Text;Var Buf;Size : Word);
                ;

                PUBLIC  BufferText
BufferText      PROC    PASCAL FAR
                ARG     A_File : DWORD,    \
                        A_Buf  : DWORD,    \
                        A_Size : WORD
                LES     DI,A_File               ; lese Zeiger auf TextRec
                MOV     AX,A_Size               ; setze neue 
                MOV     ES:[DI].fBufSize,AX     ; Buffer-Gr��e
                MOV     AX,A_Buf.offs           ; setze
                MOV     ES:[DI].fBufPtr.offs,AX ; neuen
                MOV     AX,A_Buf.segm           ; Zeiger
                MOV     ES:[DI].fBufPtr.segm,AX ; auf Buffer
                XOR     AX,AX                   ; l�sche
                MOV     ES:[DI].fBufPos,AX      ; den
                MOV     ES:[DI].fBufEnd,AX      ; Datei-Buffer
                RET     
BufferText      ENDP

                ;        
                ; Procedure Reset(Var f : Text);
                ;

                PUBLIC  ResetText
ResetText       PROC    PASCAL FAR
                MOV     DX,fmInput              ; lese Dateimodus f�r Eingabe
                mov     cx,OPEN_ACCESS_READONLY ;{CT} allow read only file access
                JMP     SHORT OpenText
ResetText       ENDP

                ;
                ; Procedure Rewrite(Var f : Text);
                ;

                PUBLIC  RewriteText
RewriteText     PROC    PASCAL FAR
                MOV     DX,fmOutput              ; lese Dateimodus f�r Ausgabe
                MOV     CX,OPEN_ACCESS_WRITEONLY ;{CT} Allow readonly File Access
                JMP     SHORT OpenText
RewriteText     ENDP

                ;
                ; Procedure Append(Var f : Text);
                ;

                PUBLIC  AppendText
AppendText      PROC    PASCAL FAR
                MOV     DX,fmInOut              ; lese Dateimodus f�r wahlfreien Zugriff
                MOV     CX,OPEN_ACCESS_READWRITE ;{CT} Allow read only file access
AppendText      ENDP

                ;
                ; �ffne Datei oder lege Datei neu an.
                ; In DX wird der Dateimodus �bergeben.
                ;

                PUBLIC  OpenText
OpenText        PROC    PASCAL FAR
                ARG     A_File : DWORD
                LES     DI,A_File               ; lese Zeiger auf TextRec
                MOV     AX,ES:[DI].fMode        ; lese aktuellen Modus der Datei
                CMP     AX,fmInput              ; ist die Datei zum Lesen ge�ffnet ?
                JE      @@CloseFirst            ; ja -> zuerst schlie�en
                CMP     AX,fmOutput             ; ist die Datei zum Schreiben ge�ffnet ?
                JE      @@CloseFirst            ; ja -> zuerst schlie�en
                CMP     AX,fmClosed             ; ist die Datei geschlossen ?
                JE      @@Open                  ; ja -> ok, �ffnen
                MOV     InOutRes,102            ; sonst Fehler: 'File not assigned'
                JMP     SHORT @@End             ; -> Ende

@@CloseFirst:   PUSH    DX                      ; rette neuen Dateimodus
                PUSH    ES                   ;{CT} Save es
                PUSH    DI                   ;{CT} Save DI
                PUSH    ES                      ; �bergebe den Zeiger
                PUSH    DI                      ; auf TextRec
                PUSH    CS                      ; schlie�e die Datei,
                CALL    NEAR PTR CloseText      ; bevor sie neu ge�ffnet wird
                POP     DI                   ;{CT} recover DI
                POP     ES                   ;{CT} RECOVER ES
                POP     DX                      ; hole neuen Dateimodus zur�ck
@@Open:         MOV     ES:[DI].fMode,DX        ; speichere neuen Dateimodus
                MOV     ES:[Di].Fprivate,CX  ;{CT} Allow REadonly
                XOR     AX,AX                   ; l�sche den
                MOV     ES:[DI].fBufPos,AX      ; Buffer
                MOV     ES:[DI].fBufEnd,AX      ; der Textdatei
                MOV     BX,fOpenProc            ; rufe Funktion
                CALL    DoFunction              ; zum �ffnen auf
                JE      @@End                   ; falls kein Fehler -> ok, weiter
                MOV     ES:[DI].fMode,fmClosed  ; bei Fehler: setze Dateimodus auf geschlossen
@@End:          RET
OpenText        ENDP

                ;
                ; Procedure Flush(Var f : Text);
                ;

                PUBLIC  FlushText
FlushText       PROC    PASCAL FAR
                XOR     AL,AL                   ; l�sche Flag f�r "Schlie�en"
                JMP     SHORT FlushClose
FlushText       ENDP

                ;
                ; Procedure Close(Var f);
                ;

                PUBLIC  CloseText
CloseText       PROC    PASCAL FAR
                MOV     AL,1                    ; setze Flag f�r "Schlie�en"
CloseText       ENDP

                ;
                ; Flush/Close.
                ;

                PUBLIC  FlushClose
FlushClose      PROC    PASCAL FAR
                ARG     A_File : DWORD
                LES     DI,A_File               ; lese Zeiger auf TextRec
                CMP     ES:[DI].fMode,fmInput   ; ist Datei als Eingabe ge�ffnet ?
                JE      @@DontFlush             ; ja -> kein Flush n�tig
                CMP     ES:[DI].fMode,fmOutput  ; ist Datei als Ausgabe ge�ffnet ?
                JE      @@DoFlush               ; ja -> Flush
                MOV     InOutRes,103            ; sonst Fehler: 'File not open'
                JMP     SHORT @@DontClose       ; -> Ende

@@DoFlush:      PUSH    AX                      ; rette Flag f�r "Schlie�en"
                MOV     BX,fInOutProc           ; gebe den restlichen
                CALL    DoFunction              ; Buffer-Inhalt aus
                POP     AX                      ; hole Flag f�r "Schlie�en" zur�ck
@@DontFlush:    OR      AL,AL                   ; ist Flag f�r "Schlie�en" gesetzt ?
                JE      @@DontClose             ; nein -> weiter, nicht schlie�en
                MOV     BX,fCloseProc           ; schlie�e
                CALL    DoFunction              ; die Datei
                MOV     ES:[DI].fMode,fmClosed  ; setze Dateimodus auf 'geschlossen'
@@DontClose:    RET
FlushClose      ENDP

                ;
                ; F�hre eine Funktion eines Textdatei-Ger�tetreibers
                ; aus. Der Offset der Funktion innerhalb des 
                ; TextRecs wird in BX �bergeben.
                ;

DoFunction      PROC    NEAR
                PUSH    ES                      ; rette Zeiger
                PUSH    DI                      ; auf TextRec
                PUSH    ES                      ; �bergebe den Zeiger
                PUSH    DI                      ; auf TextRec als Argument
                CALL    DWORD PTR ES:[DI+BX]    ; rufe die gew�nschte Funktion auf
                OR      AX,AX                   ; ist Fehler aufgetreten ?
                JE      @@NoErr                 ; nein -> weiter
                MOV     InOutRes,AX             ; speichere Fehlercode
@@NoErr:        POP     DI                      ; hole Zeiger
                POP     ES                      ; auf TextRec zur�ck
                RET
DoFunction      ENDP

                ;        
                ; Read-Funktion des Standard-Text-Ger�tetreibers.
                ;

                PUBLIC  FileRead
FileRead        PROC    PASCAL FAR
                ARG     A_File    : DWORD
                LOCAL   L_ReadCnt : WORD
                PUSH    DS                      ; rette Datensegment
                LES     DI,A_File               ; lese Zeiger auf TextRec
                PUSH    ES:[DI].fHandle         ; �bergebe FileHandle
                LDS     BX,ES:[DI].fBufPtr      ; �bergebe Zeiger
                PUSH    DS                      ; auf den
                PUSH    BX                      ; Datei-Buffer
                PUSH    ES:[DI].fBufSize        ; �bergebe Buffer-Gr��e
                LEA     BX,L_ReadCnt            ; �bergebe Zeiger auf Word,
                PUSH    SS                      ; in dem die tats�chliche Anzahl
                PUSH    BX                      ; gelesener Bytes gespeichert wird
                CALL    DosRead                 ; lese Block aus Datei
                OR      AX,AX                   ; ist Fehler beim Lesen aufgetreten ?
                JNZ     @@Error                 ; ja -> Fehler
                MOV     AX,L_ReadCnt            ; lese Anzahl gelesener Bytes
                LES     DI,A_File               ; lese Zeiger auf TextRec
                MOV     ES:[DI].fBufEnd,AX      ; speichere neues Buffer-Ende
                XOR     AX,AX                   ; l�sche Fehlercode
@@End:          MOV     ES:[DI].fBufPos,0       ; setze Position des Zeigers auf Datei-Buffers zur�ck
                POP     DS                      ; hole Datensegment zur�ck
                RET

@@Error:        MOV     ES:[DI].fBufEnd,0       ; l�sche den Datei-Buffer
                CALL    ConvErrCode             ; konvertiere Fehlercode nach OS/2-Code
                JMP     SHORT @@End             ; -> Ende
FileRead        ENDP

                ;
                ; Write-Funktion des Standard-Text-Ger�tetreibers.
                ;

                PUBLIC  FileWrite
FileWrite       PROC    PASCAL FAR
                ARG     A_File     : DWORD
                LOCAL   L_WriteCnt : WORD
                PUSH    DS                      ; rette Datensegment
                LES     DI,A_File               ; lese Zeiger auf TextRec
                PUSH    ES:[DI].fHandle         ; �bergebe FileHandle
                LDS     BX,ES:[DI].fBufPtr      ; �bergebe
                PUSH    DS                      ; Zeiger auf
                PUSH    BX                      ; den Datei-Buffer
                XOR     CX,CX                   ; �bergebe aktuelle
                XCHG    CX,ES:[DI].fBufPos      ; Gr��e des Datei-Buffers
                PUSH    CX                      ; und setze sie zur�ck
                LEA     BX,L_WriteCnt           ; �bergebe Zeiger auf Word,
                PUSH    SS                      ; in dem die tats�chliche Anzahl
                PUSH    BX                      ; geschriebener Bytes gespeichert wird
                CALL    DosWrite                ; schreibe Block in Datei
                CALL    ConvErrCode             ; konvertiere Fehlercode nach OS/2-Code
                OR      AX,AX                   ; ist Fehler aufgetreten ?
                JNZ     @@Exit                  ; ja -> Ende
                MOV     AX,L_WriteCnt           ; lese Anzahl geschriebener Bytes
                SUB     AX,CX                   ; konnten alle Bytes geschrieben werden ?
                JE      @@Exit                  ; ja -> ok, weiter
                MOV     AX,101                  ; sonst Fehler: 'Disk write error'
@@Exit:         POP     DS                      ; hole Datensegment zur�ck
                RET
FileWrite       ENDP

                ;
                ; Write-Funktion des Standard-Text-Ger�tetreibers
                ; f�r Device-Dateien.
                ;

                PUBLIC  FileWrDev
FileWrDev       PROC    PASCAL FAR
                ARG     A_File     : DWORD
                LOCAL   L_WriteCnt : WORD
                PUSH    DS                      ; rette Datensegment
                LES     DI,A_File               ; lese Zeiger auf TextRec
                PUSH    ES:[DI].fHandle         ; �bergebe FileHandle
                LDS     BX,ES:[DI].fBufPtr      ; �bergebe
                PUSH    DS                      ; Zeiger auf
                PUSH    BX                      ; den Datei-Buffer
                XOR     CX,CX                   ; �bergebe aktuelle
                XCHG    CX,ES:[DI].fBufPos      ; Gr��e des Datei-Buffers
                PUSH    CX                      ; und setze sie zur�ck
                LEA     BX,L_WriteCnt           ; �bergebe Zeiger auf Word,
                PUSH    SS                      ; in dem die tats�chliche Anzahl
                PUSH    BX                      ; geschriebener Bytes gespeichert wird
                CALL    DosWrite                ; sende Block an Device
                CALL    ConvErrCode             ; konvertiere Fehlercode nach OS/2-Code
                POP     DS                      ; hole Datensegment zur�ck
                RET     
FileWrDev       ENDP

                ;
                ; Close-Funktion des Standard-Text-Ger�tetreibers.
                ;

                PUBLIC  FileClose
FileClose       PROC    PASCAL FAR
                ARG     A_File : DWORD
                LES     DI,A_File               ; lese Zeiger auf TextRec
                MOV     BX,ES:[DI].fHandle      ; lese FileHandle
                XOR     AX,AX                   ; l�sche Fehlercode
                CMP     BX,2                    ; ist es Handle f�r Standard-I/O ?
                JBE     @@Exit                  ; ja -> nicht schlie�en
                PUSH    BX                      ; �bergebe FileHandle
                CALL    DosClose                ; schlie�e Datei
                CALL    ConvErrCode             ; konvertiere Fehlercode nach OS/2-Code
@@Exit:         RET     
FileClose       ENDP

                ;
                ; Open-Funktion des Standard-Text-Ger�tetreibers.
                ;
                ; {CT} 11/11/93
                ; BUG:  Could not use a TEXTREC Created on heap,
                ; FIX:  change use of DS to ES.
                ; DESCRIPTION:
                ; Procedure origional used DS as segment for access
                ; to TEXTREC, in doing so, it destroyed the DS segment
                ; for access to FILEMODE and INOUTRES.
                ; I change PROC to use ES Segment for access to TEXTREC.
                ; This fixed the problem.
                ;

FileOpen        PROC    PASCAL FAR
                ARG     A_File       : DWORD
                LOCAL   L_Handle     : WORD,  \
                        L_Action     : WORD,  \
                        L_FileSize   : DWORD, \
                        L_FilePtr    : DWORD, \
                        L_Count      : WORD,  \
                        L_HandleType : WORD,  \
                        L_DevAttr    : WORD
                PUSH    DS                      ; rette Datensegment
;                LDS     DI,A_File               ; lese Zeiger auf TextRec
                les     di,a_file              ;{CT} Load ES:DI to point to TextREC
;                MOV     [DI].fHandle,0          ; Handle f�r Standardeingabe = 0
                MOV    es:[DI].fHandle,0       ;{CT} init file handle = 0
                MOV     AX,FILE_OPEN            ; lese Flags f�r
;                MOV     CX,OPEN_ACCESS_READONLY ; Reset()
                MOV     CX,es:[di].fprivate    ;{CT} Allow readonly access
;                CMP     [DI].fMode,fmInput      ; wird Datei zum Lesen ge�ffnet ?
                CMP     es:[DI].fMode,fmInput   ;{CT}
                JE      @@ModeOk                ; ja -> ok, weiter
;                MOV     CX,OPEN_ACCESS_READWRITE; lese Flags f�r Append()
;                INC     [DI].fHandle            ; Handle f�r Standardausgabe = 1
                INC     ES:[DI].fHandle        ;{CT}
;                CMP     [DI].fMode,fmInOut      ; wird Datei wahlfrei ge�ffnet ?
                CMP     ES:[DI].fMode,fmInOut  ; {CT}
                JE      @@ModeOk                ; ja -> ok, weiter
                MOV     AX,FILE_CREATE OR FILE_OPEN; lese Flags f�r ReWrite()
;@@ModeOk:       CMP     [DI].fName,0            ; ist Standardein-/ausgabe gemeint ?
@@ModeOk:       CMP     es:[DI].fName,0         ;{CT}
                JE      @@AlreadyOpen           ; ja -> Datei nicht �ffnen
                LEA     DX,[DI].fName           ; lese Zeiger auf
;                PUSH    DS                      ; den Dateinamen
                PUSH    ES                      ; {CT}
                PUSH    DX                      ; und �bergebe ihn als Argument
                LEA     BX,L_Handle             ; �bergebe Zeiger auf
                PUSH    SS                      ; Speicherbereich, wo
                PUSH    BX                      ; DateiHandle abgelegt wird
                LEA     BX,L_Action             ; �bergebe Zeiger auf
                PUSH    SS                      ; Speicherbereich, wo
                PUSH    BX                      ; ausgef�hrte Aktion abgelegt wird
                XOR     BX,BX                   ; �bergebe
                PUSH    BX                      ; Gr��e
                PUSH    BX                      ; von 0
                PUSH    FILE_NORMAL             ; Flag f�r normale Datei
                PUSH    AX                      ; �bergebe Open Flags
                mov     ax,filemode          ;{CT} Allow readonly file access
                and     ax,0FFFCh;           ;{CT} mask off OPEN_ACCESS flags;
                OR      Cx,Ax                ;{CT} or with shareing ...
;                OR      CX,FileMode             ; setze Share-Mode
                PUSH    CX                      ; �bergebe Open Mode
                PUSH    BX                      ; �bergebe 0L
                PUSH    BX                      ; (reserviert)
                CALL    DosOpen                 ; �ffne Datei
                CALL    ConvErrCode             ; konvertiere Fehlercode nach OS/2-Code
                OR      AX,AX                   ; Fehler aufgetreten ?
                JNZ     @@OpenError             ; ja -> Ende
                MOV     AX,L_Handle             ; lese neues DateiHandle
;                MOV     [DI].fHandle,AX         ; speichern in TextRec
                MOV     ES:[DI].fHandle,AX    ;{CT}
@@AlreadyOpen:  MOV     AX,OFFSET FileRead      ; lese Zeiger auf Read-Funktion
                MOV     DX,CS                   ; in DX:AX
                XOR     CX,CX                   ; keine Flush-Funktion
                XOR     BX,BX                   ; f�r Eingabedatei verf�gbar
;                CMP     [DI].fMode,fmInput      ; ist Dateimodus Eingabe ?
                CMP     ES:[DI].fMode,fmInput ;{CT}
                JE      @@SetTextFuncs          ; ja -> weiter
;                PUSH    [DI].fHandle            ; teste, ob Datei zu einem Device f�hrt
                PUSH    ES:[DI].fHandle        ;{CT}
                LEA     BX,L_HandleType         ; �bergebe Zeiger auf Word,
                PUSH    SS                      ; in dem der Handle-Typ
                PUSH    BX                      ; gespeichert wird
                LEA     BX,L_DevAttr            ; �bergebe Zeiger auf Word,
                PUSH    SS                      ; in dem die Device-Attribute
                PUSH    BX                      ; gespeichert werden
                CALL    DosQHandType            ; erfrage Typ des FileHandles
                OR      AX,AX                   ; ist Fehler aufgetreten ?
                MOV     DX,0                    ; Datei ist kein Device
                JNZ     @@NoDevice              ; Fehler -> weiter
                MOV     AX,L_HandleType         ; lese Typ des FileHandles
                AND     AX,NOT HANDTYPE_NETWORK ; maskiere Network-Flag aus
                CMP     AL,HANDTYPE_DEVICE      ; ist es Device ?
                JNZ     @@NoDevice              ; ja -> weiter
                INC     DX                      ; setze Flag f�r "kein Device"
@@NoDevice:
                OR      DX,DX                   ; ist es Device?
                MOV     AX,OFFSET FileWrDev     ; lese Zeiger auf Write-Funktion
                MOV     DX,CS                   ; f�r Devices in DX:AX
                MOV     CX,AX                   ; lese Zeiger auf Flush-Funktion
                MOV     BX,DX                   ; f�r Devices in BX:CX
                JNE     @@IsDevice              ; falls Device -> weiter
;                CMP     [DI].fMode,fmInOut      ; ist es Datei mit wahlfreiem Zugriff ?
                CMP     ES:[DI].fMode,fmInOut ;{CT}
                JNE     @@NoAppend              ; nein -> weiter
                CALL    FileAppend              ; bereite Datei-Anf�gung vor
@@NoAppend:     MOV     AX,OFFSET FileWrite     ; lese Zeiger auf Write-Funktion
                MOV     DX,CS                   ; f�r Devices in DX:AX
                XOR     CX,CX                   ; keine Flush-Funktion
                XOR     BX,BX                   ; verf�gbar
;@@IsDevice:     MOV     [DI].fMode,fmOutput     ; setze Dateimodus f�r Ausgabe
;@@SetTextFuncs: MOV     [DI].fInOutProc.offs,AX ; speichere Zeiger auf
;                MOV     [DI].fInOutProc.segm,DX ; Ein-/Ausgabe-Funktion
;                MOV     [DI].fFlushProc.offs,CX ; speichere Zeiger auf
;                MOV     [DI].fFlushProc.segm,BX ; Flush-Funktion
;                MOV     [DI].fCloseProc.offs,OFFSET FileClose ; speichere Zeiger
;                MOV     [DI].fCloseProc.segm,CS ; auf Close-Funktion
@@IsDevice:     MOV     ES:[DI].fMode,fmOutput     ;{CT} initialize TEXTREC
@@SetTextFuncs: MOV     ES:[DI].fInOutProc.offs,AX ;{CT} ofs address for inoutproc
                MOV     ES:[DI].fInOutProc.segm,DX ;{CT} seg address for inoutproc
                MOV     ES:[DI].fFlushProc.offs,CX ;{CT} ofs address for flushproc
                MOV     ES:[DI].fFlushProc.segm,BX ;{CT} seg address for flushproc
                MOV     ES:[DI].fCloseProc.offs,OFFSET FileClose ;{CT}   closeproc
                MOV     ES:[DI].fCloseProc.segm,CS ;{CT}                 closeproc
                XOR     AX,AX                   ; l�sche Fehlercode
@@OpenError:    POP     DS                      ;{CT} change destinatin of jump to
                                                ;{CT} restore ds befor return
                RET                             ;{CT}

                ;
                ; Bereite Datei-Anf�gung vor, indem der Datei-Zeiger an
                ; das Ende der Datei bewegt wird und der letzte 128-Byte-
                ; Block der Datei in den Date-Buffer eingelesen wird.
                ;

FileAppend      PROC    NEAR

                ; Bestimme L�nge der Datei.

;                PUSH    [DI].fHandle            ; bestimme aktuelle Position
                PUSH    ES:[DI].fHandle         ;{CT} push correct handle
                XOR     AX,AX                   ; �bergebe 0
                PUSH    AX                      ; als
                PUSH    AX                      ; Positionsangabe
                PUSH    FILE_END                ; vom Dateiende aus
                LEA     BX,L_FileSize           ; lese Zeiger auf Word, in dem
                PUSH    SS                      ; die Dateigr��e
                PUSH    BX                      ; gespeichert wird
                CALL    DosChgFilePtr           ; erfrage L�nge der Datei
                OR      AX,AX                   ; ist Fehler aufgetreten ?
                JNZ     @@GetSizeError          ; ja -> Dateil�nge := 0
                MOV     AX,L_FileSize.offs      ; lese L�nge
                MOV     DX,L_FileSize.segm      ; der Datei
                SUB     AX,128                  ; berechne Position
                SBB     DX,0                    ; des letzten 128-Byte-Blocks
                JNC     @@Seek                  ; falls Datei nicht zu kurz -> weiter
@@GetSizeError: XOR     AX,AX                   ; bei Fehler
                XOR     DX,DX                   ; -> Datel�nge := 0

                ; Bewege Datei-Zeiger auf 128 Bytes vor Dateiende.

;@@Seek:         PUSH    [DI].fHandle            ; �bergebe FileHandle
@@Seek:         PUSH    ES:[DI].fHandle         ;{CT} push correct handle
                PUSH    DX                      ; �bergebe neue Position
                PUSH    AX                      ; des Datei-Zeigers (128 Bytes vor Dateiende)
                PUSH    FILE_BEGIN              ; vom Dateianfang aus
                LEA     BX,L_FilePtr            ; lese Zeiger auf Word, in dem
                PUSH    SS                      ; die neue Position des
                PUSH    BX                      ; Datei-Zeigers gespeichert wird
                CALL    DosChgFilePtr           ; setze Datei-Zeiger

                ; Lese die letzten 128 Byte aus der Datei.

;                PUSH    [DI].fHandle            ; �bergebe FileHandle
                PUSH    ES:[DI].fHandle       ;{CT} push correct handle
                LEA     BX,[DI].fBuffer         ; �bergebe Zeiger
                PUSH    SS                      ; auf den
                PUSH    BX                      ; Datei-Buffer
                PUSH    128                     ; L�nge := 128 Bytes
                LEA     BX,L_Count              ; �bergebe Zeiger auf Word,
                PUSH    SS                      ; in dem die Anzahl der gelesenen
                PUSH    BX                      ; Bytes gespeichert wird
                CALL    DosRead                 ; lese 128 Bytes aus Datei
                OR      AX,AX                   ; ist Lesefehler aufgetreten ?
                MOV     AX,0                    ; f�r diesen Fall: 0 Bytes gelesen
                JNZ     @@ReadError             ; Fehler -> weiter
                MOV     AX,L_Count              ; lese Anzahl tats�chlich gelesener Bytes
@@ReadError:    XOR     BX,BX                   ; init. Index auf Datei-Buffer
@@ChkEofLoop:   CMP     BX,AX                   ; Ende des Buffers erreicht ?
                JE      @@End                   ; ja -> Ende
;                CMP     [DI].fBuffer[BX],eof    ; ist EOF-Zeichen im Buffer ?
                CMP     ES:[DI].fBuffer[BX],eof ;{CT} set correct entry in buffer
                JE      @@Truncate              ; ja -> schneide Datei ab
                INC     BX                      ; n�chstes Byte im Buffer
                JMP     @@ChkEofLoop            ; auf EOF testen

                ; Schneide Datei am EOF-Zeichen ab, alle weiteren
                ; Bytes hinter (logischem) Dateiende werden gel�scht.

@@Truncate:     SUB     BX,AX                   ; berechne
                MOV     AX,L_FileSize.offs      ; Position
                MOV     DX,L_FileSize.segm      ; zum
                ADD     AX,BX                   ; Abschneiden
                ADC     DX,0                    ; der Datei
;                PUSH    [DI].fHandle            ; �bergebe FileHandle
                PUSH    ES:[DI].fHandle       ;{CT} push correct handle
                PUSH    DX                      ; �bergebe neue L�nge
                PUSH    AX                      ; der Datei
                CALL    DosNewSize              ; schneide Datei ab
                CALL    ConvErrCode             ; konvertiere Fehlercode nach OS/2-Code
@@End:          RET
FileAppend      ENDP
FileOpen        ENDP

CODE            ENDS

                END
