{**************************************************************************\
*
* Module Name: PMFONT.H
*
* OS/2 Presentation Manager type declarations for Fonts.
*
* Copyright (c) International Business Machines Corporation 1981, 1988-1990
*
\**************************************************************************}

{| Version:   1.00
 | Original translation: Peter Singer (PSi)
 }
Unit PmFONT;
Interface
Uses
  Os2Def;

TYPE
    FOCAMETRICS = record      { foca }
      ulIdentity,
      ulSize     : ULONG;
      szFamilyname,
      szFacename : array[0..31] of char;
      usRegistryId,
      usCodePage,
      yEmHeight,
      yXHeight,
      yMaxAscender,
      yMaxDescender,
      yLowerCaseAscent,
      yLowerCaseDescent,
      yInternalLeading,
      yExternalLeading,
      xAveCharWidth,
      xMaxCharInc,
      xEmInc,
      yMaxBaselineExt,
      sCharSlope,
      sInlineDir,
      sCharRot     : SHORT;
      usWeightClass,
      usWidthClass : USHORT;
      xDeviceRes,
      yDeviceRes,
      usFirstChar,
      usLastChar,
      usDefaultChar,
      usBreakChar,
      usNominalPointSize,
      usMinimumPointSize,
      usMaximumPointSize,
      fsTypeFlags,
      fsDefn,
      fsSelectionFlags,
      fsCapabilities,
      ySubscriptXSize,
      ySubscriptYSize,
      ySubscriptXOffset,
      ySubscriptYOffset,
      ySuperscriptXSize,
      ySuperscriptYSize,
      ySuperscriptXOffset,
      ySuperscriptYOffset,
      yUnderscoreSize,
      yUnderscorePosition,
      yStrikeoutSize,
      yStrikeoutPosition,
      usKerningPairs,
      sFamilyClass       : SHORT;
      pszDeviceNameOffset: PSZ;
    end;
    PFOCAMETRICS = ^FOCAMETRICS;

    FONTDEFINITIONHEADER = record      { fdh }
      ulIdentity,
      ulSize         : ULONG;
      fsFontdef,
      fsChardef,
      usCellSize,
      xCellWidth,
      yCellHeight,
      xCellIncrement,
      xCellA,
      xCellB,
      xCellC,
      pCellBaseOffset: SHORT;
    end;
    PFONTDEFINITIONHEADER = ^FONTDEFINITIONHEADER;

CONST
     FONTDEFFONT1   =  $0047;     { set width, height, inc. & base offset }
     FONTDEFFONT2   =  $0042;     { set heigh=t & base offset              }
     FONTDEFFONT3   =  $0042;    { set height & base offset              }
     FONTDEFCHAR1   =  $0081;     { set char offset and width             }
     FONTDEFCHAR2   =  $0081;     { set char offset and width             }
     FONTDEFCHAR3   =  $00b8;     { set char offset, A, B, and C space    }
     SPACE_UNDEF    =  $8000;     { space undefined = take default        }

TYPE
    FONTSIGNATURE = record     { fs }
      ulIdentity,
      ulSize      : ULONG;
      achSignature:  Array[0..11] of char;
    end;
    PFONTSIGNATURE = ^FONTSIGNATURE;

    FOCAFONT = record      { ff }
      fsSignature  : FONTSIGNATURE;
      fmMetrics    : FOCAMETRICS;
      fdDefinitions: FONTDEFINITIONHEADER;
    end;
    PFOCAFONT = ^FOCAFONT;

CONST
     FONT_SIGNATURE =  $fffffffe;   { Identity header start                 }
     FONT_METRICS   =  $00000001;   { Identity metrics                      }
     FONT_DEFINITION=  $00000002;   { Identity definition                   }
     FONT_ENDRECORD =  $ffffffff;   { Identity record end                   }

{ Options for QueryFonts }

     QUERY_PUBLIC_FONTS    =  $0001;
     QUERY_PRIVATE_FONTS   =  $0002;

     CDEF_GENERIC          =  $0001;
     CDEF_BOLD             =  $0002;
     CDEF_ITALIC           =  $0004;
     CDEF_UNDERSCORE       =  $0008;
     CDEF_STRIKEOUT        =  $0010;
     CDEF_OUTLINE          =  $0020;
implementation
end.