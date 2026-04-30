; sully.s - x86-64 Assembly Self-Replicating Quine with Counter
; Creates Sully_N.s files with decreasing counter (8 down to 0)
; nasm -f elf64 sully.s -o obj/sully.o && gcc obj/sully.o -o sully

section .data
	counter:	dd	8
	fmt_filename:	db	"Sully_%d.s", 0
	quine_start:	db	"; sully.s - x86-64 Assembly Self-Replicating Quine with Counter", 10
			db	"; Creates Sully_N.s files with decreasing counter (8 down to 0)", 10
			db	"; nasm -f elf64 sully.s -o obj/sully.o && gcc obj/sully.o -o sully", 10, 10
			db	"section .data", 10
			db	9, "counter:", 9, "dd", 9, "8", 10
			db	9, "fmt_filename:", 9, "db", 9, 34
			db	"Sully_%d.s", 34, ", 0", 10
			db	9, "quine_start:", 9, "db", 9, 34
			db	"; sully.s - x86-64 Assembly Self-Replicating Quine with Counter", 34, 10
			db	9, 9, "db", 9, 34
			db	"; Creates Sully_N.s files with decreasing counter (8 down to 0)", 34, 10
			db	9, 9, "db", 9, 34
			db	"; nasm -f elf64 sully.s -o obj/sully.o && gcc obj/sully.o -o sully", 34, 10, 10
			db	9, 9, "db", 9, 34
			db	"section .data", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "counter:", 9, "dd", 9, 34, 34, 10
			db	9, 9, "db", 9, 34
			db	"len_quine:", 9, "equ $ - quine_start", 34, 10, 10
			db	9, 9, "db", 9, 34
			db	"section .text", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "extern sprintf", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "extern fopen", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "extern fprintf", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "extern fclose", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "global main", 34, 10, 10
			db	9, 9, "db", 9, 34
			db	"main:", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "mov eax, [counter]", 9, "; load counter", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "cmp eax, 0", 9, 9, 9, "; check if 0", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "je .exit_zero", 9, 9, 9, "; if yes, exit", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "dec eax", 9, 9, 9, 9, "; counter--", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "mov [counter], eax", 9, "; store decremented", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "push rax", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "lea rdi, [rel filename]", 9, "; sprintf args", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "mov rsi, fmt_filename", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "pop rdx", 9, 9, 9, 9, "; counter value", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "call sprintf", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "lea rdi, [rel filename]", 9, "; fopen file", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "mov rsi, 'w'", 9, 9, 9, "; write mode", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "call fopen", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "mov rdi, rax", 9, 9, 9, "; file pointer", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "lea rsi, [rel quine_start]", 9, "; fprintf", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "mov rdx, len_quine", 9, 9, "; length", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "call fprintf", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "call fclose", 9, 9, 9, "; close file", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "xor eax, eax", 9, 9, 9, "; return 0", 34, 10
			db	9, 9, "db", 9, 34
			db	9, "ret", 34, 10, 10
			db	".exit_zero:", 10
			db	9, "xor eax, eax", 10
			db	9, "ret", 10, 10
			db	"section .bss", 10
			db	9, "filename:", 9, "resb 256", 10

	len_quine:	equ $ - quine_start
	filename:	equ 0

section .text
	extern sprintf
	extern fopen
	extern fprintf
	extern fclose
	global main

main:
	mov eax, [counter]			; load counter
	cmp eax, 0				; check if 0
	je .exit_zero				; if yes, exit
	dec eax					; counter--
	mov [counter], eax			; store decremented
	push rax				; save counter
	lea rdi, [rel filename]			; sprintf args
	mov rsi, fmt_filename			; format string
	pop rdx					; counter value
	call sprintf				; generate filename
	lea rdi, [rel filename]			; fopen file
	mov rsi, 'w'				; write mode
	call fopen				; open file
	mov rdi, rax				; file pointer
	lea rsi, [rel quine_start]		; fprintf args
	mov rdx, len_quine			; length
	call fprintf				; write to file
	call fclose				; close file
	xor eax, eax				; return 0
	ret

.exit_zero:
	xor eax, eax				; return 0
	ret

section .bss
	filename:	resb 256			; buffer for filename
