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
    
    CALL PROC1
           
    ; EXIT TO DOS
    MOV AH, 4CH
    INT 21H
    
MAIN ENDP

PROC1 PROC
    
    ; POPPING THE RETURN ADDRESS :3 SEE WHAT HAPPENS!!
    POP AX
         
    RET         
PROC1 ENDP

END MAIN
