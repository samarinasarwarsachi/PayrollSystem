        INCLUDE common_defs.s

        AREA BONUS_CODE, CODE, READONLY
        EXPORT BonusCalc

BonusCalc
        PUSH    {R4-R11, LR}

        LDR     R4, =EMP_TABLE_BASE      ; employee table base
        LDR     R6, =SCORES_BASE         ; performance scores
        LDR     R7, =BONUS_TABLE         ; bonus output

        MOVS    R5, #0                   ; employee index

BonusLoop
        ; Load performance score
        LDR     R1, [R6, R5, LSL #2]

        ; Load base salary 
        LDR     R2, [R4, #8]

        ; ----- Bonus rules -----
        CMP     R1, #90
        BGE     Bonus25
        CMP     R1, #75
        BGE     Bonus15
        CMP     R1, #60
        BGE     Bonus8

        MOVS    R3, #0
        B       CalcDone

Bonus25
        MOVS    R3, #25
        B       CalcDone
Bonus15
        MOVS    R3, #15
        B       CalcDone
Bonus8
        MOVS    R3, #8

CalcDone
        ; R3 = %     |   bonus = salary * percent / 100
        MUL     R3, R2, R3
        LDR     R8, =100
        SDIV    R3, R3, R8

        ; Store into BONUS_TABLE
        STR     R3, [R7, R5, LSL #2]

        ; Store INTO EMPLOYEE RECORD BONUS FIELD
        STR     R3, [R4, #40]

        ; next employee
        ADDS    R5, #1

        
        MOV     R9, #44
        ADD     R4, R4, R9

        CMP     R5, #NUM_EMPLOYEES
        BLT     BonusLoop

        POP     {R4-R11, LR}
        BX      LR

        END