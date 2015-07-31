*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: spHandleODBCError()
* Called by.......: <NA>
* Parameters......: <taErrors>
* Returns.........: <none>
* Notes...........: Обработка ошибок ODBC
*------------------------------------------------------------------------------
PROCEDURE spHandleODBCError

*28.07.2006 09:38 ->Объявление и инициализация переменных
LOCAL	lnErrorRowsCount, ;
		lnCounter, ;
		lcErrorMessage
***
LOCAL ARRAY laErrors[1]
***
lcErrorMessage = []
*------------------------------------------------------------------------------

*21.01.2004 18:52 -> Прочитаем информацию об ошибке
lnErrorRowsCount = AERROR(laErrors)
*------------------------------------------------------------------------------

*28.07.2006 09:37 -> Последовательно обработаем все ошибки 
FOR lnCounter = 1 TO lnErrorRowsCount
	IF laErrors[lnCounter,5] # 50001
		lcErrorMessage = lcErrorMessage + STRTRAN(laErrors[lnCounter,3],pcvERRORHEADMSG,[* ]) + CHR(13)
	ENDIF
	STRTOFILE(TTOC(DATETIME())+[ -> ] + STRTRAN(laErrors[lnCounter,3],pcvERRORHEADMSG,[]) + CHR(13),[Error.log],1)
ENDFOR
*------------------------------------------------------------------------------

*28.07.2006 09:46 -> Выводим сообщение пользователю
IF lnErrorRowsCount > 0
	MESSAGEBOX(lcErrorMessage,16,[Ошибка соединения...])
ENDIF
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
