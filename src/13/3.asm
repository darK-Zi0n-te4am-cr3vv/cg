; lab 1.3
; (c) C.c 2012

; Разработать программу для этого же видеоадаптера для вывода на экран
; точки с координатами x = 113, y = 98, синего цвета. Значения
; координат можно задавать непосредственно в тексте программы.

include model.inc
include macro.inc

include lib\cga.inc
include lib\sys.inc
include lib\kb.inc
include lib\int10.inc

PX_X		equ		113
PX_Y		equ		98

PX_COLOR	equ		CGA_CM_CYAN

.data
FatalMessage db 'Fatal error, exiting$'

.stack 256

.code

Entry proc
	local bOldMode :  byte

	invoke Int10_GetCurrentVideoMode
	mov bOldMode, al
	
	invoke CGA_InitVideo, CGA_SUBMODE_CM
	CHECK_STATUS fatal
	
	invoke CGA_ClearScreen
	
	invoke CGA_PutPixel, PX_X, PX_Y, PX_COLOR
	
	
	invoke KB_ReadKey
	
	; restore vmode
	invoke Int10_SetVideoMode, bOldMode
	
	RETURNB EXIT_SUCCESS
	
fatal:
	invoke DOS_Print, offset FatalMessage
	RETURNB EXIT_FAILURE
	
Entry endp

main:
	; setup ds
	mov ax, @data
	mov ds, ax
	
	call Entry
	invoke DOS_Exit, al
	
end main
