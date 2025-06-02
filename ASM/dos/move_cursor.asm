;;  MASM
.model small, c

include util.inc

.stack  1024

.data
    org 10 ;  reserved for NULL

.code
    ;; this directive sets up segment registers
move_cursor     proto    near, row:byte, col:byte
.startup
    ;;  the system ar jumps to main
main    proc    far

    mov     al, 1
    mov     ah, 40
    push    ax
    call    move_cursor
    add     sp, 2

    call    get_cursor

    add     al, 5
    add     ah, 1
    push    ax
    call    move_cursor
    add     sp, 2

    mov al, 0

main    endp
.exit                           ;  calling exit

get_cursor      proc    near
    push        bp
    mov         bp, sp

    mov         ah, 03
    mov         bh, 00
    int         10h
    mov         ax, dx

    pop         bp
    ret
get_cursor      endp

move_cursor     proc    near, row:byte, col:byte
    mov         ah, 02
    mov         bh, 00
    mov         dh, byte ptr [bp+4]
    mov         dl, byte ptr [bp+5]
    int         10h

    ret
move_cursor     endp
end
