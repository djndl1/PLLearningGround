;;  MASM
.model  small

.stack  1024

.data
data_in db  25h,12h,15h,1Fh,2Bh
sum     db  ?

.code
main    proc    far

    mov ax, @DATA
    mov ds, ax

    mov cx, 05
    mov bx, offset data_in      ; the offset part of address data_in
    mov al, 0

again:
    add al, [bx]
    inc bx
    dec cx
    jnz again

    mov sum, al

     ; exit
    mov ah, 4Ch
    int 21H

main    endp

end main
