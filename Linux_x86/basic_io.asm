%ifndef BASIC_IO
  %define BASIC_IO
    print_string:
        xor edx, edx
      .loop: 
        inc edx
        cmp BYTE [eax+edx], 0
        jne .loop

        mov ecx, eax
        mov eax, 4
        push ebx    ; callee save
        mov ebx, 1
        int 0x80
        pop ebx
        ret

    print_uint:
        push ebp
        mov ebp, esp
        sub esp, 12   ; 2^32, 10 digits + \0
        push ebx      ; callee save
        mov BYTE [esp+15], 0x0
        mov ebx, 0x0a
        mov ecx, 0xf
      .loop:
        dec ecx
        xor edx, edx
        div ebx
        add dl, 0x30
        mov BYTE [esp+ecx], dl
        test eax, eax
        jne .loop
        lea eax, [esp+ecx]
        call print_string
        add esp, 12
        pop ebx
        leave
        ret

    print_int:
        test eax, eax
        jns .pos
        push eax
        push 0x2D       ; ASCII: -
        lea eax, [esp]
        call print_string
        add esp, 4      ; remove 0x2D from stack
        pop eax
        xor eax, 0xffffffff
        inc eax
      .pos:
        call print_uint
        ret
%endif
