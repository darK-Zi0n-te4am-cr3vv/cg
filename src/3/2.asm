.model  small
.code
.stack 128

main:


mov	ax, 10h
int	10h	

MOV  DX,3C4H        ;��������� �� �������� �������
MOV  AL,2           ;������ �������� ����� �����
OUT  DX,AL          ;��������� ������
INC  DX             ;��������� �� ������� ������
MOV  AL, 1001b      ;��� �����
OUT  DX,AL          ;�������� ��� �����

mov	ax, 0a000h
mov es, ax				

mov di, 05h			;��� ����, ����� ���� �����
					;��� ��� ���� �������� ������
mov es:[di], 0ffh	;������ ������

mov di, 55h

mov es:[di], 9h 


xor	ax, ax				;�������� ������� �������
int	16h

mov	ax,4c00h			;����� �� ������� � ���������
int	21h				   ;� ���������� �����

end main