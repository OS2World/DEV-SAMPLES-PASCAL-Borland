{| Unit: pmord
 | Version: 1.00
 | translated from file pmord.H
 | Original translation: Peter Sawatzki (ps)
 | Contributing:
 |   (fill in)
 |
 | change history:
 | Date:    Ver: Author:
 | 11/19/93 1.00 ps     original translation by ps
}
Unit pmord;
Interface
Uses
  Os2Def,
  PmGpi;
{***************************** Module Header ******************************\
*
* This is the include file which defines all the structures and constants
* that can be used to build or intepret GOCA orders for the GPI
*
* ==========================================================================
*
* The orders fall into 4 categories :-
*
* 1) 1-byte orders
*
* 2) 2-byte orders    - second byte contains the value
*
* 3) Long orders      - second byte gives the order length, subsequent bytes
*                       contain the values
*
* 4) Very long orders - third and fourth bytes gives the order length,
*                       subsequent bytes contain the values
*
\**************************************************************************}

{**************************************************************************\
*
* Miscellaneous structures used in this file
*
\**************************************************************************}

{ form of RECTL with shorts instead of longs }

Type
  RECT1S = Record                       { rcs }
    xLeft,
    yBottom,
    xRight,
    yTop: SHORT
  End;

{ form of POINTL with 1 byte offsets instead of longs }
  ODPOINT = Record                      { odpt }
    dx,
    dy: Char
  End;

{ form of SIZEL with shorts instead of longs }
  SIZES = Record                        { sizs }
    cx,
    cy: SHORT
  End;

{ unsigned two-byte swapped integer }
  SWPUSHORT = Record                    { swpus }
    HiByte,
    LoByte: UCHAR
  End;

{**************************************************************************\
*
* 1-byte orders
*
\**************************************************************************}

{ macro to tell whether this is a 1-byte order }
{ UNSURE #define BYTE_ORDER(oc)   ((oc)==OCODE_GNOP1 || (oc)==OCODE_GESD) }

{ 1-byte order codes }

Const
  OCODE_GNOP1             =  $00;                  { No-operation                }
  OCODE_GESD                       =  $FF;                  { End symbol definition       }

{**************************************************************************\
*
* 2-byte orders
*
\**************************************************************************}

{ definitions to help determine whether an order code is a 2-byte order }
  OCODE2_1                         =  $80;
  OCODE2_2                         =  $88;

{ UNSURE #define SHORT_ORDER(oc)  ((((oc)^OCODE2_1)&OCODE2_2)==OCODE2_2)}

{ General 2-byte order structure }

Type
  ORDER = Record                        { ord }
    idCode,
    uchData: UCHAR
  End;

{ 2-byte order codes }

Const
  OCODE_GBAR              =  $68;                  { Begin area                  }
  OCODE_GCFIG                      =  $7D;                  { Close figure                }
  OCODE_GEEL                       =  $49;                  { End element                 }
  OCODE_GEPTH                      =  $7F;                  { End path                    }
  OCODE_GEPROL                     =  $3E;                  { End prologue                }
  OCODE_GPOP                       =  $3F;                  { Pop                         }
  OCODE_GSBMX                      =  $0D;                  { Set background mix          }
  OCODE_GPSBMX                     =  $4D;                  { Push & set b/g mix          }
  OCODE_GSCD                       =  $3A;                  { Set char direction          }
  OCODE_GPSCD                      =  $7A;                  { Push & set char direction   }
  OCODE_GSCR                       =  $39;                  { Set char precision          }
  OCODE_GPSCR                      =  $79;                  { Push & set char precision   }
  OCODE_GSCS                       =  $38;                  { Set char set                }
  OCODE_GPSCS                      =  $78;                  { Push & set char set         }
  OCODE_GSCOL                      =  $0A;                  { Set color                   }
  OCODE_GPSCOL                     =  $4A;                  { Push & set color            }
  OCODE_GSLE                       =  $1A;                  { Set line end                }
  OCODE_GPSLE                      =  $5A;                  { Push & set line end         }
  OCODE_GSLJ                       =  $1B;                  { Set line join               }
  OCODE_GPSLJ                      =  $5B;                  { Push & set line join        }
  OCODE_GSLT                       =  $18;                  { Set line type               }
  OCODE_GPSLT                      =  $58;                  { Push & set line type        }
  OCODE_GSLW                       =  $19;                  { Set line width              }
  OCODE_GPSLW                      =  $59;                  { Push & set line width       }
  OCODE_GSMP                       =  $3B;                  { Set marker precision        }
  OCODE_GPSMP                      =  $7B;                  { Push & set marker precision }
  OCODE_GSMS                       =  $3C;                  { Set marker set              }
  OCODE_GPSMS                      =  $7C;                  { Push & set marker set       }
  OCODE_GSMT                       =  $29;                  { Set marker symbol           }
  OCODE_GPSMT                      =  $69;                  { Push & set marker symbol    }
  OCODE_GSMX                       =  $0C;                  { Set mix                     }
  OCODE_GPSMX                      =  $4C;                  { Push & set mix              }
  OCODE_GSPS                       =  $08;                  { Set pattern set             }
  OCODE_GPSPS                      =  $48;                  { Push & set pattern set      }
  OCODE_GSPT                       =  $28;                  { Set pattern symbol          }
  OCODE_GPSPT                      =  $09;                  { Push & set pattern symbol   }

{ constants for 2-byte orders }

{ Begin area }
  GBAR_RESERVED                    =  $80;
  GBAR_BOUNDARY                    =  $C0;
  GBAR_NOBOUNDARY                  =  $80;
  GBAR_WINDING                     =  $A0;
  GBAR_ALTERNATE                   =  $80;

{ Set Character Precision }
  GSCR_PRECISION                   =  $0F;

{**************************************************************************\
*
* Long orders
*
\**************************************************************************}

{ definitions to help determine whether an order code is a long order }

  OCODE_VLONG                      =  $FE;

{ UNSURE #define LONG_ORDER(oc) (!((oc)==OCODE_VLONG||BYTE_ORDER(oc)||SHORT_ORDER(oc)))}

{ long order structure }
  LORDER_ML                        = 253;

Type
  LORDER = Record                       { lord }
    idCode,
    uchLength: UCHAR;
    uchData: Array [0..LORDER_ML-1] Of UCHAR
  End;

{ Long orders for which the length of data is normally zero }

Const
  OCODE_GEAR              =  $60;                  { End Area                    }
  OCODE_GEIMG                      =  $93;                  { End Image                   }

{ Long orders for which the data is contained in a type already defined }

{ Character String }
  OCODE_GCCHST                     = $83;                   { char string at curr posn    }
  GCCHST_MC                        = 255;                   { Max len of string in bytes  }

  OCODE_GCHST                      = $C3;                   { char string at given pos    }
  GCHST_SMC                        = 251;                   { Max len of string (S)       }
  GCHST_LMC                        = 247;                   { Max len of string (L)       }

{ Character String Move }
  OCODE_GCCHSTM                    =  $B1;                  { char string move at c.p.    }
  GCCHSTM_MC                       = 255;                   { Max len of string in byte   }

  OCODE_GCHSTM                     =  $F1;                  { char string move at g.p.    }
  GCHSTM_SMC                       = 251;                   { Max len of string (S)       }
  GCHSTM_LMC                       = 247;                   { Max len of string (L)       }

{ Comment }
  OCODE_GCOMT                      =  $01;                  { Comment                     }
  GCOMT_ML                         = 255;                   { Maximum len of comment data }

{ Image }
  OCODE_GIMD                       =  $92;                  { Image data                  }
  GIMD_ML                          = 255;                   { Maximum len of image data   }

{ Full Arc }
  OCODE_GCFARC                     =  $87;                  { full arc at current posn    }
  OCODE_GFARC                      =  $C7;                  { full arc at given posn      }

{ Label }
  OCODE_GLABL                      =  $D3;                  { Label                       }

{ Set Current Position }
  OCODE_GSCP                       =  $21;                  { Set current position        }
  OCODE_GPSCP                      =  $61;                  { Push and set curr posn      }

{ Bezier spline }
  OCODE_GCBEZ                      =  $A5;                  { Bezier spline at curr pos   }
  GCBEZ_SMB                        = 21;                    { Max number of splines (S)   }
  GCBEZ_LMB                        = 10;                    { Max number of splines (L)   }

  OCODE_GBEZ                       =  $E5;                  { Bezier spline at given pos  }
  GBEZ_SMB                         = 20;                    { Max number of splines (S)   }
  GBEZ_LMB                         = 10;                    { Max number of splines (L)   }

{ Fillet }
  OCODE_GCFLT                      =  $85;                  { fillet at current posn      }
  GCFLT_SMP                        = 63;                    { Max number of points (S)    }
  GCFLT_LMP                        = 31;                    { Max number of points (L)    }

  OCODE_GFLT                       =  $C5;                  { fillet at given position    }
  GFLT_SMP                         = 62;                    { Max number of points (S)    }
  GFLT_LMP                         = 30;                    { Max number of points (L)    }

{ Polyline }
  OCODE_GCLINE                     =  $81;                  { polyline at current posn    }
  GCLINE_SMP                       = 63;                    { Max number of points (S)    }
  GCLINE_LMP                       = 31;                    { Max number of points (L)    }

  OCODE_GLINE                      =  $C1;                  { polyline at given posn      }
  GLINE_SMP                        = 62;                    { Max number of points (S)    }
  GLINE_LMP                        = 30;                    { Max number of points (L)    }

{ Polymarker }
  OCODE_GCMRK                      =  $82;                  { marker at current posn      }
  GCMRK_SMP                        = 63;                    { Max number of points (S)    }
  GCMRK_LMP                        = 31;                    { Max number of points (L)    }

  OCODE_GMRK                       =  $C2;                  { marker at given posn        }
  GMRK_SMP                         = 62;                    { Max number of points (S)    }
  GMRK_LMP                         = 30;                    { Max number of points (L)    }

{ Relative Line }
  OCODE_GCRLINE                    =  $A1;                  { Relative line at curr pos   }
  GCRLINE_MP                       = 127;                   { Max number of points        }

  OCODE_GRLINE                     =  $E1;                  { Relative line at givn pos   }
  GRLINE_SMP                       = 125;                   { Max number of points (S)    }
  GRLINE_LMP                       = 123;                   { Max number of points (L)    }

{ Set Background Color }
  OCODE_GSBCOL                     =  $25;                  { Set background color        }
  OCODE_GPSBCOL                    =  $65;                  { Push and set b/g color      }

{ Set Extended Color }
  OCODE_GSECOL                     =  $26;                  { Set extended color          }
  OCODE_GPSECOL                    =  $66;                  { Push and set ext color      }

{ Extended Color values }
  SECOL_DEFAULT0                   =  $0000;
  SECOL_DEFAULT1                   =  $FF00;
  SECOL_NEUTRAL                    =  $FF07;
  SECOL_RESET                      =  $FF08;

{ Set Character Angle }
  OCODE_GSCA                       =  $34;                  { Set character angle         }
  OCODE_GPSCA                      =  $74;                  { Push and set char angle     }

{ Set Character Shear }
  OCODE_GSCH                       =  $35;                  { Set character shear         }
  OCODE_GPSCH                      =  $75;                  { Push and set char shear     }

{ Set Fractional Line Width }
  OCODE_GSFLW                      =  $11;                  { Set fractional line width   }
  OCODE_GPSFLW                     =  $51;                  { Push and set frac l width   }

{ Set Pick Identifier }
  OCODE_GSPIK                      =  $43;                  { Set pick identifier         }
  OCODE_GPSPIK                     =  $23;                  { Push and set pick id        }


{ Long Orders for which a structure can be defined for the data }

{ Arc }
  OCODE_GCARC                      =  $86;                  { Arc at Current Position     }
  OCODE_GARC                       =  $C6;                  { Arc at Given Position       }


Type
  ORDERS_GCARC = Record                 { osgcarc }
    ptInter,
    ptEnd: POINTS
  End;

  ORDERL_GCARC = Record                 { olgcarc }
    ptInter,
    ptEnd: POINTL
  End;

{ Begin Element }

Const
  OCODE_GBEL              =  $D2;                  { Begin Element               }

  GBEL_DL                          = 251;

Type
  ORDER_GBEL = Record                   { ogbel }
    lElementType: LongInt;
    achDesc: Array[0..GBEL_DL-1] Of Char
  End;

{ Begin Image }

Const
  OCODE_GCBIMG            =  $91;                  { Begin Image at curr posn    }
  OCODE_GBIMG                      =  $D1;                  { Begin Image at given posn   }


Type
  ORDER_GCBIMG = Record                 { ogbimg }
    uchFormat,
    uchReserved: UCHAR;
    cx,
    cy: SWPUSHORT
  End;

{ Begin Path }

Const
  OCODE_GBPTH             =  $D0;                  { Begin Path                  }


Type
  ORDER_GBPTH = Record                  { ogbpth }
    usReserved: USHORT;
    idPath: LongInt
  End;

{ Box }

Const
  OCODE_GCBOX             =  $80;                  { Box at current position     }
  OCODE_GBOX                       =  $C0;                  { Box at given position       }


Type
  ORDERS_GCBOX = Record                 { osgcbox }
    fbFlags,
    uchReserved: UCHAR;
    ptCorner: POINTS;
    hAxis,
    vAxis: SHORT
  End;

  ORDERL_GCBOX = Record                 { olgcbox }
    fbFlags,
    uchReserved: UCHAR;
    ptCorner: POINTL;
    hAxis,
    vAxis: LongInt
  End;


Const
  GCBOX_FILL              =  $40;
  GCBOX_BOUNDARY                   =  $20;

{ Call Segment }
  OCODE_GCALLS                     =  $07;                  { call segment                }


Type
  ORDER_GCALLS = Record                 { ogcalls }
    sReserved: USHORT;
    idSegment: LongInt
  End;

{ Fill Path }

Const
  OCODE_GFPTH             =  $D7;                  { Fill path                   }

Type
  ORDER_GFPTH = Record                  { ogfpth }
    fbFlags,
    uchReserved: UCHAR;
    idPath: LongInt
  End;


Const
  GFPTH_ALTERNATE         =  $00;
  GFPTH_WINDING                    =  $40;
  GFPTH_MODIFY                     =  $20;

{ Outline Path }
  OCODE_GOPTH                      =  $D4;                  { Outline Path                }

Type
  ORDER_GOPTH = Record                  { ogopth }
    fbFlags,
    uchReserved: UCHAR;
    idPath: LongInt
  End;

{ Modify Path }

Const
  OCODE_GMPTH             =  $D8;                  { modify path                 }


Type
  ORDER_GMPTH = Record                  { ogmpth }
    uchMode,
    uchReserved: UCHAR;
    idPath: LongInt
  End;


Const
  GMPTH_STROKE            =  $06;

{ Partial Arc }
  OCODE_GCPARC                     =  $A3;                  { Partial arc at curr posn    }
  OCODE_GPARC                      =  $E3;                  { Partial arc at given posn   }


Type
  ORDERS_GCPARC = Record                { osgcparc }
    ptCenter: POINTS;
    ufx88Multiplier: FIXED88;
    usStartAngle,
    usSweepAngle: LongInt
  End;

  ORDERL_GCPARC = Record                { olgcparc }
    ptCenter: POINTL;
    ufxMultiplier: FIXED;
    usStartAngle,
    usSweepAngle: LongInt
  End;

{ Set Clip Path }

Const
  OCODE_GSCPTH            =  $B4;                  { Set clip path               }


Type
  ORDER_GSCPTH = Record                 { ogscpth }
    fbFlags,
    uchReserved: UCHAR;
    idPath: LongInt
  End;


Const
  GSCPTH_ALTERNATE        =  $00;
  GSCPTH_WINDING                   =  $40;
  GSCPTH_RESET                     =  $00;
  GSCPTH_INTERSECT                 =  $20;

{ Set Arc Parameters }
  OCODE_GSAP                       =  $22;                  { Set arc parameters          }
  OCODE_GPSAP                      =  $62;                  { Push and set arc params     }


Type
  ORDERS_GSAP = Record                  { osgsap }
    p,
    q,
    r,
    s: SHORT
  End;

  ORDERL_GSAP = Record                  { olgsap }
    p,
    q,
    r,
    s: LongInt
  End;

{ Set Background Indexed Color }

Const
  OCODE_GSBICOL           =  $A7;                  { Set b/g indexed color       }
  OCODE_GPSBICOL                   =  $E7;                  { Push and set b/g ind color  }
  OCODE_GSICOL                     =  $A6;                  { Set indexed color           }
  OCODE_GPSICOL                    =  $E6;                  { Push and set indexd color   }


Type
  ORDER_GSBICOL = Record                { ogbicol }
    fbFlags: UCHAR;
    auchColor: Array[0..2] Of UCHAR
  End;


Const
  SICOL_SPECIFY           =  $00;
  SICOL_SPECIAL                    =  $40;
  SICOL_DEFAULT                    =  $80;
  SICOL_BLACK                      = 1;
  SICOL_WHITE                      = 2;
  SICOL_ONES                       = 4;
  SICOL_ZEROES                     = 5;

{ Set Character Cell }
  OCODE_GSCC                       =  $33;                  { Set character cell          }
  OCODE_GPSCC                      =  $03;                  { Push and set char cell      }


Type
  ORDERS_GSCC = Record                  { osgscc }
    cxInt,
    cyInt: SHORT;
    cxFract,
    cyFract: USHORT;
    fbFlags,
    uchReserved: UCHAR
  End;

  ORDERL_GSCC = Record                  { olgscc }
    cxInt,
    cyInt: LongInt;
    cxFract,
    cyFract: USHORT;
    fbFlags,
    uchReserved: UCHAR
  End;


Const
  GSCC_ZERODEF            =  $00;
  GSCC_ZEROZERO                    =  $80;

{ Set Marker Cell }
  OCODE_GSMC                       =  $37;                  { Set marker cell             }
  OCODE_GPSMC                      =  $77;                  { Push and set marker cell    }


Type
  ORDERS_GSMC = Record                  { osgsmc }
    cx,
    cy: SHORT;
    fbFlags,
    uchReserved: UCHAR
  End;

  ORDERL_GSMC = Record                  { olgsmc }
    cx,
    cy: LongInt;
    fbFlags,
    uchReserved: UCHAR
  End;


Const
  GSMC_ZERODEF            =  $00;
  GSMC_ZEROZERO                    =  $80;

{ Set Pattern Reference Point }
  OCODE_GSPRP                      =  $A0;                  { Set pattern ref point       }
  OCODE_GPSPRP                     =  $E0;                  { Push and set patt ref pt    }


Type
  ORDERS_GSPRP = Record                 { osgsprp }
    fbFlags,
    uchReserved: UCHAR;
    ptPos: POINTS
  End;

  ORDERL_GSPRP = Record                 { olgsprp }
    fbFlags,
    uchReserved: UCHAR;
    ptPos: POINTL
  End;


Const
  GSPRP_DEFAULT           =  $80;
  GSPRP_SPECIFY                    =  $00;


{ Set Individual Attribute }
  OCODE_GSIA                       =  $14;                  { Set individual attribute    }
  OCODE_GPSIA                      =  $54;                  { Push and set ind attr       }

  GSIA_VL                          = 3;

Type
  ORDER_GSIA = Record                   { ogsia }
    uchAttrType,
    uchPrimType,
    fbFlags: UCHAR;
    auchValue: Array[0..GSIA_VL-1] Of UCHAR
  End;


Const
  GSIA_COLOR              =  $01;
  GSIA_BCOLOR                      =  $02;
  GSIA_MIX                         =  $03;
  GSIA_BMIX                        =  $04;
  GSIA_LINE                        =  $01;
  GSIA_CHAR                        =  $02;
  GSIA_MARKER                      =  $03;
  GSIA_PATTERN                     =  $04;
  GSIA_IMAGE                       =  $05;
  GSIA_SPECIFY                     =  $00;
  GSIA_SPECIAL                     =  $40;
  GSIA_DEFAULT                     =  $80;
  GSIA_BLACK                       = 1;
  GSIA_WHITE                       = 2;
  GSIA_ONES                        = 4;
  GSIA_ZEROES                      = 5;


{ Set Model /Viewing Transform }
  OCODE_GSTM                       =  $24;                  { Set model transform         }
  OCODE_GPSTM                      =  $64;                  { Push and set model tfm      }

  OCODE_GSTV                       =  $31;                  { Set Viewing Transform       }

  GSTM_ML                          = 16;

Type
  ORDERS_GSTM = Record                  { osgstm }
    uchReserved,
    fbFlags: UCHAR;
    fsMask: USHORT;
    asMatrix: Array[0..GSTM_ML-1] Of SHORT
  End;

  ORDERL_GSTM = Record                  { olgstm }
    uchReserved,
    fbFlags: UCHAR;
    fsMask: USHORT;
    alMatrix: Array[0..GSTM_ML-1] Of LongInt
  End;


Const
  GSTM_M11                =  $8000;
  GSTM_M12                         =  $4000;
  GSTM_M13                         =  $2000;
  GSTM_M14                         =  $1000;
  GSTM_M21                         =  $0800;
  GSTM_M22                         =  $0400;
  GSTM_M23                         =  $0200;
  GSTM_M24                         =  $0100;
  GSTM_M31                         =  $0080;
  GSTM_M32                         =  $0040;
  GSTM_M33                         =  $0020;
  GSTM_M34                         =  $0010;
  GSTM_M41                         =  $0008;
  GSTM_M42                         =  $0004;
  GSTM_M43                         =  $0002;
  GSTM_M44                         =  $0001;

  GSTM_UNITY                       =  $00;
  GSTM_AFTER                       =  $01;
  GSTM_BEFORE                      =  $02;
  GSTM_OVERWRITE                   =  $03;

  GSTV_OVERWRITE                   =  $00;
  GSTV_AFTER                       =  $04;

{ Set Segment Boundary, Viewing Window }

  OCODE_GSSB                       =  $32;                  { Set segment boundary        }
  OCODE_GSVW                       =  $27;                  { Set viewing window          }
  OCODE_GPSVW                      =  $67;                  { Push and set view window    }

  GSSB_ML                          = 4;

Type
  ORDERS_GSSB = Record                  { osgssb }
    fbFlags,
    fbMask: UCHAR;
    alMatrix: Array[0..GSSB_ML-1] Of SHORT
  End;

  ORDERL_GSSB = Record                  { olgssb }
    fbFLags,
    fbMask: UCHAR;
    alMatrix: Array[0..GSSB_ML-1] Of LongInt
  End;


Const
  GSSB_XLEFT              =  $20;
  GSSB_XRIGHT                      =  $10;
  GSSB_YBOTTOM                     =  $08;
  GSSB_YTOP                        =  $04;

  GSVW_INTERSECT                   =  $00;
  GSVW_REPLACE                     =  $80;

{ Set Segment Characteristics }
  OCODE_GSGCH                      =  $04;                  { Set segment characteristics }

  GSGCH_ML                         = 254;

Type
  ORDER_GSGCH = Record                  { ogsgch }
    uchIdent: UCHAR;
    auchData: Array[0..GSGCH_ML-1] Of UCHAR
  End;

{ Set Stroke Line Width }

Const
  OCODE_GSSLW             =  $15;                  { Set stroke line width       }
  OCODE_GPSSLW                     =  $55;                  { Push and set strk l width   }


Type
  ORDERS_GSSLW = Record                 { osgsslw }
    fbFlags,
    uchReserved: UCHAR;
    LineWidth: SHORT
  End;

  ORDERL_GSSLW = Record                 { olgsslw }
    fbFlags,
    uchReserved: UCHAR;
    LineWidth: LongInt
  End;


Const
  GSSLW_DEFAULT           =  $80;
  GSSLW_SPECIFY                    =  $00;

{ Sharp Fillet at Current Position }
  OCODE_GCSFLT                     =  $A4;                  { Sharp fillet at curr pos    }
  OCODE_GSFLT                      =  $E4;                  { Sharp fillet at given pos   }

  GCSFLT_SMF                       = 21;
  GSFLT_SMF                        = 20;


Type
  ORDERS_GCSFLT = Record                { osgcsflt }
    apt: Array[0..2*GCSFLT_SMF-1] Of POINTS;
    afxSharpness: Array[0..GCSFLT_SMF-1] Of FIXED
  End;


Const
  GCSFLT_LMF              = 12;
  GSFLT_LMF               = 12;


Type
  ORDERL_GCSFLT = Record                { olgcsflt }
    apt: Array[0..2*GCSFLT_SMF-1] Of POINTS;
    afxSharpness: Array[0..GCSFLT_SMF-1] Of FIXED
  End;

{ Bitblt }

Const
  OCODE_GBBLT             =  $D6;                  { Bitblt                      }


Type
  ORDERS_GBBLT = Record                 { osgbblt }
    fsFlags,
    usMix: USHORT;
    hbmSrc: HBITMAP;
    lOptions: LongInt;
    rcsTargetRect: RECT1S;
    rclSourceRect: RECTL
  End;

  ORDERL_GBBLT = Record                 { olgbblt }
    fsFlags,
    usMix: USHORT;
    hbmSrc: HBITMAP;
    lOptions: LongInt;
    rclTargetRect,
    rclSourceRect: RECTL
  End;

{ Escape }

Const
  OCODE_GESCP             =  $D5;                  { Escape                      }

{
 * type describes type of escape order, identifier gives the escape
 * order if the type is registered
 }
  GESCP_ML                         = 253;

Type
  ORDER_GESCP = Record                  { ogescp }
    uchType,
    uchIdent: UCHAR;
    auchData: Array[0..GESCP_ML-1] Of UCHAR           { Escape data }
  End;


Const
  GESCP_REG               =  $80;                  { identifier is registered    }

{ Escape}
  GEBB_REGID                       =  $02;                  { uchIdent - Bitblt           }

  ETYPE_GEBB                       =  $800200D5 ;

  GEBB_LMP                         = 29;

Type
  ORDERL_GEBB = Record                  { olgebb }
    fbFlags: UCHAR;
    usMix: USHORT;
    cPoints: UCHAR;
    hbmSrc: HBITMAP;
    lReserved,
    lOptions: LongInt;
    aptPoints: Array[0..GEBB_LMP-1] Of POINTL
  End;

{ Escape }

Const
  GEPEL_REGID             =  $01;                  { uchIdent - Set Pel          }

  ETYPE_GEPEL                      =  $800100D5 ;

{ Element Types for attribute bundles }
  ETYPE_LINEBUNDLE                 =  $0000FD01 ;
  ETYPE_CHARBUNDLE                 =  $0000FD02 ;
  ETYPE_MARKERBUNDLE               =  $0000FD03 ;
  ETYPE_AREABUNDLE                 =  $0000FD04 ;
  ETYPE_IMAGEBUNDLE                =  $0000FD05 ;

{**************************************************************************\
*
* Very long orders
*
\**************************************************************************}

{ macro to tell whether this is a very long order }
{ UNSURE #define VLONG_ORDER(oc)  ((oc)==OCODE_VLONG)}

{ Very long order structure }
  VORDER_ML                        = 65531;

Type
  VORDER = Record                       { vord }
    idCode,
    uchQualifier: UCHAR;
    uchLength: SWPUSHORT;
    uchData: Array[0..VORDER_ML-1] Of UCHAR
  End;

{ Character String Extended }

Const
  OCODEQ_GCCHSTE          =  $B0;                  { Qualifier - current posn    }
  OCODEQ_GCHSTE                    =  $F0;                  { Qualifier - given position  }

  ETYPE_GCCHSTE                    =  $0000FEB0 ;
  ETYPE_GCHSTE                     =  $0000FEF0 ;


Type
  ORDERS_GCCHSTE = Record               { osgcchste }
    fbFlags,
    uchReserved: UCHAR;
    ptRect: Array[0..1] Of POINTS;
    cchString: SWPUSHORT;
    achString: Array[0..0] Of Char;
    adx: Array[0..0] Of SHORT
  End;

  ORDERL_GCCHSTE = Record               { olgcchste }
    fbFlags,
    uchReserved: UCHAR;
    ptRect: Array[0..1] Of POINTL;
    cchString: SWPUSHORT;
    achString: Array[0..0] Of Char;
    adx: Array[0..0] Of LongInt
  End;

Const
  GCCHSTE_DRAWRECT        =  $80;
  GCCHSTE_NORECT                   =  $00;
  GCCHSTE_CLIP                     =  $40;
  GCCHSTE_NOCLIP                   =  $00;
  GCCHSTE_DEEMPHASIZE              =  $20;
  GCCHSTE_NODEEMPHASIZE            =  $00;
  GCCHSTE_LEAVEPOS                 =  $10;
  GCCHSTE_MOVEPOS                  =  $00;

{ Extended Escape }
  OCODEQ_GEESCP                    =  $D5;                  { Qualifier - extended escape }

  GEESCP_ML                        = 65533;

Type
  ORDER_GEESCP = Record                 { ogeescp }
    uchType,
    uchIdent: UCHAR;
    auchData: Array[0..GEESCP_ML-1] Of UCHAR
  End;
Implementation
End.
