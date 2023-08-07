;Task:
;
;input: numbersequence ending with 0
;output in file: s1: ... , the same numbersequence as input, s2: ... , the digits with value *10 of s1

bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,scanf, fclose,fopen,fprintf              ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import scanf msvcrt.dll
import fclose msvcrt.dll
import fopen msvcrt.dll
import fprintf msvcrt.dll                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; lesen
    format_in db "%d",0
    
    ;algorithmus
    s1 times 101 dd 0 ;damit wir am ende eine 0 haben

    s2 times 101 dd 0
    ;schreiben
    
    file_name db "output.txt", 0
    access_mode db "a", 0
    text db "Sometext.", 0
    file_descriptor dd -1
    
    format_s1 db 10, "S1: ",0
    format_s2 db 10, "S2: ",0
    format_print_zahl db " %d,",0
    format_kez db "Keine Zahlen",0
    
; our code starts here
segment code use32 class=code
    start:
    ;3 Teile lesen:
    ;Wir lesen so lange bis eine 0 erscheint oder 100 zeichen gelesen wurden, und fügen jede folge als doppelwort in s1
    
    ;algorithmus: wir nehmen jede Zahl und teilen Sie durch 10
    ;dann nehmen wir das ergebnis und teilen es durch 10 -> rest in dx
    ;dx in doppelwort umandeln
    ; und mit edi auf s2 legen
    
    ;wir machen neue zeile in der einen geben wir normal s1 zurück.
    ;in der zweiten die zehner stellen mit append hinzufügen
    
    ;Lesen:
    mov esi, s1
    cld
    
    mov ch,0
    loopanfang:
    
        cmp ch,100
        je endelesen ;wenn alle 100 zahlen geschrieben wurden endet lesen
        
    pushad; wir sichern alle Register auf dem Stack
    push dword esi
    push dword format_in
    call [scanf]
    add esp, 4*2        ;wir geben in Tastatur ein und speichern in esi
    popad
    inc ch
    
    lodsd  
    cmp eax,0
    je endelesen    ;Wenn 0 eingegeben wurde bricht man aus Schleife aus
    Jmp loopanfang
    endelesen:
    
    ;ALGORITHMUS
    
    cld
    mov esi, s1
    mov edi, s2
    
    mov edx, 0 ;edx clearen
    
    mov cl, 0
    
    mov bx, 10
    algoloop:
        lodsd
        cmp eax, 0
        je fertigmitalgo
        cmp eax, 10
        jl algoloop
        push eax
        pop ax
        pop dx
        div bx
        mov dx,0
        div bx ; ergebnis in dx
        mov eax, 0
        mov ax, dx
        stosd
       
    JMP algoloop
    
    fertigmitalgo:
    
    ;schreiben
    ;öffnen   
    push dword access_mode
    push dword file_name
    call [fopen]
    add esp, 4*2
    
    mov [file_descriptor], eax
    cmp eax, 0
    je final
    
    
    push dword format_s1
    push dword [file_descriptor]
    call [fprintf]
    add esp, 4*2
    
    mov esi, s1
    s1loop:
    lodsd
    cmp eax, 0
    je fertigs1
    
    push eax
    push dword format_print_zahl
    push dword [file_descriptor]
    call [fprintf]
    add esp, 4*3
    
    jmp s1loop
    
    fertigs1:
    
    ;S2 wird geschrieben
    
    push dword format_s2
    push dword [file_descriptor]
    call [fprintf]
    add esp, 4*2
    
    mov esi, s2
    s2loop:
    lodsd
    cmp eax, 0
    je fertigs2
    
    ;wenn keine zahlen eingegeben wurden
    push eax
    push dword format_print_zahl
    push dword [file_descriptor]
    call [fprintf]
    add esp, 4*3
    
    jmp s2loop
    
    fertigs2:
    
    ;keine zahlen
    jmp then
    keinezahlen:
    
    push dword format_kez
    push dword [file_descriptor]
    call [fprintf]
    add esp, 4*2
    then:
    
    ;schließen
    push dword [file_descriptor]
    call [fclose]
    add esp, 4
    
    final:
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
