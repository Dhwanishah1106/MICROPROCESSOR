Section .data

fname: db 'abc.txt',0

success: db "File opened successfully.",10
lensuc: equ $-success
error: db "File not opened.",10
lenerr: equ $-error

menu: db "1. No of spaces",10
db "2. No of enters",10
db "3. Occurence of a letter",10
db "4.Exit",10
db "Enter choice : ",10
lenmenu: equ $-menu

letter: db "Enter the letter : ",10
lenlet: equ $-letter

ans1: db "No. of spaces = ",10
lenans1: equ $-ans1

ans2: db "No. of enters = ",10
lenans2: equ $-ans2

ans3: db "No. of occurences = ",10
lenans3: equ $-ans3

count: db 00
newline: db 0x0A

Section .bss
global fd_in,buffer,choice,len1,result,find

fd_in: resb 8
buffer: resb 100
choice: resb 2
len1: resb 8
result: resb 1
find: resb 2

%macro scall 4
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
%endmacro

Section .text
global main
main:
	scall 2,fname,2,0777
	mov qword[fd_in],rax
	bt rax,63
	jnc next1
	scall 1,1,error,lenerr
	jmp exit
next1:
	scall 1,1,success,lensuc
	scall 0,[fd_in],buffer,100
	mov qword[len1],rax
menu1:
	scall 1,1,menu,lenmenu
	scall 0,0,choice,2
	cmp byte[choice],31H
	je space
	cmp byte[choice],32H
	je enter
	cmp byte[choice],33H
	je occurence
	cmp byte[choice],34H
	je exit	
	
space:	extern spc
	call spc
	scall 1,1,ans1,lenans1
	scall 1,1,result,1
	scall 1,1,newline,1
	jmp menu1

enter:	extern ent
	call ent
	scall 1,1,ans2,lenans2
	scall 1,1,result,1
	scall 1,1,newline,1
	jmp menu1

occurence:	
	scall 1,1,letter,lenlet
	scall 0,1,find,2
	extern occ
	call occ
	cmp cx,09
	jbe next2
	add cx,07
   next2:
	add cx,30H
	mov byte[result],cl
	scall 1,1,ans3,lenans3
	scall 1,1,result,1
	scall 1,1,newline,1
	jmp menu1

exit:	mov rax,3
	mov rdi,[fd_in]
	mov rax,60
	mov rdi,0
	syscall
