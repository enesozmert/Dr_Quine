; outer comment
section .data
src: incbin "Colleen.s"
srclen: equ $-src
section .text
global main
main:
    ; inner comment
    call printer
    xor eax, eax
    ret
printer:
    mov rax, 1
    mov rdi, 1
    mov rsi, src
    mov rdx, srclen
    syscall
    ret
