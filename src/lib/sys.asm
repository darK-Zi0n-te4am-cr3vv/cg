include 'model.inc'

; dos services

DOS_PRINT_STRING_BUX	equ 09h

DOS_EXIT				equ	04ch


INT21 macro
	int 21h
endm

DOS_Exit proc
	bExitCode : byte
	uses ax
	
	mov ah, DOS_EXIT
	mov al, bExitCode
	
	INT21
	
DOS_Exit endp

DOS_Print proc
	wStringPtr : word
	uses ax, dx
	
	mov ah, DOS_PRINT_STRING_BUX
	mov dx, wStringPtr
	
	INT21
	
DOS_Print endp