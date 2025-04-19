;;  MASM
.model  small

.stack  1024

.data
NIBCNT  EQU 4
qword1  dq  548FB9963CE7h
qword2  dq  3FCD4FA23B8Dh
sum     dq  ?

.code
main    proc    far

    mov ax, @DATA
    mov ds, ax

    mov si, offset qword1
    mov di, offset qword2
    mov bx, offset sum
    mov cx, NIBCNT

    clc                 ;clear before adding the first nibble
add_word:
    mov ax, [si]
    adc ax, [di]

    mov [bx], ax

 ;;    inc does not affect the carry flag
    inc si
    inc si
    inc di
    inc di
    inc bx
    inc bx

    ;; x86 has builtin for-loop helper instruction
    loop add_word

    ;; exit
    mov ah, 4Ch
    int 21H

main    endp

end main
