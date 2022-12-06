.MODEL SMALL

.STACK 100H

.DATA

CR EQU 0DH
LF EQU 0AH
NEWLINE DB CR, LF, '$'

PROMPT1 DB 'ARRAY SIZE: ', '$'
PROMPT2 DB 'ARRAY VALUES: ', '$'
PROMPT3 DB 'SORTED ARRAY: ', '$'

N DW ?
ARR DW 65535 DUP (?)

.CODE

MAIN PROC
    
    ; LOADING DATA
    MOV AX, @DATA
    MOV DS, AX
    
    ; OUTPUT PROMPT1
    LEA DX, PROMPT1
    CALL PRINT_STRING
    CALL PRINT_NEWLINE
    
    ; ARRAY SIZE INPUT
    CALL INPUT_INT  
    MOV N, DX 
    
    CALL PRINT_NEWLINE
    
    ; OUTPUT PROMPT2
    LEA DX, PROMPT2
    CALL PRINT_STRING
    CALL PRINT_NEWLINE
    
    ; ARRAY VALUES INPUT
    LEA SI, ARR
    MOV CX, N        
    CALL IN_ARR_INT
    
    CALL PRINT_NEWLINE
    
    ; SORTING 
    LEA SI, ARR
    MOV CX, N
    CALL INSERTION_SORT
    
    CALL PRINT_NEWLINE
    
    ; OUTPUT PROMPT3
    LEA DX, PROMPT3
    CALL PRINT_STRING
    CALL PRINT_NEWLINE
    
    ; OUTPUT SORTED ARRAY
    LEA SI, ARR
    MOV CX, N
    CALL OUT_ARR_INT
    
    ; EXIT DOS
    MOV AH, 4CH
    INT 21H
    
MAIN ENDP


INSERTION_SORT PROC
    ; SORTING OF SIGNED INT16  
    ; BEFORE CALLING:
    ; 1| LEA SI, <ARRAY_NAME>
    ; 2| MOV CX, <ARRAY_SIZE>
    
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI
    
    MOV AX, 01H   ; AX OUTER ITERATOR.
    INSERTION_SORT_LOOP_1:               
        CMP AX, CX
        JE INSERTION_SORT_END_LOOP_1
        
        SHL AX, 1 
        ADD SI, AX
        MOV DX, [SI]  ; DX CURRENT KEY VALUE
        SUB SI, AX
        SHR AX, 1
        
        MOV DI, AX  ; DI INNER ITERATOR 
        SUB DI, 1
        INSERTION_SORT_LOOP_2:            
            CMP DI, 0
            JL INSERTION_SORT_END_LOOP_2
            
            SHL DI, 1 
            ADD SI, DI
            MOV BX, [SI]
            SUB SI, DI
            SHR DI, 1
            CMP DX, BX
            JGE INSERTION_SORT_END_LOOP_2
            
            ; ARR[DI+2] = ARR[DI]. "DI+2" AS INT SIZE 2 BYTE
            ADD DI, 1
            SHL DI, 1 
            ADD SI, DI
            MOV [SI], BX
            SUB SI, DI
            SHR DI, 1
            SUB DI, 1
            
            SUB DI, 1
            JMP INSERTION_SORT_LOOP_2
        INSERTION_SORT_END_LOOP_2:
        
        ; ARR[DI] = KEY VALUE
        ADD DI, 1
        SHL DI, 1
        ADD SI, DI
        MOV [SI], DX
        SUB SI, DI
        SHR DI, 1
        
        ADD AL, 1
        JMP INSERTION_SORT_LOOP_1
    INSERTION_SORT_END_LOOP_1: 
    
    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    
    RET
    
INSERTION_SORT ENDP


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
    
    ; HANDLING NEGATIVE INT
    MOV AH, 1
    INT 21H
    CMP AL, '-'
    JNE INPUT_INT_CHECK_CHAR
    MOV CL, 01H ; CL = 1 MEANS NEGATIVE INT 
                  
                  
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
    
    
    ; IF NEG INT: DX = 2SCOMP(DX)
    CMP CL, 01H
    JNE INPUT_INT_RESTORE_REG
    CALL 2SCOMP
    
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
    
    ; IF DX NEGATIVE: 1|PRINT '-', 2|2S COMPLEMENT DX
    TEST DX, 08000H
    JE OUTPUT_INT_LOOP_1
    MOV BX, DX
    MOV DL, '-'
    MOV AH, 2
    INT 21H
    MOV DX, BX
    CALL 2SCOMP    

        
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


PRINT_STRING PROC
    ; BEFORE CALLING:
    ; 1| LEA DX, <STRING_ADDRESS>
    
    PUSH AX
    
    MOV AH, 9
    INT 21H
    
    POP AX
    
    RET
PRINT_STRING ENDP



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
