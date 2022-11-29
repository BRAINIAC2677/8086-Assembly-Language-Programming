; printing the second largest of inputted 3 numbers[0-9]
.MODEL SMALL

.STACK 100H 

.DATA

.CODE

FIRST DB ?
SEC DB ?
THIRD DB ?

MAIN PROC 
    
    MOV AX, @DATA
    MOV DX, AX
              
    ; FIRST INPUT
    MOV AH, 1
    INT 21H   
    MOV FIRST, AL
    
    ; SECOND INPUT
    INT 21H
    MOV SEC, AL
    
    ; THRID INPUT
    INT 21H
    MOV THIRD, AL
    
    ; FIRST COMPARISON 
    MOV BL, SEC
    CMP FIRST, BL 
    JLE ELSE1 
    ; IF1        
    MOV BL, FIRST
    MOV BH, SEC
    MOV FIRST, BH
    MOV SEC, BL
    
    ; ELSE1
    ELSE1: 
    
    MOV BL, THIRD
    CMP FIRST, BL
    JLE ELSE2
    ; IF2
    MOV BL, FIRST 
    MOV BH, THIRD
    MOV FIRST, BH
    MOV THIRD, BL
    
    ; ELSE2
    ELSE2:
    
    ; SEC COMPARISON 
    MOV BL, THIRD
    CMP SEC, BL
    JLE ELSE3
    ; IF3
    MOV BL, SEC 
    MOV BH, THIRD
    MOV SEC, BH
    MOV THIRD, BL
    
    ; ELSE3
    ELSE3:
    
    ; PRINTING SECOND LARGEST
    MOV DL, SEC
    MOV AH, 2
    INT 21H
    
    ; EXIT DOS
    MOV AH, 4CH
    INT 21H
    
MAIN ENDP

END MAIN