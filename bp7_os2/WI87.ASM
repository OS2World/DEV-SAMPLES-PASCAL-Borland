;//////////////////////////////////////////////////////
;/                                                    /
;/ Run-time Library fÅr Borland Pascal 7.0 unter OS/2 /
;/ 80x87-Emulation fÅr OS/2-Programme.                /
;/                                                    /
;/ 1993 Matthias Withopf / c't                        /
;/ Originalversion (c) 1988,92 Borland International  /
;/                                                    /
;//////////////////////////////////////////////////////

                .286p                                         

                CODE	SEGMENT	BYTE PUBLIC
	        ASSUME	CS:CODE

	        PUBLIC	InitEM86,InitEM87
InitEM86        PROC    FAR
InitEM87:       RET
InitEM86        ENDP
CODE	        ENDS

                END
