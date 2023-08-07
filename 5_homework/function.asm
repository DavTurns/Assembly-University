bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
global maxnum


;importiere folgende variablen
extern n
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    temp resd 1
; our code starts here
segment code use32 class=code
        ; ...
        maxnum:
        
        ;prolog:
        push ebp; aktueller basepointer wird auf den stack gespeichert
        mov ebp, esp; neuer basepointer gesetzt
        sub esp, 0; platz für lokale Variablen, VOLLSTÄNDIGKEITSHALBER
        
        
        mov ecx, dword[ebp+ 16]
        mov esi, dword[ebp+ 12]
        
        mov [temp], esi
        mov edx, 0  ;größte Zahl
        l3:
        lodsd
        cmp edx,0
        JNE endinfstart
        mov edx, eax
        endinfstart:
        
        cmp eax, edx
        jng endeif
        mov edx, eax
        endeif:
        loop l3
        
        mov [ebp+8], edx  
        
        ;epilog:
        mov esp, ebp; lokale Variablen werden wieder gelöscht
        pop ebp; basepointer wird wieder hergestellt
        ret