	INCLUDE common_defs.s

    AREA MAIN_CODE, CODE, READONLY
    EXPORT main

    EXTERN InitEmployees
	EXTERN BonusCalc
    

main
	PUSH    {R4-R7, LR}
	BL      InitEmployees
	BL      BonusCalc
	
	POP     {R4-R7, LR}
loop_end
	B       loop_end
	END
