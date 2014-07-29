;//////////////////////////////////////////////////////
;/                                                    /
;/ Run-time Library fÅr Borland Pascal 7.0 unter OS/2 /
;/ Startup-Routine fÅr OS/2-DLLs.                     /
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
                EXTRN   ExitCode:WORD,HeapAllocFlags:WORD,Test8086:BYTE
                EXTRN   Input:BYTE,Output:BYTE,SelectorInc:WORD
DATA            ENDS

CODE            SEGMENT BYTE PUBLIC
                ASSUME  CS:CODE,DS:DATA
                EXTRN   DoExitProcs:NEAR,Check8086:NEAR

                ;
                ; Startup-Code fÅr OS/2-DLLS.
                ;

                PUBLIC  LibEntry
LibEntry        PROC    FAR
                CALL    Check8086               ; bestimme Prozessortyp
                MOV     HeapAllocFlags,SEG_GIVEABLE ; setze Heap-Allozierungsflags
                PUSH    DS                      ; erfrage
                PUSH    OFFSET SelectorInc      ; den Wert
                CALL    DosGetHugeShift         ; fÅr AHugeShift
                MOV     AX,1                    ; berechne
                MOV     CX,SelectorInc          ; daraus den
                SHL     AX,CL                   ; SelectorInc-Wert
                MOV     SelectorInc,AX          ; (SelectorInc := 1 Shl AHugeShift)
                MOV     ExitCode,1              ; standardmÑ·iger Exit-Code ist 1
                RET
LibEntry        ENDP

                ;
                ; Beende OS/2-DLL.
                ;

                PUBLIC  LibExit
LibExit         PROC    FAR
                POP     AX                      ; lîsche RÅcksprungadresse
                POP     AX                      ; vom Stack
                MOV     AX,ExitCode             ; lese Fehlercode
                RET                             ; zurÅck zu OS/2
LibExit         ENDP

                ;
                ; Exit-Prozedur der DLL (WEP).
                ;

                PUBLIC  LibExitProc
LibExitProc     PROC    FAR
                ARG     A_ExitCode : WORD
                MOV     AX,DS                   ; Prolog fÅr
                NOP                             ; exportierte Funktion
                PUSH    BP                      
                MOV     BP,SP
                PUSH    DS                      ; rette Datensegment
                PUSH    SI                      ; rette Register
                PUSH    DI                      ; auf Stack
                MOV     DS,AX                   ; setze Datensegment der DLL
                MOV     AX,A_ExitCode           ; lese ExitCode
                MOV     ExitCode,AX             ; speichern
                CALL    DoExitProcs             ; fÅhre Exit-Prozeduren aus
                MOV     AX,1                    ; setze Flag fÅr ok
                POP     DI                      ; hole Register
                POP     SI                      ; vom Stack
                POP     DS                      ; hole Datensegment zurÅck
                POP     BP
                RET
LibExitProc     ENDP

CODE            ENDS

                END
