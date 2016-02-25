%ifndef BASM_STR
  %define BASM_STR

section .text

    strcopy:
        ; Copies a string and \0-terminates it
        ;
        ; ecx -> address of source
        ; edx -> address of destination
        ; eax -> size (if 0 -> length of source)
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
        mov BYTE [edi-1], 0
        ret

    strlen:
        ; Counts chars until \0
        ;
        ; ecx -> address of buffer
        xor eax, eax
      .do:
        mov dl, BYTE [ecx+eax]
        inc eax
        test dl, dl
        jnz .do
        dec eax
        ret
  
%endif
