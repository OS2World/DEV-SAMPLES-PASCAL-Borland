{********************************************************}
{                                                        }
{ FILE NAME: ERROR2.H                                    }
{                                                        }
{ COPYRIGHT: IBM Corp., 1987-1990                        }
{                                                        }
{ REVISION LEVEL: 1.3                                    }
{                                                        }
{ WHAT THIS FILE DOES:                                   }
{     This file contains equates associating error codes }
{     returned from system function calls.  The equates  }
{     in this file start at 303.  You must include       }
{     ERROR.H    for return codes under 303.             }
{                                                        }
{ WHAT YOU NEED TO USE THIS FILE:                        }
{                                                        }
{     IN YOUR SOURCE PROGRAM:                            }
{                                                        }
{         #include <ERROR2.H>                            }
{                                                        }
{********************************************************}


{| Version:   1.00
 | Original translation: Peter Singer (PSi)
 }
Unit Error2;
Interface

CONST
     ERROR_INVALID_PROCID           = 303;       { invalid process id }
     ERROR_INVALID_PDELTA           = 304;       { invalid priority delta }
     ERROR_NOT_DESCENDANT           = 305;       { not descendant }
     ERROR_NOT_SESSION_MANAGER      = 306;       { requestor not session manager }
     ERROR_INVALID_PCLASS           = 307;       { invalid p class }
     ERROR_INVALID_SCOPE            = 308;       { invalid scope }
     ERROR_INVALID_THREADID         = 309;       { invalid thread id }
     ERROR_DOSSUB_SHRINK            = 310;       { can't shrink - MspSet }
     ERROR_DOSSUB_NOMEM             = 311;       { no memory - MspAlloc }
     ERROR_DOSSUB_OVERLAP           = 312;       { overlap - MspFree }
     ERROR_DOSSUB_BADSIZE           = 313;       { bad size parameter - MspAlloc or MspFree }
     ERROR_DOSSUB_BADFLAG           = 314;       { bad flag parameter - MspSet }
     ERROR_DOSSUB_BADSELECTOR       = 315;       { invalid MspSegment Selector }
     ERROR_MR_MSG_TOO_LONG          = 316;       { message too long for buffer }
     ERROR_MR_MID_NOT_FOUND         = 317;       { message id number not found }
     ERROR_MR_UN_ACC_MSGF           = 318;       { unable to access message file }
     ERROR_MR_INV_MSGF_FORMAT       = 319;       { invalid message file format }
     ERROR_MR_INV_IVCOUNT           = 320;       { invalid insertion variable count }
     ERROR_MR_UN_PERFORM            = 321;       { unable to perform function }
     ERROR_TS_WAKEUP                = 322;       { unable to wake up }
     ERROR_TS_SEMHANDLE             = 323;       { user passed invalid system semaphore }
     ERROR_TS_NOTIMER               = 324;       { no times available }
     ERROR_TS_HANDLE                = 326;       { invalid timer handle }
     ERROR_TS_DATETIME              = 327;       { date or time invalid }
     ERROR_SYS_INTERNAL             = 328;       { internal system error }
     ERROR_QUE_CURRENT_NAME         = 329;       { current name does not exist }
     ERROR_QUE_PROC_NOT_OWNED       = 330;       { current process does not own queue }
     ERROR_QUE_PROC_OWNED           = 331;       { current process owns queue }
     ERROR_QUE_DUPLICATE            = 332;       { duplicate name }
     ERROR_QUE_ELEMENT_NOT_EXIST    = 333;       { element does not exist }
     ERROR_QUE_NO_MEMORY            = 334;       { inadequate memory }
     ERROR_QUE_INVALID_NAME         = 335;       { invalid name }
     ERROR_QUE_INVALID_PRIORITY     = 336;       { invalid priority parameter }
     ERROR_QUE_INVALID_HANDLE       = 337;       { invalid queue handle }
     ERROR_QUE_LINK_NOT_FOUND       = 338;       { link not found }
     ERROR_QUE_MEMORY_ERROR         = 339;       { memory error }
     ERROR_QUE_PREV_AT_END          = 340;       { previous element was at end of queue }
     ERROR_QUE_PROC_NO_ACCESS       = 341;       { process does not have access to queues }
     ERROR_QUE_EMPTY                = 342;       { queue is empty }
     ERROR_QUE_NAME_NOT_EXIST       = 343;       { queue name does not exist }
     ERROR_QUE_NOT_INITIALIZED      = 344;       { queues not initialized }
     ERROR_QUE_UNABLE_TO_ACCESS     = 345;       { unable to access queues }
     ERROR_QUE_UNABLE_TO_ADD        = 346;       { unable to add new queue }
     ERROR_QUE_UNABLE_TO_INIT       = 347;       { unable to initialize queues }
     ERROR_VIO_INVALID_MASK         = 349;       { invalid replacement mask }
     ERROR_VIO_PTR                  = 350;       { invalid pointer to parameter }
     ERROR_VIO_APTR                 = 351;       { invalid pointer to attribute }
     ERROR_VIO_RPTR                 = 352;       { invalid pointer to row }
     ERROR_VIO_CPTR                 = 353;       { invalid pointer to column }
     ERROR_VIO_LPTR                 = 354;       { invalid pointer to length }
     ERROR_VIO_MODE                 = 355;       { unsupported screen mode }
     ERROR_VIO_WIDTH                = 356;       { invalid cursor width value }
     ERROR_VIO_ATTR                 = 357;       { invalid cursor attribute value }
     ERROR_VIO_ROW                  = 358;       { invalid row value }
     ERROR_VIO_COL                  = 359;       { invalid column value }
     ERROR_VIO_TOPROW               = 360;       { invalid toprow value }
     ERROR_VIO_BOTROW               = 361;       { invalid botrow value }
     ERROR_VIO_RIGHTCOL             = 362;       { invalid right column value }
     ERROR_VIO_LEFTCOL              = 363;       { invalid left column value }
     ERROR_SCS_CALL                 = 364;       { call issued by other than sm }
     ERROR_SCS_VALUE                = 365;       { value is not for save or restore }
     ERROR_VIO_WAIT_FLAG            = 366;       { invalid wait flag setting }
     ERROR_VIO_UNLOCK               = 367;       { screen not previously locked }
     ERROR_SGS_NOT_SESSION_MGR      = 368;       { caller not session manager }
     ERROR_SMG_INVALID_SGID         = 369;       { invalid screen group id }
     ERROR_SMG_INVALID_SESSION_ID   = 369;       { invalid session id }
     ERROR_SMG_NOSG                 = 370;       { all screen groups in use }
     ERROR_SMG_NO_SESSIONS          = 370;       { no sessions available }
     ERROR_SMG_GRP_NOT_FOUND        = 371;       { screen group not found }
     ERROR_SMG_SESSION_NOT_FOUND    = 371;       { session not found }
     ERROR_SMG_SET_TITLE            = 372;       { title set by shell or parent cant be changed }
     ERROR_KBD_PARAMETER            = 373;       { invalid parameter to kbd }
     ERROR_KBD_NO_DEVICE            = 374;       { out of system handles }
     ERROR_KBD_INVALID_IOWAIT       = 375;       { invalid i/o wait specified }
     ERROR_KBD_INVALID_LENGTH       = 376;       { invalid length for keyboard }
     ERROR_KBD_INVALID_ECHO_MASK    = 377;       { invalid echo mode mask }
     ERROR_KBD_INVALID_INPUT_MASK   = 378;       { invalid input mode mask }
     ERROR_MON_INVALID_PARMS        = 379;       { invalid parameters to dos mon }
     ERROR_MON_INVALID_DEVNAME      = 380;       { invalid device name string }
     ERROR_MON_INVALID_HANDLE       = 381;       { invalid device handle }
     ERROR_MON_BUFFER_TOO_SMALL     = 382;       { buffer too small }
     ERROR_MON_BUFFER_EMPTY         = 383;       { buffer is empty }
     ERROR_MON_DATA_TOO_LARGE       = 384;       { data record too large }
     ERROR_MOUSE_NO_DEVICE          = 385;       { no mouse device attached }
     ERROR_MOUSE_INV_HANDLE         = 386;       { mouse device closed (invalid device handle) }
     ERROR_MOUSE_INV_PARMS          = 387;       { parameters invalid or out of range }
     ERROR_MOUSE_CANT_RESET         = 388;       { function assigned and cannot be reset }
     ERROR_MOUSE_DISPLAY_PARMS      = 389;       { parameters invalid for display mode }
     ERROR_MOUSE_INV_MODULE         = 390;       { module not found }
     ERROR_MOUSE_INV_ENTRY_PT       = 391;       { entry point not valid }
     ERROR_MOUSE_INV_MASK           = 392;       { function mask invalid }
     NO_ERROR_MOUSE_NO_DATA         = 393;       { no mouse data }
     NO_ERROR_MOUSE_PTR_DRAWN       = 394;       { pointer drawn }
     ERROR_INVALID_FREQUENCY        = 395;       { invalid frequency for beep }
     ERROR_NLS_NO_COUNTRY_FILE      = 396;       { can't find country.sys }
     ERROR_NLS_OPEN_FAILED          = 397;       { can't open country.sys }
     ERROR_NLS_NO_CTRY_CODE         = 398;       { country code not found }
     ERROR_NO_COUNTRY_OR_CODEPAGE   = 398;       { country code not found }
     ERROR_NLS_TABLE_TRUNCATED      = 399;       { table truncated, buffer too small }
     ERROR_NLS_BAD_TYPE             = 400;       { selector type does not exist }
     ERROR_NLS_TYPE_NOT_FOUND       = 401;       { selector type not in file }
     ERROR_VIO_SMG_ONLY             = 402;       { valid from session manager only }
     ERROR_VIO_INVALID_ASCIIZ       = 403;       { invalid asciiz length }
     ERROR_VIO_DEREGISTER           = 404;       { vio deregister disallowed }
     ERROR_VIO_NO_POPUP             = 405;       { popup not allocated }
     ERROR_VIO_EXISTING_POPUP       = 406;       { popup on screen (no wait) }
     ERROR_KBD_SMG_ONLY             = 407;       { valid from session manager only }
     ERROR_KBD_INVALID_ASCIIZ       = 408;       { invalid asciiz length }
     ERROR_KBD_INVALID_MASK         = 409;       { invalid replacement mask }
     ERROR_KBD_REGISTER             = 410;       { kbdregister disallowed }
     ERROR_KBD_DEREGISTER           = 411;       { kbdderegister disalloed }
     ERROR_MOUSE_SMG_ONLY           = 412;       { valid from session manager only }
     ERROR_MOUSE_INVALID_ASCIIZ     = 413;       { invalid asciiz length }
     ERROR_MOUSE_INVALID_MASK       = 414;       { invalid replacement mask }
     ERROR_MOUSE_REGISTER           = 415;       { mouse register disallowed }
     ERROR_MOUSE_DEREGISTER         = 416;       { mouse deregister disallowed }
     ERROR_SMG_BAD_ACTION           = 417;       { invalid action specified }
     ERROR_SMG_INVALID_CALL         = 418;       { init called more than once }
     ERROR_SCS_SG_NOTFOUND          = 419;       { new screen group # }
     ERROR_SCS_NOT_SHELL            = 420;       { caller is not shell }
     ERROR_VIO_INVALID_PARMS        = 421;       { invalid parms passed in }
     ERROR_VIO_FUNCTION_OWNED       = 422;       { save/restore already owned }
     ERROR_VIO_RETURN               = 423;       { non-destruct return (undo) }
     ERROR_SCS_INVALID_FUNCTION     = 424;       { not valid request for caller }
     ERROR_SCS_NOT_SESSION_MGR      = 425;       { caller not session manager }
     ERROR_VIO_REGISTER             = 426;       { VIO register disallowed }
     ERROR_VIO_NO_MODE_THREAD       = 427;       { No mode restore thread in SG }
     ERROR_VIO_NO_SAVE_RESTORE_THD  = 428;       { No save/rest thread in SG }
     ERROR_VIO_IN_BG                = 429;       { Physical selector requested in background }
     ERROR_VIO_ILLEGAL_DURING_POPUP = 430;       { Function not allowed during popup }
     ERROR_SMG_NOT_BASESHELL        = 431;       { caller is not the base shell }
     ERROR_SMG_BAD_STATUSREQ        = 432;       { invalid status requested }
     ERROR_QUE_INVALID_WAIT         = 433;       { nowait parameter out of bounds }
     ERROR_VIO_LOCK                 = 434;       { error returned from scrlock }
     ERROR_MOUSE_INVALID_IOWAIT     = 435;       { invalid parameters for IO wait }
     ERROR_VIO_INVALID_HANDLE       = 436;       { invalid vio handle }
     ERROR_VIO_ILLEGAL_DURING_LOCK  = 437;       { Function not allowed during screen lock }
     ERROR_VIO_INVALID_LENGTH       = 438;       { invalid vio length }
     ERROR_KBD_INVALID_HANDLE       = 439;       { invalid kbd handle }
     ERROR_KBD_NO_MORE_HANDLE       = 440;       { ran out of handles }
     ERROR_KBD_CANNOT_CREATE_KCB    = 441;       { unable to create kcb }
     ERROR_KBD_CODEPAGE_LOAD_INCOMPL= 442;       { unsuccessful codepage load }
     ERROR_KBD_INVALID_CODEPAGE_ID  = 443;       { invalid codepage id }
     ERROR_KBD_NO_CODEPAGE_SUPPORT  = 444;       { no codepage support }
     ERROR_KBD_FOCUS_REQUIRED       = 445;       { keyboard focus required }
     ERROR_KBD_FOCUS_ALREADY_ACTIVE = 446;       { keyboard focus exists }
     ERROR_KBD_KEYBOARD_BUSY        = 447;       { keyboard busy }
     ERROR_KBD_INVALID_CODEPAGE     = 448;       { invalid codepage }
     ERROR_KBD_UNABLE_TO_FOCUS      = 449;       { focus attempt failed }
     ERROR_SMG_SESSION_NON_SELECT   = 450;       { session is not selectable }
     ERROR_SMG_SESSION_NOT_FOREGRND = 451;       { parent/child session not foreground }
     ERROR_SMG_SESSION_NOT_PARENT   = 452;       { not parent of requested child }
     ERROR_SMG_INVALID_START_MODE   = 453;       { invalid session start mode }
     ERROR_SMG_INVALID_RELATED_OPT  = 454;       { invalid session start related option }
     ERROR_SMG_INVALID_BOND_OPTION  = 455;       { invalid session bond option }
     ERROR_SMG_INVALID_SELECT_OPT   = 456;       { invalid session select option }
     ERROR_SMG_START_IN_BACKGROUND  = 457;       { session started in background }
     ERROR_SMG_INVALID_STOP_OPTION  = 458;       { invalid session stop option }
     ERROR_SMG_BAD_RESERVE          = 459;       { reserved parameters not zero }
     ERROR_SMG_PROCESS_NOT_PARENT   = 460;       { session parent process already exists }
     ERROR_SMG_INVALID_DATA_LENGTH  = 461;       { invalid data length }
     ERROR_SMG_NOT_BOUND            = 462;       { parent not bound }
     ERROR_SMG_RETRY_SUB_ALLOC      = 463;       { retry request block allocation }
     ERROR_KBD_DETACHED             = 464;       { this call disallawed for detached pid }
     ERROR_VIO_DETACHED             = 465;       { this call disallawed for detached pid }
     ERROR_MOU_DETACHED             = 466;       { this call disallawed for detached pid }
     ERROR_VIO_FONT                 = 467;       { no font available to support mode }
     ERROR_VIO_USER_FONT            = 468;       { user font active }
     ERROR_VIO_BAD_CP               = 469;       { invalid code page specified }
     ERROR_VIO_NO_CP                = 470;       { system displays don't support code page }
     ERROR_VIO_NA_CP                = 471;       { current displays doesn't support code page }
     ERROR_INVALID_CODE_PAGE        = 472;       { invalid code page }
     ERROR_CPLIST_TOO_SMALL         = 473;       { code page list is too small }
     ERROR_CP_NOT_MOVED             = 474;       { code page not moved }
     ERROR_MODE_SWITCH_INIT         = 475;       { mode switch init error }
     ERROR_CODE_PAGE_NOT_FOUND      = 476;       { code page not found }
     ERROR_UNEXPECTED_SLOT_RETURNED = 477;       { internal error }
     ERROR_SMG_INVALID_TRACE_OPTION = 478;       { invalid start session trace indicator }
     ERROR_VIO_INTERNAL_RESOURCE    = 479;       { vio internal resource error }
     ERROR_VIO_SHELL_INIT           = 480;       { vio shell init error }
     ERROR_SMG_NO_HARD_ERRORS       = 481;       { no session manager hard errors }
     ERROR_CP_SWITCH_INCOMPLETE     = 482;       { dossetcp unable to set kbd/vio cp }
     ERROR_VIO_TRANSPARENT_POPUP    = 483;       { error during vio popup }
     ERROR_CRITSEC_OVERFLOW         = 484;       { critical section overflow }
     ERROR_CRITSEC_UNDERFLOW        = 485;       { critical section underflow }
     ERROR_VIO_BAD_RESERVE          = 486;       { reserved parameter is not zero }
     ERROR_INVALID_ADDRESS          = 487;       { bad physical address }
     ERROR_ZERO_SELECTORS_REQUESTED = 488;       { must request at least on selector }
     ERROR_NOT_ENOUGH_SELECTORS_AVA = 489;       { not enought GDT selectors to satisfy request }
     ERROR_INVALID_SELECTOR         = 490;       { not a GDT selector }

{ New Equates For OS/2 1.1 }
     ERROR_SMG_INVALID_PROGRAM_TYPE = 491;       { bad program type }
     ERROR_SMG_INVALID_PGM_CONTROL  = 492;       { bad program control }
     ERROR_SMG_INVALID_INHERIT_OPT  = 493;       { bad inherit option }
     ERROR_VIO_EXTENDED_SG          = 494;
     ERROR_VIO_NOT_PRES_MGR_SG      = 495;
     ERROR_VIO_SHIELD_OWNED         = 496;
     ERROR_VIO_NO_MORE_HANDLES      = 497;
     ERROR_VIO_SEE_ERROR_LOG        = 498;
     ERROR_VIO_ASSOCIATED_DC        = 499;
     ERROR_KBD_NO_CONSOLE           = 500;
     ERROR_MOUSE_NO_CONSOLE         = 501;
     ERROR_MOUSE_INVALID_HANDLE     = 502;
     ERROR_SMG_INVALID_DEBUG_PARMS  = 503;
     ERROR_KBD_EXTENDED_SG          = 504;
     ERROR_MOU_EXTENDED_SG          = 505;
     ERROR_SMG_INVALID_ICON_FILE    = 506;

{ New Equates For OS/2 1.2 }
     ERROR_TRC_PID_NON_EXISTENT     = 507;       {request invalid PID }
     ERROR_TRC_COUNT_ACTIVE         = 508;       {trace error active  }
     ERROR_TRC_SUSPENDED_BY_COUNT   = 509;       {trace suspended     }
     ERROR_TRC_COUNT_INACTIVE       = 510;       {trace cnt not active}
     ERROR_TRC_COUNT_REACHED        = 511;       {trace count reached }
     ERROR_NO_MC_TRACE              = 512;       {minor code error    }
     ERROR_MC_TRACE                 = 513;       {bad major/minor table}
     ERROR_TRC_COUNT_ZERO           = 514;       {error count of zero  }
     ERROR_SMG_TOO_MANY_DDS         = 515;
     ERROR_SMG_INVALID_NOTIFICATION = 516;
     ERROR_LF_INVALID_FUNCTION      = 517;       { invalid log request }
     ERROR_LF_NOT_AVAIL             = 518;       { logging not available }
     ERROR_LF_SUSPENDED             = 519;       { logging suspended }
     ERROR_LF_BUF_TOO_SMALL         = 520;       { buffer too small }
     ERROR_LF_BUFFER_CORRUPTED      = 521;       { log buffer corrupted }
     ERROR_LF_INVALID_DAEMON        = 522;       { invalid log daemon }
     ERROR_LF_INVALID_TEMPL         = 523;       { bad template }
     ERROR_LF_GENERAL_FAILURE       = 524;       { general failure }
     ERROR_LF_INVALID_ID            = 525;       { invalid record id }
     ERROR_LF_INVALID_HANDLE        = 526;       { invalid handle }
     ERROR_LF_NO_ID_AVAIL           = 527;       { no id's remain }
     ERROR_LF_TEMPLATE_AREA_FULL    = 528;       { template area full }
     ERROR_LF_ID_IN_USE             = 529;       { id already in use }
     ERROR_MOU_NOT_INITIALIZED      = 530;       { bms dynamic link init not done }
     ERROR_MOUINITREAL_DONE         = 531;       { MouInitReal already done }

{ intercomponent error codes (from 8000H or 32768) }

     ERROR_SWAPPER_NOT_ACTIVE       = 32768;     { swapper is not active }
     ERROR_INVALID_SWAPID           = 32769;     { invalid swap identifier }
     ERROR_IOERR_SWAP_FILE          = 32770;     { i/o error on swap file }
     ERROR_SWAP_TABLE_FULL          = 32771;     { swap control table is full }
     ERROR_SWAP_FILE_FULL           = 32772;     { swap file is full }
     ERROR_CANT_INIT_SWAPPER        = 32773;     { cannot initialize swapper }
     ERROR_SWAPPER_ALREADY_INIT     = 32774;     { swapper already initialized }
     ERROR_PMM_INSUFFICIENT_MEMORY  = 32775;     { insufficient memory }
     ERROR_PMM_INVALID_FLAGS        = 32776;     { invalid flags for phys. mem. }
     ERROR_PMM_INVALID_ADDRESS      = 32777;     { invalid address of phys. mem. }
     ERROR_PMM_LOCK_FAILED          = 32778;     { lock of storage failed }
     ERROR_PMM_UNLOCK_FAILED        = 32779;     { unlock of storage failed }
     ERROR_PMM_MOVE_INCOMPLETE      = 32780;     { move not completed }
     ERROR_UCOM_DRIVE_RENAMED       = 32781;     { drive name was renamed }
     ERROR_UCOM_FILENAME_TRUNCATED  = 32782;     { file name was truncated }
     ERROR_UCOM_BUFFER_LENGTH       = 32783;     { bad buffer length }
     ERROR_MON_CHAIN_HANDLE         = 32784;     { invalid chain handle - mon dh }
     ERROR_MON_NOT_REGISTERED       = 32785;     { monitor not registered }
     ERROR_SMG_ALREADY_TOP          = 32786;     { specified screen group is top }
     ERROR_PMM_ARENA_MODIFIED       = 32787;     { arena modified - phys mem }
     ERROR_SMG_PRINTER_OPEN         = 32788;     { printer open error on prtsc }
     ERROR_PMM_SET_FLAGS_FAILED     = 32789;     { update to arena header flags failed }
     ERROR_INVALID_DOS_DD           = 32790;     { invalid DOS mode device driver }
     ERROR_CPSIO_CODE_PAGE_INVALID  = 65026;     { code page is not available }
     ERROR_CPSIO_NO_SPOOLER         = 65027;     { spooler not started }
     ERROR_CPSIO_FONT_ID_INVALID    = 65028;     { font id is not avail (verify) }
     ERROR_CPSIO_INTERNAL_ERROR     = 65033;     { error caused by switcher internal error }
     ERROR_CPSIO_INVALID_PTR_NAME   = 65034;     { error caused by invalid printer name input }
     ERROR_CPSIO_NOT_ACTIVE         = 65037;     { got code page req - cp switcher not initialized }
     ERROR_CPSIO_PID_FULL           = 65039;     { pid table full- cannot activate another entry }
     ERROR_CPSIO_PID_NOT_FOUND      = 65040;     { received request for pid not in table }
     ERROR_CPSIO_READ_CTL_SEQ       = 65043;     { error reading font file control sequence section }
     ERROR_CPSIO_READ_FNT_DEF       = 65045;     { error reading font file font definition block }
     ERROR_CPSIO_WRITE_ERROR        = 65047;     { error writing to temp spool file }
     ERROR_CPSIO_WRITE_FULL_ERROR   = 65048;     { disk full error writing temp spool file }
     ERROR_CPSIO_WRITE_HANDLE_BAD   = 65049;     { spool file handle bad }
     ERROR_CPSIO_SWIT_LOAD          = 65074;     { switcher load error }
     ERROR_CPSIO_INV_COMMAND        = 65077;     { invalid spool command }
     ROR_CPSIO_NO_FONT_SWIT         = 65078;     { no font switch active }

implementation
end.