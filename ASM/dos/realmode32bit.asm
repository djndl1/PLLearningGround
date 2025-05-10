;;  MASM
.model small,c
.386

.stack  1024

.data
    org 10 ;  reserved for NULL

longa   dq  123456789h
longb   dq  987654321h
longsum dq  ?

.code
    ;; this directive sets up segment registers
add64bit    proto    near, a:qword, b:qword
.startup
    ;;  the system ar jumps to main
main    proc    far

    invoke  add64bit, qword ptr [longa], qword ptr [longb]
    mov     dword ptr [longsum], eax
    mov     dword ptr [longsum+4], edx

    mov     al, 0

main    endp
.exit                           ;  calling exit

add64bit    proc    near, a:qword, b:qword
    clc
    mov     eax, [bp+4]
    add     eax, [bp+12]
    mov     edx, [bp+8]
    adc     edx, [bp+16]

    ret
add64bit    endp

end
