Section .data

menu: db "1. Ascending",10
db "2. Descending",10
db "3.Exit",10
db "Enter your choice: ",10
menu_len: equ $-menu

error: db "File not opened.",10
lenerr: equ $-error
success: db "File opened successfully.",10
lensuc: equ $-success

fname: db 'abc.txt',0

count1: db 00
count2: db 00
count3: db 00
count4: db 00

Section .bss
%macro scall 4
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
%endmacro

choice: resb 2
fd_in: resb 8
buffer: resb 50
len1: resb 8

Section .text
global main
main:
	scall 2,fname,2,0777
	mov qword[fd_in],rax
	bt rax,63
	jnc next1
	scall 1,1,error,lenerr
	jmp exit
next1:	scall 1,1,success,lensuc
	scall 0,[fd_in],buffer,100
	mov qword[len1],rax

menu1:	scall 1,1,menu,menu_len
	scall 0,1,choice,2
	
	cmp byte[choice],31H
	je option1
	cmp byte[choice],32H
	je option2
	cmp byte[choice],33H
	je exit

option1:
	call ascending
	scall 1,[fd_in],buffer,qword[len1]
	jmp menu1

option2:
	call descending
	scall 1,[fd_in],buffer,qword[len1]
	jmp menu1

ascending:
	mov byte[count1],5
up1:
	mov ax,0
	mov dx,0
	mov byte[count2],4
	mov rsi,buffer
	mov rdi,buffer
up2:
	mov al,byte[rsi]
	add rsi,2
	cmp byte[rsi],al
	jnc next11
	mov dl,byte[rsi]
	mov byte[rdi],dl
	mov byte[rsi],al
next11:
	add rdi,2
	dec byte[count2]
	jnz up2
	dec byte[count1]
	jnz up1
	ret


descending:
	mov byte[count1],5
up3:
	mov ax,0
	mov dx,0
	mov byte[count2],4
	mov rsi,buffer
	mov rdi,buffer
up4:
	mov al,byte[rsi]
	add rsi,2
	cmp byte[rsi],al
	jc next22
	mov dl,byte[rsi]
	mov byte[rdi],dl
	mov byte[rsi],al
next22:
	add rdi,2
	dec byte[count2]
	jnz up4
	dec byte[count1]
	jnz up3
	ret

exit:
	mov rax,3
	mov rdi,[fd_in]
	mov rax,60
	mov rdi,0
	syscall	

