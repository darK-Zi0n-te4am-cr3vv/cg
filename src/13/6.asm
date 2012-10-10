; lab 1.6
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

.stack 256

.code

Entry proc
	local bOldMode :  byte

	invoke Int10_GetCurrentVideoMode
	mov bOldMode, al
	
	invoke CGA_InitVideo, CGA_SUBMODE_CM
	CHECK_STATUS fatal
	
	invoke CGA_ClearScreen
	
	; generated code
	invoke CGA_DrawLine, 196, 171, 172, 183, LINE_COLOR
	invoke CGA_DrawLine, 172, 183, 145, 187, LINE_COLOR
	invoke CGA_DrawLine, 145, 187, 110, 184, LINE_COLOR
	invoke CGA_DrawLine, 110, 184, 78, 169, LINE_COLOR
	invoke CGA_DrawLine, 78, 169, 57, 139, LINE_COLOR
	invoke CGA_DrawLine, 57, 139, 56, 101, LINE_COLOR
	invoke CGA_DrawLine, 56, 101, 71, 64, LINE_COLOR
	invoke CGA_DrawLine, 71, 64, 94, 39, LINE_COLOR
	invoke CGA_DrawLine, 94, 39, 124, 19, LINE_COLOR
	invoke CGA_DrawLine, 124, 19, 157, 11, LINE_COLOR
	invoke CGA_DrawLine, 157, 11, 186, 8, LINE_COLOR
	invoke CGA_DrawLine, 186, 8, 213, 17, LINE_COLOR
	invoke CGA_DrawLine, 213, 17, 236, 32, LINE_COLOR
	invoke CGA_DrawLine, 236, 32, 251, 54, LINE_COLOR
	invoke CGA_DrawLine, 251, 54, 254, 80, LINE_COLOR
	invoke CGA_DrawLine, 254, 80, 245, 106, LINE_COLOR
	invoke CGA_DrawLine, 245, 106, 229, 119, LINE_COLOR
	invoke CGA_DrawLine, 229, 119, 205, 125, LINE_COLOR
	invoke CGA_DrawLine, 205, 125, 195, 122, LINE_COLOR
	invoke CGA_DrawLine, 195, 122, 191, 112, LINE_COLOR
	invoke CGA_DrawLine, 191, 112, 190, 91, LINE_COLOR
	invoke CGA_DrawLine, 190, 80, 189, 91, LINE_COLOR
	invoke CGA_DrawLine, 190, 80, 195, 66, LINE_COLOR
	invoke CGA_DrawLine, 195, 66, 183, 59, LINE_COLOR
	invoke CGA_DrawLine, 183, 59, 161, 52, LINE_COLOR
	invoke CGA_DrawLine, 161, 52, 141, 54, LINE_COLOR
	invoke CGA_DrawLine, 141, 54, 125, 64, LINE_COLOR
	invoke CGA_DrawLine, 125, 64, 113, 84, LINE_COLOR
	invoke CGA_DrawLine, 113, 84, 109, 103, LINE_COLOR
	invoke CGA_DrawLine, 109, 103, 112, 122, LINE_COLOR
	invoke CGA_DrawLine, 112, 122, 114, 127, LINE_COLOR
	invoke CGA_DrawLine, 114, 127, 123, 131, LINE_COLOR
	invoke CGA_DrawLine, 123, 131, 137, 126, LINE_COLOR
	invoke CGA_DrawLine, 137, 126, 153, 115, LINE_COLOR
	invoke CGA_DrawLine, 153, 115, 171, 94, LINE_COLOR
	invoke CGA_DrawLine, 171, 94, 185, 81, LINE_COLOR
	invoke CGA_DrawLine, 185, 81, 191, 67, LINE_COLOR
	
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

