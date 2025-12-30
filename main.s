	INCLUDE common_defs.s

    AREA MAIN_CODE, CODE, READONLY
    EXPORT main

    EXTERN InitEmployees
    EXTERN LoadAttendance
    EXTERN LeaveManagement
    EXTERN OvertimeCalc
    EXTERN AllowanceCalc
    EXTERN TaxCalc
    EXTERN NetSalaryCalc
    EXTERN DeptSummary
    EXTERN BonusCalc
	EXTERN SortEmployees
    EXTERN UART_PaySlip
	EXTERN Enable_ITM

main
	PUSH    {R4-R7, LR}
	BL      InitEmployees
	BL      LoadAttendance
	BL      LeaveManagement
	BL      OvertimeCalc
	BL      AllowanceCalc
	BL      TaxCalc
	BL      NetSalaryCalc
	BL      DeptSummary
	BL      BonusCalc
	BL      SortEmployees
	BL      Enable_ITM
	BL      UART_PaySlip
	POP     {R4-R7, LR}
loop_end
	B       loop_end
	END
