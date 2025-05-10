;;  MASM
.model  small, c

.stack  1024

.data

nums    dw  2300,4300,1200,3700,1298,4323,5673,986
sums    dw  0

fnums   dd  1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.1
fsums   dd  0.0

area    dq  0.0
fintsum dd  ?

.code

;;;  int16_t sum(int16_t const *nums, uint16_t len)

sum proto   near, pnums:word, len:word
fsum proto  near, pnums:word, len:word
circle_area proto near, diameter:qword
x87_int_sum proto near, a:dword, b:dword

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

    invoke  circle_area, 10.0
    fstp    qword ptr [area]

    invoke  x87_int_sum, 00000010h, 00000020h
    fistp    dword ptr [fintsum]

main    endp
.exit

x87_int_sum proc near, a:dword, b:dword
    finit
    fild     dword ptr [bp+4]
    fiadd   dword ptr [bp+8]

    ret
x87_int_sum endp

circle_area proc near, diameter:qword
    finit
    fld     qword ptr [bp+4]
    fmul    st(0), st(0)
    fldpi
    fmulp    st(1), st(0)

    ret
circle_area endp

fsum proc  near, pnums:word, len:word
    push    si

    mov     cx, word ptr [bp+6]
    mov     si, word ptr [bp+4]

    finit
    fldz
begin_add:
    fadd    dword ptr [si]
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
