{| Unit: pmpic
 | Version: 1.00
 | translated from file pmpic.H
 | Original translation: Peter Sawatzki (ps)
 | Contributing:
 |   (fill in)
 |
 | change history:
 | Date:    Ver: Author:
 | 11/13/93 1.00 ps     original translation by ps
}
Unit pmpic;
Interface
Uses
  Os2Def;
{**************************************************************************\
*
* Module Name: PMPIC.H
*
* OS/2 Presentation Manager Picture function declarations
*
\**************************************************************************}

{ type of picture to print }


Const
  PIP_MF                           = 1 ;
  PIP_PIF                          = 2 ;

  Function PicPrint (hab: HAB;pszFilename: PSZ;lType: LongInt;pszParams: PSZ): BOOL;

{ type of conversion required }


Const
  PIC_PIFTOMET                     = 0 ;
  PIC_SSTOFONT                     = 2 ;

  Function PicIchg (hab: HAB;pszFilename1,pszFilename2: PSZ;lType: LongInt): BOOL;

Implementation
  Function PicIchg; Begin Unknown('PicIchg','PmPic') End;
  Function PicPrint;                      External 'PMPIC'    Index 1;
End.

