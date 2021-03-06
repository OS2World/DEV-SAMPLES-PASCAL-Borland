;//////////////////////////////////////////////////////
;/                                                    /
;/ Run-time Library f�r Borland Pascal 7.0 unter OS/2 /
;/ Routinen f�r Dateien.                              /
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
                EXTRN   InOutRes:WORD
DATA            ENDS

CODE            SEGMENT BYTE PUBLIC
                ASSUME  CS:CODE,DS:DATA
                EXTRN   LongDiv:NEAR
                EXTRN   ConvErrCode:NEAR

                ;
                ; Function FilePos(Var f) : LongInt;
                ;

                PUBLIC  GetFPos
GetFPos         PROC    PASCAL FAR
                ARG     A_FileP    : DWORD
                LOCAL   L_FilePos  : DWORD, \
                        L_FileSize : DWORD
                CALL    FileData                ; lese Position des Dateizeigers
                JC      Exit                    ; falls Fehler -> Ende
GetPosSize:     MOV     CX,ES:[DI].fBufSize     ; lese Record-Gr��e
                CMP     CX,1                    ; ist es 1-Byte-Record ?
                JE      Exit                    ; ja -> Ende
                XOR     BX,BX                   ; anderenfalls dividiere die 
                PUSH    CS                      ; Position des Dateizeigers 
                CALL    LongDiv                 ; durch die Record-Gr��e
Exit:           RET
GetFPos         ENDP

                ;
                ; Function FileSize(Var f) : LongInt;
                ;

                PUBLIC  GetFSize
GetFSize        PROC    PASCAL FAR
                ARG     A_FileP    : DWORD
                LOCAL   L_FilePos  : DWORD, \
                        L_FileSize : DWORD
                CALL    FileData                ; lese Gr��e der Datei
                JC      Exit                    ; falls Fehler -> Ende
                MOV     AX,CX                   ; lese Dateigr��e
                MOV     DX,BX                   ; in DX:AX
                JMP     GetPosSize              ; berechne Dateigr��e in Records
GetFSize        ENDP

                ;
                ; Function Eof(Var f) : Boolean;
                ;

                PUBLIC  GetFEof
GetFEof         PROC    PASCAL FAR
                ARG     A_FileP    : DWORD
                LOCAL   L_FilePos  : DWORD, \
                        L_FileSize : DWORD
                CALL    FileData                ; lese Position des Dateizeigers und Dateigr��e
                JC      @@False                 ; falls Fehler -> gebe False zur�ck
                SUB     AX,CX                   ; ist Dateigr��e gr��er
                SBB     DX,BX                   ; als Position des Dateizeigers ?
                JC      @@False                 ; ja -> weiter
                MOV     AL,1                    ; Ergebnis := True
                RET

@@False:        XOR     AL,AL                   ; Ergebnis := False
                RET

                ;
                ; Erfrage Position des Dateizeigers (DX:AX) und
                ; Dateigr��e (BX:CX). Carry ist bei Fehler gesetzt.
                ;

FileData        PROC    NEAR
                LES     DI,A_FileP              ; lese Zeiger auf FileRec
                CMP     ES:[DI].fMode,fmInOut   ; ist Datei offen ?
                JNE     @@Error                 ; nein -> Fehler
                PUSH    ES:[DI].fHandle         ; �bergebe FileHandle
                XOR     AX,AX                   ; �bergebe 0
                PUSH    AX                      ; als
                PUSH    AX                      ; Positionsangabe
                PUSH    FILE_CURRENT            ; von aktueller Position aus
                LEA     BX,L_FilePos            ; lese Zeiger auf Word, in dem 
                PUSH    SS                      ; die aktuelle Position des
                PUSH    BX                      ; Datei-Zeigers gespeichert wird
                CALL    DosChgFilePtr           ; erfrage aktuelle Position der Datei
                CALL    ConvErrCode             ; konvertiere Fehlercode nach OS/2-Code
                OR      AX,AX                   ; ist Fehler aufgetreten ?
                JNZ     @@Error1                ; ja -> Ende
                PUSH    ES:[DI].fHandle         ; �bergebe FileHandle
                XOR     AX,AX                   ; �bergebe 0
                PUSH    AX                      ; als
                PUSH    AX                      ; Positionsangabe
                PUSH    FILE_END                ; von Dateiende aus
                LEA     BX,L_FileSize           ; lese Zeiger auf Word, in dem 
                PUSH    SS                      ; die Dateigr��e
                PUSH    BX                      ; gespeichert wird
                CALL    DosChgFilePtr           ; erfrage Dateigr��e
                CALL    ConvErrCode             ; konvertiere Fehlercode nach OS/2-Code
                OR      AX,AX                   ; ist Fehler aufgetreten ?
                JNZ     @@Error1                ; ja -> Ende
                PUSH    ES:[DI].fHandle         ; bestimme Gr��e der Datei
                PUSH    L_FilePos.segm          ; �bergebe alte Position
                PUSH    L_FilePos.offs          ; des Dateizeigers
                PUSH    FILE_BEGIN              ; von Dateiende aus
                LEA     BX,L_FilePos            ; lese Zeiger auf Word, in dem 
                PUSH    SS                      ; die aktuelle Position des
                PUSH    BX                      ; Dateizeigers gespeichert wird
                CALL    DosChgFilePtr           ; gehe wieder an alte Position
                CALL    ConvErrCode             ; konvertiere Fehlercode nach OS/2-Code
                OR      AX,AX                   ; ist Fehler aufgetreten ?
                JNZ     @@Error1                ; ja -> Ende
                MOV     DX,L_FilePos.segm       ; lese Position des Dateizeigers
                MOV     AX,L_FilePos.offs       ; in DX:AX
                MOV     BX,L_FileSize.segm      ; lese Dateigr��e
                MOV     CX,L_FileSize.offs      ; in BX:CX
                CLC                             ; l�sche Fehlerflag
                RET

@@Error:        MOV     AX,103                  ; Fehler: 'File not open'
@@Error1:       MOV     InOutRes,AX             ; speichere Fehlercode
                XOR     AX,AX                   ; lese 0
                CWD                             ; als Dateiposition
                MOV     CX,AX                   ; lese 0
                MOV     BX,AX                   ; als Dateigr��e
                STC                             ; setze Fehlerflag
                RET
FileData        ENDP
GetFEof         ENDP

CODE            ENDS

                END
