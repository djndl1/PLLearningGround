seg_addr        equ 2
offset_addr     equ 0

ld_w     macro   dst, addr
    mov     dst, word ptr [addr]
endm

st_w    macro   addr, src
    mov     word ptr [addr], src
endm

st_dw    macro   addr, lo, hi
    mov     word ptr [addr], lo
    mov     word ptr [addr+2], hi
endm


ldarr_w   macro   dst,base,idx
    local   pos
    pos =   idx * 2
    ld_w     dst, base + pos
endm

ldst_w     macro  dst, idx
    local   pos
    pos = 2 + idx * 2
    mov     dst, word ptr [bp-pos]
endm

ldparam_w  macro dst,idx
    ldarr_w  dst, <bp>, %(idx+2)
endm
