;;  MASM
.model  small

.stack  1024

.data
unconverted   db  'mY NAME is jOe'
upper         db   14 DUP(?)

.code
main    proc    far

    mov ax, @DATA
    mov ds, ax

    mov si, offset [unconverted]
    mov di, offset [upper]
    mov cx, 14

conv:
    mov al, byte ptr [si]
    cmp al, 61h
    jb next
    cmp al, 7Ah
    ja next
    sub al, 20h
next:
    mov byte ptr [di], al
    inc si
    inc di
    loop  conv

;; exit
    mov ah, 4Ch
    int 21H

main    endp

end main
