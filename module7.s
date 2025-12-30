        INCLUDE common_defs.s

        AREA NET_CODE, CODE, READONLY
        EXPORT NetSalaryCalc

NetSalaryCalc
        PUSH {R4-R11, LR}

        LDR     R4, =EMP_TABLE_BASE        ; employee table
        MOVS    R5, #0                     ; index = 0

        LDR     R8, =ALLOW_TABLE
        LDR     R9, =OTPAY_TABLE
        LDR     R10, =TAX_TABLE
        LDR     R12, =OVERFLOW_FLAG_ADDR

NetLoop
        ; -------------------------------
        ; Load base values
        ; -------------------------------
        LDR     R1, [R4, #OFF_BASESAL]     ; base salary
        LDR     R2, [R8, R5, LSL #2]       ; allowance
        LDR     R3, [R9, R5, LSL #2]       ; OT pay
        LDR     R7, [R10, R5, LSL #2]      ; tax

        ; -------------------------------
        ; Load leave deduction (2 bytes)
        ; OFF_DEDUCT = 24
        ; -------------------------------
        LDRB    R6,  [R4, #24]             ; low byte
        LDRB    R11, [R4, #25]             ; high byte
        ORR     R6, R6, R11, LSL #8        ; R6 = deduction

        ; -------------------------------
        ; Net salary calculation
        ; net = base + allow + ot - tax - deduct
        ; -------------------------------
        ADDS    R0, R1, R2
        ADDS    R0, R0, R3
        SUBS    R0, R0, R7
        SUBS    R0, R0, R6

        ; -------------------------------
        ; Clamp negative result to 0
        ; -------------------------------
        BPL     StoreNet
        MOVS    R0, #0

StoreNet
        STR     R0, [R4, #OFF_NETSAL]

        ; no overflow handling needed now
        MOVS    R1, #0
        STRB    R1, [R12, R5]

        ; -------------------------------
        ; Next employee
        ; -------------------------------
        ADDS    R5, R5, #1
        ADD     R4, R4, #RECORD_SIZE
        CMP     R5, #NUM_EMPLOYEES
        BLT     NetLoop

        POP {R4-R11, LR}
        BX  LR

        END