;
; nasm -f elf32 primes.asm && ld -melf_i386 primes.o
;

section	.data
    welcome db "Primes", 0xa, 0
    line db "====================", 0xa, 0
    question db "Find primes up to: ", 0
    sep db ", ", 0
    nl db 0x0a, 0

section .bss
	limit resd 1
	factor resd 1


section .text
global _start

%include "../basm_io.asm"

new_line:
    mov ecx, nl
    call print_string
    ret

separator:
	mov ecx, sep
	call print_string
	ret

_start:
	mov ecx, welcome
	call print_string
	mov ecx, line
	call print_string

	mov ecx, question
	call print_string

	call read_uint
	mov DWORD [limit], eax

	cmp DWORD [limit], 2
	jb exit

	mov ecx, 2
	call print_uint

	cmp DWORD [limit], 3
	jb exit

	call separator
	mov ecx, 3
	call print_uint

	mov ebx, 3				; for (ebx = 3; ebx < limit; ebx += 2)
loop:						;
	add ebx, 2
	mov DWORD [factor], 3		; for (factor = 3; factor^2 < ebx, factor += 2)
	inner_loop:
		mov eax, ebx
		cdq
		div DWORD [factor]
		add DWORD [factor], 2
		cmp ebx, [limit]
		jae exit				; exit, if ebx >= limit
		test edx, edx
		jz loop					; break and continue, if ebx has a factor
		mov eax, DWORD [factor]
		imul eax, DWORD [factor]	; eax = factor*factor
		cmp eax, ebx
		jb inner_loop
	call separator
	mov ecx, ebx
	call print_uint

	cmp ebx, [limit]
	jb loop
	

exit:				; SYSCALL: exit(0)
    mov eax, 1
    mov ebx, 0
    int 0x80
