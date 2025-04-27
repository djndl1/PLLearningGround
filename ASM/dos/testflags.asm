;;  MASM
.model  small

.stack  1024

.data

.code
main    proc    far

    mov ax, @DATA
    mov ds, ax

    mov ah, 0D5h
    sahf
    jnc err
    jnz err
    jnp err
    jns err

    lahf
    mov cl, 5
    shr ah, cl                  ; AF
    jnc err

    mov al, 40h
    shl al, 1
    jno err


    jmp     normal
err:
    mov al, 01h
normal:

    mov ah, 4Ch
    int 21H



main    endp

end main
