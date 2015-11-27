stdin       equ   0
stdout      equ   1
stderr      equ   2
sys_exit    equ   1
sys_read    equ   3
sys_write   equ   4 

%ifndef BASIC_IO
  %define BASIC_IO
section .bss
    dummy resb 1
section .text
    print_string:
        mov edx, -1
      .loop: 
        inc edx
        cmp BYTE [ecx+edx], 0
        jne .loop

        push ebx    ; callee save
        mov eax, sys_write
        mov ebx, stdout
        int 0x80
        pop ebx
        ret

    print_uint:
        push ebp
        mov ebp, esp
        sub esp, 12   ; 2^32, 10 digits + \0
        push ebx      ; callee save
        mov BYTE [esp+15], 0x0
        mov eax, ecx
        mov ebx, 0x0a
        mov ecx, 0x0f
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
        test ecx, ecx
        jns .pos
        push ecx
        push 0x2D       ; ASCII: -
        lea ecx, [esp]
        call print_string
        add esp, 4      ; remove 0x2D from stack
        pop ecx
        xor ecx, 0xffffffff
        inc ecx
      .pos:
        call print_uint
        ret

    read_string:
        push ebx
        mov eax, sys_read
        mov ebx, stdin
        int 0x80
        cmp eax, edx      ; compares len written with size of buffer
        jl  .lower
        cmp BYTE [ecx + edx - 1], 0x0a  ; EOL
        mov BYTE [ecx + edx - 1], 0x00
        je .null_terminated
        call clear_stdin
        jmp .null_terminated
      .lower:
        mov BYTE [ecx+eax-1], 0x00    ; \n => \0
      .null_terminated:
        pop ebx
        ret

    clear_stdin:
        mov eax, sys_read
        mov ebx, stdin
        mov ecx, dummy
        mov edx, 1
        int 0x80
        cmp BYTE [ecx], 0xa
        jne clear_stdin
        ret
%endif
