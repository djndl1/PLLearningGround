;;  MASM
.model  small

.stack  1024

.data
    grades  db 69, 87, 96, 45, 75
    org     08
    maxsum  db  ?

.code
main    proc    far

    mov ax, @DATA
    mov ds, ax

    mov si, offset [grades]
    mov al, byte ptr [si]
    mov cx, 5
compare:
    mov bl, byte ptr [si]
    cmp al, bl
    ja  cont_search
    mov al, bl
cont_search:
    inc si
    loop    compare
    mov [maxsum], al

;; exit
    mov ah, 4Ch
    int 21H

main    endp

end main
