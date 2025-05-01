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
    lea     ax, [asc]
    push    ax
    lea     ax, [bcd]
    push    ax
    call    _asc2ubcd
    add     sp, 6

    mov     ax, word ptr [bcd]
    push    ax
    call    _packbcd
    add     sp, 2

    push    ax
    push    ax
    call    _addpbcd
    add     sp, 4

    push    ax
    call    _unpackbcd
    add     sp, 2
    mov     word ptr [bcd+10], ax

    mov ah, 4Ch
    int 21H

main    endp

    ;; uint8_t addpbcd(uint8_t a, uint8_t b)
_addpbcd    proc    near
    push    bp
    mov     bp, sp

    mov     al, byte ptr [bp + 4]
    add     al, byte ptr [bp + 6]
    daa

    pop     bp
    ret
_addpbcd    endp

    ;;  uint16_t packbcd(uint8_t src)
_unpackbcd proc     near
    push    bp
    mov     bp, sp

    mov     ah, byte ptr [bp + 4] ; 0x00AB
    mov     al, ah                ; 0xABAB
    and     ax, 0F00Fh             ; 0xA00B
    shr     ah, 4

    pop     bp
    ret
_unpackbcd endp

    ;;  uint8_t packbcd(uint16_t src)
_packbcd proc   near
    push    bp
    mov     bp, sp

    mov     ax, [bp + 4]        ; 0x0A0B
    shl     ah, 4               ; 0xB00A
    or      al, ah              ; 0x00BA
    xor     ah, ah

    pop     bp
    ret
_packbcd endp

    ;;  int16_t asc2ubcd(uint8_t* dst, const uint8_t* src, uint16_t dstlen)
_asc2ubcd proc    near
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

    aaa
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
_asc2ubcd endp

end main
