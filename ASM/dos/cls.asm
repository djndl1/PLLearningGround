;;  MASM
.model small, c

include util.inc

.stack  1024

.data
    org 10 ;  reserved for NULL

.code
    ;; this directive sets up segment registers
.startup
    ;;  the system ar jumps to main
clear_screen    proto    near

main    proc    far

    invoke  clear_screen
    mov al, 0

main    endp
.exit                           ;  calling exit

clear_screen    proc    near

    mov     ax, 0600h
    mov     bh, 07h
    mov     cx, 0000h
    mov     dx, 174Fh
    int     10h

    ret
clear_screen    endp

end
