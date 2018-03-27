section .data
msg1: db "1.Hex to BCD",10 
	db "2.BCD to Hex",10
	db "3.Exit",10
	db "Enter your choice : ",10
len1: equ $-msg1

msg2: db "Enter the 4 digit hex number : ",10
len2: equ $-msg2

msg3: db "Enter the 5 digit BCD number : ",10
len3: equ $-msg3

msg4: db "BCD number is ",10
len4: equ $-msg4

msg5: db "Hex number is ",10
len5: equ $-msg5

newline: db 10
newlen: equ $-newline

count: db 00H
count1: db 00H
count2: db 00H
cnt2: db 00H

section .bss

%macro scall 4                    ;macro to take input and output
        mov rax,%1
        mov rdi,%2
        mov rsi,%3
        mov rdx,%4
        syscall
%endmacro
choice: resb 2
ans: resw 4
result: resw 8
num: resb 5
num1: resb 9

section .text
global main
main:

	scall 1,1,msg1,len1
	scall 0,0,choice,2

	cmp byte[choice],31H
	je hex2bcd
	cmp byte[choice],32H
	je bcd2hex
	cmp byte[choice],33H
	je exit

hex2bcd:
	scall 1,1,msg2,len2
	scall 0,1,num,5
	call atoh
	mov bx,0x0A
	mov byte[count1],00
	up11:
		mov dx,00
		div bx
		push dx
		inc byte[count1]
		cmp ax,00
		jne up11
	print:
		pop ax
		cmp ax,09H
		jbe next11
		add ax,07H
	next11:
		add ax,30H
		mov byte[ans],al
		scall 1,1,ans,1
		dec byte[count1]
		jnz print
		scall 1,1,newline,1
		jmp main

bcd2hex:
	scall 1,1,msg3,len3
	scall 0,0,num,6
	call atoh
		
	mov edx,eax			
	mov eax,00H
	mov ebx,00H
	mov al,dl
	and al,0FH
	mov bl,01H
	mul bl
	add dword[ans],eax
	ror edx,4

	mov eax,00H			
	mov ebx,00H
	mov al,dl
	and al,0FH
	mov bl,0AH
	mul bl
	add dword[ans],eax
	ror edx,4

	mov eax,00H			
	mov ebx,00H
	mov al,dl
	and al,0FH
	mov bl,64H
	mul bl
	add dword[ans],eax
	ror edx,4

	mov eax,00H			
	mov ebx,00H
	mov al,dl
	and al,0FH
	mov bx,03E8H
	mul bx
	add dword[ans],eax
	ror edx,4

	mov eax,00H			
	mov ebx,00H
	mov al,dl
	and al,0FH
	mov bx,2710H			;100,000
	mul bx
	add dword[ans],eax
	
	mov edx,dword[ans]
	mov rdi,result
	call htoa

	scall 1,1,msg5,len5
	scall 1,1,result,8
	scall 1,1,newline,newlen
	jmp main

atoh:
	mov rsi,num
	mov ax,00H
	mov byte[count1],04H
	up1:
		rol ax,04
		mov bl,byte[rsi]
		cmp bl,39H
		jbe next1
		sub bl,07
	next1:
		sub bl,30H
		add al,bl
		inc rsi
		dec byte[count1]
		jnz up1
		ret
	
htoa:
	mov byte[cnt2],08H
	up7:
		rol edx,04
		mov cl,dl
		and cl,0FH
		cmp cl,09H
		jbe next7
		add cl,07
	next7:
		add cl,30H
		mov byte[rdi],cl
		inc rdi
		dec byte[cnt2]
		jnz up7
	ret

exit:	mov rax,60
	mov rdi,0
	syscall		
