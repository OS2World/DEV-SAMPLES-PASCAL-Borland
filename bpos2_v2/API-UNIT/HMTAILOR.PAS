{| Unit: hmtailor
 | Version: 1.00
 | translated from file hmtailor.H
 | Original translation: Peter Sawatzki (ps)
 | Contributing:
 |   (fill in)
 |
 | change history:
 | Date:    Ver: Author:
 | 11/23/93 1.00 ps     original translation by ps
}
Unit HmTailor;
Interface
Uses
  Os2Def;
{***************************************************************************\
*                                                                            *
*  MODULE NAME: HMTAILOR.H                                                   *
*                                                                            *
*        IBM/Microsoft Confidential                                          *
*                                                                            *
*        Copyright
*        Copyright
*                                                                            *
*        All Rights Reserved                                                 *
\***************************************************************************}
{**************************************************************************}
{ CHANGE ACTIVITY:                                                          }
{                                                                           }
{ FLAG  REASON  RLSE  DATE  ORIGIN              COMMENTS                    }
{ ---- -------- ---- ------ ------ ----------------------------------------}
{ @PGE=DCR00002 0121 890926          add support of multiple pages          }
{ @BNZ=DCR01151 0200 900501          changes to action bar Help pulldown    }
{**************************************************************************}
Const
  IDM_FILE                         =  $7F00;
  IDM_SEARCH                       =  $7F01;
  IDM_PRINT                        =  $7F02;
  IDM_VIEWPORT                     =  $7F05;                { ->@PGE<- }

  IDM_EDIT                         =  $7F10;
  IDM_CLIP_COPY                    =  $7F11;
  IDM_CLIP_CF                      =  $7F12;
  IDM_CLIP_AF                      =  $7F13;
  IDM_LIBRARIES                    =  $7F14;

  IDM_OPTIONS                      =  $7F20;
  IDM_VIEWPAGES                    =  $7F21;
  IDM_TOC                          =  $7F23;
  IDM_OPTION_EXPLEVEL              =  $7F24;
  IDM_OPTION_EXPBRANCH             =  $7F25;
  IDM_OPTION_EXPALL                =  $7F26;
  IDM_OPTION_COLBRANCH             =  $7F27;
  IDM_OPTION_COLALL                =  $7F28;
  IDM_PREVIOUS                     =  $7F29;

  IDM_HELP                         =  $7F30;
  IDM_HELPHELP                     =  $7F31;
  IDM_HELP_EXTENDED                =  $7F32;
  IDM_USING_HELP                   = IDM_HELPHELP;
  IDM_GENERAL_HELP                 = IDM_HELP_EXTENDED;
  IDM_HELP_KEYS                    =  $7F33;
  IDM_HELP_INDEX                   =  $7F34;

  IDM_TUTORIAL                     =  $7F37;
Implementation
End.
