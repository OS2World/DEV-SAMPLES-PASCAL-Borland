;//////////////////////////////////////////////////////
;/                                                    /
;/ Run-time Library fr Borland Pascal 7.0 unter OS/2 /
;/ Routinen fr Kommandozeilen-Parameter.             /
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
                EXTRN   CmdLine:DWORD
DATA            ENDS

CODE            SEGMENT BYTE PUBLIC
                ASSUME  CS:CODE,DS:DATA

                ;
                ; Function ParamStr(i : Word) : String;
                ;

                PUBLIC  GetParStr
GetParStr       PROC    PASCAL FAR
                ARG     A_ResultStr : DWORD, \
                        A_Index     : WORD
                PUSH    DS                      ; rette Datensegment
                MOV     DX,A_Index              ; lese Index des gewnschten Parameters
                OR      DX,DX                   ; ist es ParamStr(0) ?
                JNZ     @@GetStr                ; nein -> weiter
                LES     DI,CmdLine              ; lese Zeiger auf 
                DEC     DI                      ; Kommandozeile
                DEC     DI
                STD                             ; bestimme 
                MOV     CX,-1                   ; die
                XOR     AX,AX                   ; L„nge
                REPNZ   SCASB                   ; des
                NOT     CX                      ; Programmnamens
                DEC     CX                      ; lese L„nge
                INC     DI                      ; in CX und
                INC     DI                      ; Zeiger auf Programmnamen
                JMP     SHORT @@Copy            ; kopiere Ergebnis
                
@@GetStr:       CALL    GetParam                ; lese Zeiger auf Parameter
@@Copy:         MOV     AX,ES                   ; Zeiger auf Parameter
                MOV     DS,AX                   ; in 
                MOV     SI,DI                   ; DS:SI
                LES     DI,A_ResultStr          ; lese Zeiger auf Ergebnis-String  
                CLD     
                MOV     AL,CL                   ; speichere L„nge
                STOSB                           ; des Parameters
                REP     MOVSB                   ; kopiere Parameter in Ergebnis-String
                POP     DS                      ; hole Datensegment zurck
                LEAVE                           ; nur A_Index l”schen!
                RET     2                       ; A_ResultStr muá auf Stack bleiben.
GetParStr       ENDP

                ;
                ; Function ParamCount : Word;
                ;

                PUBLIC  GetParCnt
GetParCnt       PROC    FAR
                MOV     DX,999                  ; suche letzten Parameter
                CALL    GetParam                ; in der Kommandozeile
                MOV     AX,BX                   ; lese Nummer des letzten angegebenen Parameters
                RET
GetParCnt       ENDP

                ;
                ; Lese Zeiger auf Parameter mit dem Index in DX.
                ; Der Zeiger wird in ES:DI zurckgegeben, die
                ; L„nge in CX.
                ;

GetParam        PROC    NEAR
                MOV     BX,1                    ; Parameter-Index := 1
                LES     DI,CmdLine              ; lese Zeiger auf Kommandozeile
                CLD                             ; berspringe
                MOV     CX,-1                   ; Programm-
                XOR     AX,AX                   ; namen
                REPNZ   SCASB                   
                SCASB                           ; ist berhaupt ein Parameter angegeben ?
                JNZ     @@Ok                    ; ja -> weiter
                DEC     DI                      ; setze Zeiger auf Leerstring
                XOR     CX,CX
                JMP     SHORT @@End             ; -> Ende

@@Ok:           MOV     SI,DI                   ; in ES:SI
@@Loop:         XOR     CX,CX                   ; suche nach Ende des Parameters
                MOV     DI,SI                   ; rette Zeiger auf Anfang des Parameters
@@L1:           SEGES                           ; lese n„chstens Zeichen  
                LODSB                           ; aus der Kommandozeile
                INC     CX                      ; erh”he Zeichenz„hler
                CMP     AL,' '                  ; ist es Trennzeichen ?
                JA      @@L1                    ; nein -> weiter suchen
                DEC     CX                      ; teste L„nge des Parameters
                JCXZ    @@End                   ; falls Ende der Kommandozeile -> Ende
                CMP     BX,DX                   ; ist gewnschter Parameter gefunden ?
                JNB     @@End                   ; ja -> Ende
                INC     BX                      ; erh”he Anzahl Parameter
                JMP     @@Loop                  ; -> weiter suchen
@@End:          
                DEC     BX
                RET
GetParam        ENDP

CODE            ENDS

                END
