;//////////////////////////////////////////////////////
;/                                                    /
;/ Run-time Library fÅr Borland Pascal 7.0 unter OS/2 /
;/ Startup-Routine fÅr OS/2-Programme.                /
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
                EXTRN   Input:BYTE,Output:BYTE,CmdLine:DWORD,SelectorInc:WORD
                EXTRN   ExitProc:DWORD,EnvironmentSeg:WORD,Test8086:BYTE
                EXTRN   SaveInt00:DWORD,SaveInt0C:DWORD,SaveInt0D:DWORD
DATA            ENDS

CODE            SEGMENT BYTE PUBLIC
                ASSUME  CS:CODE,DS:DATA

                EXTRN   AssignText:NEAR,ResetText:NEAR,RewriteText:NEAR
                EXTRN   CloseText:NEAR,HaltError:FAR

                ;
                ; Startup-Routine fÅr OS/2-Programme.
                ; Jedes Programm beginnt mit einem Far-Call
                ; dieser Routine.
                ;

                PUBLIC  InitTurbo
InitTurbo       PROC    FAR
                XOR     BP,BP                   ; setze Markierung fÅr ungÅltigen Stack-Frame
                MOV     EnvironmentSeg,AX       ; speichere Selektor des Environment-Blocks
                MOV     CmdLine.offs,BX         ; speichere Zeiger
                MOV     CmdLine.segm,AX         ; auf die Kommandozeile
                MOV     AX,SP
                ADD     AX,4
                MOV     SS:pStackTop,10H        
                MOV     SS:pStackBot,AX         
                MOV     SS:pStackMin,AX         
                CALL    Check8086               ; bestimme Prozessortyp
                PUSH    VECTOR_DIVIDE_BY_ZERO   ; setze Handler fÅr INT 00
                PUSH    CS                      ; (Divide by zero)
                PUSH    OFFSET Int00Handler
                PUSH    DS
                PUSH    OFFSET SaveInt00
                CALL    DosSetVec
                PUSH    12                      ; setze Handler fÅr INT 0C
                PUSH    CS                      ; (Stack Fault)
                PUSH    OFFSET Int0DHandler
                PUSH    DS
                PUSH    OFFSET SaveInt0C
                CALL    DosSetVec
                PUSH    13                      ; setze Handler fÅr INT 0D
                PUSH    CS                      ; (General Protection Fault)
                PUSH    OFFSET Int0DHandler
                PUSH    DS
                PUSH    OFFSET SaveInt0D
                CALL    DosSetVec
                MOV     AX,OFFSET Input         ;Assign/Reset Input file
                PUSH    DS
                PUSH    AX
                PUSH    DS
                PUSH    AX
                MOV     AX,OFFSET ZeroString
                PUSH    CS
                PUSH    AX
                PUSH    CS
                CALL    AssignText
                PUSH    CS
                CALL    ResetText
                MOV     AX,OFFSET Output        ;Assign/Rewrite Output file
                PUSH    DS
                PUSH    AX
                PUSH    DS
                PUSH    AX
                MOV     AX,OFFSET ZeroString
                PUSH    CS
                PUSH    AX
                PUSH    CS
                CALL    AssignText
                PUSH    CS
                CALL    RewriteText
                PUSH    DS                      ; erfrage
                PUSH    OFFSET SelectorInc      ; den Wert
                CALL    DosGetHugeShift         ; fÅr AHugeShift
                MOV     AX,1                    ; berechne
                MOV     CX,SelectorInc          ; daraus den
                SHL     AX,CL                   ; SelectorInc-Wert
                MOV     SelectorInc,AX          ; (SelectorInc := 1 Shl AHugeShift)
                MOV     ExitProc.offs,OFFSET ExitTurbo ; setze standardmÑ·ige
                MOV     ExitProc.segm,CS        ; Exit-Prozedur
                RET

                ;
                ; Bestimme den CPU-Typ und setze
                ; Variable Test8086 entsprechend.
                ;

                PUBLIC  Check8086
Check8086       PROC    NEAR
                XOR     AX,AX                   ;lese 0 als Kennzeichen fÅr 8088/8086
                PUSHF                           ;BX = Flags
                POP     BX
                AND     BH,0FH                  ;Clear bits 12-15
                PUSH    BX                      ;Flags = BX
                POPF
                PUSHF                           ;CX = Flags
                POP     CX
                AND     CH,0F0H                 ;Bits 12-15 set?
                CMP     CH,0F0H
                JE      @@End                   ; ja -> Typ = 8088/86
                INC     AX                      ; lese 1 als Kennzeichen fÅr 80286
                OR      BH,0F0H                 ;Set bits 12-15
                PUSH    BX                      ;Flags = BX
                POPF
                PUSHF                           ;CX = Flags
                POP     CX
                AND     CH,0F0H                 ;Bits 12-15 cleared?
                JE      @@End                   ; ja -> Typ = 80286
                INC     AX                      ; lese 2 als Kennzeichen fÅr 80386
@@End:          MOV     Test8086,AL             ; speichere Ergebnis
                RET
Check8086       ENDP

                ;
                ; Routine fÅr INT 00: Division by zero.
                ;

Int00Handler    PROC    FAR
                MOV     AX,200                  ; Fehler: 'Division by zero'
                JMP     HaltError
Int00Handler    ENDP

                ;
                ; Routine fÅr INT 0C: Stack Fault.
                ;

Int0CHandler    PROC    FAR
                MOV     AX,202                  ; Fehler: 'Stack overflow error'
                JMP     HaltError
Int0CHandler    ENDP

                ;
                ; Routine fÅr INT 0D: General Protection Fault.
                ;

Int0DHandler    PROC    FAR
                MOV     AX,216                  ; Fehler: 'General Protection fault'
                JMP     HaltError
Int0DHandler    ENDP

ZeroString      DB      0
InitTurbo       ENDP

                ;
                ; Beende das OS/2-Programm.
                ; Schlie·e die Standard-Ein-/Ausgabedateien.
                ;

ExitTurbo       PROC    FAR
                MOV     AX,OFFSET Input         
                PUSH    DS
                PUSH    AX
                PUSH    CS
                CALL    CloseText
                MOV     AX,OFFSET Output        
                PUSH    DS
                PUSH    AX
                PUSH    CS
                CALL    CloseText
                RET
ExitTurbo       ENDP

CODE            ENDS

                END
