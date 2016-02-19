%ifndef BASM_CAST
  %define BASM_CAST

section .text

    strtoi:
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

