include 'model.inc'

include 'lib\cga.inc'
include 'lib\int10.inc'
include 'lib\status.inc'
include 'macro.inc'


.data

CGA_PIX_MASK: db 03fh, 0dfh, 0fdh, 0f3h

.code

CGA_InitVideo proc
	bCGASubMode : byte 
	
	cmp bCGASubMode, CGA_SUBMODE_RG
	jnz checkCm
	
	; FIXME: add pallete changing
	invoke Int10_SetVideoMode, VMODE_CGA_COLOR_320
	jmp ok
	
checkCm:
	
	cmp bCGASubMode, CGA_SUBMODE_RG
	jnz mono
	
	invoke Int10_SetVideoMode, VMODE_CGA_COLOR_320
	jmp ok
	
mono:
	cmp bCGASubMode, CGA_SUBMODE_BW
	jnz noMode
	
	invoke Int10_SetVideoMode, VMODE_CGA_MONO
	jmp ok
	
noMode:
	RETURN_STATUS STATUS_INVALID_ARGUMENT
	
ok:
	RETURN_STATUS STATUS_SUCCESS
	
CGA_InitVideo endp


CGA_ClearScreen proc
	uses ax, es
	
	mov ax, CGA_VMEM_SEG
	mov es, ax
	
	mov di, CGA_VMEM_HALF_SIZE

loop1:
	dec di
	
	mov es:[di], 0

	cmp di, 0
	jnz loop1
	
	mov di, CGA_VMEM_HALF_SIZE
	add di, CGA_VMEM_HALF_AREA
	
loop2:
	dec di
	
	mov es:[di], 0

	cmp di, 0
	jnz loop2
	
	ret
	
CGA_ClearScreen endp

CGA_PutPixel proc 
	wX : word,
	wY : word,
	bColor : byte
	
	uses ax, bx, di, si
	
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
	shr ah, bx
	or al, ah
	
	mov es:[di], al
	
	ret
	
CGA_PutPixel endp
