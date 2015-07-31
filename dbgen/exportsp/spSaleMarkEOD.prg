*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spSaleMarkEOD()
* Called by.......: <NA>
* Parameters......: <none>
* Returns.........: <tnSalesLogID>
* Notes...........: Закрытие дня
*------------------------------------------------------------------------------
PROCEDURE spSaleMarkEOD
LPARAMETERS tnSalesLogID

*29.04.2006 17:49 ->Объявление и инициализация переменных
LOCAL   lnRecCount, ;
		llResult
*------------------------------------------------------------------------------  

*07.04.2006 16:13 -> Коннектимся к БД через существующее соединение
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> Проверим, существуют ли открытые кассы в этом дне кассы
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[SELECT ] + ;
			[POSActivity.POSActCloseStamp ] + ;
		[FROM POSActivity ] + ;
		[WHERE POSActivity.POSActSLID = ?tnSalesLogID AND POSActivity.POSActCloseStamp IS NULL], ;
		[curOpenDay])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
***
lnRecCount = RECCOUNT([curOpenDay])
*------------------------------------------------------------------------------

*29.04.2006 17:49 ->Закрываем курсор
USE IN SELECT([curOpenDay])
*------------------------------------------------------------------------------

IF lnRecCount = 0

	*12.04.2006 14:04 ->Закрываем день
	lnSqlExeResult = 0
	***
	DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
		lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
			[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
			[UPDATE SalesLog ] + ;
			[SET Stamp = GETDATE(), ] + ;
				[EOD = 1 ] + ;
			[WHERE SalesLog.SalesLogID = ?tnSalesLogID])
	ENDDO
	***
	IF lnSqlExeResult = -1
		spHandleODBCError()
		RETURN .F.
	ENDIF
	*------------------------------------------------------------------------------

	llResult = .T.

ELSE

	llResult = .F.

ENDIF

*07.04.2006 16:12 -> Делаем дисконнект: освобождаем соединение
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

RETURN llResult

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
