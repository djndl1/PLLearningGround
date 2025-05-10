;;  MASM
.model small, c

include util.inc

.stack  1024

.data
    org 10 ;  reserved for NULL

vec2    dq  15.3, 55.2, 123.0
norm    dq  ?

not_squared  dq  10.0
squared    dq  ?

poly_coeff  dq  12.34, 5.0, 2.0
poly_len    dw  3
poly_x      dq  1.25
poly_y      dq  ?


.code
vecnorm    proto    near, pvec:word, len:word
power      proto    near, x:qword, n:word
polynom    proto    near, pcoeff:word, len:word, x:qword

    ;; this directive sets up segment registers
.startup
    ;;  the system ar jumps to main
main    proc    far

    invoke  vecnorm, offset vec2, 03h
    fstp    qword ptr [norm]

    invoke  power, qword ptr [not_squared], 05h
    fstp    qword ptr [squared]

    invoke  polynom, offset poly_coeff, word ptr [poly_len], qword ptr [poly_x]
    fstp    qword ptr [poly_y]

    mov al, 0
main    endp
.exit                           ;  calling exit

power       proc    near, x:qword, n:word
    finit
    fld     qword ptr [bp+4]
    fld1
    mov     cx, word ptr [bp+12]
begin_mul:
    test    cx, cx
    jz      end_mul

    fmul    st(0), st(1)

    dec     cx
    jmp     begin_mul
end_mul:
    fstp    st(1)

    ret
power       endp

POLY_PARM_PCOEFF    textequ     <word ptr [bp+4]>
POLY_PARM_LEN       textequ     <word ptr [bp+6]>
POLY_PARM_X         textequ     <qword ptr [bp+8]>
polynom     proc    near, pcoeff:word, len:word, x:qword
    push    si

    mov     si, POLY_PARM_PCOEFF
    mov     cx, POLY_PARM_LEN

    finit
    fldz
    test    cx, cx
    jz      end_sum
    fadd    qword ptr [si]
    add     si, 8
    dec     cx
    ;; st0 -> sum

    fld     POLY_PARM_X
    fld1
    ;; st0 -> 1, st1 -> x, st2 -> sum
begin_sum:
    test    cx, cx
    jz      end_sum

    ;; st0 -> x^k, st1 -> x, st2 -> sum
    fmul    st(0), st(1)        ; x^k * x

    fld     st(0)
    fmul    qword ptr [si]  ; x^(k+1) * coeff
    ;; st0 -> term, st1 -> x^(k+1), st2 -> x, st3 -> sum
    faddp   st(3), st(0)
    ;; st1 -> x^(k+1), st1 -> x, st2 -> sum

    add     si, 8
    dec     cx
    jmp     begin_sum
end_sum:
    fstp    st(0)
    fstp    st(0)

    pop     si

    ret
polynom     endp

vecnorm    proc    near, pvec:word, len:word
    push    si

    mov     si, word ptr [bp+4]
    mov     cx, word ptr [bp+6]
    finit
    fldz
begin_sum:
    test    cx, cx
    jz      end_sum

    fld     qword ptr [si]
    fmul    st(0), st(0)
    faddp   st(1), st(0)

    add     si, 8
    dec     cx
    jmp     begin_sum
end_sum:
    fsqrt

    pop     si

    ret
vecnorm    endp

end
