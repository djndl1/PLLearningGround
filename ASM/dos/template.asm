;;  MASM
.model  small

.stack  1024

.data

.code
main    proc    far

    mov ax, @DATA
    mov ds, ax

;; exit
    mov ah, 4Ch
    int 21H

main    endp

end main
