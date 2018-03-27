Section .data

msg: db "Factorial is "
len: equ $-msg

Section .bss
%macro scall 4
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
%endmacro

count: resb 2
result: resb 8
number: resb 1

Section .text
global main
main:
	pop rbx
	pop rbx
	pop rbx
	mov dl,byte[rbx]
	sub dl,30H
	mov byte[number],dl
	mov eax,1H
	call fact

fact:
	mul dl
	dec dl
	cmp dl,01H
	je next
	call fact
next:
	mov rsi,result
	mov byte[count],8
up:
	rol eax,04
	mov cl,al
	and cl,0x0F
	cmp cl,09H
	jbe next1
	add cl,07H
next1:
	add cl,30H
	mov byte[rsi],cl
	inc rsi
	dec byte[count]
	jnz up
	scall 1,1,msg,len
	scall 1,1,result,8

exit:
	mov rax,60
	mov rdi,0
	syscall

	

