{**************************************************************************\
*
* Module Name: PMMLE.H
*
* OS/2 Presentation Manager MultiLine Edit Control - Version 1.0
*
* Copyright (c) International Business Machines Corporation 1989, 1990
*
\**************************************************************************}
{| Version:   1.00
 | Original translation: Peter Sawatzki ps
 | Contributing:
 |   Peter Sawatzki ps
 |
 | change history:
 | Date:    Ver: Author:
 | 11/11/93 1.00 ps     original translation by ps
}
Unit PmMLE;
Interface
Uses
  Os2Def;
Const
{**************************************************************************\
* MLE Class and dialog code
\**************************************************************************}
{ in pmwin.h }

{**************************************************************************\
* MLE Window styles ( in addition to WS_* )
\**************************************************************************}
  MLS_WORDWRAP             = $00000001;
  MLS_BORDER               = $00000002;
  MLS_VSCROLL              = $00000004;
  MLS_HSCROLL              = $00000008;
  MLS_READONLY             = $00000010;
  MLS_IGNORETAB            = $00000020;

{**************************************************************************\
* MLE External Data Types
\**************************************************************************}
Type
  IPT  = LONG;       { insertion point                             }
  PIPT = ^LONG;      { insertion point                             }
  PIX  = LONG;       { pixel                                       }
  LINE = ULONG;      { Line number                                 }

  MLEFORMATRECT = Record { MLEFRD format rectangle data               }
    cxFormat,           { format rectangle width                     }
    cyFormat: LONG      { format rectangle height                    }
  End;
  pFORMATRECT = ^MLEFORMATRECT;

  MLECTLDATA = Record { MLECTL control data                        }
    cbCtlData,          { Length of the MLECTLDATA structure          }
    afIEFormat: USHORT; { import/export format                        }
    cchText: ULONG;     { text limit                                  }
    iptAnchor,          { beginning of selection                      }
    iptCursor: IPT;     { ending of selection                         }
    cxFormat,           { format rectangle width                      }
    cyFormat: LONG;     { format rectangle height                     }
    afFormatFlags: ULONG{ formatting rectangle flags - see mask below }
  End;
  pMLECTLDATA = ^MLECTLDATA;

{**************************************************************************\
* afFormatFlags mask
\**************************************************************************}
Const
  MLFFMTRECT_LIMITHORZ     = $00000001;
  MLFFMTRECT_LIMITVERT     = $00000002;
  MLFFMTRECT_MATCHWINDOW   = $00000004;
  MLFFMTRECT_FORMATRECT    = $00000007;
{**************************************************************************\
* afIEFormat - Import/Export Format flags
\**************************************************************************}
  MLFIE_CFTEXT             = 0;
  MLFIE_NOTRANS            = 1;
  MLFIE_WINFMT             = 2;
  MLFIE_RTF                = 3;

{**************************************************************************\
* MLN_OVERFLOW structure
\**************************************************************************}
Type
  MLEOVERFLOW = Record { overflow structure                        }
    afErrInd: ULONG;            { see mask below                            }
    nBytesOver,                 { number of bytes overflowed                }
    pixHorzOver,                { number of pixels horizontally overflowed  }
    pixVertOver: LONG           { number of pixels vertically overflowed    }
  End;
  pOVERFLOW = ^MLEOVERFLOW;

Const
{**************************************************************************\
* afErrInd - error format rectangle flags
\**************************************************************************}
  MLFEFR_RESIZE            = $00000001;
  MLFEFR_TABSTOP           = $00000002;
  MLFEFR_FONT              = $00000004;
  MLFEFR_TEXT              = $00000008;
  MLFEFR_WORDWRAP          = $00000010;
  MLFETL_TEXTBYTES         = $00000020;

Type
{**************************************************************************\
* MLN_MARGIN structure
\**************************************************************************}
  MLEMARGSTRUCT = Record { margin structure                        }
    afMargins,            { margin indicator                          }
    usMouMsg: USHORT;     { mouse message                             }
    iptNear: IPT          { the geometrically nearest insertion point }
 End;
 pMARGSTRUCT = ^MLEMARGSTRUCT;

Const
{**************************************************************************\
* afFlags - margin notification indicators
\**************************************************************************}
  MLFMARGIN_LEFT           = $0001;
  MLFMARGIN_BOTTOM         = $0002;
  MLFMARGIN_RIGHT          = $0003;
  MLFMARGIN_TOP            = $0004;

{**************************************************************************\
* MLM_QUERYSELECTION flags
\**************************************************************************}
  MLFQS_MINMAXSEL          = 0;
  MLFQS_MINSEL             = 1;
  MLFQS_MAXSEL             = 2;
  MLFQS_ANCHORSEL          = 3;
  MLFQS_CURSORSEL          = 4;

{**************************************************************************\
* MLN_CLPBDFAIL flags
\**************************************************************************}
  MLFCLPBD_TOOMUCHTEXT     = $00000001;
  MLFCLPBD_ERROR           = $00000002;

Type
{**************************************************************************\
* MLM_SEARCH structure
\**************************************************************************}
  MLE_SEARCHDATA = Record { search structure                               }
    cb: USHORT;           { size of search spec structure                  }
    pchFind,              { string to search for                           }
    pchReplace: pChar;    { string to replace with                         }
    cchFind,              { length of pchFindString                        }
    cchReplace: SHORT;    { length of replace string                       }
    iptStart,             { point at which to start search                 }
                          { (negative indicates cursor pt)                 }
                          { becomes pt where string found                  }
    iptStop: IPT;         { point at which to stop search                  }
                          { (negative indicates EOT)                       }
    cchFound: USHORT      { Length of found string at iptStart             }
  End;
  pMLE_SEARCHDATA = ^MLE_SEARCHDATA;

Const
{**************************************************************************\
* MLM_SEARCH style flags
\**************************************************************************}
  MLFSEARCH_CASESENSITIVE  = $00000001;
  MLFSEARCH_SELECTMATCH    = $00000002;
  MLFSEARCH_CHANGEALL      = $00000004;

{**************************************************************************\
* MLE messages - MLM from 0x01b0 to 0x01de; MLN from 0x0001 to 0x000f
\**************************************************************************}
{ formatting messages }
  MLM_SETTEXTLIMIT         = $01b0;
  MLM_QUERYTEXTLIMIT       = $01b1;
  MLM_SETFORMATRECT        = $01b2;
  MLM_QUERYFORMATRECT      = $01b3;
  MLM_SETWRAP              = $01b4;
  MLM_QUERYWRAP            = $01b5;
  MLM_SETTABSTOP           = $01b6;
  MLM_QUERYTABSTOP         = $01b7;
  MLM_SETREADONLY          = $01b8;
  MLM_QUERYREADONLY        = $01b9;

{ text content manipulation and queries messages }
  MLM_QUERYCHANGED         = $01ba;
  MLM_SETCHANGED           = $01bb;
  MLM_QUERYLINECOUNT       = $01bc;
  MLM_CHARFROMLINE         = $01bd;
  MLM_LINEFROMCHAR         = $01be;
  MLM_QUERYLINELENGTH      = $01bf;
  MLM_QUERYTEXTLENGTH      = $01c0;

{ text import and export messages }
  MLM_FORMAT               = $01c1;
  MLM_SETIMPORTEXPORT      = $01c2;
  MLM_IMPORT               = $01c3;
  MLM_EXPORT               = $01c4;
  MLM_DELETE               = $01c6;
  MLM_QUERYFORMATLINELENGTH= $01c7;
  MLM_QUERYFORMATTEXTLENGTH= $01c8;
  MLM_INSERT               = $01c9;

{ selection messages }
  MLM_SETSEL               = $01ca;
  MLM_QUERYSEL             = $01cb;
  MLM_QUERYSELTEXT         = $01cc;

{ undo and redo messages }
  MLM_QUERYUNDO            = $01cd;
  MLM_UNDO                 = $01ce;
  MLM_RESETUNDO            = $01cf;

{ text attributes messages }
  MLM_QUERYFONT            = $01d0;
  MLM_SETFONT              = $01d1;
  MLM_SETTEXTCOLOR         = $01d2;
  MLM_QUERYTEXTCOLOR       = $01d3;
  MLM_SETBACKCOLOR         = $01d4;
  MLM_QUERYBACKCOLOR       = $01d5;

{ scrolling messages }
  MLM_QUERYFIRSTCHAR       = $01d6;
  MLM_SETFIRSTCHAR         = $01d7;

{ clipboard messages }
  MLM_CUT                  = $01d8;
  MLM_COPY                 = $01d9;
  MLM_PASTE                = $01da;
  MLM_CLEAR                = $01db;

{ display manipulation messages }
  MLM_ENABLEREFRESH        = $01dc;
  MLM_DISABLEREFRESH       = $01dd;

{ search message }
  MLM_SEARCH               = $01de;
  MLM_QUERYIMPORTEXPORT    = $01df;

{ notification messages }
  MLN_OVERFLOW             = $0001;
  MLN_PIXHORZOVERFLOW      = $0002;
  MLN_PIXVERTOVERFLOW      = $0003;
  MLN_TEXTOVERFLOW         = $0004;
  MLN_VSCROLL              = $0005;
  MLN_HSCROLL              = $0006;
  MLN_CHANGE               = $0007;
  MLN_SETFOCUS             = $0008;
  MLN_KILLFOCUS            = $0009;
  MLN_MARGIN               = $000a;
  MLN_SEARCHPAUSE          = $000b;
  MLN_MEMERROR             = $000c;
  MLN_UNDOOVERFLOW         = $000d;
  MLN_CLPBDFAIL            = $000f;
Implementation
End.
