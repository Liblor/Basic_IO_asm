stdin       equ   0
stdout      equ   1
stderr      equ   2
sys_exit    equ   1
sys_read    equ   3
sys_write   equ   4 

%ifndef BASM_IO
  %define BASM_IO

%include "basm_cast.asm"
section .bss
    dummy resb 1
section .text

    print_string:
        ; prints a string to the standard output
        ;
        ; ecx -> address of buffer
        mov edx, -1
      .loop: 
        inc edx
        cmp BYTE [ecx+edx], 0
        jne .loop

        push ebx                    ; callee save
        mov eax, sys_write
        mov ebx, stdout
        int 0x80
        pop ebx
        ret

    print_uint:
        ; prints an unsigned integer to the standard output
        ;
        ; ecx -> unsigned integer
        push ebp
        mov ebp, esp
        push ebx                    ; callee save
        sub esp, 12                 ; 2^32, 10 digits + \0
        mov BYTE [esp+11], 0x0
        mov eax, ecx
        mov ebx, 0x0a
        mov ecx, 0x0b
      .loop:
        dec ecx
        xor edx, edx
        div ebx
        add dl, 0x30
        mov BYTE [esp+ecx], dl
        test eax, eax
        jne .loop
        lea ecx, [esp+ecx]
        call print_string
        add esp, 12
        pop ebx
        leave
        ret

    print_int:
        ; prints an integer to the standard output
        ;
        ; ecx -> signed integer
        test ecx, ecx
        jns .pos
        push ecx
        push 0x2d                   ; ASCII: -
        mov ecx, esp
        call print_string
        add esp, 4                  ; remove 0x2d from stack
        pop ecx
        xor ecx, 0xffffffff
        inc ecx
      .pos:
        call print_uint
        ret

    read_string:
        ; reads a string from the standard input to 'buffer'
        ;
        ; ecx -> address of buffer
        ; edx -> size of buffer
        push ebx
        mov eax, sys_read
        mov ebx, stdin
        int 0x80
        cmp eax, edx                ; compares the size of input with the size of the buffer
        jl  .lower
        cmp BYTE [ecx + edx - 1], 0x0a  ; EOL
        mov BYTE [ecx + edx - 1], 0x00
        je .null_terminated
        push eax
        call clear_stdin
        pop eax
        jmp .null_terminated
      .lower:
        mov BYTE [ecx+eax-1], 0x00  ; \n => \0
      .null_terminated:
        pop ebx
        ret

    read_int:
    read_uint:
        ; reads an integer from the standard input and returns it
        push ebp
        mov ebp, esp

        sub esp, 12                 ; 2^32, 10 digits + \0
        mov ecx, esp
        mov edx, 12
        call read_string
        call strtoi

        leave
        ret

    clear_stdin:
        ; reads from stdin until \n
        mov eax, sys_read
        mov ebx, stdin
        mov ecx, dummy
        mov edx, 1
        int 0x80
        cmp BYTE [ecx], 0xa
        jne clear_stdin
        ret
%endif
