%ifndef BASM_STR
  %define BASM_STR

section .text

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
