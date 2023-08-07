;Task
;To calculate the double word Q from the double words R and T as follows:

;    Bits 0-6 of Q are the same as bits 10-16 of T.
;    Bits 7-24 of Q are the same as bits 7-24 of (R XOR T).
;    Bits 25-31 of Q are the same as bits 5-11 of R.

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
    r dd 00001111000011110000111100001111b
    t dd 11110000111100001111000011110000b
    q dd 0
 
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov eax, 0 ; fill eax with 0, the endresult will be here
 
        mov ebx, [t] ; t -> ebx 
        ror ebx, 10 ; rotate 10 bits to the right
        and ebx, 0000007Fh; isolate 0-16
        or eax, ebx ; Ergebnis wird in eax übernommen
        
        mov ebx, [r]; r -> ebx
        xor ebx, [t] ; r xor t -> ebx
        and ebx, 00000001111111111111111110000000b ; bits 7-24 isolated
        or eax, ebx ; bits 7-24 -> eax
        
        mov ebx, [r] ; r -> ebx
        rol ebx, 20 ; rotate ebx 20 bits to the left
        and ebx, 11111110000000000000000000000000b; fe000000h isolate
        or eax, ebx; result -> eax
        
        mov [q], eax ; final result -> q
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
