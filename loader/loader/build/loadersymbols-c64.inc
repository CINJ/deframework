; build command:
; make prg INSTALL=8000 RESIDENT=2000 ZP=c0

; configuration
config_DECOMPRESSOR             = $03
config_DIRTRACK                 = $12
config_DISABLE_WATCHDOG         = $01
config_END_ADDRESS_API          = $00
config_FILENAME_MAXLENGTH       = $10
config_IDLE_BUS_LOCK            = $00
config_LC_SPEED                 = $06
config_LOAD_COMPD_API           = $01
config_LOAD_RAW_API             = $01
config_LOAD_TO_API              = $00
config_LOAD_UNDER_D000_DFFF     = $01
config_LOAD_VIA_KERNAL_FALLBACK = $01
config_MEM_DECOMP_API           = $00
config_MEM_DECOMP_TO_API        = $00
config_NTSC_COMPATIBILITY       = $00
config_ONLY_1541_AND_COMPATIBLE = $00
config_UNINSTALL_API            = $00

; zeropage
loadaddrlo                      = $c0
loader_zp_first                 = $c0
loadaddrhi                      = $c1
decdestlo                       = $c2
decdesthi                       = $c3
loader_zp_last                  = $d5

; resident
loadraw                         = $2000
loadcompd                       = $200d
loadcompdexecute                = $2013
loadcompdopen                   = $204f
openfile                        = $204f
pollblock                       = $212f
decrunch                        = $2373

; install
drivecode41                     = $8000
drivecode71                     = $87dd
drivecode81                     = $8f72
install                         = $92e7
