{| Unit: pmsei
 | Version: 1.00
 | translated from file pmsei.H
 | Original translation: Peter Sawatzki (ps)
 | Contributing:
 |   (fill in)
 |
 | change history:
 | Date:    Ver: Author:
 | 11/13/93 1.00 ps     original translation by ps
}
Unit pmsei;
Interface
Uses
  Os2Def;
{**************************************************************************\
*
* Module Name: PMSEI.H
*
* OS/2 Presentation Manager SetErrorInfo constants and function declaration
*
* This is included from PMWIN.H when appropriate INCL symbols are defined
*
* =======================================================================

{ SetErrorInfo API }

  {Function WINSETERRORINFO (ERRORID,USHORT,...:): ERRORID cdecl;}

Const
  SEI_BREAKPOINT          =  $8000;                { Always enter an INT 3 breakpt          }
  SEI_NOBEEP                       =  $4000;                { Do not call DosBeep                    }
  SEI_NOPROMPT                     =  $2000;                { Do not prompt the user                 }
  SEI_DBGRSRVD                     =  $1000;                { Reserved for debug use                 }
  SEI_STACKTRACE                   =  $0001;                { save the stack trace                   }
  SEI_REGISTERS                    =  $0002;                { save the registers                     }
  SEI_ARGCOUNT                     =  $0004;                { first USHORT in args is arg count      }
  SEI_DOSERROR                     =  $0008;                { first USHORT in args is OS2 error code }
  SEI_MSGSTR                       =  $0010;                { first PSZ in arg -> msg string         }
  SEI_RESERVED                     =  $0FE0;                { Reserved for future use                }

{ Note that when SEI_ARGCOUNT, SEI_DOSERROR and DOS_MSGSTR are specified     }
{ together, then the implied order of the parameters is:                     }
{                                                                            }
{                                                                            }
{  WinSetErrorInfo
{                   SEI_ARGCOUNT | SEI_DOSERROR | SEI_MSGSTR,                }
{                   argCount,                                                }
{                   dosErrorCode,                                            }
{                   "This is the error msg string: %s\n",                    }
{                   "This is an insert for the %s format specifier" );       }
{                                                                            }
Implementation

  {Function WINSETERRORINFO;               External '?'        Index    ?;}

End.

