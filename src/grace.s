; grace.s - x86-64 Assembly Quine with File Writing
; Writes own source code to Grace_kid.s file
; nasm -f elf64 grace.s -o obj/grace.o && ld obj/grace.o -o grace

section .data
	filename:	db	"Grace_kid.s", 0
	quine:		db	"; grace.s - x86-64 Assembly Quine with File Writing", 10
			db	"; Writes own source code to Grace_kid.s file", 10
			db	"; nasm -f elf64 grace.s -o obj/grace.o && ld obj/grace.o -o grace", 10, 10
			db	"section .data", 10
			db	9, "filename:", 9, "db", 9, 34
			db	"Grace_kid.s", 34, ", 0", 10
			db	9, "quine:", 9, 9, "db", 9, 34
			db	"; grace.s - x86-64 Assembly Quine with File Writing", 34, 10
			db	9, 9, "db", 9, 34
			db	"; Writes own source code to Grace_kid.s file", 34, 10
			db	9, 9, "db", 9, 34
			db	"; nasm -f elf64 grace.s -o obj/grace.o && ld obj/grace.o -o grace", 34, 10, 10
			db	9, 9, "db", 9, 34
			db	"section .data", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "filename:", 9, "db", 9, 34, 34
			db	", 0", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "quine:", 9, 9, "db", 9, 34, 34, 10
			db	9, 9, "db", 9, 34
			db	"len:", 9, "equ $ - quine", 34, 10, 10
			db	9, 9, "db", 9, 34
			db	"section .text", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "global _start", 34, 10, 10
			db	9, 9, "db", 9, 34
			db	"_start:", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "mov rax, 2", 9, 9, "; open", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "mov rdi, filename", 9, "; file", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "mov rsi, 0o1100", 9, "; flags", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "mov rdx, 0o644", 9, 9, "; mode", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "syscall", 34, 10, 10
			db	9, 9, "db", 9, 34
			db	9, "mov rdi, rax", 9, 9, "; fd", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "mov rax, 1", 9, 9, "; write", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "mov rsi, quine", 9, "; buf", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "mov rdx, len", 9, 9, "; count", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "syscall", 34, 10, 10
			db	9, 9, "db", 9, 34
			db	9, "mov rax, 3", 9, 9, "; close", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "syscall", 34, 10, 10
			db	9, 9, "db", 9, 34
			db	9, "mov rax, 60", 9, 9, "; exit", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "mov rdi, 0", 9, 9, 9, "; code", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "syscall", 34, 10, 10
			db	"len:", 9, "equ $ - quine", 10, 10
			db	"section .text", 10
			db	9, "global _start", 10, 10
			db	"_start:", 10
			db	9, "mov rax, 2", 9, 9, "; open syscall", 10
			db	9, "mov rdi, filename", 9, "; filename", 10
			db	9, "mov rsi, 0o1100", 9, "; O_CREAT|O_WRONLY|O_TRUNC", 10
			db	9, "mov rdx, 0o644", 9, 9, "; mode rw-r--r--", 10
			db	9, "syscall", 10, 10
			db	9, "mov rdi, rax", 9, 9, "; fd to rdi", 10
			db	9, "mov rax, 1", 9, 9, "; write syscall", 10
			db	9, "mov rsi, quine", 9, "; buffer", 10
			db	9, "mov rdx, len", 9, 9, "; count", 10
			db	9, "syscall", 10, 10
			db	9, "mov rax, 3", 9, 9, "; close syscall", 10
			db	9, "syscall", 10, 10
			db	9, "mov rax, 60", 9, 9, "; exit syscall", 10
			db	9, "mov rdi, 0", 9, 9, 9, "; exit code 0", 10
			db	9, "syscall", 10

	len:	equ $ - quine

section .text
	global _start

_start:
	mov rax, 2				; open syscall
	mov rdi, filename			; filename
	mov rsi, 0o1100				; O_CREAT|O_WRONLY|O_TRUNC
	mov rdx, 0o644				; mode rw-r--r--
	syscall

	mov rdi, rax				; fd to rdi
	mov rax, 1				; write syscall
	mov rsi, quine				; buffer
	mov rdx, len				; count
	syscall

	mov rax, 3				; close syscall
	syscall

	mov rax, 60				; exit syscall
	mov rdi, 0				; exit code 0
	syscall
