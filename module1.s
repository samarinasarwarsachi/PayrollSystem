        INCLUDE common_defs.s
       
		AREA |.text|, CODE, READONLY
        EXPORT InitEmployees
        THUMB

; ----------------------------
; Constants / Layout
; ----------------------------
RECORD_BASE    EQU 0x20000000
ATT_BASE       EQU 0x20001000


; ----------------------------
; Sample name strings
; ----------------------------
        AREA |.rodata|, DATA, READONLY
name_emp0    DCB "Ahsan",0
name_emp1    DCB "Maya",0
name_emp2    DCB "Rafiq",0
name_emp3    DCB "Shaila",0
name_emp4    DCB "Tanvir",0
        ALIGN

; ----------------------------
; Code
; ----------------------------
        AREA |.text|, CODE, READONLY
InitEmployees
        PUSH    {r4-r7, lr}

        LDR     r4, =RECORD_BASE        ; current record base

; --- Employee 1 ---
        LDR     r0, =0x00000001
        STR     r0, [r4, #OFF_ID]
        LDR     r0, =name_emp0
        STR     r0, [r4, #OFF_NAMEPTR]
        LDR     r0, =40000
        STR     r0, [r4, #OFF_BASESAL]
        MOVS    r0, #0x41
        STRB    r0, [r4, #OFF_JOBGRADE]
        MOVS    r0, #0x01
        STRB    r0, [r4, #OFF_DEPTCODE]
        LDR     r0, =0x12345678
        STR     r0, [r4, #OFF_BANKACC]
        LDR     r0, =ATT_BASE
        STR     r0, [r4, #OFF_ATT_PTR]
        MOVS    r0, #0
        STR     r0, [r4, #OFF_DEDUCT]      ; leave deduction
        MOVS    r0, #0
        STR     r0, [r4, #OFF_PRESENT]
        LDR     r0, =ALLOW_TABLE
        STR     r0, [r4, #OFF_ALLOW_PTR]   ; allowance pointer
        MOVS    r0, #0
        STR     r0, [r4, #OFF_NETSAL]
        MOVS    r0, #0
        STR     r0, [r4, #OFF_BONUS]

        ADDS    r4, r4, #RECORD_SIZE

; --- Employee 2 ---
        LDR     r0, =0x00000002
        STR     r0, [r4, #OFF_ID]
        LDR     r0, =name_emp1
        STR     r0, [r4, #OFF_NAMEPTR]
        LDR     r0, =32000
        STR     r0, [r4, #OFF_BASESAL]
        MOVS    r0, #0x42
        STRB    r0, [r4, #OFF_JOBGRADE]
        MOVS    r0, #0x02
        STRB    r0, [r4, #OFF_DEPTCODE]
        LDR     r0, =0x23456789
        STR     r0, [r4, #OFF_BANKACC]
        LDR     r0, =(ATT_BASE + 0x100)
        STR     r0, [r4, #OFF_ATT_PTR]
        MOVS    r0, #0
        STR     r0, [r4, #OFF_DEDUCT]
        MOVS    r0, #0
        STR     r0, [r4, #OFF_PRESENT]
        LDR     r0, =ALLOW_TABLE
        STR     r0, [r4, #OFF_ALLOW_PTR]
        MOVS    r0, #0
        STR     r0, [r4, #OFF_NETSAL]
        MOVS    r0, #0
        STR     r0, [r4, #OFF_BONUS]

        ADDS    r4, r4, #RECORD_SIZE

; --- Employee 3 ---
        LDR     r0, =0x00000003
        STR     r0, [r4, #OFF_ID]
        LDR     r0, =name_emp2
        STR     r0, [r4, #OFF_NAMEPTR]
        LDR     r0, =25000
        STR     r0, [r4, #OFF_BASESAL]
        MOVS    r0, #0x43
        STRB    r0, [r4, #OFF_JOBGRADE]
        MOVS    r0, #0x03
        STRB    r0, [r4, #OFF_DEPTCODE]
        LDR     r0, =0x34567890
        STR     r0, [r4, #OFF_BANKACC]
        LDR     r0, =(ATT_BASE + 0x200)
        STR     r0, [r4, #OFF_ATT_PTR]
        MOVS    r0, #0
        STR     r0, [r4, #OFF_DEDUCT]
        MOVS    r0, #0
        STR     r0, [r4, #OFF_PRESENT]
        LDR     r0, =ALLOW_TABLE
        STR     r0, [r4, #OFF_ALLOW_PTR]
        MOVS    r0, #0
        STR     r0, [r4, #OFF_NETSAL]
        MOVS    r0, #0
        STR     r0, [r4, #OFF_BONUS]

        ADDS    r4, r4, #RECORD_SIZE

; --- Employee 4 ---
        LDR     r0, =0x00000004
        STR     r0, [r4, #OFF_ID]
        LDR     r0, =name_emp3
        STR     r0, [r4, #OFF_NAMEPTR]
        LDR     r0, =55000
        STR     r0, [r4, #OFF_BASESAL]
        MOVS    r0, #0x41
        STRB    r0, [r4, #OFF_JOBGRADE]
        MOVS    r0, #0x01
        STRB    r0, [r4, #OFF_DEPTCODE]
        LDR     r0, =0x45678901
        STR     r0, [r4, #OFF_BANKACC]
        LDR     r0, =(ATT_BASE + 0x300)
        STR     r0, [r4, #OFF_ATT_PTR]
        MOVS    r0, #0
        STR     r0, [r4, #OFF_DEDUCT]
        MOVS    r0, #0
        STR     r0, [r4, #OFF_PRESENT]
        LDR     r0, =ALLOW_TABLE
        STR     r0, [r4, #OFF_ALLOW_PTR]
        MOVS    r0, #0
        STR     r0, [r4, #OFF_NETSAL]
        MOVS    r0, #0
        STR     r0, [r4, #OFF_BONUS]

        ADDS    r4, r4, #RECORD_SIZE

; --- Employee 5 ---
        LDR     r0, =0x00000005
        STR     r0, [r4, #OFF_ID]
        LDR     r0, =name_emp4
        STR     r0, [r4, #OFF_NAMEPTR]
        LDR     r0, =18000
        STR     r0, [r4, #OFF_BASESAL]
        MOVS    r0, #0x43
        STRB    r0, [r4, #OFF_JOBGRADE]
        MOVS    r0, #0x02
        STRB    r0, [r4, #OFF_DEPTCODE]
        LDR     r0, =0x56789012
        STR     r0, [r4, #OFF_BANKACC]
        LDR     r0, =(ATT_BASE + 0x400)
        STR     r0, [r4, #OFF_ATT_PTR]
        MOVS    r0, #0
        STR     r0, [r4, #OFF_DEDUCT]
        MOVS    r0, #0
        STR     r0, [r4, #OFF_PRESENT]
        LDR     r0, =ALLOW_TABLE
        STR     r0, [r4, #OFF_ALLOW_PTR]
        MOVS    r0, #0
        STR     r0, [r4, #OFF_NETSAL]
        MOVS    r0, #0
        STR     r0, [r4, #OFF_BONUS]

        POP     {r4-r7, pc}
        END
