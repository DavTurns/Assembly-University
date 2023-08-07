;Task
;perform unsigned operation: 
;x -(a+b+c*d)/(9-a)
;= 20 -(2+9+1*3) / (9-2) = 20 - (14/7) = 20 - 2 = 18
;a,c,d-byte; b-doubleword; x-qword

bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    
    x dq 20
    a db 2
    b dd 9
    c db 1
    d db 3
    
; our code starts here
segment code use32 class=code
    start:

        mov ah, [c]
        mov al, [d]

        mul ah ;ax = ah* al = 1 * 3
        mov cl, [a]
        mov ch, 0
        add ax, cx ;ax = ax + cx = (c*d) + a = 5
        
        mov dx, 0
        push dx
        push ax
        pop ebx; ebx = 5 convert ax to doubleword to be able add with b
        
        mov eax, [b]
        add ebx, eax; (a+b+c*d) = (2+9+1*3) = 14
        
        mov ch, [a]
        mov cl, 9
        sub cl, ch ; cl = cl - ch = 9 - 2 ->byte
        mov ch, 0
        push ebx; convert ebx -> dx:ax for division
        pop ax
        pop dx
        div cx; dx:ax / cx -> al (rest 0 -> ah)
        
        ;now we want to calculate x - al, thats why we convert al into quadword
        mov ah, 0 ; set ah to 0
        push ax
        mov eax, 0
        pop ax
        mov ebx, 0; ebx:eax -> subtrahend
        mov ecx, dword[x+4];  
        mov edx, dword[x+0]; x in ecx:edx -> minuend
        clc ;set carryflag to 0
        sub edx, eax
        sbb ecx, ebx; ecx:edx - ebx:eax = 18 
        ;result is in ecx:edx
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
