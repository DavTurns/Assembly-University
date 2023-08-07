;Task
;To calculate the double word C from the words A and B as follows:
;    Bits 0-3 of C are the same as bits 5-8 of B.
;    Bits 4-8 of C are the same as bits 0-4 of A.
;    Bits 9-15 of C are the same as bits 6-12 of A.
;    Bits 16-31 of C are the same as bits of B.

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
    a dw 1111000011110000b
    b dw 1010101010101010b
    c dd 0
    ; c soll also aus 1010101010101010 1000011100000101
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov ax, 0 ;calculate bits 0-15 in ax
        mov bx, [b]
        ror bx, 5 ;rotate b to the right so that bits 5-8 on pos 0-3
        and bx, 0000000000001111b ; isolate bits 0-3
        or ax, bx ; insert bits 0-3 in result
        
        mov bx, [a] ; a -> bx
        rol bx, 4 ; shift bits 0-4 to pos 4-8 through rotation
        and bx, 0000000111110000b ; isolate bits 4-8
        or ax, bx; insert bits 4-8 in result
        
        mov bx, [a] ; a -> bx
        rol bx, 3 ; rotate 3 bit to the left so that bits 6-12 are on pos 9-15
        and bx, 1111111000000000b ; isolate
        or ax, bx
        
        push word[b];  compose eax <- ax and bits 16-31 from [b]
        push ax
        pop eax
        
        mov [c], eax; final result saved in c
         
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
