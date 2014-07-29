{| Unit: PmSpl
 | Version: 1.00
 | translated from file PmSpl.H
 | Original translation: Peter Sawatzki (ps)
 | Contributing:
 |   (fill in)
 |
 | change history:
 | Date:    Ver: Author:
 | 11/23/93 1.00 ps     original translation by ps
}
Unit PmSpl;
Interface
Uses
  Os2Def,
  BseDos;
{**************************************************************************\
*
* OS/2 Presentation Manager Spooler constants, types and function declarations
*
\**************************************************************************}
Const

{ Names of various OS2SYS.INI spooler variables }

  SPL_INI_SPOOLER       = 'PM_SPOOLER';
  SPL_INI_QUEUE         = 'PM_SPOOLER_QUEUE';
  SPL_INI_PRINTER       = 'PM_SPOOLER_PRINTER';
  SPL_INI_PRINTERDESCR  = 'PM_SPOOLER_PRINTER_DESCR';
  SPL_INI_QUEUEDESCR    = 'PM_SPOOLER_QUEUE_DESCR';
  SPL_INI_QUEUEDD       = 'PM_SPOOLER_QUEUE_DD';
  SPL_INI_QUEUEDDDATA   = 'PM_SPOOLER_QUEUE_DDDATA';

{ General SPL return values }
  SPL_ERROR             = 0;
  SPL_OK                = 1;

Type
{ handle to a spool file }
  HSPL = LHANDLE;               { hspl }
{ Used in recording of PM_Q_STD data via SplStdxxx calls }
  HSTD = LHANDLE;               { hstd }
  pHSTD = ^HSTD;
{ spooler manager open data }
  pQMOPENDATA = ^PSZ;       { pqmdop }

{** Spooler Queue manager Interface }
  Function SplQmOpen (Par1: PSZ; Par2: LONG; Par3: PQMOPENDATA): HSPL;
  Function SplQmStartDoc (Par1: HSPL; Par2: PSZ): BOOL;
  Function SplQmWrite (Par1: HSPL; Par2: LONG;Par3: PBYTE): BOOL;
  Function SplQmEndDoc (Par1: HSPL): BOOL;
  Function SplQmClose (Par1: HSPL): BOOL;
  Function SplQmAbort (Par1: HSPL): BOOL;
  Function SplQmAbortDoc (Par1: HSPL): BOOL;

{** Direct Device File System Interface }
  Function PrtOpen (Par1: PSZ; Var Par2, Par3: USHORT; Par4: ULONG; Par5: USHORT;
                    Par6, Par7: USHORT; Par8: ULONG): USHORT;
  Function PrtClose (hFile: HFILE): USHORT;
  Function PrtWrite (hFile: HFILE; Par2: PCH; Par3: USHORT; Var Par4: USHORT): USHORT;
  Function PrtDevIOCtl (Par1, Par2: Pointer; Par3, Par4: USHORT; hFile: HFILE): USHORT;
  Procedure PrtAbort (hFile: HFILE);

{** Spooler Queue Processor interface }

  Function SplQpQueryDt (Var Par1: LONG; Var Par2: PSZ): BOOL;
  Function SplQpInstall (hWnd: HWND): BOOL;

{ Style for SplMessageBox }
{ Same as for WinMsgBox see PMWIN.H for details }

{** Spooler message interface }
  Function SplMessageBox (Par1: PSZ; Par2, Par3: USHORT; Par4, Par5: PSZ; Par6, Par7: USHORT): USHORT;

{** PM_Q_STD datatype functions }
  Function SplStdOpen (hDC: HDC): BOOL;
  Function SplStdClose (hDC: HDC): BOOL;
  Function SplStdStart (hDC: HDC): BOOL;
  Function SplStdStop (hDC: HDC): HSTD;
  Function SplStdDelete (hSTD: HSTD): BOOL;
  Function SplStdGetBits (hSTD: HSTD; Long1, Long2: LONG; Par4: PCH): BOOL;
  Function SplStdQueryLength (hSTD: HSTD): LongInt;

{ Error information and return codes
** ==================================
}
{ Error information for SplMessageBox }

Const
  SPLINFO_QPERROR         =  $0001;
  SPLINFO_DDERROR                  =  $0002;
  SPLINFO_SPLERROR                 =  $0004;
  SPLINFO_OTHERERROR               =  $0080;
  SPLINFO_INFORMATION              =  $0100;                { @P3C }
  SPLINFO_WARNING                  =  $0200;                { @P3C }
  SPLINFO_ERROR                    =  $0400;                { @P3C }
  SPLINFO_SEVERE                   =  $0800;                { @P3C }
  SPLINFO_USERINTREQD              =  $1000;

{ Error Data for SplMessageBox }
  SPLDATA_PRINTERJAM               =  $0001;
  SPLDATA_FORMCHGREQD              =  $0002;
  SPLDATA_CARTCHGREQD              =  $0004;
  SPLDATA_PENCHGREQD               =  $0008;
  SPLDATA_DATAERROR                =  $0010;
  SPLDATA_UNEXPECTERROR            =  $0020;
  SPLDATA_OTHER                    =  $8000;

{ return code for SplStdQueryLength }
  SSQL_ERROR                       = (-1 );


{ length for character arrays in structures}
  CNLEN                            = 15;                    { Computer name length      }
  UNLEN                            = 20;                    { Maximum user name length  }
  QNLEN                            = 12;                    { Queue name maximum length }
  PDLEN                            = 8;                     { Print destination length  }
  DTLEN                            = 9;                     { Spool file data type      }
                                            { e.g. PM_Q_STD,PM_Q_RAW    }
  QP_DATATYPE_SIZE                 = 15;                    { returned by SplQpQueryDt  }
  DRIV_DEVICENAME_SIZE             = 31;                    { see DRIVDATA struc        }
  DRIV_NAME_SIZE                   = 8;                     { name of device driver     }
  PRINTERNAME_SIZE                 = 32;                    { max printer name length   }
  FORMNAME_SIZE                    = 31;                    { max form name length      }
  MAXCOMMENTSZ                     = 48;                    { queue comment length      }

  DEFAULT_LM_PROC = 'LMPRINT';

Type
  SPLERR = Word;    { err }

  PRJINFO = Record                      { prj1 }
    uJobId: USHORT;
    szUserName: Array[0..UNLEN] Of Char;
    pad_1,
    szNotifyName: Array[0..CNLEN] Of Char;
    szDataType: Array[0..DTLEN] Of Char;
    pszParms: PSZ;
    uPosition,
    fsStatus: USHORT;
    pszStatus: PSZ;
    ulSubmitted,
    ulSize: ULONG;
    pszComment: PSZ
  End;
  pPRJINFO = ^PPRJINFO;
  npPRJINFO = ^PPRJINFO; {-CANT-}

  PRJINFO2 = Record                     { prj2 }
    uJobId,
    uPriority: USHORT;
    pszUserName: PSZ;
    uPosition,
    fsStatus: USHORT;
    ulSubmitted,
    ulSize: ULONG;
    pszComment,
    pszDocument: PSZ
  End;
  pPRJINFO2 = ^PRJINFO2;
  npPRJINFO2 = ^PRJINFO2; {-CANT-}

  PRJINFO3 = Record                     { prj }
    uJobId,
    uPriority: USHORT;
    pszUserName: PSZ;
    uPosition,
    fsStatus: USHORT;
    ulSubmitted,
    ulSize: ULONG;
    pszComment,
    pszDocument,
    pszNotifyName,
    pszDataType,
    pszParms,
    pszStatus,
    pszQueue,
    pszQProcName,
    pszQProcParms,
    pszDriverName: PSZ;
    pDriverData: PDRIVDATA;
    pszPrinterName: PSZ
  End;
  pPRJINFO3 = ^PRJINFO3;
  npPRJINFO3 = ^PRJINFO3; {-CANT-}


  PRDINFO = Record                      { prd1 }
    szName: Array[0..PDLEN] Of Char;
    szUserName: Array[0..UNLEN] Of Char;
    uJobId,
    fsStatus: USHORT;
    pszStatus: PSZ;
    time: USHORT
  End;
  pPRDINFO = ^PRDINFO;
  npPRDINFO = ^PRDINFO; {-CANT-}

  PRDINFO3 = Record                     { prd }
    pszPrinterName,
    pszUserName,
    pszLogAddr: PSZ;
    uJobId,
    fsStatus: USHORT;
    pszStatus,
    pszComment,
    pszDrivers: PSZ;
    time,
    usTimeOut: USHORT
  End;
  pPRDINFO3 = ^PRDINFO3;
  npPRDINFO3 = ^PRDINFO3; {-CANT-}


  PRQINFO = Record                      { prq1 }
    szName: Array[0..QNLEN] Of Char;
    pad_1: Char;
    uPriority,
    uStartTime,
    uUntilTime: USHORT;
    pszSepFile,
    pszPrProc,
    pszDestinations,
    pszParms,
    pszComment: PSZ;
    fsStatus,
    cJobs: USHORT
  End;
  pPRQINFO  = ^PRQINFO;
  npPRQINFO  = ^PRQINFO;  {-CANT-}


  PRQINFO3 = Record                     { prq }
    pszName: PSZ;
    uPriority,
    uStartTime,
    uUntilTime,
    pad1: USHORT;
    pszSepFile,
    pszPrProc,
    pszParms,
    pszComment: PSZ;
    fsStatus,
    cJobs: USHORT;
    pszPrinters,
    pszDriverName: PSZ;
    pDriverData: PDRIVDATA
  End;
  pPRQINFO3 = ^PRQINFO3;
  npPRQINFO3 = ^PRQINFO3; {-CANT-}


{
 * structure for DosPrintJobGetId
 }
  PRIDINFO = Record                     { prjid }
    uJobId: USHORT;
    szServer: Array[0..CNLEN] Of Char;
    szQName: Array[0..QNLEN] Of Char;
    pad_1: Char
  End;
  pPRIDINFO = ^PRIDINFO;
  npPRIDINFO = ^PRIDINFO; {-CANT-}


{***************************************************************
 *                                                              *
 *              Function prototypes                             *
 *                                                              *
 ***************************************************************}

  Function DosPrintDestEnum (pszServer: PSZ;uLevel: USHORT;pbBuf: PBYTE;cbBuf: USHORT;pcReturned,
                             pcTotal: PUSHORT): SPLERR;

  Function DosPrintDestControl (pszServer,pszDevName: PSZ;uControl: USHORT): SPLERR;

  Function DosPrintDestGetInfo (pszServer,pszName: PSZ;uLevel: USHORT;pbBuf: PBYTE;cbBuf: USHORT;
                                pcbNeeded: PUSHORT): SPLERR;

  Function DosPrintDestAdd (pszServer: PSZ;uLevel: USHORT;pbBuf: PBYTE;cbBuf: USHORT): SPLERR;

  Function DosPrintDestSetInfo (pszServer,pszName: PSZ;uLevel: USHORT;pbBuf: PBYTE;cbBuf,uParmNum: USHORT): SPLERR;

  Function DosPrintDestDel (pszServer,pszPrinterName: PSZ): SPLERR;

  Function DosPrintQEnum (pszServer: PSZ;uLevel: USHORT;pbBuf: PBYTE;cbBuf: USHORT;pcReturned,
                          pcTotal: PUSHORT): SPLERR;

  Function DosPrintQGetInfo (pszServer,pszQueueName: PSZ;uLevel: USHORT;pbBuf: PBYTE;cbBuf: USHORT;
                             pcbNeeded: PUSHORT): SPLERR;

  Function DosPrintQSetInfo (pszServer,pszQueueName: PSZ;uLevel: USHORT;pbBuf: PBYTE;cbBuf,
                             uParmNum: USHORT): SPLERR;

  Function DosPrintQPause (pszServer,pszQueueName: PSZ): SPLERR;

  Function DosPrintQContinue (pszServer,pszQueueName: PSZ): SPLERR;

  Function DosPrintQPurge (pszServer,pszQueueName: PSZ): SPLERR;

  Function DosPrintQAdd (pszServer: PSZ;uLevel: USHORT;pbBuf: PBYTE;cbBuf: USHORT): SPLERR;

  Function DosPrintQDel (pszServer,pszQueueName: PSZ): SPLERR;

  Function DosPrintJobGetInfo (pszServer: PSZ;uJobId,uLevel: USHORT;pbBuf: PBYTE;cbBuf: USHORT;
                               pcbNeeded: PUSHORT): SPLERR;

  Function DosPrintJobSetInfo (pszServer: PSZ;uJobId,uLevel: USHORT;pbBuf: PBYTE;cbBuf,uParmNum: USHORT): SPLERR;

  Function DosPrintJobPause (pszServer: PSZ;uJobId: USHORT): SPLERR;

  Function DosPrintJobContinue (pszServer: PSZ;uJobId: USHORT): SPLERR;

  Function DosPrintJobDel (pszServer: PSZ;uJobId: USHORT): SPLERR;

  Function DosPrintJobEnum (pszServer,pszQueueName: PSZ;uLevel: USHORT;pbBuf: PBYTE;cbBuf: USHORT;
                            pcReturned,pcTotal: PUSHORT): SPLERR;

  Function DosPrintJobGetId (hFile: HFILE;pInfo: PPRIDINFO;cbInfo: USHORT): SPLERR;

{
 *      Values for parmnum in DosPrintQSetInfo.
 }


Const
  PRQ_PRIORITY_PARMNUM    = 2;
  PRQ_STARTTIME_PARMNUM            = 3;
  PRQ_UNTILTIME_PARMNUM            = 4;
  PRQ_SEPARATOR_PARMNUM            = 5;
  PRQ_PROCESSOR_PARMNUM            = 6;
  PRQ_DESTINATIONS_PARMNUM         = 7;
  PRQ_PARMS_PARMNUM                = 8;
  PRQ_COMMENT_PARMNUM              = 9;
  PRQ_PRINTERS_PARMNUM             = 12;
  PRQ_DRIVERNAME_PARMNUM           = 13;
  PRQ_DRIVERDATA_PARMNUM           = 14;
  PRQ_MAXPARMNUM                   = 14;

{
 *      Print Queue Priority
 }

  PRQ_MAX_PRIORITY                 = 1;                     { highest priority }
  PRQ_DEF_PRIORITY                 = 5;
  PRQ_MIN_PRIORITY                 = 9;                     { lowest priority }
  PRQ_NO_PRIORITY                  = 0;

{
 *      Print queue status bitmask and values for level 1
 }

  PRQ_STATUS_MASK                  = 3;
  PRQ_ACTIVE                       = 0;
  PRQ_PAUSED                       = 1;
  PRQ_ERROR                        = 2;
  PRQ_PENDING                      = 3;

{
 *      Print queue status bits for level 3
 }

  PRQ3_PAUSED                      =  $1;
  PRQ3_PENDING                     =  $2;

{
 *      Values for parmnum in DosPrintJobSetInfo.
 }

  PRJ_NOTIFYNAME_PARMNUM           = 3;
  PRJ_DATATYPE_PARMNUM             = 4;
  PRJ_PARMS_PARMNUM                = 5;
  PRJ_POSITION_PARMNUM             = 6;
  PRJ_COMMENT_PARMNUM              = 11;
  PRJ_DOCUMENT_PARMNUM             = 12;
  PRJ_PRIORITY_PARMNUM             = 14;
  PRJ_PROCPARMS_PARMNUM            = 16;
  PRJ_DRIVERDATA_PARMNUM           = 18;
  PRJ_MAXPARMNUM                   = 18;

{
 *      Bitmap masks for status field of PRJINFO.
 }

{ 2-7 bits also used in device status }

  PRJ_QSTATUS                      =  $0003;                { Bits 0,1 }
  PRJ_DEVSTATUS                    =  $0ffc;                { 2-11 bits }
  PRJ_COMPLETE                     =  $0004;                {  Bit 2   }
  PRJ_INTERV                       =  $0008;                {  Bit 3   }
  PRJ_ERROR                        =  $0010;                {  Bit 4   }
  PRJ_DESTOFFLINE                  =  $0020;                {  Bit 5   }
  PRJ_DESTPAUSED                   =  $0040;                {  Bit 6   }
  PRJ_NOTIFY                       =  $0080;                {  Bit 7   }
  PRJ_DESTNOPAPER                  =  $0100;                {  Bit 8   }
  PRJ_DESTFORMCHG                  =  $0200;                { BIT 9 }
  PRJ_DESTCRTCHG                   =  $0400;                { BIT 10 }
  PRJ_DESTPENCHG                   =  $0800;                { BIT 11 }
  PRJ_DELETED                      =  $8000;                { Bit 15   }

{
 *      Values of PRJ_QSTATUS bits in fsStatus field of PRJINFO.
 }

  PRJ_QS_QUEUED                    = 0;
  PRJ_QS_PAUSED                    = 1;
  PRJ_QS_SPOOLING                  = 2;
  PRJ_QS_PRINTING                  = 3;

{
 *      Print Job Priority
 }

  PRJ_MAX_PRIORITY                 = 99;                    { lowest priority }
  PRJ_MIN_PRIORITY                 = 1;                     { highest priority }
  PRJ_NO_PRIORITY                  = 0;


{
 *      Bitmap masks for status field of PRDINFO.
 *      see PRJ_... for bits 2-11
 }

  PRD_STATUS_MASK                  =  $0003;                { Bits 0,1 }
  PRD_DEVSTATUS                    =  $0ffc;                { 2-11 bits }

{
 *      Values of PRD_STATUS_MASK bits in fsStatus field of PRDINFO.
 }

  PRD_ACTIVE                       = 0;
  PRD_PAUSED                       = 1;

{
 *      Control codes used in DosPrintDestControl.
 }

  PRD_DELETE                       = 0;
  PRD_PAUSE                        = 1;
  PRD_CONT                         = 2;
  PRD_RESTART                      = 3;

{
 *      Values for parmnum in DosPrintDestSetInfo.
 }

  PRD_LOGADDR_PARMNUM              = 3;
  PRD_COMMENT_PARMNUM              = 7;
  PRD_DRIVERS_PARMNUM              = 8;
  PRD_TIMEOUT_PARMNUM              = 10;

Implementation
  Function DosPrintDestAdd;               External 'PMSPL'    Index  101;
  Function DosPrintDestControl;           External 'PMSPL'    Index   80;
  Function DosPrintDestDel;               External 'PMSPL'    Index  103;
  Function DosPrintDestEnum;              External 'PMSPL'    Index   82;
  Function DosPrintDestGetInfo;           External 'PMSPL'    Index   81;
  Function DosPrintDestSetInfo;           External 'PMSPL'    Index  102;
  Function DosPrintJobContinue;           External 'PMSPL'    Index   84;
  Function DosPrintJobDel;                External 'PMSPL'    Index   86;
  Function DosPrintJobEnum;               External 'PMSPL'    Index   92;
  Function DosPrintJobGetId;              External 'PMSPL'    Index  105;
  Function DosPrintJobGetInfo;            External 'PMSPL'    Index   90;
  Function DosPrintJobPause;              External 'PMSPL'    Index   85;
  Function DosPrintJobSetInfo;            External 'PMSPL'    Index   91;
  Function DosPrintQAdd;                  External 'PMSPL'    Index   93;
  Function DosPrintQContinue;             External 'PMSPL'    Index   95;
  Function DosPrintQDel;                  External 'PMSPL'    Index   96;
  Function DosPrintQEnum;                 External 'PMSPL'    Index   99;
  Function DosPrintQGetInfo;              External 'PMSPL'    Index   97;
  Function DosPrintQPause;                External 'PMSPL'    Index   94;
  Function DosPrintQPurge;                External 'PMSPL'    Index  104;
  Function DosPrintQSetInfo;              External 'PMSPL'    Index   98;
  Procedure PrtAbort;                     External 'PMSPL'    Index   75;
  Function PrtClose;                      External 'PMSPL'    Index   73;
  Function PrtDevIOCtl;                   External 'PMSPL'    Index   72;
  Function PrtOpen;                       External 'PMSPL'    Index   70;
  Function PrtWrite;                      External 'PMSPL'    Index   71;
  Function SplMessageBox;                 External 'PMSPL'    Index    7;
  Function SplQmAbort;                    External 'PMSPL'    Index    5;
  Function SplQmAbortDoc;                 External 'PMSPL'    Index    8;
  Function SplQmClose;                    External 'PMSPL'    Index    6;
  Function SplQmEndDoc;                   External 'PMSPL'    Index    3;
  Function SplQmOpen;                     External 'PMSPL'    Index    1;
  Function SplQmStartDoc;                 External 'PMSPL'    Index    2;
  Function SplQmWrite;                    External 'PMSPL'    Index    4;
  Function SplQpInstall; Begin UnKnown('SplQpInstall','PmSpl') End;
  Function SplQpQueryDt; Begin UnKnown('SplQpQueryDt','PmSpl') End;
  Function SplStdClose;                   External 'PMSPL'    Index   51;
  Function SplStdDelete;                  External 'PMSPL'    Index   54;
  Function SplStdGetBits;                 External 'PMSPL'    Index   55;
  Function SplStdOpen;                    External 'PMSPL'    Index   50;
  Function SplStdQueryLength;             External 'PMSPL'    Index   56;
  Function SplStdStart;                   External 'PMSPL'    Index   52;
  Function SplStdStop;                    External 'PMSPL'    Index   53;
End.
