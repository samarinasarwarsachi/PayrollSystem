        INCLUDE common_defs.s

        AREA SORT_CODE, CODE, READONLY
        EXPORT SortEmployees
        THUMB

SortEmployees
        PUSH {R4-R11, LR}

; ======================================================
; 1. COPY EMP_TABLE_BASE -> SORT_DEST
; ======================================================

        LDR     R4, =EMP_TABLE_BASE     ; source
        LDR     R5, =SORT_DEST          ; destination
        MOVS    R6, #0                  ; employee index

CopyLoop
        MOVS    R7, #RECORD_SIZE        ; 44 bytes per record

CopyRecord
        LDRB    R8, [R4], #1
        STRB    R8, [R5], #1
        SUBS    R7, R7, #1
        BNE     CopyRecord

        ADDS    R6, R6, #1
        CMP     R6, #NUM_EMPLOYEES
        BLT     CopyLoop


; ======================================================
; 2. SELECTION SORT ON SORT_DEST BY NET SALARY
; ======================================================

        MOVS    R7, #0                  ; i = 0

OuterLoop
        CMP     R7, #NUM_EMPLOYEES
        BGE     EndSort

        ; ------------------------------------------------
        ; max_index = i
        ; max_value = SORT_DEST[i].net_salary
        ; ------------------------------------------------
        MOV     R8, R7                  ; max_index

        LDR     R0, =SORT_DEST
        MOV     R1, R7
        MOVS    R2, #RECORD_SIZE
        MUL     R1, R1, R2
        ADD     R0, R0, R1

        LDR     R9, [R0, #OFF_NETSAL]   ; max_value

        ADDS    R11, R7, #1             ; j = i + 1

InnerLoop
        CMP     R11, #NUM_EMPLOYEES
        BGE     EndInner

        ; -----------------------------------------------
        ; load SORT_DEST[j].net_salary
        ; -----------------------------------------------
        LDR     R0, =SORT_DEST
        MOV     R1, R11
        MOVS    R2, #RECORD_SIZE
        MUL     R1, R1, R2
        ADD     R0, R0, R1

        LDR     R3, [R0, #OFF_NETSAL]
        CMP     R3, R9
        BLE     NoUpdate

        MOV     R9, R3
        MOV     R8, R11

NoUpdate
        ADDS    R11, R11, #1
        B       InnerLoop

EndInner
        CMP     R8, R7
        BEQ     NoSwap

; ======================================================
; 3. SWAP FULL 44-BYTE RECORDS IN SORT_DEST
; ======================================================

        ; addr A = SORT_DEST + i * 44
        LDR     R0, =SORT_DEST
        MOV     R1, R7
        MOVS    R2, #RECORD_SIZE
        MUL     R1, R1, R2
        ADD     R0, R0, R1

        ; addr B = SORT_DEST + max_index * 44
        LDR     R3, =SORT_DEST
        MOV     R4, R8
        MOVS    R5, #RECORD_SIZE
        MUL     R4, R4, R5
        ADD     R3, R3, R4

        ; swap 11 words (44 bytes)
        MOVS    R10, #0

SwapLoop
        LDR     R11, [R0, R10, LSL #2]
        LDR     R12, [R3, R10, LSL #2]
        STR     R12, [R0, R10, LSL #2]
        STR     R11, [R3, R10, LSL #2]

        ADDS    R10, R10, #1
        CMP     R10, #11
        BLT     SwapLoop

NoSwap
        ADDS    R7, R7, #1
        B       OuterLoop

EndSort
        POP {R4-R11, LR}
        BX  LR

        END