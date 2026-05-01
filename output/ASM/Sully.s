;i=5
section .rodata
fname_fmt:  db "Sully_%d.s", 0
mode_w:     db "w", 0
iline_fmt:  db ";i=%d", 10, 0
copy_fmt:   db "cp Sully_%d.s /tmp/sully_self.s", 0
gcc_fmt:    db "nasm -f elf64 Sully_%d.s -o /tmp/Sully_%d.o 2>/dev/null && gcc -no-pie /tmp/Sully_%d.o -o Sully_%d 2>/dev/null", 0
run_fmt:    db "./Sully_%d", 0

section .data
src:        incbin "/tmp/sully_self.s"
srclen:     equ $-src

section .bss
fname:      resb 64
cmd:        resb 512
iline:      resb 16

section .text
extern sprintf
extern fopen
extern fwrite
extern fclose
extern system
global main

main:
    push rbp
    mov rbp, rsp
    push rbx
    sub rsp, 8

    movzx eax, byte [rel src + 3]
    sub eax, '0'
    sub eax, 1
    mov ebx, eax

    lea rdi, [rel fname]
    lea rsi, [rel fname_fmt]
    mov edx, ebx
    xor eax, eax
    call sprintf

    lea rdi, [rel fname]
    lea rsi, [rel mode_w]
    call fopen
    test rax, rax
    jz .err
    mov r12, rax

    lea rdi, [rel iline]
    lea rsi, [rel iline_fmt]
    mov edx, ebx
    xor eax, eax
    call sprintf

    lea rdi, [rel iline]
    mov rsi, 1
    mov rdx, 5
    mov rcx, r12
    call fwrite

    lea rdi, [rel src + 5]
    mov rsi, 1
    mov rdx, srclen
    sub rdx, 5
    mov rcx, r12
    call fwrite

    mov rdi, r12
    call fclose

    test ebx, ebx
    js .done

    lea rdi, [rel cmd]
    lea rsi, [rel copy_fmt]
    mov edx, ebx
    xor eax, eax
    call sprintf

    lea rdi, [rel cmd]
    call system

    lea rdi, [rel cmd]
    lea rsi, [rel gcc_fmt]
    mov edx, ebx
    mov ecx, ebx
    mov r8d, ebx
    mov r9d, ebx
    xor eax, eax
    call sprintf

    lea rdi, [rel cmd]
    call system

    lea rdi, [rel cmd]
    lea rsi, [rel run_fmt]
    mov edx, ebx
    xor eax, eax
    call sprintf

    lea rdi, [rel cmd]
    call system

.done:
    xor eax, eax
    add rsp, 8
    pop rbx
    pop rbp
    ret

.err:
    mov eax, 1
    add rsp, 8
    pop rbx
    pop rbp
    ret
