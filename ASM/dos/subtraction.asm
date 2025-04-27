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

    mov ax, word ptr [data1]
    sub ax, word ptr [data2]

    mov word ptr [result], ax

    mov ax, word ptr [data1 + 2]
    sbb ax, word ptr [data2 + 2]

    mov word ptr [result + 2], ax

;; exit
    mov ah, 4Ch
    int 21H

main    endp

end main
