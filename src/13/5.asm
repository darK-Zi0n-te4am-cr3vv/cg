; lab 1.3
; (c) C.c 2012

; Разработать программу построения вертикальной линии произвольного раз-
; мера.

include model.inc
include macro.inc

include lib\cga.inc
include lib\sys.inc
include lib\kb.inc
include lib\int10.inc

LINE_COLOR			equ		CGA_CM_MAGENTA

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
	
	invoke CGA_DrawLine, 10, 89, 10, 34, LINE_COLOR
	CHECK_STATUS fatal
	
	
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

