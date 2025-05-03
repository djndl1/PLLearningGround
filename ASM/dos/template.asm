;;  MASM
.model small

.stack  1024

.data
    org 10 ;  reserved for NULL

.code
    ;; this directive sets up segment registers
.startup
    ;;  the system ar jumps to main
main    proc    far

    mov al, 0

main    endp
.exit                           ;  calling exit

end
