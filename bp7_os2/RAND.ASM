;//////////////////////////////////////////////////////
;/                                                    /
;/ Run-time Library fÅr Borland Pascal 7.0 unter OS/2 /
;/ Zufallszahlen-Generator.                           /
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
                EXTRN   RandSeed:DWORD
DATA            ENDS

CODE            SEGMENT BYTE PUBLIC
                ASSUME  CS:CODE,DS:DATA

Factor          DW      8405H                   ; Multiplication factor
ConstDelta      DD      2147483648.0            ; Scaling constants
ConstScale      DW      -32

                ; 
                ; Berechne nÑchste Zufallszahl und gebe sie in DX:AX zurÅck.
                ;

NextRand        PROC    NEAR
                MOV     AX,RandSeed.w0
                MOV     BX,RandSeed.w2
                MOV     CX,AX
                MUL     CS:Factor               ; New = Old.w0 * 8405H
                SHL     CX,1                    ; New.w2 += Old.w0 * 808H
                SHL     CX,1
                SHL     CX,1
                ADD     CH,CL
                ADD     DX,CX
                ADD     DX,BX                   ; New.w2 += Old.w2 * 8405H
                SHL     BX,1
                SHL     BX,1
                ADD     DX,BX
                ADD     DH,BL
                MOV     CL,5
                SHL     BX,CL
                ADD     DH,BL
                ADD     AX,1                    ; New += 1
                ADC     DX,0
                MOV     RandSeed.w0,AX
                MOV     RandSeed.w2,DX
                RET
NextRand        ENDP

                ;
                ; Function Random(Range : Word) : Word;
                ;

                PUBLIC  RandInt
RandInt         PROC    PASCAL FAR
                ARG     A_Range : WORD
                CALL    NextRand                ; lese nÑchste Zufallszahl
                MOV     CX,DX
                MUL     A_Range
                MOV     AX,CX
                MOV     CX,DX
                MUL     A_Range
                ADD     AX,CX
                ADC     DX,0
                MOV     AX,DX
                RET
RandInt         ENDP

                ;
                ; Function Random : Real;
                ;

                PUBLIC  RandReal
RandReal        PROC    FAR
                CALL    NextRand                ; lese nÑchste Zufallszahl
                XCHG    AX,BX
                MOV     AX,80H
                MOV     CX,32
@@Loop:         TEST    DH,80H
                JNE     @@Ok
                SHL     BX,1
                RCL     DX,1
                DEC     AL
                LOOP    @@Loop
                XOR     AL,AL
@@Ok:           AND     DH,7FH
                RET
RandReal        ENDP

                ;
                ; Function Random : Extended;
                ;

                PUBLIC  RandFloat
RandFloat       PROC    FAR
                CALL    NextRand                ; lese nÑchste Zufallszahl
                FILD    CS:ConstScale           ; lese Konstante -32
                FILD    RandSeed                ; Load 32-bit random integer
                FADD    CS:ConstDelta           ; fÅr Zahl mu· gelten:
                FSCALE                          ;   0 <= x < 1
                FSTP    ST(1)                   ; entferne Skalierungsfaktor
                FWAIT                           ; warte bis fertig
                RET
RandFloat       ENDP

                ;
                ; Procedure Randomize;
                ;

                PUBLIC  InitRand
InitRand        PROC    PASCAL FAR
                LOCAL   L_DateTime : DATETIME
                LEA     BX,L_DateTime
                PUSH    SS
                PUSH    BX        
                CALL    DosGetDateTime
                MOV     AX,L_DateTime.w0
                MOV     RandSeed.w0,AX
                MOV     AX,L_DateTime.w2
                MOV     RandSeed.w2,AX
                RET
InitRand        ENDP

CODE            ENDS

                END
