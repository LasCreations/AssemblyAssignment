.MODEL SMALL
.STACK 100h

.DATA
    prompt1 DB 'Enter the first digit: $'
    prompt2 DB 'Enter the second digit: $'
    result_single DB 'The sum is: $'
    result_double DB 'The sum is: $'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; Prompt for the first digit
    MOV AH, 9
    LEA DX, prompt1
    INT 21h

    ; Read the first digit
    MOV AH, 1
    INT 21h
    MOV BL, AL

    ; Prompt for the second digit
    MOV AH, 9
    LEA DX, prompt2
    INT 21h

    ; Read the second digit
    MOV AH, 1
    INT 21h
    ADD BL, AL

    ; Check if the sum is greater than 9
    CMP BL, 9
    JA DOUBLE_DIGIT

    ; Single-digit result
    MOV AH, 9
    LEA DX, result_single
    INT 21h

    MOV AH, 2
    MOV DL, BL
    ADD DL, 30h ; Convert to ASCII
    INT 21h

    JMP EXIT

DOUBLE_DIGIT:
    ; Double-digit result
    MOV AH, 9
    LEA DX, result_double
    INT 21h

    ; Calculate the tens digit
    MOV AL, BL
    DIV BL, 10
    MOV CL, AL

    ; Calculate the units digit
    MOV DL, BL
    ADD CL, 30h ; Convert tens digit to ASCII
    ADD DL, 30h ; Convert units digit to ASCII

    ; Print the tens digit
    MOV AH, 2
    MOV DL, CL
    INT 21h

    ; Print the units digit
    MOV AH, 2
    MOV DL, DL
    INT 21h

EXIT:
    MOV AH, 4Ch
    INT 21h
MAIN ENDP
END MAIN