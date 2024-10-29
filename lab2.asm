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

count1 db 80 dup (0)
count2 db 80 dup (0)

.code
_count PROC C str1:DWORD, len:DWORD, count:DWORD
    entr    
    mov ecx, len
    mov edi, str1
    mov esi, count
_count_loop:
    mov edx, 0
    mov dl, [edi + ecx - 1]
    inc BYTE PTR [esi + edx]
    loop _count_loop
    gtfo
_count ENDP

_levy PROC C str1:DWORD, str2:DWORD ; transcribed from MAtH on wikipedia
    entr
    mov esi, str1
    mov edi, str2

    push OFFSET count1
    mov ecx, [string1_len]
    push ecx
    push OFFSET string1
    call _count

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
