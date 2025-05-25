;;  MAS
.model small, c

include util.inc

.stack  1024

.data
    org 10 ;  reserved for NULL

strsrc db  'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 0
strdst db  27 DUP(?)

strsub  db  'AFDGHKJFEDDJFSDfJ',0

.code
    ;; this directive sets up segment registers
strncpy proto   near    dst:dword, src:dword, len:word
replace_char    proto    near    s:dword, len:word, match:byte, replacement:byte

.startup
    ;;  the system ar jumps to main
main    proc    far

    push    27
    mov     ax, seg strsrc
    push    ax
    mov     ax, offset strsrc
    push    ax
    mov     ax, seg strdst
    push    ax
    mov     ax, offset strdst
    push    ax

    call    strncpy

    add     sp, 10

    mov     al, 'J'
    mov     ah, 'G'
    push    ax
    push    18
    mov     ax, seg strsub
    push    ax
    mov     ax, offset strsub
    push    ax

    call    replace_char

    add     sp, 10

    mov al, 0
main    endp
.exit                           ;  calling exit

strncpy proc   near    dst:dword, src:dword, len:word
    push    si
    push    di
    push    ds

    ldparam_w   di, 0
    ldparam_w   ax, 1
    mov         es, ax
    ldparam_w   si, 2
    ldparam_w   ax, 3
    mov         ds, ax
    ldparam_w   cx, 4

    rep         movsb

    pop         ds
    pop         di
    pop         si

    ret
strncpy endp

replace_char    proc    near    s:dword, len:word, match:byte, replacement:byte
    push        ds

    ldparam_w   di, 0
    ldparam_w   ax, 1
    mov         ds, ax
    ldparam_w   cx, 2
    ldparam_w   ax, 3
begin_search:
    test        cx, cx
    jz          end_search

    repne       scasb
    jne         end_search

    dec         di
    mov         byte ptr [di], ah
    inc         di

    jmp         begin_search
end_search:

    pop         ds
    ret
replace_char    endp

end
