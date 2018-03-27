Section .data

array: dq 0x4325798012654213,0xA32574801B652210,0x332A19801C654F17,0x83AB698012654E16,0x1E37357980A65421,0xF325798012656219,0x8323798012694215,0xC3857920126F4213,0x632A798012B5431A,0xC325795014654819

msgarr: db "Array is 0x4325798012654213,0xA32574801B652210,0x332A19801C654F17,0x83AB698012654E16,0x1E37357980A65421,0xF325798012656219,0x8323798012694215,0xC3857920126F4213,0x632A798012B5431A,0xC325795014654819",10
arrlen: equ $-msgarr

pos: db 0
neg: db 0
count: db 10
newline: db 0x0A

msgpos: db "No. of positive numbers = "
poslen: equ $-msgpos
msgneg: db "No. of negative numbers = "
neglen: equ $-msgneg


Section .bss

%macro print 2
	mov rax,1
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

Section .text
global main
main:

print msgarr,arrlen

mov rsi,array

up:
	mov rax,qword[rsi]
	BT rax,63
	jc next1
	inc byte[pos]
	add rsi,8
	dec byte[count]
	jnz up
	jmp next2
	next1:	inc byte[neg]
		add rsi,8		
		dec byte[count]
		jnz up
	
next2:
	cmp byte[pos],9
	jbe next3
	add byte[pos],7
next3:
	add byte[pos],30H
	cmp byte[neg],9
	jbe next4
	add byte[neg],7

next4:	add byte[neg],30H

print msgpos,poslen
print pos,1
print newline,1

print msgneg,neglen
print neg,1
print newline,1

mov rax,60
mov rdi,0
syscall	
