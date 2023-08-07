;Task:
;Gegeben ist eine Folge(vonBytes)S der Länge l. Erstelle eine 
;Folge D der Länge l-1 nach folgen der Regel: D(i)=S(i)*S(i+1)
;(jedes Element von D ist das Produkt zweier 
;aufeinanderfolgender Elemente von S).

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
    F db 1,2,3,4
    index EQU $ - F - 1
    E RESW 3
    
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov ecx, index
        mov esi, F
        mov edi, E
        
        JECXZ ende
        anfang:
        LODSB
        mov bl, al
        LODSB
        sub esi, 1
        mul bl
        STOSW
        LOOP anfang
        ende:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
