;;  MASM
.model  small

.stack  1024

.data
    data1   dd  062562FAh
    data2   dd  0412963Bh
    result   dd  ?

.code
main    proc    far

    mov ax, @DATA
    mov ds, ax

    push    word ptr [data2+2]
    push    word ptr [data2]
    push    word ptr [data1+2]
    push    word ptr [data1]
    call    _dwordsub
    add     sp, 8
    mov     word ptr [result], ax
    mov     word ptr [result+2], dx

;; exit
    mov ah, 4Ch
    int 21H

main    endp

    ;; int32_t dwordsub(int32_t a, int32_t b)
_dwordsub    proc    near
    push    bp
    mov     bp, sp

    mov     ax, word ptr [bp+4]
    mov     dx, word ptr [bp+6]
    clc
    sub     ax, word ptr [bp+8]
    sbb     dx, word ptr [bp+10]

    pop     bp
    ret
_dwordsub   endp

end main
