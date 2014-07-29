{| Unit: IsPUser
 | Version: 1.00
 | translated from file IsPUser.H
 | Original translation: Peter Sawatzki (ps)
 | Contributing:
 |   (fill in)
 |
 | change history:
 | Date:    Ver: Author:
 | 11/23/93 1.00 ps     original translation by ps
}
Unit IsPUser;
Interface
Uses
  Os2Def,
  PmWin;
{********************************************************************\
* OS/2 Dialog Manager message constants and type definitions for
* user controls and user exits.
\*********************************************************************}

{********************************************************************}
{ Application-defined messages should be begin at DM_USER to avoid   }
{ conflict with DM-defined messages.                                 }
{********************************************************************}

Const
  DM_USER                          = WM_USER+ $1000;
  CM_MESSAGE_BASE                  = WM_USER+ $800;

{********************************************************************}
{  DM messages common to User Controls and User Exits                }
{********************************************************************}

  CM_FREE_CTL_RESOURCES            = (CM_MESSAGE_BASE+$0000);
  CM_MEM_ALLOC                     = (CM_MESSAGE_BASE+$0001);
  CM_MEM_FREE                      = (CM_MESSAGE_BASE+$0002);
  CM_MEM_REALLOC                   = (CM_MESSAGE_BASE+$0003);
  CM_QUERY_CTL_HDL                 = (CM_MESSAGE_BASE+$0004);
  CM_QUERY_USER_INST_PTR           = (CM_MESSAGE_BASE+$0005);
  CM_SET_USER_INST_PTR             = (CM_MESSAGE_BASE+$0006);
  CM_UPDATE_CONTROL                = (CM_MESSAGE_BASE+$0007);

{********************************************************************}
{  DM User Control Messages                                          }
{********************************************************************}

  CM_INIT_USER_CONTROL             = (CM_MESSAGE_BASE+$0008);
  CM_PANEL_ENTERED                 = (CM_MESSAGE_BASE+$0009);
  CM_END_DISPLAY                   = (CM_MESSAGE_BASE+$000A);
  CM_GET_UC_PARM_AND_TEXT          = (CM_MESSAGE_BASE+$000B);
  CM_NO_FOCUS_USER_CONTROL         = (CM_MESSAGE_BASE+$000C);
  CM_YES_FOCUS_USER_CONTROL        = (CM_MESSAGE_BASE+$000D);
  CM_SET_MIN_MAX_SIZE              = (CM_MESSAGE_BASE+$000E);

{********************************************************************}
{  DM User Action Exit Messages                                      }
{********************************************************************}

  CM_DO_ACTION               =      (CM_MESSAGE_BASE+$000F);
  CM_INIT_USER_ACTION        =      (CM_MESSAGE_BASE+$0010);

{********************************************************************}
{  DM User Check Exit Messages                                       }
{********************************************************************}

  CM_DO_CHECK                     = (CM_MESSAGE_BASE+$0011);
  CM_INIT_USER_CHECK              = (CM_MESSAGE_BASE+$0012);

{********************************************************************}
{  DM User Command Action Exit Messages                              }
{********************************************************************}

  CM_DO_CMD_ACTION                 = (CM_MESSAGE_BASE+$0013);
  CM_INIT_USER_CMD_ACTION          = (CM_MESSAGE_BASE+$0014);

{********************************************************************}
{  DM User Translate Exit Messages                                   }
{********************************************************************}

  CM_DO_XLATE                      = (CM_MESSAGE_BASE+$0015);
  CM_INIT_USER_XLATE               = (CM_MESSAGE_BASE+$0016);

{********************************************************************}
{  DM User Variable Exit Messages                                    }
{********************************************************************}

  CM_INIT_USER_VARIABLE            = (CM_MESSAGE_BASE+$0017);
  CM_QUERY_VARIABLE_VALUE          = (CM_MESSAGE_BASE+$0018);
  CM_SET_VARIABLE_VALUE            = (CM_MESSAGE_BASE+$0019);


  CCTL_INPUT                       = 1;
  CCTL_OUTPUT                      = 2;

{********************************************************************}
{ These constants are provided to make is easy for the writer of a   }
{ user control or user exit to register their class.                 }
{                                                                    }
{ The style constants provided as class styles for the application's }
{ user control/exit window class.  They should "or" in any of their  }
{ own class styles.  Currently these are null because DM doesn't     }
{ require user controls/exits to have a particular window style, but }
{ these can be changed in the future if that requirement arises.     }
{                                                                    }
{ The extra bytes constants should be used so that user controls/    }
{ exits have extra window words for the pointer to their instance    }
{ data.  Any extra bytes the application wants to use must be after  }
{ the first 4 in the extra window words, as these are reserved by    }
{ DM.  Remember the UserInstancePtr in the user control/exit         }
{ instance data can be used to point to application specific data.   }
{********************************************************************}

  CCTL_UC_CLASS_STYLE              =  $00000000;           { User control   }
  CCTL_UA_CLASS_STYLE              =  $00000000;           { Action         }
  CCTL_UK_CLASS_STYLE              =  $00000000;           { Check          }
  CCTL_UM_CLASS_STYLE              =  $00000000;           { Command action }
  CCTL_UX_CLASS_STYLE              =  $00000000;           { Translate      }
  CCTL_UV_CLASS_STYLE              =  $00000000;           { Variable access}

  CCTL_UC_EXTRA_BYTES              = 4;                     { User control   }
  CCTL_UA_EXTRA_BYTES              = 4;                     { Action         }
  CCTL_UK_EXTRA_BYTES              = 4;                     { Check          }
  CCTL_UM_EXTRA_BYTES              = 4;                     { Command action }
  CCTL_UX_EXTRA_BYTES              = 4;                     { Translate      }
  CCTL_UV_EXTRA_BYTES              = 4;                     { Variable access}

Type
  cmDefaultMessageParm = Record
    ReturnCode: ULONG;
    MessageParmSize: USHORT
  End;
  cmFreeCtlResourcesParm    = cmDefaultMessageParm;
  cmInitUserControlParm     = cmDefaultMessageParm;
  cmInitUserVariableParm    = cmDefaultMessageParm;
  cmNoFocusUserControlParm  = cmDefaultMessageParm;
  cmYesFocusUserControlParm = cmDefaultMessageParm;
  cmPanelEnteredParm        = cmDefaultMessageParm;
  cmQueryUserInstPtrParm    = cmDefaultMessageParm;

  cmDefaultMessageParmPtr      = ^cmDefaultMessageParm;
  cmFreeCtlResourcesParmPtr    = ^cmDefaultMessageParm;
  cmInitUserControlParmPtr     = ^cmDefaultMessageParm;
  cmInitUserVariableParmPtr    = ^cmDefaultMessageParm;
  cmNoFocusUserControlParmPtr  = ^cmDefaultMessageParm;
  cmYesFocusUserControlParmPtr = ^cmDefaultMessageParm;
  cmPanelEnteredParmPtr        = ^cmDefaultMessageParm;
  cmQueryUserInstPtrParmPtr    = ^cmDefaultMessageParm;

  cmMemAllocParm = Record
    ReturnCode: ULONG;
    MessageParmSize,
    ByteCount: USHORT
  End;
  cmMemAllocParmPtr = ^cmMemAllocParm;

  cmMemFreeParm = Record
    ReturnCode: ULONG;
    MessageParmSize: USHORT;
    MemoryPtr: PVOID
  End;
  cmMemFreeParmPtr            = ^cmMemFreeParm               ;

  cmMemReallocParm = Record
    ReturnCode: ULONG;
    MessageParmSize,
    NewByteCount: USHORT;
    SourcePtr: PVOID
  End;
  cmMemReallocParmPtr         = ^cmMemReallocParm            ;

  cmQueryCtlHdlParm = Record
    ReturnCode: ULONG;
    MessageParmSize: USHORT;
    Name: PSZ
  End;
  cmQueryCtlHdlParmPtr        = ^cmQueryCtlHdlParm           ;

  cmSetUserInstPtrParm = Record
    ReturnCode: ULONG;
    MessageParmSize: USHORT;
    UserInstancePtr: PVOID
  End;
  cmSetUserInstPtrParmPtr     = ^cmSetUserInstPtrParm           ;

  cmUpdateControlParm = Record
    ReturnCode: ULONG;
    MessageParmSize: USHORT;
    SetInitialState: BOOL
  End;
  cmUpdateControlParmPtr      = ^cmUpdateControlParm         ;

  cmEndDisplayParm = Record
    ReturnCode: ULONG;
    MessageParmSize: USHORT;
    DisplayReasonCode: ULONG;
    MsgOnInvalidField: BOOL
  End;
  cmEndDisplayParmPtr         = ^cmEndDisplayParm            ;

  cmGetUCParmAndTextParm = Record
    ReturnCode: ULONG;
    MessageParmSize: USHORT;
    ReturnControlTextPtr,
    ReturnControlPrmdataPtr: PSZ
  End;
  cmGetUCParmAndTextParmPtr   = ^cmGetUCParmAndTextParm      ;

  cmSetMinMaxSizeParm = Record
    ReturnCode: ULONG;
    MessageParmSize,
    MinWidth,
    MaxWidth,
    MinDepth,
    MaxDepth: USHORT
  End;
  cmSetMinMaxSizeParmPtr      = ^cmSetMinMaxSizeParm         ;

  cmDoActionParm = Record
    ReturnCode: ULONG;
    MessageParmSize: USHORT;
    ActionParmPtr: PSZ
  End;
  cmDoActionParmPtr           = ^cmDoActionParm              ;

  cmInitUserActionParm = Record
    ReturnCode: ULONG;
    MessageParmSize: USHORT;
    ActionParmPtr: PSZ
  End;
  cmInitUserActionParmPtr     = ^cmInitUserActionParm        ;

  cmDoCheckParm = Record
    ReturnCode: ULONG;
    MessageParmSize: USHORT;
    CheckValuePtr,
    CheckParm1Ptr,
    CheckParm2Ptr: PSZ
  End;
  cmDoCheckParmPtr            = ^cmDoCheckParm               ;

  cmInitUserCheckParm = Record
    ReturnCode: ULONG;
    MessageParmSize: USHORT;
    CheckParm1Ptr,
    CheckParm2Ptr: PSZ
  End;
  cmInitUserCheckParmPtr      = ^cmInitUserCheckParm         ;

  cmDoCmdActionParm = Record
    ReturnCode: ULONG;
    MessageParmSize: USHORT;
    CmdParmPtr,
    CmdActionParmPtr: PSZ
  End;
  cmDoCmdActionParmPtr        = ^cmDoCmdActionParm           ;

  cmInitUserCmdActionParm = Record
    ReturnCode: ULONG;
    MessageParmSize: USHORT;
    CmdActionParmPtr: PSZ
  End;
  cmInitUserCmdActionParmPtr  = ^cmInitUserCmdActionParm     ;

  cmDoXlateParm = Record
    ReturnCode: ULONG;
    MessageParmSize,
    Direction,
    XlateBufferLen: USHORT;
    XlateBufferPtr,
    XlateParmPtr: PSZ;
    Continue: BOOL
  End;
  cmDoXlateParmPtr            = ^cmDoXlateParm               ;

  cmInitUserXlateParm = Record
    ReturnCode: ULONG;
    MessageParmSize,
    XlateBufferLen: USHORT;
    XlateParmPtr: PSZ
  End;
  cmInitUserXlateParmPtr      = ^cmInitUserXlateParm         ;

  cmQueryVariableValueParm = Record
    ReturnCode: ULONG;
    MessageParmSize: USHORT;
    VnamePtr,
    ReturnBufferPtr: PSZ;
    ReturnBufferLength,
    Subscript: USHORT
  End;
  cmQueryVariableValueParmPtr = ^cmQueryVariableValueParm    ;

  cmSetVariableValueParm = Record
    ReturnCode: ULONG;
    MessageParmSize: USHORT;
    VnamePtr,
    BufferPtr: PSZ;
    Subscript: USHORT
  End;
  cmSetVariableValueParmPtr   = ^cmSetVariableValueParm      ;
Implementation
End.
