;;  MASM
.model  small, c

.stack  1024

.data

nums    dw  2300,4300,1200,3700,1298,4323,5673,986
sums    dw  0

.code

;;;  int16_t sum(int16_t const *nums, uint16_t len)

_sum proto   near, pnums:word, len:word

.startup
main    proc    far
    ;; parameter passing code is generated
    lea     ax, [nums]
    invoke    _sum, ax, 8
    ;; stack cleanup is generated
    mov     word ptr [sums], ax
main    endp
.exit

    ;; prolog and epilog are generated
_sum proc    near, pnums:word, len:word
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
_sum endp

end
