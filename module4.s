		INCLUDE common_defs.s

        AREA    |OT_CODE|, CODE, READONLY
        EXPORT  OvertimeCalc

; For each employee:
;  - read OT hours from OT_BASE + idx*4
;  - read grade from employee record offset #12 (byte)
;  - rate lookup: A -> 250, B -> 200, C or others -> 150
;  - ot_pay = ot_hours * rate
;  - store ot_pay (word) into OTPAY_TABLE[idx]

OvertimeCalc
        PUSH    {R4-R7, LR}

        LDR     R4, =EMP_TABLE_BASE    ; R4 -> employee base
        MOVS    R5, #0                 ; index = 0
        LDR     R8, =OTPAY_TABLE       ; destination table
        LDR     R6, =OT_BASE           ; OT hours table

LoopEmp
        ; load ot hours (word)
        LDR     R1, [R6, R5, LSL #2]   ; R1 = ot_hours

        ; load grade byte (offset #12)
        LDRB    R2, [R4, #12]          ; R2 = grade

        ; default rate = 150 (for grade C or others)
        LDR     R7, =150

        ; check grade A
        CMP     R2, #'A'
        BEQ     GradeA

        ; check grade B
        CMP     R2, #'B'
        BEQ     GradeB

        ; grade C or other ? keep rate=150
        B       ComputeOT

GradeA
        LDR     R7, =250
        B       ComputeOT

GradeB
        LDR     R7, =200
        B       ComputeOT

ComputeOT
        ; ot_pay = ot_hours * rate
        MUL     R3, R1, R7

        ; store ot_pay into OTPAY_TABLE
        STR     R3, [R8, R5, LSL #2]

        ; next employee
        ADD     R4, R4, #RECORD_SIZE
        ADDS    R5, R5, #1
        CMP     R5, #NUM_EMPLOYEES
        BLT     LoopEmp

        POP     {R4-R7, LR}
        BX      LR

        END