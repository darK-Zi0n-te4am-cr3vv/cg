include model.inc

include lib\cga.inc
include lib\int10.inc
include lib\status.inc
include macro.inc


.data

CGA_PIX_MASK db 00111111b, 11001111b, 11110011b, 11111100b
CGA_PIX_CMASK db 11000000b, 00110000b, 00001100b, 00000011b


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
	
	; drawing
	shr ax, 1
	
	mov bx, 320
	mul bx
	
	add ax, wX
	mov bx, ax
	
	shr ax, 2
	and bx, 03h
	
	add di, ax
	mov al, es:[di]
	; al is old vmem byte
	
	mov si, offset CGA_PIX_MASK
	add si, bx	
	and al, [si]
	
	; calculating color
	mov cl, 3
	sub cl, bl
	mov ah, bColor
	shl cl, 1
	shl ah, cl
	
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


CGA_DrawLineVertical proc uses bx cx di si X : word, sY : word, eY : word, color : byte

	
local pmask : byte
local cmask : byte

	mov ax, sY
	mov bx, eY
	cmp ax, bx
	
	jle noSwap

	mov sY, bx
	mov eY, ax
	
noSwap:

	; initializaring color
	
	mov al, color
	shl al, 2
	or al, color
	shl al, 2
	or al, color
	shl al, 2
	or al, color
	mov color, al

	
	; initializaring masks
	
	mov si, X
	and si, 3
	
	add si, offset CGA_PIX_MASK 
	mov al, ds:[si]
	mov pmask, al
	
	mov si, X
	and si, 3
	
	add si, offset CGA_PIX_CMASK 
	mov al, ds:[si]
	mov cmask, al
	
	; calculating offset
	
	mov ax, sY
	mov bx, 050h
	mul bx
	
	mov bx, X
	shr bx, 2
	add ax, bx
	
	mov di, ax
	mov si, ax
	add di, 02000h
	
	mov ax, sY
	
	; now just drawing

	mov cl, pmask
	mov ch, cmask
	
	mov dl, color
	
drawLoop:
	
	test ax, 1
	jnz upPage
	
	mov dh, es:[si]
	and dh, cl
	mov bl, dl
	and bl, ch
	or bl, dh
	mov es:[si], bl
	add si, 050h
	
	jmp loopCond
	
upPage:

	mov dh, es:[di]
	and dh, cl
	mov bl, dl
	and bl, ch
	or bl, dh
	mov es:[di], bl
	add di, 050h

loopCond:
	
	inc ax
	cmp ax, eY
	jg drawLoopEnd
	jmp drawLoop

	
	
drawLoopEnd:
	
	ret
	
CGA_DrawLineVertical endp


; Bresenham's line algorithm implementation
CGA_DrawLineGeneric proc uses bx cx di si x1 : word, y1 : word, x2 : word, y2 : word, color : byte
	
	local deltaX : word
	local deltaY : word
	local signX : word
	local signY : word
	local xerror : word
	local xerror2 : word
	
	; deltaX = abs(x2 - x1);
	; signX = x1 < x2 ? 1 : -1;
	
    mov ax, x2
	xor bx, bx
	sub ax, x1
	adc bx, 00h
	shl bx, 1
	mov cx, 01h
	sub cx, bx
	
	mov signX, cx
	
	; abs
	mov bx, ax
	sar bx, 15
	add ax, bx
	xor ax, bx
	
	mov deltaX, ax
	
	; deltaY = abs(y2 - y1);
	; signY = y1 < y2 ? 1 : -1;
    
	mov ax, y2
	xor bx, bx
	sub ax, y1
	adc bx, 00h
	shl bx, 1
	mov cx, 01h
	sub cx, bx
	
	mov signY, cx
	
	; abs
	mov bx, ax
	sar bx, 15
	add ax, bx
	xor ax, bx
	
	mov deltaY, ax
	
	; xerror = deltaX - deltaY;
	mov ax, deltaX
	sub ax, deltaY
	mov xerror, ax
	
	; setPixel(x2, y2);
	invoke CGA_PutPixel, x2, y2, color
	
	; here we just invert deltaY, because it always used with -
	xor ax, ax
	sub ax, deltaY
	mov deltaY, ax
	
	; while(x1 != x2 || y1 != y2) {
xloop:
	mov ax, x1
	cmp ax, x2
	jnz xLoopBody
	mov bx, y1
	cmp bx, y2
	jnz xLoopBody
	
	jmp xLoopEnd
	
xLoopBody:

	; setPixel(x1, y1);
	invoke CGA_PutPixel, x1, y1, color
	
	; xerror2 = error * 2;
	mov ax, xerror
	shl ax, 2
	mov xerror2, ax
	
	; if(error2 > -deltaY) {
	mov ax, deltaY
	cmp xerror2, ax
	jle xCheckDeltaX
	
	; error -= deltaY;
	add xerror, ax
	
	; x1 += signX;
	mov ax, signX
	add x1, ax
	
xCheckDeltaX:

	; if(error2 < deltaX) {
	mov ax, deltaX
	cmp xerror2, ax
	jge xLoopContinue
	
	; error += deltaX;
	add xerror, ax
	
	; y1 += signY;
	mov ax, signY
	add y1, ax
        
xLoopContinue:
	jmp xLoop
	
xLoopEnd:
	ret
CGA_DrawLineGeneric endp



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
	
	invoke CGA_DrawLineVertical, sX, sY, eY, color
	RETURNW STATUS_SUCCESS

genericLine: 
	invoke CGA_DrawLineGeneric, sX, sY, eX, eY, color
	RETURNW STATUS_SUCCESS

CGA_DrawLine endp


; helper function
CGA_PlotCirclePoints proc uses cx bx x : word, y : word, xCenter : word, yCenter : word, color : byte

	; mempoint(x_center+x,y_center+y,color_code);
	mov cx, xCenter
	add cx, x
	mov bx, yCenter
	add bx, y
	invoke CGA_PutPixel, cx, bx, color
	
	;mempoint(x_center+x,y_center-y,color_code);
	mov cx, xCenter
	add cx, x
	mov bx, yCenter
	sub bx, y
	invoke CGA_PutPixel, cx, bx, color
	
    ;mempoint(x_center-x,y_center+y,color_code);
	mov cx, xCenter
	sub cx, x
	mov bx, yCenter
	add bx, y
	invoke CGA_PutPixel, cx, bx, color
	
    ;mempoint(x_center-x,y_center-y,color_code);
	mov cx, xCenter
	sub cx, x
	mov bx, yCenter
	sub bx, y
	invoke CGA_PutPixel, cx, bx, color
	
	ret
CGA_PlotCirclePoints endp




; Bresenham's circle algorithm implementation
CGA_DrawCircle proc uses ax bx dx xCenter : word, yCenter : word, radius : word, color : byte

	local x : word
	local y : word
	local delta : word
	local RR : word
	
	
    ;x = 0;
    mov x, 0
	
	;y = radius;
	mov ax, radius
	mov y, ax
	
	; RR = radius*radius;
	mov ax, radius
	mul ax
	mov RR, ax
	
	;while(x<y) {
xLoopBegin:
	mov ax, x
	cmp ax, y
	jge xLoopEnd
	
xLoopBody:
	;plot_circle(x,y,x_center,y_center,color_code);
	invoke CGA_PlotCirclePoints, x, y, xCenter, yCenter, color
	
	;plot_circle(y,x,x_center,y_center,color_code);
	invoke CGA_PlotCirclePoints, y, x, xCenter, yCenter, color
	
	; check
	; if (RR - x*x > y*y - y) y--; 
	
	mov ax, x
	mul ax
	mov bx, RR
	sub bx, ax
	
	mov ax, y
	mul ax
	sub ax, y
    
	cmp bx, ax
	jg xNoYDec
	
	dec y
	
xNoYDec:
	
	;x++;
	inc x
    
xLoopContinue:
	jmp xLoopBegin
	
	;}
xLoopEnd:

    ;if(x==y) plot_circle(x,y,x_center,y_center,color_code);
	mov ax, x
	cmp ax, y
	jne xProcRet
	
	invoke CGA_PlotCirclePoints, x, y, xCenter, yCenter, color
	
xProcRet:
	ret
	
CGA_DrawCircle endp


end
