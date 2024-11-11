; These are not needed 
;.MODEL SMALL
;.STACK 100H

;Test

section .text
    org 0x100  ; Required for .com files to tell the assembler where code starts

_start:
    ; Setup data segment
    mov ax, cs      ; Load code segment into AX
    mov ds, ax      ; Copy code segment into data segment

    ;   Call Menu Option 
    call menu
    call readMenuOption

    mov cl, al  ; Move option into CL

    cmp cl, '4'
    je exit_program

    ; Prompt and accept first digit
    call prompt_user
    call read_input

    mov bl, al  

    ; Prompt and accept second digit
    call prompt_user
    call read_input          

    cmp cl, '1'
    je add_digits

    cmp cl, '2'
    je sub_digits


display:
    cmp al, 9             ; Check if result is less/equal 9
    jbe single_digit_result 
    jmp double_digit_result ; else call

readMenuOption:
    mov ah, 01h      ; Function to read a character
    int 21h          ; Call DOS interrupt
    ret

menu:
    mov dx, menuopt
    mov ah, 09h      
    int 21h 

    call newLine

    mov dx, _add
    mov ah, 09h      
    int 21h 

    call newLine

    mov dx, _sub
    mov ah, 09h      
    int 21h 

    call newLine

    mov dx, _mul
    mov ah, 09h      
    int 21h 

    call newLine

    mov dx, exit
    mov ah, 09h      
    int 21h 

    call newLine

    ret

add_digits:
    add al, bl
    call display
    
sub_digits:
    mov dx, _test
    mov ah, 09h      
    int 21h          
    jmp exit_program  

; Prompt user to enter a digit
prompt_user:
    mov dx, prompt   
    mov ah, 09h      
    int 21h          
    ret               

read_input:

    ; Read first character
    mov ah, 01h      ; Function to read a character
    int 21h          ; Call DOS interrupt

    cmp al, '9'
    JA error          ; If character input has a value greater than '9'
    
    cmp al, '0'
    JB error          ; If character input has a value less than '0'

    sub al, 30h       ; Convert ASCII to number
    ret

error:
    mov dx, error_message
    mov ah, 09h      ;
    int 21h          
    jmp read_input    

single_digit_result:
    add al, 30h             ; Convert result back to ASCII

    ; Print the result message
    mov dx, result       
    mov ah, 09h      
    int 21h          

    ; Output the result character
    call print_char

    call exit_program


newLine:
    ;New Line
    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h 
    ret


double_digit_result :

    call newLine

    ; Assume the result is in AL
    mov ah, 0          ; Clear AH for division
    mov bl, 10         ; Set divisor as 10
    div bl             ; AL now holds the quotient (tens), AH holds remainder (ones)

    ; Convert and display the tens digit
    add al, '0'        ; Convert quotient (tens) to ASCII
    mov dl, al         ; Move ASCII tens digit to DL
    call print_char    ; Print tens digit

    ; Convert and display the ones digit
    mov al, ah         ; Move remainder (ones) to AL
    add al, '0'        ; Convert to ASCII
    mov dl, al         ; Move ASCII ones digit to DL
    call print_char    ; Print ones digit

    call exit_program

print_char:
    ; Output a single character in AL
    mov dl, al       ; Load result character into DL
    mov ah, 02h      ; Function to print character
    int 21h          ; Call DOS interrupt
    ret    

    ; Exit the program
exit_program:
    mov ah, 4Ch      ; Function to exit program
    int 21h          ; Call DOS interrupt

section .data
    prompt           db 10, 13, 'ENTER DIGIT: $'
    result           db 10, 13, 'RESULT IS: $'
    menuopt          db 10, 13, 'CHOOSE ARITHMETIC OPTION: $'
    _add             db 10, 13, '1. ADDITION $'
    _sub             db 10, 13, '2. SUBTRACTION $'
    _mul             db 10, 13, '3. MULTIPLICATION $'
    exit             db 10, 13, '4. EXIT $'
    error_message    db 10, 13, 'INVALID INPUT. TRY AGAIN.$'
    _test             db 10, 13, 'test $'
