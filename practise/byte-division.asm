.MODEL SMALL

.STACK 100H

.DATA  

CR EQU 0DH
LF EQU 0AH
NEWLINE DB CR, LF, '$'

DIVIDEND DB ?
DIVISOR DB ?    
QUOTIENT DB ?
REMAINDER DB ?

PROMPT1 DB 'DIVIDEND[0-9]: ', '$'
PROMPT2 DB 'DIVISOR[0-9]: ', '$'
PROMPT3 DB 'QUOTIENT: ', '$'
PROMPT4 DB 'REMAINDER: ', '$'

.CODE

MAIN PROC
    
    ; LOADING DS
    MOV AX, @DATA
    MOV DS, AX
    
    ; TAKING DIVISOR, DIVIDEND AS INPUT
    MOV AH, 9
    LEA DX, PROMPT1
    INT 21H
     
    MOV AH, 1
    INT 21H
    MOV DIVIDEND, AL
    SUB DIVIDEND, '0' ; FROM ASCII TO DIGIT
    
    MOV AH, 9
    LEA DX, NEWLINE
    INT 21H
    
    MOV AH, 9
    LEA DX, PROMPT2
    INT 21H
    
    MOV AH, 1
    INT 21H
    MOV DIVISOR, AL
    SUB DIVISOR, '0' ; FROM ASCII TO DIGIT
    
    ; DIVISION
    MOV AL, DIVIDEND
    CBW 
    IDIV DIVISOR
    MOV QUOTIENT, AL
    MOV REMAINDER, AH
    
    ; PRINTING
    MOV AH, 9
    LEA DX, NEWLINE
    INT 21H
    
    MOV AH, 9
    LEA DX, PROMPT3
    INT 21H
    
    MOV AH, 2
    MOV DL, QUOTIENT
    ADD DL, '0'
    INT 21H           
    
    MOV AH, 9
    LEA DX, NEWLINE
    INT 21H
    
    MOV AH, 9
    LEA DX, PROMPT4
    INT 21H
    
    MOV AH, 2
    MOV DL, REMAINDER
    ADD DL, '0'
    INT 21H 
    
    ; EXIT DOS
    MOV AH, 4CH
    INT 21H
             
MAIN ENDP

END MAIN