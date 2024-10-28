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

    ;  Prompt and accept first digit
    call prompt_user
    call read_input

    mov bl, al  ;

    ; Prompt and accept second digit
    call prompt_user
    call read_input          

    ; Add the two digits
    add al, bl              ; Add first and second digit
    
    cmp al, 9             ; Check if result is less/equal 9
    jbe single_digit_result 
    jmp double_digit_result ; else call


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


double_digit_result :

    ;New Line
    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h 

    ; Print the result message
    mov dx, result   
    mov ah, 09h      
    int 21h          


     ; For two-digit results, calculate tens and ones
    xor ah, ah        ; Clear AH to avoid issues with division
    mov dl, 10        ; Divisor (10)
    div dl            ; Divide AL by 10, quotient in AL (tens), remainder in AH (ones)

    ; Convert the quotient (tens) to ASCII and print it
    mov dl, al        ; Move quotient (tens) into DL
    add dl, 30h       ; Convert to ASCII
    call print_char   ; Print the tens digit

    ; Convert the remainder (ones) to ASCII and print it
    mov dl, ah        ; Move remainder (ones) into DL
    add dl, 30h       ; Convert to ASCII
    call print_char   ; Print the ones digit

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
    error_message    db 10, 13, 'INVALID INPUT. TRY AGAIN.$'
