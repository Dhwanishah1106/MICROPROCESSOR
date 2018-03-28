Section .data
msg: db "Menu",0x0A
     db	"1.HEX TO BCD",0x0A
     db	"2.BCD TO HEX",0x0A
     db	"3.EXIT",0x0A
len: equ $-msg

msg2: db "Please enter HEX number"
len2: equ $-msg2

msg3: db "Please enter BCD number"
len3: equ $-msg3

result: dd 0x00000000

Section .bss
choice: resb 2
noh: resb 5
nob: resb 6
cnt: resb 1
temp:resb 2
temp1:resb 2

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
scall 1,1,msg,len
scall 0,0,choice,2
cmp byte[choice],31H
je next1

cmp byte[choice],32H
je next2

cmp byte[choice],33H
je next3

next1:	scall 1,1,msg2,len2
	scall 0,0,noh,5
	call htob
	jmp main
	
next2:	scall 1,1,msg3,len3
	scall 0,0,nob,6
	call btoh
	jmp main	

next3: mov rax,60
       mov rdi,0
       syscall	


atoh:
mov ax,00
mov rsi,noh
mov byte[cnt],4
up:rol ax,4
   mov bl,byte[rsi]
   cmp bl,39H
   jbe next
   sub bl,07H
next:sub bl,30H
     add al,bl
     inc rsi
     dec byte[cnt]
     jnz up
ret

htob:
 call atoh
 mov bx,0x0A
 mov byte[cnt],0
up1:mov dx,00
    div bx
    push dx
    inc byte[cnt]
    cmp ax,0
    jne up1
    

up2:pop dx
   add dx,30H
    mov word[temp],dx
    scall 1,1,temp,2
    dec byte[cnt]
    jnz up2
ret
  
atob:
mov eax,00000000
mov rsi,nob
mov byte[cnt],5
up3:rol eax,4
    mov bl,byte[rsi]
    sub bl,30H
    add al,bl
    inc rsi
    dec byte[cnt]
    jnz up3
ret
    
btoh:
call atob
mov ebx,eax
and eax,0x0000000f
mov dx,0x01
mul dx
mov ecx,00000000H
add ecx,eax
ror ebx,4
mov eax,ebx
and eax,0x0000000f
mov dx,0x0A
mul dx
add ecx,eax
ror ebx,4
mov eax,ebx
and eax,0x0000000f
mov dx,0x64
mul dx
add ecx,eax
ror ebx,4
mov eax,ebx
and eax,0x0000000f
mov dx,0x3E8
mul dx
add ecx,eax
ror ebx,4
mov eax,ebx
and eax,0x0000000f
mov dx,0x2710
mul dx
add ecx,eax
mov word[temp1],cx

mov rsi,temp1
inc rsi
mov al,byte[rsi]
rol al,4
and al,0x0F
cmp al, 09
jbe l1
add al,07H

l1:
add al, 30H
mov byte[temp],al
scall 1,1,temp,1

mov rsi,temp1
inc rsi
mov al,byte[rsi]
rol al, 4
and al,0x0F
cmp al, 09
jbe l2
add al,07H

l2:
add al, 30H
mov byte[temp],al
scall 1,1,temp,1

mov rsi,temp1
mov al,byte[rsi]
rol al,4
and al,0x0F
cmp al, 09
jbe l3
add al,07H

l3:
add al, 30H
mov byte[temp],al
scall 1,1,temp,1



mov rsi,temp1
mov al,byte[rsi]
and al,0x0F
cmp al, 09
jbe l4
add al,07H

l4:
add al, 30H
mov byte[temp],al
scall 1,1,temp,1
ret

 

    
        
    
  
