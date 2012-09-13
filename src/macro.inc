
RETURN_STATUS macro status
	mov ax, status
	ret
endm

CHECK_STATUS macro ft
	test ax, ax
	jnz ft
endm