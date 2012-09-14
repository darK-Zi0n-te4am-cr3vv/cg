include model.inc

include lib\cga.inc
include lib\int10.inc
include lib\status.inc
include macro.inc


.data

CGA_PIX_MASK db 03fh, 0dfh, 0fdh, 0f3h

.code

CGA_InitVideo proc bCGASubMode : byte 
	
	cmp bCGASubMode, CGA_SUBMODE_RG
	jnz checkCm
	
	; FIXME: add pallete changing
	invoke Int10_SetVideoMode, VMODE_CGA_COLOR_320
	RETURNW STATUS_SUCCESS
	
checkCm:
	
	cmp bCGASubMode, CGA_SUBMODE_CM
	jnz mono
	
	invoke Int10_SetVideoMode, VMODE_CGA_COLOR_320
	RETURNW STATUS_SUCCESS
	
mono:
	cmp bCGASubMode, CGA_SUBMODE_BW
	jnz noMode
	
	invoke Int10_SetVideoMode, VMODE_CGA_MONO_640
	RETURNW STATUS_SUCCESS
	
noMode:
	RETURNW STATUS_INVALID_ARGUMENT
	
CGA_InitVideo endp


CGA_ClearScreen proc uses ax es
	
	LDSEG es, CGA_VMEM_SEG
	
	mov di, CGA_VMEM_HALF_SIZE

	xor ax, ax
	;mov ax, 5555h
	
loop1:
	dec di
	
	mov es:[di], al

	cmp di, 0
	jnz loop1
	
	
	mov di, CGA_VMEM_HALF_SIZE
	add di, CGA_VMEM_HALF_AREA
	
loop2:
	dec di
	
	mov es:[di], al

	cmp di, 0
	jnz loop2
	
	ret
	
CGA_ClearScreen endp

CGA_PutPixel proc uses ax bx cx di si es wX : word, wY : word, bColor : byte
	
	LDSEG es, CGA_VMEM_SEG
	
	mov ax, wY
	
	mov bx, ax
	and bx, 01h
	jz area2
	
	add di, CGA_VMEM_HALF_AREA
	
area2:
	
	shr ax, 1
	
	mov bx, 320
	mul bx
	
	add ax, wX
	mov bx, ax
	
	shr ax, 2
	and bx, 03h
	
	add di, ax
	mov al, es:[di]
	
	mov si, offset CGA_PIX_MASK
	add si, bx	
	and al, [si]
	
	mov ah, bColor

shift:
	shr ah, 2
	dec bx
	jnz shift
	
	or al, ah
	
	mov es:[di], al
	
	ret
	
CGA_PutPixel endp

end
