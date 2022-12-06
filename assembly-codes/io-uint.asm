DEL SMALL

.STACK 100H

.DATA

CR EQU 0DH
LF EQU 0AH
NEWLINE DB CR, LF, '$'

.CODE

MAIN PROC
    
    ; LOADING DATA
    MOV AX, @DATA
    MOV DS, AX
    
    CALL INPUT_INT
    
    MOV BX, DX
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    MOV DX, BX
    
    CALL OUTPUT_INT
    
    ; EXIT DOS
    MOV AH, 4CH
    INT 21H
    
MAIN ENDP  

INPUT_INT PROC
    ; TAKE A SIGNED INT INPUT AND STORE IN DX REG
    
    PUSH AX 
    PUSH BX
    PUSH CX
    
    ; DX = 0
    XOR DX, DX
    XOR CX, CX 
                  
                  
    INPUT_INT_LOOP_1:
        ; CHARACTER BY CHARACTER INPUT
        
        MOV AH,1
        INT 21H
        
        INPUT_INT_CHECK_CHAR:
        
            ; BREAK
            CMP AL, '0'
            JL INPUT_INT_END_LOOP_1
            CMP AL, '9'
            JG INPUT_INT_END_LOOP_1
            
            ; STORING DIGIT TO BX
            SUB AL, 30H
            MOV BL, AL
            XOR BH, BH
            
            ; DX = DX*10 + BX
            MOV AL, 10D
            XOR AH, AH
            MUL DX
            ADD AX, BX
            MOV DX, AX
             
            JMP INPUT_INT_LOOP_1        
    INPUT_INT_END_LOOP_1:  
    
    
    POP CX 
    POP BX
    POP AX
    
    RET
INPUT_INT ENDP
   



OUTPUT_INT PROC
    ; PRINT SIGNED INTEGER FROM DX REG
    
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    ; CX WILL COUNT THE NUMBER OF DIGITS
    XOR CX, CX   

        
    OUTPUT_INT_LOOP_1:    
        ; EXTRACTING AND STACKING DIGITS
        
        CMP DX, 0H
        JE OUTPUT_INT_END_LOOP_1
        
        ; DX = DX/10, EXTRACT DX%10
        MOV AX, DX
        MOV BL, 10D
        XOR BH, BH
        XOR DX, DX      ; CLEARING DX 
        DIV BX          
        ADD DX, 30H     ; DIGIT TO ASCII  
        PUSH DX
        ADD CX, 1
        MOV DX, AX      
        JMP OUTPUT_INT_LOOP_1           
    OUTPUT_INT_END_LOOP_1:
 
    
    OUTPUT_INT_LOOP_2:
        ; UNSTACKING AND PRINTING DIGITS
            
        CMP CX, 0H
        JE OUTPUT_INT_END_LOOP_2
        
        POP DX
        MOV AH, 2
        INT 21H
        
        SUB CX, 1
        JMP OUTPUT_INT_LOOP_2    
    OUTPUT_INT_END_LOOP_2:
    
    
    POP DX
    POP CX
    POP BX
    POP AX
    
    RET
OUTPUT_INT ENDP



END MAIN


