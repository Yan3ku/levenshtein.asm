.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC
extern __read : PROC
extern _strlen : PROC
public _main

entr MACRO ; entr (not enter) and save registers
    push ebx
    push edi
    push esi
ENDM

gtfo MACRO ; replacement for ret that restore regs
    pop esi
    pop edi
    pop ebx
    ret
ENDM

min MACRO a, b
    cmp a, b
    cmova a, b ; a > b then a = b
ENDM

.data
string1 db 80 dup (?)
string1_len dd ?
string2 db 80 dup (?)
string2_len dd ?

.code
_levy PROC C str1:DWORD, str2:DWORD ; transcribed from MAtH on wikipedia
    entr
    mov esi, str1
    mov edi, str2

    ; if |a| = 0 ret |b|
    mov dl, [esi]
    test dl, dl
    jnz @f

    push edi
    call _strlen
    add esp, 4
    gtfo
@@: ; if |b| = 0 ret |a|
    mov dl, [edi]
    test dl, dl
    jnz @f

    push esi
    call _strlen
    add esp, 4
    gtfo
@@: ; head(a) = head(b)
    cmp dl, [esi]
    jnz @f

    add esi, 1
    add edi, 1
    push edi
    push esi
    call _levy
    add esp, 8
    gtfo
@@: ; call this shit 3 times like the holy scripture says and pray
    lea ecx, [esi+1]
    push edi
    push ecx
    call _levy
    add esp, 8
    mov ebx, eax

    lea ecx, [edi+1]
    push ecx
    push esi
    call _levy
    add esp, 8
    mov edx, eax

    add esi, 1
    add edi, 1
    push edx
    push edi
    push esi
    call _levy
    add esp, 8
    pop edx

    ; find min and gtfo
    min eax, ebx
    min eax, edx

    add eax, 1
    gtfo
_levy ENDP


_main PROC
    push 80
    push OFFSET string1
    push 0
    call __read
    add esp, 12
    mov string1[eax], 0
    mov string1_len, eax

    push 80
    push OFFSET string2
    push 0
    call __read
    add esp, 12
    mov string2[eax], 0
    mov string2_len, eax

    push OFFSET string2
    push OFFSET string1
    call _levy
    add esp, 8

    push eax
    call _ExitProcess@4
_main ENDP
END
