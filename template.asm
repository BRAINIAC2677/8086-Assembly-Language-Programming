; template code

.MODEL SMALL

.STACK 100H

.DATA
    ; define the variables
    CR      EQU 0DH
    LF      EQU 0AH
    NEWLINE DB  CR, LF , '$'

.CODE

MAIN PROC
    ; data segment initialization
    MOV AX, @DATA
    MOV DS, AX

    WHILE_1:    
        ; INITIALIZATION
        
        ; LOOP BREAKING CONDITION

        ; LOOP BODY
        
        JMP WHILE_1
    
    END_WHILE_1:

    ; NEWLINE
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H

    ; DOS exit
    MOV AH, 4CH
    INT 21H

MAIN ENDP
    ; other procedures
    
END MAIN