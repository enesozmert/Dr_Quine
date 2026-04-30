; colleen.s - x86-64 Assembly Quine
; Self-replicating program that outputs its own source code to stdout
; nasm -f elf64 colleen.s -o obj/colleen.o && ld obj/colleen.o -o colleen

section .data
	quine:	db	"; colleen.s - x86-64 Assembly Quine", 10
		db	"; Self-replicating program that outputs its own source code to stdout", 10
		db	"; nasm -f elf64 colleen.s -o obj/colleen.o && ld obj/colleen.o -o colleen", 10, 10
		db	"section .data", 10
		db	9, "quine:", 9, "db", 9, 34
		db	"; colleen.s - x86-64 Assembly Quine", 34, 10
		db	9, 9, "db", 9, 34
		db	"; Self-replicating program that outputs its own source code to stdout", 34, 10
		db	9, 9, "db", 9, 34
		db	"; nasm -f elf64 colleen.s -o obj/colleen.o && ld obj/colleen.o -o colleen", 34, 10, 10
		db	9, 9, "db", 9, 34
		db	"section .data", 34, 10
		db	9, 9, "db", 9, 34
		db	9, "quine:", 9, "db", 9, 34, 34, 10
		db	9, 9, "db", 9, 34
		db	9, 9, "db", 9, 34, 34, 10
		db	9, 9, "db", 9, 34
		db	"len:", 9, "equ $ - quine", 34, 10, 10
		db	9, 9, "db", 9, 34
		db	"section .text", 34, 10
		db	9, 9, "db", 9, 34
		db	9, "global _start", 34, 10, 10
		db	9, 9, "db", 9, 34
		db	"_start:", 34, 10
		db	9, 9, "db", 9, 34
		db	9, "mov rax, 1", 9, 9, "; write syscall", 34, 10
		db	9, 9, "db", 9, 34
		db	9, "mov rdi, 1", 9, 9, "; stdout", 34, 10
		db	9, 9, "db", 9, 34
		db	9, "mov rsi, quine", 9, "; buffer", 34, 10
		db	9, 9, "db", 9, 34
		db	9, "mov rdx, len", 9, 9, "; count", 34, 10
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
		db	9, "mov rax, 1", 9, 9, "; write syscall", 10
		db	9, "mov rdi, 1", 9, 9, "; stdout", 10
		db	9, "mov rsi, quine", 9, "; buffer", 10
		db	9, "mov rdx, len", 9, 9, "; count", 10
		db	9, "syscall", 10, 10
		db	9, "mov rax, 60", 9, 9, "; exit", 10
		db	9, "mov rdi, 0", 9, 9, 9, "; code", 10
		db	9, "syscall", 10

	len:	equ $ - quine

section .text
	global _start

_start:
	mov rax, 1			; write syscall
	mov rdi, 1			; stdout
	mov rsi, quine			; buffer
	mov rdx, len			; count
	syscall

	mov rax, 60			; exit
	mov rdi, 0			; code
	syscall
