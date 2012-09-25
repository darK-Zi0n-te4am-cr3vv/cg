include model.inc

include lib\cga.inc
include lib\int10.inc
include lib\status.inc
include macro.inc


.data

CGA_PIX_MASK db 03fh, 0dfh, 0fdh, 0f3h
CGA_HOR_LINE_MASKS db 0ffh, 0c0h, 0f0h, 0fch
CGA_HOR_LINE_PIX db 00h, 3fh, 0fh, 03h

CGA_HOR_LINE_EMASKS db 0ffh, 03fh, 00fh, 03h
CGA_HOR_LINE_EPIX db 00h, 0c0h, 0f0h, 0fch


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

CGA_PutPixel proc uses ax bx cx dx di si es wX : word, wY : word, bColor : byte
	
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
	shl ah, 2
	inc bx
	cmp bx, 3
	jl shift
	
	or al, ah
	
	mov es:[di], al
	
	ret
	
CGA_PutPixel endp

 
CGA_DrawLineHorizontal proc uses bx cx di si sX : word, eX : word, Y : word, color : byte
	
	;
	; we drawing line in 3 steps:
	; begining, middle, ending
	;
	
local nOffset : word
local nStartByte : word
local nEndByte : word
	
	; dirty hack
	inc eX
	
	mov ax, sX
	mov bx, eX
	cmp ax, bx
	jle noSwap

	mov sX, bx
	mov eX, ax
	
noSwap:
	
	; calculating color
	
	mov al, color
	shl al, 2
	or al, color
	shl al, 2
	or al, color
	shl al, 2
	or al, color
	
	mov color, al
	
	; calculating line offset
	
	mov ax, Y
	mov bx, ax
	
	shr ax, 1
	mov cx, CGA_LINE_SIZE
	mul cx
	
	and bx, 1
	jz upPage
	add ax, CGA_VMEM_HALF_AREA
	
upPage:
	mov nOffset, ax
	
	mov ax, eX
	shr ax, 2
	add ax, nOffset
	mov nEndByte, ax
	
	mov ax, sX
	mov bx, ax
	
	shr bx, 2
	add bx, nOffset
	mov nStartByte, bx
	
	cmp nEndByte, bx
	jz oneByteLine
	
	and ax, 3h
	jz noStarting
	
	mov si, offset CGA_HOR_LINE_MASKS
	add si, ax
	
	mov bl, [si]
	
	mov di, nStartByte
	
	mov cl, es:[di]
	and cl, bl
	
	mov si, offset CGA_HOR_LINE_PIX
	add si, ax
	
	mov bl, [si]
	and bl, color
	
	or cl, bl
	
	mov es:[di], cl
	
	inc nStartByte
	
noStarting:
	
	mov di, nStartByte
	mov si, nEndByte
	
	mov al, color
	
	
mdLineLoop:
	cmp di, si
	jge mdLineLoopEnd
	
	mov es:[di], al
	inc di
	
	jmp mdLineLoop
	
mdLineLoopEnd:
	
ending:
	mov ax, eX
	and ax, 3h
	jz noEnding
	
	mov si, offset CGA_HOR_LINE_EMASKS
	add si, ax
	
	mov bl, [si]
	
	mov di, nEndByte
	
	mov cl, es:[di]
	and cl, bl
	
	mov si, offset CGA_HOR_LINE_EPIX
	add si, ax
	
	mov bl, [si]
	and bl, color
	
	or cl, bl
	
	mov es:[di], cl
	

noEnding:

	ret

oneByteLine:

	mov si, sX
	mov bx, eX
	mov cl, color
	and cx, 3
	mov dx, Y
	
lineLoop:
	invoke CGA_PutPixel, si, dx, cl
	inc si
	cmp si, bx
	jle lineLoop

	ret
	
CGA_DrawLineHorizontal endp


CGA_DrawLine proc uses es bx cx sX : word, sY : word, eX : word, eY : word, color : byte
	
	LDSEG es, CGA_VMEM_SEG
	
	mov ax, sY
	cmp ax, eY
	jz horizontalLine
	
	mov ax, sX
	cmp ax, eX
	jz verticalLine
	
	jmp genericLine
	
horizontalLine:
	
	invoke CGA_DrawLineHorizontal, sX, eX, sY, color
	RETURNW STATUS_SUCCESS
	
verticalLine:
	
	;RETURNW STATUS_SUCCESS

genericLine: 
	RETURNW STATUS_NOT_IMPLEMENTED

CGA_DrawLine endp

end
