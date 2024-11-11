;Done By: Lascelle Mckenzie-2104113

.MODEL SMALL
.STACK 100h


; The initialized data
.DATA

        ;NOTE: 0dh, 0ah -> New Line
        msg0    db      0dh,0ah, "**********************************" ,0dh,0ah, "**    Single Digit Calculator   **" ,0dh,0ah, "**********************************",0dh,0ah, '$' 
        msg     db      "**            1. Add            **",0dh,0ah, "**            2. Multiply       **",0dh,0ah, "**            3. Subtract       **",0dh,0ah, "**            4. Exit           **", 0Dh,0Ah, "**********************************", 0Dh,0Ah, '$' 
        msg1    db      0dh,0ah, "Please Enter The Operation You Want To Use: ",0Dh,0Ah,'$'
        msg2    db      0dh,0ah, "Please Enter The First Digit (0-9) [PRESS ENTER AFTER]: $"
        msg3    db      0dh,0ah, "Please Enter The Second Digit (0-9) [PRESS ENTER AFTER]: $"
    
        msg4    db      0dh,0ah,"Invalid Input" , 0Dh,0Ah," $" 
        msg5    db      0dh,0ah,"Result : $" 
        msg7    db      0dh,0ah,"Invalid Digit Input Please Try Again" , 0Dh,0Ah," $" 
    
        msg6    db      0dh,0ah ,'Thank You for using the calculator! Submitted by Lascelle, Benjamin, Fredrica ,Dawayne. & Keller ', 0Dh,0Ah, '$'
   
.CODE  
MAIN PROC   
    mov ax, @data      ; Load the code segment address into AX register
    mov ds, ax      ; Copy the code segment address into the data segment register (ds)

    jmp start       ; Jump to the start label to skip over data section

start:
        ; Display the introductory message
        mov ah,9
        mov dx, offset msg0 
        int 21h          ; DOS interrupt to display string in DX

        ; Display menu with options for user
        mov ah,9
        mov dx, offset msg 
        int 21h

        ; Ask user to select an operation
        mov ah,9                  
        mov dx,offset msg1
        int 21h 

        mov ah,0                       
        int 16h          ; Read a key from keyboard (store it in AL)

        ; Compare input (AL) with values to select operation
        cmp al, 31h      ; Compare with '1' (Addition)
        call Addition

        cmp al, 32h      ; Compare with '2' (Multiplication)
        call Multiply

        cmp al, 33h      ; Compare with '3' (Subtraction)
        call Subtract

        cmp al, 34h      ; Compare with '4' (Exit)
        call Exit

        ; If input is invalid, display error message and prompt again
        mov ah, 09h
        mov dx, offset msg4
        int 21h

        jmp start        ; Jump back to start to re-prompt the user
        Addition:
        ; Display prompt for first digit in addition
        mov ah,09h  
        mov dx, offset msg2  
        int 21h

        mov cx,0         ; Clear CX register, used to store number of digits

        call InputNo     ; Call InputNo to get first input (number in DX)

        ; Validate first input to ensure it's a valid digit (0-9)
        cmp dx, 9
        JA DigitInvalid          ; If greater than '9', invalid input
        
        cmp dx, 0
        JB DigitInvalid          ; If less than '0', invalid input
        
        push dx           ; Save first digit on stack

        ; Display prompt for second digit in addition
        mov ah, 09h
        mov dx, offset msg3
        int 21h

        mov cx,0         ; Reset CX register for second input

        call InputNo     ; Get second digit from user
        mov bx, dx       ; Store second input in BX for comparison

        ; Validate second input (0-9)
        cmp bx, 9
        JA DigitInvalid

        cmp bx, 0
        JB DigitInvalid

        pop bx            ; Restore first digit from stack
        add dx, bx        ; Add both digits
        push dx           ; Save result

        ; Display result message
        mov ah,09h
        mov dx,offset msg5
        int 21h

        mov cx, 10000    ; Set CX to large value for division display
        pop dx            ; Restore result from stack

        call View         ; Call View function to display result
        jmp start         ; Jump back to start for new operation


        
Multiply:
        ; Multiply: Function to multiply two digits entered by the user
        mov ah,09h
        mov dx, offset msg2
        int 21h

        mov cx,0
        call InputNo

        cmp dx, 9
        JA DigitInvalid          ; If greater than '9', invalid input
    
        cmp dx, 0
        JB DigitInvalid          ; If less than '0', invalid input

        push dx

        mov ah,9
        mov dx, offset msg3
        int 21h 

        mov cx,0
        call InputNo

        mov bx, dx  
        cmp bx, 9
        JA DigitInvalid         
    
        cmp bx, 0
        JB DigitInvalid  

        pop bx
        mov ax,dx
        mul bx                 ; Multiply the numbers
        mov dx,ax             ; Store the result in DX
        push dx               ; Push result onto the stack
        mov ah,9
        mov dx,offset msg5
        int 21h
        mov cx,10000
        pop dx
        call View            ; Display result
        jmp start 

DigitInvalid:
        ; Display invalid digit message
        mov dx, offset msg7
        mov ah, 09h      
        int 21h
        jmp start         ; Prompt user again
        
Subtract:
        ; Subtract: Function to subtract two digits entered by the user
        mov ah,09h
        mov dx,offset msg2
        int 21h

        mov cx,0
        call InputNo
        cmp dx, 9
        JA DigitInvalid          ; If greater than '9', invalid input
    
        cmp dx, 0
        JB DigitInvalid          ; If less than '0', invalid input

        push dx

        mov ah,9
        mov dx, offset msg3
        int 21h 

        mov cx,0
        call InputNo
        mov bx, dx  
        cmp bx, 9
        JA DigitInvalid         
    
        cmp bx, 0
        JB DigitInvalid  

        pop bx
        sub bx,dx               ; Subtract second digit from first
        mov dx,bx               ; Store result in DX
        push dx 
        mov ah,9
        mov dx,  offset  msg5
        int 21h
        mov cx,10000
        pop dx
        call View             ; Display result
        jmp start 




NewLine:
        ; Print newline (Carriage Return and Line Feed)
        mov ah, 02h
        mov dl, 13        ; Carriage return
        int 21h
        mov dl, 10        ; Line feed
        int 21h 
        ret

InputNo:
        ; InputNo function: Reads a keypress and stores the result in DX
        mov ah,0
        int 16h           ; Wait for key press, result in AL

        mov dx,0          ; Clear DX
        mov bx,1          ; Set BX to 1 (to handle the digit)

        cmp al,0dh        ; Check if Enter key was pressed (0Dh)
        je FormNo         ; If Enter pressed, process number
        sub ax,30h        ; Convert ASCII to actual number (subtract 30h)
        
        call ViewNo       ; Display the number
        mov ah,0
        push ax           ; Save AX on stack

        inc cx            ; Increment number of digits
        jmp InputNo       ; Repeat input

FormNo:
        ; FormNo: Complete number processing after Enter is pressed
        pop ax            ; Restore AX (most recent digit)
        push dx           ; Save DX
        mul bx            ; Multiply AX by BX (used for digit processing)
        pop dx            ; Restore DX
        add dx, ax        ; Add AX (digit value) to DX (current number)
        mov ax, bx        ; Move BX to AX
        mov bx, 10        ; Set BX to 10 for decimal conversion
        push dx           ; Save DX
        mul bx            ; Multiply AX by 10 (shift number by one decimal place)
        pop dx            ; Restore DX
        mov bx, ax        ; Move result to BX (final number)
        dec cx            ; Decrement digit counter
        cmp cx, 0         ; Check if all digits processed
        jne FormNo        ; Repeat if there are more digits
        ret   

View:
        ; View: Display number stored in DX
        mov ax, dx        ; Move number to AX
        mov dx, 0         ; Clear DX
        div cx            ; Divide AX by CX, result in AX, remainder in DX
        call ViewNo       ; Display remainder (next digit)
        mov bx, dx        ; Move remainder to BX
        mov dx, 0         ; Clear DX
        mov ax, cx        ; Move quotient to AX
        mov cx, 10        ; Set divisor to 10 for decimal
        div cx            ; Divide by 10 for next digit
        mov dx, bx        ; Move remainder to DX
        mov cx, ax        ; Move quotient to CX
        cmp ax, 0         ; If quotient is zero, end of number
        jne View          ; Repeat if quotient is non-zero
        ret

ViewNo:
        ; ViewNo: Display a single digit stored in AX
        push ax           ; Save AX
        push dx           ; Save DX
        mov dx, ax        ; Move digit to DX for display
        add dl, 30h       ; Convert to ASCII
        mov ah, 2         ; DOS interrupt for character output
        int 21h
        pop dx            ; Restore DX
        pop ax            ; Restore AX
        ret

Exit:
        ; Exit: Display exit message and terminate the program
        mov dx,  offset msg6
        mov ah, 09h
        int 21h  

        mov ah, 4Ch       ; DOS terminate program function
        int 21h  
        ret 



MAIN ENDP
END MAIN