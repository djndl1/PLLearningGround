;;  MASM
.model small, c

include util.inc

.stack  1024

.data
    org 10 ;  reserved for NULL

vec2    real8  15.3, 55.2, 123.0
norm    real8  ?                ; 135.6839342000371

not_squared  real8  10.0
squared    real8  ?             ; 10^5

poly_coeff  real8  12.34, 5.0, 2.0
poly_len    word  3
poly_x      real8  1.25
poly_y      real8  ?            ; 21.715

quadr_a     real8   2.0
quadr_b     real8   -7.0
quadr_c     real8   3.0
quadr_pos   real8   ?           ; 3
quadr_neg   real8   ?           ; 0.5


.code
vecnorm    proto    near, pvec:word, len:word
power      proto    near, x:real8, n:word
polynom    proto    near, pcoeff:word, len:word, x:real8
solve_quadratic proto    near, a:real8, b:real8, cc:real8, posx:word, negx:word

    ;; this directive sets up segment registers
.startup
    ;;  the system ar jumps to main
main    proc    far

    invoke  vecnorm, offset vec2, 03h
    fstp    real8 ptr [norm]

    invoke  power, real8 ptr [not_squared], 05h
    fstp    real8 ptr [squared]

    invoke  polynom, offset poly_coeff, word ptr [poly_len], real8 ptr [poly_x]
    fstp    real8 ptr [poly_y]

    invoke  solve_quadratic, real8 ptr [quadr_a], real8 ptr [quadr_b], real8 ptr [quadr_c], offset [quadr_pos], offset [quadr_neg]


    mov al, 0
main    endp
.exit                           ;  calling exit

power       proc    near, x:real8, n:word
    finit
    fld     real8 ptr [bp+4]
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

solve_quadratic proc    near, a:real8, b:real8, cc:real8, posx:word, negx:word
    finit

    fld1
    fadd    st, st              ; 2
    fld     st                  ; 2,2
    fmul    real8 ptr [bp+4]    ; 2a,2

    fmul    st(1), st           ; 2a,4a
    fxch                        ; 4a,2a
    fmul    real8 ptr [bp+20]   ; 4ac,2a

    fld     real8 ptr [bp+12]   ; b,4ac,2a
    fmul    st, st              ; b^2,4ac,2a
    fsubr                       ; b^2 - 4ac, 2a

    fsqrt                       ; \sqrt{b^2-4ac}, 2a
;;; TODO error handling

    fld     b                   ; b, \sqrt{b^2-4ac}, 2a
    fchs                        ; -b, \sqrt{b^2-4ac}, 2a
    fxch                        ; \sqrt{b^2-4ac}, -b, 2a

    fld     st                  ; \sqrt{b^2-4ac}, \sqrt{b^2-4ac}, -b, 2a
    fadd    st, st(2)           ; -b + \sqrt{b^2-4ac}, \sqrt{b^2-4ac}, -b, 2a
    fxch                        ; \sqrt{b^2-4ac}, -b + \sqrt{b^2-4ac},  -b, 2a
    fsubp   st(2), st           ; -b + \sqrt{b^2-4ac}, -b - \sqrt{b^2-4ac}, 2a

    fdiv    st, st(2)           ;
    mov     di, word ptr [bp+28]
    fstp    real8 ptr [di]
    fdivr
    mov     di, word ptr [bp+30]
    fstp    real8 ptr [di]

    mov     ax, 1

    ret
solve_quadratic endp

POLY_PARM_PCOEFF    textequ     <word ptr [bp+4]>
POLY_PARM_LEN       textequ     <word ptr [bp+6]>
POLY_PARM_X         textequ     <real8 ptr [bp+8]>
polynom     proc    near, pcoeff:word, len:word, x:real8
    push    si

    mov     si, POLY_PARM_PCOEFF
    mov     cx, POLY_PARM_LEN

    finit
    fldz
    test    cx, cx
    jz      end_sum
    fadd    real8 ptr [si]
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
    fmul    real8 ptr [si]  ; x^(k+1) * coeff
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

    fld     real8 ptr [si]
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
