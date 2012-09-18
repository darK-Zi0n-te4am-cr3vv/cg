.model  small
.code
.stack 128

main:


mov	ax, 10h
int	10h	

MOV  DX,3C4H        ;указываем на адресный регистр
MOV  AL,2           ;индекс регистра маски карты
OUT  DX,AL          ;установка адреса
INC  DX             ;указываем на регистр данных
MOV  AL, 1010b      ;код цвета
OUT  DX,AL          ;посылаем код цвета

mov	ax, 0a000h
mov es, ax				

mov di, 2F56h

mov al,1h
mov es:[di], al 


xor	ax, ax				;ожидание нажатия клавиши
int	16h

mov	ax,4c00h			;выход из графики с возвратом
int	21h				   ;в предыдущий режим

end main