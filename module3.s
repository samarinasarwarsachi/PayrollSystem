		INCLUDE common_defs.s

        AREA    |LEAVE_CODE|, CODE, READONLY
        EXPORT  LeaveManagement

; LeaveManagement:
; For each employee:
;  - read present-days at offset #28 (byte)
;  - if present < 22:
;       leave_deficit = 22 - present
;       deduction = leave_deficit * 300
;       store deduction (word) at offset #24
;       if leave_deficit > 5 -> set LDEFICIT flag (byte) at offset #27 = 1
;    else
;       store deduction = 0 and LDEFICIT = 0

LeaveManagement
        PUSH    {R4-R7, LR}

        LDR     R4, =EMP_TABLE_BASE    ; R4 -> first employee record
        MOVS    R5, #0                 ; index = 0

LoopEmployees
        ; load present days (byte) from offset #28
        LDRB    R6, [R4, #28]          ; R6 = present_days

        MOVS    R7, #22
        CMP     R6, R7
        BGE     NoDeductionNeeded

        ; compute leave_deficit = 22 - present_days
        SUBS    R7, R7, R6             ; R7 = deficit

        ; deduction = deficit * 300
        LDR     R1, =300
        MUL     R2, R7, R1             ; R2 = deduction

        ; store deduction word at offset #24
        STR     R2, [R4, #24]

        ; set LDEFICIT flag if deficit > 5
        MOVS    R3, #5
        CMP     R7, R3
        BLE     SmallDeficit
        MOVS    R3, #1
        STRB    R3, [R4, #27]          ; set flag
        B       LeaveNext

SmallDeficit
        MOVS    R3, #0
        STRB    R3, [R4, #27]

        B       LeaveNext

NoDeductionNeeded
        ; store 0 deduction and clear flag
        MOVS    R2, #0
        STR     R2, [R4, #24]
        MOVS    R3, #0
        STRB    R3, [R4, #27]

LeaveNext
        ADD     R4, R4, #RECORD_SIZE
        ADDS    R5, R5, #1
        CMP     R5, #NUM_EMPLOYEES
        BLT     LoopEmployees

        POP     {R4-R7, LR}
        BX      LR

        END