extern stdout
extern exstdout
extern read

global main
main:

section .data
; errors
	.openError 	db 		"Error while opening",10,0
	.usageError db 		"Incorrect usage/syntax",10,0
	.readError 	db 		10,"Error while reading",10,0 	; starts with NL because it prints between other texts
; messages
	.catExit 	db 		10,"Succesfuly exiting cat...",10,0

section .text
; rdi (command line arg) is argument count
; rsi (command line arg) is string of arguments: file location with terminating zero

mov r12, rdi		; argc
mov r13, rsi 		; argv

; check for usage errors 
cmp r12, 2  	
jne .usageerror

; open file
mov rdi, [r13+8]	; use second argument, each argument is 8 bytes
call open
mov r14, rax		; save FD to r14

cmp r14, 0
jl .openerror

; print file
mov rdi, r14
call prtopenf

cmp rax, 0
jl .readerror

; exit with succes
jmp .succes

.usageerror:
	mov rdi, .usageError
	call stdout
	jmp exit

.openerror:
	mov rdi, .openError
	call stdout
	jmp exit

.readerror:
	mov rdi, .readError
	call stdout
	jmp exit

.succes:
	mov rdi, .catExit
	call stdout
	jmp exit



open:

section .data
	.NR_open equ 2
	.O_RDONLY equ 000000q

section .text
; rdi is argument file_location

push rbp
mov rbp, rsp

; open with read mode, return file descriptor in rax or error code
mov rax, .NR_open
mov rsi, .O_RDONLY

syscall

mov rsp, rbp
pop rbp

ret


prtopenf:

section .data
	.bufsize dq 100

section .bss
	.buffer resb 100

section .text
; rdi is argument FD

push rbp
mov rbp, rsp

push r12		; callee saved

mov r12, rdi 	; save local file descriptor

; seek beginning of the file
mov rax, 8 		; file lseek
mov rdi, r12
mov rsi, 0  	; begin of file 
syscall

; keep printing until call returns 0 read
.prtloop:
; read buffer
	mov rdi, r12
	mov rsi, .buffer
	mov rdx, [.bufsize]
	call read

; look for errors or end of file
	cmp rax, 0
	jl .readerror
	je .done
	
; write buffer			
	mov rdi, .buffer    
	mov rsi, [.bufsize] 
	call exstdout

; if no error or EOF loop
	jmp .prtloop

.readerror:
	mov rsp, rbp
	pop rbp

	pop r12		; callee saved

	ret

.done:
	mov rsp, rbp
	pop rbp

	pop r12		; callee saved

	ret


exit:

mov rax, 60
mov rdi, 0
syscall