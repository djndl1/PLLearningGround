;;  MASM
.model  small

.stack  1024

.data

.code
main    proc    far

    mov ax, @DATA
    mov ds, ax

    push    097F4h
    call    _bit1count
    add     sp, 2

;; exit
    mov ah, 4Ch
    int 21H

main    endp

    ;; size_t bit1count(uint16_t w)
_bit1count   proc    near
    push    bp
    mov     bp, sp

    push    bx

    xor     bx, bx
    mov     cx, 16
    mov     ax, word ptr [bp+4]
begin_count:
    ror     ax, 1
    jnc     cont_count
    inc     bx
cont_count:
    loop    begin_count
end_count:
    mov     ax, bx
    pop     bx

    pop     bp
    ret
_bit1count   endp

end main
