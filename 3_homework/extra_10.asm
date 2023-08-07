;Task:
;Zwei Zeichenfolgen S1 und S2 werden angegeben. Erstelle die Zeichenfolge D, indem man die Elemente von S2 in 
;umgekehrter Reihenfolge und die Elemente von S, die sich an geraden Positionen befinden, verketten werden.

bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    
    S1 DB 1,2,3,4
    l_s1 EQU $ - S1
    lastpos_s1 EQU $-1
    
    S2 DB 1,2,3,4
    l_s2 EQU $ - S2
    E:
    ;Ergebnis soll sein 4,3,2,1,2,4
; our code starts here
segment code use32 class=code
    start:
        ; ...Teil1: S1 umgekehrt in E
        mov esi, lastpos_s1
        mov edi, E
        mov ecx, l_s1

        JECXZ endet1
        anfangt1:
        STD
        LODSB
        CLD
        STOSB
        Loop anfangt1
        endet1:
        
        ;Teil2
        mov esi, S2
        mov ecx, l_s2

        JECXZ endet2
        CLD
        anfangt2:
        mov eax, ecx
        clc
        shr eax, 1
        JC ungerade
        LODSB
        STOSB
        JMP then
        ungerade:
        inc esi
        then:
        LOOP anfangt2
        endet2:
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
