;Task:
;
;Read a string using the keyboard and ending with "0", find the maximum char and print it in base 16
;precondition: Use a modulefile function.asm

bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,scanf,printf,fopen,fprintf,fclose      ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll  
import scanf msvcrt.dll
import printf msvcrt.dll
import fopen msvcrt.dll
import fprintf msvcrt.dll
import fclose msvcrt.dll
  ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                   
extern maxnum                   ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

global n ; n wird global gesetzt

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    ausgabe db "Die größte Zahl ist: %x", 0
    text db "HALLOO",0
    ergebnis dd 0
    
    file_name db "out.txt", 0       
    access_mode db "a", 0           
    file_descriptor dd -1
    
    n resd 100
    len_n equ $-n
    last_n equ $ - 4
    format db "%d", 0
         ;descriptor
        
    
; our code starts here
segment code use32 class=code
    start:
        ; ...

        mov ecx, len_n
        mov esi, last_n
        std
        mov edx,0 ; zählt wie oft eine Zahl gelesen wird
        
        loopanfang:
        
        pushad; wir sichern alle Register auf dem Stack
        
        push dword esi
        push dword format
        call [scanf]
        add esp, 4*2        ;wir geben in Tastatur ein und speichern in esi
        
        popad
         
        lodsd
        cmp eax,0
        je endelesen    ;Wenn 0 eingegeben wurde bricht man aus Schleife aus
        inc edx        ;Zähler von gelesenen Zahlen ++
        loop loopanfang
        endelesen:
        
        ;JETZT WIRD DIE GRÖ?TE ZAHl ERMITTELT
        
        push dword edx      ;parameter die anzahl an gelesenen Zahlen
        push dword last_n   ;parameter die adresse des letzten reservierten doppelword
        sub esp, 4          ;Wir reservieren platz für returnwert
        
        call maxnum
        pop ebx             ;Wir speichern returnwert in ebx
        add esp, 4*2
        
        pushad
        push dword ebx
        push dword ausgabe
        call [printf] ; wir printen das ergebnis
        add esp, 4*2
        popad
        
        ;Wir schreiben das ergebnis in eine Datei
        pushad
        push dword access_mode
        push dword file_name
        call [fopen]
        add esp, 4*2 
        popad
        mov [file_descriptor], eax
        
        push dword ebx
        push dword ausgabe
        push dword [file_descriptor]
        call [fprintf]
        add esp, 4*3
        
        push dword [file_descriptor]
        call [fclose]
        add esp, 4
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
