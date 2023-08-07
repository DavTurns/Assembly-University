Task

bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, fread, fopen, fclose             ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll                      ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fread msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    file_name db "beispieltext.txt", 0
    access_mode db "r", 0
    
    deskriptor dd -1
    len_datei_inhalt equ 100
    datei_inhalt times 100 db "A"
   
    ziffern RESB 10
    len_ziffern EQU $ - ziffern
    
    ausgabe db "Die Ziffer %d hat die hoechste Frequenz von %d", 0
; our code starts here
segment code use32 class=code
    start:
        ; ...
      ;öffne Datei
      push dword access_mode
      push dword file_name
      call [fopen]
      add esp, 4*2
      
      cmp eax, 0;überprüfen ob öffnen erfolgreich war
      JNE oe
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]
      oe:
      
      ;datei lesen
      mov [deskriptor], eax
      push dword [deskriptor]
      push dword len_datei_inhalt
      push dword 1
      push dword datei_inhalt
      call [fread]
      add esp, 4*4
      
      ;datei schließen
      push dword [deskriptor]
      call [fclose]
      
      
      ;push dword datei_inhalt
      ;call[printf]
      ;add esp, 4
  
  
      mov edi, ziffern ;Hier kommt die Adresse von der Zehnerstelle weil wir mit ecx = 10 starten
      mov eax, 0 ;
      mov ebx, 0 ; Counter für loopziffern ebx = 10
      loopziffern:
        mov dh,0
        mov esi, datei_inhalt ; Hier kommt die erste Adresse von dateiinhalt rein
        mov ecx, len_datei_inhalt ; Counter für loop_inhalt mit länge von Inhalt
        JECXZ ende_loopinhalt
        loop_inhalt:
            CLD   ; weil wir von Links nach rechts lesen
            LODSB  ; wir laden von inhalt jeden char
            
            sub eax, 30h
            
            CMP eax, ebx ; wir vergleichen den Inhalt von
            JNE then    ; wenn der ausgelesene char der ziffer im Counter entspricht
                inc dh  ; machen wir den Counter größer
            then:
            Loop loop_inhalt
        ende_loopinhalt:
        mov al, dh
        STOSB   ; wir schreiben in ziffern die Anzahl an vorkommende Ziffern
        
        inc ebx ; wir machen counter kleiner
        CMP ebx,10
        JL loopziffern
        
        ;#Teil 2.
	;pseudocode
        ;highestcounter = 0
        ;highestziffer = 0
        ;for ziffer in range(10):
            ;gettempcount <-
;           if count > highestcounter:
;                highestziffer, ziffer
                 ;highestcount, 
                    

        mov ecx, 0 ;Ziffernsorte
        mov esi, ziffern
        CLD
        mov dh, 0 ; häufigste Ziffer
        mov dl, 0 ; highestcounter startet bei 0
        
        ziffern_loop:
            LODSB   ;tempcount
            CMP al, dl 
            JBE then2 ;wenn count <= highestcount -> if wird übersprungen
            mov dl, al; wenn count > highestcount <= count 
            mov dh, cl; häufigste ziffer <= ziffer 
            then2:
            inc ecx
            CMP ecx, 10
            JL ziffern_loop
        
        ;dh <- häufigste Ziffer
        ;dl <- höchster counter
        mov eax, 0 ;höchste Ziffer
        mov al, dh
        mov ebx, 0 ;höchster Counter
        mov bl, dl
        
        ;vorbereiten printf
        push ebx
        push eax
        push dword ausgabe
        call[printf]
        add esp, 4*3
        
        ;FRAGE: Was ist Dateideskriptor
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
