%ifndef BASM_CAST
  %define BASM_CAST

section .text

%include "basm_str.asm"

    itostr:
        ; ecx -> int
        ; edx -> address of buf
        ; eax -> size of buf
        ; TODO



        ret

    uitostr:
        ; ecx -> unsigned int
        ; edx -> address of buf
        ; eax -> size of buf

        push ebp
        mov ebp, esp
        push edx
        sub esp, 12   ; 2^32, 10 digits + \0
        mov BYTE [esp+11], 0x0
        xchg eax, ecx
        mov esi, 0x0a
        mov edi, 0x0b
      .loop:
        dec edi
        xor edx, edx
        div esi
        add dl, 0x30
        mov BYTE [esp+edi], dl
        test eax, eax
        jne .loop
        mov edx, [esp+12]
        mov eax, ecx    ; size of buf
        lea ecx, [esp+edi]
        call strcopy
        add esp, 16
        leave
        ret

    strtoi:
    strtoui:
        xor esi, esi
        xor eax, eax
        xor edx, edx
        mov dl, BYTE [ecx]
        cmp dl, 0x2d    ; -
        jne .read
        inc ecx
        inc esi         ; negative
      .read:
        mov dl, BYTE [ecx]
        inc ecx
        test dl, dl
        jz .end
        imul eax, 10
        sub dl, 0x30
        add eax, edx
        jmp .read
      .end:
        test esi, esi
        jz .positive
        imul eax, -1
      .positive:
        ret
  
%endif

