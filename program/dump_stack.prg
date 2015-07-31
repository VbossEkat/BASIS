*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: DUMP_STACK.PRG
* Module/Procedure: DUMP_STACK()
* Called by.......: <NA>
* Parameters......: <none>
* Returns.........: <none>
* Notes...........: ~
*-------------------------------------------------------

*06.12.2004 17:18 ->Объявление и инициализация переменных
LOCAL	lnFileHandler, ;
		lnCounter, ;
		lcProgram
*------------------------------------------------------------------------------

*06.12.2004 17:18 ->Откроем/создадим файл
IF !FILE([tmp\dump_stack.txt])
	lnFileHandler = FCREATE([tmp\dump_stack.txt])
ELSE
	lnFileHandler = FOPEN([tmp\dump_stack.txt],2)
	FSEEK(lnFileHandler,0,2)
ENDIF
***
FPUTS(lnFileHandler,REPLICATE([=],80))
FPUTS(lnFileHandler,[STACK DUMP Started ]+TTOC(DATETIME()))
*------------------------------------------------------------------------------

*06.12.2004 17:19 ->Экспортируем стэк
FOR lnCounter = 1 TO 128
	lcProgram = PROGRAM(lnCounter)
	IF !EMPTY(lcProgram)
		FPUTS(lnFileHandler,lcProgram)
	ELSE
		EXIT
	ENDIF
ENDFOR &&* lnCounter = 0 TO 128
*------------------------------------------------------------------------------

*06.12.2004 17:22 ->Закроем файл
FPUTS(lnFileHandler,[STACK DUMP Ended ]+TTOC(DATETIME()))
FPUTS(lnFileHandler,REPLICATE([=],80)+CHR(13)+CHR(13))
FCLOSE(lnFileHandler)
*------------------------------------------------------------------------------