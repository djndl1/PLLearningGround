.intel_syntax noprefix

.section .data
arg_error:  .string  "No enough argument!\n"
result_fmt:  .string  "The reversed string is %s!\n"
.section .text

.global main
.global printf
.global strlen

// void reverse_string(char *s)
reverse_string:
    push    rbp
    mov     rbp, rsp

    sub     rsp, 32
    mov     [rsp + 8], rbx
    mov     [rsp + 24], rdi // s

    call    strlen
    mov     [rsp + 16], rax // len

    mov     rsi, rdi
    add     rsi, rax // s + len
    dec     rsi

.meeting:
    cmp     rdi, rsi
    jae     .end_reverse

    mov     al, byte ptr [rdi]
    mov     bl, byte ptr [rsi]

    mov     byte ptr [rsi], al
    mov     byte ptr [rdi], bl

    inc     rdi
    dec     rsi

    jmp     .meeting
.end_reverse:
    mov     rbx, [rsp + 8]
    add     rsp, 32

    pop     rbp
    ret

// int main(int argc, char *argv[])
main:
    push    rbp
    mov     rbp, rsp

    sub     rsp, 16
    mov     dword ptr [rsp], edi // argc
    mov     qword ptr [rsp + 8], rsi       // argv

    mov     eax, edi
    cmp     eax, 1
    jle     arg_error_handler
arg_correct:
    mov     rdi, [rsp + 8] // argv
    mov     rdi, [rdi + 8] // *(argv + 1)

    mov     rbx, rdi
    call    reverse_string
    mov     rdi, rbx

    mov     rsi, rdi
    lea     rdi, [rip + result_fmt]
    xor     al, al
    call    printf

    jmp ret_main
arg_error_handler:
    lea rdi, [rip + arg_error]
    xor al, al
    call printf
ret_main:
    xor al, al

    add rsp, 16
    pop rbp
    ret
