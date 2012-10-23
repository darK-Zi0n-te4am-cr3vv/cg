; cga.inc - routines to operate in CGA video mode


CGA_SUBMODE_RG	equ		00h
CGA_SUBMODE_CM	equ		01h
CGA_SUBMODE_BW	equ		02h

CGA_VMEM_SEG		equ		0b800h
CGA_VMEM_HALF_SIZE	equ		1F40h ; 320 * 100 * 2bpp	
CGA_VMEM_HALF_AREA	equ		2000h	

CGA_COLOR_SCREEN_WIDTH	equ		320
CGA_COLOR_SCREEN_HEIGHT	equ		200

CGA_LINE_SIZE			equ		050h



CGA_CM_BLACK	equ		00h
CGA_CM_CYAN		equ		01h
CGA_CM_MAGENTA	equ		02h
CGA_CM_WHITE	equ		03h

CGA_RG_BLACK	equ		00h
CGA_RG_RED		equ		01h
CGA_RG_GREEN	equ		02h
CGA_RG_BROWN	equ		03h


; Initializares CGA video mode and returns error code
CGA_InitVideo proto bCGASubMode : byte

CGA_ClearScreen proto

CGA_PutPixel proto wX : word, wY : word, bColor : byte
CGA_DrawLine proto sX : word, sY : word, eX : word, eY : word, color : byte
CGA_DrawCircle proto xCenter : word, yCenter : word, radius : word, color : byte
