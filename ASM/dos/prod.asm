;;  MASM
.model small, c

include util.inc

.stack  1024

.data
    org 10 ;  reserved for NULL
nums    dw      1,2,3,4,5,6,7,8,9,10
product  dd      ?

.code
    ;; this directive sets up segment registers
prod    proto    near, pnums:word, len:word
.startup
    ;;  the system ar jumps to main
main    proc    far

    mov al, 0

    invoke  prod, offset nums, 10
    st_dw   product, ax, dx


main    endp
.exit                           ;  calling exit

prod    proc    near, pnums:word, len:word
    push    si

    ldparam_w     si, 0
    ldparam_w     cx, 1
    mov     ax, 1
begin_prod_while:
    test     cx, cx
    jz      end_prod_while

    mul     word ptr [si]

    add     si, 2
    dec     cx
    jmp     begin_prod_while
end_prod_while:
    pop     si

    ret
prod    endp

end
