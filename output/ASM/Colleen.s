; outer comment
section .data
src: incbin "Colleen.s"
srclen: equ $-src
section .text
global _start
_start:
    ; inner comment
    call printer
    mov rax, 60
    xor rdi, rdi
    syscall
printer:
    mov rax, 1
    mov rdi, 1
    mov rsi, src
    mov rdx, srclen
    syscall
    ret
