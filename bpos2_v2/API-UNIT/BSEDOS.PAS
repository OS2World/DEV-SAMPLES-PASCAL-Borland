{| Unit: BseDos
 | Version: 1.00
 | translated from file BseDos.H
 | Original translation: Peter Sawatzki (ps)
 | Contributing:
 |   (fill in)
 |
 | change history:
 | Date:    Ver: Author:
 | 11/13/93 1.00 ps     original translation by ps
}
Unit BseDos;
Interface
Uses
  Os2Def;
{**************************************************************************\
*
* Module Name: BSEDOS.H
*
* OS/2 Base Include File
*
* Copyright
*
\**************************************************************************}

{** General services }

{**   DosBeep - Generates sound from speaker                   }

  Function DosBeep (usFrequency,                            { frequency of sound in Hertz }
                    usDuration: USHORT): USHORT;             { length of sound in milliseconds }

{** Process and Thread support }

{**    DosExit - Exit a program
 *
 *      This call is issued when a thread completes its execution.
 *      The current thread is ended.
 }

  Procedure DosExit (fTerminate,                          { 0=end current thread, 1=end all }
                    usExitCode: USHORT);                  { program completion code         }

{ DosExit codes }

Const
  EXIT_THREAD                      = 0;
  EXIT_PROCESS                     = 1;

{**    _PIDINFO  structure of the address of the area where the
 *      ID's will be placed
 }


Type
  PIDINFO = Record
    pid: PID;                           { current process' process ID }
    tid: TID;                           { current process' thread ID }
    pidParent: PID                      { process ID of the parent }
  End;
  pPIDINFO = ^PIDINFO;

  pFnThread = Procedure;

{**    DosCreateThread - Create another thread of execution
 *
 *      Creates an asynchronous thread of execution under the
 *      current process
 }

  Function DosCreateThread (pfnFun: PFNTHREAD;              { Starting Address for new thread }
                            pTid: PTID;                     { Address to put new thread ID }
                            pbStack: PBYTE): USHORT;                 { Address of stack for new thread }

{**    DosResumeThread - Resume the execution of a thread
 *
 *      This call restarts the execution of a thread
 *      previously stopped by a call to DosSuspendThread.
 }

  Function DosResumeThread (tid: TID): USHORT;                       { Thread ID }


{**    DosSuspendThread - Suspend the execution of a thread
 *
 *      This call temporarily suspends a thread's execution
 *      until a DosResumeThread call is made for that thread ID.
 }

  Function DosSuspendThread (tid: TID): USHORT;                       { Thread ID }

{ Action code values }


Const
  DCWA_PROCESS                     = 0;
  DCWA_PROCESSTREE                 = 1;

{ Wait option values }

  DCWW_WAIT                        = 0;
  DCWW_NOWAIT                      = 1;

{**   _RESULTCODES - structure used by DosExecPgm and DosCWait
 *              First word is Termination code, second word is Exit code.
 *              For DosExecPgm, first word may instead be the Process ID.
 }


Type
  RESULTCODES = Record
    codeTerminate,                      { Termination Code -or- Process ID }
    codeResult: USHORT                  { Exit Code }
  End;
  pRESULTCODES = ^RESULTCODES;


{**    DosCwait - Wait for child termination
 *
 *      Places the current thread in a wait state until a child process
 *      has terminated, then returns the ending process' process ID and
 *      termination code.
 }

  Function DosCwait (fScope,                                { Action (execution) codes }
                     fwait: USHORT;                         { Wait options }
                     prescResults: PRESULTCODES;            { Address to put return codes }
                     ppidProcess: PPID;                     { Address to put process ID }
                     pidWaitProcess: PID): USHORT;            { ProcessID of process to wait for }

{**   DosSleep - Delay Process Execution
 *
 *     Suspends the current thread for a specified time.
 *
 }

  Function DosSleep (ulTime: ULONG): USHORT;         { interval in milliseconds to delay execution }

{ codeTerminate values }


Const
  TC_EXIT                          = 0;
  TC_HARDERROR                     = 1;
  TC_TRAP                          = 2;
  TC_KILLPROCESS                   = 3;

Type
  pFnExitList = Procedure (aShort: USHORT);

{**    DosEnterCritSec - Enter critical section of execution
 *
 *      Disables thread switching for the current process
 }

  Function DosEnterCritSec: USHORT;

{**    DosExitCritSec - Exit critical section of execution
 *
 *      Re-enables thread switching for the current process
 *}

  Function DosExitCritSec: USHORT;

{**    DosExitList - Routine list for process termination
 *
 *      Maintains a list of routines which are to be executed when the
 *      current process ends, normally or otherwise
 }

  Function DosExitList (fFnCode: USHORT;                    { Function request code }
                        pfnFunction: PFNEXITLIST): USHORT;       { Address of routine to be executed }

{ DosExitList functions }


Const
  EXLST_ADD                        = 1;
  EXLST_REMOVE                     = 2;
  EXLST_EXIT                       = 3;

{**    DosExecPgm - Execute a program
 *
 *      Allows a program to request another program be executed as a
 *      child process.  The requestor's process may optionally continue
 *      to execute asynchronous to the new program
 }

  Function DosExecPgm (pchFailName: PCHAR;                  { Object name buffer (address) }
                       cbFailName: SHORT;                   { Object name buffer length }
                       fExecFlag: USHORT;                   { 0=synchronous, 1=asynchronous with }
                                                            { return code discarded, 2=async }
                                                            { with return code saved, 3=trace }
                                                            { 4=asynch detached, 5=loaded but }
                                                            { not executed }
                       pszArgs,                             { Address of argument strings }
                       pszEnv: PSZ;                         { Address of environment strings }
                       prescResults: PRESULTCODES;          { Address to put return codes }
                       pszPgmName: PSZ): USHORT;            { Address of program filename        }

{ DosExecPgm functions }


Const
  EXEC_SYNC                        = 0;
  EXEC_ASYNC                       = 1;
  EXEC_ASYNCRESULT                 = 2;
  EXEC_TRACE                       = 3;
  EXEC_BACKGROUND                  = 4;
  EXEC_LOAD                        = 5;

{**    DosGetPID - Return process ID
 *
 *      Returns the current process's process ID
 *      and the PID of the process that spawned it
 }

  Function DosGetPID (ppidInfo: PPIDINFO): USHORT;             { _PIDINFO structure }


{**   DosGetPPid - Get a process's parent's PID
 *
 *     Allows the caller to obtain the parent process ID for any process
 *
 }

  Function DosGetPPID (pidChild: USHORT;                    { process id of process to find the parent pid }
                       ppidParent: PUSHORT): USHORT;  { where pid will be placed                     }

{**    DosGetPrty - Get Process's Priority
 *
 *      Allows the caller to learn the priority of a process or thread
 }

  Function DosGetPrty (usScope: USHORT;                     { scope the request will have }
                       pusPriority: PUSHORT;                { Address to put priority }
                       pid: USHORT): USHORT;                    { PID of process/thread of interest }

{**    DosSetPrty - Set Process Priority
 *
 *      Allows the caller to change the base priority or priority
 *      class of a child process or a thread in the current process
 }

  Function DosSetPrty (usScope,                             { Indicate scope of change }
                       fPrtyClass: USHORT;                  { Priority class to set }
                       sChange: SHORT;                      { Priority delta to apply }
                       id: USHORT): USHORT;                     { Process or Thread ID of target }

{ Priority scopes }


Const
  PRTYS_PROCESS                    = 0;
  PRTYS_PROCESSTREE                = 1;
  PRTYS_THREAD                     = 2;

{ Priority classes }

  PRTYC_NOCHANGE                   = 0;
  PRTYC_IDLETIME                   = 1;
  PRTYC_REGULAR                    = 2;
  PRTYC_TIMECRITICAL               = 3;
  PRTYC_FOREGROUNDSERVER           = 4;

{ Priority deltas }

  PRTYD_MINIMUM                    = -31;
  PRTYD_MAXIMUM                    = 31;

{**    DosKillProcess - Terminate a Process
 *
 *      Terminates a child process and returns its termination code
 *      to its parent
 }

  Function DosKillProcess (usScope: USHORT;                 { 0=kill child processes also, }{ 1=kill only indicated process }
                           pidProcess: PID): USHORT;                { Process ID of process to end  }


Const
  DKP_PROCESSTREE                  = 0;
  DKP_PROCESS                      = 1;



{** InfoSeg support }


{ Global Info Seg }


Type
  GINFOSEG = Record
    time,                               { time in seconds }
    msecs: ULONG;                       { milliseconds }
    hour,                               { hours }
    minutes,                            { minutes }
    seconds,                            { seconds }
    hundredths: UCHAR;                  { hundredths }
    timezone,                           { minutes from UTC }
    cusecTimerInterval: USHORT;         { timer interval (units = 0.0001 seconds) }
    day,                                { day }
    month: UCHAR;                       { month }
    year: USHORT;                       { year }
    weekday,                            { day of week }
    uchMajorVersion,                    { major version number }
    uchMinorVersion,                    { minor version number }
    chRevisionLetter,                   { revision letter }
    sgCurrent,                          { current foreground session }
    sgMax,                              { maximum number of sessions }
    cHugeShift,                         { shift count for huge elements }
    fProtectModeOnly: UCHAR;            { protect mode only indicator }
    pidForeground: USHORT;              { pid of last process in forground session }
    fDynamicSched,                      { dynamic variation flag }
    csecMaxWait: UCHAR;                 { max wait in seconds }
    cmsecMinSlice,                      { minimum timeslice (milliseconds) }
    cmsecMaxSlice,                      { maximum timeslice (milliseconds) }
    bootdrive: USHORT;                  { drive from which the system was booted }
    amecRAS: Array[0..31] Of UCHAR;     { system trace major code flag bits }
    csgWindowableVioMax,                { maximum number of VIO windowable sessions }
    csgPMMax: UCHAR                     { maximum number of pres. services sessions }
  End;
  pGINFOSEG = ^GINFOSEG;

{ Local Info Seg }

  LINFOSEG = Record
    pidCurrent,                         { current process id }
    pidParent: PID;                     { process id of parent }
    prtyCurrent: USHORT;                { priority of current thread }
    tidCurrent: TID;                    { thread ID of current thread }
    sgCurrent: USHORT;                  { session }
    rfProcStatus,                       { process status }
    dummy1: UCHAR;
    fForeground: BOOL;                  { current process has keyboard focus }
    typeProcess,                        { process type }
    dummy2: UCHAR;
    selEnvironment: SEL;                { environment selector }
    offCmdLine,                         { command line offset }
    cbDataSegment,                      { length of data segment }
    cbStack,                            { stack size }
    cbHeap: USHORT;                     { heap size }
    hmod: HMODULE;                      { module handle of the application }
    selDS: SEL                          { data segment handle of the application }
  End;
  pLINFOSEG = ^LINFOSEG;

{ Process Type codes }


Const
  PT_FULLSCREEN                    = 0;                     { Full screen app.          }
  PT_REALMODE                      = 1;                     { Real mode process         }
  PT_WINDOWABLEVIO                 = 2;                     { VIO windowable app.       }
  PT_PM                            = 3;                     { Presentation Manager app. }
  PT_DETACHED                      = 4;                     { Detached app.             }

{ Process Status Flag definitions

  PS_EXITLIST                      = 1;                     { Thread is in exitlist routine }


{**    DosGetInfoSeg - Get address of system variables segment
 *
 *      Returns the address of a global and process local data segment used to
 *      determine the value of several items of general information.
 *
 }

  Function DosGetInfoSeg (pselGlobal,                       { global segment selector (returned) }
                          pselLocal: PSEL): USHORT;                { local segment selector (returned)  }

{ Helper macros used to convert selector to PINFOSEG or LINFOSEG }




{
 * CCHMAXPATH is the maximum fully qualified path name length including
 * the drive letter, colon, backslashes and terminating NULL.
 }

Const
  CCHMAXPATH                       = 260;

{
 * CCHMAXPATHCOMP is the maximum individual path component name length
 * including a terminating NULL.
 }
  CCHMAXPATHCOMP                   = 256;



{** File manager }



{ DosChgFilePtr

  FILE_BEGIN                       =  $0000;                { Move relative to beginning of file     }
  FILE_CURRENT                     =  $0001;                { Move relative to current fptr position }
  FILE_END                         =  $0002;                { Move relative to end of file           }

{ DosFindFirst/Next Directory handle types }

  HDIR_SYSTEM                      =  $0001;                { Use system handle (1)         }
  HDIR_CREATE                      =  $FFFF;                { Allocate a new, unused handle }

{ DosCopy control bits; may be or'ed together }
  DCPY_EXISTING                    =  $00001;               { Copy even if target exists }
  DCPY_APPEND                      =  $00002;               { Append to existing file,   }
                                        { do not replace             }

{ Dosopen/DosQFHandState/DosQueryFileInfo et al file attributes; also }
{ known as Dso File Mode bits... }

  FILE_NORMAL                      =  $0000;
  FILE_READONLY                    =  $0001;
  FILE_HIDDEN                      =  $0002;
  FILE_SYSTEM                      =  $0004;
  FILE_DIRECTORY                   =  $0010;
  FILE_ARCHIVED                    =  $0020;

{ DosOpen

  FILE_EXISTED                     =  $0001;
  FILE_CREATED                     =  $0002;
  FILE_TRUNCATED                   =  $0003;

{ DosOpen

  FILE_OPEN                        =  $0001;
  FILE_TRUNCATE                    =  $0002;
  FILE_CREATE                      =  $0010;

{     this nibble applies if file already exists                xxxx }

  OPEN_ACTION_FAIL_IF_EXISTS       =  $0000;                { ---- ---- ---- 0000 }
  OPEN_ACTION_OPEN_IF_EXISTS       =  $0001;                { ---- ---- ---- 0001 }
  OPEN_ACTION_REPLACE_IF_EXISTS    =  $0002;                { ---- ---- ---- 0010 }

{     this nibble applies if file does not exist           xxxx      }

  OPEN_ACTION_FAIL_IF_NEW          =  $0000;                { ---- ---- 0000 ---- }
  OPEN_ACTION_CREATE_IF_NEW        =  $0010;                { ---- ---- 0001 ---- }

{ DosOpen/DosSetFHandState flags }

  OPEN_ACCESS_READONLY             =  $0000;                { ---- ---- ---- -000 }
  OPEN_ACCESS_WRITEONLY            =  $0001;                { ---- ---- ---- -001 }
  OPEN_ACCESS_READWRITE            =  $0002;                { ---- ---- ---- -010 }
  OPEN_SHARE_DENYREADWRITE         =  $0010;                { ---- ---- -001 ---- }
  OPEN_SHARE_DENYWRITE             =  $0020;                { ---- ---- -010 ---- }
  OPEN_SHARE_DENYREAD              =  $0030;                { ---- ---- -011 ---- }
  OPEN_SHARE_DENYNONE              =  $0040;                { ---- ---- -100 ---- }
  OPEN_FLAGS_NOINHERIT             =  $0080;                { ---- ---- 1--- ---- }
  OPEN_FLAGS_NO_LOCALITY           =  $0000;                { ---- -000 ---- ---- }
  OPEN_FLAGS_SEQUENTIAL            =  $0100;                { ---- -001 ---- ---- }
  OPEN_FLAGS_RANDOM                =  $0200;                { ---- -010 ---- ---- }
  OPEN_FLAGS_RANDOMSEQUENTIAL      =  $0300;                { ---- -011 ---- ---- }
  OPEN_FLAGS_NO_CACHE              =  $1000;                { ---1 ---- ---- ---- }
  OPEN_FLAGS_FAIL_ON_ERROR         =  $2000;                { --1- ---- ---- ---- }
  OPEN_FLAGS_WRITE_THROUGH         =  $4000;                { -1-- ---- ---- ---- }
  OPEN_FLAGS_DASD                  =  $8000;                { 1--- ---- ---- ---- }


{ DosSearchPath

  SEARCH_PATH                      =  $0000;
  SEARCH_CUR_DIRECTORY             =  $0001;
  SEARCH_ENVIRONMENT               =  $0002;
  SEARCH_IGNORENETERRS             =  $0004;

{***********************************************************
DosFileIO
=========================================
***********************************************************}
{ File IO command words }
  FIO_LOCK                         = 0;                     { Lock Files          }
  FIO_UNLOCK                       = 1;                     { Unlock Files        }
  FIO_SEEK                         = 2;                     { Seek (set file ptr) }
  FIO_READ                         = 3;                     { File Read           }
  FIO_WRITE                        = 4;                     { File Write          }

{ Lock Sharing Modes }
  FIO_NOSHARE                      = 0;                     { None      }
  FIO_SHAREREAD                    = 1;                     { Read-Only }


Type
  FIOLOCKCMD = Record                   { FLC  FileLockCmd prefix }
    usCmd,                              { Cmd = FIO_LOCK }
    cLockCnt: USHORT;                   { Lock records that follow }
    cTimeOut: ULONG                     { in Msec }
  End;
  pFIOLOCKCMD = ^FIOLOCKCMD;


  FIOLOCKREC = Record                   { FLR FileLockRecord              }
    fShare: USHORT;                     { FIO_NOSHARE or FIO_SHAREREAD }
    cbStart,                            { Starting offset for lock region }
    cbLength: ULONG                     { Length of lock region }
  End;
  pFIOLOCKREC = ^FIOLOCKREC;


  FIOUNLOCKCMD = Record                 { FUC FileUnlockCmd prefix   }
    usCmd,                              { Cmd = FIO_UNLOCK }
    cUnlockCnt: USHORT                  { Unlock records that follow }
  End;
  pFIOUNLOCKCMD =^FIOUNLOCKCMD;


  FIOUNLOCKREC = Record                 { FUR FileUnlockRecord              }
    cbStart,                            { Starting offset for unlock region }
    cbLength: ULONG                     { Length of unlock region }
  End;
  pFIOUNLOCKREC =^FIOUNLOCKREC;


  FIOSEEKCMD = Record                   { Seek command structure             }
    usCmd,                              { Cmd = FIO_SEEK }
    fsMethod: USHORT;                   { One of : FPM_BEGINNING, }{ FPM_CURRENT,or FPM_END }
    cbDistance,                         { Byte offset for seek }
    cbNewPosition: ULONG                { Bytes from start of file after }{ seek }
  End;
  pFIOSEEKCMD = ^FIOSEEKCMD;


  FIOREADWRITE = Record                 { RWC Read&Write command structure }
    usCmd: USHORT;                      { Cmd = FIO_READ or FIO_WRITE }
    pbBuffer: PVOID;                    { Pointer to data buffer }
    cbBufferLen,                        { Bytes in buffer or max size }
    cbActualLen: USHORT                 { Bytes actually read/written }
  End;
  pFIOREADWRITE =^FIOREADWRITE;


{***********************************************************
EA Info Levels & Find First/Next
=========================================
API's: DosFindFirst, DosQueryFileInfo, DosQueryPathInfo, DosSetFileInfo,
       DosSetPathInfo
***********************************************************}

{ File info levels: All listed API's }

Const
  FIL_STANDARD                     = 1;                     { Info level 1, standard file info }
  FIL_QUERYEASIZE                  = 2;                     { Level 2, return Full EA size     }
  FIL_QUERYEASFROMLIST             = 3;                     { Level 3, return requested EA's   }

{ File info levels: Dos...PathInfo only }
  FIL_QUERYFULLNAME                = 5;                     { Level 5, return fully qualified  }
                                        { name of file                     }
  FIL_NAMEISVALID                  = 6;                     { Level 6, check validity of file/path
                                           name for this FSD                }



{ DosFindNotifyFirst
  FNOTIL_STANDARD                  = 1;                     { Find-Notify Info level 1: Return
                                   standard directory change info }


{ DosFsAttach
{ Attact or detach }
  FSATTACH                         = 0;                     { Attach file server }
  FSDETACH                         = 1;                     { Detach file server }


{ DosFsCtl
{ Routing type }
  FSCTL_HANDLE                     = 1;                     { File Handle directs req routing }
  FSCTL_PATHNAME                   = 2;                     { Path Name directs req routing   }
  FSCTL_FSDNAME                    = 3;                     { FSD Name directs req routing    }


{ DosQueryFSAttach
{ Information level types
  FSAIL_QUERYNAME                  = 1;                     { Return data for a Drive or Device }
  FSAIL_DEVNUMBER                  = 2;                     { Return data for Ordinal Device #  }
  FSAIL_DRVNUMBER                  = 3;                     { Return data for Ordinal Drive #   }

{ Item types
  FSAT_CHARDEV                     = 1;                     { Resident character device    }
  FSAT_PSEUDODEV                   = 2;                     { Pusedu-character device      }
  FSAT_LOCALDRV                    = 3;                     { Local drive                  }
  FSAT_REMOTEDRV                   = 4;                     { Remote drive attached to FSD }


Type
  FSQBUFFER = Record                    { Data structure for QFSAttach       }
    iType,                              { Item type }
    cbName: USHORT;                     { Length of item name, sans NULL }
    szName: Array[0..0] Of UCHAR;       { ASCIIZ item name }
    cbFSDName: USHORT;                  { Length of FSD name, sans NULL }
    szFSDName: Array[0..0] Of UCHAR;    { ASCIIZ FSD name }
    cbFSAData: USHORT;                  { Length of FSD Attach data returned }
    rgFSAData: Array[0..0] Of UCHAR     { FSD Attach data from FSD }
  End;
  pFSQBUFFER = ^FSQBUFFER;


{**********
File System Drive Information&gml DosQueryFSInfo DosSetFSInfo
**********}

{ FS Drive Info Levels }

Const
  FSIL_ALLOC                       = 1;                     { Drive allocation info (Query only) }
  FSIL_VOLSER                      = 2;                     { Drive Volum/Serial info            }

{ DosQueryFHType }
{ Handle classes }
  FHT_DISKFILE                     =  $0000;                { Disk file handle        }
  FHT_CHRDEV                       =  $0001;                { Character device handle }
  FHT_PIPE                         =  $0002;                { Pipe handle             }

{ Handle bits }
  FHB_DSKREMOTE                    =  $8000;                { Remote disk             }
  FHB_CHRDEVREMOTE                 =  $8000;                { Remote character device }
  FHB_PIPEREMOTE                   =  $8000;                { Remote pipe             }

Type
  HFILE = SHANDLE;      { hf }
  pHFILE = ^HFILE;


{ File time and date types }

Type
  FTIME = Word;
    {[0..4]: twosecs;
     [5..10]: minutes;
     [11..15]: hours; }
  pFTIME = ^FTIME;

  FDATE = Word;
    {[0..4]: day;
     [5..8]: month;
     [9..15]: year; }
  pFDATE = ^FDATE;

  FILEFINDBUF = Record                  { findbuf }
    fdateCreation: FDATE;
    ftimeCreation: FTIME;
    fdateLastAccess: FDATE;
    ftimeLastAccess: FTIME;
    fdateLastWrite: FDATE;
    ftimeLastWrite: FTIME;
    cbFile,
    cbFileAlloc: ULONG;
    attrFile: USHORT;
    cchName: UCHAR;
    achName: Array[0..CCHMAXPATHCOMP-1] Of Char
  End;
  pFILEFINDBUF = ^FILEFINDBUF;

  FILEFINDBUF2 = Record                 { findbuf2 }
    fdateCreation: FDATE;
    ftimeCreation: FTIME;
    fdateLastAccess: FDATE;
    ftimeLastAccess: FTIME;
    fdateLastWrite: FDATE;
    ftimeLastWrite: FTIME;
    cbFile,
    cbFileAlloc: ULONG;
    attrFile: USHORT;
    cbList: ULONG;
    cchName: UCHAR;
    achName: Array[0..CCHMAXPATHCOMP-1] Of Char
  End;
  pFILEFINDBUF2 =^FILEFINDBUF2;

{ extended attribute structures }

  GEA = Record                          { gea                            }
    cbName: BYTE;                       { name length not including NULL }
    szName: Array[0..0] Of Char         { attribute name }
  End;
  pGEA =  ^GEA;

  GEALIST = Record                      { geal                                         }
    cbList: ULONG;                      { total bytes of structure including full list }
    list: Array[0..0] Of GEA            { variable length GEA structures }
  End;
  pGEALIST = ^GEALIST;

  FEA = Record                          { fea                            }
    fea,                                { flags }
    cbName: BYTE;                       { name length not including NULL }
    cbValue: USHORT                     { value length }
  End;
  pFEA =  ^FEA;

{ flags for _FEA.fEA }


Const
  FEA_NEEDEA                       =  $80;                  { need EA bit }


Type
  FEALIST = Record                      { feal                                         }
    cbList: ULONG;                      { total bytes of structure including full list }
    list: Array[0..0] Of FEA            { variable length FEA structures }
  End;
  pFEALIST = ^FEALIST;

  EAOP = Record                         { eaop            }
    fpGEAList: PGEALIST;                { general EA list }
    fpFEAList: PFEALIST;                { full EA list }
    oError: ULONG
  End;
  pEAOP = ^EAOP;

{
 * Equates for the types of EAs that follow the convention that we have
 * established.
 *
 * Values 0xFFFE thru 0x8000 are reserved.
 * Values 0x0000 thru 0x7fff are user definable.
 }


Const
  EAT_BINARY                       =  $FFFE;                { length preceeded binary            }
  EAT_ASCII                        =  $FFFD;                { length preceeded ASCII             }
  EAT_BITMAP                       =  $FFFB;                { length preceeded bitmap            }
  EAT_METAFILE                     =  $FFFA;                { length preceeded metafile          }
  EAT_ICON                         =  $FFF9;                { length preceeded icon              }
  EAT_EA                           =  $FFEE;                { length preceeded ASCII ext. attr.  }
                                        { name of associated data
  EAT_MVMT                         =  $FFDF;                { multi-valued, multi-typed field    }
  EAT_MVST                         =  $FFDE;                { multi-valued, single-typed field   }
  EAT_ASN1                         =  $FFDD;                { ASN.1 field                        }


{**   DosOpen - Open file
 *
 *     Creates or opens a specified file.
 *
 }

  Function DosOpen (pszFname: PSZ;                          { path name of file to be opened }
                    phfOpen: PHFILE;                        { file handle (returned ) }
                    pusAction: PUSHORT;                     { action taken (returned) }
                    ulFSize: ULONG;                         { file's new size }
                    usAttr,                                 { file attribute }
                    fsOpenFlags,                            { action take if file exists }
                    fsOpenMode: USHORT;                     { open mode }
                    ulReserved: ULONG): USHORT;              { reserved (must be 0)           }


{**    DosOpen2 - Open a File
 *
 *
 *
 *      Creates the specified file
 *
 *      Supports Extended Attributes
 }

  Function DosOpen2 (pszFname: PSZ;                         { File path name }
                     phfOpen: PHFILE;                       { New file's handle }
                     pusAction: PUSHORT;                    { Action taken - 1=file existed, }{ 2=file was created }
                     ulFSize: ULONG;                        { File primary allocation }
                     usAttr,                                { File attributes }
                     usOpenFlags: USHORT;                   { Open function type }
                     usOpenMode: ULONG;                     { Open mode of the file }
                     pvEABuf: PEAOP;                        { EA structure pointer }
                     ulReserved: ULONG): USHORT;              { Reserved (must be zero)        }

{**   DosClose - Close file handle
 *
 *     Closes a specific file handle.
 *
 }

  Function DosClose (hf: HFILE): USHORT;                      { file handle }


{**   DosRead - Read from file
 *
 *     Reads the specified number of bytes from a file or device to a buffer
 *     location.
 *
 }

  Function DosRead (hf: HFILE;                              { file handle }
                    pBuf: PVOID;                            { input buffer }
                    cbBuf: USHORT;                          { number of bytes to be read }
                    pcbBytesRead: PUSHORT): USHORT;          { number of bytes read (returned) }


{**   DosWrite - Synchronous Write to file
 *
 *     Transfers the specified number of bytes from a buffer to the specified
 *     file, synchronously with respect to the requesting process's execution.
 *
 }

  Function DosWrite (hf: HFILE;                             { file handle }
                     pBuf: PVOID;                           { output buffer }
                     cbBuf: USHORT;                         { number of bytes to be written }
                     pcbBytesWritten: PUSHORT): USHORT;      { number of bytes written (returned) }


{**   DosShutdown - File System Shutdown
 *
 *
 *
 }

  Function DosShutdown (ulReserved: ULONG): USHORT;     { reserved }


{**    FileStatus - structure of information list used by DosQFileInfo }


Type
  FILESTATUS = Record                   { fsts  }
    fdateCreation: FDATE;               { date of file creation }
    ftimeCreation: FTIME;               { time of file creation }
    fdateLastAccess: FDATE;             { date of last access }
    ftimeLastAccess: FTIME;             { time of last access }
    fdateLastWrite: FDATE;              { date of last write }
    ftimeLastWrite: FTIME;              { time of last write }
    cbFile,                             { file size (end of data) }
    cbFileAlloc: ULONG;                 { file allocated size }
    attrFile: USHORT                    { attributes of the file }
  End;
  pFILESTATUS = ^FILESTATUS;

  FILESTATUS2 = Record                  { fsts2 }
    fdateCreation: FDATE;
    ftimeCreation: FTIME;
    fdateLastAccess: FDATE;
    ftimeLastAccess: FTIME;
    fdateLastWrite: FDATE;
    ftimeLastWrite: FTIME;
    cbFile,
    cbFileAlloc: ULONG;
    attrFile: USHORT;
    cbList: ULONG
  End;
  pFILESTATUS2 = ^FILESTATUS2;

{**    FSAllocate - structure of file system allocation }

  FSALLOCATE = Record
    idFileSystem,                       { file system ID }
    cSectorUnit,                        { number sectors per allocation unit }
    cUnit,                              { number of allocation units }
    cUnitAvail: ULONG;                  { avalaible allocation units }
    cbSector: USHORT                    { bytes per sector }
  End;
  pFSALLOCATE = ^FSALLOCATE;

  VOLUMELABEL = Record                  { vol }
    cch: BYTE;
    szVolLabel: Array[0..11] Of Char
  End;
  pVOLUMELABEL = ^VOLUMELABEL;

  FSINFO = Record                       { fsinf }
    fdateCreation: FDATE;
    ftimeCreation: FTIME;
    vol: VOLUMELABEL
  End;
  pFSINFO = ^FSINFO;

{ HANDTYPE values }


Const
  HANDTYPE_FILE                    =  $0000;
  HANDTYPE_DEVICE                  =  $0001;
  HANDTYPE_PIPE                    =  $0002;
  HANDTYPE_NETWORK                 =  $8000;

Type
  FILELOCK = Record                     { flock }
    lOffset,
    lRange: LongInt
  End;
  pFILELOCK = ^FILELOCK;

  HDIR = SHANDLE;        { hdir }
  pHDIR = ^HDIR;


{**    DosDelete - Delete file
 *
 *      Removes a directory entry associated with a filename.
 *
 }

  Function DosDelete (pszFName: PSZ;                        { name of file to be deleted }
                      ulReserved: ULONG): USHORT;              { reserved (must be 0)       }


{**   DosDupHandle - Duplicate file handle
 *
 *     Returns a new file handle for an open file that refers to the same file
 *     at the same position.
 *
 }

  Function DosDupHandle (hfOld: HFILE;                      { current file handle }
                         phfNew: PHFILE): USHORT;                 { new file handle (returned) }
{**   DosQFHandState - Query file handle state
 *
 *     Queries the state of the specified file.
 *
 }

  Function DosQFHandState (hf: HFILE;                       { file handle }
                           pfsOpenMode: PUSHORT): USHORT;           { file handle state (returned) }


{**   DosSetFHandState - Set file handle state
 *
 *     Sets the state of the specified file.
 *
 }

  Function DosSetFHandState (hf: HFILE;                     { file handle }
                             fsState: USHORT): USHORT;                { file handle state }


{**   DosQHandType - Query handle type
 *
 *     Determines whether a handle references a file or a device.
 *
 }

  Function DosQHandType (hf: HFILE;                         { file handle }
                         pfsType,                           { handle type (returned) }
                         pusDevAttr: PUSHORT): USHORT;            { device driver attribute (returned) }

{**   DosReadAsync - Asynchronous read from file
 *
 *     Transfers the specified number of bytes from a file to a buffer,
 *     asynchronously with the requesting process execution.
 *
 }

  Function DosReadAsync (hf: HFILE;                         { file handle }
                         hsemRam: PULONG;                   { ram semaphore }{ (signals end of read operation) }
                         pusErrCode: PUSHORT;               { return code (returned) }
                         pBuf: PVOID;                       { input buffer }
                         cbBuf: USHORT;                     { number of bytes to be read }
                         pcbBytesRead: PUSHORT): USHORT;          { number of bytes read (returned) }


{**   DosWriteAsync - Asynchronous write to file
 *
 *     Transers the specified number of bytes to a file from a buffer
 *     asynchronously with respect to the requesting process's execution.
 *
 }

  Function DosWriteAsync (hf: HFILE;                        { file handle }
                          hsemRam: PULONG;                  { ram semaphore }{ (indicates end of write operation) }
                          pusErrCode: PUSHORT;              { return code (returned) }
                          pBuf: PVOID;                      { output buffer }
                          cbBuf: USHORT;                    { number of bytes to be written }
                          pcbBytesWritten: PUSHORT): USHORT;       { number of bytes written (returned) }


{**   DosFindFirst - Find first matching file
 *
 *     Finds the first set of filenames that match a given file specification.
 *
 }

  Function DosFindFirst (pszFSpec: PSZ;                     { path name of files to be found }
                         phdir: PHDIR;                      { directory handle }
                         usAttr: USHORT;                    { attribute used to search for the files }
                         pffb: PFILEFINDBUF;                { result buffer }
                         cbBuf: USHORT;                     { length of result buffer }
                         pcSearch: PUSHORT;                 { number of matching entries in result buffer }
                         ulReserved: ULONG): USHORT;     { reserved (must be 0)                        }

{**    DosFindFirst2 - Find First Matching File, version 2
 *
 *
 *
 *      Finds the first filename that matches the specified file
 *      specification
 *
 *      Supports FileInfoLevel
 }

  Function DosFindFirst2 (pszFSpec: PSZ;                    { File path name }
                          phdir: PHDIR;                     { Directory search handle }
                          usAttr: USHORT;                   { Search attribute }
                          pBuf: PVOID;                      { Result buffer }
                          cbBuf: USHORT;                    { Result buffer length }
                          pcSearch: PUSHORT;                { Number of entries to find }
                          usInfoLevel: USHORT;              { Request level }
                          ulReserved: ULONG): USHORT;              { Reserved (must be 0)      }

{**   DosFindNext - Find next matching file
 *
 *     Locates the next set of directory entries that match the name specified
 *     in the previous DosFindFirst or DosFindNext call.
 *
 }

  Function DosFindNext (hdir: HDIR;                         { directory handle }
                        pffb: PFILEFINDBUF;                 { result buffer }
                        cbBuf: USHORT;                      { length of result buffer }
                        pcSearch: PUSHORT): USHORT;              { number of entries to find }

{**   DosFindClose - Close find handle
 *
 *     Closes the association between a directory handle and a DosFindFirst or
 *     DosFindNext directory search function.
 *
 }

  Function DosFindClose (hdir: HDIR): USHORT;                     { directory handle }


{**    DosFindNotifyFirst - Start Monitoring a Directory for Change
 *
 *      Waits for changes
 *      to take place against the specified path.  The number of changes
 *      is specified in the change count parameter.
 *
 }

  Function DosFindNotifyFirst (pszPath: PSZ;                { Path spec }
                               hdir: PHDIR;                 { Directory search handle }
                               usAttr: USHORT;              { Search attribute }
                               pBuf: PBYTE;                 { Result buffer }
                               cbBuf: USHORT;               { Result buffer length }
                               pcChg: PUSHORT;              { Number of changes required }
                               usInfoLevel: USHORT;         { Request level }
                               ulTimeOut,                   { Timeout or Duration of call }
                               ulReserved: ULONG): USHORT;              { Reserved (must be 0)        }

{**    DosFindNotifyNext - Return Directory Change Information
 *
 *      Waits for changes
 *      to take place against the specified DirHandle.  The number of changes
 *      is specified in the change count parameter.
 *
 }

  Function DosFindNotifyNext (hdir: HDIR;                   { Directory handle }
                              pBuf: PVOID;                  { Result buffer }
                              cbBuf: USHORT;                { Result buffer length }
                              pcChg: PUSHORT;               { Number of required }
                              ulTimeOut: ULONG): USHORT;               { Timeout or Duration of call }


{**    DosFindNotifyClose - Close FindNotify Handle
 *
 *      Closes the association between a directory handle and a
 *      osFindNotifyFirst or DosFindNotifyNext function
 }

  Function DosFindNotifyClose (hdir: HDIR): USHORT;                    { Directory watch handle }



{**    DosFsAttach - Creates and Detroys FSD Connections
 *
 *      Attaches or detaches drive from a remote FSD or a psuedo-character
 *      device name to/from a local or remote FSD
 }

  Function DosFSAttach (pszDevName,                         { device name }
                        pszFSD: PSZ;                        { FSD name }
                        pData: PBYTE;                       { data buffer }
                        cbData,                             { data buffer length }
                        fsOp: USHORT;                       { open flag }
                        ulReserved: ULONG): USHORT;              { reserved           }



{**    DosQFsAttach - Query Attached FSD Information
 *
 *      Query information about an attached remote file system or about
 *      a character device or about a psuedo-character device attacted
 *      to a local or remote FSD
 }

  Function DosQFSAttach (pszDev: PSZ;                       { device name }
                         usOrdinal,                         { ordinal }
                         usInfoLevel: USHORT;               { FSAinfolevel }
                         pFSAttBuf: PBYTE;                  { Data buffer }
                         cbBuf: PUSHORT;                    { Data buffer length }
                         ulReserved: ULONG): USHORT;              { reserved           }



{**    DosFSCtl - File System Control
 *
 *      Allow an extended standard interface between an application
 *      and an FSD
 }

  Function DosFSCtl (pDate: PBYTE;                          { Data area }
                     cbData: USHORT;                        { Data length maximum }
                     pcbData: PUSHORT;                      { Data length }
                     pParms: PBYTE;                         { Parameter list }
                     cbParms: USHORT;                       { Parameter length max }
                     pcbParms: PUSHORT;                     { Parameter length }
                     usFunCode: USHORT;                     { Function code }
                     pszRoute: PSZ;                         { Route name }
                     hf: HFILE;                             { File handle }
                     usRouteMethod: USHORT;                 { Route method }
                     ulReserved: ULONG): USHORT;              { reserved             }



{**   DosNewSize - Change file size
 *
 *     Changes the size of a file.
 *
 }

  Function DosNewSize (hf: HFILE;                           { file handle }
                       ulNewSize: ULONG): USHORT;               { file's new size }


{**   DosBufReset - Commit File's cache buffers
 *
 *     Flushes a requesting process's cache buffers for a specific file handle.
 *
 }

  Function DosBufReset (hf: HFILE): USHORT;                      { file handle                    }


{**   DosChgFilePtr - Change
 *
 *     moves the read/write pointer in accordance with the method specified.
 *
 }

  Function DosChgFilePtr (hf: HFILE;                        { file handle }
                          lOffset: LongInt;                 { distance to move in bytes }
                          fsMethod: USHORT;                 { method of moving }
                          pulNewOffset: PULONG): USHORT;           { new pointer location (returned) }


{**  DosFileLocks - File lock manager
 *
 *    Locks and unlocks a range in an opened file
 *
 }

  Function DosFileLocks (hf: HFILE;                         { file handle }
                         pUnlock,                           { range to be unlocked }
                         pLock: PLONG): USHORT;                   { range to be locked   }


{**   DosMove - Move a file
 *
 *     moves a specified file.
 *
 }

  Function DosMove (pszOld,                                 { old path name }
                    pszNew: PSZ;                            { new path name }
                    ulReserved: ULONG): USHORT;              { reserved (must be 0)           }

{**   DosCopy - Copy file
 *
 *     copies file
 *
 }

  Function DosCopy (pszSrc,                                 { old path name }
                    pszDst: PSZ;                            { new path name }
                    usOpt: USHORT;                          { operation mode }
                    ulReserved: ULONG): USHORT;              { reserved (must be 0)            }


{**    DosEditName - Transform source string using editing string
 *
 *      Transform a source string into a destination string using an
 *      editing string and OS/2 meta editing semantics.
 *
 }

  Function DosEditName (usEditLevel: USHORT;                { Level of meta editing semantics }
                        pszSrc,                             { String to transform }
                        pszEdit: PSZ;                       { Editing string }
                        pszDst: PBYTE;                      { Destination string buffer }
                        cbDst: USHORT): USHORT;                  { Destination string buffer length }


{**    DosFileIO - Multiple Lock, Unlock, Seek, Read and Write I/O.
 *
 *      Combines the above File I/O operations into a single API providing
 *      improved performance.
 }

  Function DosFileIO (hf: HFILE;                            { File handle }
                      pbCmd: PBYTE;                         { Pointer to command list buffer }
                      cbCmd: USHORT;                        { Command list length }
                      pulErr: PLONG): USHORT;                  { Pointer to error offset        }

{**   DosMkDir - make subdirectory
 *
 *     Creates a specified directory
 *
 }

  Function DosMkDir (pszDirName: PSZ;                       { new directory name }
                     usReserved: ULONG): USHORT;              { reserved (must be 0)           }

{**    DosMkdir2 - Make Subdirectory
 *
 *
 *
 *      Creates the specified directory
 }

  Function DosMkDir2 (pszDir: PSZ;                          { New directory name }
                      pBuf: PEAOP;                          { EA structure pointer }
                      ulReserved: ULONG): USHORT;              { Reserved (must be 0) }

{**   DosRmDir - Remove subdirectory
 *
 *     Removes a subdirectory from the specified disk.
 *
 }

  Function DosRmDir (pszDir: PSZ;                           { directory name }
                     ulReserved: ULONG): USHORT;              { reserved (must be 0)           }


{**   DosSelectDisk - Select default drive
 *
 *     Selects the drive specified as the default drive for the calling
 *     process.
 *
 }

  Function DosSelectDisk (usDrvNum: USHORT): USHORT;               { new default drive number       }


{**   DosQCurDisk - Query current disk
 *
 *     Determines the current default drive for the requesting process.
 *
 }

  Function DosQCurDisk (pusDrvNum: PUSHORT;                 { default drive number (returned) }
                        pulLogDrvMap: PULONG): USHORT;         { bit map of logical drives (returned)}


{**   DosChDir - Change current directory
 *
 *     Defines the current directory for the requesting process.
 *
 }

  Function DosChDir (pszDir: PSZ;                           { directory path name }
                     ulReserved: ULONG): USHORT;              { reserved (must be 0)           }


{**   DosQCurDir - Query current directory
 *
 *     Gets the full path name of the current directory for the requesting
 *     process for the specified drive.
 *
 }

  Function DosQCurDir (usDrvNum: USHORT;                    { drive number }
                       pszPathBuf: PBYTE;                   { directory path name (returned) }
                       pcbPathBuf: PUSHORT): USHORT;            { length of directory path buffer }
                                        {


{**   DosQFSInfo - Query file system information
 *
 *     Queries information from a file system device.
 *
 }

  Function DosQFSInfo (usDrvNum,                            { logical drive number }
                       usInfoLevel: USHORT;                 { level of file information required }
                       pbInfo: PBYTE;                       { storage area for information returned }
                       cbInfo: USHORT): USHORT;              { length of storage area                }


{**   DosSetFSInfo - Set file system information
 *
 *     Sets information for a file system device.
 *
 }

  Function DosSetFSInfo (usDrvNum,                          { drive number }
                         usInfoLevel: USHORT;               { level of file information to be set }
                         pBuf: PBYTE;                       { storage area for new file system information }
                         cbBuf: USHORT): USHORT;        { length of storage area                       }


{**   DosQVerify - Query verify setting
 *
 *     Returns the value of the verify flag.
 *
 }

  Function DosQVerify (pfVerifyOn: PUSHORT): USHORT;            { current verify mode (returned)     }


{**   DosSetVerify - Set/reset verify switch
 *
 *     Sets the verify switch.
 *
 }

  Function DosSetVerify (fVerify: USHORT): USHORT;                { new verify mode                    }


{**   DosSetMaxFH - Set maximum file handles
 *
 *     Defines the maximum number of file handles for the current process.
 *
 }

  Function DosSetMaxFH (usHandles: USHORT): USHORT;           { number of file handles to be provided }

{**   DosQFileInfo - Query file information
 *
 *     Returns information for a specific file.
 *
 }

  Function DosQFileInfo (hf: HFILE;                         { file handle }
                         usInfoLevel: USHORT;               { level of file information required }
                         pInfoBuf: PBYTE;                   { storage area for returned information }
                         cbInfoBuf: USHORT): USHORT;           { length of storage area                }


{**   DosSetFileInfo - Set file information
 *
 *     Specifies information for a file
 *
 }

  Function DosSetFileInfo (hf: HFILE;                       { file handle }
                           usInfoLevel: USHORT;             { level of file information being set }
                           pInfoBuf: PBYTE;                 { storage area for file information }
                           cbInfoBuf: USHORT): USHORT;             { length of storage area              }


{**    DosQPathInfo - Query a Path's Information
 *
 *      Returns information for a specific file or directory
 }

  Function DosQPathInfo (pszPath: PSZ;                      { Path string }
                         usInfoLevel: USHORT;               { Path data required }
                         pInfoBuf: PBYTE;                   { Path data buffer }
                         cbInfoBuf: USHORT;                 { Path data buffer size }
                         ulReserved: ULONG): USHORT;              { Reserved (must be zero) }


{**    DosSetPathInfo - Set a Path's Information
 *
 *      Specifies information for a file or directory
 }

  Function DosSetPathInfo (pszPath: PSZ;                    { Path string }
                           usInfoLevel: USHORT;             { Path info data required }
                           pInfoBuf: PBYTE;                 { Path info buffer }
                           cbInfoBuf,                       { Path info buffer size }
                           usFlags: USHORT;                 { Path info flags }
                           ulReserved: ULONG): USHORT;              { Reserved (must be zero) }


{**   DosQFileMode - Query file mode
 *
 *     Queries the mode
 *
 }

  Function DosQFileMode (pszFname: PSZ;                     { file path name }
                         pusAttr: PUSHORT;                  { current file attribute (returned) }
                         ulReserved: ULONG): USHORT;              { reserved (must be 0)               }


{**   DosSetFileMode - Set file mode
 *
 *     Changes the mode
 *
 }

  Function DosSetFileMode (pszFName: PSZ;                   { file path name }
                           usAttr: USHORT;                  { new attribute of file }
                           ulReserved: ULONG): USHORT;              { reserved (must be 0)               }

{**    DosEnumAttribute - Enumerate a file or directory's extended attributes
 *
 *      Enumerates information for a specific file or subdirectory
 *
 }

  Function DosEnumAttribute (Par1: USHORT;                  { RefType - indicates handle or path }
                             Par2: PVOID;                   { Pointer to file handle or path }
                             Par3: ULONG;                   { Starting entry in EA list }
                             Par4: PVOID;                   { Data buffer }
                             Par5: ULONG;                   { Data buffer size }
                         Var Par6: ULONG;                   { Number of entries to return }
                             Par7: ULONG;                   { Info level }
                             Par8: ULONG): USHORT;          { Reserved (must be zero)            }

Type
  DENA1 = Record                        { level 1 info returned from DosEnumAttribute }
    reserved,                           { 0 }
    cbName: UCHAR;                      { length of name exculding NULL }
    cbValue: USHORT;                    { length of value }
    szName: Array[0..0] Of UCHAR        { variable length asciiz name }
  End;
  pDENA1 = ^DENA1;



{** Memory management }


{**   DosAllocSeg - Allocate segment
 *
 *     Allocates a segment of memory to a requesting process.
 *
 }

  Function DosAllocSeg (cbSize: USHORT;                     { number of bytes requested }
                        pSel: PSEL;                         { sector allocated (returned) }
                        fsAlloc: USHORT): USHORT;       { sharing attributes of the allocated segment }


{**   DosReallocSeg - Change segment size
 *
 *     Changes the size of a segment already allocated.
 *
 }

  Function DosReallocSeg (cbNewSize: USHORT;                { new size requested in bytes }
                          sel: SEL): USHORT;                    { selector of the segment to be resized }


{**   DosFreeSeg - Free segment
 *
 *     Deallocates a memory segment.
 *
 }

  Function DosFreeSeg (sel: SEL): USHORT;                      { selector of the segment to be freed }


{**   DosGivSeg - Give access to segment
 *
 *     Gives another process access to a shared memory segment.
 *
 }

  Function DosGiveSeg (sel: SEL;                            { segment selector of the memory }{ segment to be shared }
                       pid: PID;                            { process ID of recipient }
                       pSelRecipient: PSEL): USHORT;            { recipients segment selector    }
                                        {


{**   DosGetSeg - Access segment
 *
 *     Gets access to a shared memory segment.
 *
 }

  Function DosGetSeg (sel: SEL): USHORT;                       { selector to access                 }


{**   DosSizeSeg - Get size of a segment.                      }

  Function DosSizeSeg (sel: SEL;                            { segment selector of which size }{ is to be found }
                       pcbSize: PULONG): USHORT;                { size in bytes (returned)       }

{ Segment attribute flags


Const
  SEG_NONSHARED                    =  $0000;
  SEG_GIVEABLE                     =  $0001;
  SEG_GETTABLE                     =  $0002;
  SEG_DISCARDABLE                  =  $0004;




{**   DosAllocHuge - Allocate huge memory
 *
 *     Allocates multiple segments of memory.
 *
 }

  Function DosAllocHuge (cSegs,                             { number of 64k segments }
                         cbPartialSeg: USHORT;              { number of bytes in last non-64k segment }
                         psel: PSEL;                        { selector allocated (returned) }
                         cMaxSegs,                          { max number of 64k segments }
                         fsAlloc: USHORT): USHORT;       { sharing attributes of the allocated segment }


{**   DosReallocHuge - Change huge memory size
 *
 *     Changes the size of memory originally allocated by DosAllocHuge.
 *
 }

  Function DosReallocHuge (cSegs,                           { number of 64k segments requested }
                           cbPartialSeg: USHORT;            { number of bytes in last non-64k segment }
                           sel: SEL): USHORT;                  { selector                                }


{**   DosGetHugeShift - Get shift count
 *
 *    Returns a shift count used to derive the selectors that address memory
 *    allocated with DosAllocHuge.
 *
 }

  Function DosGetHugeShift (pusShiftCount: PUSHORT): USHORT;         { shift count (returned)             }


{**   DosAllocShrSeg - Allocate shared segment
 *
 *     Allocates a shared memory segment to a process.
 *
 }

  Function DosAllocShrSeg (cbSeg: USHORT;                   { number of bytes requested }
                           pszSegName: PSZ;                 { symbolic name associated with shared memory }
                           psel: PSEL): USHORT;            { selector of allocated segment (returned)    }


{**   DosLockSeg - Lock segment in memory
 *
 *     Locks a discardable segment in memory.
 *
 }

  Function DosLockSeg (sel: SEL): USHORT;                       { selector of segment to be locked   }


{**   DosUnlockSeg - Unlock segment
 *
 *     Unlocks a discardable segment.
 *
 }

  Function DosUnlockSeg (sel: SEL): USHORT;                       { selector of segment to be unlocked }


{**   DosGetShrSeg - Access shared segment
 *
 *     Accesses a shared memory segment previously allocated by another
 *     process.
 *
 }

  Function DosGetShrSeg (pszSegName: PSZ;                   { name string associated with the }{ shared memory segment }
                         psel: PSEL): USHORT;                     { selector of shared memory segment }
                                        {


{**   DosMemAvail - Get size of largest free memory block
 *
 *     Returns the size of the largest block of free memory.
 *
 }

  Function DosMemAvail (pcbFree: PULONG): USHORT;             { size of largest free block (returned) }


{**   DosCreateCSAlias - Create CS alias
 *
 *     Creates a code segment alias descriptor for a data segment passed as
 *     input.
 *
 }

  Function DosCreateCSAlias (selDs: SEL;                    { data segment selector }
                             pselCS: PSEL): USHORT;                   { selector of code segment allias }
                                        { descriptor


{**   DosSubAlloc - Suballocate memory within segment
 *
 *     Allocates memory from a segment previously allocated by DosAllocSeg or
 *     DosAllocShrSeg and initialized by DosSubSet.
 *
 }

  Function DosSubAlloc (sel: SEL;                           { segment selector from which memory }{ is to be allocated }
                        ousOffset: PUSHORT;                 { offset to the block allocated (returned) }
                        cb: USHORT): USHORT;               { size of memory block requested in bytes  }


{**   DosSubFree - Free memory suballocated within segment
 *
 *     Frees memory previously allocated by DosSubAlloc.
 *
 }

  Function DosSubFree (sel: SEL;                            { segment selector from which }{ memory is to be freed }
                       offBlock,                            { offset of memory block to free }
                       cb: USHORT): USHORT;                 { size of the block to be freed in bytes }


{**   DosSubSet - Initialize or set allocated memory
 *
 *     Used to initialize a segment for suballocation or to increase the size
 *     a previously initialized, suballocated segment.
 *
 }

  Function DosSubSet (sel: SEL;                             { selector of the target data segment }
                      fFlags,                               { 0=increasing size of a segment }{ 1=initializing a segment }
                      cbNew: USHORT): USHORT;                 { size of the segment in bytes        }



{** Semaphore support }


Const
  SEM_INDEFINITE_WAIT              = -1 ;
  SEM_IMMEDIATE_RETURN             = 0 ;

{**   DosSemClear - Clear
 *
 *     Unconditionally clears a semaphore. If any threads were blocked on the
 *     semaphore, they are restarted.
 *
 }

  Function DosSemClear (hsem: HSEM): USHORT;                     { semaphore handle                   }


{**   DosSemSet - Set Semaphore Owned
 *
 *     Unconditionally sets a seaphore.
 *
 }

  Function DosSemSet (hsem: HSEM): USHORT;                     { semaphore handle                   }


{**   DosSemWait - Wait for semaphore to clear
 *
 *     Blocks the current thread until an indicated semaphore clears, but does
 *     not establish ownership of this semaphore.
 *
 }

  Function DosSemWait (hsem: HSEM;                          { semaphore handle }
                       lTimeOut: LongInt): USHORT;                 { timeout (in milliseconds)          }


{**   DosSemSetWait - Set semaphore and wait for next clear
 *
 *     Blocks the current thread until the next DosSemClear is issued. However,
 *     DosSemSetWait does not establish ownership of this semaphore.
 *
 }

  Function DosSemSetWait (hsem: HSEM;                       { semaphore handle }
                          lTimeOut: LongInt): USHORT;                 { timeout (in milliseconds)          }


{**   DosSemRequest - Request semaphore
 *
 *     Obtains a semaphore. If the semaphore is already owned, the requesting
 *     thread is placed in a wait state until the semaphore is released or
 *     until a time out occures.
 *
 }

  Function DosSemRequest (hsem: HSEM;                       { semaphore handle }
                          lTimeOut: LongInt): USHORT;                 { timeout (in milliseconds)          }


Type
  HSYSSEM = LHANDLE;
  pHSYSSEM = ^HSYSSEM;


{**   DosCreateSem - Create system semaphore
 *
 *     Creates a system semaphore used by semaphore manipulation calls such as
 *     DosSemRequest, DosSemClear, DosSemSet, DosSemSetWait, DosSemWait, and
 *     DosMuxSemWait.
 *
 }

  Function DosCreateSem (fExclusive: USHORT;                { indicate no exclusive ownership }
                         phsem: PHSYSSEM;                   { semaphore handle (returned) }
                         pszSemName: PSZ): USHORT;                { semaphore name string              }


Const
  CSEM_PRIVATE                     = 0;
  CSEM_PUBLIC                      = 1;


{**   DosOpenSem - Open existing system semaphore
 *
 *     Opens a system semaphore.
 *
 }

  Function DosOpenSem (phsem: PHSEM;                        { semaphore handle (returned) }
                       pszSemName: PSZ): USHORT;                { semaphore name string              }


{**   DosCloseSem - Close system semaphore
 *
 *     Closes a specific system semaphore.
 *
 }

  Function DosCloseSem (hsem: HSEM): USHORT;                     { semaphore handle                   }


Type
  MUXSEM = Record
    zero: USHORT;                       { zero }
    hsem: HSEM                          { semaphore handle }
  End;
  pMUXSEM = ^MUXSEM;

  MUXSEMLIST = Record
    cmxs: USHORT;                       { count of MUXSEM structures }
    amxs: Array[0..15] Of MUXSEM        { array of MUXSEM structures }
  End;
  pMUXSEMLIST = ^MUXSEMLIST;

{
 * Since a MUXSEMLIST structure is actually a variable length
 * structure, the following macro may be used to define a MUXSEMLIST
 * structure having size elements, named "name".
}
(******
#define DEFINEMUXSEMLIST(name, size) \
    struct {                         \
        USHORT cmxs;                 \
        MUXSEM amxs[size];           \
    } name;
*******)

{
 * This function actually takes a far pointer to a MUXSEMLIST structure
 * as its second parameter, but in order to allow its use with the
 * DEFINEMUXSEMLIST macro, it is declared here as PVOID.
 }


{**   DosMuxSemWait - Wait for one of n semaphores to clear
 *
 *     Blocks a current thread until one of the specefied semaphores clear.
 *
 }

  Function DosMuxSemWait (pisemCleared: PUSHORT;            { index number of event (returned) }
                          pmsxl: PVOID;                     { semaphore list }
                          lTimeOut: LongInt): USHORT;                 { timeout (in milliseconds)          }


{** Fast safe ram semaphores }


Type
  DOSFSRSEM = Record
    cb: USHORT;                         { length of this structure (bytes) }
    pid: PID;                           { Process ID of the owner or zero }
    tid: TID;                           { Thread ID of the owner or zero }
    cUsage,                             { Reference count }
    client: USHORT;                     { 16 bit field for use by owner }
    sem: ULONG                          { OS/2 Ram Semaphore }
  End;
  pDOSFSRSEM = ^DOSFSRSEM;


{**   DosFSRamSemRequest - Safe ram semaphore request
 *
 *     Obtains a ram seaphore and records the current owner for potential
 *     cleanup by a dos exit list routine.
 *
 }

  Function DosFSRamSemRequest (pdosfsrs: PDOSFSRSEM;        { Address of the fast-safe }{ RamSemaphore data structure }
                               lTimeOut: LongInt): USHORT;                 { timeout, in milliseconds    }


{**   DosFSRamSemClear - Clear (release) a fast-safe ram semaphore}

Function DosFSRamSemClear(pdosfsrs: pDOSFSRSEM): USHORT; {Address of the fast-safe}
                                                         {RamSemaphore data structure}




{** Time support }


Type
  DATETIME = Record
    hours,                              { current hour }
    minutes,                            { current minute }
    seconds,                            { current second }
    hundredths,                         { current hundredths of a second }
    day,                                { current day }
    month: UCHAR;                       { current month }
    year: USHORT;                       { current year }
    timezone: SHORT;                    { minutes of time west of GMT }
    weekday: UCHAR                      { current day of week }
  End;
  pDATETIME = ^DATETIME;


{**   DosGetDateTime - Get current date and time
 *
 *     Gets the current date and time maintained by the operating system.
 *
 }

  Function DosGetDateTime (pdatetime: PDATETIME): USHORT;           { date/time structure (returned)     }


{**   DosSetDateTime - Set current date and time
 *
 *     Used to set the date and time that are maintained by the operating
 *     system.
 *
 }

  Function DosSetDateTime (pdatetime: PDATETIME): USHORT;           { date/time structure                }

Type
  HTIMER = SHANDLE;
  pHTIMER = ^HTIMER;


{**   DosTimerAsync - Start asynchronous time delay
 *
 *     Starts a timer that runs asynchronously to the thread issuing the
 *     request and clears a sytem semaphore when the specified interval
 *     expires.
 *
 }

  Function DosTimerAsync (ulTime: ULONG;                    { time (in milliseconds) before }{ semaphore is cleared }
                          hsem: HSEM;                       { system semaphore handle }
                          phtimer: PHTIMER): USHORT;               { timer handle (returned)            }


{**   DosTimerStart - Start periodic interval timer
 *
 *     Starts a periodic interval timer that runs asynchronously to the thread
 *     issuing the request.
 *
 }

  Function DosTimerStart (ulTime: ULONG;                    { time (in milliseconds) before }{ semaphore is cleared }
                          hsem: HSEM;                       { system semaphore handle }
                          phtimer: PHTIMER): USHORT;               { timer handle (returned)            }


{**   DosTimerStop - Stop interval timer
 *
 *     Stops a periodic interval timer started by DosTimerStart, or an
 *     asynchronous timer started by DosTimerAsync.
 *
 }

  Function DosTimerStop (htimer: HTIMER): USHORT;                 { handle of the timer                }



{** Module manager }



{**   DosLoadModule - Load dynamic link module
 *
 *     Loads a dynamic link module and returns a handle for the module.
 *
 }

  Function DosLoadModule (pszFailName: PSZ;                 { object name buffer }
                          cbFileName: USHORT;               { length of object name buffer }
                          pszModName: PSZ;                  { dynamic link module name string }
                          hmod: PHMODULE): USHORT;                 { module handle (returned)           }


{**   DosFreeModule - Free dynamic link module
 *
 *     Frees the reference to a dynamic link module for a process. When the
 *     dynamic link module is no longer needed by any process, the module is
 *     freed from system memory.
 *
 }

  Function DosFreeModule (hmod: HMODULE): USHORT;                  { module handle                      }


{**   DosGetProcAddr - Get dynamic link procedure address
 *
 *     Returns a far address to a desired procedure within a dynamic link
 *     module.
 *
 }

  Function DosGetProcAddr (hmod: HMODULE;                   { handle of module where procedure is located }
                           pszProcName: PSZ;                { name of module where procedure is located }
                      Var  ppfnProcAddr: pFn): USHORT;      { procedure address (returned)       }



{**   DosGetModHandle - Get dynamic link module handle
 *
 *     Returns a handle to a previously loaded dynamic link module.
 *
 }

  Function DosGetModHandle (pszModName: PSZ;                { dynamic link module name }
                            phmod: PHMODULE): USHORT;                { module handle (returned)           }


{**   DosGetModName - Get dynamic link module name
 *
 *     Returns the fully qualified drive, path, filename, and extension
 *     associated with a referenced module handle.
 *
 }

  Function DosGetModName (hmod: HMODULE;                    { module handle }
                          cbBuf: USHORT;                    { max length of buffer where name is stored }
                          pchBuf: PCHAR): USHORT;           { buffer (returned) where info is stored    }



{** Resource support }

{ Predefined resource types }


Const
  RT_POINTER              = 1;                     { mouse pointer shape }
  RT_BITMAP                        = 2;                     { bitmap }
  RT_MENU                          = 3;                     { menu template }
  RT_DIALOG                        = 4;                     { dialog template }
  RT_STRING                        = 5;                     { string tables }
  RT_FONTDIR                       = 6;                     { font directory }
  RT_FONT                          = 7;                     { font }
  RT_ACCELTABLE                    = 8;                     { accelerator tables }
  RT_RCDATA                        = 9;                     { binary data }
  RT_MESSAGE                       = 10;                    { error msg     tables }
  RT_DLGINCLUDE                    = 11;                    { dialog include file name }
  RT_VKEYTBL                       = 12;                    { key to vkey tables }
  RT_KEYTBL                        = 13;                    { key to UGL tables }
  RT_CHARTBL                       = 14;                    { glyph to character tables }
  RT_DISPLAYINFO                   = 15;                    { screen display information }
  RT_FKASHORT                      = 16;                    { function key area short form }
  RT_FKALONG                       = 17;                    { function key area long form }

  RT_HELPTABLE                     = 18;                    { Help table for IPFC }
  RT_HELPSUBTABLE                  = 19;                    { Help subtable for IPFC }

  RT_FDDIR                         = 20;                    { DBCS uniq/font driver directory }
  RT_FD                            = 21;                    { DBCS uniq/font driver }
  RT_MAX                           = 22;                    { 1st unused Resource Type }




{**   DosGetResource - Get resource segment selector
 *
 *     Returns the segment selector of the specified resource segment.
 *
 }

  Function DosGetResource (hmod: HMODULE;                   { module handle }
                           idType,                          { resource type ID }
                           idName: USHORT;                  { resource name ID }
                           psel: PSEL): USHORT;                     { resource selector (returned) }


{**   DosGetResource2 - Get resource far pointer
 *
 *     Returns a far pointer to the specified resource data.
 *
 }

  Function DosGetResource2 (hmod: HMODULE;                  { module handle }
                            idType,                         { resource type ID }
                            idName: USHORT;                 { resource name ID }
                        Var ppData: Pointer): USHORT;            { resource far pointer (returned) }


{**   DosFreeResource - Free Resource
 *
 *     Deallocates memory of a resource.
 *
 }

  Function DosFreeResource (pData: PVOID): USHORT;                   { resource pointer }




{** NLS Support }


{**   _COUNTRYCODE is used by DOSGETCTRYINFO to store
 *              the country code and code page
 }


Type
  COUNTRYCODE = Record
    country,                            { country code }
    codepage: USHORT                    { code page }
  End;
  pCOUNTRYCODE = ^COUNTRYCODE;

{**   _COUNTRYINFO is used by DOSGETCTRYINFO to store
 *              various country-dependent data items
 }

  COUNTRYINFO = Record
    country,                            { country code }
    codepage,                           { code page }
    fsDateFmt: USHORT;                  { date format }
    szCurrency: Array[0..4] Of Char;    { currency indicator }
    szThousandsSeparator,               { thousands separator }
    szDecimal,                          { decimal separator }
    szDateSeparator,                    { date separator }
    szTimeSeparator: Array[0..1] Of Char; { time separator }
    fsCurrencyFmt,                      { bit fields for currency format }
    cDecimalPlace,                      { currency decimal places }
    fsTimeFmt: UCHAR;                   { Time format (AM/PM or 24 hr) }
    abReserved1: Array[0..1] Of USHORT; { reserved (0) }
    szDataSeparator: Array[0..1] Of Char; { Data list separator }
    abReserved2: Array[0..4] Of USHORT  { reserved (0) }
  End;
  pCOUNTRYINFO = ^COUNTRYINFO;


{**   DosGetCtryInfo - Get country information
 *
 *     Obtains contry dependent formatting information that resides in the
 *     country information file.
 *
 }

  Function DosGetCtryInfo (cbBuf: USHORT;                   { length of data area provided }
                           pctryc: PCOUNTRYCODE;            { input data structure }
                           pctryi: PCOUNTRYINFO;            { data area to be filled by the function }
                           pcbCtryInfo: PUSHORT): USHORT;       { length of data (returned)              }


{**   DosGetDBCSEv - Get DBCS environmental vector
 *
 *     Obtains a DBCS
 *     resides in the country information file
 *
 }

  Function DosGetDBCSEv (cbBuf: USHORT;                     { length of data area provided }
                         pctryc: PCOUNTRYCODE;              { input data structure }
                         pchBuf: PCHAR): USHORT;                { data area to contain the information }


{**   DosCaseMap - Perform case mapping
 *
 *     Performs case mapping on a string of binary values that represent ASCII
 *     characters.
 *
 }

  Function DosCaseMap (usLen: USHORT;                       { length of string to case map }
                       pctryc: PCOUNTRYCODE;                { input data structure }
                       pchStr: PCHAR): USHORT;                 { address of string to be case mapped }


{**   DosGetCollate - Get collate table
 *
 *     Obtains a collating sequence table
 *     resides in the country information file. It is used by the SORT utility
 *     to sort text according to the collating sequence.
 *
 }

  Function DosGetCollate (usLen: USHORT;                    { length of data area provided }
                          pctryc: PCOUNTRYCODE;             { input data structure }
                          pchBuf: PCHAR;                    { data area to contain the collate table }
                          pcbTable: PUSHORT): USHORT;          { length of table (returned)             }


{**   DosGetCp - Get process code page
 *
 *     Allows a process to query the current process code page and the prepared
 *     system code pages.
 *
 }

  Function DosGetCp (cbBuf: USHORT;                         { length of CodePageList in bytes }
                     pBuf,                                  { CodePageList (returned) }
                     pcbCodePgLst: PUSHORT): USHORT;          { length of returned list            }


{**   DosSetCp - Set code page
 *
 *     Allows a process to set its code page and the session's display code
 *     page and keyboard code page.
 *
 }

  Function DosSetCp (usCodePage,                            { code page identifier }
                     usReserved: USHORT): USHORT;             { reserved (must be set to 0)        }

{** DosSetProcCp - Set process code page
 *
 *     Allows a process to set it's own code page.
 }

  Function DosSetProcCp (usCodePage,                        { Code page identifier word }
                         usReserved: USHORT): USHORT;             { Reserved (must be set to 0)        }



{** Signal support }


{ Signal Numbers for DosSetSigHandler  }


Const
  SIG_CTRLC               = 1;                     { Control C            }
  SIG_BROKENPIPE                   = 2;                     { Broken Pipe          }
  SIG_KILLPROCESS                  = 3;                     { Program Termination  }
  SIG_CTRLBREAK                    = 4;                     { Control Break        }
  SIG_PFLG_A                       = 5;                     { Process Flag A       }
  SIG_PFLG_B                       = 6;                     { Process Flag B       }
  SIG_PFLG_C                       = 7;                     { Process Flag C       }
  SIG_CSIGNALS                     = 8;                     { number of signals plus one }

{ Flag Numbers for DosFlagProcess      }

  PFLG_A                           = 0;                     { Process Flag A       }
  PFLG_B                           = 1;                     { Process Flag B       }
  PFLG_C                           = 2;                     { Process Flag C       }

{ Signal actions }

  SIGA_KILL                        = 0;
  SIGA_IGNORE                      = 1;
  SIGA_ACCEPT                      = 2;
  SIGA_ERROR                       = 3;
  SIGA_ACKNOWLEDGE                 = 4;

{ DosHoldSignal constants }

  HLDSIG_ENABLE                    = 0;
  HLDSIG_DISABLE                   = 1;

{ DosFlagProcess codes }

  FLGP_SUBTREE                     = 0;
  FLGP_PID                         = 1;

Type
  pFnSigHandler = Procedure (a,b: UShort);

{**    DosSetSigHandler - Handle Signal
 *
 *      Notifies OS/2 of a handler for a signal.  It may also be used
 *      to ignore a signal or install a default action for a signal.
 }

  Function DosSetSigHandler (pfnSigHandler: PFNSIGHANDLER;  { Signal handler address }
                         Var ppfnPrev: PFNSIGHANDLER;       { Address of previous handler }
                             pfAction: PUSHORT;             { Address of previous action }
                             fAction,                       { Indicate request type }
                             usSigNum: USHORT): USHORT;               { Signal number               }


{**    DosFlagProcess - Issue signal
 *
 *      Used to send a signal event to an arbitrary process or
 *      command subtree.
 }

  Function DosFlagProcess (pid: PID;                        { Process ID to signal }
                           fScope,                          { 0=notify entire subtree, 1=notify }{ only the indicated process }
                           usFlagNum,                       { Flag number }
                           usFlagArg: USHORT): USHORT;              { Flag argument                     }

{**    DosHoldSignal - Disable / Enable signals
 *
 *      Used to termporarily disable or enable signal processing
 *      for the current process.
 }

  Function DosHoldSignal (fDisable: USHORT): USHORT;               { 0=enable signal, 1=disable signal }

{**    DosSendSignal - Send Signal to Command Subtree Process Handler
 *
 *      Used to send a signal to last process
 *      that has a handler installed
 }

  Function DosSendSignal (idProcess,                        { process ID of the root process }{ of the subtree }
                          usSigNumber: USHORT): USHORT;           { signal number to send          }



{** Monitor support }

Type
  HMONITOR = SHANDLE;    { hmon }
  pHMONITOR = ^HMONITOR;


{**   DosMonOpen - Open connection to device monitor
 *
 *     Gains access to a character device data stream.
 *
 }

  Function DosMonOpen (pszDevName: PSZ;                     { Device name string (returned) }
                       phmon: PHMONITOR): USHORT;               { Monitor handle (returned)          }


{**   DosMonClose - Close connection to device monitor
 *
 *     Terminates character device monitoring. All monitor buffers associated
 *     with this process are flushed and closed.
 *
 }

  Function DosMonClose (hmon: HMONITOR): USHORT;                 { handle from previous DosMonOpen }


{**   DosMonReg - Register set of buffers as monitor
 *
 *     Establishes an input and output buffer structure to monitor an I/O
 *     stream for a character device.
 *
 }

  Function DosMonReg (hmon: HMONITOR;                       { handle from DosMonOpen }
                      pbInBuf,                              { input buffer }
                      pbOutBuf: PBYTE;                      { output buffer }
                      fPosition,                            { position preference flag }
                      usIndex: USHORT): USHORT;                { index of data stream for the }
                                        { device being monitered       }


{**   DosMonRead - Read input from monitor structure
 *
 *     Waits for and moves a data recorrd from the input buffer of a registered
 *     character device monitor and places it in a private data area where the
 *     monitor can freely access it.
 *
 }

  Function DosMonRead (pbInBuf: PBYTE;                      { monitor input buffer }
                       fWait: UCHAR;                        { block/run indicator }
                       pbDataBuf: PBYTE;                    { buffer into which records are read }
                       pcbData: PUSHORT): USHORT;               { length of the data buffer/number   }
                                        { of bytes moved                     }


{**   DosMonWrite - Write output to monitor structure
 *
 *     Moves a filtered data record from the monitor's private data area into
 *     the monitor's output buffer.
 *
 }

  Function DosMonWrite (pbOutBuf,                           { monitor output buffer }
                        pbDataBuf: PBYTE;                   { buffer from which records are taken }
                        cbData: USHORT): USHORT;                { number of bytes in the data record  }




{** Pipe and queue support }

Type
  HQUEUE = SHANDLE;  { hq }
  pHQUEUE = ^HQUEUE;

{**    DosMakePipe - Create a Pipe }

  Function DosMakePipe (phfRead,                            { Addr to place the read handle }
                        phfWrite: PHFILE;                   { Addr to place the write handle }
                        cb: USHORT): USHORT;                     { Size to reserve for the pipe   }

{**    DosCloseQueue - Close a Queue
 *
 *      close a queue which is in use by the requesting process
 *
 }

  Function DosCloseQueue (hqueue: HQUEUE): USHORT;                 { queue handle }

{**    DosCreateQueue - Create a Queue
 *
 *      creates a queue to be owned by the requesting process
 *
 }

  Function DosCreateQueue (phqueue: PHQUEUE;                { read/write handle of queue }
                           fQueueOrder: USHORT;             { 0=FIFO queue, 1=LIFO queue, }{ 2=Priority queue }
                           pszQueueName: PSZ): USHORT;              { name of the queue           }

{**    DosOpenQueue - Open a Queue
 *
 *      opens a queue for the current process
 *
 }

  Function DosOpenQueue (ppidOwner: PUSHORT;                { PID of queue owner }
                         phqueue: PHQUEUE;                  { queue handle }
                         pszQueueName: PSZ): USHORT;              { queue name         }

{**    DosPeekQueue - Peek at a Queue
 *
 *      retrieves an element from a queue without removing it from the queue
 *
 }

  Function DosPeekQueue (hqueue: HQUEUE;                    { queue handle }
                         pqresc: PULONG;                    { pointer to request }
                         pcbElement: PUSHORT;               { length of datum returned }
                         ppBuf: PULONG;                     { pointer to address of datum }
                         pElemCode: PUSHORT;                { indicator of datum returned }
                         fwait: UCHAR;                      { wait indicator for empty queue }
                         pbElemPrty: PBYTE;                 { priority of element }
                         hsem: ULONG): USHORT;                    { semaphore handle               }

{**    DosPurgeQueue - Purge a Queue
 *
 *      purges all elements from a queue
 *
 }

  Function DosPurgeQueue (hqueue: HQUEUE): USHORT;                 { queue handle }

{**    DosQueryQueue - Query size of a Queue
 *
 *      returns the number of elements in a queue
 *
 }

  Function DosQueryQueue (hqueue: HQUEUE;                   { queue handle }
                          pcElem: PUSHORT): USHORT;                { pointer for number of elements }

{**    DosReadQueue - Read from a Queue
 *
 *      retrieves an element from a queue
 *
 }

  Function DosReadQueue (hqueue: HQUEUE;                    { queue handle }
                         pqresc: PULONG;                    { pointer to request }
                         pcbElem: PUSHORT;                  { length of datum returned }
                         ppBuf: PULONG;                     { pointer to address of datum }
                         usElem: USHORT;                    { indicator of datum returned }
                         fWait: UCHAR;                      { wait indicator for empty queue }
                         pbElemPrty: PBYTE;                 { priority of element }
                         hsem: HSEM): USHORT;                     { semaphore handle               }

{**    DosWriteQueue - Write to a Queue
 *
 *      adds an element to a queue
 *
 }

  Function DosWriteQueue (hqueue: HQUEUE;                   { queue handle }
                          usRequest,                        { request }
                          cbBuf: USHORT;                    { length of datum }
                          pBuf: PBYTE;                      { address of datum }
                          fPriority: UCHAR): USHORT;               { priority of element }




{**   DosError - Enable hard error processing
 *
 *     Allows a process to disable user notification
 *     and program exceptions.
 *
 }

  Function DosError (fEnable: USHORT): USHORT;                { action flag (bit field)            }


{**   DosSetVec - Establish handler for exception vector
 *
 *     Allows a process to register an address to be used when a machine
 *     exception occurs.
 *
 }

  Function DosSetVec (usVecNum: USHORT;                     { number of the vector to be }{ serviced by this routine }
                      pfnFun,                               { handler routine }
                      ppfnPrev: PFN): USHORT;                 { previous handler address (returned) }


{**   DosGetMessage - System message with variable text
 *
 *     Retrieves a message from a message file and inserts variable information
 *     into the body of the message.
 *
 }

  Function DosGetMessage (Var ppchVTable: pChar;            { table of variables to insert }
                          usVCount: USHORT;                 { number of variables }
                          pchBuf: PCHAR;                    { data area (where message is returned) }
                          cbBuf,                            { length of data area }
                          usMsgNum: USHORT;                 { number of the message requested }
                          pszFileName: PSZ;                 { message path and file name }
                          pcbMsg: PUSHORT): USHORT;             { length of message (returned)          }


{**   DosErrClass - Classify error codes
 *
 *     Helps OS/2 applications respnd to error codes
 *     from the OS/2 API.
 *
 }

  Function DosErrClass (usErrCode: USHORT;                  { error code for analysis }
                        pusClass,                           { error classification (returned) }
                        pfsAction,                          { recommended action (returned) }
                        pusLocus: PUSHORT): USHORT;              { origin of the error (returned)     }


{**   DosInsMessage - Insert variable text strings in message
 *
 *     Inserts variable text string information into the body of a message.
 *     This is useful when messages are loaded before insertion text strings
 *     are known.
 *
 }

  Function DosInsMessage (Var ppchVTable: pChar;            { table of variables to insert }
                          usVCount: USHORT;                 { number of variables }
                          pszMsg: PSZ;                      { address of input message }
                          cbMsg: USHORT;                    { length of input message }
                          pchBuf: PCHAR;                    { data area address to return }{ message to }
                          cbBuf: USHORT;                    { length of data area (returned) }
                          pcbMsg: PUSHORT): USHORT;                { length of updated messsage     }


{**   DosPutMessage - Output message text to indicated handle
 *
 *     Outputs the message in a buffer passed by a caller to the specified
 *     handle. The function formats the buffer to prevent words from wrapping
 *     if displayed to a screen.
 *
 }

  Function DosPutMessage (hf,                               { handle of output file/device }
                          cbMsg: USHORT;                    { length of message }
                          pchMsg: PCHAR): USHORT;                  { message buffer that contains the }
                                        { message to be output             }



{**   DosPtrace - Interface for program debugging
 *
 *     Provides an interface into the OS/2 kernel to facilitate program
 *     debugging.
 *
 }

  Function DosPtrace (pPtraceBuf: PBYTE): USHORT;               { Ptrace buffer }

{ definition for DOSQSYSINFO }

Const
  Q_MAX_PATH_LENGTH       = (0);                   { index for query max path length }

{**    DosQSysInfo - query system constants
 *
 *      Returns system constants like the maximum path name length.
 *
 }

  Function DosQSysInfo (index: USHORT;                      { Index of constant requested }
                        pBuf: PBYTE;                        { Pointer to return buffer }
                        cbBuf: USHORT): USHORT;                  { return buffer size          }

{**   DosGetEnv - Get address of process environment string
 *
 *     Returns the address of the process environment string for the current
 *     process.
 *
 }

  Function DosGetEnv (pselEnv,                              { selector for the environment }{ segment (returned) }
                      pOffsetCmd: PUSHORT): USHORT;            { command line offset (returned) }


{**   DosScanEnv - Scan an environment segment
 *
 *     Scans
 *
 }

  Function DosScanEnv (pszVarName: PSZ;                     { environment variable name }
                   Var ppszResult: PSZ): USHORT;            { search result pointer (returned)    }


{**   DosSearchPath - Search path for file name
 *
 *     Provides a general path search mechanism which allows applications to
 *     find files residing along paths. The path string may come from the
 *     process environment, or be supplied directly by the caller.
 *
 }

  Function DosSearchPath (fsSearch: USHORT;                 { function control vector }
                          pszPath,                          { search path reference }
                          pszFName: PSZ;                    { file name }
                          pBuf: PBYTE;                      { search result buffer }
                          cbBuf: USHORT): USHORT;                  { search result buffer length        }


{**   DosGetVersion - Get OS/2 version number   }

  Function DosGetVersion (pVer: PUSHORT): USHORT;                  { version number (returned)          }


{** DosGetMachineMode - Return current mode of processor
 *
 *   Returns the current mode of the processor, whether the processor is
 *   running in the DOS mode or the OS/2 mode. This allows an application to
 *   determine whether a dynamic link call is valid or not.
 *
 }

  Function DosGetMachineMode (pMachMode: PBYTE): USHORT;               { current processor mode (returned)  }



{** Session manager support }


{ DOSSTARTSESSION data structure definition }


Type
  STARTDATA = Record
    Length,                             { length of data structure in bytes }
    Related,                            { 0 = independent session, 1 = child session }
    FgBg,                               { 0 = start in foreground, 1 = start in background }
    TraceOpt: USHORT;                   { 0 = no trace, 1 = trace }
    PgmTitle,                           { address of program title }
    PgmName: PSZ;                       { address of program name }
    PgmInputs,                          { input arguments }
    TermQ,                              { address of program queue name }
    Environment: PBYTE;                 { environment string }
    InheritOpt,                         { where are handles and environment inherited from }
                                        { 0 = inherit from shell , 1 = inherit from caller }
    SessionType: USHORT;                { session type }
    IconFile: PSZ;                      { address of icon definition }
    PgmHandle: ULONG;                   { program handle }
    PgmControl,                         { initial state of windowed application }
    InitXPos,                           { x coordinate of initial session window }
    InitYPos,                           { y coordinate of initial session window }
    InitXSize,                          { initial size of x }
    InitYSize: USHORT                   { initial size of y }
  End;
  pSTARTDATA = ^STARTDATA;


{ DOSSETSESSION data structure definition }

  STATUSDATA = Record
    Length,                             { length of this data structure }
    SelectInd,                          { 0=leave setting unchanged, 1=selectable }{ 2=non-selectable }
    BondInd: USHORT                     { which session to bring to foreground }
  End;
  pSTATUSDATA = ^STATUSDATA;


{ DOSSMREGISTERDD data structure definition }

  REGISTERDATA = Record
    Length,                             { length of this data structure }
    NotifType: USHORT;                  { type of notification }
    DDName: PCHAR                       { device driver name }
  End;
  pREGISTERDATA =^REGISTERDATA;


{** DosStartSession - Start session
 *
 *   Provides an application program interface to start another session and
 *   specify the name of the program to start in the session.
 *
 }

  Function DosStartSession (pstdata: PSTARTDATA;            { start session data structure }
                            pidSession,                     { session ID (returned) }
                            ppid: PUSHORT): USHORT;                  { process ID (returned)              }


{**   DosSetSession - Set session status
 *
 *     Sets the status of a child session.
 *
 }

  Function DosSetSession (idSession: USHORT;                { session ID }
                          pstsdata: PSTATUSDATA): USHORT;          { session status data structure      }


{**   DosSelectSession - Select foreground session
 *
 *     Allows a parent session to switch one of its child sessions to the
 *     foreground
 *
 }

  Function DosSelectSession (idSession: USHORT;             { session ID }
                             usReserved: ULONG): USHORT;              { reserved (must be 0)               }


{**   DosStopSession - Stop session
 *
 *     Terminates a session previously started with DosStartSession.
 *
 }

  Function DosStopSession (fScope,                          { target option }
                           isSession: USHORT;               { session ID }
                           ulReserved: ULONG): USHORT;              { reserved (must be 0)               }


{**   DosSmRegisterDD - Register device driver
 *
 *     Allows a device driver to receive session switch notification.
 *
 }

  Function DosSmRegisterDD (pregdata: PREGISTERDATA): USHORT;        { register data structure            }


{**   DosQAppType - Return the application type of an executable file }

  Function DosQAppType (pszPrgName: PSZ;                    { file name of executable file }
                        pusType: PUSHORT): USHORT;               { application type                   }

{** Device support }

{**   DosDevConfig - Get device configuration
 *
 *     Gets information about attached devices.
 *
 }

  Function DosDevConfig (pDevInfo: PVOID;                   { returned information }
                         usItem,                            { what device information is needed }
                         usReserved: USHORT): USHORT;             { reserved, should be set to 0       }


{**   DosDevIOCtl - I/O control for devices
 *
 *     Performs control functions on a device specified by an opened device
 *     handle.
 *
 }

  Function DosDevIOCtl (pData,                              { data area }
                        pParms: PVOID;                      { command specific argument list }
                        usFun,                              { device specific function code }
                        usCategory: USHORT;                 { device category }
                        hDev: HFILE): USHORT;                    { device handle                      }

{**    DosDevIOCtl2 - Perform Control Functions Directly On Device, with lengths
 *
 *      Control functions on the device specified by the opened
 *      handle
 }

  Function DosDevIOCtl2 (pData: PVOID;                      { Data area }
                         cbData: USHORT;                    { Length of data area }
                         pParm: PVOID;                      { Command-specific argument list }
                         cbParm,                            { Length of argument list }
                         usFun,                             { Device-specific function code }
                         usCategory: USHORT;                { Device category }
                         hDev: HFILE): USHORT;                    { Device handle returned by Open }

{**   DosCLIAccess - Request CLI/STI privilege
 *
 *     Requests I/O privilege for disabling and enabling interrupts. Access to
 *     ports must be granted via DosPortAccess.
 *
 }

  Function DosCLIAccess: USHORT;



{**   DosPortAccess - Request port access
 *
 *     Requests or releases access to ports for I/O privilege.
 *
 }

  Function DosPortAccess (usReserved,                       { reserved (must be set to 0) }
                          fRelease,                         { 0=request access, 1=release access }
                          usFirstPort,                      { first port number }
                          usLastPort: USHORT): USHORT;             { last port number                   }


{**   DosPhysicalDisk - Partitionable disk support
 *
 *     Obtains information on partitionable disks.
 *
 }

  Function DosPhysicalDisk (usFun: USHORT;                  { type of information to obtain }
                            pOut: PBYTE;                    { pointer to return buffer }
                            cbOut: USHORT;                  { return buffer length }
                            pParm: PBYTE;                   { pointer to user-supplied information }
                            cbParm: USHORT): USHORT;               { length of user-supplied information  }


{**   DosR2StackRealloc - Reallocate ring 2 stack
 *
 *     Changes the size of a thread's ring 2 stack
 *
 }

  Function DosR2StackRealloc (cbStack: USHORT): USHORT;                { ring 2 stack's new size in bytes }


{**   DosCallback Ring 2 call to ring 3 routine
 *
 *     Provided so a Ring 2 IOPL segment can call a Ring 3 allocation segment.
 *
 }

  Procedure DosCallback (pfn: PFN); { Address of the ring 3 routine }
                                    { to be called                  }
Type
  HPIPE = SHANDLE;
  pHPIPE = ^HPIPE;


Type
  AVAILDATA = Record                    { PeekNMPipe Bytes Available record  }
    cbpipe,                             { bytes left in the pipe }
    cbmessage: USHORT                   { bytes left in current message }
  End;
  pAVAILDATA = ^AVAILDATA;

{** DosCallNmPipe - Procedure call transaction
 *
 *   Performs a procedure call transaction using a message pipe.
 *
 }

  Function DosCallNmPipe (pszName: PSZ;                     { Name of the pipe to be opened }
                          pInBuf: PBYTE;                    { Address of the buffer to write to the pipe }
                          cbInBuf: USHORT;                  { Number of bytes to be written }
                          pbOutBuf: PBYTE;                  { Address of the buffer for returned data }
                          cbOutBuf: USHORT;                 { Maximum size (in bytes) of returned data }
                          pcbRead: PUSHORT;                 { Number of bytes actually read (returned) }
                          ulTimeOut: ULONG): USHORT;       { Maximum wait time                          }

{** DosConnectNmPipe - Connect named pipe
 *
 *   Enables a new client to obtain handle-based access to a named pipe
 *   through DosOpen.
 *
 }

  Function DosConnectNmPipe (hp: HPIPE): USHORT;                      { Pipe Handle                        }

{** DosDisConnectNmPipe - Disconnect named pipe
 *
 *   Forces a named pipe to close.
 *
 }

  Function DosDisConnectNmPipe (hp: HPIPE): USHORT;                      { Pipe Handle                        }

{** DosMakeNmPipe - Create a named pipe
 *
 *   Creates the specified named pipe and returns its handle.
 *
 }

  Function DosMakeNmPipe (pszName: PSZ;                     { Pipe Name }
                          php: PHPIPE;                      { Returned pipe handle }
                          fsOpenMode,                       { DOS open mode of pipe }
                          fsPipeMode,                       { Pipe open mode }
                          cbOutBuf,                         { Advisory outgoing buffer size }
                          cbInBuf: USHORT;                  { Advisory incoming buffer size }
                          ulTimeOut: ULONG): USHORT;               { Timeout for DosWaitNmPipe          }

{** DosPeekNmPipe - Peek named pipe
 *
 *   Reads pipe without removing the read data from the pipe
 *
 }

  Function DosPeekNmPipe (hp: HPIPE;                        { Pipe handle }
                          pBuf: PBYTE;                      { Address of user buffer }
                          cbBuf: USHORT;                    { Buffer length }
                          pcbRead: PUSHORT;                 { Bytes read }
                          pAvail: PAVAILDATA;               { Bytes available }
                          pfsState: PUSHORT): USHORT;              { Pipe state                         }

{** DosQNmPHandState - Query named pipe state
 *
 *   Returns information for a named pipe's specific handle state.
 *
 }

  Function DosQNmPHandState (hp: HPIPE;                     { Pipe handle }
                             pfsState: PUSHORT): USHORT;              { Pipe handle state                  }

{** DosQNmPipeInfo - Query named pipe info
 *
 *   Returns information for a named pipe
 *
 }

  Function DosQNmPipeInfo (hp: HPIPE;                       { Pipe handle }
                           usInfoLevel: USHORT;             { Pipe data required }
                           pBuf: PBYTE;                     { Pipe data buffer }
                           cb: USHORT): USHORT;                     { Pipe data buffer size              }

{** DosQNmPipeSemState - Query named pipe operations
 *
 *   Returns information about named pipes attached to a specific system
 *   semaphore
 *
 }

  Function DosQNmPipeSemState (hsem: HSEM;                  { Semaphore handle }
                               pBuf: PBYTE;                 { Address of returned info }
                               cb: USHORT): USHORT;                     { Length of InfoBuff                 }



{** DosSetNmPHandState - Set named pipe handle state
 *
 *   Returns information about named pipes specific handle state.
 *
 }

  Function DosSetNmPHandState (hp: HPIPE;                   { Pipe handle }
                               fsState: USHORT): USHORT;                { Pipe handle state                  }

  Function DosSetNmPipeSem (hp: HPIPE;                      { File handle }
                            hsem: HSEM;                     { Semaphore handle }
                            usKeyVal: USHORT): USHORT;               { Key              }

{** DosTransactNmPipe - Perform transaction
 *
 *   Performs a transaction, write followed by a read, on a message pipe.
 *
 }

  Function DosTransactNmPipe (hp: HPIPE;                    { Pipe handle }
                              pOutBuf: PBYTE;               { Write buffer address }
                              cbOut: USHORT;                { Write buffer length }
                              pInBuf: PBYTE;                { Read buffer address }
                              cbIn: USHORT;                 { Read buffer length }
                              pcbRead: PUSHORT): USHORT;               { Bytes read (returned)              }

{** DosWaitNmPipe - Wait named pipe instance
 *
 *   Waits for the availability of a named pipe instance.
 *
 }

  Function DosWaitNmPipe (pszName: PSZ;                     { Pipe name }
                          ulTimeOut: ULONG): USHORT;               { Maximum wait time                  }


{** Data structures and equates used with named pipes **}


Var
  npi_data1: Record                    { PipeInfo data block (returned, level 1) }
    npi_obuflen,                        { length of outgoing I/O buffer }
    npi_ibuflen: USHORT;                { length of incoming I/O buffer }
    npi_maxicnt,                        { maximum number of instances }
    npi_curicnt,                        { current number of instances }
    npi_namlen: UCHAR;                  { length of pipe name }
    npi_name: Array[0..0] Of Char       { start of name }
  End;

  npss: Record                         { QNmPipeSemState information record }
    npss_status,                        { type of record, 0=EOI, 1=read ok, }{   2 = write ok, 3 = pipe closed }
    npss_flag: UCHAR;                   { additional info, 01=waiting thread }
    npss_key,                           { user's key value }
    npss_avail: USHORT                  { available data/space if status=1/2 }
  End;

{ values in npss_status }

Const
  NPSS_EOI                         = 0;                     { End Of Information    }
  NPSS_RDATA                       = 1;                     { read data available   }
  NPSS_WSPACE                      = 2;                     { write space available }
  NPSS_CLOSE                       = 3;                     { pipe in CLOSING state }

{ values in npss_flag }
  NPSS_WAIT                        =  $01;                  { waiting thread on other end of pipe }

{ defined bits in pipe mode }
  NP_NBLK                          =  $8000;                { non-blocking read/write }
  NP_SERVER                        =  $4000;                { set if server end       }
  NP_WMESG                         =  $0400;                { write messages          }
  NP_RMESG                         =  $0100;                { read as messages        }
  NP_ICOUNT                        =  $00FF;                { instance count field    }


{ Named pipes may be in one of several states depending on the actions
 * that have been taken on it by the server end and client end.  The
 * following state/action table summarizes the valid state transitions:
 *
 * Current state   Action                 Next state
 *
 *  <none>         server DosMakeNmPipe   DISCONNECTED
 *  DISCONNECTED   server connect         LISTENING
 *  LISTENING      client open            CONNECTED
 *  CONNECTED      server disconn         DISCONNECTED
 *  CONNECTED      client close           CLOSING
 *  CLOSING        server disconn         DISCONNECTED
 *  CONNECTED      server close           CLOSING
 *  <any other>    server close           <pipe deallocated>
 *
 * If a server disconnects his end of the pipe, the client end will enter a
 * special state in which any future operations
 * descriptor associated with the pipe will return an error.
 }

{
 * Values for named pipe state
 }

  NP_DISCONNECTED                  = 1;                     { after pipe creation or Disconnect }
  NP_LISTENING                     = 2;                     { after DosNmPipeConnect            }
  NP_CONNECTED                     = 3;                     { after Client open                 }
  NP_CLOSING                       = 4;                     { after Client or Server close      }


{** DosPFSActivate - Activate font
 *
 *   Specifies the code page and font to make active for the specified printer
 *   and Process ID
 *
 }

  Function DosPFSActivate (hspl: PVOID;                     { Temporary spool file handle }
                           pfnAct: PULONG;                  { Number of bytes written (returned) }
                           pszPName: PSZ;                   { Printer name string }
                           usCodePage,                      { Code page to make active }
                           usFontId,                        { Font ID to make active }
                           usSFN: USHORT;                   { System file number }
                           ulReserved: ULONG): USHORT;              { Reserved, set to 0                 }

{** DosPFSCloseUser - Close Font User Interface
 *
 *   Indicates to the Font Switcher that the specified process has closed its
 *   spool file. The font Switcher may then free any resources being used to
 *   track code page and font switching for a process.
 *
 }

  Function DosPFSCloseUser (pszPName: PSZ;                  { Printer name string }
                            usSFN: USHORT;                  { System file number }
                            ulReserved: ULONG): USHORT;              { Reserved, set to 0                 }

{** DosPFSInit - Initialize code page and fpnt
 *
 *   Allows the FontSwitcher ti initialize code page and font switching for a
 *   specified printer.
 *
 }

  Function DosPFSInit (pusHdw: PUSHORT;                     { Hdw font definition list }
                       pszFontPath,                         { File pathname of the font }{ file to use }
                       pszPType,                            { Printer type string }
                       pszPName: PSZ;                       { Printer name string }
                       usSpool: USHORT;                     { Number of spool instances }
                       ulReserved: ULONG): USHORT;              { Reserved                           }

{** DosPFSQueryAct - Query active font
 *
 *   Queries the active code page and font for the specified printer and
 *   Process ID.
 *
 }


  Function DosPFSQueryAct (pszPname: PSZ;                   { Printer name string }
                           pusCodePage,                     { Code page return }
                           pusFontId: PUSHORT;              { Font ID return }
                           usSFN: USHORT;                   { System file number }
                           ulReserved: ULONG): USHORT;              { Reserved, set to 0                 }

{** DosPFSVerifyFont - Verify font
 *
 *   Indicates whether the specified code page and font within that code page
 *   are available in the font file for the specified printer.
 *
 }

  Function DosPFSVerifyFont (pszPName: PSZ;                 { Printer name string }
                             usCodePage,                    { Code page to validate }
                             usFontId: USHORT;              { Font ID to validate }
                             ulReserved: ULONG): USHORT;              { Reserved, set to 0                 }


{** DosPFS API Support }







{** DosProfile API support }


{ DosProfile ordinal number }


Const
  PROF_ORDINAL            = 133;

{ DosProfile usType }

  PROF_SYSTEM                      = 0;
  PROF_USER                        = 1;
  PROF_USEDD                       = 2;
  PROF_KERNEL                      = 4;
  PROF_VERBOSE                     = 8;
  PROF_ENABLE                      = 16;

{ DosProfile usFunc }

  PROF_ALLOC                       = 0;
  PROF_CLEAR                       = 1;
  PROF_ON                          = 2;
  PROF_OFF                         = 3;
  PROF_DUMP                        = 4;
  PROF_FREE                        = 5;

{ DosProfile tic count granularity}
  PROF_SHIFT                       = 2;

{ DosProfile module name string length }
  PROF_MOD_NAME_SIZE               = 10;

{ DosProfile error code for end of data }
  PROF_END_OF_DATA                 = 13;

Implementation
  Function DosAllocHuge;                  External 'DOSCALLS' Index   40;
  Function DosAllocSeg;                   External 'DOSCALLS' Index   34;
  Function DosAllocShrSeg;                External 'DOSCALLS' Index   35;
  Function DosBeep;                       External 'DOSCALLS' Index   50;
  Function DosBufReset;                   External 'DOSCALLS' Index   56;
  Function DosCLIAccess;                  External 'DOSCALLS' Index   51;
  Function DosCallNmPipe;                 External 'NAMPIPES' Index   10;
  Procedure DosCallback;                  External 'DOSCALLS' Index  157;
  Function DosCaseMap;                    External 'NLS'      Index    1;
  Function DosChDir;                      External 'DOSCALLS' Index   57;
  Function DosChgFilePtr;                 External 'DOSCALLS' Index   58;
  Function DosClose;                      External 'DOSCALLS' Index   59;
  Function DosCloseQueue;                 External 'QUECALLS' Index    3;
  Function DosCloseSem;                   External 'DOSCALLS' Index   23;
  Function DosConnectNmPipe;              External 'NAMPIPES' Index    3;
  Function DosCopy;                       External 'DOSCALLS' Index  201;
  Function DosCreateCSAlias;              External 'DOSCALLS' Index   43;
  Function DosCreateQueue;                External 'QUECALLS' Index    8;
  Function DosCreateSem;                  External 'DOSCALLS' Index   24;
  Function DosCreateThread;               External 'DOSCALLS' Index  145;
  Function DosCwait;                      External 'DOSCALLS' Index    2;
  Function DosDelete;                     External 'DOSCALLS' Index   60;
  Function DosDevConfig;                  External 'DOSCALLS' Index   52;
  Function DosDevIOCtl;                   External 'DOSCALLS' Index   53;
  Function DosDevIOCtl2;                  External 'DOSCALLS' Index   99;
  Function DosDisConnectNmPipe;           External 'NAMPIPES' Index    4;
  Function DosDupHandle;                  External 'DOSCALLS' Index   61;
  Function DosEditName;                   External 'DOSCALLS' Index  191;
  Function DosEnterCritSec;               External 'DOSCALLS' Index    3;
  Function DosEnumAttribute;              External 'DOSCALLS' Index  204;
  Function DosErrClass;                   External 'DOSCALLS' Index  139;
  Function DosError;                      External 'DOSCALLS' Index  120;
  Function DosExecPgm;                    External 'DOSCALLS' Index  144;
  Procedure DosExit;                      External 'DOSCALLS' Index    5;
  Function DosExitCritSec;                External 'DOSCALLS' Index    6;
  Function DosExitList;                   External 'DOSCALLS' Index    7;
  Function DosFSAttach;                   External 'DOSCALLS' Index  181;
  Function DosFSCtl;                      External 'DOSCALLS' Index  183;
  Function DosFSRamSemClear;              External 'DOSCALLS' Index  162;
  Function DosFSRamSemRequest;            External 'DOSCALLS' Index  161;
  Function DosFileIO;                     External 'DOSCALLS' Index  186;
  Function DosFileLocks;                  External 'DOSCALLS' Index   62;
  Function DosFindClose;                  External 'DOSCALLS' Index   63;
  Function DosFindFirst;                  External 'DOSCALLS' Index   64;
  Function DosFindFirst2;                 External 'DOSCALLS' Index  184;
  Function DosFindNext;                   External 'DOSCALLS' Index   65;
  Function DosFindNotifyClose;            External 'DOSCALLS' Index  187;
  Function DosFindNotifyFirst;            External 'DOSCALLS' Index  188;
  Function DosFindNotifyNext;             External 'DOSCALLS' Index  189;
  Function DosFlagProcess;                External 'DOSCALLS' Index   15;
  Function DosFreeModule;                 External 'DOSCALLS' Index   46;
  Function DosFreeResource;               External 'DOSCALLS' Index  208;
  Function DosFreeSeg;                    External 'DOSCALLS' Index   39;
  Function DosGetCollate;                 External 'NLS'      Index    2;
  Function DosGetCp;                      External 'DOSCALLS' Index  130;
  Function DosGetCtryInfo;                External 'NLS'      Index    3;
  Function DosGetDBCSEv;                  External 'NLS'      Index    4;
  Function DosGetDateTime;                External 'DOSCALLS' Index   33;
  Function DosGetEnv;                     External 'DOSCALLS' Index   91;
  Function DosGetHugeShift;               External 'DOSCALLS' Index   41;
  Function DosGetInfoSeg;                 External 'DOSCALLS' Index    8;
  Function DosGetMachineMode;             External 'DOSCALLS' Index   49;
  Function DosGetMessage; Begin {IndexNotFound('DosGetMessage')} End;
  Function DosGetModHandle;               External 'DOSCALLS' Index   47;
  Function DosGetModName;                 External 'DOSCALLS' Index   48;
  Function DosGetPID;                     External 'DOSCALLS' Index   94;
  Function DosGetPPID;                    External 'DOSCALLS' Index  156;
  Function DosGetProcAddr;                External 'DOSCALLS' Index   45;
  Function DosGetPrty;                    External 'DOSCALLS' Index    9;
  Function DosGetResource;                External 'DOSCALLS' Index  155;
  Function DosGetResource2;               External 'DOSCALLS' Index  207;
  Function DosGetSeg;                     External 'DOSCALLS' Index  121;
  Function DosGetShrSeg;                  External 'DOSCALLS' Index   36;
  Function DosGetVersion;                 External 'DOSCALLS' Index   92;
  Function DosGiveSeg;                    External 'DOSCALLS' Index   37;
  Function DosHoldSignal;                 External 'DOSCALLS' Index   13;
  Function DosInsMessage;                 External 'MSG'      Index    3;
  Function DosKillProcess;                External 'DOSCALLS' Index   10;
  Function DosLoadModule;                 External 'DOSCALLS' Index   44;
  Function DosLockSeg;                    External 'DOSCALLS' Index  122;
  Function DosMakeNmPipe;                 External 'NAMPIPES' Index    1;
  Function DosMakePipe;                   External 'DOSCALLS' Index   16;
  Function DosMemAvail;                   External 'DOSCALLS' Index  127;
  Function DosMkDir;                      External 'DOSCALLS' Index   66;
  Function DosMkDir2;                     External 'DOSCALLS' Index  185;
  Function DosMonClose;                   External 'MONCALLS' Index    3;
  Function DosMonOpen;                    External 'MONCALLS' Index    4;
  Function DosMonRead;                    External 'MONCALLS' Index    2;
  Function DosMonReg;                     External 'MONCALLS' Index    5;
  Function DosMonWrite;                   External 'MONCALLS' Index    1;
  Function DosMove;                       External 'DOSCALLS' Index   67;
  Function DosMuxSemWait;                 External 'DOSCALLS' Index   22;
  Function DosNewSize;                    External 'DOSCALLS' Index   68;
  Function DosOpen;                       External 'DOSCALLS' Index   70;
  Function DosOpen2;                      External 'DOSCALLS' Index   95;
  Function DosOpenQueue;                  External 'QUECALLS' Index    7;
  Function DosOpenSem;                    External 'DOSCALLS' Index   25;
  Function DosPFSActivate;                External 'SPOOLCP'  Index    4;
  Function DosPFSCloseUser;               External 'SPOOLCP'  Index    1;
  Function DosPFSInit;                    External 'SPOOLCP'  Index    3;
  Function DosPFSQueryAct;                External 'SPOOLCP'  Index    2;
  Function DosPFSVerifyFont;              External 'SPOOLCP'  Index    5;
  Function DosPeekNmPipe;                 External 'NAMPIPES' Index    7;
  Function DosPeekQueue;                  External 'QUECALLS' Index    5;
  Function DosPhysicalDisk;               External 'DOSCALLS' Index  129;
  Function DosPortAccess;                 External 'DOSCALLS' Index   69;
  Function DosPtrace;                     External 'DOSCALLS' Index   12;
  Function DosPurgeQueue;                 External 'QUECALLS' Index    2;
  Function DosPutMessage;                 External 'MSG'      Index    1;
  Function DosQAppType;                   External 'DOSCALLS' Index  163;
  Function DosQCurDir;                    External 'DOSCALLS' Index   71;
  Function DosQCurDisk;                   External 'DOSCALLS' Index   72;
  Function DosQFHandState;                External 'DOSCALLS' Index   73;
  Function DosQFSAttach;                  External 'DOSCALLS' Index  182;
  Function DosQFSInfo;                    External 'DOSCALLS' Index   76;
  Function DosQFileInfo;                  External 'DOSCALLS' Index   74;
  Function DosQFileMode;                  External 'DOSCALLS' Index   75;
  Function DosQHandType;                  External 'DOSCALLS' Index   77;
  Function DosQNmPHandState;              External 'NAMPIPES' Index    5;
  Function DosQNmPipeInfo;                External 'NAMPIPES' Index    2;
  Function DosQNmPipeSemState;            External 'NAMPIPES' Index   14;
  Function DosQPathInfo;                  External 'DOSCALLS' Index   98;
  Function DosQSysInfo;                   External 'DOSCALLS' Index  166;
  Function DosQVerify;                    External 'DOSCALLS' Index   78;
  Function DosQueryQueue;                 External 'QUECALLS' Index    4;
  Function DosR2StackRealloc;             External 'DOSCALLS' Index  160;
  Function DosRead;                       External 'DOSCALLS' Index  137;
  Function DosReadAsync;                  External 'DOSCALLS' Index  149;
  Function DosReadQueue;                  External 'QUECALLS' Index    1;
  Function DosReallocHuge;                External 'DOSCALLS' Index   42;
  Function DosReallocSeg;                 External 'DOSCALLS' Index   38;
  Function DosResumeThread;               External 'DOSCALLS' Index   26;
  Function DosRmDir;                      External 'DOSCALLS' Index   80;
  Function DosScanEnv;                    External 'DOSCALLS' Index  152;
  Function DosSearchPath;                 External 'DOSCALLS' Index  151;
  Function DosSelectDisk;                 External 'DOSCALLS' Index   81;
  Function DosSelectSession;              External 'SESMGR'   Index    9;
  Function DosSemClear;                   External 'DOSCALLS' Index  141;
  Function DosSemRequest;                 External 'DOSCALLS' Index  140;
  Function DosSemSet;                     External 'DOSCALLS' Index  143;
  Function DosSemSetWait;                 External 'DOSCALLS' Index   20;
  Function DosSemWait;                    External 'DOSCALLS' Index  142;
  Function DosSendSignal;                 External 'DOSCALLS' Index  134;
  Function DosSetCp;                      External 'DOSCALLS' Index  153;
  Function DosSetDateTime;                External 'DOSCALLS' Index   28;
  Function DosSetFHandState;              External 'DOSCALLS' Index   82;
  Function DosSetFSInfo;                  External 'DOSCALLS' Index   97;
  Function DosSetFileInfo;                External 'DOSCALLS' Index   83;
  Function DosSetFileMode;                External 'DOSCALLS' Index   84;
  Function DosSetMaxFH;                   External 'DOSCALLS' Index   85;
  Function DosSetNmPHandState;            External 'NAMPIPES' Index    6;
  Function DosSetNmPipeSem;               External 'NAMPIPES' Index   13;
  Function DosSetPathInfo;                External 'DOSCALLS' Index  104;
  Function DosSetProcCp;                  External 'DOSCALLS' Index  164;
  Function DosSetPrty;                    External 'DOSCALLS' Index   11;
  Function DosSetSession;                 External 'SESMGR'   Index   14;
  Function DosSetSigHandler;              External 'DOSCALLS' Index   14;
  Function DosSetVec;                     External 'DOSCALLS' Index   89;
  Function DosSetVerify;                  External 'DOSCALLS' Index   86;
  Function DosShutdown;                   External 'DOSCALLS' Index  206;
  Function DosSizeSeg;                    External 'DOSCALLS' Index  126;
  Function DosSleep;                      External 'DOSCALLS' Index   32;
  Function DosSmRegisterDD;               External 'SESMGR'   Index   29;
  Function DosStartSession;               External 'SESMGR'   Index   17;
  Function DosStopSession;                External 'SESMGR'   Index    8;
  Function DosSubAlloc;                   External 'DOSCALLS' Index  147;
  Function DosSubFree;                    External 'DOSCALLS' Index  148;
  Function DosSubSet;                     External 'DOSCALLS' Index  146;
  Function DosSuspendThread;              External 'DOSCALLS' Index   27;
  Function DosTimerAsync;                 External 'DOSCALLS' Index   29;
  Function DosTimerStart;                 External 'DOSCALLS' Index   30;
  Function DosTimerStop;                  External 'DOSCALLS' Index   31;
  Function DosTransactNmPipe;             External 'NAMPIPES' Index    9;
  Function DosUnlockSeg;                  External 'DOSCALLS' Index  123;
  Function DosWaitNmPipe;                 External 'NAMPIPES' Index    8;
  Function DosWrite;                      External 'DOSCALLS' Index  138;
  Function DosWriteAsync;                 External 'DOSCALLS' Index  150;
  Function DosWriteQueue;                 External 'QUECALLS' Index    6;
End.

WriteLn('Verify BseDos');
veri('AVAILDATA                          ',sizeof(AVAILDATA                          ));
veri('COUNTRYCODE                        ',sizeof(COUNTRYCODE                        ));
veri('COUNTRYINFO                        ',sizeof(COUNTRYINFO                        ));
veri('DATETIME                           ',sizeof(DATETIME                           ));
veri('DENA1                              ',sizeof(DENA1                              ));
veri('DOSFSRSEM                          ',sizeof(DOSFSRSEM                          ));
veri('EAOP                               ',sizeof(EAOP                               ));
veri('FDATE                              ',sizeof(FDATE                              ));
veri('FEA                                ',sizeof(FEA                                ));
veri('FEALIST                            ',sizeof(FEALIST                            ));
veri('FILEFINDBUF                        ',sizeof(FILEFINDBUF                        ));
veri('FILEFINDBUF2                       ',sizeof(FILEFINDBUF2                       ));
veri('FILELOCK                           ',sizeof(FILELOCK                           ));
veri('FILESTATUS                         ',sizeof(FILESTATUS                         ));
veri('FILESTATUS2                        ',sizeof(FILESTATUS2                        ));
veri('FIOLOCKCMD                         ',sizeof(FIOLOCKCMD                         ));
veri('FIOLOCKREC                         ',sizeof(FIOLOCKREC                         ));
veri('FIOREADWRITE                       ',sizeof(FIOREADWRITE                       ));
veri('FIOSEEKCMD                         ',sizeof(FIOSEEKCMD                         ));
veri('FIOUNLOCKCMD                       ',sizeof(FIOUNLOCKCMD                       ));
veri('FIOUNLOCKREC                       ',sizeof(FIOUNLOCKREC                       ));
veri('FSALLOCATE                         ',sizeof(FSALLOCATE                         ));
veri('FSINFO                             ',sizeof(FSINFO                             ));
veri('FSQBUFFER                          ',sizeof(FSQBUFFER                          ));
veri('FTIME                              ',sizeof(FTIME                              ));
veri('GEA                                ',sizeof(GEA                                ));
veri('GEALIST                            ',sizeof(GEALIST                            ));
veri('GINFOSEG                           ',sizeof(GINFOSEG                           ));
veri('LINFOSEG                           ',sizeof(LINFOSEG                           ));
veri('MUXSEM                             ',sizeof(MUXSEM                             ));
veri('MUXSEMLIST                         ',sizeof(MUXSEMLIST                         ));
veri('PIDINFO                            ',sizeof(PIDINFO                            ));
veri('REGISTERDATA                       ',sizeof(REGISTERDATA                       ));
veri('RESULTCODES                        ',sizeof(RESULTCODES                        ));
veri('STARTDATA                          ',sizeof(STARTDATA                          ));
veri('STATUSDATA                         ',sizeof(STATUSDATA                         ));
veri('VOLUMELABEL                        ',sizeof(VOLUMELABEL                        ));

printf("Verify BseDos\n");
veri("AVAILDATA                          ",sizeof(AVAILDATA                          ));
veri("COUNTRYCODE                        ",sizeof(COUNTRYCODE                        ));
veri("COUNTRYINFO                        ",sizeof(COUNTRYINFO                        ));
veri("DATETIME                           ",sizeof(DATETIME                           ));
veri("DENA1                              ",sizeof(DENA1                              ));
veri("DOSFSRSEM                          ",sizeof(DOSFSRSEM                          ));
veri("EAOP                               ",sizeof(EAOP                               ));
veri("FDATE                              ",sizeof(FDATE                              ));
veri("FEA                                ",sizeof(FEA                                ));
veri("FEALIST                            ",sizeof(FEALIST                            ));
veri("FILEFINDBUF                        ",sizeof(FILEFINDBUF                        ));
veri("FILEFINDBUF2                       ",sizeof(FILEFINDBUF2                       ));
veri("FILELOCK                           ",sizeof(FILELOCK                           ));
veri("FILESTATUS                         ",sizeof(FILESTATUS                         ));
veri("FILESTATUS2                        ",sizeof(FILESTATUS2                        ));
veri("FIOLOCKCMD                         ",sizeof(FIOLOCKCMD                         ));
veri("FIOLOCKREC                         ",sizeof(FIOLOCKREC                         ));
veri("FIOREADWRITE                       ",sizeof(FIOREADWRITE                       ));
veri("FIOSEEKCMD                         ",sizeof(FIOSEEKCMD                         ));
veri("FIOUNLOCKCMD                       ",sizeof(FIOUNLOCKCMD                       ));
veri("FIOUNLOCKREC                       ",sizeof(FIOUNLOCKREC                       ));
veri("FSALLOCATE                         ",sizeof(FSALLOCATE                         ));
veri("FSINFO                             ",sizeof(FSINFO                             ));
veri("FSQBUFFER                          ",sizeof(FSQBUFFER                          ));
veri("FTIME                              ",sizeof(FTIME                              ));
veri("GEA                                ",sizeof(GEA                                ));
veri("GEALIST                            ",sizeof(GEALIST                            ));
veri("GINFOSEG                           ",sizeof(GINFOSEG                           ));
veri("LINFOSEG                           ",sizeof(LINFOSEG                           ));
veri("MUXSEM                             ",sizeof(MUXSEM                             ));
veri("MUXSEMLIST                         ",sizeof(MUXSEMLIST                         ));
veri("PIDINFO                            ",sizeof(PIDINFO                            ));
veri("REGISTERDATA                       ",sizeof(REGISTERDATA                       ));
veri("RESULTCODES                        ",sizeof(RESULTCODES                        ));
veri("STARTDATA                          ",sizeof(STARTDATA                          ));
veri("STATUSDATA                         ",sizeof(STATUSDATA                         ));
veri("VOLUMELABEL                        ",sizeof(VOLUMELABEL                        ));
