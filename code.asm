section .text
    org 0x100  ; Required for .com files to tell the assembler where code starts


mov ax, cs      ; Load code segment into AX
mov ds, ax      ; Copy code segment into data segment
jmp menu

menu:
    call new_line

    mov dx, display_menu
    mov ah, 09h      
    int 21h

    call new_line

    mov ah, 01h      
    int 21h        
    
    mov cl, al  

    cmp cl, '4'
    ja menu         
    
    cmp cl, '1'
    jb menu         

    cmp cl, '4'
    je exit_program

    jmp accept_input

new_line:
    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h 
    ret

prompt_user:
    mov dx, prompt   
    mov ah, 09h      
    int 21h          
    ret 

accept_input:
    call prompt_user
    call read_input

    mov bl, al  
        
    call prompt_user
    call read_input

    cmp cl, '1'
    je addition


display:
    cmp al, 9             ; Check if result is less/equal 9
    jbe single_digit_result 
    jmp double_digit_result ; else call

double_digit_result:
    ; Copy result in AL to a temporary register (so AL can be safely used for division)
    mov bl, al            ; Move the result to BL

    ; Prepare for division by 10
    mov ax, 0             ; Clear AX
    mov al, bl            ; Load the result back into AL
    mov cl, 10            ; Set divisor to 10
    div cl                ; Divide AL by 10 -> quotient in AL (tens), remainder in AH (units)

    ; Convert and print tens digit
    add al, 30h           ; Convert quotient (tens) to ASCII
    mov dl, al            ; Move ASCII tens digit to DL for printing
    call print_char       ; Print tens digit

    ; Convert and print units digit
    mov al, ah            ; Move remainder (units) to AL
    add al, 30h           ; Convert to ASCII
    mov dl, al            ; Move ASCII units digit to DL for printing
    call print_char       ; Print units digit

    jmp exit_program      ; Go to program exit


addition:
    add al, bl
    jmp display    

single_digit_result: 
    add al, 30h             ; Convert result back to ASCII

    ; Print the result message
    mov dx, result       
    mov ah, 09h      
    int 21h          

    ; Output the result character
    call print_char

    call exit_program

print_char:
    mov dl, al
    mov ah, 02h
    int 21h
    ret   

read_input:
    mov ah, 01h      
    int 21h          

    cmp al, '9'
    JA error          
    
    cmp al, '0'
    JB error          

    sub al, 30h  
    ret




error:
    mov dx, error_message
    mov ah, 09h      
    int 21h 

    call new_line
    call prompt_user
    jmp read_input  

exit_program:
    mov ah, 4Ch      
    int 21h    

section .data
    result           db 10, 13, 'RESULT IS: $'
    display_menu     db 10, 13, '1.ADDITION  2.SUBTRACTION 3.MULTIPLICATION 4.EXIT  $'
    error_message    db 10, 13, 'INVALID INPUT. TRY AGAIN.$'
    prompt           db 10, 13, 'ENTER DIGIT: $'
    a db 0
    b db 0
    c db 0