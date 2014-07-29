;//////////////////////////////////////////////////////
;/                                                    /
;/ Run-time Library fÅr Borland Pascal 7.0 unter OS/2 /
;/ Routinen fÅr Verzeichnisse.                        /
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
                PUSH    SS                      ; auf Buffer fÅr
                POP     DS                      ; Pfad in DS:SI
                MOV     AL,A_Drive              ; lese Nummer des Laufwerks
                OR      AL,AL                   ; ist es aktuelles Laufwerk ?
                JNZ     @@NotCurDrive           ; nein -> weiter
                LEA     BX,L_DriveNo            ; Åbergebe
                PUSH    SS                      ; Zeiger auf Speicher
                PUSH    BX                      ; fÅr Drive-Nummer
                LEA     BX,L_DriveMap           ; Åbergebe
                PUSH    SS                      ; Zeiger auf Speicher
                PUSH    BX                      ; fÅr Drive-Map
                CALL    DosQCurDisk             ; erfrage aktuelles Laufwerk
                MOV     AX,L_DriveNo            ; lese Nummer des Laufwerks
@@NotCurDrive:  MOV     DL,AL                   ; rette Nummer des aktuellen Laufwerks
                ADD     AL,'A' - 1              ; wandle in Laufwerksbuchstabe
                MOV     [SI],AL                 ; speichere als erstes 
                INC     SI                      ; Zeichen des Pfadnamens
                MOV     WORD PTR [SI],'\:'      ; fÅge ':\' 
                INC     SI                      ; an den 
                INC     SI                      ; Laufwerksbuchstaben an
                XOR     DH,DH                   ; Åbergebe Nummer
                PUSH    DX                      ; des Laufwerks
                PUSH    SS                      ; Åbergebe Zeiger
                PUSH    SI                      ; auf den Pfad-Buffer
                MOV     L_DriveNo,127           ; gebe max. LÑnge des Pfad-Buffers an
                LEA     BX,L_DriveNo            ; Åbergebe
                PUSH    SS                      ; Dummy-Zeiger auf Speicher
                PUSH    BX                      ; fÅr LÑnge des Pfadnamens
                CALL    DosQCurDir              ; erfrage aktuelles Verzeichnis
                OR      AX,AX                   ; ist Fehler aufgetreten ?
                JZ      @@NoError               ; nein -> weiter
                MOV     BYTE PTR [SI],0         ; kein Pfadnamen im Fehlerfall
@@NoError:      LEA     SI,L_Path               ; lese Zeiger auf Pfadnamen in DS:SI
                LES     DI,A_StrP               ; lese Zeiger auf RÅckgabe-String
                MOV     DX,DI                   ; rette Zeiger auf LÑngenbyte
                INC     DI                      ; Åberspringe LÑngenbyte
                MOV     CX,A_StrLen             ; lese max. LÑnge des RÅckgabe-Strings
                XOR     BX,BX                   ; LÑnge des RÅckgabe-Strings := 0
                CLD                             ; lese nÑchstes Zeichen  
@@GetCharLoop:  LODSB                           ; aus Pfadnamen
                OR      AL,AL                   ; ist Ende erreicht ?
                JE      @@StoreLen              ; ja -> speichere LÑngenbyte
                STOSB                           ; speichere Zeichen im RÅckgabe-String
                INC     BX                      ; erhîhe LÑnge des RÅckgabe-Strings
                LOOP    @@GetCharLoop           ; -> bis Ende erreicht ist
@@StoreLen:     MOV     DI,DX                   ; speichere LÑngenbyte
                MOV     AL,BL                   ; des 
                STOSB                           ; RÅckgabe-Strings
                POP     DS                      ; hole Datensegment zurÅck
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
                AND     AL,NOT 20H              ; wandle Laufwerkbuchstaben in Gro·buchstaben
                SUB     AL,'A' - 1              ; konvertiere Buchstaben
                XOR     AH,AH                   ; in Laufwerksnummer  
                PUSH    AX                      ; Åbergebe Laufwerksnummer
                CALL    DosSelectDisk           ; setze neues Default-Laufwerk
                OR      AX,AX                   ; ist Fehler aufgetreten ?
                JZ      @@DiskOk                ; nein -> ok, weiter
                MOV     InOutRes,15             ; sonst Fehler: 'Invalid drive number'
                JMP     SHORT @@Exit            ; -> Ende

@@DiskOk:       CMP     L_Path[2],0             ; ist Pfad hinter Laufwerksbuchstaben angegeben ?
                JE      @@Exit                  ; nein -> Ende
@@NoDisk:       LEA     BX,L_Path               ; Åbergebe
                PUSH    SS                      ; Zeiger auf
                PUSH    BX                      ; den Pfad-Buffer
                XOR     AX,AX                   ; Åbergebe
                PUSH    AX                      ; 0L
                PUSH    AX                      ; (reserviert)
                CALL    DosChDir                ; wÑhle neues Default-Verzeichnis
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
                XOR     DL,DL                   ; setze Flag fÅr Anlegen
                JMP     SHORT DirCreateRemove   ; -> lege Verzeichnis an
DirCreate       ENDP

                ;
                ; Procedure RmDir(Dir : String);
                ;

                PUBLIC  DirRemove
DirRemove       PROC    FAR
                MOV     DL,1                    ; setze Flag fÅr Lîschen
DirRemove       ENDP                            

                ;
                ; Gemeinsame Routine fÅr Anlegen/Lîschen eines 
                ; Verzeichnisses.
                ;

                PUBLIC  DirCreate
DirCreateRemove PROC    PASCAL FAR
                ARG     A_StrP : DWORD
                LOCAL   L_Path : BYTE : 128
                CALL    GetPath                 ; konvertiere Pfad in nullterminierten String
                LEA     BX,L_Path               ; Åbergebe
                PUSH    SS                      ; Zeiger auf
                PUSH    BX                      ; Pfadnamen
                XOR     AX,AX                   ; Åbergebe
                PUSH    AX                      ; 0L
                PUSH    AX                      ; (reserviert)
                OR      DL,DL                   ; soll Verzeichnis angelegt werden ?
                JZ      @@Create                ; ja -> weiter
                CALL    DosRmDir                ; lîsche Verzeichnis
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
                ; Die max. LÑnge betrÑgt 127 Zeichen.
                ;

GetPath         PROC    NEAR
                PUSH    DS                      ; rette Datensegment
                LDS     SI,A_StrP               ; lese Zeiger auf Agument-String in DS:SI
                LEA     DI,L_Path               ; lese Zeiger 
                PUSH    SS                      ; auf Pfad-Buffer
                POP     ES                      ; in ES:DI
                CLD                             ; lese LÑngenbyte
                LODSB                           ; des Argument-Strings
                CMP     AL,127                  ; ist LÑnge > 127 Zeichen ?
                JB      @@LenOk                 ; nein -> LÑnge ok, weiter
                MOV     AL,127                  ; sonst: begrenze Pfad auf 127 Zeichen
@@LenOk:        XOR     CX,CX                   ; lese LÑnge
                MOV     CL,AL                   ; in CX
                REP     MOVSB                   ; kopiere Argument-String in Pfad-Buffer
                XOR     AL,AL                   ; schlie·e Pfadnamen
                STOSB                           ; mit Nullbyte ab
                POP     DS                      ; hole Datensegment zurÅck
                RET
GetPath         ENDP
DirCreateRemove ENDP

CODE            ENDS

                END
