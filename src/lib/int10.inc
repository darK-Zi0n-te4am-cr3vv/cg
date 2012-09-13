; int10.inc - int 10 common routines

; videomodes

VMODE_CGA_COLOR_320		equ		04h
VMODE_CGA_GRAYSCALE_320	equ		05h
VMODE_CGA_MONO_640		equ		06h

VMODE_EGA_COLOR_320_200	equ		0dh
VMODE_EGA_COLOR_640_200	equ		0eh
VMODE_EGA_MONO_BOLD_640	equ		0fh
VMODE_EGA_COLOR_640_350	equ		10h



EGA_VMEM_SEG	equ		0A000h		

Int10_SetVideoMode proto 
	bVMode : byte 