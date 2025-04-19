;;  MASM
.model  small

.stack  1024

.data
data_in db  25h,4Fh,85h,1Fh,2bh,0C4h
data_out     db  6 dup (?)

.code
main    proc    far

    mov ax, @DATA
    mov ds, ax

    mov cx, 06
    mov si, offset data_in      ; the offset part of address data_in
    mov di, offset data_out

again:
    mov al, [si]
    mov [di], al
    inc si
    inc di

    dec cx
    jnz again

    xor al, al
     ; exit
    mov ah, 4Ch
    int 21H

main    endp

end main
