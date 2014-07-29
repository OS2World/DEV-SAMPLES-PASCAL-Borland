;//////////////////////////////////////////////////////
;/                                                    /
;/ Run-time Library fr Borland Pascal 7.0 unter OS/2 /
;/ Heap-Memory-Manager.                               /
;/                                                    /
;/ 1993 Matthias Withopf / c't                        /
;/ Originalversion (c) 1988,92 Borland International  /
;/                                                    /
;//////////////////////////////////////////////////////

                .286p                                         

                _NOMACROS_ = 1                  ; keine Macros definieren
                INCLUDE SE.ASM
                INCLUDE OS2.ASM

                ; Header jedes Heap-Segments.

hsSignature     EQU     (WORD PTR 0)
hsReserved      EQU     (WORD PTR 2)
hsFreeList      EQU     (BYTE PTR 4)
hsMemFree       EQU     (WORD PTR 8)
hsNextHeap      EQU     (WORD PTR 10)
hsHeapOrg       EQU     (BYTE PTR 12)

                ; Header jedes Heap-Blocks.

hbNext          EQU     (WORD PTR 0)
hbSize          EQU     (WORD PTR 2)

DATA            SEGMENT WORD PUBLIC
                EXTRN   HeapList:WORD,HeapLimit:WORD,HeapBlock:WORD
                EXTRN   HeapError:DWORD,HeapAllocFlags:WORD

AllocSize       DW      ?       ; Lokale Variable
DATA            ENDS

CODE            SEGMENT BYTE PUBLIC
                ASSUME  CS:CODE,DS:DATA

                EXTRN   HaltError:NEAR

                ;
                ; Procedure New(Var p : Pointer);
                ; Procedure GetMem(Var p : Pointer;Size : Word);
                ;

                PUBLIC  NewPtr
NewPtr          PROC    PASCAL FAR
                ARG     A_Size : WORD
                MOV     AX,A_Size               ; lese Gr”áe des Speicherblocks
                CALL    NewMemory               ; fordere Speicher an
                JC      @@Error                 ; falls nicht gengend Speicher -> Fehler
                RET

@@Error:        LEAVE                           ; verlasse den Stack-Frame
                MOV     AX,203                  ; Fehler: 'Heap overflow error'
                JMP     HaltError
NewPtr          ENDP

                ;
                ; Procedure Dispose(Var p : Pointer);
                ; Procedure FreeMem(Var p : Pointer;Size : Word);
                ;

                PUBLIC  DisposePtr
DisposePtr      PROC    PASCAL FAR
                ARG     A_Ptr  : DWORD, \
                        A_Size : WORD
                MOV     AX,A_Size               ; lese Gr”áe des Speicherblocks
                MOV     CX,A_Ptr.offs           ; lese Zeiger auf den 
                MOV     BX,A_Ptr.segm           ; freizugebenden Speicherblock
                CALL    DisMemory               ; gebe Speicher frei
                JC      MemError                ; falls nicht ok -> Fehler
                RET
DisposePtr      ENDP

                ;
                ; Procedure Mark(Var p : Pointer);
                ; Procedure Release(Var p : Pointer);
                ;

                PUBLIC  MarkPtr
                PUBLIC  ReleasePtr
MarkPtr:
MemError:
ReleasePtr:
                MOV     AX,204                  ; Fehler: 'Invalid pointer operation'
                JMP     HaltError

                ;
                ; Function MemAvail : LongInt;
                ;

                PUBLIC  GetFreMem
GetFreMem       PROC    PASCAL FAR
                LOCAL   L_AvailMem : DWORD
                LEA     BX,L_AvailMem           ; lese Zeiger 
                PUSH    SS                      ; auf Speicher fr
                PUSH    BX                      ; Gr”áe des freien Speichers
                CALL    DosMemAvail             ; erfrage freien Speicher
                MOV     AX,L_AvailMem.offs      ; lese Gr”áe des 
                MOV     DX,L_AvailMem.segm      ; freien Speichers in DX/AX
                MOV     CX,HeapList             ; lese Segment der Heap-Liste
                JCXZ    @@End                   ; falls keine Bl”cke alloziert -> Ende
@@Loop:         MOV     ES,CX                   ; setze Segment des Heap-Segements
                ADD     AX,ES:hsMemFree         ; addiere freier Speicher
                ADC     DX,0                    ; des Heap-Segments
                MOV     CX,ES:hsNextHeap        ; lese Segment des n„chsten Heap-Segments
                CMP     CX,HeapList             ; ist zu Ende ?
                JNE     @@Loop                  ; nein -> zurck und weiter suchen
@@End:          RET
GetFreMem       ENDP

                ;
                ; Function MaxAvail : LongInt;
                ;

                PUBLIC  GetFreMax
GetFreMax       PROC    PASCAL FAR
                LOCAL   L_AvailMem : DWORD
                LEA     BX,L_AvailMem           ; lese Zeiger 
                PUSH    SS                      ; auf Speicher fr
                PUSH    BX                      ; Gr”áe des freien Speichers
                CALL    DosMemAvail             ; erfrage freien Speicher
                MOV     AX,L_AvailMem.offs      ; lese Gr”áe des 
                MOV     DX,L_AvailMem.segm      ; freien Speichers in DX/AX
                OR      DX,DX                   ; mehr als 64K ?
                JNE     @@End                   ; ja -> Ende
                MOV     CX,HeapList             ; lese Segment der Heap-Liste
                JCXZ    @@End                   ; falls keine Bl”cke alloziert -> Ende
@@Loop:         MOV     ES,CX                   ; setze Segment des Heap-Segements
                CMP     AX,ES:hsMemFree         ; falls in diesem Heap-Segment mehr
                JAE     @@LessMem               ; Speicher frei ist als auf OS/2-Heap
                MOV     AX,ES:hsMemFree         ; -> lese freie Speichermenge
@@LessMem:      MOV     CX,ES:hsNextHeap        ; lese Segment des n„chsten Heap-Segments
                CMP     CX,HeapList             ; ist zu Ende ?
                JNE     @@Loop                  ; nein -> zurck und weiter suchen
@@End:          RET
GetFreMax       ENDP

                ;
                ; Alloziere einen Speicherblock, dessen Gr”áe in AX
                ; bergeben wird.
                ; Falls am Ende das Carry-Flag gel”scht ist, enth„lt
                ; DX:AX den Zeiger auf den Speicherblock (oder Nil),
                ; anderenfalls ist ein Fehler aufgetreten.
                ;

                PUBLIC  NewMemory
NewMemory       PROC    NEAR
                OR      AX,AX                   ; soll Block der Gr”áe 0 angefordert werden ?
                JE      @@ReturnNil             ; ja -> gebe Nil zurck
                MOV     AllocSize,AX            ; speichere Blockgr”áe
@@Retry:        CMP     AX,HeapLimit            ; ist es ein 'Small Block' ?
                JB      @@AllocSmall            ; ja -> weiter
                CALL    NewGlobal               ; fordere einen globalen Block an
                JNC     @@End                   ; falls ok -> Ende
                CMP     HeapLimit,0             ; ist 'Sub-Allocation' deaktiviert ?
                JE      @@HeapError             ; ja -> rufe HeapError-Funktion auf
                MOV     AX,AllocSize            ; lese gewnschte Blockgr”áe
                MOV     BX,HeapBlock            ; lese Gr”áe eines globalen Blocks
                SUB     BX,hsHeapOrg
                CMP     AX,BX
                JA      @@HeapError
                CALL    NewHeapMem
                JMP     SHORT @@ChkHeapErr      ; -> teste auf Fehler

                ; Fordere einen 'Small Block' an.

@@AllocSmall:   CALL    NewHeapMem
                JNC     @@End                   ; falls ok -> Ende
                MOV     AX,AllocSize            ; lese gewnschte Blockgr”áe
                CALL    NewGlobal               ; fordere einen globalen Block an
@@ChkHeapErr:   JNC     @@End                   ; falls ok -> Ende
@@HeapError:    MOV     AX,HeapError.offs       ; ist eine
                OR      AX,HeapError.segm       ; HeapError-Funktion definiert ?
                JE      @@NoErrFunc             ; nein -> weiter
                PUSH    AllocSize               ; rufe die HeapError-Funktion mit
                CALL    HeapError               ; der gewnschten Blockgr”áe auf
@@NoErrFunc:    CMP     AX,1                    ; lese Ergebnis der HeapError-Funktion
                MOV     AX,AllocSize            ; lese gewnschte Gr”áe des Blocks
                JA      @@Retry                 ; falls nochmals versuchen -> zurck
                JB      @@End                   ; falls Runtime error -> Ende mit gesetztem Carry
@@ReturnNil:    XOR     AX,AX                   ; lese Nil-Zeiger
                CWD                             ; (0:0) in DX:AX
@@End:          RET
NewMemory       ENDP

                ;
                ; Alloziere einen Block (Gr”áe in AX) auf dem OS/2-Heap.
                ; Falls das Carry gel”scht ist, wird in DX:AX ein 
                ; Zeiger auf den Speicherblock zurckgegeben.
                ;

NewGlobal       PROC    PASCAL NEAR
                LOCAL   L_Sel : WORD
                PUSH    AX                      ; bergebe die gewnschte Gr”áe
                LEA     BX,L_Sel                ; bergebe Zeiger auf 
                PUSH    SS                      ; Speicher fr ein Word,
                PUSH    BX                      ; in dem der Selektor zurckgegeben wird
                PUSH    HeapAllocFlags          ; bergebe Allozierungs-Flags
                CALL    DosAllocSeg             ; fordere Speicher an
                OR      AX,AX                   ; Fehler aufgetreten ?
                JNZ     @@Error                 ; ja -> Fehler
                MOV     DX,L_Sel                ; lese Zeiger auf neuen 
                XOR     AX,AX                   ; Block in DX:AX, Carry gel”scht
                RET

@@Error:        STC                             ; setze Fehlerflag
                RET
NewGlobal       ENDP

                ;
                ; Allocate heap block
                ; In    AX    = Block size
                ; Out   DX:AX = Block pointer
                ;       CF    = 1 if error
                ;

NewHeapMem      PROC    NEAR
                ADD     AX,3                    ; runde gewnschte Blockgr”áe
                AND     AL,0FCH                 ; auf n„chstes Vielfaches von 4 auf
                MOV     CX,HeapList             
                JCXZ    @@2
@@1:            MOV     ES,CX
                CALL    NewBlock
                JNC     @@Ok                    ; falls ok -> gebe Zeiger zurck
                MOV     CX,ES:hsNextHeap
                CMP     CX,HeapList
                JNE     @@1
@@2:            CALL    NewSegment
                JC      @@Exit                  ; falls Fehler -> Ende
                CALL    NewBlock
@@Ok:           MOV     HeapList,ES
                MOV     AX,BX                   ; gebe den Zeiger auf den
                MOV     DX,ES                   ; Block in DX:AX zurck
@@Exit:         RET
NewHeapMem      ENDP

                ;
                ; Allocate heap segment
                ; Out   ES = Heap segment
                ;       CF = 1 if error
                ;

NewSegment      PROC    NEAR
                PUSH    AX                      ; rette Akku
                MOV     AX,HeapBlock            ; lese Gr”áe eines globalen Blocks
                CALL    NewGlobal               ; fordere einen globalen Block an
                JC      @@Error                 ; falls Fehler -> Ende
                MOV     ES,DX                   ; lese Zeiger auf das neue
                XOR     DI,DI                   ; Heap-Segment in ES:DI
                CLD                             ; setze Signatur 
                MOV     AX,'PT'                 ; in 
                STOSW                           ; hsSignature
                XOR     AX,AX                   ; l”sche 
                STOSW                           ; hsReserved
                MOV     AX,hsHeapOrg            
                STOSW                           ; hsFreeList.hbNext
                XOR     AX,AX
                STOSW                           ; hsFreeList.hbSize
                MOV     AX,HeapBlock            ; lese Gr”áe eines globalen Blocks
                SUB     AX,hsHeapOrg
                STOSW                           ; hsMemFree
                PUSH    AX
                MOV     AX,ES
                MOV     CX,HeapList
                JCXZ    @@1
                PUSH    DS
                MOV     DS,CX
                XCHG    AX,DS:hsNextHeap
                POP     DS
@@1:            STOSW                           ; hsNextHeap
                XOR     AX,AX
                STOSW                           ; hbNext
                POP     AX
                STOSW                           ; hbSize
@@Error:        POP     AX
                RET
NewSegment      ENDP

                ;
                ; Allocate block from heap segment
                ; In    AX = Block size
                ;       ES = Heap segment
                ; Out   BX = Block offset
                ;       CF = 1 if error
                ;

NewBlock        PROC    NEAR
                MOV     BX,hsFreeList
@@1:            MOV     SI,BX
                MOV     BX,ES:[BX].hbNext
                CMP     BX,1
                JB      @@Exit
                MOV     DX,ES:[BX].hbSize
                SUB     DX,AX
                JB      @@1
                MOV     CX,ES:[BX].hbNext
                JE      @@2
                MOV     DI,BX
                ADD     DI,AX
                MOV     ES:[DI].hbNext,CX
                MOV     ES:[DI].hbSize,DX
                MOV     CX,DI
@@2:            MOV     ES:[SI].hbNext,CX
                SUB     ES:hsMemFree,AX
                CLC
@@Exit:         RET
NewBlock        ENDP

                ;
                ; Dispose memory
                ; In    AX    = Block size
                ;       BX:CX = Block pointer
                ; Out   CF    = 1 if error
                ;

                PUBLIC  DisMemory
DisMemory       PROC    NEAR
                OR      AX,AX                   ; soll Block der Gr”áe 0 freigegeben werden ?
                JE      @@End                   ; ja -> Ende
                JCXZ    @@FreeGlobal            ; falls globalen Block freigeben -> weiter
                ADD     AX,3                    ; runde Blockgr”áe auf n„chstes
                AND     AL,0FCH                 ; Vielfache von 4 auf
                MOV     ES,BX                   ; lese Zeiger auf freizugebenden 
                MOV     BX,CX                   ; Block in ES:BX
                CMP     ES:hsSignature,'PT'     ; hat der Block gltige Signatur 'TP' ?
                JNE     @@Error                 ; nein -> Fehler
                TEST    BL,3                    ; ist Block auf DWORD-Grenze aligned ?
                JNE     @@Error                 ; nein -> Fehler
                MOV     SI,hsFreeList           ; lese Offset der Frei-Liste
@@1:            MOV     DI,SI                   ; rette Offset
                MOV     SI,ES:[SI].hbNext       ; lese Offset des n„chsten Blocks
                OR      SI,SI                   ; Ende der Liste erreicht ?
                JE      @@2                     ; ja -> weiter
                CMP     BX,SI                   ; ist freizugebender Block gefunden ?
                JA      @@1                     ; nein -> zurck
                JE      @@Error                 
@@2:            MOV     ES:[BX].hbNext,SI
                MOV     ES:[BX].hbSize,AX
                ADD     AX,ES:hsMemFree
                MOV     ES:hsMemFree,AX
                ADD     AX,hsHeapOrg
                CMP     AX,HeapBlock            ; vergleiche mit Gr”áe fr einen globalen Block
                JE      @@7
                CALL    @@3
                MOV     ES:[DI].hbNext,BX
                MOV     BX,DI                   
@@3:            MOV     SI,BX
                ADD     SI,ES:[BX].hbSize
                CMP     SI,ES:[BX].hbNext
                JNE     @@End
                MOV     AX,ES:[SI].hbNext
                MOV     ES:[BX].hbNext,AX
                MOV     AX,ES:[SI].hbSize
                ADD     ES:[BX].hbSize,AX
@@End:          CLC                             ; l”sche Fehlerflag
                RET                             

@@Error:        STC                             ; setze Fehlerflag
                RET

@@FreeGlobal:   MOV     AX,DS                   ; soll Datensegment als Heap-Block
                CMP     AX,BX                   ; freigegeben werden ?
                JE      @@Error                 ; ja -> Fehler
                PUSH    BX                      ; bergebe Selektor des Blocks
                CALL    DosFreeSeg              ; gebe globalen Block frei
                CLC                             ; l”sche Fehlerflag
                RET

@@7:            XOR     AX,AX
                MOV     BX,ES
                MOV     DX,ES:hsNextHeap
                CMP     BX,DX
                JE      @@9
                MOV     AX,HeapList
@@8:            MOV     ES,AX
                MOV     AX,ES:hsNextHeap
                CMP     AX,BX
                JNE     @@8
                MOV     ES:hsNextHeap,DX
                MOV     AX,ES
@@9:            MOV     HeapList,AX
                JMP     @@FreeGlobal            ; -> globalen Block freigeben
DisMemory       ENDP

CODE            ENDS

                END
