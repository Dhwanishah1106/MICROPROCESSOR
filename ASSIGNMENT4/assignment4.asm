Section .data
msg: db "MENU",0x0A
     db "SUCCESIVE ADDITION",0x0A
     db "ADD AND SHIFT",0x0A
     db "EXIT",0x0A
len: equ $-msg

msg1:db "Enter your multiplicand "
len1: equ $-msg1 
    
msg2:db "Enter your multiplier"
len2: equ $-msg2

Section .bss
multiplicand: resb 3
multiplier: resb 3

choice: resb 2
result: resb 4
cnt: resb 2

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
je next

cmp byte[choice],32H
je next1

cmp byte[choice],33H
je next2

next:scall 1,1,msg1,len1
     scall 0,0,multiplicand,3
     scall 1,1,msg2,len2
     scall 0,0,multiplier,3
     call SA
     jmp main
  
next1:scall 1,1,msg1,len1
     scall 0,0,multiplicand,3
     scall 1,1,msg2,len2
     scall 0,0,multiplier,3
     call AS
     jmp main
     
next2:mov rax,60
      mov rdi,0
      syscall
     
SA: 	mov rsi,multiplicand
	call atoh
	mov byte[multiplicand],al
	mov rsi,multiplier
	call atoh
	mov byte[cnt],al
	mov ax,0x0000
	mov dx,0x0000
	mov dl,byte[multiplicand]
	up:add ax,dx
	dec byte[cnt]
	jnz up
	call htoa
	ret
	
AS:	mov rsi,multiplicand
	call atoh
	mov byte[multiplicand],al
	mov rsi,multiplier
	call atoh
	mov bl,al
	mov byte[cnt],8
	mov dx,0x0000
	mov dl,byte[multiplicand]
	mov ax,0x0000
	up7:shr bl,1
	jnc next4
	add ax,dx
	next4:shl dx,1
	dec byte[cnt]
	jnz up7
	call htoa
	ret

htoa:
mov rsi,result
mov byte[cnt],4
up1:rol ax,4
    mov cl,al
    and cl,0FH
    cmp cl,09
    jbe next5
    add cl,07H
next5:add cl,30H
      mov byte[rsi],cl
      inc rsi
      dec byte[cnt]
      jnz up1
scall 1,1,result,4
ret
		
atoh:mov al,0x00
     mov byte[cnt],2
     up2:rol al,4
        mov bl,byte[rsi]
        cmp bl,39H
        jbe next3
        sub bl,07H
next3:sub bl,30H
     add al,bl
     inc rsi
     dec byte[cnt]
     jnz up2
ret
     
