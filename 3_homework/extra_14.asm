;Zwei Folgen(vonBytes) A und B werden angegeben. 
;Erstelle die Folge R, indem man die Elemente von B in umgekehrter Reihenfolge und die geraden Elemente von A 
;verketten werden.

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
    A db 2,1,3,3,4,2,6
    l_a EQU $ - A
    B db 4,5,7
    l_b EQU $ - B
    laste_b EQU B + l_b - 1
    R RESB l_a + l_b
    
; our code starts here
segment code use32 class=code
    start:
        ; ...
        ;TEIL 1: wir fügen B umgekehrt in R ein
        mov esi, laste_b ;die Adresse des letzten elementes -> esi
        mov edi, R
        mov ecx, l_b
        JECXZ teil1ende
        anfang:
        STD
        LODSB
        CLD
        STOSB
        Loop anfang
        teil1ende:
        
        ;Teil 2: wir fügen bei A nur die geraden Elemente in R ein
        mov esi, A
        mov ecx, l_a
        mov bl, 2
        CLD
        JECXZ teil2ende
        anfang2:
        LODSB
        mov EDX, ESI
        mov ah, 0
        div bl
        CMP ah, 1
        JE nichtgerade
        Mul bl
        STOSB
        nichtgerade:
        Loop anfang2
        teil2ende:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program