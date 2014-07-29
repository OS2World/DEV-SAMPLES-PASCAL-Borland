{| Unit: pmstddlg
 | Version: 1.00
 | translated from file pmstddlg.H
 | Original translation: Peter Singer (PSi)
 | Contributing:
 |   (fill in)
 |
 | change history:
 | Date:    Ver: Author:
 | 11/21/93 1.00 PSi     original translation by PSi
}
Unit pmstddlg;
Interface
Uses
  PmGpi, PmWIN, Os2Def;
{**************************************************************************}
{                                                                          }
{                             IBM/Microsoft                                }
{                                                                          }
{                 Copyright (c) IBM Corporation  1987-1991                 }
{                 Copyright (c) Microsoft Corp.  1987-1991                 }
{                           All Rights Reserved                            }
{                                                                          }
{**************************************************************************}
{********************************************************************}
{                                                                    }
{ Module Name: PMSTDDLG.H                                            }
{                                                                    }
{ OS/2 Presentation Manager Standard Dialog Declarations             }
{                                                                    }
{ ===================================================================}
{ The following symbols are used in this file for conditional        }
{ sections:                                                          }
{                                                                    }
{ INCL_WINSTDSPIN               - spin button control class          }
{ INCL_WINSTDDRAG               - standard drag dll                  }
{                                                                    }
{********************************************************************}

{********************************************************************}
{                                                                    }
{                          S P I N    B U T T O N                    }
{                                                                    }
{********************************************************************}

{********************************************************************}
{ SPINBUTTON Creation Flags                                          }
{********************************************************************}

{********************************************************************}
{ Character Acceptance                                               }
{********************************************************************}

CONST
  SPBS_ALLCHARACTERS      =  $00000000 ;           { Default: All chars accepted }
  SPBS_NUMERICONLY        =  $00000040 ;           { Only 0 - 9 accepted & VKeys }
  SPBS_READONLY           =  $00000020 ;           { No chars allowed in entryfld}

{********************************************************************}
{ Type of Component                                                  }
{********************************************************************}
  SPBS_MASTER             =  $00000010 ;
  SPBS_SERVANT            =  $00000000 ;           { Default: Servant }

{********************************************************************}
{ Type of Justification                                              }
{********************************************************************}
  SPBS_JUSTDEFAULT        =  $00000000 ;           { Default: Same as Left }
  SPBS_JUSTLEFT           =  $00000000 ;
  SPBS_JUSTRIGHT          =  $00000002 ;
  SPBS_JUSTCENTER         =  $00000001 ;

{********************************************************************}
{ Border or not                                                      }
{********************************************************************}
  SPBS_NOBORDER           =  $00000200 ;           { Borderless SpinField         }
                                      { Default is to have a border. }

{********************************************************************}
{ Fast spin or not                                                   }
{********************************************************************}
  SPBS_FASTSPIN           =  $00000100;  { Allow fast spinning.  Fast   }
                                         { spinning is performed by     }
                                         { skipping over numbers        }

{********************************************************************}
{ Pad numbers on front with 0's                                      }
{********************************************************************}
  SPBS_PADWITHZEROS        =  $00000080 ; { Pad the number with zeroes   }

{********************************************************************}
{ SPINBUTTON Messages                                                }
{********************************************************************}

{********************************************************************}
{ Notification from Spinbutton to the application is sent in a       }
{ WM_CONTROL message.                                                }
{********************************************************************}
  SPBN_UPARROW               =  $20A;  { up arrow button was pressed  }
  SPBN_DOWNARROW             =  $20B;  { down arrow button was pressed}
  SPBN_ENDSPIN               =  $20C;  { mouse button was released    }
  SPBN_CHANGE                =  $20D;  { spinfield text has changed   }
  SPBN_SETFOCUS              =  $20E;  { spinfield received focus     }
  SPBN_KILLFOCUS             =  $20F;  { spinfield lost focus         }

{********************************************************************}
{ Messages from application to Spinbutton                            }
{********************************************************************}
  SPBM_OVERRIDESETLIMITS     =  $200;  { Set spinbutton limits without}
                                       {  resetting the current value }
  SPBM_QUERYLIMITS           =  $201;  { Query limits set by          }
                                       {  SPBM_SETLIMITS              }
  SPBM_SETTEXTLIMIT          =  $202;  { Max entryfield characters    }
  SPBM_SPINUP                =  $203;  { Tell entry field to spin up  }
  SPBM_SPINDOWN              =  $204;  { Tell entry field to spin down}
  SPBM_QUERYVALUE            =  $205;  { Tell entry field to send     }
                                       {  current value               }

{********************************************************************}
{ Query Flags                                                        }
{********************************************************************}
  SPBQ_UPDATEIFVALID               = 0;                     { Default                      }
  SPBQ_ALWAYSUPDATE                = 1;
  SPBQ_DONOTUPDATE                 = 3;

{********************************************************************}
{ Return value for Empty Field.                                      }
{    If ptr too long, variable sent in query msg                     }
{********************************************************************}
  SPBM_SETARRAY                    =  $206;                 { Change the data to spin      }
  SPBM_SETLIMITS                   =  $207;                 { Change the numeric Limits    }
  SPBM_SETCURRENTVALUE             =  $208;                 { Change the current value     }
  SPBM_SETMASTER                   =  $209;                 { Tell entryfield who master is}

{********************************************************************}
{ SPINBUTTON Window Class Definition                                 }
{********************************************************************}


{********************************************************************}
{                                                                    }
{                D I R E C T   M A N I P U L A T I O N               }
{                                                                    }
{********************************************************************}

  PMERR_NOT_DRAGGING               =  $1f00;     { move to pmerr.h           }
  PMERR_ALREADY_DRAGGING           =  $1f01;

  MSGF_DRAG                        =  $0010;     { message filter identifier }

  WM_DRAGFIRST                     =  $0310;
  WM_DRAGLAST                      = (WM_DRAGFIRST + $001f);

  DM_DROP                          = (WM_DRAGLAST - $0);
  DM_DRAGOVER                      = (WM_DRAGLAST - $1);
  DM_DRAGLEAVE                     = (WM_DRAGLAST - $2);
  DM_DROPHELP                      = (WM_DRAGLAST - $3);
  DM_ENDCONVERSATION               = (WM_DRAGLAST - $4);
  DM_PRINT                         = (WM_DRAGLAST - $5);
  DM_RENDER                        = (WM_DRAGLAST - $6);
  DM_RENDERCOMPLETE                = (WM_DRAGLAST - $7);
  DM_RENDERPREPARE                 = (WM_DRAGLAST - $8);
  DM_DRAGFILECOMPLETE              = (WM_DRAGLAST - $9);
  DM_EMPHASIZETARGET               = (WM_DRAGLAST - $A);
  DM_DRAGERROR                     = (WM_DRAGLAST - $B);
  DM_FILERENDERED                  = (WM_DRAGLAST - $C);
  DM_RENDERFILE                    = (WM_DRAGLAST - $D);


  DRT_ASM                         = 'Assembler Code';   { drag type constants  }
  DRT_BASIC                       = 'BASIC Code';
  DRT_BINDATA                     = 'Binary Data';
  DRT_BITMAP                      = 'Bitmap';
  DRT_C                           = 'C Code';
  DRT_COBOL                       = 'COBOL Code';
  DRT_DLL                         = 'Dynamic Link Library';
  DRT_DOSCMD                      = 'DOS Command File';
  DRT_EXE                         = 'Executable';
  DRT_FORTRAN                     = 'FORTRAN Code';
  DRT_ICON                        = 'Icon';
  DRT_LIB                         = 'Library';
  DRT_METAFILE                    = 'Metafile';
  DRT_OS2CMD                      = 'OS/2 Command File';
  DRT_PASCAL                      = 'Pascal Code';
  DRT_RESOURCE                    = 'Resource File';
  DRT_TEXT                        = 'Plain Text';
  DRT_UNKNOWN                     = 'Unknown';

  DOR_NODROP                       =  $0000;     { DM_DRAGOVER response codes }
  DOR_DROP                         =  $0001;
  DOR_NODROPOP                     =  $0002;
  DOR_NEVERDROP                    =  $0003;

  DO_COPYABLE                      =  $0001;     { supported operation flags  }
  DO_MOVEABLE                      =  $0002;

  DC_OPEN                          =  $0001;     { source control flags       }
  DC_REF                           =  $0002;
  DC_GROUP                         =  $0004;
  DC_CONTAINER                     =  $0008;
  DC_PREPARE                       =  $0010;
  DC_REMOVEABLEMEDIA               =  $0020;

  DO_DEFAULT                       =  $BFFE;     { Default operation          }
  DO_UNKNOWN                       =  $BFFF;     { Unknown operation          }
  DO_COPY                          =  KC_CTRL;
  DO_MOVE                          =  KC_ALT;

  DMFL_TARGETSUCCESSFUL            =  $0001;                { transfer reply flags       }
  DMFL_TARGETFAIL                  =  $0002;
  DMFL_NATIVERENDER                =  $0004;
  DMFL_RENDERRETRY                 =  $0008;
  DMFL_RENDEROK                    =  $0010;
  DMFL_RENDERFAIL                  =  $0020;

  DRG_ICON                         =  $00000001 ;           { drag image manipulation    }
  DRG_BITMAP                       =  $00000002 ;           {   flags                    }
  DRG_POLYGON                      =  $00000004 ;
  DRG_STRETCH                      =  $00000008 ;
  DRG_TRANSPARENT                  =  $00000010 ;
  DRG_CLOSED                       =  $00000020 ;

  DME_IGNOREABORT                  = 1;                     { DM_DRAGERROR return values }
  DME_IGNORECONTINUE               = 2;
  DME_REPLACE                      = 3;
  DME_RETRY                        = 4;

  DF_MOVE                          =  $0001;                { DM_DRAGFILECOMPLETE flags  }
  DF_SOURCE                        =  $0002;
  DF_SUCCESSFUL                    =  $0004;

  DFF_MOVE                         = 1;                     { DM_DRAGERROR operation IDs }
  DFF_COPY                         = 2;
  DFF_DELETE                       = 3;


TYPE
  HSTR = LHANDLE;  { hstr }


  DRAGITEM = Record                     { ditem }
    hwndItem: HWND;                     { conversation partner }
    ulItemID: ULONG;                    { identifies item being dragged }
    hstrType,                           { type of item }
    hstrRMF,                            { rendering mechanism and format }
    hstrContainerName,                  { name of source container }
    hstrSourceName,                     { name of item at source }
    hstrTargetName: HSTR;               { suggested name of item at dest }
    cxOffset,                           { x offset of the origin of the }
                                        {   image from the mouse hotspot }
    cyOffset: SHORT;                    { y offset of the origin of the }
                                        {   image from the mouse hotspot }
    fsControl,                          { source item control flags }
    fsSupportedOps: USHORT              { ops supported by source }
  End;
  PDRAGITEM = ^DRAGITEM;

  DRAGINFO = Record                     { dinfo }
    cbDraginfo: ULONG;                  { Size of DRAGINFO and DRAGITEMs }
    cbDragitem,                         { size of DRAGITEM }
    usOperation: USHORT;                { current drag operation }
    hwndSource: HWND;                   { window handle of source }
    xDrop,                              { x coordinate of drop position }
    yDrop: SHORT;                       { y coordinate of drop position }
    cditem,                             { count of DRAGITEMs }
    usReserved: USHORT                  { reserved for future use }
  End;
  PDRAGINFO = ^DRAGINFO;

  DRAGIMAGE = Record                    { dimg }
    cb,                                 { size control block }
    cptl: USHORT;                       { count of pts, if DRG_POLYGON }
    hImage: LHANDLE;                    { image handle passed to DrgDrag }
    sizlStretch: SIZEL;                 { size to strecth ico or bmp to }
    fl: ULONG;                          { flags passed to DrgDrag }
    cxOffset,                           { x offset of the origin of the }
                                        {   image from the mouse hotspot }
    cyOffset: SHORT                     { y offset of the origin of the }
                                        {   image from the mouse hotspot }
  End;
  PDRAGIMAGE = ^DRAGIMAGE;

  DRAGTRANSFER = Record                 { dxfer }
    cb: ULONG;                          { size of control block }
    hwndClient: HWND;                   { handle of target }
    pditem: PDRAGITEM;                  { DRAGITEM being transferred }
    hstrSelectedRMF,                    { rendering mech & fmt of choice }
    hstrRenderToName: HSTR;             { name source will use }
    ulTargetInfo: ULONG;                { reserved for target's use }
    usOperation,                        { operation being performed }
    fsReply: USHORT                     { reply flags }
  End;
  PDRAGTRANSFER = ^DRAGTRANSFER;

  RENDERFILE = Record                   { rndf }
    hwndDragFiles: HWND;                { conversation window }
    hstrSource,                         { handle to source file name }
    hstrTarget: HSTR;                   { handle to target file name }
    fMove: BOOL;                        { TRUE - move, FALSE - copy }
    usRsvd: USHORT                      { reserved }
  End;
  PRENDERFILE = ^RENDERFILE;
  PPSZ  = ^PSZ;

  Function DrgAcceptDroppedFiles (hwnd: HWND; pszPath, pszTypes: PSZ; usDefaultOp, usRsvd: USHORT): BOOL;

  Function DrgAccessDraginfo (pdinfo: PDRAGINFO): BOOL;
  Function DrgAddStrHandle (psz: PSZ): HSTR;

  Function DrgAllocDraginfo (cditem: USHORT): PDRAGINFO;
  Function DrgAllocDragtransfer (cdxfer: USHORT): PDRAGTRANSFER;
  Function DrgDeleteDraginfoStrHandles (pdinfo: PDRAGINFO): BOOL;
  Function DrgDeleteStrHandle (hstr: HSTR): BOOL;
  Function DrgDrag (hwndSource: HWND; pdinfo: PDRAGINFO; pdimg: PDRAGIMAGE;
                    cdimg: USHORT; vkTerminate: SHORT; pRsvd: PVOID): HWND;
  Function DrgDragFiles (hwnd: HWND; apszFiles: PPSZ; apszTypes: PPSZ;
                         apszTargets: PPSZ; cFiles: USHORT;
                         hptrDrag: HPOINTER; vkTerm: USHORT;
                         fSourceRender: BOOL; ulRsvd: ULONG): BOOL;
  Function DrgFreeDraginfo (pdinfo: PDRAGINFO): BOOL;
  Function DrgFreeDragtransfer (pdxfer: PDRAGTRANSFER): BOOL;
  Function DrgGetPS (hwnd: HWND): HPS;
  Function DrgPostTransferMsg (hwnd: HWND; msg: USHORT; pdxfer: PDRAGTRANSFER;
                               fs, usRsvd: USHORT; fRetry: BOOL): BOOL;
  Function DrgPushDraginfo (pdinfo: PDRAGINFO; hwndDest: HWND): BOOL;
  Function DrgQueryDragitem (pdinfo: PDRAGINFO; cbBuffer: USHORT;
                             pditem: PDRAGITEM; iItem: USHORT): BOOL;
  Function DrgQueryDragitemCount (pdinfo: PDRAGINFO): USHORT;
  Function DrgQueryDragitemPtr (pdinfo: PDRAGINFO; i: USHORT): PDRAGITEM;
  Function DrgQueryNativeRMF (pditem: PDRAGITEM; cbBuffer: USHORT;
                              pBuffer: PCHAR): BOOL;
  Function DrgQueryNativeRMFLen (pditem: PDRAGITEM): USHORT;
  Function DrgQueryStrName (hstr: HSTR; cbBuffer: USHORT; pBuffer: PSZ): USHORT;
  Function DrgQueryStrNameLen (hstr: HSTR): USHORT;
  Function DrgQueryTrueType (pditem:PDRAGITEM; cbBuffer: USHORT; pBuffer: PSZ): BOOL;
  Function DrgQueryTrueTypeLen (pditem: PDRAGITEM): USHORT;
  Function DrgReleasePS (hps: HPS): BOOL;
  Function DrgSendTransferMsg (hwnd: HWND; msg: USHORT; mp1, mp2: MPARAM): MRESULT;
  Function DrgSetDragitem (pdinfo: PDRAGINFO; pditem:  PDRAGITEM;
                          cbBuffer, iItem: USHORT): BOOL;
  Function DrgSetDragPointer (pdinfo: PDRAGINFO; hptr: HPOINTER): BOOL;
  Function DrgSetDragImage (pdinfo: PDRAGINFO; pdimg: PDRAGIMAGE;
                            cdimg: USHORT; pRsvd: PVOID): BOOL;
  Function DrgVerifyNativeRMF (pditem: PDRAGITEM; pszRMF: PSZ): BOOL;
  Function DrgVerifyRMF (pditem: PDRAGITEM; pszMech, pszFmt: PSZ): BOOL;
  Function DrgVerifyTrueType (pditem: PDRAGITEM; pszType: PSZ): BOOL;
  Function DrgVerifyType (pditem: PDRAGITEM; pszType: PSZ): BOOL;
  Function DrgVerifyTypeSet (pditem: PDRAGITEM; pszType: PSZ; cbMatch: USHORT;
                             pszMatch: PSZ): BOOL;

Implementation
  Function DrgAcceptDroppedFiles;         External 'PMDRAG'   Index   64;
  Function DrgAccessDraginfo;             External 'PMDRAG'   Index    1;
  Function DrgAddStrHandle;               External 'PMDRAG'   Index    2;
  Function DrgAllocDraginfo;              External 'PMDRAG'   Index    3;
  Function DrgAllocDragtransfer;          External 'PMDRAG'   Index    4;
  Function DrgDeleteDraginfoStrHandles;   External 'PMDRAG'   Index    5;
  Function DrgDeleteStrHandle;            External 'PMDRAG'   Index    6;
  Function DrgDrag;                       External 'PMDRAG'   Index    7;
  Function DrgDragFiles;                  External 'PMDRAG'   Index   63;
  Function DrgFreeDraginfo;               External 'PMDRAG'   Index    8;
  Function DrgFreeDragtransfer;           External 'PMDRAG'   Index    9;
  Function DrgGetPS;                      External 'PMDRAG'   Index   10;
  Function DrgPostTransferMsg;            External 'PMDRAG'   Index   11;
  Function DrgPushDraginfo;               External 'PMDRAG'   Index   12;
  Function DrgQueryDragitem;              External 'PMDRAG'   Index   13;
  Function DrgQueryDragitemCount;         External 'PMDRAG'   Index   14;
  Function DrgQueryDragitemPtr;           External 'PMDRAG'   Index   15;
  Function DrgQueryNativeRMF;             External 'PMDRAG'   Index   16;
  Function DrgQueryNativeRMFLen;          External 'PMDRAG'   Index   17;
  Function DrgQueryStrName;               External 'PMDRAG'   Index   18;
  Function DrgQueryStrNameLen;            External 'PMDRAG'   Index   19;
  Function DrgQueryTrueType;              External 'PMDRAG'   Index   20;
  Function DrgQueryTrueTypeLen;           External 'PMDRAG'   Index   21;
  Function DrgReleasePS;                  External 'PMDRAG'   Index   22;
  Function DrgSendTransferMsg;            External 'PMDRAG'   Index   23;
  Function DrgSetDragPointer;             External 'PMDRAG'   Index   24;
  Function DrgSetDragImage;               External 'PMDRAG'   Index   25;
  Function DrgSetDragitem;                External 'PMDRAG'   Index   26;
  Function DrgVerifyNativeRMF;            External 'PMDRAG'   Index   27;
  Function DrgVerifyRMF;                  External 'PMDRAG'   Index   28;
  Function DrgVerifyTrueType;             External 'PMDRAG'   Index   29;
  Function DrgVerifyType;                 External 'PMDRAG'   Index   30;
  Function DrgVerifyTypeSet;              External 'PMDRAG'   Index   31;
End.
