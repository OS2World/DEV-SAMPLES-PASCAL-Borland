;//////////////////////////////////////////////////////
;/                                                    /
;/ Run-time Library f�r Borland Pascal 7.0 unter OS/2 /
;/ Routinen f�r Verzeichnisse.                        /
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
                ; Procedure GetDir(D : Byte;Var Dir : String);
                ;

                PUBLIC  DirGet
DirGet          PROC    PASCAL FAR
                ARG     A_Drive    : BYTE  : 2,   \
                        A_StrP     : DWORD,       \
                        A_StrLen   : WORD
                LOCAL   L_DriveNo  : WORD,        \
                        L_DriveMap : DWORD,       \
                        L_Path     : BYTE  : 128
                PUSH    DS                      ; rette Datensegment
                LEA     SI,L_Path               ; lese Zeiger
                PUSH    SS                      ; auf Buffer f�r
                POP     DS                      ; Pfad in DS:SI
                MOV     AL,A_Drive              ; lese Nummer des Laufwerks
                OR      AL,AL                   ; ist es aktuelles Laufwerk ?
                JNZ     @@NotCurDrive           ; nein -> weiter
                LEA     BX,L_DriveNo            ; �bergebe
                PUSH    SS                      ; Zeiger auf Speicher
                PUSH    BX                      ; f�r Drive-Nummer
                LEA     BX,L_DriveMap           ; �bergebe
                PUSH    SS                      ; Zeiger auf Speicher
                PUSH    BX                      ; f�r Drive-Map
                CALL    DosQCurDisk             ; erfrage aktuelles Laufwerk
                MOV     AX,L_DriveNo            ; lese Nummer des Laufwerks
@@NotCurDrive:  MOV     DL,AL                   ; rette Nummer des aktuellen Laufwerks
                ADD     AL,'A' - 1              ; wandle in Laufwerksbuchstabe
                MOV     [SI],AL                 ; speichere als erstes 
                INC     SI                      ; Zeichen des Pfadnamens
                MOV     WORD PTR [SI],'\:'      ; f�ge ':\' 
                INC     SI                      ; an den 
                INC     SI                      ; Laufwerksbuchstaben an
                XOR     DH,DH                   ; �bergebe Nummer
                PUSH    DX                      ; des Laufwerks
                PUSH    SS                      ; �bergebe Zeiger
                PUSH    SI                      ; auf den Pfad-Buffer
                MOV     L_DriveNo,127           ; gebe max. L�nge des Pfad-Buffers an
                LEA     BX,L_DriveNo            ; �bergebe
                PUSH    SS                      ; Dummy-Zeiger auf Speicher
                PUSH    BX                      ; f�r L�nge des Pfadnamens
                CALL    DosQCurDir              ; erfrage aktuelles Verzeichnis
                OR      AX,AX                   ; ist Fehler aufgetreten ?
                JZ      @@NoError               ; nein -> weiter
                MOV     BYTE PTR [SI],0         ; kein Pfadnamen im Fehlerfall
@@NoError:      LEA     SI,L_Path               ; lese Zeiger auf Pfadnamen in DS:SI
                LES     DI,A_StrP               ; lese Zeiger auf R�ckgabe-String
                MOV     DX,DI                   ; rette Zeiger auf L�ngenbyte
                INC     DI                      ; �berspringe L�ngenbyte
                MOV     CX,A_StrLen             ; lese max. L�nge des R�ckgabe-Strings
                XOR     BX,BX                   ; L�nge des R�ckgabe-Strings := 0
                CLD                             ; lese n�chstes Zeichen  
@@GetCharLoop:  LODSB                           ; aus Pfadnamen
                OR      AL,AL                   ; ist Ende erreicht ?
                JE      @@StoreLen              ; ja -> speichere L�ngenbyte
                STOSB                           ; speichere Zeichen im R�ckgabe-String
                INC     BX                      ; erh�he L�nge des R�ckgabe-Strings
                LOOP    @@GetCharLoop           ; -> bis Ende erreicht ist
@@StoreLen:     MOV     DI,DX                   ; speichere L�ngenbyte
                MOV     AL,BL                   ; des 
                STOSB                           ; R�ckgabe-Strings
                POP     DS                      ; hole Datensegment zur�ck
                RET
DirGet          ENDP

                ;
                ; Procedure ChDir(Dir : String);
                ;

                PUBLIC  DirSet
DirSet          PROC    PASCAL FAR
                ARG     A_StrP : DWORD
                LOCAL   L_Path : BYTE : 128
                CALL    GetPath                 ; konvertiere Pfad in nullterminierten String
                MOV     AX,WORD PTR L_Path      ; lese die ersten zwei Zeichen aus Pfad
                OR      AL,AL                   ; ist ein Leerstring angegeben ?
                JE      @@Exit                  ; ja -> Ende
                CMP     AH,':'                  ; ist das zweite Zeichen = ':' ?
                JNE     @@NoDisk                ; nein -> nur Verzeichnis setzen
                AND     AL,NOT 20H              ; wandle Laufwerkbuchstaben in Gro�buchstaben
                SUB     AL,'A' - 1              ; konvertiere Buchstaben
                XOR     AH,AH                   ; in Laufwerksnummer  
                PUSH    AX                      ; �bergebe Laufwerksnummer
                CALL    DosSelectDisk           ; setze neues Default-Laufwerk
                OR      AX,AX                   ; ist Fehler aufgetreten ?
                JZ      @@DiskOk                ; nein -> ok, weiter
                MOV     InOutRes,15             ; sonst Fehler: 'Invalid drive number'
                JMP     SHORT @@Exit            ; -> Ende

@@DiskOk:       CMP     L_Path[2],0             ; ist Pfad hinter Laufwerksbuchstaben angegeben ?
                JE      @@Exit                  ; nein -> Ende
@@NoDisk:       LEA     BX,L_Path               ; �bergebe
                PUSH    SS                      ; Zeiger auf
                PUSH    BX                      ; den Pfad-Buffer
                XOR     AX,AX                   ; �bergebe
                PUSH    AX                      ; 0L
                PUSH    AX                      ; (reserviert)
                CALL    DosChDir                ; w�hle neues Default-Verzeichnis
                OR      AX,AX                   ; ist Fehler aufgetreten ?
                JZ      @@Exit                  ; nein -> Ende
                CALL    ConvErrCode             ; konvertiere Fehlercode nach OS/2-Code
                MOV     InOutRes,AX             ; specichere Fehlernummer
@@Exit:         RET
DirSet          ENDP

                ;
                ; Procedure MkDir(Dir : String);
                ;

                PUBLIC  DirCreate
DirCreate       PROC    FAR
                XOR     DL,DL                   ; setze Flag f�r Anlegen
                JMP     SHORT DirCreateRemove   ; -> lege Verzeichnis an
DirCreate       ENDP

                ;
                ; Procedure RmDir(Dir : String);
                ;

                PUBLIC  DirRemove
DirRemove       PROC    FAR
                MOV     DL,1                    ; setze Flag f�r L�schen
DirRemove       ENDP                            

                ;
                ; Gemeinsame Routine f�r Anlegen/L�schen eines 
                ; Verzeichnisses.
                ;

                PUBLIC  DirCreate
DirCreateRemove PROC    PASCAL FAR
                ARG     A_StrP : DWORD
                LOCAL   L_Path : BYTE : 128
                CALL    GetPath                 ; konvertiere Pfad in nullterminierten String
                LEA     BX,L_Path               ; �bergebe
                PUSH    SS                      ; Zeiger auf
                PUSH    BX                      ; Pfadnamen
                XOR     AX,AX                   ; �bergebe
                PUSH    AX                      ; 0L
                PUSH    AX                      ; (reserviert)
                OR      DL,DL                   ; soll Verzeichnis angelegt werden ?
                JZ      @@Create                ; ja -> weiter
                CALL    DosRmDir                ; l�sche Verzeichnis
                JMP     SHORT @@TestOnErr       ; -> teste auf Fehler

@@Create:       CALL    DosMkDir                ; lege neues Verzeichnis an
@@TestOnErr:    OR      AX,AX                   ; ist Fehler aufgetreten ?
                JZ      @@NoError               ; nein -> weiter
                CALL    ConvErrCode             ; konvertiere Fehlercode nach OS/2-Code
                MOV     InOutRes,AX             ; speichere Fehlernummer
@@NoError:      RET

                ;
                ; Kopiere den Argument-String (Pascal-String) als
                ; nullterminierten String in den Pfad-Buffer.
                ; Die max. L�nge betr�gt 127 Zeichen.
                ;

GetPath         PROC    NEAR
                PUSH    DS                      ; rette Datensegment
                LDS     SI,A_StrP               ; lese Zeiger auf Agument-String in DS:SI
                LEA     DI,L_Path               ; lese Zeiger 
                PUSH    SS                      ; auf Pfad-Buffer
                POP     ES                      ; in ES:DI
                CLD                             ; lese L�ngenbyte
                LODSB                           ; des Argument-Strings
                CMP     AL,127                  ; ist L�nge > 127 Zeichen ?
                JB      @@LenOk                 ; nein -> L�nge ok, weiter
                MOV     AL,127                  ; sonst: begrenze Pfad auf 127 Zeichen
@@LenOk:        XOR     CX,CX                   ; lese L�nge
                MOV     CL,AL                   ; in CX
                REP     MOVSB                   ; kopiere Argument-String in Pfad-Buffer
                XOR     AL,AL                   ; schlie�e Pfadnamen
                STOSB                           ; mit Nullbyte ab
                POP     DS                      ; hole Datensegment zur�ck
                RET
GetPath         ENDP
DirCreateRemove ENDP

CODE            ENDS

                END
