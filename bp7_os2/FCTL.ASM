;//////////////////////////////////////////////////////
;/                                                    /
;/ Run-time Library fr Borland Pascal 7.0 unter OS/2 /
;/ Datei-Routinen.                                    /
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

                ;
                ; Konvertiere OS/2-Fehlercode in AX in DOS-Fehlercode.
                ; Falls kein korrespondierender Fehlercode existiert,
                ; wird der OS/2-Code mit gesetztem Bit 15 zurckgegeben.
                ;

                PUBLIC  ConvErrCode
ConvErrCode     PROC    NEAR
                CMP     AX,110
                JNZ     @@1
                MOV     AX,2
@@1:            CMP     AX,88                   ; muá Code konvertiert werden ?
                                                ; Fehlercodes 1-87 sind gleich fr MS-DOS und OS/2!
                JAE     @@Convert               ; ja -> setze Bit 15
                RET

@@Convert:      OR      AH,80H                  ; setze Bit 15 fr OS/2-Fehlercode
                RET
ConvErrCode     ENDP

                ;
                ; Procedure Assign(Var f;Name : PChar);
                ;

                PUBLIC  AssignFileC
AssignFileC     PROC    PASCAL FAR
                MOV     DL,1                    ; setze Flag fr PChar-Argument
                JMP     SHORT Assign
AssignFileC     ENDP

                ;
                ; Procedure Assign(Var f;Name : String);
                ;

                PUBLIC  AssignFile
AssignFile      PROC    PASCAL FAR
                XOR     DX,DX                   ;l”sche Flag fr PChar-Argument
AssignFile      ENDP

                ; 
                ; Gemeinsame Routine fr Assign.
                ;

Assign          PROC    PASCAL FAR
                ARG     A_File : DWORD,  \
                        A_Name : DWORD
                PUSH    DS                      ; rette Datensegment
                LES     DI,A_File               ; lese Zeiger auf FileRec
                LDS     SI,A_Name               ; lese Zeiger auf Namen
                MOV     ES:[DI].fHandle,0       ; markiere Handle als ungltig
                MOV     ES:[DI].fMode,fmClosed  ; Datei ist geschlossen
                XOR     AX,AX                   ; l”sche die 
                MOV     CX,(fName-fBufSize)/2   ; restlichen 
                ADD     DI,fBufSize             ; Komponenten
                CLD                             ; des
                REP     STOSW                   ; FileRecs
                MOV     CX,79                   ; lese max. L„nge des Dateinamens
                OR      DX,DX                   ; ist es PChar-Routine ?
                JNE     @@CopyNameLoop          ; ja -> weiter
                LODSB                           ; lese L„ngenbyte des Namens
                CMP     CL,AL                   ; ist max. L„nge berschritten ?
                JBE     @@CopyNameLoop          ; nein -> ok, weiter
                MOV     CL,AL                   ; schneide Namen ab
                JCXZ    @@CopyNameEnd           ; falls Namen Leerstring -> weiter
@@CopyNameLoop: LODSB                           ; lese Zeichen aus angegebenem Dateinamen
                OR      AL,AL                   ; Ende erreicht (bei PChar-Routine) ?
                JE      @@CopyNameEnd           ; ja -> Kopieren des Namens beenden
                STOSB                           ; speichere Zeichen in TextRec
                LOOP    @@CopyNameLoop          ; gesamten Namen kopieren
@@CopyNameEnd:  XOR     AL,AL                   ; schlieáe Namen in TextRec
                STOSB                           ; mit Nullbyte ab
                POP     DS                      ; stelle Datensegment wieder her
                RET     
Assign          ENDP

                ;
                ; Procedure Close(Var f);
                ;

                PUBLIC  CloseFile
CloseFile       PROC    PASCAL FAR
                ARG     A_File : DWORD
                LES     DI,A_File               ; lese Zeiger auf FileRec
                CALL    OpenCheck               ; ist Datei ge”ffnet ?
                JNE     @@Exit                  ; falls nein -> Ende
                MOV     BX,ES:[DI].fHandle      ; lese Handle der Datei
                CMP     BX,2                    ; ist es Handle fr Standard-I/O ?
                JBE     @@Closed                ; ja -> nicht schlieáen
                PUSH    BX                      ; bergebe FileHandle
                CALL    DosClose                ; schlieáe Datei
                CALL    ConvErrCode             ; konvertiere Fehlercode nach OS/2-Code
                OR      AX,AX                   ; ist Fehler aufgetreten ?
                JZ      @@Closed                ; nein -> Ende
                MOV     InOutRes,AX             ; speichere Fehlercode
@@Closed:       MOV     ES:[DI].fMode,fmClosed  ; markiere Datei als geschlossen
@@Exit:         RET
CloseFile       ENDP

                ;
                ; Procedure Reset(Var f;RecSize : Word); 
                ;

                PUBLIC  ResetFile
ResetFile       PROC    PASCAL FAR
                MOV     AX,FILE_OPEN            ; lese Flags fr ™ffnen
                XOR     DX,DX                   ; Handle der Standard-Eingabe := 0
                JMP     SHORT OpenFile          ; -> ”ffne Datei
ResetFile       ENDP

                ;
                ; Procedure Rewrite(Var f;RecSize : Word); 
                ;

                PUBLIC  RewriteFile
RewriteFile     PROC    PASCAL FAR
                MOV     AX,FILE_CREATE OR FILE_OPEN; lese Flags fr neue Datei
                MOV     DX,1                    ; Handle der Standard-Ausgabe := 1
RewriteFile     ENDP

                ;
                ; Open file
                ;

OpenFile        PROC    PASCAL FAR
                ARG     A_FileP   : DWORD, \
                        A_RecSize : WORD
                LOCAL   L_Handle  : WORD,  \
                        L_Action  : WORD
                LES     DI,A_FileP              ; lese Zeiger auf FileRec
                CMP     ES:[DI].fMode,fmClosed  ; ist die Datei geschlossen ?
                JE      @@FileClosed            ; ja -> weiter
                CMP     ES:[DI].fMode,fmInOut   ; ist die Datei ge”ffnet ?
                JE      @@CloseFile             ; ja -> Datei zuerst schlieáen
                MOV     InOutRes,102            ; sonst Fehler: 'File not assigned'
                JMP     SHORT @@Exit            ; -> Ende

@@CloseFile:    PUSH    AX                      ; rette
                PUSH    DX                      ; Register
                PUSH    ES                      ; bergebe Zeiger
                PUSH    DI                      ; auf FileRec
                PUSH    CS                      ; schlieáe Datei, bevor
                CALL    CloseFile               ; sie wieder ge”ffnet wird
                POP     DX                      ; hole Register
                POP     AX                      ; zurck
@@FileClosed:   CMP     ES:[DI].fName,0         ; soll Standard-Ein-/Ausgabe ge”ffnet werden ?
                JE      @@OpenOk                ; ja -> weiter, bereits offen
                LEA     DX,[DI].fName           ; bergebe
                PUSH    ES                      ; Zeiger auf
                PUSH    DX                      ; Dateinamen
                LEA     DX,L_Handle             ; bergebe Zeiger auf 
                PUSH    SS                      ; Speicherbereich, wo
                PUSH    DX                      ; DateiHandle abgelegt wird
                LEA     DX,L_Action             ; bergebe Zeiger auf 
                PUSH    SS                      ; Speicherbereich, wo
                PUSH    DX                      ; ausgefhrte Aktion abgelegt wird
                XOR     DX,DX                   ; bergebe 
                PUSH    DX                      ; Gr”áe
                PUSH    DX                      ; von 0
                PUSH    FILE_NORMAL             ; Flag fr normale Datei
                PUSH    AX                      ; bergebe Open Flags
                MOV     AX,OPEN_ACCESS_READWRITE; ”ffne fr Ein-/Ausgabe
                OR      AX,FileMode             ; bergebe 
                PUSH    AX                      ; Open Mode
                PUSH    DX                      ; bergebe 0L
                PUSH    DX                      ; (reserviert)
                CALL    DosOpen                 ; ”ffne Datei
                MOV     DX,L_Handle             ; lese Handle der neuen Datei
                CALL    ConvErrCode             ; konvertiere Fehlercode nach OS/2-Code
                OR      AX,AX                   ; Fehler aufgetreten ?
                JZ      @@OpenOk                ; nein -> ok, weiter
                MOV     InOutRes,AX             ; speichere Fehlercode
                JMP     SHORT @@Exit            ; -> Ende

@@OpenOk:       XCHG    AX,DX                   ; lese Handle in AX
                MOV     ES:[DI].fMode,fmInOut   ; setze Dateimodus
                MOV     ES:[DI].fHandle,AX      ; speichere Handle
                MOV     AX,A_RecSize            ; speichere angegebene
                MOV     ES:[DI].fBufSize,AX     ; Record-Gr”áe im FileRec
@@Exit:         RET
OpenFile        ENDP

                ;
                ; Procedure Truncate(Var f);
                ;

                PUBLIC  TruncFile
TruncFile       PROC    PASCAL FAR
                ARG     A_FileP   : DWORD
                LOCAL   L_FilePos : DWORD
                LES     DI,A_FileP              ; lese Zeiger auf FileRec
                CALL    OpenCheck               ; ist Datei ge”ffnet ?
                JNE     @@Exit                  ; nein -> weiter
                PUSH    ES:[DI].fHandle         ; bestimme aktuelle Position
                XOR     AX,AX                   ; bergebe 0
                PUSH    AX                      ; als
                PUSH    AX                      ; Positionsangabe
                PUSH    FILE_CURRENT            ; von aktueller Position aus
                LEA     BX,L_FilePos            ; lese Zeiger auf Word, in dem 
                PUSH    SS                      ; die aktuelle Position des
                PUSH    BX                      ; Datei-Zeigers gespeichert wird
                CALL    DosChgFilePtr           ; erfrage aktuelle Position der Datei
                CALL    ConvErrCode             ; konvertiere Fehlercode nach OS/2-Code
                OR      AX,AX                   ; ist Fehler aufgetreten ?
                JNZ     @@Error                 ; ja -> Ende
                PUSH    ES:[DI].fHandle         ; bergebe FileHandle
                PUSH    L_FilePos.segm          ; bergebe neue
                PUSH    L_FilePos.offs          ; Dateigr”áe
                CALL    DosNewSize              ; schneide Datei ab
                CALL    ConvErrCode             ; konvertiere Fehlercode nach OS/2-Code
                OR      AX,AX                   ; ist Fehler aufgetreten ?
                JZ      @@Exit                  ; nein -> weiter
@@Error:        MOV     InOutRes,AX             ; speichere Fehlercode
@@Exit:         RET
TruncFile       ENDP
                
                ;
                ; Teste, ob Datei ge”ffnet ist.
                ;

OpenCheck       PROC    NEAR
                CMP     ES:[DI].fMode,fmInOut   ; ist Datei offen ?
                JE      @@Exit                  ; ja -> Ende
                MOV     InOutRes,103            ; sonst Fehler: 'File not open'
@@Exit:         RET
OpenCheck       ENDP

                ;
                ; Procedure Read(Var f;Var V);
                ;

                PUBLIC  ReadFile
ReadFile        PROC    PASCAL FAR
                XOR     AH,AH                   ; setze Flag fr Lesen
                MOV     DX,100                  ; Fehlernummer fr 'Disk read error'
                JMP     SHORT InOutFile         ; -> lese Datei
ReadFile        ENDP

                ;
                ; Procedure Write(Var f;Var V);
                ;

                PUBLIC  WriteFile
WriteFile       PROC    PASCAL FAR
                MOV     AH,1                    ; setze Flag fr Schreiben
                MOV     DX,101                  ; Fehlernummer fr 'Disk write error'
WriteFile       ENDP

                ;
                ; Typed file I/O
                ;

InOutFile       PROC    PASCAL FAR
                ARG     A_FileP    : DWORD, \
                        A_BufferP  : DWORD
                LOCAL   L_Count    : WORD
                LES     DI,A_FileP              ; lese Zeiger auf FileRec
                CALL    OpenCheck               ; ist Datei ge”ffnet ?
                JNE     @@Exit                  ; nein -> Fehler, Ende
                PUSH    DS                      ; rette Datensegment
                PUSH    DX                      ; rette Fehlernummer
                PUSH    ES:[DI].fHandle         ; bergebe FileHandle
                LDS     DX,A_BufferP            ; bergebe 
                PUSH    DS                      ; Zeiger auf
                PUSH    DX                      ; Buffer
                PUSH    ES:[DI].fBufSize        ; bergebe Anzahl Bytes zum Lesen/Schreiben
                LEA     BX,L_Count              ; bergebe Zeiger auf Word,
                PUSH    SS                      ; in dem die tats„chliche Anzahl
                PUSH    BX                      ; gelesener/geschriebener Bytes gespeichert wird
                OR      AH,AH                   ; Schreiben ?
                JZ      @@Read                  ; nein -> Lesen
                CALL    DosWrite                ; schreibe Block in Datei
                JMP     SHORT @@Ok              ; -> weiter

@@Read:         CALL    DosRead                 ; lese Block aus Datei
@@Ok:           CALL    ConvErrCode             ; konvertiere Fehlercode nach OS/2-Code
                POP     DX                      ; hole Fehlernummer zurck
                POP     DS                      ; hole Datensegment zurck
                OR      AX,AX                   ; ist Fehler aufgetreten ?
                JNZ     @@Error                 ; ja -> speichere Fehlernummer
                MOV     AX,L_Count              ; lese Anzahl gelesener/geschriebener Bytes
                CMP     AX,ES:[DI].fBufSize     ; konnte alles verarbeitet werden ?
                JE      @@Exit                  ; ja -> Ende
                MOV     AX,DX                   ; lese Fehlernummer in AX
@@Error:        MOV     InOutRes,AX             ; speichere Fehlernummer
@@Exit:         LEAVE                           ; nur A_BufferP vom Stack nehmen,
                RET     4                       ; A_FileP dort lassen !
InOutFile       ENDP

                ;
                ; Procedure BlockRead(Var f : File;Var Buf;Count : Word;Var Result : Word);
                ;

                PUBLIC  ReadBlock
ReadBlock       PROC    PASCAL FAR
                XOR     BL,BL                   ; setze Flag fr Lesen
                MOV     CX,100                  ; Fehlernummer fr 'Disk read error'
                JMP     SHORT InOutBlock
ReadBlock       ENDP

                ;
                ; Procedure BlockWrite(Var f : File;Var Buf;Count : Word;Var Result : Word);
                ;

                PUBLIC  WriteBlock
WriteBlock      PROC    PASCAL FAR
                MOV     BL,1                    ; setze Flag fr Schreiben
                MOV     CX,101                  ; Fehlernummer fr 'Disk write error'
WriteBlock      ENDP

                ;
                ; Ein-/Ausgabe von untypisierten Dateien.
                ;

InOutBlock      PROC    PASCAL FAR
                ARG     A_FileP   : DWORD, \
                        A_BufferP : DWORD, \
                        A_Count   : WORD,  \
                        A_ResultP : DWORD
                LOCAL   L_Count   : WORD
                LES     DI,A_FileP              ; lese Zeiger auf FileRec
                CALL    OpenCheck               ; ist Datei ge”ffnet ?
                JNE     @@NotOpen               ; nein -> Fehler, Ende
                MOV     AX,A_Count              ; lese Anzahl zu lesender/schreibender Bytes
                OR      AX,AX                   ; 0 Bytes lesen/schreiben ?
                JE      @@ZeroBuf               ; ja -> weiter
                PUSH    DS                      ; rette Datensegment
                PUSH    CX                      ; rette Fehlernummer
                PUSH    ES:[DI].fHandle         ; bergebe FileHandle
                LDS     DX,A_BufferP            ; bergebe 
                PUSH    DS                      ; Zeiger auf
                PUSH    DX                      ; Buffer
                MUL     ES:[DI].fBufSize        ; Anzahl Bytes := RecCount * RecSize
                PUSH    AX                      ; bergebe Anzahl Bytes zum Lesen/Schreiben
                LEA     DX,L_Count              ; bergebe Zeiger auf Word,
                PUSH    SS                      ; in dem die tats„chliche Anzahl
                PUSH    DX                      ; gelesener/geschriebener Bytes gespeichert wird
                OR      BL,BL                   ; Schreiben ?
                JZ      @@Read                  ; nein -> Lesen
                CALL    DosWrite                ; schreibe Block in Datei
                JMP     SHORT @@Ok              ; -> weiter

@@Read:         CALL    DosRead                 ; lese Block aus Datei
@@Ok:           POP     CX                      ; hole Fehlernummer zurck
                POP     DS                      ; hole Datensegment zurck
                CALL    ConvErrCode             ; konvertiere Fehlercode nach OS/2-Code
                OR      AX,AX                   ; ist Fehler aufgetreten ?
                JNZ     @@Error                 ; ja -> speichere Fehlernummer
                MOV     AX,L_Count              ; berechne Anzahl 
                XOR     DX,DX                   ; der gelesenen/geschriebenen
                DIV     ES:[DI].fBufSize        ; Records
@@ZeroBuf:      LES     DI,A_ResultP            ; lese Zeiger auf Ergebnis-Word
                MOV     DX,ES                   ; ist Ergebnis-Word
                OR      DX,DI                   ; berhaupt angegeben ?
                JE      @@NoResult              ; nein -> weiter
                MOV     ES:[DI],AX              ; speichere Anzahl Records im Ergebnis-Word
                JMP     SHORT @@Exit            ; -> Ende

@@NoResult:     CMP     AX,A_Count              ; wurde alles verarbeitet ?
                JE      @@Exit                  ; ja -> Ende
                MOV     InOutRes,CX             ; sonst setze Fehlercode
                JMP     SHORT @@Exit            ; -> Ende

@@Error:        MOV     InOutRes,AX             ; speichere Fehlercode
@@NotOpen:      LES     DI,A_ResultP            ; lese Zeiger auf Ergebnis-Word
                MOV     DX,ES                   ; ist Ergebnis-Word
                OR      DX,DI                   ; berhaupt angegeben ?
                JE      @@Exit                  ; nein -> Ende
                XOR     AX,AX                   ; speichere 0 als 
                MOV     ES:[DI],AX              ; Ergebnis im Fehlerfall
@@Exit:         RET
InOutBlock      ENDP

                ;
                ; Procedure Seek(Var f;Pos : LongInt);
                ;

                PUBLIC  SeekFile
SeekFile        PROC    PASCAL FAR
                ARG     A_FileP   : DWORD, \
                        A_FilePos : DWORD
                LOCAL   L_FilePtr : DWORD
                LES     DI,A_FileP              ; lese Zeiger auf FileRec
                CALL    OpenCheck               ; ist Datei ge”ffnet ?
                JNE     @@Exit                  ; nein -> Fehler, Ende
                MOV     AX,A_FilePos.w2         ; berechne 
                MUL     ES:[DI].fBufSize        ; die
                MOV     CX,AX                   ; neue
                MOV     AX,A_FilePos.w0         ; Position
                MUL     ES:[DI].fBufSize        ; des 
                ADD     CX,DX                   ; Datei-Zeigers
                PUSH    [DI].fHandle            ; bergebe FileHandle
                PUSH    CX                      ; bergebe neue Position
                PUSH    AX                      ; des Datei-Zeigers
                PUSH    FILE_BEGIN              ; vom Dateianfang aus
                LEA     BX,L_FilePtr            ; lese Zeiger auf Word, in dem 
                PUSH    SS                      ; die neue Position des
                PUSH    BX                      ; Datei-Zeigers gespeichert wird
                CALL    DosChgFilePtr           ; setze Datei-Zeiger
                OR      AX,AX                   ; ist Fehler aufgetreten ?
                JZ      @@Exit                  ; nein -> Ende
                CALL    ConvErrCode             ; konvertiere Fehlercode nach OS/2-Code
                MOV     InOutRes,AX             ; speichere Fehlercode
@@Exit:         RET
SeekFile        ENDP

CODE            ENDS

                END
