.model  small
.code
.stack 128

main:


mov	ax, 04h
int	10h	

mov	ax, 0B800h
mov es, ax				


mov di, 0A5h
add di, 2000h

mov di, 0a4h

mov es:[di], 9ch 

xor	ax, ax				;�������� ������� �������
int	16h

mov	ax,4c00h			;����� �� ������� � ���������
int	21h				;� ���������� �����

end main