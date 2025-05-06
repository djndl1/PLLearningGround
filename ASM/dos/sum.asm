;;  MASM
.model  small, c

.stack  1024

.data

nums    dw  2300,4300,1200,3700,1298,4323,5673,986
sums    dw  0

fnums   dd  1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.1
fsums   dd  0.0

.code

;;;  int16_t sum(int16_t const *nums, uint16_t len)

sum proto   near, pnums:word, len:word
fsum proto  near, pnums:word, len:word

.startup
main    proc    far
    ;; parameter passing code is generated
    lea     ax, [nums]
    invoke    sum, ax, 8
    ;; stack cleanup is generated
    mov     word ptr [sums], ax

    mov     ax, offset fnums
    invoke  fsum, ax, 8
    fstp    dword ptr [fsums]
main    endp
.exit

fsum proc  near, pnums:word, len:word
    push    si

    mov     cx, word ptr [bp+6]
    mov     si, word ptr [bp+4]

    finit
    fldz
begin_add:
    fadd   dword ptr [si]
    add     si, 4
    loop    begin_add
end_add:

    pop     si
    ;; pop bp is generated automatically
    ret
fsum endp

    ;; prolog and epilog are generated
sum proc    near, pnums:word, len:word
    push    si

    mov     cx, word ptr [bp+6]
    mov     si, word ptr [bp+4]
    xor     ax, ax
begin_add:
    add     ax, word ptr [si]
    add     si, 2
    loop    begin_add
end_add:

    pop     si

    ;; pop bp is generated automatically
    ret
sum endp

end
