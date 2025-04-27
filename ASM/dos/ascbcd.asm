;;  MASM
.model  small

.stack  1024

.data
org     0002h                   ; reserved for NULL data pointer
asc     db  '9562481273',0
org     0010h
bcd     db  12 dup(?)

.code
main    proc    far

    mov ax, @DATA
    mov ds, ax

    mov si, offset [asc]

    push    12
    mov     ax, offset [asc]
    push    ax
    mov     ax, offset [bcd]
    push    ax
    call    _asc2bcd
    add     sp, 6

    mov ah, 4Ch
    int 21H

main    endp

    ;;  int16_t asc2bcd(uint8_t* dst, const uint8_t* src, uint16_t dstlen)
_asc2bcd proc    near
    push    bp
    mov     bp, sp

    sub     sp, 4
    mov     word ptr [bp-2], si
    mov     word ptr [bp-4], di

    mov     di, word ptr [bp+4]          ;dst
    mov     si, word ptr [bp+6]          ;src
    mov     cx, word ptr [bp+8]          ;dstlen
guards:
    test    si, si
    jz      bailout
    test    di, di
    jz      bailout
    test    cx, cx
    jz      bailout

conv:
    mov     al, byte ptr [si]
    test    al, al
    jz      end_conv
    test    cx, cx
    jz      end_conv

    and     al, 0Fh
    mov     byte ptr [di], al

    inc     si
    inc     di
    dec     cx

    jmp    conv
end_conv:
    mov     ax, word ptr [bp+6]
    sub     si, ax
    mov     ax, si
    jmp     unwind

bailout:
    mov     ax, 0
unwind:
    pop     di
    pop     si

    pop     bp
    ret
_asc2bcd endp

end main
