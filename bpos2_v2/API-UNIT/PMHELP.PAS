{**************************************************************************\
*
* Module Name: PMHELP.H
*
* OS/2 Information Presentation Facility (IPF) for providing Help
*
* Copyright (c) International Business Machines Corporation 1989, 1990
*
*****************************************************************************
}
{| Version:   1.00
 | Original translation: Peter Sawatzki (ps)
 | Contributing:
 |   Peter Sawatzki ps
 |
 | change history:
 | Date:    Ver: Author:
 | 11/11/93 1.00 ps     original translation by ps
}
Unit PmHelp;
Interface
Uses
  Os2Def;
Type
{****************************************************************************}
{ HelpSubTable entry structure                                               }
{****************************************************************************}
  HELPSUBTABLE = Integer;
  pHELPSUBTABLE = ^HELPSUBTABLE;

{****************************************************************************}
{ HelpTable entry structure                                                  }
{****************************************************************************}

  HELPTABLE = Record
    idAppWindow: USHORT;
    phstHelpSubTable: pHELPSUBTABLE;
    idExtPanel: USHORT
  End;
  pHELPTABLE = ^HELPTABLE;

{****************************************************************************}
{ IPF Initialization Structure used on the                                   }
{ WinCreateHelpInstance() call.                                              }
{****************************************************************************}

  HELPINIT = Record
    cb: USHORT;
    ulReturnCode: ULONG;
    pszTutorialName: pSZ;
    phtHelpTable: pHELPTABLE;
    hmodHelpTableModule,
    hmodAccelActionBarModule: HMODULE;
    idAccelTable,
    idActionBar: USHORT;
    pszHelpWindowTitle:pSZ;
    usShowPanelId: USHORT;
    pszHelpLibraryName: pSZ
  End;
  pHELPINIT = HELPINIT;

Const
{****************************************************************************}
{ Search parent chain indicator for HM_SET_ACTIVE_WINDOW message.            }
{****************************************************************************}
  HWND_PARENT = HWND(0);

{****************************************************************************}
{ Constants used to define whether user wants to display panel using         }
{ panel number or panel name.                                                }
{****************************************************************************}
  HM_RESOURCEID          = 0;
  HM_PANELNAME           = 1;
  HMPANELTYPE_NUMBER     = 0;
  HMPANELTYPE_NAME       = 1;

{****************************************************************************}
{ Constants used to define how the panel IDs are displayed on                }
{ help panels.                                                               }
{****************************************************************************}

  CMIC_HIDE_PANEL_ID      = $0000;
  CMIC_SHOW_PANEL_ID      = $0001;
  CMIC_TOGGLE_PANEL_ID    = $0002;

{****************************************************************************}
{ Window Help function declarations.                                         }
{****************************************************************************}

Function  WinDestroyHelpInstance(hwndHelpInstance: HWND): BOOL;
Function  WinCreateHelpInstance(_hab: HAB; phinitHMInitStructure: PHELPINIT): HWND;
Function  WinAssociateHelpInstance(hwndHelpInstance, hwndApp: HWND): BOOL;
Function  WinQueryHelpInstance(hwndApp: HWND): HWND;
Function  WinLoadHelpTable (hwndHelpInstance: HWND; idHelpTable: USHORT;
                            Module: HMODULE): BOOL;
Function  WinCreateHelpTable (hwndHelpInstance: HWND; phtHelpTable: PHELPTABLE): BOOL;

Const
{****************************************************************************}
{ IPF message base.                                                          }
{****************************************************************************}
  HM_MSG_BASE             = $0220;

{****************************************************************************}
{ Messages applications can send to the IPF.                                 }
{****************************************************************************}

  HM_DISMISS_WINDOW            = HM_MSG_BASE+$0001;
  HM_DISPLAY_HELP              = HM_MSG_BASE+$0002;
  HM_EXT_HELP                  = HM_MSG_BASE+$0003;
  HM_SET_ACTIVE_WINDOW         = HM_MSG_BASE+$0004;
  HM_LOAD_HELP_TABLE           = HM_MSG_BASE+$0005;
  HM_CREATE_HELP_TABLE         = HM_MSG_BASE+$0006;
  HM_SET_HELP_WINDOW_TITLE     = HM_MSG_BASE+$0007;
  HM_SET_SHOW_PANEL_ID         = HM_MSG_BASE+$0008;
  HM_REPLACE_HELP_FOR_HELP     = HM_MSG_BASE+$0009;
  HM_HELP_INDEX                = HM_MSG_BASE+$000a;
  HM_HELP_CONTENTS             = HM_MSG_BASE+$000b;
  HM_KEYS_HELP                 = HM_MSG_BASE+$000c;
  HM_SET_HELP_LIBRARY_NAME     = HM_MSG_BASE+$000d;

{****************************************************************************}
{ Messages the IPF sends to the applications active window                   }
{ as defined by the IPF.                                                     }
{****************************************************************************}

  HM_ERROR                     = HM_MSG_BASE+$000e;
  HM_HELPSUBITEM_NOT_FOUND     = HM_MSG_BASE+$000f;
  HM_QUERY_KEYS_HELP           = HM_MSG_BASE+$0010;
  HM_TUTORIAL                  = HM_MSG_BASE+$0011;
  HM_EXT_HELP_UNDEFINED        = HM_MSG_BASE+$0012;
  HM_ACTIONBAR_COMMAND         = HM_MSG_BASE+$0013;
  HM_INFORM                    = HM_MSG_BASE+$0014;

{****************************************************************************}
{ HMERR_NO_FRAME_WND_IN_CHAIN - There is no frame window in the              }
{ window chain from which to find or set the associated help                 }
{ instance.                                                                  }
{****************************************************************************}

  HMERR_NO_FRAME_WND_IN_CHAIN              = $00001001;

{****************************************************************************}
{ HMERR_INVALID_ASSOC_APP_WND - The application window handle                }
{ specified on the WinAssociateHelpInstance() call is not a valid            }
{ window handle.                                                             }
{****************************************************************************}

  HMERR_INVALID_ASSOC_APP_WND              = $00001002;

{****************************************************************************}
{ HMERR_INVALID_ASSOC_HELP_INST - The help instance handle specified         }
{ on the WinAssociateHelpInstance() call is not a valid                      }
{ window handle.                                                             }
{****************************************************************************}

  HMERR_INVALID_ASSOC_HELP_INST            = $00001003;

{****************************************************************************}
{ HMERR_INVALID_DESTROY_HELP_INST - The window handle specified              }
{ as the help instance to destroy is not of the help instance class.         }
{****************************************************************************}

  HMERR_INVALID_DESTROY_HELP_INST          = $00001004;

{****************************************************************************}
{ HMERR_NO_HELP_INST_IN_CHAIN - The parent or owner chain of the             }
{ application window specified does not have a help instance                 }
{ associated with it.                                                        }
{****************************************************************************}

  HMERR_NO_HELP_INST_IN_CHAIN              = $00001005;

{****************************************************************************}
{ HMERR_INVALID_HELP_INSTANCE_HDL - The handle specified to be a             }
{ help instance does not have the class name of a IPF                        }
{ help instance.                                                             }
{****************************************************************************}

  HMERR_INVALID_HELP_INSTANCE_HDL          = $00001006;

{****************************************************************************}
{ HMERR_INVALID_QUERY_APP_WND - The application window specified on          }
{ a WinQueryHelpInstance() call is not a valid window handle.                }
{****************************************************************************}

  HMERR_INVALID_QUERY_APP_WND              = $00001007;

{****************************************************************************}
{ HMERR_HELP_INST_CALLED_INVALID -  The handle of the help instance          }
{ specified on an API call to the IPF does not have the                      }
{ class name of an IPF help instance.                                        }
{****************************************************************************}

  HMERR_HELP_INST_CALLED_INVALID           = $00001008;
  HMERR_HELPTABLE_UNDEFINE                 = $00001009;
  HMERR_HELP_INSTANCE_UNDEFINE             = $0000100a;
  HMERR_HELPITEM_NOT_FOUND                 = $0000100b;
  HMERR_INVALID_HELPSUBITEM_SIZE           = $0000100c;
  HMERR_HELPSUBITEM_NOT_FOUND              = $0000100d;

{****************************************************************************}
{ HMERR_INDEX_NOT_FOUND - No index in library file.                          }
{****************************************************************************}

  HMERR_INDEX_NOT_FOUND                    = $00002001;

{****************************************************************************}
{ HMERR_CONTENT_NOT_FOUND - Library file does not have any contents.         }
{****************************************************************************}

  HMERR_CONTENT_NOT_FOUND                  = $00002002;

{****************************************************************************}
{ HMERR_OPEN_LIB_FILE     - Cannot open library file.                        }
{****************************************************************************}

  HMERR_OPEN_LIB_FILE                      = $00002003;

{****************************************************************************}
{ HMERR_READ_LIB_FILE     - Cannot read library file.                        }
{****************************************************************************}

  HMERR_READ_LIB_FILE                      = $00002004;

{****************************************************************************}
{ HMERR_CLOSE_LIB_FILE    - Cannot close library file.                       }
{****************************************************************************}

  HMERR_CLOSE_LIB_FILE                     = $00002005;

{****************************************************************************}
{ HMERR_INVALID_LIB_FILE  - Improper library file provided.                  }
{****************************************************************************}

  HMERR_INVALID_LIB_FILE                   = $00002006;

{****************************************************************************}
{ HMERR_NO_MEMORY - Unable to allocate the requested amount of memory.       }
{****************************************************************************}

  HMERR_NO_MEMORY                          = $00002007;

{****************************************************************************}
{ HMERR_ALLOCATE_SEGMENT - Unable                                            }
{ to allocate a segment of memory for memory allocation requested            }
{ from the IPF.                                                              }
{****************************************************************************}

  HMERR_ALLOCATE_SEGMENT                   = $00002008;

{****************************************************************************}
{ HMERR_FREE_MEMORY - Unable to free allocated  memory.                      }
{****************************************************************************}

  HMERR_FREE_MEMORY                        = $00002009;

{****************************************************************************}
{ HMERR_PANEL_NOT_FOUND  - Unable                                            }
{ to find a help panel requested to IPF.                                     }
{****************************************************************************}

  HMERR_PANEL_NOT_FOUND                    = $00002010;

{****************************************************************************}
{ HMERR_DATABASE_NOT_OPEN - Unable to read the unopened database.            }
{****************************************************************************}

  HMERR_DATABASE_NOT_OPEN                  = $00002011;

Implementation
Function WinCreateHelpInstance;    External 'HELPMGR' Index 1;
Function WinDestroyHelpInstance;   External 'HELPMGR' Index 2;
Function WinQueryHelpInstance;     External 'HELPMGR' Index 3;
Function WinAssociateHelpInstance; External 'HELPMGR' Index 4;
Function WinLoadHelpTable;         External 'HELPMGR' Index 5;
Function WinCreateHelpTable;       External 'HELPMGR' Index 6;
End.
