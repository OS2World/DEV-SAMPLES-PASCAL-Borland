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

;           Modifed by CHUCK TODD 70531.1475 {CT} { 4 Dec 1993 }
;      Procedure modifed to return additional results
;          Paramstr(-1) = Entire Cmdline with #0 between pgm name
;                         and rest of cmdline, verbatium
;          Paramstr(-2) = only Params returned verbatium no pgm name
;

                PUBLIC  GetParStr
GetParStr       PROC    PASCAL FAR
                ARG     A_Index     : WORD RETURNS A_ResultStr : DWORD
                LOCAL   PARMSONLY : word
                USES    DS
                MOV     DX,A_Index              ; lese Index des gewnschten Parameters
                MOV     [PARMSONLY],0           ;{CT}
                cmp     dx,-1                   ;{CT} if index = -1 then
                JE      @@Returnall             ;{CT} return entire cmd line
                MOV     [PARMSONLY],1           ;{CT}
                cmp     DX,-2                   ;{CT} if index = -2 then
                JE      @@Returnall             ;{CT} RETURN only All Params
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
@@ReturnAll:    LES     DI,CmdLine              ; Address to Command line in
                                                ; enviroment
                push    DI                      ; Save offset to cmd line
                CLD                             ; count up
                MOV     CX,-1                   ; Counter for Command Len
                XOR     AX,AX                   ; value to comp in SCASB
                REPNZ   SCASB                   ; #0 Program name
                cmp     [parmsonly],0           ;{CT} if pgm name and params
                je      @@all                   ;{CT} do all else clean di,cx
                pop     CX                      ;{CT} pull di of stack
                push    DI                      ;{CT} save di of Parms on stack
                mov     CX,-1                   ;{CT} Reset Length count
@@ALL:          REPNZ   SCASB                   ; #0 Terminating cmd line
                NOT     CX                      ; Convert cx to count
                DEC     CX
                CMP     CX,255                  ; is cmdline <= 255 chars long
                JBE     @@goodsize              ; yes
                Mov     CX,255                  ; no, truncate to 255
@@goodSize:     POP     DI                      ; Recover pointer to Source
                JMP     short @@copy
@@GetStr:       CALL    GetParam                ; lese Zeiger auf Parameter
@@Copy:         MOV     AX,ES                   ; Zeiger auf Parameter
                MOV     DS,AX                   ; in
                MOV     SI,DI                   ; DS:SI
                LES     DI,A_ResultStr          ; lese Zeiger auf Ergebnis-String
                CLD
                MOV     AL,CL                   ; speichere L„nge
                STOSB                           ; des Parameters
                REP     MOVSB                   ; kopiere Parameter in Ergebnis-String
@@end:          RET                             ; A_ResultStr muá auf Stack bleiben.
GetParStr       ENDP

                ;
                ; Function ParamCount : Word;
                ;


;        Modified by Chuck Todd {CT} 70531.1475 { 4 DEC 1993 }
; Origional procedure would terminate on multiple separators between params.
; all params after multiple separators ignored.
; Bug found by Jasper Neumann 2:242/2
; Reported by Peter Singer [100024,1603]
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
@@Loop1:        MOV     DI,SI                   ; rette Zeiger auf Anfang des Parameters
@@L1:           SEGES                           ; lese n„chstens Zeichen
                LODSB                           ; aus der Kommandozeile
                INC     CX                      ; erh”he Zeichenz„hler
                CMP     AL,0                    ;{CT} end marker?
                JE      @@end1                  ;{CT} yes, so exit
                CMP     AL,' '                  ; ist es Trennzeichen ?
                JA      @@L1                    ; nein -> weiter suchen
                DEC     CX                      ;{CT} set Length not to include separator
                JCXZ    @@Loop1                 ;{CT} if only Separator try again
                JMP     SHORT @@VALID           ;{CT} current param not ''
@@Valid:        CMP     BX,DX                   ; ist gewnschter Parameter gefunden ?
                JNB     @@End                   ; ja -> Ende
                INC     BX                      ; erh”he Anzahl Parameter
                JMP     @@Loop                  ; -> weiter suchen
@@End1:         DEC     CX                      ;{CT} is there a last parameter?
                JNZ     @@END2                  ;{CT} yes, so don't ignore it
@@END:          DEC     BX                      ;{CT} Correct param counter
@@end2:         RET
GetParam        ENDP

CODE            ENDS

                END
