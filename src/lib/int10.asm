include model.inc
include macro.inc

include lib\int10.inc

INT10 macro 
	int 10h
endm

; INT 10 services

INT10_SET_VMODE				equ 00h
INT10_SET_CURSOR_PARAMS		equ 01h
INT10_SET_CURSOR_POSITION	equ 02h

INT10_SET_ACTIVE_PAGE		equ 05h

INT10_GET_CURRENT_VMODE		equ 0fh

.code

Int10_SetVideoMode  proc uses ax bVMode : byte 
	
	mov ah, INT10_SET_VMODE
	mov al, bVMode
	
	INT10
	
	ret
	
Int10_SetVideoMode endp

Int10_GetCurrentVideoMode  proc 
	
	mov ah, INT10_GET_CURRENT_VMODE	
	INT10
	RETURNW ax
	
Int10_GetCurrentVideoMode endp

end

