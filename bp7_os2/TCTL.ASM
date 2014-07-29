;//////////////////////////////////////////////////////
;/                                                    /
;/ Run-time Library fÅr Borland Pascal 7.0 unter OS/2 /
;/ Routinen fÅr Text-Dateien.                         /
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
                MOV     DL,1                    ; setze Flag fÅr PChar-Argument
                JMP     SHORT Assign
AssignTextC     ENDP

                ;        
                ; Assign(Var f;Name : String);
                ;

                PUBLIC  AssignText
AssignText      PROC    PASCAL FAR
                XOR     DX,DX                   ; lîsche Flag fÅr PChar-Argument
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
                MOV     ES:[DI].fHandle,0       ; markiere Handle als ungÅltig
                MOV     ES:[DI].fMode,fmClosed  ; Datei ist geschlossen
                MOV     ES:[DI].fBufSize,128    ; setze Standardgrî·e des Buffers
                MOV     ES:[DI].fPrivate,0      ; init. private Daten
                MOV     ES:[DI].fBufPos,0       ; lîsche den
                MOV     ES:[DI].fBufEnd,0       ; Datei-Buffer
                LEA     AX,[DI].fBuffer         ; initialisiere Zeiger
                MOV     ES:[DI].fBufPtr.offs,AX ; auf Buffer innerhalb
                MOV     ES:[DI].fBufPtr.segm,ES ; TextRec
                MOV     ES:[DI].fOpenProc.offs,OFFSET FileOpen ; definiere die
                MOV     ES:[DI].fOpenProc.segm,CS              ; Open-Funktion
                XOR     AX,AX                   ; lîsche die 
                MOV     CX,(fName-fInOutProc)/2 ; restlichen 
                ADD     DI,fInOutProc           ; Funktionszeiger
                CLD                             ; und
                REP     STOSW                   ; UserData
                MOV     CX,79                   ; lese max. LÑnge des Dateinamens
                OR      DX,DX                   ; ist es PChar-Routine ?
                JNE     @@CopyNameLoop          ; ja -> weiter
                LODSB                           ; lese LÑngenbyte des Namens
                CMP     CL,AL                   ; ist max. LÑnge Åberschritten ?
                JBE     @@CopyNameLoop          ; nein -> ok, weiter
                MOV     CL,AL                   ; schneide Namen ab
                JCXZ    @@CopyNameEnd           ; falls Namen Leerstring -> weiter
@@CopyNameLoop: LODSB                           ; lese Zeichen aus angegebenem Dateinamen
                OR      AL,AL                   ; Ende erreicht (bei PChar-Routine) ?
                JE      @@CopyNameEnd           ; ja -> Kopieren des Namens beenden
                STOSB                           ; speichere Zeichen in TextRec
                LOOP    @@CopyNameLoop          ; gesamten Namen kopieren
@@CopyNameEnd:  XOR     AL,AL                   ; schlie·e Namen in TextRec
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
                MOV     ES:[DI].fBufSize,AX     ; Buffer-Grî·e
                MOV     AX,A_Buf.offs           ; setze
                MOV     ES:[DI].fBufPtr.offs,AX ; neuen
                MOV     AX,A_Buf.segm           ; Zeiger
                MOV     ES:[DI].fBufPtr.segm,AX ; auf Buffer
                XOR     AX,AX                   ; lîsche
                MOV     ES:[DI].fBufPos,AX      ; den
                MOV     ES:[DI].fBufEnd,AX      ; Datei-Buffer
                RET     
BufferText      ENDP

                ;        
                ; Procedure Reset(Var f : Text);
                ;

                PUBLIC  ResetText
ResetText       PROC    PASCAL FAR
                MOV     DX,fmInput              ; lese Dateimodus fÅr Eingabe
                JMP     SHORT OpenText
ResetText       ENDP

                ;
                ; Procedure Rewrite(Var f : Text);
                ;

                PUBLIC  RewriteText
RewriteText     PROC    PASCAL FAR   
                MOV     DX,fmOutput             ; lese Dateimodus fÅr Ausgabe
                JMP     SHORT OpenText
RewriteText     ENDP

                ;
                ; Procedure Append(Var f : Text);
                ;

                PUBLIC  AppendText
AppendText      PROC    PASCAL FAR
                MOV     DX,fmInOut              ; lese Dateimodus fÅr wahlfreien Zugriff
AppendText      ENDP

                ;
                ; ôffne Datei oder lege Datei neu an.
                ; In DX wird der Dateimodus Åbergeben.
                ;

                PUBLIC  OpenText
OpenText        PROC    PASCAL FAR
                ARG     A_File : DWORD
                LES     DI,A_File               ; lese Zeiger auf TextRec
                MOV     AX,ES:[DI].fMode        ; lese aktuellen Modus der Datei
                CMP     AX,fmInput              ; ist die Datei zum Lesen geîffnet ?
                JE      @@CloseFirst            ; ja -> zuerst schlie·en
                CMP     AX,fmOutput             ; ist die Datei zum Schreiben geîffnet ?
                JE      @@CloseFirst            ; ja -> zuerst schlie·en
                CMP     AX,fmClosed             ; ist die Datei geschlossen ?
                JE      @@Open                  ; ja -> ok, îffnen
                MOV     InOutRes,102            ; sonst Fehler: 'File not assigned'
                JMP     SHORT @@End             ; -> Ende

@@CloseFirst:   PUSH    DX                      ; rette neuen Dateimodus
                PUSH    ES                      ; Åbergebe den Zeiger
                PUSH    DI                      ; auf TextRec
                PUSH    CS                      ; schlie·e die Datei,
                CALL    NEAR PTR CloseText      ; bevor sie neu geîffnet wird
                POP     DX                      ; hole neuen Dateimodus zurÅck
@@Open:         MOV     ES:[DI].fMode,DX        ; speichere neuen Dateimodus
                XOR     AX,AX                   ; lîsche den
                MOV     ES:[DI].fBufPos,AX      ; Buffer
                MOV     ES:[DI].fBufEnd,AX      ; der Textdatei
                MOV     BX,fOpenProc            ; rufe Funktion 
                CALL    DoFunction              ; zum ôffnen auf
                JE      @@End                   ; falls kein Fehler -> ok, weiter
                MOV     ES:[DI].fMode,fmClosed  ; bei Fehler: setze Dateimodus auf geschlossen
@@End:          RET     
OpenText        ENDP

                ;
                ; Procedure Flush(Var f : Text);
                ;

                PUBLIC  FlushText
FlushText       PROC    PASCAL FAR
                XOR     AL,AL                   ; lîsche Flag fÅr "Schlie·en"
                JMP     SHORT FlushClose
FlushText       ENDP

                ;        
                ; Procedure Close(Var f);
                ;

                PUBLIC  CloseText
CloseText       PROC    PASCAL FAR
                MOV     AL,1                    ; setze Flag fÅr "Schlie·en"
CloseText       ENDP

                ;
                ; Flush/Close. 
                ;

                PUBLIC  FlushClose
FlushClose      PROC    PASCAL FAR
                ARG     A_File : DWORD
                LES     DI,A_File               ; lese Zeiger auf TextRec
                CMP     ES:[DI].fMode,fmInput   ; ist Datei als Eingabe geîffnet ?
                JE      @@DontFlush             ; ja -> kein Flush nîtig
                CMP     ES:[DI].fMode,fmOutput  ; ist Datei als Ausgabe geîffnet ?
                JE      @@DoFlush               ; ja -> Flush
                MOV     InOutRes,103            ; sonst Fehler: 'File not open'
                JMP     SHORT @@DontClose       ; -> Ende

@@DoFlush:      PUSH    AX                      ; rette Flag fÅr "Schlie·en"
                MOV     BX,fInOutProc           ; gebe den restlichen
                CALL    DoFunction              ; Buffer-Inhalt aus
                POP     AX                      ; hole Flag fÅr "Schlie·en" zurÅck
@@DontFlush:    OR      AL,AL                   ; ist Flag fÅr "Schlie·en" gesetzt ?
                JE      @@DontClose             ; nein -> weiter, nicht schlie·en
                MOV     BX,fCloseProc           ; schlie·e
                CALL    DoFunction              ; die Datei
                MOV     ES:[DI].fMode,fmClosed  ; setze Dateimodus auf 'geschlossen'
@@DontClose:    RET     
FlushClose      ENDP

                ;
                ; FÅhre eine Funktion eines Textdatei-GerÑtetreibers
                ; aus. Der Offset der Funktion innerhalb des 
                ; TextRecs wird in BX Åbergeben.
                ;

DoFunction      PROC    NEAR
                PUSH    ES                      ; rette Zeiger
                PUSH    DI                      ; auf TextRec
                PUSH    ES                      ; Åbergebe den Zeiger
                PUSH    DI                      ; auf TextRec als Argument
                CALL    DWORD PTR ES:[DI+BX]    ; rufe die gewÅnschte Funktion auf
                OR      AX,AX                   ; ist Fehler aufgetreten ?
                JE      @@NoErr                 ; nein -> weiter
                MOV     InOutRes,AX             ; speichere Fehlercode
@@NoErr:        POP     DI                      ; hole Zeiger
                POP     ES                      ; auf TextRec zurÅck
                RET
DoFunction      ENDP

                ;        
                ; Read-Funktion des Standard-Text-GerÑtetreibers.
                ;

                PUBLIC  FileRead
FileRead        PROC    PASCAL FAR
                ARG     A_File    : DWORD
                LOCAL   L_ReadCnt : WORD
                PUSH    DS                      ; rette Datensegment
                LES     DI,A_File               ; lese Zeiger auf TextRec
                PUSH    ES:[DI].fHandle         ; Åbergebe FileHandle
                LDS     BX,ES:[DI].fBufPtr      ; Åbergebe Zeiger
                PUSH    DS                      ; auf den
                PUSH    BX                      ; Datei-Buffer
                PUSH    ES:[DI].fBufSize        ; Åbergebe Buffer-Grî·e
                LEA     BX,L_ReadCnt            ; Åbergebe Zeiger auf Word,
                PUSH    SS                      ; in dem die tatsÑchliche Anzahl
                PUSH    BX                      ; gelesener Bytes gespeichert wird
                CALL    DosRead                 ; lese Block aus Datei
                OR      AX,AX                   ; ist Fehler beim Lesen aufgetreten ?
                JNZ     @@Error                 ; ja -> Fehler
                MOV     AX,L_ReadCnt            ; lese Anzahl gelesener Bytes
                LES     DI,A_File               ; lese Zeiger auf TextRec
                MOV     ES:[DI].fBufEnd,AX      ; speichere neues Buffer-Ende
                XOR     AX,AX                   ; lîsche Fehlercode
@@End:          MOV     ES:[DI].fBufPos,0       ; setze Position des Zeigers auf Datei-Buffers zurÅck
                POP     DS                      ; hole Datensegment zurÅck
                RET     

@@Error:        MOV     ES:[DI].fBufEnd,0       ; lîsche den Datei-Buffer
                CALL    ConvErrCode             ; konvertiere Fehlercode nach OS/2-Code
                JMP     SHORT @@End             ; -> Ende
FileRead        ENDP

                ;
                ; Write-Funktion des Standard-Text-GerÑtetreibers.
                ;

                PUBLIC  FileWrite
FileWrite       PROC    PASCAL FAR
                ARG     A_File     : DWORD
                LOCAL   L_WriteCnt : WORD
                PUSH    DS                      ; rette Datensegment
                LES     DI,A_File               ; lese Zeiger auf TextRec
                PUSH    ES:[DI].fHandle         ; Åbergebe FileHandle
                LDS     BX,ES:[DI].fBufPtr      ; Åbergebe 
                PUSH    DS                      ; Zeiger auf
                PUSH    BX                      ; den Datei-Buffer
                XOR     CX,CX                   ; Åbergebe aktuelle
                XCHG    CX,ES:[DI].fBufPos      ; Grî·e des Datei-Buffers
                PUSH    CX                      ; und setze sie zurÅck
                LEA     BX,L_WriteCnt           ; Åbergebe Zeiger auf Word,
                PUSH    SS                      ; in dem die tatsÑchliche Anzahl
                PUSH    BX                      ; geschriebener Bytes gespeichert wird
                CALL    DosWrite                ; schreibe Block in Datei
                CALL    ConvErrCode             ; konvertiere Fehlercode nach OS/2-Code
                OR      AX,AX                   ; ist Fehler aufgetreten ?
                JNZ     @@Exit                  ; ja -> Ende
                MOV     AX,L_WriteCnt           ; lese Anzahl geschriebener Bytes
                SUB     AX,CX                   ; konnten alle Bytes geschrieben werden ?
                JE      @@Exit                  ; ja -> ok, weiter
                MOV     AX,101                  ; sonst Fehler: 'Disk write error'
@@Exit:         POP     DS                      ; hole Datensegment zurÅck
                RET     
FileWrite       ENDP

                ;
                ; Write-Funktion des Standard-Text-GerÑtetreibers
                ; fÅr Device-Dateien.
                ;

                PUBLIC  FileWrDev
FileWrDev       PROC    PASCAL FAR
                ARG     A_File     : DWORD
                LOCAL   L_WriteCnt : WORD
                PUSH    DS                      ; rette Datensegment
                LES     DI,A_File               ; lese Zeiger auf TextRec
                PUSH    ES:[DI].fHandle         ; Åbergebe FileHandle
                LDS     BX,ES:[DI].fBufPtr      ; Åbergebe 
                PUSH    DS                      ; Zeiger auf
                PUSH    BX                      ; den Datei-Buffer
                XOR     CX,CX                   ; Åbergebe aktuelle
                XCHG    CX,ES:[DI].fBufPos      ; Grî·e des Datei-Buffers
                PUSH    CX                      ; und setze sie zurÅck
                LEA     BX,L_WriteCnt           ; Åbergebe Zeiger auf Word,
                PUSH    SS                      ; in dem die tatsÑchliche Anzahl
                PUSH    BX                      ; geschriebener Bytes gespeichert wird
                CALL    DosWrite                ; sende Block an Device
                CALL    ConvErrCode             ; konvertiere Fehlercode nach OS/2-Code
                POP     DS                      ; hole Datensegment zurÅck
                RET     
FileWrDev       ENDP

                ;
                ; Close-Funktion des Standard-Text-GerÑtetreibers.
                ;

                PUBLIC  FileClose
FileClose       PROC    PASCAL FAR
                ARG     A_File : DWORD
                LES     DI,A_File               ; lese Zeiger auf TextRec
                MOV     BX,ES:[DI].fHandle      ; lese FileHandle
                XOR     AX,AX                   ; lîsche Fehlercode
                CMP     BX,2                    ; ist es Handle fÅr Standard-I/O ?
                JBE     @@Exit                  ; ja -> nicht schlie·en
                PUSH    BX                      ; Åbergebe FileHandle
                CALL    DosClose                ; schlie·e Datei
                CALL    ConvErrCode             ; konvertiere Fehlercode nach OS/2-Code
@@Exit:         RET     
FileClose       ENDP

                ;
                ; Open-Funktion des Standard-Text-GerÑtetreibers.
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
                LDS     DI,A_File               ; lese Zeiger auf TextRec
                MOV     [DI].fHandle,0          ; Handle fÅr Standardeingabe = 0
                MOV     AX,FILE_OPEN            ; lese Flags fÅr 
                MOV     CX,OPEN_ACCESS_READONLY ; Reset()
                CMP     [DI].fMode,fmInput      ; wird Datei zum Lesen geîffnet ?
                JE      @@ModeOk                ; ja -> ok, weiter
                MOV     CX,OPEN_ACCESS_READWRITE; lese Flags fÅr Append()
                INC     [DI].fHandle            ; Handle fÅr Standardausgabe = 1
                CMP     [DI].fMode,fmInOut      ; wird Datei wahlfrei geîffnet ?
                JE      @@ModeOk                ; ja -> ok, weiter
                MOV     AX,FILE_CREATE OR FILE_OPEN; lese Flags fÅr ReWrite()
@@ModeOk:       CMP     [DI].fName,0            ; ist Standardein-/ausgabe gemeint ?
                JE      @@AlreadyOpen           ; ja -> Datei nicht îffnen
                LEA     DX,[DI].fName           ; lese Zeiger auf 
                PUSH    DS                      ; den Dateinamen
                PUSH    DX                      ; und Åbergebe ihn als Argument
                LEA     BX,L_Handle             ; Åbergebe Zeiger auf 
                PUSH    SS                      ; Speicherbereich, wo
                PUSH    BX                      ; DateiHandle abgelegt wird
                LEA     BX,L_Action             ; Åbergebe Zeiger auf 
                PUSH    SS                      ; Speicherbereich, wo
                PUSH    BX                      ; ausgefÅhrte Aktion abgelegt wird
                XOR     BX,BX                   ; Åbergebe 
                PUSH    BX                      ; Grî·e
                PUSH    BX                      ; von 0
                PUSH    FILE_NORMAL             ; Flag fÅr normale Datei
                PUSH    AX                      ; Åbergebe Open Flags
                OR      CX,FileMode             ; setze Share-Mode
                PUSH    CX                      ; Åbergebe Open Mode
                PUSH    BX                      ; Åbergebe 0L
                PUSH    BX                      ; (reserviert)
                CALL    DosOpen                 ; îffne Datei
                CALL    ConvErrCode             ; konvertiere Fehlercode nach OS/2-Code
                OR      AX,AX                   ; Fehler aufgetreten ?
                JNZ     @@OpenError             ; ja -> Ende
                MOV     AX,L_Handle             ; lese neues DateiHandle
                MOV     [DI].fHandle,AX         ; speichern in TextRec
@@AlreadyOpen:  MOV     AX,OFFSET FileRead      ; lese Zeiger auf Read-Funktion
                MOV     DX,CS                   ; in DX:AX
                XOR     CX,CX                   ; keine Flush-Funktion
                XOR     BX,BX                   ; fÅr Eingabedatei verfÅgbar
                CMP     [DI].fMode,fmInput      ; ist Dateimodus Eingabe ?
                JE      @@SetTextFuncs          ; ja -> weiter
                PUSH    [DI].fHandle            ; teste, ob Datei zu einem Device fÅhrt
                LEA     BX,L_HandleType         ; Åbergebe Zeiger auf Word,
                PUSH    SS                      ; in dem der Handle-Typ 
                PUSH    BX                      ; gespeichert wird
                LEA     BX,L_DevAttr            ; Åbergebe Zeiger auf Word,
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
                INC     DX                      ; setze Flag fÅr "kein Device"
@@NoDevice:
                OR      DX,DX                   ; ist es Device?
                MOV     AX,OFFSET FileWrDev     ; lese Zeiger auf Write-Funktion
                MOV     DX,CS                   ; fÅr Devices in DX:AX
                MOV     CX,AX                   ; lese Zeiger auf Flush-Funktion
                MOV     BX,DX                   ; fÅr Devices in BX:CX
                JNE     @@IsDevice              ; falls Device -> weiter
                CMP     [DI].fMode,fmInOut      ; ist es Datei mit wahlfreiem Zugriff ?
                JNE     @@NoAppend              ; nein -> weiter
                CALL    FileAppend              ; bereite Datei-AnfÅgung vor
@@NoAppend:     MOV     AX,OFFSET FileWrite     ; lese Zeiger auf Write-Funktion
                MOV     DX,CS                   ; fÅr Devices in DX:AX
                XOR     CX,CX                   ; keine Flush-Funktion
                XOR     BX,BX                   ; verfÅgbar
@@IsDevice:     MOV     [DI].fMode,fmOutput     ; setze Dateimodus fÅr Ausgabe
@@SetTextFuncs: MOV     [DI].fInOutProc.offs,AX ; speichere Zeiger auf
                MOV     [DI].fInOutProc.segm,DX ; Ein-/Ausgabe-Funktion
                MOV     [DI].fFlushProc.offs,CX ; speichere Zeiger auf
                MOV     [DI].fFlushProc.segm,BX ; Flush-Funktion
                MOV     [DI].fCloseProc.offs,OFFSET FileClose ; speichere Zeiger
                MOV     [DI].fCloseProc.segm,CS ; auf Close-Funktion    
                XOR     AX,AX                   ; lîsche Fehlercode            
@@OpenError:    POP     DS
                RET     

                ;
                ; Bereite Datei-AnfÅgung vor, indem der Datei-Zeiger an
                ; das Ende der Datei bewegt wird und der letzte 128-Byte-
                ; Block der Datei in den Date-Buffer eingelesen wird.
                ;

FileAppend      PROC    NEAR

                ; Bestimme LÑnge der Datei.

                PUSH    [DI].fHandle            ; bestimme aktuelle Position
                XOR     AX,AX                   ; Åbergebe 0
                PUSH    AX                      ; als
                PUSH    AX                      ; Positionsangabe
                PUSH    FILE_END                ; vom Dateiende aus
                LEA     BX,L_FileSize           ; lese Zeiger auf Word, in dem 
                PUSH    SS                      ; die Dateigrî·e
                PUSH    BX                      ; gespeichert wird
                CALL    DosChgFilePtr           ; erfrage LÑnge der Datei
                OR      AX,AX                   ; ist Fehler aufgetreten ?
                JNZ     @@GetSizeError          ; ja -> DateilÑnge := 0
                MOV     AX,L_FileSize.offs      ; lese LÑnge
                MOV     DX,L_FileSize.segm      ; der Datei
                SUB     AX,128                  ; berechne Position 
                SBB     DX,0                    ; des letzten 128-Byte-Blocks
                JNC     @@Seek                  ; falls Datei nicht zu kurz -> weiter
@@GetSizeError: XOR     AX,AX                   ; bei Fehler
                XOR     DX,DX                   ; -> DatelÑnge := 0

                ; Bewege Datei-Zeiger auf 128 Bytes vor Dateiende.

@@Seek:         PUSH    [DI].fHandle            ; Åbergebe FileHandle
                PUSH    DX                      ; Åbergebe neue Position
                PUSH    AX                      ; des Datei-Zeigers (128 Bytes vor Dateiende)
                PUSH    FILE_BEGIN              ; vom Dateianfang aus
                LEA     BX,L_FilePtr            ; lese Zeiger auf Word, in dem 
                PUSH    SS                      ; die neue Position des
                PUSH    BX                      ; Datei-Zeigers gespeichert wird
                CALL    DosChgFilePtr           ; setze Datei-Zeiger

                ; Lese die letzten 128 Byte aus der Datei.

                PUSH    [DI].fHandle            ; Åbergebe FileHandle
                LEA     BX,[DI].fBuffer         ; Åbergebe Zeiger
                PUSH    SS                      ; auf den
                PUSH    BX                      ; Datei-Buffer
                PUSH    128                     ; LÑnge := 128 Bytes
                LEA     BX,L_Count              ; Åbergebe Zeiger auf Word,  
                PUSH    SS                      ; in dem die Anzahl der gelesenen 
                PUSH    BX                      ; Bytes gespeichert wird
                CALL    DosRead                 ; lese 128 Bytes aus Datei
                OR      AX,AX                   ; ist Lesefehler aufgetreten ?
                MOV     AX,0                    ; fÅr diesen Fall: 0 Bytes gelesen
                JNZ     @@ReadError             ; Fehler -> weiter
                MOV     AX,L_Count              ; lese Anzahl tatsÑchlich gelesener Bytes
@@ReadError:    XOR     BX,BX                   ; init. Index auf Datei-Buffer
@@ChkEofLoop:   CMP     BX,AX                   ; Ende des Buffers erreicht ?
                JE      @@End                   ; ja -> Ende
                CMP     [DI].fBuffer[BX],eof    ; ist EOF-Zeichen im Buffer ?
                JE      @@Truncate              ; ja -> schneide Datei ab
                INC     BX                      ; nÑchstes Byte im Buffer
                JMP     @@ChkEofLoop            ; auf EOF testen

                ; Schneide Datei am EOF-Zeichen ab, alle weiteren 
                ; Bytes hinter (logischem) Dateiende werden gelîscht.

@@Truncate:     SUB     BX,AX                   ; berechne 
                MOV     AX,L_FileSize.offs      ; Position 
                MOV     DX,L_FileSize.segm      ; zum 
                ADD     AX,BX                   ; Abschneiden
                ADC     DX,0                    ; der Datei
                PUSH    [DI].fHandle            ; Åbergebe FileHandle
                PUSH    DX                      ; Åbergebe neue LÑnge
                PUSH    AX                      ; der Datei
                CALL    DosNewSize              ; schneide Datei ab
                CALL    ConvErrCode             ; konvertiere Fehlercode nach OS/2-Code
@@End:          RET
FileAppend      ENDP
FileOpen        ENDP

CODE            ENDS

                END
