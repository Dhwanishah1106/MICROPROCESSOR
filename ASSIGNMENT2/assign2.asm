Section .data

menu: db "1.Non-overlapping without string",10
db "2.Non-overlapping with string",10
db "3.Overlapping without string",10
db "4.Overlapping with string",10
db "5.Exit",10
lenmenu: equ $-menu

ini: db "Initial Array",10
lenini: equ $-ini
final: db "Final Array",10
lenfin: equ $-final
colon: db ":"
lencol: equ $-colon

array: dq 0x94326702319234A2,0xAD76342598301249,0x34618902315670C4,0x9874632015429ECD,0x754230120AB389C7
new1: dq 0x00,0x00,0x00,0x00,0x00
count1: db 0
count2: db 0
count3: db 0
count4: db 0
count5: db 0
newline: db 0x0A

Section .bss
%macro scall 4
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
%endmacro

choice: resb 02
new: resb 16
value: resb 16

Section .text
global main
main:

scall 1,1,menu,lenmenu
scall 0,0,choice,2

cmp byte[choice],31H
je NONOVERLAPPED
cmp byte[choice],32H
je NONOVERLAPPED_STR
cmp byte[choice],33H
je OVERLAPPED
cmp byte[choice],34H
je OVERLAPPED_STR
cmp byte[choice],35H
je EXIT

NONOVERLAPPED:
	scall 1,1,ini,lenini
	call print_array
	mov rsi,array
	mov rdi,array+40
	mov byte[count1],5
	up1:
		mov rcx,qword[rsi]
		mov qword[rdi],rcx
		add rsi,8
		add rdi,8
		dec byte[count1]
		jnz up1
	scall 1,1,final,lenfin
	call print_final
	jmp main

NONOVERLAPPED_STR:
	scall 1,1,ini,lenini
	call print_array
	mov rsi,array
	mov rdi,array+40
	mov byte[count1],5
	up2:
		movsq
		dec byte[count1]
		jnz up2
	scall 1,1,final,lenfin
	call print_final
	jmp main

OVERLAPPED:
	scall 1,1,ini,lenini
	call print_array
	call other_shift
	mov rsi,new1
	mov rdi,array+24
	mov byte[count1],5
	up3:
		mov rcx,qword[rsi]
		mov qword[rdi],rcx
		add rsi,8
		add rdi,8
		dec byte[count1]
		jnz up3
	scall 1,1,final,lenfin
	call print_final2
	jmp main

OVERLAPPED_STR:
	scall 1,1,ini,lenini
	call print_array
	call other_shift
	mov rsi,new1
	mov rdi,array+24
	mov byte[count1],5
	up4:
		movsq
		dec byte[count1]
		jnz up4
	scall 1,1,final,lenfin
	call print_final2
	jmp main

other_shift:
	mov rsi,array
	mov rdi,new1
	mov byte[count5],5
	oi:
		mov rcx,qword[rsi]
		mov qword[rdi],rcx
		add rsi,8
		add rdi,8
		dec byte[count5]
		jnz oi
	ret
		

EXIT:	mov rax,60
	mov rdi,0
	syscall

print_array:
	mov rsi,array
	mov byte[count1],5
	up5:
		mov rbx,rsi
		push rsi
		call htoa1
		pop rsi
		mov rcx,qword[rsi]
		push rsi
		call htoa2
		pop rsi
		add rsi,8
		dec byte[count1]
		jnz up5
	ret


print_final:
	mov rsi,array
	mov byte[count1],10
	up6:
		mov rbx,rsi
		push rsi
		call htoa1
		pop rsi
		mov rcx,qword[rsi]
		push rsi
		call htoa2
		pop rsi
		add rsi,8
		dec byte[count1]
		jnz up6
		ret

print_final2:
	mov rsi,array
	mov byte[count1],8
	up7:
		mov rbx,rsi
		push rsi
		call htoa1
		pop rsi
		mov rcx,qword[rsi]
		push rsi
		call htoa2
		pop rsi
		add rsi,8
		dec byte[count1]
		jnz up7
		ret

htoa1:	
	mov rdi,new
	mov byte[count4],16
	up11:
		rol rbx,04
		mov dl,bl
		And dl,0FH
		cmp dl,09
		jbe next31
		add dl,07
		next31:
			add dl,30H
			mov byte[rdi],dl
			inc rdi
			dec byte[count4]
			jnz up11
	scall 1,1,new,16
	scall 1,1,colon,1
	ret

htoa2:	
	mov rdi,value
	mov byte[count3],16
	up22:
		rol rcx,04
		mov dl,cl
		and dl,0FH
		cmp dl,09
		jbe next2
		add dl,07
		next2:
			add dl,30H
			mov byte[rdi],dl
			inc rdi
			dec byte[count3]
			jnz up22
		scall 1,1,value,16
		scall 1,1,newline,2
		ret

	

	

