bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data

    
    a dd 20
    b db 4
    c db 2
    x dq 50
    
; our code starts here
segment code use32 class=code
    start: ;mit Vorzeichen
        ; ...    ; ...a-doubleword; b,c-byte; x-qword sind. (a+b)/(2-b*b+b/c)-x = (20+4)/(2-4*4+4/2)- 50 = 24/-12 -50 = -52
        ;also a = 20, b = 4, c= 2 x = 50
        
        mov al, [b]
        cbw; al -> ax unter Beachtung Vorzeichen
        cwde; ax -> eax unter Beachtung Vorzeichen 
        mov ebx, [a]
        add ebx, eax; (a+b) = 20 + 4 = 24 -> ebx
        mov al, [b]
        mov ch, [b]
        imul ch ; b*b-> ax, imul oder mul macht kein Unterschied da immer positives Produkt
        mov cx, 2
        sub cx,ax; 2 - b*b = 2 - 4*4 = -14 -> cx
        mov al, [b]
        cbw; al -> ax also b wird zu word
        mov dl, [c]
        idiv dl ; ax / dl = b/c = 4/2 = 2 -> al (quotient) 0 -> ah (rest)
        cbw ; al -> ax also b/c -> ax
        add cx,ax; (2-b*b+b/c) = (2-4*4+4/2) = -12 in cx
        push ebx
        pop ax
        pop dx; ebx -> dx:ax
        idiv cx; dx:ax / cx -> ax quotient, dx rest
        cwde ; ax -> eax
        cdq     ; eax -> edx:eax -2
        mov ecx, dword[x+4]
        mov ebx, dword[x+0] ; -> ecx:ebx -> 50
        ; -2 - 50 also edx:eax - ecx:ebx -> -52 in edx:eax
        clc; clear carry flag
        sub eax, ebx
        sbb edx,ecx
        ;Ergebnis -52 in edx:eax
        
        
        
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
        