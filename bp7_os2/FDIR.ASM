;//////////////////////////////////////////////////////
;/                                                    /
;/ Run-time Library fÅr Borland Pascal 7.0 unter OS/2 /
;/ Routinen fÅr Dateien.                              /
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
                EXTRN   ConvErrCode:NEAR

                ; 
                ; Procedure Erase(Var f);
                ;

                PUBLIC  EraseFile
EraseFile       PROC    PASCAL FAR
                ARG     A_FileP : DWORD
                LES     BX,A_FileP              ; lese Zeiger auf FileRec
                ADD     BX,fName                ; lese Zeiger auf Dateinamen
                PUSH    ES                      ; Åbergebe Zeiger
                PUSH    BX                      ; auf Dateinamen
                XOR     AX,AX                   ; Åbergebe
                PUSH    AX                      ; 0L
                PUSH    AX                      ; (reserviert)
                CALL    DosDelete               ; lîsche Datei
                CALL    ConvErrCode             ; konvertiere Fehlercode nach OS/2-Code
                OR      AX,AX                   ; ist Fehler aufgetreten ?
                JZ      @@Exit                  ; nein -> weiter
                MOV     InOutRes,AX             ; speichere Fehlercode
@@Exit:         RET
EraseFile       ENDP

                ;
                ; Procedure Rename(Var f;NewName : PChar); 
                ;

                PUBLIC  RenameFileC
RenameFileC     PROC    FAR
                MOV     DL,1                    ; setze Flag fÅr PChar-Argument
                JMP     SHORT RenFile
RenameFileC     ENDP

                ;
                ; Procedure Rename(Var f;NewName : String); 
                ;

                PUBLIC  RenameFile
RenameFile      PROC    FAR
                XOR     DL,DL                   ; lîsche Flag fÅr PChar-Argument
RenameFile      ENDP

                ;
                ; Gemeinsame Routine fÅr Umbenennen einer Datei.
                ;

RenFile         PROC    PASCAL FAR
                ARG     A_FileP   : DWORD, \
                        A_NameP   : DWORD
                LOCAL   L_NewName : BYTE : 80
                PUSH    DS                      ; rette Datensegment
                LDS     SI,A_NameP              ; lese Zeiger auf neuen Dateinamen in DS:SI
                LEA     DI,L_NewName            ; lese Zeiger auf 
                PUSH    SS                      ; Buffer fÅr neuen Namen
                POP     ES                      ; ES:DI
                CLD                             ; der Name darf
                MOV     CX,79                   ; max. 79 Zeichen lang sein
                OR      DX,DX                   ; PChar-Argument ?
                JNE     @@CopyLoop              ; ja -> weiter
                LODSB                           ; lese LÑngenbyte
                CMP     CL,AL                   ; ist max. LÑnge Åberschritten ?
                JBE     @@CopyLoop              ; nein -> weiter
                MOV     CL,AL                   ; setze max. LÑnge
                JCXZ    @@CopyEnd               ; falls Leerstring -> nicht kopieren
@@CopyLoop:     LODSB                           ; lese Zeichen aus neuem Namen
                OR      AL,AL                   ; Ende erreicht ?
                JE      @@CopyEnd               ; ja -> weiter
                STOSB                           ; speichere Zeichen
                LOOP    @@CopyLoop              ; -> bis alle Zeichen kopiert sind
@@CopyEnd:      XOR     AL,AL                   ; schlie·e Namen
                STOSB                           ; mit Nullbyte ab
                LDS     BX,A_FileP              ; lese Zeiger auf FileRec 
                ADD     BX,fName                ; Zeiger auf Namen in DS:DX
                PUSH    DS                      ; Åbergebe Zeiger
                PUSH    BX                      ; auf alten Namen
                LEA     BX,L_NewName            ; lese Zeiger auf neuen Namen
                PUSH    SS                      ; Åbergebe Zeiger
                PUSH    BX                      ; auf neuen Namen
                XOR     AX,AX                   ; Åbergebe
                PUSH    AX                      ; 0L
                PUSH    AX                      ; (reserviert)
                CALL    DosMove                 ; benenne Datei um
                OR      AX,AX                   ; ist Fehler aufgetreten ?
                JZ      @@SetNewName            ; nein -> weiter
                CALL    ConvErrCode             ; konvertiere Fehlercode nach OS/2-Code
                MOV     InOutRes,AX             ; speichere Fehlercode
                JMP     SHORT @@Exit            ; -> Ende

@@SetNewName:   LEA     SI,L_NewName            ; lese Zeiger auf 
                PUSH    SS                      ; neuen Dateinamen
                POP     DS                      ; in DS:SI
                LES     DI,A_FileP              ; lese Zeiger auf FileRec
                ADD     DI,fName                ; lese Zeiger auf Namen in FileRec
                CLD                             ; lese Zeichen
@@NewNameLoop:  LODSB                           ; aus neuem Namen
                STOSB                           ; speichere in FileRec
                OR      AL,AL                   ; Ende erreicht ?
                JNE     @@NewNameLoop           ; nein -> weiter kopieren
@@Exit:         POP     DS                      ; hole Datensegment zurÅck
                RET
RenFile         ENDP

CODE            ENDS

                END
