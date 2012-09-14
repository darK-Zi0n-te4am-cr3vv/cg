include model.inc

; dos services

DOS_PRINT_STRING_BUX	equ 09h

DOS_TERMINATE			equ	04ch


INT21 macro
	int 21h
endm

.code

DOS_Exit proc uses ax bExitCode : byte
	
	mov ah, DOS_TERMINATE
	mov al, bExitCode
	
	INT21
	
DOS_Exit endp

DOS_Print proc uses ax dx wStringPtr : word
	
	mov ah, DOS_PRINT_STRING_BUX
	mov dx, wStringPtr
	
	INT21
	ret
DOS_Print endp

end