{| Unit: pmavio
 | Version: 1.00
 | translated from file pmavio.H
 | Original translation: Peter Sawatzki (ps)
 | Contributing:
 |   (fill in)
 |
 | change history:
 | Date:    Ver: Author:
 | 11/19/93 1.00 ps     original translation by ps
}
Unit pmavio;
Interface
Uses
  Os2Def,
  PmWin;
{**************************************************************************\
*
* Module Name: PMAVIO.H
*
* OS/2 Presentation Manager AVIO constants, types and function declarations
*
\**************************************************************************}

{ common types, constants and function declarations }

Type
  HVPS = USHORT;    { hpvs }
  pHVPS = ^HVPS;    { phpvs }

  Function VioAssociate (hdc: HDC; hvps: HVPS): USHORT;
  Function VioCreateLogFont (pfatattrs: PFATTRS; llcid: LongInt; pName: PSTR8;hvps: HVPS): USHORT;
  Function VioCreatePS (phvps: PHVPS; sdepth,swidth,sFormat,sAttrs: SHORT;hvpsReserved: HVPS): USHORT;
  Function VioDeleteSetId (llcid: LongInt; hvps: HVPS): USHORT;
  Function VioDestroyPS (hvps: HVPS): USHORT;
  Function VioGetDeviceCellSize (psHeight,psWidth: PSHORT; hvps: HVPS): USHORT;
  Function VioGetOrg (psRow,psColumn: PSHORT; hvps: HVPS): USHORT;
  Function VioQueryFonts (plRemfonts: PLONG; afmMetrics: PFONTMETRICS; lMetricsLength: LongInt;
                          plFonts: PLONG; pszFacename: PSZ; flOptions: ULONG;hvps: HVPS): USHORT;
  Function VioQuerySetIds (allcids: PLONG; pNames: PSTR8; alTypes: PLONG;lcount: LongInt;hvps: HVPS): USHORT;
  Function VioSetDeviceCellSize (sHeight,sWidth: SHORT; hvps: HVPS): USHORT;
  Function VioSetOrg (sRow,sColumn: SHORT; hvps: HVPS): USHORT;
  Function VioShowPS (sDepth,sWidth,soffCell: SHORT; hvps: HVPS): USHORT;

{*********************** Public Function ******************************\
 * WinDefAVioWindowProc -- Default message processing for AVio PS's
\**********************************************************************}

  Function WinDefAVioWindowProc (hwnd: HWND;msg: USHORT; mp1,mp2: MPARAM): MRESULT;

Implementation
  Function VioAssociate;                  External 'VIOCALLS' Index   55;
  Function VioCreateLogFont;              External 'VIOCALLS' Index   60;
  Function VioCreatePS;                   External 'VIOCALLS' Index   56;
  Function VioDeleteSetId;                External 'VIOCALLS' Index   57;
  Function VioDestroyPS;                  External 'VIOCALLS' Index   61;
  Function VioGetDeviceCellSize;          External 'VIOCALLS' Index   58;
  Function VioGetOrg;                     External 'VIOCALLS' Index   59;
  Function VioQueryFonts;                 External 'VIOCALLS' Index   64;
  Function VioQuerySetIds;                External 'VIOCALLS' Index   62;
  Function VioSetDeviceCellSize;          External 'VIOCALLS' Index   65;
  Function VioSetOrg;                     External 'VIOCALLS' Index   63;
  Function VioShowPS;                     External 'VIOCALLS' Index   66;
  Function WinDefAVioWindowProc;          External 'PMVIOP'   Index   30;
End.
