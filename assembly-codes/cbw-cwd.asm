.MODEL SMALL

.STACK 100H

.DATA

.CODE

MAIN PROC
    
    MOV AL, 0FFH ; AL = OFFH
    CBW  ; AX = OFFFFH
    CWD  ; DX = OFFFFH AX = 0FFFFH
    
    
    ; EXIT DOS
    MOV AH, 4CH
    INT 21H
             
MAIN ENDP

END MAIN
