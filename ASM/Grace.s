; Grace ASM quine - writes itself to Grace_kid.s
%macro OPEN_FILE 0
    mov rax, 2
    lea rdi, [rel fname]
    mov rsi, 0o1101
    mov rdx, 0o644
    syscall
%endmacro

%macro WRITE_SRC 0
    mov rdi, rax
    mov rax, 1
    lea rsi, [rel src]
    mov rdx, srclen
    syscall
%endmacro

%macro CLOSE_FD 0
    mov rax, 3
    syscall
%endmacro

section .data
fname: db "Grace_kid.s", 0
src: incbin "Grace.s"
srclen: equ $-src

section .text
global main
main:
    OPEN_FILE
    WRITE_SRC
    CLOSE_FD
    xor eax, eax
    ret
