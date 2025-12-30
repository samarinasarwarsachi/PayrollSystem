	INCLUDE common_defs.s

    AREA ALLOW_CODE, CODE, READONLY
    EXPORT AllowanceCalc

AllowanceCalc
	PUSH    {R4-R7, LR}
	LDR     R4, =EMP_TABLE_BASE
	MOVS    R5, #0
	LDR     R8, =ALLOW_TABLE

AllowLoop
	LDR     R1, [R4, #8]           ; base salary
	MOVS    R2, #20
	MUL     R3, R1, R2
	MOVS    R2, #100
	SDIV    R3, R3, R2              ; HRA = base*20/100

    MOV    R2, #3000
    ADDS    R3, R3, R2              ; HRA + medical

    LDRB    R6, [R4, #13]           ; dept
    CMP     R6, #1
    BEQ     AddIT
    CMP     R6, #2
    BEQ     AddHR
    MOV    R2, #3500
    B       StoreAllow

AddIT
	MOV    R2, #5000
	B       StoreAllow

AddHR
	MOVS    R2, #4000

StoreAllow
	ADDS    R3, R3, R2
	STR     R3, [R8, R5, LSL #2]

    ADD     R4, R4, #RECORD_SIZE
    ADDS    R5, R5, #1
    CMP     R5, #NUM_EMPLOYEES
    BLT     AllowLoop

    POP     {R4-R7, LR}
    BX      LR
    END