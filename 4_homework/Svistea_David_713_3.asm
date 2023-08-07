;Task:
;add a and b and print the result

bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit , printf              ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a dd 1
    b dd -2
    string db "%d + %d = %d", 0
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov ebx, [a]
        mov ecx, [b]
        add ebx, ecx ; a+b in ebx

        push ebx
        push dword[b]
        push dword[a]
        push dword string ; parameters are pushed on the stack
        call [printf]; function called
        add esp, 4*4 ; esp set to adress before the function was called
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
