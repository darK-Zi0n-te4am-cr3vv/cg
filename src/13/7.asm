; lab 1.7
; (c) C.c 2012

;  Draw a complex object

include model.inc
include macro.inc

include lib\cga.inc
include lib\sys.inc
include lib\kb.inc
include lib\int10.inc

LINE_COLOR			equ		CGA_CM_MAGENTA

.data
FatalMessage db 'Fatal error, exiting$'

.stack 40960

.code

Entry proc
	local bOldMode :  byte

	invoke Int10_GetCurrentVideoMode
	mov bOldMode, al
	
	invoke CGA_InitVideo, CGA_SUBMODE_CM
	CHECK_STATUS fatal
	
	invoke CGA_ClearScreen

	invoke CGA_DrawCircle, 160, 100, 80, LINE_COLOR
	invoke CGA_DrawCircle, 125, 60, 10, LINE_COLOR
	invoke CGA_DrawCircle, 195, 60, 10, LINE_COLOR
	invoke CGA_DrawCircle, 160, 120, 35, LINE_COLOR
	invoke CGA_DrawCircle, 145, 120, 10, LINE_COLOR
	invoke CGA_DrawCircle, 175, 120, 10, LINE_COLOR
	
xfill:
	
	invoke CGA_FloodFill, 175, 120, CGA_CM_CYAN
	
	invoke KB_ReadKey
	
	; restore vmode
	invoke Int10_SetVideoMode, bOldMode
	
	RETURNB EXIT_SUCCESS
	
fatal:
	; restore vmode
	invoke Int10_SetVideoMode, bOldMode

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

