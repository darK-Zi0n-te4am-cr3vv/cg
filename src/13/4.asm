; lab 1.3
; (c) C.c 2012

; На базе разработанной программы вывода точки разработать программу
; построения горизонтальной линии произвольного размера от минимального (в
; один пиксель) до максимального (320 пикселей). Стремиться к максимальной
; скорости построения линии.


include model.inc
include macro.inc

include lib\cga.inc
include lib\sys.inc
include lib\kb.inc
include lib\int10.inc

LINE_COLOR			equ		CGA_CM_CYAN

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
	
	invoke CGA_DrawLine, 0, 10, 123, 10, LINE_COLOR
	invoke CGA_DrawLine, 84, 20, 240, 20, LINE_COLOR
	invoke CGA_DrawLine, 3, 30, 319, 30, LINE_COLOR
	invoke CGA_DrawLine, 317, 40, 319, 40, LINE_COLOR
	
	
	
	
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

