                ;
                ; OS/2-Funktionen.
                ;

EXIT_THREAD     EQU    0
EXIT_PROCESS    EQU    1
                EXTRN  DosExit         : FAR
                
                EXTRN  DosRead         : FAR 
                EXTRN  DosWrite        : FAR 

FILE_OPEN             EQU    1
FILE_TRUNCATE         EQU    2
FILE_CREATE           EQU    10H
FILE_NORMAL           EQU    0
OPEN_ACCESS_READONLY  EQU    0
OPEN_ACCESS_READWRITE EQU    2
OPEN_SHARE_DENYNONE   EQU    40H
                EXTRN  DosOpen         : FAR 

FILE_BEGIN      EQU    0
FILE_CURRENT    EQU    1
FILE_END        EQU    2
                EXTRN  DosChgFilePtr   : FAR 

                EXTRN  DosClose        : FAR

HANDTYPE_FILE   EQU    0
HANDTYPE_DEVICE EQU    1
HANDTYPE_PIPE   EQU    2
HANDTYPE_NETWORK EQU   80H
                EXTRN  DosQHandType    : FAR

                EXTRN  DosNewSize      : FAR
                EXTRN  DosGetEnv       : FAR

VECTOR_DIVIDE_BY_ZERO   EQU  0
VECTOR_OVERFLOW         EQU  4
VECTOR_OUTOFBOUNDS      EQU  5
VECTOR_INVALIDOPCODE    EQU  6
VECTOR_NO_EXTENSION     EQU  7
VECTOR_EXTENSION_ERROR  EQU  10H
                EXTRN  DosSetVec       : FAR

                EXTRN  DosQCurDisk     : FAR
                EXTRN  DosQCurDir      : FAR
                EXTRN  DosSelectDisk   : FAR
                EXTRN  DosChDir        : FAR
                EXTRN  DosMkDir        : FAR
                EXTRN  DosRmDir        : FAR
                EXTRN  DosDelete       : FAR
                EXTRN  DosMove         : FAR

SEG_NONSHARED          EQU 0
SEG_GIVEABLE           EQU 1
SEG_GETTABLE           EQU 2
SEG_DISCARDABLE        EQU 4
                EXTRN  DosAllocSeg     : FAR
                EXTRN  DosFreeSeg      : FAR
                EXTRN  DosMemAvail     : FAR

DATETIME        STRUC
                hours         DB  ?
                minutes       DB  ?
                seconds       DB  ?
                hundredths    DB  ?
                day           DB  ?
                month         DB  ?
                year          DW  ?
                timezone      DW  ?
                weekday       DB  ?
DATETIME        ENDS
                EXTRN   DosGetDateTime  : FAR
                
                EXTRN   DosGetHugeShift : FAR
