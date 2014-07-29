
(*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*)
(*                                                                   *)
(*     Borland Pascal OS/2 API                                       *)
(*                                                                   *)
(*     DOSTYPES - Dos system types                                   *)
(*                                                                   *)
(*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*)

unit DosTypes;

interface

uses
  OS2Def;

(* ---------------------------- ERROR CODES ------------------------------- *)

const
  NO_ERROR                                = 0;
  ERROR_INVALID_FUNCTION                  = 1;
  ERROR_FILE_NOT_FOUND                    = 2;
  ERROR_PATH_NOT_FOUND                    = 3;
  ERROR_TOO_MANY_OPEN_FILES               = 4;
  ERROR_ACCESS_DENIED                     = 5;
  ERROR_INVALID_HANDLE                    = 6;
  ERROR_ARENA_TRASHED                     = 7;
  ERROR_NOT_ENOUGH_MEMORY                 = 8;
  ERROR_INVALID_BLOCK                     = 9;
  ERROR_BAD_ENVIRONMENT                   = 10;
  ERROR_BAD_FORMAT                        = 11;
  ERROR_INVALID_ACCESS                    = 12;
  ERROR_INVALID_DATA                      = 13;
  ERROR_INVALID_DRIVE                     = 15;
  ERROR_CURRENT_DIRECTORY                 = 16;
  ERROR_NOT_SAME_DEVICE                   = 17;
  ERROR_NO_MORE_FILES                     = 18;
  ERROR_WRITE_PROTECT                     = 19;
  ERROR_BAD_UNIT                          = 20;
  ERROR_NOT_READY                         = 21;
  ERROR_BAD_COMMAND                       = 22;
  ERROR_CRC                               = 23;
  ERROR_BAD_LENGTH                        = 24;
  ERROR_SEEK                              = 25;
  ERROR_NOT_DOS_DISK                      = 26;
  ERROR_SECTOR_NOT_FOUND                  = 27;
  ERROR_OUT_OF_PAPER                      = 28;
  ERROR_WRITE_FAULT                       = 29;
  ERROR_READ_FAULT                        = 30;
  ERROR_GEN_FAILURE                       = 31;
  ERROR_SHARING_VIOLATION                 = 32;
  ERROR_LOCK_VIOLATION                    = 33;
  ERROR_WRONG_DISK                        = 34;
  ERROR_FCB_UNAVAILABLE                   = 35;
  ERROR_SHARING_BUFFER_EXCEEDED           = 36;
  ERROR_CODE_PAGE_MISMATCHED              = 37;
  ERROR_HANDLE_EOF                        = 38;
  ERROR_HANDLE_DISK_FULL                  = 39;
  ERROR_NOT_SUPPORTED                     = 50;
  ERROR_REM_NOT_LIST                      = 51;
  ERROR_DUP_NAME                          = 52;
  ERROR_BAD_NETPATH                       = 53;
  ERROR_NETWORK_BUSY                      = 54;
  ERROR_DEV_NOT_EXIST                     = 55;
  ERROR_TOO_MANY_CMDS                     = 56;
  ERROR_ADAP_HDW_ERR                      = 57;
  ERROR_BAD_NET_RESP                      = 58;
  ERROR_UNEXP_NET_ERR                     = 59;
  ERROR_BAD_REM_ADAP                      = 60;
  ERROR_PRINTQ_FULL                       = 61;
  ERROR_NO_SPOOL_SPACE                    = 62;
  ERROR_PRINT_CANCELLED                   = 63;
  ERROR_NETNAME_DELETED                   = 64;
  ERROR_NETWORK_ACCESS_DENIED             = 65;
  ERROR_BAD_DEV_TYPE                      = 66;
  ERROR_BAD_NET_NAME                      = 67;
  ERROR_TOO_MANY_NAMES                    = 68;
  ERROR_TOO_MANY_SESS                     = 69;
  ERROR_SHARING_PAUSED                    = 70;
  ERROR_REQ_NOT_ACCEP                     = 71;
  ERROR_REDIR_PAUSED                      = 72;
  ERROR_SBCS_ATT_WRITE_PROT               = 73;
  ERROR_SBCS_GENERAL_FAILURE              = 74;
  ERROR_XGA_OUT_MEMORY                    = 75;
  ERROR_FILE_EXISTS                       = 80;
  ERROR_DUP_FCB                           = 81;
  ERROR_CANNOT_MAKE                       = 82;
  ERROR_FAIL_I24                          = 83;
  ERROR_OUT_OF_STRUCTURES                 = 84;
  ERROR_ALREADY_ASSIGNED                  = 85;
  ERROR_INVALID_PASSWORD                  = 86;
  ERROR_INVALID_PARAMETER                 = 87;
  ERROR_NET_WRITE_FAULT                   = 88;
  ERROR_NO_PROC_SLOTS                     = 89;
  ERROR_NOT_FROZEN                        = 90;
  ERROR_SYS_COMP_NOT_LOADED               = 90;
  ERR_TSTOVFL                             = 91;
  ERR_TSTDUP                              = 92;
  ERROR_NO_ITEMS                          = 93;
  ERROR_INTERRUPT                         = 95;
  ERROR_DEVICE_IN_USE                     = 99;
  ERROR_TOO_MANY_SEMAPHORES               = 100;
  ERROR_EXCL_SEM_ALREADY_OWNED            = 101;
  ERROR_SEM_IS_SET                        = 102;
  ERROR_TOO_MANY_SEM_REQUESTS             = 103;
  ERROR_INVALID_AT_INTERRUPT_TIME         = 104;
  ERROR_SEM_OWNER_DIED                    = 105;
  ERROR_SEM_USER_LIMIT                    = 106;
  ERROR_DISK_CHANGE                       = 107;
  ERROR_DRIVE_LOCKED                      = 108;
  ERROR_BROKEN_PIPE                       = 109;
  ERROR_OPEN_FAILED                       = 110;
  ERROR_BUFFER_OVERFLOW                   = 111;
  ERROR_DISK_FULL                         = 112;
  ERROR_NO_MORE_SEARCH_HANDLES            = 113;
  ERROR_INVALID_TARGET_HANDLE             = 114;
  ERROR_PROTECTION_VIOLATION              = 115;
  ERROR_VIOKBD_REQUEST                    = 116;
  ERROR_INVALID_CATEGORY                  = 117;
  ERROR_INVALID_VERIFY_SWITCH             = 118;
  ERROR_BAD_DRIVER_LEVEL                  = 119;
  ERROR_CALL_NOT_IMPLEMENTED              = 120;
  ERROR_SEM_TIMEOUT                       = 121;
  ERROR_INSUFFICIENT_BUFFER               = 122;
  ERROR_INVALID_NAME                      = 123;
  ERROR_INVALID_LEVEL                     = 124;
  ERROR_NO_VOLUME_LABEL                   = 125;
  ERROR_MOD_NOT_FOUND                     = 126;
  ERROR_PROC_NOT_FOUND                    = 127;
  ERROR_WAIT_NO_CHILDREN                  = 128;
  ERROR_CHILD_NOT_COMPLETE                = 129;
  ERROR_DIRECT_ACCESS_HANDLE              = 130;
  ERROR_NEGATIVE_SEEK                     = 131;
  ERROR_SEEK_ON_DEVICE                    = 132;
  ERROR_IS_JOIN_TARGET                    = 133;
  ERROR_IS_JOINED                         = 134;
  ERROR_IS_SUBSTED                        = 135;
  ERROR_NOT_JOINED                        = 136;
  ERROR_NOT_SUBSTED                       = 137;
  ERROR_JOIN_TO_JOIN                      = 138;
  ERROR_SUBST_TO_SUBST                    = 139;
  ERROR_JOIN_TO_SUBST                     = 140;
  ERROR_SUBST_TO_JOIN                     = 141;
  ERROR_BUSY_DRIVE                        = 142;
  ERROR_SAME_DRIVE                        = 143;
  ERROR_DIR_NOT_ROOT                      = 144;
  ERROR_DIR_NOT_EMPTY                     = 145;
  ERROR_IS_SUBST_PATH                     = 146;
  ERROR_IS_JOIN_PATH                      = 147;
  ERROR_PATH_BUSY                         = 148;
  ERROR_IS_SUBST_TARGET                   = 149;
  ERROR_SYSTEM_TRACE                      = 150;
  ERROR_INVALID_EVENT_COUNT               = 151;
  ERROR_TOO_MANY_MUXWAITERS               = 152;
  ERROR_INVALID_LIST_FORMAT               = 153;
  ERROR_LABEL_TOO_LONG                    = 154;
  ERROR_TOO_MANY_TCBS                     = 155;
  ERROR_SIGNAL_REFUSED                    = 156;
  ERROR_DISCARDED                         = 157;
  ERROR_NOT_LOCKED                        = 158;
  ERROR_BAD_THREADID_ADDR                 = 159;
  ERROR_BAD_ARGUMENTS                     = 160;
  ERROR_BAD_PATHNAME                      = 161;
  ERROR_SIGNAL_PENDING                    = 162;
  ERROR_UNCERTAIN_MEDIA                   = 163;
  ERROR_MAX_THRDS_REACHED                 = 164;
  ERROR_MONITORS_NOT_SUPPORTED            = 165;
  ERROR_UNC_DRIVER_NOT_INSTALLED          = 166;
  ERROR_LOCK_FAILED                       = 167;
  ERROR_SWAPIO_FAILED                     = 168;
  ERROR_SWAPIN_FAILED                     = 169;
  ERROR_BUSY                              = 170;
  ERROR_CANCEL_VIOLATION                  = 173;
  ERROR_ATOMIC_LOCK_NOT_SUPPORTED         = 174;
  ERROR_READ_LOCKS_NOT_SUPPORTED          = 175;
  ERROR_INVALID_SEGMENT_NUMBER            = 180;
  ERROR_INVALID_CALLGATE                  = 181;
  ERROR_INVALID_ORDINAL                   = 182;
  ERROR_ALREADY_EXISTS                    = 183;
  ERROR_NO_CHILD_PROCESS                  = 184;
  ERROR_CHILD_ALIVE_NOWAIT                = 185;
  ERROR_INVALID_FLAG_NUMBER               = 186;
  ERROR_SEM_NOT_FOUND                     = 187;
  ERROR_INVALID_STARTING_CODESEG          = 188;
  ERROR_INVALID_STACKSEG                  = 189;
  ERROR_INVALID_MODULETYPE                = 190;
  ERROR_INVALID_EXE_SIGNATURE             = 191;
  ERROR_EXE_MARKED_INVALID                = 192;
  ERROR_BAD_EXE_FORMAT                    = 193;
  ERROR_ITERATED_DATA_EXCEEDS_64K         = 194;
  ERROR_INVALID_MINALLOCSIZE              = 195;
  ERROR_DYNLINK_FROM_INVALID_RING         = 196;
  ERROR_IOPL_NOT_ENABLED                  = 197;
  ERROR_INVALID_SEGDPL                    = 198;
  ERROR_AUTODATASEG_EXCEEDS_64K           = 199;
  ERROR_RING2SEG_MUST_BE_MOVABLE          = 200;
  ERROR_RELOCSRC_CHAIN_EXCEEDS_SEGLIMIT   = 201;
  ERROR_INFLOOP_IN_RELOC_CHAIN            = 202;
  ERROR_ENVVAR_NOT_FOUND                  = 203;
  ERROR_NOT_CURRENT_CTRY                  = 204;
  ERROR_NO_SIGNAL_SENT                    = 205;
  ERROR_FILENAME_EXCED_RANGE              = 206;
  ERROR_RING2_STACK_IN_USE                = 207;
  ERROR_META_EXPANSION_TOO_LONG           = 208;
  ERROR_INVALID_SIGNAL_NUMBER             = 209;
  ERROR_THREAD_1_INACTIVE                 = 210;
  ERROR_INFO_NOT_AVAIL                    = 211;
  ERROR_LOCKED                            = 212;
  ERROR_BAD_DYNALINK                      = 213;
  ERROR_TOO_MANY_MODULES                  = 214;
  ERROR_NESTING_NOT_ALLOWED               = 215;
  ERROR_CANNOT_SHRINK                     = 216;
  ERROR_ZOMBIE_PROCESS                    = 217;
  ERROR_STACK_IN_HIGH_MEMORY              = 218;
  ERROR_INVALID_EXITROUTINE_RING          = 219;
  ERROR_GETBUF_FAILED                     = 220;
  ERROR_FLUSHBUF_FAILED                   = 221;
  ERROR_TRANSFER_TOO_LONG                 = 222;
  ERROR_FORCENOSWAP_FAILED                = 223;
  ERROR_SMG_NO_TARGET_WINDOW              = 224;
  ERROR_NO_CHILDREN                       = 228;
  ERROR_INVALID_SCREEN_GROUP              = 229;
  ERROR_BAD_PIPE                          = 230;
  ERROR_PIPE_BUSY                         = 231;
  ERROR_NO_DATA                           = 232;
  ERROR_PIPE_NOT_CONNECTED                = 233;
  ERROR_MORE_DATA                         = 234;
  ERROR_VC_DISCONNECTED                   = 240;
  ERROR_CIRCULARITY_REQUESTED             = 250;
  ERROR_DIRECTORY_IN_CDS                  = 251;
  ERROR_INVALID_FSD_NAME                  = 252;
  ERROR_INVALID_PATH                      = 253;
  ERROR_INVALID_EA_NAME                   = 254;
  ERROR_EA_LIST_INCONSISTENT              = 255;
  ERROR_EA_LIST_TOO_LONG                  = 256;
  ERROR_NO_META_MATCH                     = 257;
  ERROR_FINDNOTIFY_TIMEOUT                = 258;
  ERROR_NO_MORE_ITEMS                     = 259;
  ERROR_SEARCH_STRUC_REUSED               = 260;
  ERROR_CHAR_NOT_FOUND                    = 261;
  ERROR_TOO_MUCH_STACK                    = 262;
  ERROR_INVALID_ATTR                      = 263;
  ERROR_INVALID_STARTING_RING             = 264;
  ERROR_INVALID_DLL_INIT_RING             = 265;
  ERROR_CANNOT_COPY                       = 266;
  ERROR_DIRECTORY                         = 267;
  ERROR_OPLOCKED_FILE                     = 268;
  ERROR_OPLOCK_THREAD_EXISTS              = 269;
  ERROR_VOLUME_CHANGED                    = 270;
  ERROR_FINDNOTIFY_HANDLE_IN_USE          = 271;
  ERROR_FINDNOTIFY_HANDLE_CLOSED          = 272;
  ERROR_NOTIFY_OBJECT_REMOVED             = 273;
  ERROR_ALREADY_SHUTDOWN                  = 274;
  ERROR_EAS_DIDNT_FIT                     = 275;
  ERROR_EA_FILE_CORRUPT                   = 276;
  ERROR_EA_TABLE_FULL                     = 277;
  ERROR_INVALID_EA_HANDLE                 = 278;
  ERROR_NO_CLUSTER                        = 279;
  ERROR_CREATE_EA_FILE                    = 280;
  ERROR_CANNOT_OPEN_EA_FILE               = 281;
  ERROR_EAS_NOT_SUPPORTED                 = 282;
  ERROR_NEED_EAS_FOUND                    = 283;
  ERROR_DUPLICATE_HANDLE                  = 284;
  ERROR_DUPLICATE_NAME                    = 285;
  ERROR_EMPTY_MUXWAIT                     = 286;
  ERROR_MUTEX_OWNED                       = 287;
  ERROR_NOT_OWNER                         = 288;
  ERROR_PARAM_TOO_SMALL                   = 289;
  ERROR_TOO_MANY_HANDLES                  = 290;
  ERROR_TOO_MANY_OPENS                    = 291;
  ERROR_WRONG_TYPE                        = 292;
  ERROR_UNUSED_CODE                       = 293;
  ERROR_THREAD_NOT_TERMINATED             = 294;
  ERROR_INIT_ROUTINE_FAILED               = 295;
  ERROR_MODULE_IN_USE                     = 296;
  ERROR_NOT_ENOUGH_WATCHPOINTS            = 297;
  ERROR_TOO_MANY_POSTS                    = 298;
  ERROR_ALREADY_POSTED                    = 299;
  ERROR_ALREADY_RESET                     = 300;
  ERROR_SEM_BUSY                          = 301;
  ERROR_INVALID_PROCID                    = 303;
  ERROR_INVALID_PDELTA                    = 304;
  ERROR_NOT_DESCENDANT                    = 305;
  ERROR_NOT_SESSION_MANAGER               = 306;
  ERROR_INVALID_PCLASS                    = 307;
  ERROR_INVALID_SCOPE                     = 308;
  ERROR_INVALID_THREADID                  = 309;
  ERROR_DOSSUB_SHRINK                     = 310;
  ERROR_DOSSUB_NOMEM                      = 311;
  ERROR_DOSSUB_OVERLAP                    = 312;
  ERROR_DOSSUB_BADSIZE                    = 313;
  ERROR_DOSSUB_BADFLAG                    = 314;
  ERROR_DOSSUB_BADSELECTOR                = 315;
  ERROR_MR_MSG_TOO_LONG                   = 316;
  ERROR_MR_MID_NOT_FOUND                  = 317;
  ERROR_MR_UN_ACC_MSGF                    = 318;
  ERROR_MR_INV_MSGF_FORMAT                = 319;
  ERROR_MR_INV_IVCOUNT                    = 320;
  ERROR_MR_UN_PERFORM                     = 321;
  ERROR_TS_WAKEUP                         = 322;
  ERROR_TS_SEMHANDLE                      = 323;
  ERROR_TS_NOTIMER                        = 324;
  ERROR_TS_HANDLE                         = 326;
  ERROR_TS_DATETIME                       = 327;
  ERROR_SYS_INTERNAL                      = 328;
  ERROR_QUE_CURRENT_NAME                  = 329;
  ERROR_QUE_PROC_NOT_OWNED                = 330;
  ERROR_QUE_PROC_OWNED                    = 331;
  ERROR_QUE_DUPLICATE                     = 332;
  ERROR_QUE_ELEMENT_NOT_EXIST             = 333;
  ERROR_QUE_NO_MEMORY                     = 334;
  ERROR_QUE_INVALID_NAME                  = 335;
  ERROR_QUE_INVALID_PRIORITY              = 336;
  ERROR_QUE_INVALID_HANDLE                = 337;
  ERROR_QUE_LINK_NOT_FOUND                = 338;
  ERROR_QUE_MEMORY_ERROR                  = 339;
  ERROR_QUE_PREV_AT_END                   = 340;
  ERROR_QUE_PROC_NO_ACCESS                = 341;
  ERROR_QUE_EMPTY                         = 342;
  ERROR_QUE_NAME_NOT_EXIST                = 343;
  ERROR_QUE_NOT_INITIALIZED               = 344;
  ERROR_QUE_UNABLE_TO_ACCESS              = 345;
  ERROR_QUE_UNABLE_TO_ADD                 = 346;
  ERROR_QUE_UNABLE_TO_INIT                = 347;
  ERROR_VIO_INVALID_MASK                  = 349;
  ERROR_VIO_PTR                           = 350;
  ERROR_VIO_APTR                          = 351;
  ERROR_VIO_RPTR                          = 352;
  ERROR_VIO_CPTR                          = 353;
  ERROR_VIO_LPTR                          = 354;
  ERROR_VIO_MODE                          = 355;
  ERROR_VIO_WIDTH                         = 356;
  ERROR_VIO_ATTR                          = 357;
  ERROR_VIO_ROW                           = 358;
  ERROR_VIO_COL                           = 359;
  ERROR_VIO_TOPROW                        = 360;
  ERROR_VIO_BOTROW                        = 361;
  ERROR_VIO_RIGHTCOL                      = 362;
  ERROR_VIO_LEFTCOL                       = 363;
  ERROR_SCS_CALL                          = 364;
  ERROR_SCS_VALUE                         = 365;
  ERROR_VIO_WAIT_FLAG                     = 366;
  ERROR_VIO_UNLOCK                        = 367;
  ERROR_SGS_NOT_SESSION_MGR               = 368;
  ERROR_SMG_INVALID_SGID                  = 369;
  ERROR_SMG_INVALID_SESSION_ID            = 369;
  ERROR_SMG_NOSG                          = 370;
  ERROR_SMG_NO_SESSIONS                   = 370;
  ERROR_SMG_GRP_NOT_FOUND                 = 371;
  ERROR_SMG_SESSION_NOT_FOUND             = 371;
  ERROR_SMG_SET_TITLE                     = 372;
  ERROR_KBD_PARAMETER                     = 373;
  ERROR_KBD_NO_DEVICE                     = 374;
  ERROR_KBD_INVALID_IOWAIT                = 375;
  ERROR_KBD_INVALID_LENGTH                = 376;
  ERROR_KBD_INVALID_ECHO_MASK             = 377;
  ERROR_KBD_INVALID_INPUT_MASK            = 378;
  ERROR_MON_INVALID_PARMS                 = 379;
  ERROR_MON_INVALID_DEVNAME               = 380;
  ERROR_MON_INVALID_HANDLE                = 381;
  ERROR_MON_BUFFER_TOO_SMALL              = 382;
  ERROR_MON_BUFFER_EMPTY                  = 383;
  ERROR_MON_DATA_TOO_LARGE                = 384;
  ERROR_MOUSE_NO_DEVICE                   = 385;
  ERROR_MOUSE_INV_HANDLE                  = 386;
  ERROR_MOUSE_INV_PARMS                   = 387;
  ERROR_MOUSE_CANT_RESET                  = 388;
  ERROR_MOUSE_DISPLAY_PARMS               = 389;
  ERROR_MOUSE_INV_MODULE                  = 390;
  ERROR_MOUSE_INV_ENTRY_PT                = 391;
  ERROR_MOUSE_INV_MASK                    = 392;
  NO_ERROR_MOUSE_NO_DATA                  = 393;
  NO_ERROR_MOUSE_PTR_DRAWN                = 394;
  ERROR_INVALID_FREQUENCY                 = 395;
  ERROR_NLS_NO_COUNTRY_FILE               = 396;
  ERROR_NLS_OPEN_FAILED                   = 397;
  ERROR_NLS_NO_CTRY_CODE                  = 398;
  ERROR_NLS_TABLE_TRUNCATED               = 399;
  ERROR_NLS_BAD_TYPE                      = 400;
  ERROR_NLS_TYPE_NOT_FOUND                = 401;
  ERROR_VIO_SMG_ONLY                      = 402;
  ERROR_VIO_INVALID_ASCIIZ                = 403;
  ERROR_VIO_DEREGISTER                    = 404;
  ERROR_VIO_NO_POPUP                      = 405;
  ERROR_VIO_EXISTING_POPUP                = 406;
  ERROR_KBD_SMG_ONLY                      = 407;
  ERROR_KBD_INVALID_ASCIIZ                = 408;
  ERROR_KBD_INVALID_MASK                  = 409;
  ERROR_KBD_REGISTER                      = 410;
  ERROR_KBD_DEREGISTER                    = 411;
  ERROR_MOUSE_SMG_ONLY                    = 412;
  ERROR_MOUSE_INVALID_ASCIIZ              = 413;
  ERROR_MOUSE_INVALID_MASK                = 414;
  ERROR_MOUSE_REGISTER                    = 415;
  ERROR_MOUSE_DEREGISTER                  = 416;
  ERROR_SMG_BAD_ACTION                    = 417;
  ERROR_SMG_INVALID_CALL                  = 418;
  ERROR_SCS_SG_NOTFOUND                   = 419;
  ERROR_SCS_NOT_SHELL                     = 420;
  ERROR_VIO_INVALID_PARMS                 = 421;
  ERROR_VIO_FUNCTION_OWNED                = 422;
  ERROR_VIO_RETURN                        = 423;
  ERROR_SCS_INVALID_FUNCTION              = 424;
  ERROR_SCS_NOT_SESSION_MGR               = 425;
  ERROR_VIO_REGISTER                      = 426;
  ERROR_VIO_NO_MODE_THREAD                = 427;
  ERROR_VIO_NO_SAVE_RESTORE_THD           = 428;
  ERROR_VIO_IN_BG                         = 429;
  ERROR_VIO_ILLEGAL_DURING_POPUP          = 430;
  ERROR_SMG_NOT_BASESHELL                 = 431;
  ERROR_SMG_BAD_STATUSREQ                 = 432;
  ERROR_QUE_INVALID_WAIT                  = 433;
  ERROR_VIO_LOCK                          = 434;
  ERROR_MOUSE_INVALID_IOWAIT              = 435;
  ERROR_VIO_INVALID_HANDLE                = 436;
  ERROR_VIO_ILLEGAL_DURING_LOCK           = 437;
  ERROR_VIO_INVALID_LENGTH                = 438;
  ERROR_KBD_INVALID_HANDLE                = 439;
  ERROR_KBD_NO_MORE_HANDLE                = 440;
  ERROR_KBD_CANNOT_CREATE_KCB             = 441;
  ERROR_KBD_CODEPAGE_LOAD_INCOMPL         = 442;
  ERROR_KBD_INVALID_CODEPAGE_ID           = 443;
  ERROR_KBD_NO_CODEPAGE_SUPPORT           = 444;
  ERROR_KBD_FOCUS_REQUIRED                = 445;
  ERROR_KBD_FOCUS_ALREADY_ACTIVE          = 446;
  ERROR_KBD_KEYBOARD_BUSY                 = 447;
  ERROR_KBD_INVALID_CODEPAGE              = 448;
  ERROR_KBD_UNABLE_TO_FOCUS               = 449;
  ERROR_SMG_SESSION_NON_SELECT            = 450;
  ERROR_SMG_SESSION_NOT_FOREGRND          = 451;
  ERROR_SMG_SESSION_NOT_PARENT            = 452;
  ERROR_SMG_INVALID_START_MODE            = 453;
  ERROR_SMG_INVALID_RELATED_OPT           = 454;
  ERROR_SMG_INVALID_BOND_OPTION           = 455;
  ERROR_SMG_INVALID_SELECT_OPT            = 456;
  ERROR_SMG_START_IN_BACKGROUND           = 457;
  ERROR_SMG_INVALID_STOP_OPTION           = 458;
  ERROR_SMG_BAD_RESERVE                   = 459;
  ERROR_SMG_PROCESS_NOT_PARENT            = 460;
  ERROR_SMG_INVALID_DATA_LENGTH           = 461;
  ERROR_SMG_NOT_BOUND                     = 462;
  ERROR_SMG_RETRY_SUB_ALLOC               = 463;
  ERROR_KBD_DETACHED                      = 464;
  ERROR_VIO_DETACHED                      = 465;
  ERROR_MOU_DETACHED                      = 466;
  ERROR_VIO_FONT                          = 467;
  ERROR_VIO_USER_FONT                     = 468;
  ERROR_VIO_BAD_CP                        = 469;
  ERROR_VIO_NO_CP                         = 470;
  ERROR_VIO_NA_CP                         = 471;
  ERROR_INVALID_CODE_PAGE                 = 472;
  ERROR_CPLIST_TOO_SMALL                  = 473;
  ERROR_CP_NOT_MOVED                      = 474;
  ERROR_MODE_SWITCH_INIT                  = 475;
  ERROR_CODE_PAGE_NOT_FOUND               = 476;
  ERROR_UNEXPECTED_SLOT_RETURNED          = 477;
  ERROR_SMG_INVALID_TRACE_OPTION          = 478;
  ERROR_VIO_INTERNAL_RESOURCE             = 479;
  ERROR_VIO_SHELL_INIT                    = 480;
  ERROR_SMG_NO_HARD_ERRORS                = 481;
  ERROR_CP_SWITCH_INCOMPLETE              = 482;
  ERROR_VIO_TRANSPARENT_POPUP             = 483;
  ERROR_CRITSEC_OVERFLOW                  = 484;
  ERROR_CRITSEC_UNDERFLOW                 = 485;
  ERROR_VIO_BAD_RESERVE                   = 486;
  ERROR_INVALID_ADDRESS                   = 487;
  ERROR_ZERO_SELECTORS_REQUESTED          = 488;
  ERROR_NOT_ENOUGH_SELECTORS_AVA          = 489;
  ERROR_INVALID_SELECTOR                  = 490;
  ERROR_SMG_INVALID_PROGRAM_TYPE          = 491;
  ERROR_SMG_INVALID_PGM_CONTROL           = 492;
  ERROR_SMG_INVALID_INHERIT_OPT           = 493;
  ERROR_VIO_EXTENDED_SG                   = 494;
  ERROR_VIO_NOT_PRES_MGR_SG               = 495;
  ERROR_VIO_SHIELD_OWNED                  = 496;
  ERROR_VIO_NO_MORE_HANDLES               = 497;
  ERROR_VIO_SEE_ERROR_LOG                 = 498;
  ERROR_VIO_ASSOCIATED_DC                 = 499;
  ERROR_KBD_NO_CONSOLE                    = 500;
  ERROR_MOUSE_NO_CONSOLE                  = 501;
  ERROR_MOUSE_INVALID_HANDLE              = 502;
  ERROR_SMG_INVALID_DEBUG_PARMS           = 503;
  ERROR_KBD_EXTENDED_SG                   = 504;
  ERROR_MOU_EXTENDED_SG                   = 505;
  ERROR_SMG_INVALID_ICON_FILE             = 506;
  ERROR_TRC_PID_NON_EXISTENT              = 507;
  ERROR_TRC_COUNT_ACTIVE                  = 508;
  ERROR_TRC_SUSPENDED_BY_COUNT            = 509;
  ERROR_TRC_COUNT_INACTIVE                = 510;
  ERROR_TRC_COUNT_REACHED                 = 511;
  ERROR_NO_MC_TRACE                       = 512;
  ERROR_MC_TRACE                          = 513;
  ERROR_TRC_COUNT_ZERO                    = 514;
  ERROR_SMG_TOO_MANY_DDS                  = 515;
  ERROR_SMG_INVALID_NOTIFICATION          = 516;
  ERROR_LF_INVALID_FUNCTION               = 517;
  ERROR_LF_NOT_AVAIL                      = 518;
  ERROR_LF_SUSPENDED                      = 519;
  ERROR_LF_BUF_TOO_SMALL                  = 520;
  ERROR_LF_BUFFER_CORRUPTED               = 521;
  ERROR_LF_BUFFER_FULL                    = 521;
  ERROR_LF_INVALID_DAEMON                 = 522;
  ERROR_LF_INVALID_RECORD                 = 522;
  ERROR_LF_INVALID_TEMPL                  = 523;
  ERROR_LF_INVALID_SERVICE                = 523;
  ERROR_LF_GENERAL_FAILURE                = 524;
  ERROR_LF_INVALID_ID                     = 525;
  ERROR_LF_INVALID_HANDLE                 = 526;
  ERROR_LF_NO_ID_AVAIL                    = 527;
  ERROR_LF_TEMPLATE_AREA_FULL             = 528;
  ERROR_LF_ID_IN_USE                      = 529;
  ERROR_MOU_NOT_INITIALIZED               = 530;
  ERROR_MOUINITREAL_DONE                  = 531;
  ERROR_DOSSUB_CORRUPTED                  = 532;
  ERROR_MOUSE_CALLER_NOT_SUBSYS           = 533;
  ERROR_ARITHMETIC_OVERFLOW               = 534;
  ERROR_TMR_NO_DEVICE                     = 535;
  ERROR_TMR_INVALID_TIME                  = 536;
  ERROR_PVW_INVALID_ENTITY                = 537;
  ERROR_PVW_INVALID_ENTITY_TYPE           = 538;
  ERROR_PVW_INVALID_SPEC                  = 539;
  ERROR_PVW_INVALID_RANGE_TYPE            = 540;
  ERROR_PVW_INVALID_COUNTER_BLK           = 541;
  ERROR_PVW_INVALID_TEXT_BLK              = 542;
  ERROR_PRF_NOT_INITIALIZED               = 543;
  ERROR_PRF_ALREADY_INITIALIZED           = 544;
  ERROR_PRF_NOT_STARTED                   = 545;
  ERROR_PRF_ALREADY_STARTED               = 546;
  ERROR_PRF_TIMER_OUT_OF_RANGE            = 547;
  ERROR_PRF_TIMER_RESET                   = 548;
  ERROR_VDD_LOCK_USEAGE_DENIED            = 639;
  ERROR_TIMEOUT                           = 640;
  ERROR_VDM_DOWN                          = 641;
  ERROR_VDM_LIMIT                         = 642;
  ERROR_VDD_NOT_FOUND                     = 643;
  ERROR_INVALID_CALLER                    = 644;
  ERROR_PID_MISMATCH                      = 645;
  ERROR_INVALID_VDD_HANDLE                = 646;
  ERROR_VLPT_NO_SPOOLER                   = 647;
  ERROR_VCOM_DEVICE_BUSY                  = 648;
  ERROR_VLPT_DEVICE_BUSY                  = 649;
  ERROR_NESTING_TOO_DEEP                  = 650;
  ERROR_VDD_MISSING                       = 651;
  ERROR_BIDI_INVALID_LENGTH               = 671;
  ERROR_BIDI_INVALID_INCREMENT            = 672;
  ERROR_BIDI_INVALID_COMBINATION          = 673;
  ERROR_BIDI_INVALID_RESERVED             = 674;
  ERROR_BIDI_INVALID_EFFECT               = 675;
  ERROR_BIDI_INVALID_CSDREC               = 676;
  ERROR_BIDI_INVALID_CSDSTATE             = 677;
  ERROR_BIDI_INVALID_LEVEL                = 678;
  ERROR_BIDI_INVALID_TYPE_SUPPORT         = 679;
  ERROR_BIDI_INVALID_ORIENTATION          = 680;
  ERROR_BIDI_INVALID_NUM_SHAPE            = 681;
  ERROR_BIDI_INVALID_CSD                  = 682;
  ERROR_BIDI_NO_SUPPORT                   = 683;
  NO_ERROR_BIDI_RW_INCOMPLETE             = 684;
  ERROR_IMP_INVALID_PARM                  = 691;
  ERROR_IMP_INVALID_LENGTH                = 692;
  ERROR_MON_BAD_BUFFER                    = 730;
  ERROR_MODULE_CORRUPTED                  = 731;
  ERROR_SM_OUTOF_SWAPFILE                 = 1477;
  ERROR_LF_TIMEOUT                        = 2055;
  ERROR_LF_SUSPEND_SUCCESS                = 2057;
  ERROR_LF_RESUME_SUCCESS                 = 2058;
  ERROR_LF_REDIRECT_SUCCESS               = 2059;
  ERROR_LF_REDIRECT_FAILURE               = 2060;
  ERROR_SWAPPER_NOT_ACTIVE                = 32768;
  ERROR_INVALID_SWAPID                    = 32769;
  ERROR_IOERR_SWAP_FILE                   = 32770;
  ERROR_SWAP_TABLE_FULL                   = 32771;
  ERROR_SWAP_FILE_FULL                    = 32772;
  ERROR_CANT_INIT_SWAPPER                 = 32773;
  ERROR_SWAPPER_ALREADY_INIT              = 32774;
  ERROR_PMM_INSUFFICIENT_MEMORY           = 32775;
  ERROR_PMM_INVALID_FLAGS                 = 32776;
  ERROR_PMM_INVALID_ADDRESS               = 32777;
  ERROR_PMM_LOCK_FAILED                   = 32778;
  ERROR_PMM_UNLOCK_FAILED                 = 32779;
  ERROR_PMM_MOVE_INCOMPLETE               = 32780;
  ERROR_UCOM_DRIVE_RENAMED                = 32781;
  ERROR_UCOM_FILENAME_TRUNCATED           = 32782;
  ERROR_UCOM_BUFFER_LENGTH                = 32783;
  ERROR_MON_CHAIN_HANDLE                  = 32784;
  ERROR_MON_NOT_REGISTERED                = 32785;
  ERROR_SMG_ALREADY_TOP                   = 32786;
  ERROR_PMM_ARENA_MODIFIED                = 32787;
  ERROR_SMG_PRINTER_OPEN                  = 32788;
  ERROR_PMM_SET_FLAGS_FAILED              = 32789;
  ERROR_INVALID_DOS_DD                    = 32790;
  ERROR_BLOCKED                           = 32791;
  ERROR_NOBLOCK                           = 32792;
  ERROR_INSTANCE_SHARED                   = 32793;
  ERROR_NO_OBJECT                         = 32794;
  ERROR_PARTIAL_ATTACH                    = 32795;
  ERROR_INCACHE                           = 32796;
  ERROR_SWAP_IO_PROBLEMS                  = 32797;
  ERROR_CROSSES_OBJECT_BOUNDARY           = 32798;
  ERROR_LONGLOCK                          = 32799;
  ERROR_SHORTLOCK                         = 32800;
  ERROR_UVIRTLOCK                         = 32801;
  ERROR_ALIASLOCK                         = 32802;
  ERROR_ALIAS                             = 32803;
  ERROR_NO_MORE_HANDLES                   = 32804;
  ERROR_SCAN_TERMINATED                   = 32805;
  ERROR_TERMINATOR_NOT_FOUND              = 32806;
  ERROR_NOT_DIRECT_CHILD                  = 32807;
  ERROR_DELAY_FREE                        = 32808;
  ERROR_GUARDPAGE                         = 32809;
  ERROR_SWAPERROR                         = 32900;
  ERROR_LDRERROR                          = 32901;
  ERROR_NOMEMORY                          = 32902;
  ERROR_NOACCESS                          = 32903;
  ERROR_NO_DLL_TERM                       = 32904;
  ERROR_CPSIO_CODE_PAGE_INVALID           = 65026;
  ERROR_CPSIO_NO_SPOOLER                  = 65027;
  ERROR_CPSIO_FONT_ID_INVALID             = 65028;
  ERROR_CPSIO_INTERNAL_ERROR              = 65033;
  ERROR_CPSIO_INVALID_PTR_NAME            = 65034;
  ERROR_CPSIO_NOT_ACTIVE                  = 65037;
  ERROR_CPSIO_PID_FULL                    = 65039;
  ERROR_CPSIO_PID_NOT_FOUND               = 65040;
  ERROR_CPSIO_READ_CTL_SEQ                = 65043;
  ERROR_CPSIO_READ_FNT_DEF                = 65045;
  ERROR_CPSIO_WRITE_ERROR                 = 65047;
  ERROR_CPSIO_WRITE_FULL_ERROR            = 65048;
  ERROR_CPSIO_WRITE_HANDLE_BAD            = 65049;
  ERROR_CPSIO_SWIT_LOAD                   = 65074;
  ERROR_CPSIO_INV_COMMAND                 = 65077;
  ERROR_CPSIO_NO_FONT_SWIT                = 65078;
  ERROR_ENTRY_IS_CALLGATE                 = 65079;

(* ----------------------------- ERRORS ----------------------------------- *)

  ERRACT_RETRY                            = 1;
  ERRACT_DLYRET                           = 2;
  ERRACT_USER                             = 3;
  ERRACT_ABORT                            = 4;
  ERRACT_PANIC                            = 5;
  ERRACT_IGNORE                           = 6;
  ERRACT_INTRET                           = 7;

  ERRCLASS_OUTRES                         = 1;
  ERRCLASS_TEMPSIT                        = 2;
  ERRCLASS_AUTH                           = 3;
  ERRCLASS_INTRN                          = 4;
  ERRCLASS_HRDFAIL                        = 5;
  ERRCLASS_SYSFAIL                        = 6;
  ERRCLASS_APPERR                         = 7;
  ERRCLASS_NOTFND                         = 8;
  ERRCLASS_BADFMT                         = 9;
  ERRCLASS_LOCKED                         = 10;
  ERRCLASS_MEDIA                          = 11;
  ERRCLASS_ALREADY                        = 12;
  ERRCLASS_UNK                            = 13;
  ERRCLASS_CANT                           = 14;
  ERRCLASS_TIME                           = 15;

  ERRLOC_UNK                              = 1;
  ERRLOC_DISK                             = 2;
  ERRLOC_NET                              = 3;
  ERRLOC_SERDEV                           = 4;
  ERRLOC_MEM                              = 5;

  FERR_DISABLEHARDERR                     = $0000;
  FERR_ENABLEHARDERR                      = $0001;
  FERR_ENABLEEXCEPTION                    = $0000;
  FERR_DISABLEEXCEPTION                   = $0002;


(* ------------------------- MEMORY MANAGEMENT ---------------------------- *)

const
  PAG_READ                                = $0001;
  PAG_WRITE                               = $0002;
  PAG_EXECUTE                             = $0004;
  PAG_GUARD                               = $0008;
  PAG_COMMIT                              = $0010;
  OBJ_TILE                                = $0040;
  OBJ_PROTECTED                           = $0080;
  OBJ_GETTABLE                            = $0100;
  OBJ_GIVEABLE                            = $0200;
  PAG_DEFAULT                             = $0400;
  PAG_SHARED                              = $2000;
  PAG_FREE                                = $4000;

  DOSSUB_INIT                             = $0001;
  DOSSUB_GROW                             = $0002;
  DOSSUB_SPARSE_OBJ                       = $0004;
  DOSSUB_SERIALIZE                        = $0008;


(* --------------------------- FILE SYSTEM -------------------------------- *)

const
  CCHMAXPATH                              = 260;
  CCHMAXPATHCOMP                          = 256;

  FILE_NORMAL                             = $0000;
  FILE_READONLY                           = $0001;
  FILE_HIDDEN                             = $0002;
  FILE_SYSTEM                             = $0004;
  FILE_DIRECTORY                          = $0010;
  FILE_ARCHIVED                           = $0020;

  FILE_EXISTED                            = $0001;
  FILE_CREATED                            = $0002;
  FILE_TRUNCATED                          = $0003;

  FILE_OPEN                               = $0001;
  FILE_TRUNCATE                           = $0002;
  FILE_CREATE                             = $0010;

  FILE_BEGIN                              = 0;
  FILE_CURRENT                            = 1;
  FILE_END                                = 2;

  OPEN_ACTION_FAIL_IF_EXISTS              = $0000;
  OPEN_ACTION_OPEN_IF_EXISTS              = $0001;
  OPEN_ACTION_REPLACE_IF_EXISTS           = $0002;
  OPEN_ACTION_FAIL_IF_NEW                 = $0000;
  OPEN_ACTION_CREATE_IF_NEW               = $0010;

  OPEN_ACCESS_READONLY                    = $0000;
  OPEN_ACCESS_WRITEONLY                   = $0001;
  OPEN_ACCESS_READWRITE                   = $0002;

  OPEN_SHARE_DENYREADWRITE                = $0010;
  OPEN_SHARE_DENYWRITE                    = $0020;
  OPEN_SHARE_DENYREAD                     = $0030;
  OPEN_SHARE_DENYNONE                     = $0040;

  OPEN_FLAGS_NOINHERIT                    = $0080;
  OPEN_FLAGS_NO_LOCALITY                  = $0000;
  OPEN_FLAGS_SEQUENTIAL                   = $0100;
  OPEN_FLAGS_RANDOM                       = $0200;
  OPEN_FLAGS_RANDOMSEQUENTIAL             = $0300;
  OPEN_FLAGS_NO_CACHE                     = $1000;
  OPEN_FLAGS_FAIL_ON_ERROR                = $2000;
  OPEN_FLAGS_WRITE_THROUGH                = $4000;
  OPEN_FLAGS_DASD                         = $8000;
  OPEN_FLAGS_NONSPOOLED                   = $40000;

  FIL_STANDARD                            = 1;
  FIL_QUERYEASIZE                         = 2;
  FIL_QUERYEASFROMLIST                    = 3;
  FIL_QUERYFULLNAME                       = 5;

  FSAIL_QUERYNAME                         = 1;
  FSAIL_DEVNUMBER                         = 2;
  FSAIL_DRVNUMBER                         = 3;

  FSAT_CHARDEV                            = 1;
  FSAT_PSEUDODEV                          = 2;
  FSAT_LOCALDRV                           = 3;
  FSAT_REMOTEDRV                          = 4;

  DCPY_EXISTING                           = $0001;
  DCPY_APPEND                             = $0002;
  DCPY_FAILEAS                            = $0004;

  DSPI_WRTTHRU                            = $0010;

  HDIR_SYSTEM                             = 1;
  HDIR_CREATE                             = (-1);

  FILE_IGNORE                             = $10000;

  MUST_HAVE_READONLY                      = (FILE_READONLY   or  (FILE_READONLY   shl  8));
  MUST_HAVE_HIDDEN                        = (FILE_HIDDEN     or  (FILE_HIDDEN     shl  8));
  MUST_HAVE_SYSTEM                        = (FILE_SYSTEM     or  (FILE_SYSTEM     shl  8));
  MUST_HAVE_DIRECTORY                     = (FILE_DIRECTORY  or  (FILE_DIRECTORY  shl  8));
  MUST_HAVE_ARCHIVED                      = (FILE_ARCHIVED   or  (FILE_ARCHIVED   shl  8));

  EAT_BINARY                              = $fffe;
  EAT_ASCII                               = $fffd;
  EAT_BITMAP                              = $fffb;
  EAT_METAFILE                            = $fffa;
  EAT_ICON                                = $fff9;
  EAT_EA                                  = $ffee;
  EAT_MVMT                                = $ffdf;
  EAT_MVST                                = $ffde;
  EAT_ASN1                                = $ffdd;

  ENUMEA_LEVEL_NO_VALUE                   = 1;

  ENUMEA_REFTYPE_FHANDLE                  = 0;
  ENUMEA_REFTYPE_PATH                     = 1;
  ENUMEA_REFTYPE_MAX                      = ENUMEA_REFTYPE_PATH;

  FHT_DISKFILE                            = $0000;
  FHT_CHRDEV                              = $0001;
  FHT_PIPE                                = $0002;

  FHB_DSKREMOTE                           = $8000;
  FHB_CHRDEVREMOTE                        = $8000;
  FHB_PIPEREMOTE                          = $8000;

  FS_ATTACH                               = 0;
  FS_DETACH                               = 1;
  FS_SPOOLATTACH                          = 2;
  FS_SPOOLDETACH                          = 3;

  FSCTL_HANDLE                            = 1;
  FSCTL_PATHNAME                          = 2;
  FSCTL_FSDNAME                           = 3;

  FSCTL_ERROR_INFO                        = 1;
  FSCTL_MAX_EASIZE                        = 2;

  FSIL_ALLOC                              = 1;
  FSIL_VOLSER                             = 2;

  HANDTYPE_FILE                           = $0000;
  HANDTYPE_DEVICE                         = $0001;
  HANDTYPE_PIPE                           = $0002;
  HANDTYPE_NETWORK                        = $8000;

  SEARCH_PATH                             = $0000;
  SEARCH_CUR_DIRECTORY                    = $0001;
  SEARCH_ENVIRONMENT                      = $0002;
  SEARCH_IGNORENETERRS                    = $0004;

  FEA_NEEDEA                              = $80;

type
  HDIR = SHANDLE;
  PHDIR = ^HDIR;

  FTIME = word;
  {
    twosecs : Word : 5 ;
    minutes : Word : 6 ;
    hours : Word : 5 ;
  }
  PFTIME = ^FTIME;

  FDATE = word;
  {
    day : Word : 5 ;
    month : Word : 4 ;
    year : Word : 7 ;
  }
  PFDATE = ^FDATE;

  TFSALLOCATE = record
    idFileSystem : Longint;
    cSectorUnit : Longint;
    cUnit : Longint;
    cUnitAvail : Longint;
    cbSector : Word;
  end;
  PFSALLOCATE = ^TFSALLOCATE;

  TEASIZEBUF = record
    cbMaxEASize : Word;
    cbMaxEAListSize : Longint;
  end;
  PEASIZEBUF = ^TEASIZEBUF;

  TFEA = record
    fEA : Byte;
    cbName : Byte;
    cbValue : Word;
  end;
  PFEA = ^TFEA;

  TFEALIST = record
    cbList : Longint;
    list : array[0..1-1] of TFEA;
  end;
  PFEALIST = ^TFEALIST;

  TGEA = record
    cbName : Byte;
    szName : array[0..1-1] of Char;
  end;
  PGEA = ^TGEA;

  TGEALIST = record
    cbList : Longint;
    list : array[0..1-1] of TGEA;
  end;
  PGEALIST = ^TGEALIST;

  TEAOP = record
    fpGEAList : PGEALIST;
    fpFEAList : PFEALIST;
    oError : Longint;
  end;
  PEAOP = ^TEAOP;

  TFEA2 = record
    oNextEntryOffset : Longint;
    fEA : Byte;
    cbName : Byte;
    cbValue : Word;
    szName : array[0..1-1] of Char;
  end;
  PFEA2 = ^TFEA2;

  TFEA2LIST = record
    cbList : Longint;
    list : array[0..1-1] of TFEA2;
  end;
  PFEA2LIST = ^TFEA2LIST;

  TGEA2 = record
    oNextEntryOffset : Longint;
    cbName : Byte;
    szName : array[0..1-1] of Char;
  end;
  PGEA2 = ^TGEA2;

  TGEA2LIST = record
    cbList : Longint;
    list : array[0..1-1] of TGEA2;
  end;
  PGEA2LIST = ^TGEA2LIST;

  TEAOP2 = record
    fpGEA2List : PGEA2LIST;
    fpFEA2List : PFEA2LIST;
    oError : Longint;
  end;
  PEAOP2 = ^TEAOP2;

  TFILESTATUS = record
    fdateCreation : FDATE;
    ftimeCreation : FTIME;
    fdateLastAccess : FDATE;
    ftimeLastAccess : FTIME;
    fdateLastWrite : FDATE;
    ftimeLastWrite : FTIME;
    cbFile : Longint;
    cbFileAlloc : Longint;
    attrFile : Word;
  end;
  PFILESTATUS = ^TFILESTATUS;

  TFILESTATUS2 = record
    fdateCreation : FDATE;
    ftimeCreation : FTIME;
    fdateLastAccess : FDATE;
    ftimeLastAccess : FTIME;
    fdateLastWrite : FDATE;
    ftimeLastWrite : FTIME;
    cbFile : Longint;
    cbFileAlloc : Longint;
    attrFile : Word;
    cbList : Longint;
  end;
  PFILESTATUS2 = ^TFILESTATUS2;

  TFILESTATUS3 = record
    fdateCreation : FDATE;
    ftimeCreation : FTIME;
    fdateLastAccess : FDATE;
    ftimeLastAccess : FTIME;
    fdateLastWrite : FDATE;
    ftimeLastWrite : FTIME;
    cbFile : Longint;
    cbFileAlloc : Longint;
    attrFile : Longint;
  end;
  PFILESTATUS3 = ^TFILESTATUS3;

  TFILESTATUS4 = record
    fdateCreation : FDATE;
    ftimeCreation : FTIME;
    fdateLastAccess : FDATE;
    ftimeLastAccess : FTIME;
    fdateLastWrite : FDATE;
    ftimeLastWrite : FTIME;
    cbFile : Longint;
    cbFileAlloc : Longint;
    attrFile : Longint;
    cbList : Longint;
  end;
  PFILESTATUS4 = ^TFILESTATUS4;

  TFSQBUFFER = record
    iType : Word;
    cbName : Word;
    szName : array[0..1-1] of Char;
    cbFSDName : Word;
    szFSDName : array[0..1-1] of Char;
    cbFSAData : Word;
    rgFSAData : array[0..1-1] of Char;
  end;
  PFSQBUFFER = ^TFSQBUFFER;

  TFSQBUFFER2 = record
    iType : Word;
    cbName : Word;
    cbFSDName : Word;
    cbFSAData : Word;
    szName : array[0..1-1] of Char;
    szFSDName : array[0..1-1] of Char;
    rgFSAData : array[0..1-1] of Char;
  end;
  PFSQBUFFER2 = ^TFSQBUFFER2;

  TSPOOLATTACH = record
    hNmPipe : Word;
    ulKey : Longint;
  end;
  PSPOOLATTACH = ^TSPOOLATTACH;

  TVOLUMELABEL = record
    cch : Byte;
    szVolLabel : array[0..12-1] of Char;
  end;
  PVOLUMELABEL = ^TVOLUMELABEL;

  TFSINFO = record
    fdateCreation : FDATE;
    ftimeCreation : FTIME;
    vol : TVOLUMELABEL;
  end;
  PFSINFO = ^TFSINFO;

  TFILEFINDBUF = record
    fdateCreation : FDATE;
    ftimeCreation : FTIME;
    fdateLastAccess : FDATE;
    ftimeLastAccess : FTIME;
    fdateLastWrite : FDATE;
    ftimeLastWrite : FTIME;
    cbFile : Longint;
    cbFileAlloc : Longint;
    attrFile : Word;
    cchName : Char;
    achName : array[0..CCHMAXPATHCOMP-1] of Char;
  end;
  PFILEFINDBUF = ^TFILEFINDBUF;

  TFILEFINDBUF2 = record
    fdateCreation : FDATE;
    ftimeCreation : FTIME;
    fdateLastAccess : FDATE;
    ftimeLastAccess : FTIME;
    fdateLastWrite : FDATE;
    ftimeLastWrite : FTIME;
    cbFile : Longint;
    cbFileAlloc : Longint;
    attrFile : Word;
    cbList : Longint;
    cchName : Char;
    achName : array[0..CCHMAXPATHCOMP-1] of Char;
  end;
  PFILEFINDBUF2 = ^TFILEFINDBUF2;

  TFILEFINDBUF3 = record
    oNextEntryOffset : Longint;
    fdateCreation : FDATE;
    ftimeCreation : FTIME;
    fdateLastAccess : FDATE;
    ftimeLastAccess : FTIME;
    fdateLastWrite : FDATE;
    ftimeLastWrite : FTIME;
    cbFile : Longint;
    cbFileAlloc : Longint;
    attrFile : Longint;
    cchName : Char;
    achName : array[0..CCHMAXPATHCOMP-1] of Char;
  end;
  PFILEFINDBUF3 = ^TFILEFINDBUF3;

  TFILEFINDBUF4 = record
    oNextEntryOffset : Longint;
    fdateCreation : FDATE;
    ftimeCreation : FTIME;
    fdateLastAccess : FDATE;
    ftimeLastAccess : FTIME;
    fdateLastWrite : FDATE;
    ftimeLastWrite : FTIME;
    cbFile : Longint;
    cbFileAlloc : Longint;
    attrFile : Longint;
    cbList : Longint;
    cchName : Char;
    achName : array[0..CCHMAXPATHCOMP-1] of Char;
  end;
  PFILEFINDBUF4 = ^TFILEFINDBUF4;

  TFILELOCK = record
    lOffset : Longint;
    lRange : Longint;
  end;
  PFILELOCK = ^TFILELOCK;

  TDENA1 = record
    reserved : Char;
    cbName : Char;
    cbValue : Word;
    szName : array[0..1-1] of Char;
  end;
  PDENA1 = ^TDENA1;

  TDENA2 = TFEA2;
  PDENA2 = PFEA2;


(* ---------------------------- DEVICE I/O -------------------------------- *)

const
  DEVINFO_PRINTER                         = 0;
  DEVINFO_RS232                           = 1;
  DEVINFO_FLOPPY                          = 2;
  DEVINFO_COPROCESSOR                     = 3;
  DEVINFO_SUBMODEL                        = 4;
  DEVINFO_MODEL                           = 5;
  DEVINFO_ADAPTER                         = 6;

  INFO_COUNT_PARTITIONABLE_DISKS          = 1;
  INFO_GETIOCTLHANDLE                     = 2;
  INFO_FREEIOCTLHANDLE                    = 3;

  IOCTL_ASYNC                             = $0001;
  IOCTL_SCR_AND_PTRDRAW                   = $0003;
  IOCTL_KEYBOARD                          = $0004;
  IOCTL_PRINTER                           = $0005;
  IOCTL_LIGHTPEN                          = $0006;
  IOCTL_POINTINGDEVICE                    = $0007;
  IOCTL_DISK                              = $0008;
  IOCTL_PHYSICALDISK                      = $0009;
  IOCTL_MONITOR                           = $000a;
  IOCTL_GENERAL                           = $000b;

  ASYNC_SETBAUDRATE                       = $0041;
  ASYNC_SETLINECTRL                       = $0042;
  ASYNC_TRANSMITIMM                       = $0044;
  ASYNC_SETBREAKOFF                       = $0045;
  ASYNC_SETMODEMCTRL                      = $0046;
  ASYNC_STOPTRANSMIT                      = $0047;
  ASYNC_STARTTRANSMIT                     = $0048;
  ASYNC_SETBREAKON                        = $004b;
  ASYNC_SETDCBINFO                        = $0053;
  ASYNC_GETBAUDRATE                       = $0061;
  ASYNC_GETLINECTRL                       = $0062;
  ASYNC_GETCOMMSTATUS                     = $0064;
  ASYNC_GETLINESTATUS                     = $0065;
  ASYNC_GETMODEMOUTPUT                    = $0066;
  ASYNC_GETMODEMINPUT                     = $0067;
  ASYNC_GETINQUECOUNT                     = $0068;
  ASYNC_GETOUTQUECOUNT                    = $0069;
  ASYNC_GETCOMMERROR                      = $006d;
  ASYNC_GETCOMMEVENT                      = $0072;
  ASYNC_GETDCBINFO                        = $0073;

  SCR_ALLOCLDT                            = $0070;
  SCR_DEALLOCLDT                          = $0071;
  PTR_GETPTRDRAWADDRESS                   = $0072;
  SCR_ALLOCLDTOFF                         = $0075;

  KBD_SETTRANSTABLE                       = $0050;
  KBD_SETINPUTMODE                        = $0051;
  KBD_SETINTERIMFLAG                      = $0052;
  KBD_SETSHIFTSTATE                       = $0053;
  KBD_SETTYPAMATICRATE                    = $0054;
  KBD_SETFGNDSCREENGRP                    = $0055;
  KBD_SETSESMGRHOTKEY                     = $0056;
  KBD_SETFOCUS                            = $0057;
  KBD_SETKCB                              = $0058;
  KBD_SETNLS                              = $005c;
  KBD_CREATE                              = $005d;
  KBD_DESTROY                             = $005e;
  KBD_GETINPUTMODE                        = $0071;
  KBD_GETINTERIMFLAG                      = $0072;
  KBD_GETSHIFTSTATE                       = $0073;
  KBD_READCHAR                            = $0074;
  KBD_PEEKCHAR                            = $0075;
  KBD_GETSESMGRHOTKEY                     = $0076;
  KBD_GETKEYBDTYPE                        = $0077;
  KBD_GETCODEPAGEID                       = $0078;
  KBD_XLATESCAN                           = $0079;

  PRT_QUERYJOBHANDLE                      = $0021;
  PRT_SETFRAMECTL                         = $0042;
  PRT_SETINFINITERETRY                    = $0044;
  PRT_INITPRINTER                         = $0046;
  PRT_ACTIVATEFONT                        = $0048;
  PRT_GETFRAMECTL                         = $0062;
  PRT_GETINFINITERETRY                    = $0064;
  PRT_GETPRINTERSTATUS                    = $0066;
  PRT_QUERYACTIVEFONT                     = $0069;
  PRT_VERIFYFONT                          = $006a;

  MOU_ALLOWPTRDRAW                        = $0050;
  MOU_UPDATEDISPLAYMODE                   = $0051;
  MOU_SCREENSWITCH                        = $0052;
  MOU_SETSCALEFACTORS                     = $0053;
  MOU_SETEVENTMASK                        = $0054;
  MOU_SETHOTKEYBUTTON                     = $0055;
  MOU_SETPTRSHAPE                         = $0056;
  MOU_DRAWPTR                             = $0057;
  MOU_REMOVEPTR                           = $0058;
  MOU_SETPTRPOS                           = $0059;
  MOU_SETPROTDRAWADDRESS                  = $005a;
  MOU_SETREALDRAWADDRESS                  = $005b;
  MOU_SETMOUSTATUS                        = $005c;
  MOU_DISPLAYMODECHANGE                   = $005d;
  MOU_GETBUTTONCOUNT                      = $0060;
  MOU_GETMICKEYCOUNT                      = $0061;
  MOU_GETMOUSTATUS                        = $0062;
  MOU_READEVENTQUE                        = $0063;
  MOU_GETQUESTATUS                        = $0064;
  MOU_GETEVENTMASK                        = $0065;
  MOU_GETSCALEFACTORS                     = $0066;
  MOU_GETPTRPOS                           = $0067;
  MOU_GETPTRSHAPE                         = $0068;
  MOU_GETHOTKEYBUTTON                     = $0069;
  MOU_VER                                 = $006a;

  DSK_LOCKDRIVE                           = $0000;
  DSK_UNLOCKDRIVE                         = $0001;
  DSK_REDETERMINEMEDIA                    = $0002;
  DSK_SETLOGICALMAP                       = $0003;
  DSK_BLOCKREMOVABLE                      = $0020;
  DSK_GETLOGICALMAP                       = $0021;
  DSK_SETDEVICEPARAMS                     = $0043;
  DSK_WRITETRACK                          = $0044;
  DSK_FORMATVERIFY                        = $0045;
  DSK_GETDEVICEPARAMS                     = $0063;
  DSK_READTRACK                           = $0064;
  DSK_VERIFYTRACK                         = $0065;

  PDSK_LOCKPHYSDRIVE                      = $0000;
  PDSK_UNLOCKPHYSDRIVE                    = $0001;
  PDSK_WRITEPHYSTRACK                     = $0044;
  PDSK_GETPHYSDEVICEPARAMS                = $0063;
  PDSK_READPHYSTRACK                      = $0064;
  PDSK_VERIFYPHYSTRACK                    = $0065;

  MON_REGISTERMONITOR                     = $0040;

  DEV_FLUSHINPUT                          = $0001;
  DEV_FLUSHOUTPUT                         = $0002;
  DEV_QUERYMONSUPPORT                     = $0060;

  RX_QUE_OVERRUN                          = $0001;
  RX_HARDWARE_OVERRUN                     = $0002;
  PARITY_ERROR                            = $0004;
  FRAMING_ERROR                           = $0008;

  CHAR_RECEIVED                           = $0001;
  LAST_CHAR_SENT                          = $0004;
  CTS_CHANGED                             = $0008;
  DSR_CHANGED                             = $0010;
  DCD_CHANGED                             = $0020;
  BREAK_DETECTED                          = $0040;
  ERROR_OCCURRED                          = $0080;
  RI_DETECTED                             = $0100;

  TX_WAITING_FOR_CTS                      = $0001;
  TX_WAITING_FOR_DSR                      = $0002;
  TX_WAITING_FOR_DCD                      = $0004;
  TX_WAITING_FOR_XON                      = $0008;
  TX_WAITING_TO_SEND_XON                  = $0010;
  TX_WAITING_WHILE_BREAK_ON               = $0020;
  TX_WAITING_TO_SEND_IMM                  = $0040;
  RX_WAITING_FOR_DSR                      = $0080;

  WRITE_REQUEST_QUEUED                    = $0001;
  DATA_IN_TX_QUE                          = $0002;
  HARDWARE_TRANSMITTING                   = $0004;
  CHAR_READY_TO_SEND_IMM                  = $0008;
  WAITING_TO_SEND_XON                     = $0010;
  WAITING_TO_SEND_XOFF                    = $0020;

  CTS_ON                                  = $10;
  DSR_ON                                  = $20;
  RI_ON                                   = $40;
  DCD_ON                                  = $80;

  MODE_DTR_CONTROL                        = $01;
  MODE_DTR_HANDSHAKE                      = $02;
  MODE_CTS_HANDSHAKE                      = $08;
  MODE_DSR_HANDSHAKE                      = $10;
  MODE_DCD_HANDSHAKE                      = $20;
  MODE_DSR_SENSITIVITY                    = $40;

  MODE_AUTO_TRANSMIT                      = $01;
  MODE_AUTO_RECEIVE                       = $02;
  MODE_ERROR_CHAR                         = $04;
  MODE_NULL_STRIPPING                     = $08;
  MODE_BREAK_CHAR                         = $10;
  MODE_RTS_CONTROL                        = $40;
  MODE_RTS_HANDSHAKE                      = $80;
  MODE_TRANSMIT_TOGGLE                    = $c0;

  MODE_NO_WRITE_TIMEOUT                   = $01;
  MODE_READ_TIMEOUT                       = $02;
  MODE_WAIT_READ_TIMEOUT                  = $04;
  MODE_NOWAIT_READ_TIMEOUT                = $06;

  DTR_ON                                  = $01;
  RTS_ON                                  = $02;

  DTR_OFF                                 = $fe;
  RTS_OFF                                 = $fd;

  ASCII_MODE                              = $00;
  BINARY_MODE                             = $80;

  CONVERSION_REQUEST                      = $20;
  INTERIM_CHAR                            = $80;

  HOTKEY_MAX_COUNT                        = $0000;
  HOTKEY_CURRENT_COUNT                    = $0001;

  KBD_DATA_RECEIVED                       = $0001;
  KBD_DATA_BINARY                         = $8000;

  KBD_READ_WAIT                           = $0000;
  KBD_READ_NOWAIT                         = $8000;

  SHIFT_REPORT_MODE                       = $01;


  RIGHTSHIFT                              = $0001;
  LEFTSHIFT                               = $0002;
  CONTROL                                 = $0004;
  ALT                                     = $0008;
  SCROLLLOCK_ON                           = $0010;
  NUMLOCK_ON                              = $0020;
  CAPSLOCK_ON                             = $0040;
  INSERT_ON                               = $0080;
  LEFTCONTROL                             = $0100;
  LEFTALT                                 = $0200;
  RIGHTCONTROL                            = $0400;
  RIGHTALT                                = $0800;
  SCROLLLOCK                              = $1000;
  NUMLOCK                                 = $2000;
  CAPSLOCK                                = $4000;
  SYSREQ                                  = $8000;

  PRINTER_TIMEOUT                         = $0001;
  PRINTER_IO_ERROR                        = $0008;
  PRINTER_SELECTED                        = $0010;
  PRINTER_OUT_OF_PAPER                    = $0020;
  PRINTER_ACKNOWLEDGED                    = $0040;
  PRINTER_NOT_BUSY                        = $0080;

  MOUSE_MOTION                            = $0001;
  MOUSE_MOTION_WITH_BN1_DOWN              = $0002;
  MOUSE_BN1_DOWN                          = $0004;
  MOUSE_MOTION_WITH_BN2_DOWN              = $0008;
  MOUSE_BN2_DOWN                          = $0010;
  MOUSE_MOTION_WITH_BN3_DOWN              = $0020;
  MOUSE_BN3_DOWN                          = $0040;

  MHK_BUTTON1                             = $0001;
  MHK_BUTTON2                             = $0002;
  MHK_BUTTON3                             = $0004;

  MOU_NOWAIT                              = $0000;
  MOU_WAIT                                = $0001;

  MHK_NO_HOTKEY                           = $0000;

  MOUSE_QUEUEBUSY                         = $0001;
  MOUSE_BLOCKREAD                         = $0002;
  MOUSE_FLUSH                             = $0004;
  MOUSE_UNSUPPORTED_MODE                  = $0008;
  MOUSE_DISABLED                          = $0100;
  MOUSE_MICKEYS                           = $0200;

  BUILD_BPB_FROM_MEDIUM                   = $00;
  REPLACE_BPB_FOR_DEVICE                  = $01;
  REPLACE_BPB_FOR_MEDIUM                  = $02;

  DEVTYPE_48TPI                           = $0000;
  DEVTYPE_96TPI                           = $0001;
  DEVTYPE_35                              = $0002;
  DEVTYPE_8SD                             = $0003;
  DEVTYPE_8DD                             = $0004;
  DEVTYPE_FIXED                           = $0005;
  DEVTYPE_TAPE                            = $0006;
  DEVTYPE_UNKNOWN                         = $0007;

type
  HMONITOR = SHANDLE;

  TDCBINFO = record
    usWriteTimeout : Word;
    usReadTimeout : Word;
    fbCtlHndShake : Byte;
    fbFlowReplace : Byte;
    fbTimeout : Byte;
    bErrorReplacementChar : Byte;
    bBreakReplacementChar : Byte;
    bXONChar : Byte;
    bXOFFChar : Byte;
  end;
  PDCBINFO = ^TDCBINFO;

  TLINECONTROL = record
    bDataBits : Byte;
    bParity : Byte;
    bStopBits : Byte;
    fTransBreak : Byte;
  end;
  PLINECONTROL = ^TLINECONTROL;

  TMODEMSTATUS = record
    fbModemOn : Byte;
    fbModemOff : Byte;
  end;
  PMODEMSTATUS = ^TMODEMSTATUS;

  TKBDTYPE = record
    usType : Word;
    reserved1 : Word;
    reserved2 : Word;
  end;
  PKBDTYPE = ^TKBDTYPE;

  TRATEDELAY = record
    usDelay : Word;
    usRate : Word;
  end;
  PRATEDELAY = ^TRATEDELAY;

  TCODEPAGEINFO = record
    pbTransTable : PBYTE;
    idCodePage : Word;
    idTable : Word;
  end;

  TCPID = record
    idCodePage : Word;
    Reserved : Word;
  end;
  PCPID = ^TCPID;

  TSHIFTSTATE = record
    fsState : Word;
    fNLS : Byte;
  end;
  PSHIFTSTATE = ^TSHIFTSTATE;

  THOTKEY = record
    fsHotKey : Word;
    uchScancodeMake : Char;
    uchScancodeBreak : Char;
    idHotKey : Word;
  end;
  PHOTKEY = ^THOTKEY;

  TPTRDRAWFUNCTION = record
    usReturnCode : Word;
    pfnDraw : PFN;
    pchDataSeg : PCH;
  end;
  PPTRDRAWFUNCTION = ^TPTRDRAWFUNCTION;

  TPTRDRAWADDRESS = record
    reserved : Word;
    ptrdfnc : TPTRDRAWFUNCTION;
  end;
  PPTRDRAWADDRESS = ^TPTRDRAWADDRESS;

  TPTRDRAWDATA = record
    cb : Word;
    usConfig : Word;
    usFlag : Word;
  end;
  PPTRDRAWDATA = ^TPTRDRAWDATA;

  TTRACKLAYOUT = record
    bCommand : Byte;
    usHead : Word;
    usCylinder : Word;
    usFirstSector : Word;
    cSectors : Word;
    usSectorNumber : Word;
    usSectorSize : Word;
    TrackTable : array[0..1-1] of Byte;
  end;
  PTRACKLAYOUT = ^TTRACKLAYOUT;

  TTRACKFORMAT = record
    bCommand : Byte;
    usHead : Word;
    usCylinder : Word;
    usReserved : Word;
    cSectors : Word;
    bCylinder : Byte;
    bHead : Byte;
    idSector : Byte;
    bBytesSector : Byte;
    FormatTable : array[0..1-1] of Byte;
  end;
  PTRACKFORMAT = ^TTRACKFORMAT;

  TBIOSPARAMETERBLOCK = record
    usBytesPerSector : Word;
    bSectorsPerCluster : Byte;
    usReservedSectors : Word;
    cFATs : Byte;
    cRootEntries : Word;
    cSectors : Word;
    bMedia : Byte;
    usSectorsPerFAT : Word;
    usSectorsPerTrack : Word;
    cHeads : Word;
    cHiddenSectors : Longint;
    cLargeSectors : Longint;
    abReserved : array[0..6-1] of Byte;
    cCylinders : Word;
    bDeviceType : Byte;
    fsDeviceAttr : Word;
  end;
  PBIOSPARAMETERBLOCK = ^TBIOSPARAMETERBLOCK;

  TDEVICEPARAMETERBLOCK = record
    reserved1 : Word;
    cCylinders : Word;
    cHeads : Word;
    cSectorsPerTrack : Word;
    reserved2 : Word;
    reserved3 : Word;
    reserved4 : Word;
    reserved5 : Word;
  end;
  PDEVICEPARAMETERBLOCK = ^TDEVICEPARAMETERBLOCK;

  TMONITORPOSITION = record
    fPosition : Word;
    index : Word;
    pbInBuf : Longint;
    offOutBuf : Word;
  end;
  PMONITORPOSITION = ^TMONITORPOSITION;

  TFRAME = record
    bCharsPerLine : Byte;
    bLinesPerInch : Byte;
  end;
  PFRAME = ^TFRAME;

  TLDTADDRINFO = record
    pulPhysAddr : PLongint;
    cb : Word;
  end;
  PLDTADDRINFO = ^TLDTADDRINFO;

  TSCREENGROUP = record
    idScreenGrp : Word;
    fTerminate : Word;
  end;
  PSCREENGROUP = ^TSCREENGROUP;

  TRXQUEUE = record
    cch : Word;
    cb : Word;
  end;
  PRXQUEUE = ^TRXQUEUE;

  PGlobalInfoSeg = ^TGlobalInfoSeg;
  TGlobalInfoSeg = Record
                     time                : LongInt;
                     msecs               : LongInt;
                     hour                : Byte;
                     minutes             : Byte;
                     seconds             : Byte;
                     hundredths          : Byte;
                     timezone            : Word;
                     cusecTimerInterval  : Word;
                     day                 : Byte;
                     month               : Byte;
                     year                : Word;
                     weekday             : Byte;
                     uchMajorVersion     : Byte;
                     uchMinorVersion     : Byte;
                     chRevisionLetter    : Byte;
                     sgCurrent           : Byte;
                     sgMax               : Byte;
                     cHugeShift          : Byte;
                     fProtectModeOnly    : Byte;
                     pidForeground       : Word;
                     fDynamicSched       : Byte;
                     csecMaxWait         : Byte;
                     cmsecMinSlice       : Word;
                     cmsecMaxSlice       : Word;
                     bootdrive           : Word;
                     amecRAS             : Array[1..32] of Byte;
                     csgWindowableVioMax : Byte;
                     csgPMMax            : Byte;
                   End;
  PLocalInfoSeg = ^TLocalInfoSeg;
  TLocalInfoSeg  = Record
                     pidCurrent          : PID;
                     pidParent           : PID;
                     prtyCurrent         : Word;
                     tidCurrent          : TID;
                     sgCurrent           : Word;
                     rfProcStatus        : Byte;
                     dummy1              : Byte;
                     fForeground         : WordBool;
                     typeProcess         : Byte;
                     dummy2              : Byte;
                     selEnvironment      : Sel;
                     offCmdLine          : Word;
                     cbDataSegment       : Word;
                     cbStack             : Word;
                     cbHeap              : Word;
                     hmod                : Word;
                     selDS               : Sel;
                   End;


(* -------------------- NATIONAL LANGUAGE SUPPORT ------------------------- *)

type
  TCOUNTRYCODE = record
    country : Longint;
    codepage : Longint;
  end;
  PCOUNTRYCODE = ^TCOUNTRYCODE;

  TCOUNTRYINFO = record
    country : Longint;
    codepage : Longint;
    fsDateFmt : Longint;
    szCurrency : array[0..5-1] of Char;
    szThousandsSeparator : array[0..2-1] of Char;
    szDecimal : array[0..2-1] of Char;
    szDateSeparator : array[0..2-1] of Char;
    szTimeSeparator : array[0..2-1] of Char;
    fsCurrencyFmt : Char;
    cDecimalPlace : Char;
    fsTimeFmt : Char;
    abReserved1 : array[0..2-1] of Word;
    szDataSeparator : array[0..2-1] of Char;
    abReserved2 : array[0..5-1] of Word;
  end;
  PCOUNTRYINFO = ^TCOUNTRYINFO;


(* -------------------------- DYNAMIC LINKING ----------------------------- *)

const
  PT_16BIT                                = 0;
  PT_32BIT                                = 1;



(* ----------------------------- RESOURCES -------------------------------- *)

const
  RT_POINTER                              = 1;
  RT_BITMAP                               = 2;
  RT_MENU                                 = 3;
  RT_DIALOG                               = 4;
  RT_STRING                               = 5;
  RT_FONTDIR                              = 6;
  RT_FONT                                 = 7;
  RT_ACCELTABLE                           = 8;
  RT_RCDATA                               = 9;
  RT_MESSAGE                              = 10;
  RT_DLGINCLUDE                           = 11;
  RT_VKEYTBL                              = 12;
  RT_KEYTBL                               = 13;
  RT_CHARTBL                              = 14;
  RT_DISPLAYINFO                          = 15;
  RT_FKASHORT                             = 16;
  RT_FKALONG                              = 17;
  RT_HELPTABLE                            = 18;
  RT_HELPSUBTABLE                         = 19;
  RT_FDDIR                                = 20;
  RT_FD                                   = 21;
  RT_MAX                                  = 22;

  RF_ORDINALID                            = $80000000;


(* -------------------------------- TASKS --------------------------------- *)

const
  DCWA_PROCESS                            = 0;
  DCWA_PROCESSTREE                        = 1;

  DCWW_WAIT                               = 0;
  DCWW_NOWAIT                             = 1;

  DKP_PROCESSTREE                         = 0;
  DKP_PROCESS                             = 1;

  EXEC_SYNC                               = 0;
  EXEC_ASYNC                              = 1;
  EXEC_ASYNCRESULT                        = 2;
  EXEC_TRACE                              = 3;
  EXEC_BACKGROUND                         = 4;
  EXEC_LOAD                               = 5;
  EXEC_ASYNCRESULTDB                      = 6;

  EXIT_THREAD                             = 0;
  EXIT_PROCESS                            = 1;

  EXLST_ADD                               = 1;
  EXLST_REMOVE                            = 2;
  EXLST_EXIT                              = 3;

  PRTYC_NOCHANGE                          = 0;
  PRTYC_IDLETIME                          = 1;
  PRTYC_REGULAR                           = 2;
  PRTYC_TIMECRITICAL                      = 3;
  PRTYC_FOREGROUNDSERVER                  = 4;

  PRTYD_MINIMUM                           = (-31);
  PRTYD_MAXIMUM                           = 31;

  PRTYS_PROCESS                           = 0;
  PRTYS_PROCESSTREE                       = 1;
  PRTYS_THREAD                            = 2;

  TC_EXIT                                 = 0;
  TC_HARDERROR                            = 1;
  TC_TRAP                                 = 2;
  TC_KILLPROCESS                          = 3;
  TC_EXCEPTION                            = 4;

type
  TRESULTCODES = record
    codeTerminate : Longint;
    codeResult : Longint;
  end;
  PRESULTCODES = ^TRESULTCODES;

  TTIB2 = record
    tib2_ultid : Longint;
    tib2_ulpri : Longint;
    tib2_version : Longint;
    tib2_usMCCount : Word;
    tib2_fMCForceFlag : Word;
  end;
  PTIB2 = ^TTIB2;

  TTIB = record
    tib_pexchain : Pointer;
    tib_pstack : Pointer;
    tib_pstacklimit : Pointer;
    tib_ptib2 : PTIB2;
    tib_version : Longint;
    tib_ordinal : Longint;
  end;
  PTIB = ^TTIB;
  PPTIB = ^PTIB;

  TPIB = record
    pib_ulpid : Longint;
    pib_ulppid : Longint;
    pib_hmte : Longint;
    pib_pchcmd : PChar;
    pib_pchenv : PChar;
    pib_flstatus : Longint;
    pib_ultype : Longint;
  end;
  PPIB = ^TPIB;
  PPPIB = ^PPIB;

  TFNTHREAD = procedure;
  PFNTHREAD = ^TFNTHREAD;
  TFNEXITLIST = procedure;
  PFNEXITLIST = ^PFNEXITLIST;

  TPIDINFO = record
    pid : PID;
    tid : TID;
    pidParent : PID;
  end;
  PPIDINFO = ^TPIDINFO;


(* ------------------------------ SESSIONS -------------------------------- *)

const
  SSF_RELATED_INDEPENDENT                 = 0;
  SSF_RELATED_CHILD                       = 1;

  SSF_FGBG_FORE                           = 0;
  SSF_FGBG_BACK                           = 1;

  SSF_TRACEOPT_NONE                       = 0;
  SSF_TRACEOPT_TRACE                      = 1;
  SSF_TRACEOPT_TRACEALL                   = 2;

  SSF_INHERTOPT_SHELL                     = 0;
  SSF_INHERTOPT_PARENT                    = 1;

  SSF_TYPE_DEFAULT                        = 0;
  SSF_TYPE_FULLSCREEN                     = 1;
  SSF_TYPE_WINDOWABLEVIO                  = 2;
  SSF_TYPE_PM                             = 3;
  SSF_TYPE_VDM                            = 4;
  SSF_TYPE_GROUP                          = 5;
  SSF_TYPE_DLL                            = 6;
  SSF_TYPE_WINDOWEDVDM                    = 7;
  SSF_TYPE_PDD                            = 8;
  SSF_TYPE_VDD                            = 9;

  SSF_CONTROL_VISIBLE                     = $0000;
  SSF_CONTROL_INVISIBLE                   = $0001;
  SSF_CONTROL_MAXIMIZE                    = $0002;
  SSF_CONTROL_MINIMIZE                    = $0004;
  SSF_CONTROL_NOAUTOCLOSE                 = $0008;
  SSF_CONTROL_SETPOS                      = $8000;

  SET_SESSION_UNCHANGED                   = 0;
  SET_SESSION_SELECTABLE                  = 1;
  SET_SESSION_NON_SELECTABLE              = 2;
  SET_SESSION_BOND                        = 1;
  SET_SESSION_NO_BOND                     = 2;

  STOP_SESSION_SPECIFIED                  = 0;
  STOP_SESSION_ALL                        = 1;

  FAPPTYP_NOTSPEC                         = $0000;
  FAPPTYP_NOTWINDOWCOMPAT                 = $0001;
  FAPPTYP_WINDOWCOMPAT                    = $0002;
  FAPPTYP_WINDOWAPI                       = $0003;
  FAPPTYP_BOUND                           = $0008;
  FAPPTYP_DLL                             = $0010;
  FAPPTYP_DOS                             = $0020;
  FAPPTYP_PHYSDRV                         = $0040;
  FAPPTYP_VIRTDRV                         = $0080;
  FAPPTYP_PROTDLL                         = $0100;
  FAPPTYP_WINDOWSREAL                     = $0200;
  FAPPTYP_WINDOWSPROT                     = $0400;
  FAPPTYP_32BIT                           = $4000;
  FAPPTYP_EXETYPE                         = $0003;
  FAPPTYP_RESERVED                        = ( not (FAPPTYP_WINDOWAPI  or  FAPPTYP_BOUND  or  
	FAPPTYP_DLL  or  FAPPTYP_DOS  or  
	FAPPTYP_PHYSDRV  or  FAPPTYP_VIRTDRV  or
	FAPPTYP_PROTDLL  or  FAPPTYP_32BIT));

type
  TSTARTDATA = record
    Length : Word;
    Related : Word;
    FgBg : Word;
    TraceOpt : Word;
    PgmTitle : PChar;
    PgmName : PChar;
    PgmInputs : PBYTE;
    TermQ : PBYTE;
    Environment : PBYTE;
    InheritOpt : Word;
    SessionType : Word;
    IconFile : PChar;
    PgmHandle : Longint;
    PgmControl : Word;
    InitXPos : Word;
    InitYPos : Word;
    InitXSize : Word;
    InitYSize : Word;
    Reserved : Word;
    ObjectBuffer : PChar;
    ObjectBuffLen : Longint;
  end;
  PSTARTDATA = ^TSTARTDATA;

  TSTATUSDATA = record
    Length : Word;
    SelectInd : Word;
    BondInd : Word;
  end;
  PSTATUSDATA = ^TSTATUSDATA;


(* ----------------------------- SEMAPHORES ------------------------------- *)

const
  SEM_INDEFINITE_WAIT                     = (-1);
  SEM_IMMEDIATE_RETURN                    = 0;

  DC_SEM_SHARED                           = $01;
  DCMW_WAIT_ANY                           = $02;
  DCMW_WAIT_ALL                           = $04;

type
  HEV = Longint;
  PHEV = ^HEV;


type
  HMTX = Longint;
  PHMTX = ^HMTX;


type
  HMUX = Longint;
  PHMUX = ^HMUX;

  HSEM = Pointer;
  PHSEM = ^HSEM;

  HSYSSEM = Pointer;
  PHSYSSEM = ^HSYSSEM; { 1.x }

  TSEMRECORD = record
    hsemCur : HSEM;
    ulUser : Longint;
  end;
  PSEMRECORD = ^TSEMRECORD;

  TDOSFSRSEM = record
    fs_Length : word;
    fs_ProcID : PID;
    fs_ThrdID : TID;
    fs_UseCount : word;
    fs_Client : word;
    fs_RAMSem : longint;
  end;


(* ---------------------------- NAMED PIPES ------------------------------- *)

const
  NP_INDEFINITE_WAIT                      = (-1);
  NP_DEFAULT_WAIT                         = 0;

  NP_STATE_DISCONNECTED                   = 1;
  NP_STATE_LISTENING                      = 2;
  NP_STATE_CONNECTED                      = 3;
  NP_STATE_CLOSING                        = 4;

  NP_ACCESS_INBOUND                       = $0000;
  NP_ACCESS_OUTBOUND                      = $0001;
  NP_ACCESS_DUPLEX                        = $0002;
  NP_INHERIT                              = $0000;
  NP_NOINHERIT                            = $0080;
  NP_WRITEBEHIND                          = $0000;
  NP_NOWRITEBEHIND                        = $4000;

  NP_READMODE_BYTE                        = $0000;
  NP_READMODE_MESSAGE                     = $0100;
  NP_TYPE_BYTE                            = $0000;
  NP_TYPE_MESSAGE                         = $0400;
  NP_END_CLIENT                           = $0000;
  NP_END_SERVER                           = $4000;
  NP_WAIT                                 = $0000;
  NP_NOWAIT                               = $8000;
  NP_UNLIMITED_INSTANCES                  = $00ff;

  NPSS_EOI                                = 0;
  NPSS_RDATA                              = 1;
  NPSS_WSPACE                             = 2;
  NPSS_CLOSE                              = 3;

  NPSS_WAIT                               = $0001;

type
  TAVAILDATA = record
    cbpipe : Word;
    cbmessage : Word;
  end;
  PAVAILDATA = ^TAVAILDATA;

  TPIPEINFO = record
    cbOut : Word;
    cbIn : Word;
    cbMaxInst : Byte;
    cbCurInst : Byte;
    cbName : Byte;
    szName : array[0..1-1] of Char;
  end;
  PPIPEINFO = ^TPIPEINFO;

  TPIPESEMSTATE = record
    fStatus : Byte;
    fFlag : Byte;
    usKey : Word;
    usAvail : Word;
  end;
  PPIPESEMSTATE = ^TPIPESEMSTATE;


(* ------------------------------- QUEUES --------------------------------- *)

const
  QUE_FIFO                                = $0000;
  QUE_LIFO                                = $0001;
  QUE_PRIORITY                            = $0002;
  QUE_NOCONVERT_ADDRESS                   = $0000;
  QUE_CONVERT_ADDRESS                     = $0004;

type
  TREQUESTDATA = record
    pid : PID;
    ulData : Longint;
  end;
  PREQUESTDATA = ^TREQUESTDATA;


(* --------------------------- EXCEPTIONS --------------------------------- *)

const
  CONTEXT_CONTROL                         = $0001;
  CONTEXT_INTEGER                         = $0002;
  CONTEXT_SEGMENTS                        = $0004;
  CONTEXT_FLOATING_POINT                  = $0008;
  CONTEXT_FULL                            = (CONTEXT_CONTROL  or  CONTEXT_INTEGER  or
	CONTEXT_SEGMENTS  or  CONTEXT_FLOATING_POINT);

  EH_NONCONTINUABLE                       = $0001;
  EH_UNWINDING                            = $0002;
  EH_EXIT_UNWIND                          = $0004;
  EH_STACK_INVALID                        = $0008;
  EH_NESTED_CALL                          = $0010;

  SIG_UNSETFOCUS                          = 0;
  SIG_SETFOCUS                            = 1;

  UNWIND_ALL                              = 0;

  XCPT_CONTINUE_SEARCH                    = $00000000;
  XCPT_CONTINUE_EXECUTION                 = $ffffffff;
  XCPT_CONTINUE_STOP                      = $00716668;

  XCPT_SIGNAL_INTR                        = 1;
  XCPT_SIGNAL_KILLPROC                    = 3;
  XCPT_SIGNAL_BREAK                       = 4;

  XCPT_FATAL_EXCEPTION                    = $c0000000;
  XCPT_SEVERITY_CODE                      = $c0000000;
  XCPT_CUSTOMER_CODE                      = $20000000;
  XCPT_FACILITY_CODE                      = $1fff0000;
  XCPT_EXCEPTION_CODE                     = $0000ffff;

  XCPT_UNKNOWN_ACCESS                     = $00000000;
  XCPT_READ_ACCESS                        = $00000001;
  XCPT_WRITE_ACCESS                       = $00000002;
  XCPT_EXECUTE_ACCESS                     = $00000004;
  XCPT_SPACE_ACCESS                       = $00000008;
  XCPT_LIMIT_ACCESS                       = $00000010;
  XCPT_DATA_UNKNOWN                       = $ffffffff;

  XCPT_GUARD_PAGE_VIOLATION               = $80000001;
  XCPT_UNABLE_TO_GROW_STACK               = $80010001;
  XCPT_ACCESS_VIOLATION                   = $c0000005;
  XCPT_IN_PAGE_ERROR                      = $c0000006;
  XCPT_ILLEGAL_INSTRUCTION                = $c000001c;
  XCPT_INVALID_LOCK_SEQUENCE              = $c000001d;
  XCPT_NONCONTINUABLE_EXCEPTION           = $c0000024;
  XCPT_INVALID_DISPOSITION                = $c0000025;
  XCPT_UNWIND                             = $c0000026;
  XCPT_BAD_STACK                          = $c0000027;
  XCPT_INVALID_UNWIND_TARGET              = $c0000028;
  XCPT_ARRAY_BOUNDS_EXCEEDED              = $c0000093;
  XCPT_FLOAT_DENORMAL_OPERAND             = $c0000094;
  XCPT_FLOAT_DIVIDE_BY_ZERO               = $c0000095;
  XCPT_FLOAT_INEXACT_RESULT               = $c0000096;
  XCPT_FLOAT_INVALID_OPERATION            = $c0000097;
  XCPT_FLOAT_OVERFLOW                     = $c0000098;
  XCPT_FLOAT_STACK_CHECK                  = $c0000099;
  XCPT_FLOAT_UNDERFLOW                    = $c000009a;
  XCPT_INTEGER_DIVIDE_BY_ZERO             = $c000009b;
  XCPT_INTEGER_OVERFLOW                   = $c000009c;
  XCPT_PRIVILEGED_INSTRUCTION             = $c000009d;
  XCPT_DATATYPE_MISALIGNMENT              = $c000009e;
  XCPT_BREAKPOINT                         = $c000009f;
  XCPT_SINGLE_STEP                        = $c00000a0;
  XCPT_PROCESS_TERMINATE                  = $c0010001;
  XCPT_ASYNC_PROCESS_TERMINATE            = $c0010002;
  XCPT_SIGNAL                             = $c0010003;

type
  TFPREG = record
    losig : Longint;
    hisig : Longint;
    signexp : Word;
  end;
  PFPREG = ^TFPREG;

  TCONTEXTRECORD = record
    ContextFlags : Longint;
    ctx_env : array[0..7-1] of Longint;
    ctx_stack : array[0..8-1] of TFPREG;
    ctx_SegGs : Longint;
    ctx_SegFs : Longint;
    ctx_SegEs : Longint;
    ctx_SegDs : Longint;
    ctx_RegEdi : Longint;
    ctx_RegEsi : Longint;
    ctx_RegEax : Longint;
    ctx_RegEbx : Longint;
    ctx_RegEcx : Longint;
    ctx_RegEdx : Longint;
    ctx_RegEbp : Longint;
    ctx_RegEip : Longint;
    ctx_SegCs : Longint;
    ctx_EFlags : Longint;
    ctx_RegEsp : Longint;
    ctx_SegSs : Longint;
  end;
  PCONTEXTRECORD = ^TCONTEXTRECORD;

const
  EXCEPTION_MAXIMUM_PARAMETERS            = 4;
(*
type
  ;
function (
    ExceptionNum : Longint
    fHandlerFlags : Longint
    _EXCEPTIONREPORTRECORD : structNestedExceptionReportRecord : *
    ExceptionAddress : Pointer
    cParameters : Longint
    ExceptionInfo : array[0..EXCEPTION_MAXIMUM_PARAMETERS-1] of Longint
    EXCEPTIONREPORTRECORD : }
    EXCEPTIONREPORTRECORD : typedef*PEXCEPTIONREPORTRECORD
    
    _EXCEPTIONREGISTRATIONRECORD : struct

    Longint : typedef(*ERR) : {;
function _EXCEPTIONREGISTRATIONRECORD *pRegistration,(
    pContext : PCONTEXTRECORD; pWhatever : Pointer) : struct;

type
  ;
function (
    _EXCEPTIONREGISTRATIONRECORD : struct__volatile__ : *prev_structure
    __volatile__ : ERRExceptionHandler
    EXCEPTIONREGISTRATIONRECORD : }
    EXCEPTIONREGISTRATIONRECORD : typedef*PEXCEPTIONREGISTRATIONRECORD

    END_OF_CHAIN : #define((PEXCEPTIONREGISTRATIONRECORD) : {;
*)

(* --------------------------- INFORMATION -------------------------------- *)

const
  QSV_MAX_PATH_LENGTH                     = 1;
  QSV_MAX_TEXT_SESSIONS                   = 2;
  QSV_MAX_PM_SESSIONS                     = 3;
  QSV_MAX_VDM_SESSIONS                    = 4;
  QSV_BOOT_DRIVE                          = 5;
  QSV_DYN_PRI_VARIATION                   = 6;
  QSV_MAX_WAIT                            = 7;
  QSV_MIN_SLICE                           = 8;
  QSV_MAX_SLICE                           = 9;
  QSV_PAGE_SIZE                           = 10;
  QSV_VERSION_MAJOR                       = 11;
  QSV_VERSION_MINOR                       = 12;
  QSV_VERSION_REVISION                    = 13;
  QSV_MS_COUNT                            = 14;
  QSV_TIME_LOW                            = 15;
  QSV_TIME_HIGH                           = 16;
  QSV_TOTPHYSMEM                          = 17;
  QSV_TOTRESMEM                           = 18;
  QSV_TOTAVAILMEM                         = 19;
  QSV_MAXPRMEM                            = 20;
  QSV_MAXSHMEM                            = 21;
  QSV_TIMER_INTERVAL                      = 22;
  QSV_MAX_COMP_LENGTH                     = 23;
  QSV_MAX                                 = QSV_MAX_COMP_LENGTH;

(* ---------------------------- TIMERS ------------------------------------ *)

type
  HTIMER = LHANDLE;
  PHTIMER = ^HTIMER;

  TDATETIME = record
    hours : Byte;
    minutes : Byte;
    seconds : Byte;
    hundredths : Byte;
    day : Byte;
    month : Byte;
    year : Word;
    timezone : Shortint;
    weekday : Byte;
  end;
  PDATETIME = ^TDATETIME;

  TQWORD = record
    ulLo : Longint;
    ulHi : Longint;
  end;
  PQWORD = ^TQWORD;

(* ---------------------- VIRTUAL DOS MACHINES----------------------------- *)

type
  HVDD = LHANDLE;
  PHVDD = ^HVDD;

  SGID = Word;

(* --------------------------- DEBUGGING ---------------------------------- *)

const
  DBG_C_Null                              = 0;
  DBG_C_ReadMem                           = 1;
  DBG_C_ReadMem_I                         = 1;
  DBG_C_ReadMem_D                         = 2;
  DBG_C_ReadReg                           = 3;
  DBG_C_WriteMem                          = 4;
  DBG_C_WriteMem_I                        = 4;
  DBG_C_WriteMem_D                        = 5;
  DBG_C_WriteReg                          = 6;
  DBG_C_Go                                = 7;
  DBG_C_Term                              = 8;
  DBG_C_SStep                             = 9;
  DBG_C_Stop                              = 10;
  DBG_C_Freeze                            = 11;
  DBG_C_Resume                            = 12;
  DBG_C_NumToAddr                         = 13;
  DBG_C_ReadCoRegs                        = 14;
  DBG_C_WriteCoRegs                       = 15;
  DBG_C_ThrdStat                          = 17;
  DBG_C_MapROAlias                        = 18;
  DBG_C_MapRWAlias                        = 19;
  DBG_C_UnMapAlias                        = 20;
  DBG_C_Connect                           = 21;
  DBG_C_ReadMemBuf                        = 22;
  DBG_C_WriteMemBuf                       = 23;
  DBG_C_SetWatch                          = 24;
  DBG_C_ClearWatch                        = 25;
  DBG_C_RangeStep                         = 26;
  DBG_C_Continue                          = 27;
  DBG_C_AddrToObject                      = 28;
  DBG_C_XchngOpcode                       = 29;
  DBG_C_LinToSel                          = 30;
  DBG_C_SelToLin                          = 31;

  DBG_N_SUCCESS                           = 0;
  DBG_N_ERROR                             = (-1);
  DBG_N_ProcTerm                          = (-6);
  DBG_N_Exception                         = (-7);
  DBG_N_ModuleLoad                        = (-8);
  DBG_N_CoError                           = (-9);
  DBG_N_ThreadTerm                        = (-10);
  DBG_N_AsyncStop                         = (-11);
  DBG_N_NewProc                           = (-12);
  DBG_N_AliasFree                         = (-13);
  DBG_N_Watchpoint                        = (-14);
  DBG_N_ThreadCreate                      = (-15);
  DBG_N_ModuleFree                        = (-16);
  DBG_N_RangeStep                         = (-17);

  DBG_D_Thawed                            = 0;
  DBG_D_Frozen                            = 1;

  DBG_T_Runnable                          = 0;
  DBG_T_Suspended                         = 1;
  DBG_T_Blocked                           = 2;
  DBG_T_CritSec                           = 3;

  DBG_L_386                               = 1;

  DBG_CO_387                              = 1;

  DBG_O_OBJMTE                            = $10000000;

  DBG_W_Global                            = $00000001;
  DBG_W_Local                             = $00000002;
  DBG_W_Execute                           = $00010000;
  DBG_W_Write                             = $00020000;
  DBG_W_ReadWrite                         = $00040000;

type
  TDEBUGBUFFER = record
    ulPid : Longint;
    ulTid : Longint;
    lCmd : Longint;
    lValue : Longint;
    ulAddr : Longint;
    ulBuffer : Longint;
    ulLen : Longint;
    ulIndex : Longint;
    ulMTE : Longint;
    ulEAX : Longint;
    ulECX : Longint;
    ulEDX : Longint;
    ulEBX : Longint;
    ulESP : Longint;
    ulEBP : Longint;
    ulESI : Longint;
    ulEDI : Longint;
    ulEFlags : Longint;
    ulEIP : Longint;
    ulCSLim : Longint;
    ulCSBase : Longint;
    ucCSAcc : Char;
    ucCSAtr : Char;
    usCS : Word;
    ulDSLim : Longint;
    ulDSBase : Longint;
    ucDSAcc : Char;
    ucDSAtr : Char;
    usDS : Word;
    ulESLim : Longint;
    ulESBase : Longint;
    ucESAcc : Char;
    ucESAtr : Char;
    _usES : Word;
    ulFSLim : Longint;
    ulFSBase : Longint;
    ucFSAcc : Char;
    ucFSAtr : Char;
    usFS : Word;
    ulGSLim : Longint;
    ulGSBase : Longint;
    ucGSAcc : Char;
    ucGSAtr : Char;
    usGS : Word;
    ulSSLim : Longint;
    ulSSBase : Longint;
    ucSSAcc : Char;
    ucSSAtr : Char;
    usSS : Word;
  end;
  PDEBUGBUFFER = ^TDEBUGBUFFER;


(* ---------------------------- REXX -------------------------------------- *)

const
  RXAUTOBUFLEN                            = 256;

type
  TRXSTRING = record
    strlength : Longint;
    strptr : PCH;
  end;
  PRXSTRING = ^TRXSTRING;

  TRXSYSEXIT = record
    sysexit_name : PChar;
    sysexit_code : Longint;
  end;
  PRXSYSEXIT = ^TRXSYSEXIT;
{
const
  RXNULLSTRING                            = (r)         ((r).strptr == (PCH)0);
  RXZEROLENSTRING                         = (r)      ((r).strptr  not = (PCH)0  and  (r).strlength == 0);
  RXVALIDSTRING                           = (r)        ((r).strptr  not = (PCH)0  and  (r).strlength  not = 0);
  RXSTRLEN                                = (r)             (RXNULLSTRING(r) ? 0 : (r).strlength);
  RXSTRPTR                                = (r)             (r).strptr;
  MAKERXSTRING                            = (r,p,l) 
	((r).strptr = (PCH)p, (r).strlength = (Longint)l);

}

implementation

end.