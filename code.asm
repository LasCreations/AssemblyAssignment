; These are not needed 
;.MODEL SMALL
;.STACK 100H

section .text
    org 0x100  ; Required for .com files to tell the assembler where code starts

_start:
    ; Setup data segment
    mov ax, cs      ; Load code segment into AX
    mov ds, ax      ; Copy code segment into data segment

    ; Prompt for the first digit
    call prompt_user
    call read_input

    mov bl, al  ; Store the first digit in BL

    ; Prompt for the second digit
    call prompt_user
    call read_input          ; Read second digit

    ; Add the two digits
    add al, bl              ; Add first and second digit
    add al, 30h             ; Convert result back to ASCII

    jmp print_result

prompt_user:
    ; Prompt user to enter a digit
    mov dx, prompt   ; Load the address of prompt into DX
    mov ah, 09h      ; Function to print string
    int 21h          ; Call DOS interrupt
    ret               ; Return to point of call

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
    mov ah, 09h      ; Function to print string
    int 21h          ; Call DOS interrupt
    
    ; Instead of jumping to prompt_user, go back to read_input
    jmp read_input    ; Go back to read input again

print_result:
    ; Print the result message
    mov dx, p3       ; Load the address of p3 into DX
    mov ah, 09h      ; Function to print string
    int 21h          ; Call DOS interrupt

    ; Output the result character
    mov dl, al       ; Load result character into DL
    mov ah, 02h      ; Function to print character
    int 21h          ; Call DOS interrupt

    ; Exit the program
exit_program:
    mov ah, 4Ch      ; Function to exit program
    int 21h          ; Call DOS interrupt

section .data
    prompt          db 10, 13, 'ENTER DIGIT: $'
    p2              db 10, 13, 'ENTER SECOND DIGIT: $'
    p3              db 10, 13, 'RESULT IS: $'
    error_message    db 10, 13, 'INVALID INPUT. TRY AGAIN.$'
