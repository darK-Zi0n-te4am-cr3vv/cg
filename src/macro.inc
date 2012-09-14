
include lib\status.inc

RETURNW macro val
	mov ax, val
	ret
endm

RETURNB macro val
	mov al, val
	ret
endm

CHECK_STATUS macro ft
	cmp ax, STATUS_SUCCESS
	jnz ft
endm

LDSEG macro segr, val
	push ax
	mov ax, val
	mov es, ax
	pop ax
endm
