        INCLUDE common_defs.s

        AREA UART_CODE, CODE, READONLY
        EXPORT UART_PaySlip
		EXPORT Enable_ITM

; ITM registers
ITM_STIM0      EQU 0xE0000000
ITM_TCR        EQU 0xE0000E80
ITM_TER        EQU 0xE0000E00
DEMCR          EQU 0xE000EDFC
ITM_LAR        EQU 0xE0000FB0

;---------------------------------------------------------
; Enable ITM
;---------------------------------------------------------
Enable_ITM
        PUSH {LR}

        LDR  R0, =DEMCR
        LDR  R1, [R0]
        ORR  R1, R1, #(1 << 24)
        STR  R1, [R0]

        LDR  R0, =ITM_LAR
        LDR  R1, =0xC5ACCE55
        STR  R1, [R0]

        LDR  R0, =ITM_TCR
        LDR  R1, =0x0001000D
        STR  R1, [R0]

        LDR  R0, =ITM_TER
        MOVS R1, #1
        STR  R1, [R0]

        POP  {LR}
        BX   LR

;---------------------------------------------------------
; Send single byte via ITM
;---------------------------------------------------------
UART_SendByte
        PUSH {LR}
        BL   ITM_SendChar
        POP  {LR}
        BX   LR

ITM_SendChar
        PUSH {R1, LR}
        LDR  R1, =ITM_TCR
        LDR  R1, [R1]
        TST  R1, #1
        BEQ  ITM_Exit
        LDR  R1, =ITM_STIM0
        STRB R0, [R1]
ITM_Exit
        POP  {R1, LR}
        BX   LR

;---------------------------------------------------------
; Send string
;---------------------------------------------------------
UART_SendString
        PUSH {R1, R2, LR}
StrLoop
        LDRB R1, [R0]
        CMP  R1, #0
        BEQ  StrDone
        MOV  R2, R0
        MOV  R0, R1
        BL   UART_SendByte
        MOV  R0, R2
        ADD  R0, R0, #1
        B    StrLoop
StrDone
        POP {R1, R2, LR}
        BX   LR

;---------------------------------------------------------
; Send newline
;---------------------------------------------------------
UART_NewLine
        PUSH {LR}
        MOVS R0, #13
        BL   UART_SendByte
        MOVS R0, #10
        BL   UART_SendByte
        POP  {LR}
        BX   LR

;---------------------------------------------------------
; Send unsigned 32-bit number as decimal
;---------------------------------------------------------
UART_SendNumber
        PUSH {R1-R7, LR}
        MOV  R1, R0
        LDR  R2, =DivTable
        MOVS R7, #0
DigitLoop
        LDR  R3, [R2], #4
        CMP  R3, #0
        BEQ  NumDone
        MOVS R4, #0
CountLoop
        CMP  R1, R3
        BLT  WriteDigit
        SUBS R1, R1, R3
        ADDS R4, R4, #1
        B    CountLoop
WriteDigit
        CMP  R7, #0
        BEQ  SkipLead
        ADD  R0, R4, #'0'
        BL   UART_SendByte
        B    DigitLoop
SkipLead
        CMP  R4, #0
        BEQ  DigitLoop
        MOVS R7, #1
        ADD  R0, R4, #'0'
        BL   UART_SendByte
        B    DigitLoop
NumDone
        CMP  R7, #0
        BNE  ExitNum
        MOVS R0, #'0'
        BL   UART_SendByte
ExitNum
        POP {R1-R7, LR}
        BX   LR

DivTable
        DCD 10000,1000,100,10,1,0

;---------------------------------------------------------
; UART pay-slip routine
;---------------------------------------------------------
UART_PaySlip
        PUSH {R4-R12, LR}

        LDR  R4, =EMP_TABLE_BASE        ; employee record base
        MOVS R5, #0                  ; employee index

EmpLoop
        CMP  R5, #5                  ; number of employees
        BGE  Done

        ; Employee ID
        LDR  R1, [R4, #OFF_ID]
        LDR  R0, =str_ID
        BL   UART_SendString
        MOV  R0, R1
        BL   UART_SendNumber
        BL   UART_NewLine

        ; Net Salary
        LDR  R0, =str_Net
        BL   UART_SendString
        LDR  R0, [R4, #OFF_NETSAL]
        BL   UART_SendNumber
        BL   UART_NewLine
        
		 ; tax
        LDR     R1, =TAX_TABLE      ; allowance table
        LDR     R0, =str_Tax
        BL      UART_SendString
        LDR     R0, [R1, R5, LSL #2] ; first allowance value for employee index
        BL      UART_SendNumber
        BL      UART_NewLine
		
			   ; Allowance (fetch from pointer in record)
		LDR     R1, =ALLOW_TABLE      ; allowance table
        LDR     R0, =str_Allow
        BL      UART_SendString
        LDR     R0, [R1, R5, LSL #2] ; first allowance value for employee index
        BL      UART_SendNumber
        BL      UART_NewLine



        ; Bonus
        LDR  R0, =str_Bonus
        BL   UART_SendString
        LDR  R0, [R4, #OFF_BONUS]
        BL   UART_SendNumber
        BL   UART_NewLine

        ; Final Pay = Net + Bonus
		LDR  R0, =str_Final
        BL   UART_SendString
        LDR  R1, [R4, #OFF_NETSAL]
        LDR  R0, [R4, #OFF_BONUS]
        ADDS R0, R0, R1
        BL   UART_SendNumber
        BL   UART_NewLine
        BL   UART_NewLine

        ; next employee
        ADDS R5, R5, #1
        ADD  R4, R4, #RECORD_SIZE
        B    EmpLoop

Done
        POP {R4-R12, LR}
        BX  LR

;---------------------------------------------------------
        AREA UART_STR, DATA, READONLY
str_ID      DCB "Employee ID: ",0
str_Net     DCB "Net Salary: ",0
str_Tax     DCB "Tax: ",0
str_Allow   DCB "Allowance: ",0
str_Bonus   DCB "Bonus: ",0
str_Final   DCB "Final Pay: ",0

        END