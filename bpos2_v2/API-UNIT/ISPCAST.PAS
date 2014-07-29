{| Unit: IsPCast
 | Version: 1.00
 | translated from file IsPCast.H
 | Original translation: Peter Sawatzki (ps)
 | Contributing:
 |   (fill in)
 |
 | change history:
 | Date:    Ver: Author:
 | 11/20/93 1.00 ps     original translation by ps
}
Unit IsPCast;
Interface
Uses
  Os2Def;
{************************************************************************\
*
* Module Name: ISPCAST.H
*
* OS/2 Dialog Manager typedefs for the communication block and
* declarations for the procedures used to call services of Dialog Manager
*
*
*
\************************************************************************}

Const
  DMCOMMBLOCK_ERROR_INFO_COUNT = 6;

{********************************************************************}
{              Typedef for the Error Information Array               }
{********************************************************************}
Type
  DMERRORINFO = Record
    ReasonCode,                  { Dialog Manager Return Code }
    OS2ReturnCode: LongInt       { DOS Return Code            }
  End;
  pDMERRORINFO = ^DMERRORINFO;

{********************************************************************}
{        Typedef for the Dialog Manager Communications Block         }
{********************************************************************}

  DMCOMMBLOCK = Record
    ReturnCode,                         { Dialog Manager Return Code }
    ReasonCode: LongInt;                { Dialog Manager Reason Code }
    InstanceID: Array[0..7] Of Char;    { Instance Identifier        }
    OS2ReturnCode: LongInt;             { DOS Return Code            }
    ErrorInfo: Array[0..DMCOMMBLOCK_ERROR_INFO_COUNT-1] Of DMERRORINFO;
                                        { Error Information Array    }
    Filler: Array[0..59] Of Char        { Used by DM -- don't modify }
  End;
  pDMCOMMBLOCK = ^DMCOMMBLOCK;

{********************************************************************}
{                  Declarations for Dialog Manager                   }
{********************************************************************}

{ -CANT-
int far _CDECL ISPCI  (PDMCOMMBLOCK, long int, char far *);
int far _CDECL ISPCI2 (PDMCOMMBLOCK, long int, char far *,
               long far *, void far *);
}

Implementation
End.
