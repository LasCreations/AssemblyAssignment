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
    mov dx, result
    mov ah, 09h
    int 21h

    mov dl, al
    div dl, 10  ; Divide the result by 10 to get the tens digit
    add dl, 30h ; Convert the tens digit to ASCII
    mov ah, 02h
    int 21h

    mov dl, ah  ; The remainder is the units digit
    add dl, 30h ; Convert the units digit to ASCII
    mov ah, 02h
    int 21h
    ret


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