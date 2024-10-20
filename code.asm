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

    ; Print the first prompt (ENTER FIRST DIGIT)
    mov dx, p1      ; Load the address of p1 into DX
    mov ah, 09h     ; Function to print string
    int 21h         ; Call DOS interrupt

    ; Read first character
    mov ah, 01h     ; Function to read a character
    int 21h         ; Call DOS interrupt
    sub al, 30h     ; Convert ASCII to number
    mov bl, al      ; Store the first digit in BL

    ; Print the second prompt (ENTER SECOND DIGIT)
    mov dx, p2      ; Load the address of p2 into DX
    mov ah, 09h     ; Function to print string
    int 21h         ; Call DOS interrupt

    ; Read second character
    mov ah, 01h     ; Function to read a character
    int 21h         ; Call DOS interrupt
    sub al, 30h     ; Convert ASCII to number

    ; Add the two numbers
    add al, bl      ; Add first and second digit
    add al, 30h     ; Convert result back to ASCII

    ; Print the result message
    mov dx, p3      ; Load the address of p3 into DX
    mov ah, 09h     ; Function to print string
    int 21h         ; Call DOS interrupt

    ; Output the result character
    mov dl, al      ; Load result character into DL
    mov ah, 02h     ; Function to print character
    int 21h         ; Call DOS interrupt

    ; Exit the program
    mov ah, 4Ch     ; Function to exit program
    int 21h         ; Call DOS interrupt

section .data
    p1  db 10, 13, 'ENTER FIRST DIGIT: $'
    p2  db 10, 13, 'ENTER SECOND DIGIT: $'
    p3  db 10, 13, 'RESULT IS $'
