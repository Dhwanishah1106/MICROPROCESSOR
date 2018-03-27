Section .data
error: db "File not opened.",10
len: equ $-error

Section .bss
%macro scall 4
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
%endmacro

fname: resb 10
fname1: resb 10
fd_in1: resb 8
fd_in2: resb 8
len1: resb 8
buffer: resb 100

Section .text
global main
main:
	pop rbx
	pop rbx
	pop rbx
	cmp byte[rbx],'T'
	je type
	cmp byte[rbx],'C'
	je copy
	cmp byte[rbx],'D'
	je delete
	
type:	pop rbx
	call filename
	scall 2,fname,2,0777
	mov qword[fd_in1],rax
	BT rax,63
	jnc next1
	scall 1,1,error,len
	jmp exit
next1:
	scall 0,[fd_in1],buffer,100
	mov qword[len1],rax
	scall 1,1,buffer,len1
	mov rax,3
	mov rdi,[fd_in1]
	syscall
	jmp exit


copy:
	pop rbx
	call filename
	scall 2,fname,2,0777
	mov qword[fd_in1],rax
	BT rax,63
	jnc next2
	scall 1,1,error,len
	jmp exit
next2:
	scall 0,[fd_in1],buffer,100
	mov qword[len1],rax
	mov rax,3
	mov rdi,[fd_in1]
	syscall
	
	mov rbx,0
	pop rbx	
	call filename1
	scall 2,fname1,2,0777
	mov qword[fd_in2],rax
	BT rax,63
	jnc down3
	scall 1,1,error,len
	jmp exit
down3:	
	scall 1,[fd_in2],buffer,qword[len1]
	jmp exit


delete:
	pop rbx
	call filename
	mov rax,87
	mov rdi,fname
	syscall
	jmp exit

filename:
	mov rsi,rbx
	mov rdi,fname
	cld
up4:
	cmp byte[rsi],0
	je next4
	movsb
	jmp up4
next4:
	ret

filename1:
	mov rsi,rbx
	mov rdi,fname1
	cld
up5:
	cmp byte[rsi],0
	je next5
	movsb
	jmp up5
next5:
	ret


exit:	mov rax,60
	mov rdi,0
	syscall
