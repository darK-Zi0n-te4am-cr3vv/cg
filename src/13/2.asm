.model  small
.stack 128

; this is just sample
; has no dependencies on lib

; В видеоадаптере CGA (цветном) в в видеопамяти на фоне всех нулей в байт
; с адресом 2000h+A4h относительно начала видеопамяти записан код 9Ch.
; Определить, что отобразится на экране в этом случае, и обоснование этого
; определения представить преподавателю.
; Разработать программу, отображающую это на экране.

PX_OFFSET		equ		(2000h + 0A4h)
PX_BYTE			equ		09Ch

CGA_VMEM_SEG	equ		0B800h

.code

main:

	; init CGA color vmode
	mov	ax, 04h
	int	10h	

	; init es segmet register 
	mov	ax, CGA_VMEM_SEG
	mov es, ax				

	mov di, PX_OFFSET

	mov es:[di], PX_BYTE 

	; wait keypress
	mov ax, 00h
	int	16h

	; exit to dos
	mov	ax, 4c00h		
	int	21h				
	
end main