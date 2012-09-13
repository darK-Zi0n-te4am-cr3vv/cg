include model.inc

KB_READ_KEY		equ		00h

INT16 macro
	int 16h
endm

.code

KB_Readkey proc
	mov ax, KB_READ_KEY
	INT16
KB_Readkey endp

end