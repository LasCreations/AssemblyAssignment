; These are not needed 
;.MODEL SMALL
;.STACK 100H

section .text
    org 0x100  ; Required for .com files to tell the assembler where code starts

    ; Start of the program
_start:
    ; Setup data segment
    mov ax, cs      ; Load code segment into AX
    mov ds, ax      ; Copy code segment into data segment

    prompt_1:
        ; Print the first prompt (ENTER FIRST DIGIT)
        mov dx, p1      ; Load the address of p1 into DX
        mov ah, 09h     ; Function to print string
        int 21h         ; Call DOS interrupt



    read_character_1:
        ; Read first character
        mov ah, 01h     ; Function to read a character
        int 21h         ; Call DOS interrupt
        ; Compare the raw value

    check_1:
        cmp al, '9'
        JBE check_2   ;JBE jumps if the the value is less or equal to a value
        ; If the input is greater than '9', print an error message
        mov dx, error_message
        mov ah, 09h     ; Function to print string
        int 21h         ; Call DOS interrupt
        JMP prompt_1   ;brings back if the character is more  


    check_2:
        cmp al, '0'
        JAE  sub_val   ;JAE jumps if the the value is greater or equal to a value
        mov dx, error_message
        mov ah, 09h     ; Function to print string
        int 21h         ; Call DOS interrupt
        JMP prompt_1   ;brings back if the character is more 

    sub_val:
        sub al, 30h     ; Convert ASCII to number
        mov bl, al      ; Store the first digit in BL

    prompt_2:
        ; Print the second prompt (ENTER SECOND DIGIT)
        mov dx, p2      ; Load the address of p2 into DX
        mov ah, 09h     ; Function to print string
        int 21h         ; Call DOS interrupt


    read_character_2:
        ; Read second character
        mov ah, 01h     ; Function to read a character
        int 21h         ; Call DOS interrupt
        sub al, 30h     ; Convert ASCII to number


    add_numbers:
        ; Add the two numbers
        add al, bl      ; Add first and second digit
        add al, 30h     ; Convert result back to ASCII

    print_result:
        ; Print the result message
        mov dx, p3      ; Load the address of p3 into DX
        mov ah, 09h     ; Function to print string
        int 21h         ; Call DOS interrupt


        ; Output the result character
        mov dl, al      ; Load result character into DL
        mov ah, 02h     ; Function to print character
        int 21h         ; Call DOS interrupt

    exit_program:
        ; Exit the program
        mov ah, 4Ch     ; Function to exit program
        int 21h         ; Call DOS interrupt

section .data
    p1  db 10, 13, 'ENTER FIRST DIGIT: $'
    p2  db 10, 13, 'ENTER SECOND DIGIT: $'
    p3  db 10, 13, 'RESULT IS $'
    error_message db 10, 13, 'INVALID INPUT TRY AGAIN $'
