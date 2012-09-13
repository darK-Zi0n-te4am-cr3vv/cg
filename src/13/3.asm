include 'model.inc'
include 'macro.inc'

include 'lib\cga.inc'
include 'lib\sys.inc'
include 'lib\kb.inc'

; Разработать программу для этого же видеоадаптера для вывода на экран
; точки с координатами x = 113, y = 98, синего цвета. Значения
; координат можно задавать непосредственно в тексте программы.

PX_X		equ		113
PX_Y		equ		98

PX_COLOR	equ		CGA_CM_CYAN

.data
FatalMessage: db 'Fatal error, exiting$'

.code

main:
	invoke CGA_InitVideo, CGA_SUBMODE_CM
	CHECK_STATUS fatal
	
	invoke CGA_ClearScreen
	
	invoke CGA_PutPixel, PX_X, PX_Y, PX_COLOR
	
	invoke KB_ReadKey
	invoke DOS_Exit
	
fatal:
	invoke DOS_Print, offset FatalMessage
	invoke DOS_Exit
	
end main