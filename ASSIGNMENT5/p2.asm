Section .bss
extern fd_in,buffer,choice,len1,result,find

count: resb 2

Section .text
global main2
main2:

global spc:
spc:
	mov rsi,buffer
	mov rcx,qword[len1]
	mov qword[count],rcx
	mov rcx,0
up1:	
	cmp byte[rsi],0x20
	jne next1
	inc cx
next1:
	inc rsi
	dec qword[count]
	jnz up1
	cmp cl,09
	jbe next2
	add cl,07
next2:
	add cl,30H
	mov byte[result],cl
	ret

global ent:
ent:
	mov rsi,buffer
	mov rcx,qword[len1]
	mov qword[count],rcx
	mov rcx,0
up2:	
	cmp byte[rsi],0x0A
	jne next3
	inc cx
next3:
	inc rsi
	dec qword[count]
	jnz up2
	cmp cl,09
	jbe next4
	add cl,07
next4:
	add cl,30H
	mov byte[result],cl
	ret


global occ
occ:
	mov rsi,buffer
	mov rcx,qword[len1]
	mov qword[count],rcx
	mov rcx,0
	mov ax,0
	mov al,byte[find]
up3:
	cmp byte[rsi],al
	jne next5
	inc cx
next5:
	inc rsi
	dec qword[count]
	jnz up3
	ret

