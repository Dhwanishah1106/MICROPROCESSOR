Section .data

msg_gdt: db "content of GDTR are:"
len_gdt: equ $-msg_gdt

msg_limg: db "limit of GDTR is:"
len_limg: equ $-msg_limg

msg_ldt: db "content of LDTR are:"
len_ldt: equ $-msg_ldt

msg_idt: db "content of IDTR are:"
len_idt: equ $-msg_idt

msg_limi: db "limit of IDTR is:"
len_limi: equ $-msg_limi

msg_tr: db "content of TR is:"
len_tr: equ $-msg_tr

msg_msw: db "content of MSW are:"
len_msw:equ $-msg_msw

real: db "Working in real mode"
lenreal: equ $-real

proc: db "Working in protected mode"
lenproc: equ $-proc

newline: db 0x0A
count: db 0

Section .bss

%macro scall 4
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
%endmacro

msw:resb 4
result:resb 4
gdt:resb 6
idt:resb 6

Section .text

global main
main:
	smsw eax
	bt eax,0
	jnc next1
	scall 1,1,proc,lenproc
	scall 1,1,newline,2
	jmp next2
next1:	scall 1,1,real,lenreal
	scall 1,1,newline,2

next2:
	scall 1,1,msg_msw,len_msw

	smsw eax
	mov dword[msw],eax
	mov rsi,msw+2
	mov ax,word[rsi]
	call htoa
	mov rsi,msw
	mov ax,word[rsi]
	call htoa

	scall 1,1,newline,2
	
	scall 1,1,msg_ldt,len_ldt
	sldt ax
	call htoa
	
	scall 1,1,newline,2
	scall 1,1,msg_tr,len_tr
	str ax
	call htoa
	scall 1,1,newline,2

	scall 1,1,msg_gdt,len_gdt

	sgdt [gdt]
	mov rsi,gdt+4
	mov ax,word[rsi]
	call htoa
	mov rsi,gdt+2
	mov ax,word[rsi]
	call htoa

	scall 1,1,newline,2

	scall 1,1,msg_limg,len_limg
	mov rsi,gdt
	mov ax,word[rsi]
	call htoa

	scall 1,1,newline,2

	scall 1,1,msg_idt,len_idt

	sidt [idt]
	mov rsi,idt+4
	mov ax,word[rsi]
	call htoa
	mov rsi,idt+2
	mov ax,word[rsi]
	call htoa

	scall 1,1,newline,2

	scall 1,1,msg_limi,len_limi
	mov rsi,idt
	mov ax,word[rsi]
	call htoa

mov rax,60
mov rdi,0
syscall

htoa:
	mov rdi,result
	mov byte[count],4
up11:
	rol ax,04
	mov dl,al
	and dl,0FH
	cmp dl,09
	jbe next11
	add dl,07
next11:
	add dl,30H
	mov byte[rdi],dl
	inc rdi
	dec byte[count]
	jnz up11
scall 1,1,result,4
ret
		
