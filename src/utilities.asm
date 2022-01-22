section .text


global exstdout
exstdout:       ; explicit stdout (explicit write size)
; argument rdi for message
; argument rsi for size

push rbp
mov rbp, rsp

mov     rdx, rsi            ; write size, until terminating zero
mov     rsi, rdi            ; memory address of message
mov     rdi, 1              ; file descriptor for stdout
mov     rax, 1              ; write
syscall                

mov rsp, rbp
pop rbp

ret



global stdout
stdout:
; argument rdi for message

push rbp
mov rbp, rsp

call strsize   

mov     rdx, rax            ; write size, until terminating zero
mov     rsi, rdi            ; memory address of message
mov     rdi, 1              ; file descriptor for stdout
mov     rax, 1              ; write
syscall                

mov rsp, rbp
pop rbp

ret


global strsize
strsize:
; argument rdi for memory address of string

push rbp
mov rbp, rsp

push r12        ; callee saved

mov r12, 0      ; index (length when done)

; keep checking for terminating zero
.checkloop:
    mov r11b, [rdi+r12]
    cmp r11b, 0

    je .done
    inc r12
    jmp .checkloop
    
.done:
    mov rax, r12

    pop r12     ; callee saved

    mov rsp, rbp
    pop rbp

    ret


global stdin
stdin:
; argument rdi for buffer memory address
; argument rsi for buffer size

push rbp
mov rbp, rsp

push rdi ; callee saved
push rsi ; callee saved
push rdx ; callee saved

mov rdx, rsi                ; buffer size
mov rsi, rdi                ; buffer memory address
xor rdi, rdi                ; file descriptor for stdin
xor rax, rax                ; read
syscall                   

pop rdx ; callee saved
pop rsi ; callee saved
pop rdi ; callee saved

mov rsp, rbp
pop rbp

ret


global read
read:
; argument rdi for file descriptor
; argument rsi for buffer memory address
; argument rdx for buffer size

push rbp
mov rbp, rsp

push rdi ; callee saved
push rsi ; callee saved
push rdx ; callee saved

; rdx in arguments for buffer size
; rsi in arguments for buffer memory address
; rdi in arguments for file descriptor
xor rax, rax                ; read
syscall

pop rdx ; callee saved
pop rsi ; callee saved
pop rdi ; callee saved

mov rsp, rbp
pop rbp

ret
