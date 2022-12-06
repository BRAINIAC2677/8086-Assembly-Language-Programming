.MODEL SMALL

.STACK 100H

.DATA
    FIRST DW 01234H
    SEC DW ?
    
.CODE      

MAIN PROC          
    
    ; LOADING DATA
    MOV AX, @DATA
    MOV DS, AX    
    
    MOV AX, 01234H
    MOV BX, 05678H
    
    ; SWAPPING AX, BX 
    PUSH AX
    PUSH BX
    POP AX
    POP BX 
    
    ; PUSHING AND POPPING VARIABLE
    PUSH FIRST
    POP SEC
           
    ; EXIT TO DOS
    MOV AH, 4CH
    INT 21H
    
MAIN ENDP

END MAIN
