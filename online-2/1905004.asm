.MODEL SMALL

.STACK 100H

.DATA

CR EQU 0DH
LF EQU 0AH
NEWLINE DB CR, LF, '$'

N1 DW ?
ASCENT DW 0
ARR1 DW 15 DUP (?)

.CODE

MAIN PROC
    ; AX,BX,CX,DX, SI, DI
    
    ; LOADING DATA
    MOV AX, @DATA
    MOV DS, AX
    
    CALL INPUT_INT
    CALL PRINT_NEWLINE 
    
    LEA SI, ARR1
    MOV N1, DX
    MOV CX, N1
    CALL IN_ARR_INT
    
    MOV ASCENT, 1
    MOV CX, 1
    XOR SI, SI
    ADD SI, 2
    LOOP_1:
        
        MOV AX, SI
        SHR AX, 1
        CMP AX, N1
        JE END_LOOP_1
        
        ; AX = ARR1[SI], BX = ARR1[SI-1]
        MOV AX, ARR1[SI]
        SUB SI, 2
        MOV BX, ARR1[SI]
        ADD SI, 2
        
        CMP AX, BX
        JA ELSE_1
        
        IF_1:
            CMP CX, ASCENT
            JBE ELSE_2
            MOV ASCENT, CX
            
            ELSE_2:  
            
            MOV CX, 1
            JMP END_IF_1
        ELSE_1:
            ADD CX, 1
            
        END_IF_1:
        
        ADD SI, 2
        JMP LOOP_1
    END_LOOP_1:
    
    CMP CX, ASCENT
    JBE ELSE_3
    MOV ASCENT, CX
    ELSE_3:
    
    MOV DX, ASCENT
    CALL OUTPUT_INT
    
    
    ; EXIT DOS
    MOV AH, 4CH
    INT 21H
    
MAIN ENDP


IN_ARR_INT PROC
    ; BEFORE CALLING: 
    ; 1| LEA SI <ARRAY_NAME>
    ; 2| MOV CX, <NUMBER OF INPUT> (MUST BE NON-NEGATIVE) 
    
    PUSH CX
    PUSH DX
    PUSH SI
            
            
    IN_ARR_INT_LOOP_1:    
        ; INPUT CX NUMBER OF INT
        
        CMP CX, 0
        JE IN_ARR_INT_END_LOOP_1
        
        CALL INPUT_INT
        MOV WORD PTR [SI], DX
        ADD SI, 2
        SUB CX, 1
        
        CALL PRINT_NEWLINE
             
        JMP IN_ARR_INT_LOOP_1
        
    IN_ARR_INT_END_LOOP_1:
                
                
    POP SI
    POP DX
    POP CX 
    
    RET
IN_ARR_INT ENDP


OUT_ARR_INT PROC
    ; BEFORE CALLING: 
    ; 1| LEA SI <ARRAY_NAME>
    ; 2| MOV CX, <NUMBER OF INPUT> 
    
    PUSH CX
    PUSH DX
    PUSH SI
            
            
    OUT_ARR_INT_LOOP_1:    
        ; OUTPUT CX NUMBER OF INT
        
        CMP CX, 0
        JE OUT_ARR_INT_END_LOOP_1
        
        MOV DX, [SI]
        CALL OUTPUT_INT
        ADD SI, 2
        SUB CX, 1
        
        CALL PRINT_NEWLINE
             
        JMP OUT_ARR_INT_LOOP_1
        
    OUT_ARR_INT_END_LOOP_1:
                
                
    POP SI
    POP DX
    POP CX 
    
    RET
OUT_ARR_INT ENDP



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
    
    
    
    INPUT_INT_RESTORE_REG:
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



2SCOMP PROC
    ; WILL CALC 2S COMPLEMENT OF DX AND STORE IN DX
    
    PUSH AX
    
    MOV AX, 0FFFFH  ; NOT
    SUB AX, DX
    ADD AX, 01H
    MOV DX, AX
    
    POP AX
    
    RET
2SCOMP ENDP



PRINT_NEWLINE PROC
    
    PUSH AX
    PUSH DX
    
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    
    POP DX
    POP AX
    
    RET
PRINT_NEWLINE ENDP

 
 
END MAIN

