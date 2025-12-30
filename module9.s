        INCLUDE common_defs.s

        AREA SUMMARY_CODE, CODE, READONLY
        EXPORT DeptSummary

DeptSummary
        PUSH    {R4-R11, LR}

        ; Clear summary (IT, HR, Others)
        LDR     R12, =SUMMARY_BASE
        MOVS    R0, #0
        STR     R0, [R12, #0]     ; IT
        STR     R0, [R12, #4]     ; HR
        STR     R0, [R12, #8]     ; Others

        ; Init
        LDR     R4, =EMP_TABLE_BASE
        MOVS    R5, #0            ; index
        MOVS    R6, #0            ; IT sum
        MOVS    R7, #0            ; HR sum
        MOVS    R8, #0            ; Others sum

SumLoop
        LDR     R10, [R4, #OFF_NETSAL]   ; net salary
        LDRB    R11, [R4, #OFF_DEPTCODE] ; dept

        CMP     R11, #1
        BEQ     AddIT
        CMP     R11, #2
        BEQ     AddHR

        ; Others
        ADDS    R8, R8, R10
        B       NextEmp

AddIT
        ADDS    R6, R6, R10
        B       NextEmp

AddHR
        ADDS    R7, R7, R10

NextEmp
        ADD     R4, R4, #RECORD_SIZE
        ADDS    R5, R5, #1
        CMP     R5, #NUM_EMPLOYEES
        BLT     SumLoop

        ; Store summary
        LDR     R12, =SUMMARY_BASE
        STR     R6, [R12, #0]     ; IT
        STR     R7, [R12, #4]     ; HR
        STR     R8, [R12, #8]     ; Others

        POP     {R4-R11, LR}
        BX      LR

        END