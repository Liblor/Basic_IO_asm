%ifndef BASM_CAST
  %define BASM_CAST

section .text

%include "basm_str.asm"

    itostr:
        ; Converts an integer to a string
        ; if the buffer is to small not the whole number is written
        ;
        ; ecx -> int
        ; edx -> address of buffer
        ; eax -> size of buffer
        test ecx, ecx               ; goto .pos if ecx >= 0
        jns .pos                    ;
        mov BYTE [edx], 0x2d        ; if the number is negative, a '-' is put
        inc edx                     ; at the beginning of the buffer. Then the
        dec eax                     ; number is made positive so that uitostr
        xor ecx, 0xffffffff         ; can be used.
        inc ecx
      .pos:
        call uitostr

        ret

    uitostr:
        ; Converts an unsigned integer to a string.
        ; if the buffer is to small not the whole number is written
        ;
        ; ecx -> unsigned int
        ; edx -> address of buffer
        ; eax -> size of buffer

        push ebp
        mov ebp, esp
        push edx                    ; save address of buffer for later
        sub esp, 12                 ; 2^32-1 has 10 digits + \0
        mov BYTE [esp+11], 0x0      ; Null terminate string
        xchg eax, ecx               ; eax must store the number, because of the
                                    ; division 
        mov esi, 0x0a               ; divisor
        mov edi, 0x0b               ; [esp+edi] -> last byte of string
      .loop:
        dec edi
        xor edx, edx                ; clear edx for division
        div esi                     ; get last decimal digit -> edx
        add dl, 0x30                ; numbers 0-9 +0x30 give the ASCII value
        mov BYTE [esp+edi], dl      ; store ASCII value
        test eax, eax               ; 
        jne .loop
        mov edx, [esp+12]           ; prepare for strcopy call
        mov eax, ecx                ; size of buf
        lea ecx, [esp+edi]
        call strcopy
        add esp, 16
        leave
        ret

    strtoi:
    strtoui:
        ; Converts a string to an integer
        ;
        ; ecx -> address of buffer
        xor esi, esi                ; bool flag
        xor eax, eax                ; (u)int number
        xor edx, edx                ; char temp
        mov dl, BYTE [ecx]          ; if buffer starts with '-'
        cmp dl, 0x2d
        jne .read
        inc ecx
        inc esi                     ; set esi -> negative number
      .read:
        mov dl, BYTE [ecx]          ; read first byte
        inc ecx
        test dl, dl                 ; if the char is \0, stop reading
        jz .end
        imul eax, 10
        sub dl, 0x30                ; ASCII to integer
        add eax, edx
        jmp .read
      .end:
        test esi, esi
        jz .positive
        imul eax, -1
      .positive:
        ret
  
%endif

