	INCLUDE common_defs.s

    AREA TAX_CODE, CODE, READONLY
    EXPORT TaxCalc

TaxCalc
	PUSH    {R4-R7, LR}
	LDR     R4, =EMP_TABLE_BASE
	MOVS    R5, #0
	LDR     R8, =ALLOW_TABLE
	LDR     R9, =OTPAY_TABLE
	LDR     R10, =TAX_TABLE

TaxLoop
	LDR     R1, [R4, #8]           ; base
	LDR     R2, [R8, R5, LSL #2]   ; allowance
	LDR     R3, [R9, R5, LSL #2]   ; ot_pay
	ADDS    R6, R1, R2
	ADDS    R6, R6, R3             ; gross_salary

   
	LDR     R7, =30000
    CMP     R6, R7
    BLE     Tax0
	LDR     R7, =60000
    CMP     R6, R7
    BLE     Tax5
	LDR     R7, =120000
    CMP     R6, R7
    BLE     Tax10
    B       Tax15

Tax0
	MOVS    R7, #0
	B       CalcStoreTax
Tax5
	MOVS    R7, #5
	B       CalcStoreTax
Tax10
	MOVS    R7, #10
	B       CalcStoreTax
Tax15
	MOVS    R7, #15

CalcStoreTax
	MUL     R11, R6, R7
	LDR     R12, =100
	SDIV    R11, R11, R12
	STR     R11, [R10, R5, LSL #2]

    ADD     R4, R4, #RECORD_SIZE
    ADDS    R5, R5, #1
    CMP     R5, #NUM_EMPLOYEES
    BLT     TaxLoop

    POP     {R4-R7, LR}
    BX      LR
    END