include 'lib\int10.inc'

INT10 macro 
	int 10h
endm

; INT 10 services

INT10_SET_VMODE				equ 00h
INT10_SET_CURSOR_PARAMS		equ 01h
INT10_SET_CURSOR_POSITION	equ 02h

INT10_SET_ACTIVE_PAGE		equ 05h

INT10_GET_CURRENT_VMODE		equ 0fh


Int10_SetVideoMode proc 
	bVMode : byte 
	uses ax
	
	mov ah, INT10_SET_VMODE
	mov al, bVMode
	
	INT10
	
Int10_SetVideoMode endp


