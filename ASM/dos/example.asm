;;  MASM
.model  small

.stack  1024

.data
data1   db  52h
data2   db  29h
sum     db  ?

.code
main    proc    far

    mov ax, @DATA
    mov ds, ax

    mov al, data1
    mov bl, data2
    add al, bl
    mov sum, al
    mov ah, 4Ch
    int 21H

main    endp

end main
