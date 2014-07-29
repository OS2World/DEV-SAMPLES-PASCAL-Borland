Unit os2;

Interface

Function DosClose( handle : word ): word; Far;

function DosOpen ( name:pchar; var Handle : word; Var Action : word;
                   Filesize : longint; Attrib : word; OpenFlag : word;
                   openmode : word; reserved : longint):word;
                   Far;
Function DosRead (     Handle: word; Var buffer; bufferlen : word;
                   Var BytesRead :word): word;
                   Far;

Function DosWrite(     Handle: word; Var Buffer; bufferlen : word;
                   Var BytesWrote : word ):word;
                   Far;


Function DosMakeNMPipe(    pipename : pchar;
                       var PipeHandle : word;
                           Openmode   : word;
                           Pipemode   : word;
                           OutBufSize : word;
                           inbufsize  : word;
                           timeout    : longint ):word; Far;

Function DosConnectNMPipe( pipehandle : word ):word; Far;

Function DosDisconnectNMpipe( pipehandle : word ):word; Far;

Function DosQNMPipeInfo ( Pipehandle : word; mode : word; Var buffer;
                          bufferlen : word): word; Far;
Type
   tavailStruc = Record
      Bytes_in_pipe : word;
      Bytes_in_msg  : word;
      end;

Function DosPeekNMPipe (pipehandle : word; Var Buffer; Bufferlen : word;
                        Var Bytesread : word;
                        Var availstruc : tAvailStruc;
                        Var PipeState  : word): word; Far;

Const
   cPipe_Disconnected = 1;
   cPipe_Listening    = 2;
   cPipe_Connected    = 3;
   cPipe_Closing      = 4;

Function DosSetNMPHandState ( pipehandle : word; State : word):word; far;

Function DosWaitNMPipe ( pipename : Pchar; Timeout : word):word; Far;

Function DosSleep ( milliSeconds : Longint): Word; Far;

Function DosCreateQueue( var Handle: word; Mode : word; name : pchar ): word;
         Far;

Function DosOpenQueue ( var OwnerPid: word; Var Handle : word; name : pchar)
         :word; Far;
type
  QueueRequest_record = record
     OwnerPID         : word;
     AppSpecific      : word;
     end;

function DosPeekQueue (    Handle : word;
                       Var Request: Queuerequest_record;
                       Var DataLen : word;
                       Var Dataaddr;
                       var Elementadr : word;
                           NoWait     : Word;  {byte;  }
                       var Elementpri : byte;
                           SemHandle  : Longint ):word;Far;

function dosPurgeQueue( handle : word ):word; Far;

function DosReadQueue (    Handle : word;
                       Var Request: Queuerequest_record;
                       Var DataLen : word;
                       Var Dataaddr;
                       var Elementadr : word;
                           NoWait     : Word;   {byte;}
                       var Elementpri : byte;
                           SemHandle  : Longint ):word;Far;

Function DosWriteQueue(    Handle : word;
                           Request : word;
                           Datalen : word;
                       Var Dataadr;
                           Elempri : word ):word; Far;

Function DosQueryQueue( Handle : word; Var Count : word ):word; Far;

Function DosCloseQueue( handle : word ):word; Far;

Type
   FastSafeRamSem_record = Record
      Blocklen           : word;
      Pid                : word;
      Tid                : word;
      Usage_count        : word;
      App_word           : word;
      Semiphore          : longint;
      end;

{Timeout values
   -1 = Wait indefinitely
    0 = return immediately
   >0 = Wait indicated number of milliseconds for semiphore }

Function DOSFSRAMSEMREQUEST ( var Fs      : FastSafeRamSem_record;
                                  Timeout : Longint): word; Far;

Function DOSFSRAMSEMCLEAR   ( Var FS      : FastSafeRamSem_record): word; Far;

Function DosSemSetWait      ( semHandle : Longint;
                              timeout   : longint ): word; Far;
Type
   SemList_type = record
      SemCount  : word;
      SemEntry  : array [0..255] of record
         Resrv  : word;
         SemHandle : Longint;
         end;
      end;

Function DosMuxSemWait      ( Var IndexSem : word;
                              Var SemList;  { SemList_Record }
                                  Timeout : Longint ): word; Far;

Function DosCloseSem        ( Semhandle : longint ): word; Far;

{ nonexclusive
    0 = exclusive access for creating process.
    1 = allows other processes access to the semiphore }

Function DosCreateSem       (     NonExclusive : word;
                              Var SemHandle    : Longint;
                                  Name         : pchar): word; far;

Function DosOpenSem         ( Var SemHandle    : longint;
                                  Name         : pchar): word; Far;

Function DosSemRequest      (     Semhandle    : longint;
                                  Timeout      : longint ): word; Far;

function DosSemClear        (    Semhandle     : longint ): word; Far;

Function DosSemWait         (    Semhandle     : longint;
                                 Timeout       : longint ): word; Far;

Function DosSemSet          (    Semhandle     : longint ):word; Far;

{Flags bits
  15-4 = 0;
  3    = Resizeable if Shared;
  2    = Discardable if unlocked;
  1    = shareable with Get;
  0    = Shareable with Give; }

Function DosAllocSeg        (     Size : word;
                              Var Selector : word;
                                  flags    : word ): word; Far;

Function DosAllocShrSeg     (     Size : word;
                                  Name : pchar;
                              Var Selector : word ):word; Far;

Function DosGetShrSeg       (     Name : pchar;
                              Var Selector : word ):word; Far;

Function DosGiveSeg         (    Selector : word;
                                 Target_PID : word;
                             Var Target_selector : word ):word; Far;

Function DosReAllocSeg      ( Size : word;
                              Selector : word ): word; Far;

Function DosFreeSeg         ( Selector : word ): word; Far;


Implementation

function dosClose( Handle: word):Word; External 'DOSCALLS' index 59;

function DosOpen ( name:pchar; var Handle : word; Var Action : word;
                   Filesize : longint; Attrib : word; OpenFlag : word;
                   openmode : word; reserved : longint):word;
                   External 'DOSCALLS' index 70;

Function DosRead (     Handle: word; Var buffer; bufferlen : word;
                   Var BytesRead :word): word;
                   External 'DOSCALLS' Index 137;

Function DosWrite(     Handle: word; Var Buffer; bufferlen : word;
                   Var BytesWrote : word ):word;
                   External 'DOSCALLS' Index 138;


Function DosMakeNMPipe(    pipename   : Pchar;
                       var PipeHandle : word;
                           Openmode   : word;
                           Pipemode   : word;
                           OutBufSize : word;
                           inbufsize  : word;
                           timeout    : Longint):word; External 'NAMPIPES'
                                                     Index 1;

Function DosConnectNMPipe( pipehandle : word ):word; External 'NAMPIPES'
                                                     Index 3;

Function DosDisconnectNMpipe( pipehandle : word ):word; External 'NAMPIPES'
                                                        Index 4;

Function DosQNMPipeInfo ( Pipehandle : word; mode : word; Var buffer;
                          bufferlen : word): word; External 'NAMPIPES'
                                                   index 2;

Function DosPeekNMPipe (pipehandle : word; Var Buffer; Bufferlen : word;
                        Var Bytesread : word;
                        Var availstruc : tAvailStruc;
                        Var PipeState  : word): word; External 'NAMPIPES'
                                                      index 7;

Function DosWaitNMPipe ( pipename : Pchar; Timeout : word):word;
                         External 'NAMPIPES' index 8;

Function DosSleep ( milliSeconds : Longint): Word; External 'DOSCALLS'
                                                 index 32;

Function DosSetNMPHandState ( pipehandle : word; State : word):word;
                              External 'NAMPIPES' index 6;


Function DosCreateQueue( var Handle: word; Mode : word; name : pchar ): word;
         External 'QUECALLS' Index 8;

Function DosOpenQueue ( var OwnerPid: word; Var Handle : word; name : pchar)
         :word; External 'QUECALLS' Index 7;

function DosPeekQueue (    Handle : word;
                       Var Request: Queuerequest_record;
                       Var DataLen : word;
                       Var Dataaddr;
                       var Elementadr : word;
                           NoWait     : Word;  {byte;  }
                       var Elementpri : byte;
                           SemHandle  : Longint ):word;
          External 'QUECALLS' Index 5;

function dosPurgeQueue( handle : word ):word; External 'QUECALLS' Index 2;

function DosReadQueue (    Handle : word;
                       Var Request: Queuerequest_record;
                       Var DataLen : word;
                       Var Dataaddr;
                       var Elementadr : word;
                           NoWait     : Word;   {byte;}
                       var Elementpri : byte;
                           SemHandle  : Longint ):word;
         External 'QUECALLS' Index 1;

Function DosWriteQueue(    Handle : word;
                           Request : word;
                           Datalen : word;
                       Var Dataadr;
                           Elempri : word ):word;
         External 'QUECALLS' Index 6;

Function DosQueryQueue( Handle : word; Var Count : word ):word;
         External 'QUECALLS' Index 4;

Function DosCloseQueue( handle : word ):word; External 'QUECALLS' Index 3;

Function DOSFSRAMSEMREQUEST ( var Fs      : FastSafeRamSem_record;
                                  Timeout : Longint): word;
         External 'DOSCALLS' Index 161;

Function DOSFSRAMSEMCLEAR   ( Var FS      : FastSafeRamSem_record): word;
         External 'DOSCALLS' Index 162;

Function DosSemSetWait      ( semHandle : Longint;
                              timeout   : longint ): word;
         External 'DOSCALLS' Index 20;

Function DosMuxSemWait      ( Var IndexSem : word;
                              Var SemList;  { SemList_Record }
                                  Timeout : Longint ): word;
         External 'DOSCALLS' Index  22;

Function DosCloseSem        ( Semhandle : longint ): word;
         External 'DOSCALLS' Index  23;

Function DosCreateSem       (     NonExclusive : word;
                              Var SemHandle    : Longint;
                                  Name         : pchar): word;
         External 'DOSCALLS' Index  24;

Function DosOpenSem         ( Var SemHandle    : longint;
                                  Name         : pchar): word;
         External 'DOSCALLS' Index  25;

Function DosSemRequest      (     Semhandle    : longint;
                                  Timeout      : longint ): word;
         External 'DOSCALLS' Index  140;

function DosSemClear        (    Semhandle     : longint ): word;
         External 'DOSCALLS' Index  141;

Function DosSemWait         (    Semhandle     : longint;
                                 Timeout       : longint ): word;
         External 'DOSCALLS' Index  142;

Function DosSemSet          (    Semhandle     : longint ):word;
         External 'DOSCALLS' Index  143;

{Flags bits
  15-4 = 0;
  3    = Resizeable if Shared;
  2    = Discardable if unlocked;
  1    = shareable with Get;
  0    = Shareable with Give; }

Function DosAllocSeg        (     Size : word;
                              Var Selector : word;
                                  flags    : word ): word;
         External 'DOSCALLS' Index  34;

Function DosAllocShrSeg     (     Size : word;
                                  Name : pchar;
                              Var Selector : word ):word;
         External 'DOSCALLS' Index  35;

Function DosGetShrSeg       (     Name : pchar;
                              Var Selector : word ):word;
         External 'DOSCALLS' Index  36;

Function DosGiveSeg         (    Selector : word;
                                 Target_PID : word;
                             Var Target_selector : word ):word;
         External 'DOSCALLS' Index  37;

Function DosReAllocSeg      ( Size : word;
                              Selector : word ): word;
         External 'DOSCALLS' Index  38;

Function DosFreeSeg         ( Selector : word ): word;
         External 'DOSCALLS' Index  39;

{
DOSQNMPHANDSTATE                 NAMPIPES.5
DOSSETNMPHANDSTATE               NAMPIPES.6
DOSTRANSACTNMPIPE                NAMPIPES.9
DOSCALLNMPIPE                    NAMPIPES.10
DOSRAWREADNMPIPE                 NAMPIPES.11
DOSRAWWRITENMPIPE                NAMPIPES.12
DOSSETNMPIPESEM                  NAMPIPES.13
DOSQNMPIPESEMSTATE               NAMPIPES.14
}


end.