%ifndef BASM_STR
  %define BASM_STR

section .text

    strcopy:
        ; ecx source
        ; edx destination
        ; eax size (if 0 -> length of source)
        push esi
        push edi
        mov esi, ecx
        mov edi, edx
        test eax, eax
        jnz .copy
        call strlen
        inc eax
      .copy:
        mov ecx, eax
        cld
        rep movsb
        dec eax
        mov BYTE [edi+eax], 0
        pop edi
        pop esi
        ret

    strlen:
        xor eax, eax
      .do:
        mov dl, BYTE [ecx+eax]
        inc eax
        test dl, dl
        jnz .do
        dec eax
        ret
  
%endif
