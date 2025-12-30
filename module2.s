		INCLUDE common_defs.s

        AREA    |ATT_CODE|, CODE, READONLY
        EXPORT  LoadAttendance

; LoadAttendance:
; For each employee:
;   R4 -> employee record base (EMP_TABLE_BASE + idx*RECORD_SIZE)
;   R6 -> attendance base pointer (word read from employee struct offset #20)
;   STRB count into [R4, #28]

LoadAttendance
        PUSH    {R4-R7, LR}

        LDR     R4, =EMP_TABLE_BASE   ; R4 points to first employee record
        MOVS    R5, #0                 ; employee index = 0

EmpLoop
        ; load attendance pointer from employee struct (offset #20)
        LDR     R6, [R4, #20]          ; R6 = attendance base (word)

        MOVS    R7, #0                 ; present-days counter
        MOVS    R3, #0                 ; day index 

DayLoop
        LDRB    R2, [R6, R3]           ; load attendance byte for day
        CMP     R2, #1
        BEQ     IncCount
        B       SkipInc

IncCount
        ADDS    R7, R7, #1

SkipInc
        ADDS    R3, R3, #1
        CMP     R3, #31
        BLT     DayLoop

        ; store the present-days (byte) into employee record offset #28
        STRB    R7, [R4, #28]

        ; next employee
        ADD     R4, R4, #RECORD_SIZE
        ADDS    R5, R5, #1
        CMP     R5, #NUM_EMPLOYEES
        BLT     EmpLoop

        POP     {R4-R7, LR}
        BX      LR

        END