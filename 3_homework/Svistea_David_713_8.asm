;Task:
;
;A string S is given. Create the string D that contains all the uppercase letters of the string S. For example:
;S: 'a', 'A', 'b', 'B', '2', '%', 'x', 'M'
;D: 'A', 'B', 'M'

bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    
    s db 'AiB32.-C+g'
    langes EQU $ - s ; lenght of string s
    d RESB 1 ;wir reservieren einen Speicherplatz für die Zielzeichenfolge, damit wir edi richtig setzen können
    
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov edi, d ; edi <- adress of d
        mov esi, s ; esi <- adress of s
        mov ecx, langes ; ECX <- lenght of string
        JECXZ endloop ; if ECX is zero -> jump to "endloop"
        CLD ; set directionflag to 0 to iterate asc through esi and edi

	anfang:
        LODSB ; load char (byte) from esi adress -> al
        
	; if value is between (64;91), this is going to be added to the list
        CMP al, 65
        JL endif
        CMP al, 90
        JG endif
        STOSB
        endif:
        Loop anfang
        
        endloop:
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program