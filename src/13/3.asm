include model.inc
include macro.inc

include lib\cga.inc
include lib\sys.inc
include lib\kb.inc
include lib\int10.inc

; Разработать программу для этого же видеоадаптера для вывода на экран
; точки с координатами x = 113, y = 98, синего цвета. Значения
; координат можно задавать непосредственно в тексте программы.

PX_X		equ		113
PX_Y		equ		98

PX_COLOR	equ		CGA_CM_CYAN

.data
FatalMessage db 'Fatal error, exiting$'

.stack 256

.code

Entry proc
	local bOldMode :  byte

	
	
	;invoke Int10_GetCurrentVideoMode
	;mov bOldMode, al
	
	invoke CGA_InitVideo, CGA_SUBMODE_CM
	CHECK_STATUS fatal
	
	mov ax, CGA_VMEM_SEG
	mov es, ax
	
	;invoke CGA_ClearScreen
	
	;invoke CGA_PutPixel, PX_X, PX_Y, PX_COLOR
	
	invoke KB_ReadKey
	
	;invoke Int10_SetVideoMode, 3
	invoke DOS_Exit, 0
	
fatal:
	invoke DOS_Print, offset FatalMessage
	invoke DOS_Exit, 1
	
Entry endp

main:
	; setup ds
	mov ax, @data
	mov ds, ax
	
	call Entry
end main
