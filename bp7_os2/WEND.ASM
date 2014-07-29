;//////////////////////////////////////////////////////
;/                                                    /
;/ Run-time Library fÅr Borland Pascal 7.0 unter OS/2 /
;/ Beendigungs-Routine fÅr OS/2-Programme.            /
;/                                                    /
;/ 1993 Matthias Withopf / c't                        /
;/ Originalversion (c) 1988,92 Borland International  /
;/                                                    /
;//////////////////////////////////////////////////////

                .286p                                         

                _NOMACROS_ = 1                  ; keine Macros definieren
                INCLUDE SE.ASM
                INCLUDE OS2.ASM

CONST           SEGMENT WORD PUBLIC
ErrorStr        DB      'Runtime error '
                DB      '    0'
ErrorCodeStrE   DB      ' at '
                DB      '0000'
ErrorSegmStrE   DB      ':'
                DB      '0000'
ErrorOffsStrE   DB      '.'
ErrorStrLen     EQU     $ - ErrorStr
CONST           ENDS

DATA            SEGMENT WORD PUBLIC
                EXTRN   ExitProc:DWORD,ExitCode:WORD,ErrorAddr:DWORD
                EXTRN   EnvironmentSeg:WORD,InOutRes:WORD
DATA            ENDS

DGROUP          GROUP   CONST,DATA

CODE            SEGMENT BYTE PUBLIC
                ASSUME  CS:CODE,DS:DGROUP

                ;
                ; Procedure RunError(ErrorCode : Byte);
                ;

                PUBLIC  HaltError
HaltError       PROC    FAR
                POP     CX                      ; hole RÅcksprungadresse vom Stack
                POP     BX                      ; (an dieser Stelle ist Fehler aufgetreten)
                JMP     SHORT Terminate         ; -> beende Programm
HaltError       ENDP

                ;
                ; Procedure Halt(ExitCode : Word);
                ;

                PUBLIC  HaltTurbo
HaltTurbo       PROC    FAR
                XOR     CX,CX                   ; Programm wurde mit 'Halt' ordnungsgemÑ·
                XOR     BX,BX                   ; beendet, keine Fehleradresse verfÅgbar
HaltTurbo       ENDP

                ;
                ; Beende Programm. In AX wird der Exit-Code des
                ; Programms Åbergeben, in BX:CX die Fehleradresse
                ; oder Nil.
                ;

                PUBLIC  Terminate
Terminate       PROC    FAR
                PUSH    AX                      ; rette Exit-Code
                MOV     AX,SEG DATA             ; lade Datensegment
                MOV     DS,AX                   ; des Programms
                POP     AX                      ; hole Exit-Code zurÅck
                MOV     ExitCode,AX             ; speichere Exit-Code
                MOV     AX,CX                   ; ist es ein Runtime Error ?
                OR      AX,BX                   ; (Fehleradresse in BX:CX)
                JE      @@ExitAddrOk            ; nein -> weiter
                CMP     BX,-1                   ; unbekannte Fehleradresse ?
                JE      @@ExitAddrOk            ; ja -> nicht Ñndern
                MOV     ES,BX                   ; lese logische Segment-Nummer, die im 
                MOV     BX,WORD PTR ES:0        ; 1. Word jedes Code-Segments gespeichert ist
@@ExitAddrOk:   MOV     ErrorAddr.offs,CX       ; speichere 
                MOV     ErrorAddr.segm,BX       ; Fehleradresse
                CMP     EnvironmentSeg,0        ; wird diese Routine von einer DLL aufgerufen ? Falls ja 
                JE      @@NoExitProcs           ; -> Exit-Prozeduren nicht ausfÅhren, diese sind nur fÅr Hauptprgm
                CALL    DoExitProcs             ; Exit-Prozeduren ausfÅhren
@@NoExitProcs:  MOV     AX,ErrorAddr.offs       ; ist es ein 
                OR      AX,ErrorAddr.segm       ; Runtime Error?
                JE      @@NoRTError             ; nein -> weiter
                MOV     AX,ExitCode             ; lese Exit-Code in AX
                MOV     BX,OFFSET ErrorCodeStrE ; wandle
                MOV     CX,10                   ; in 
                CALL    Num2Str                 ; Dezimal-String
                MOV     AX,ErrorAddr.segm       ; lese Selektor
                MOV     BX,OFFSET ErrorSegmStrE ; der Fehleradresse 
                MOV     CX,16                   ; und wandle
                CALL    Num2Str                 ; in Hexadezimal-String
                MOV     AX,ErrorAddr.offs       ; lese Offset der 
                MOV     BX,OFFSET ErrorOffsStrE ; Fehleradresse und wandle
                CALL    Num2Str                 ; in Hexadezimal-String
                PUSH    1                       ; Åbergebe Handle der Standard-Ausgabe
                PUSH    DS                      ; Åbergebe Adresse  
                PUSH    OFFSET ErrorStr         ; des Fehlertexts
                PUSH    ErrorStrLen             ; Åbergebe TextlÑnge
                PUSH    DS                      ; Åbergebe Adresse
                PUSH    OFFSET InOutRes         ; eines Dummy-Words
                CALL    DosWrite                ; gebe Fehlertext aus
@@NoRTError:    PUSH    EXIT_PROCESS
                PUSH    ExitCode
                CALL    DosExit
Terminate       ENDP

                ;
                ; FÅhre Exit-Prozeduren aus.
                ;

                PUBLIC  DoExitProcs
DoExitProcs     PROC    NEAR
                LES     BX,ExitProc             ; lese Zeiger auf zuletzt eingehÑngte Exit-Prozedur
                MOV     AX,ES                   ; ist Åberhaupt eine
                OR      AX,BX                   ; Exit-Prozedur definiert ?
                JE      @@End                   ; nein -> Ende
                XOR     AX,AX                   ; lîsche diese 
                MOV     ExitProc.offs,AX        ; Exit-Prozedur
                MOV     ExitProc.segm,AX        ; aus der Kette
                MOV     InOutRes,AX             ; setze I/O-Fehler zurÅck
                MOV     AX,OFFSET DoExitProcs   ; speichere Adresse dieser Routine 
                PUSH    CS                      ; auf dem Stack als RÅcksprungadresse
                PUSH    AX                      ; nach der Exit-Prozedur
                PUSH    ES                      ; fÅhre die
                PUSH    BX                      ; Exit-Prozedur aus
                RETF                            ; (JMP ES:BX)

@@End:          RET
DoExitProcs     ENDP

                ;
                ; Wandle die in AX Åbergebene Zahl in ASCII-String.
                ; Die Zahlenbasis ist in CX, das Buffer-Ende in DS:BX.
                ;

Num2Str         PROC    NEAR    
                XOR     DX,DX                   ; setze HiWord des Dividend auf 0
                DIV     CX                      ; spalte rechte Ziffer ab
                ADD     DL,'0'                  ; wandle Ziffer nach ASCII
                CMP     DL,'0'+10               ; falls > '9'
                JB      @@DigitOk               ; wandle
                ADD     DL,'A'-'0'-10           ; in Hex-Ziffer
@@DigitOk:      DEC     BX                      ; speichere Ziffer
                MOV     [BX],DL                 ; in Buffer
                OR      AX,AX                   ; ist Zahl ganz gewandelt ?
                JNE     Num2Str                 ; nein -> zurÅck und weitermachen
                RET
Num2Str         ENDP

                ;
                ; Copyright.
                ;

Copyright       DB      'Portions Copyright (c) 1983,92 Borland',13,10
                DB      'Portions 1993 by Matthias Withopf / c''t',13,10,0

CODE            ENDS

                END
