*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spSaleOpenDay()
* Called by.......: <NA>
* Parameters......: <tnCashID>
* Returns.........: <none>
* Notes...........: Открытие дня
*------------------------------------------------------------------------------
PROCEDURE spSaleOpenDay
PARAMETERS tnCashID

*29.04.2006 15:14 ->Объявление и инициализация переменных
LOCAL   lnRecCount, ;
		lnSLID, ;
		ltPOSActCloseStamp, ;
		lnConnectHandle, ;
		lnSqlExeResult
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> Коннектимся к БД через существующее соединение
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> Проверим, существует ли открытый день
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[SELECT ] + ;
			[SalesLog.SalesLogID ] + ;
		[FROM SalesLog ] + ;
		[WHERE SalesLog.EOD = 0], ;
		[curSalesLog])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
***
lnRecCount = RECCOUNT([curSalesLog])
lnSLID = curSalesLog.SalesLogID
*------------------------------------------------------------------------------

*29.04.2006 15:14 -> Закроем курсор
USE IN SELECT([curSalesLog])
*------------------------------------------------------------------------------

*29.04.2006 17:00 ->
DO CASE
	CASE lnRecCount>1
		RETURN -2 && осталось открытыми более одного дня
	CASE lnRecCount=0
	
		*07.04.2006 16:45 -> Открываем системный день
		lnSqlExeResult = 0
		***
		DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
			lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
				[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
				[INSERT INTO SalesLog ] + ;
					[(StampOpenDay,EOD) ] + ;
				[VALUES ] + ;
					[(GETDATE(),0) ] + ;
				[SELECT SCOPE_IDENTITY() AS LastID], ;
				[curSLID])
		ENDDO
		***
		IF lnSqlExeResult = -1
			spHandleODBCError()
			RETURN
		ENDIF
		*------------------------------------------------------------------------------
		
		*12.04.2006 14:12 -> Сохраним ID нового дня
		lnSLID = curSLID.LastID
		*------------------------------------------------------------------------------

	CASE lnRecCount=1
		
	OTHERWISE
		RETURN -4 && неизвестная ошибка
ENDCASE
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> Проверим, существует ли открытый день для данной кассы
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[SELECT ] + ;
			[POSActivity.POSActCloseStamp ] + ;
		[FROM POSActivity ] + ;
		[WHERE POSActivity.POSActSLID = ?lnSLID AND POSActivity.POSActCID = ?tnCashID], ;
		[curOpenDay])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
***
lnRecCount = RECCOUNT([curOpenDay])
ltPOSActCloseStamp = curOpenDay.POSActCloseStamp
*------------------------------------------------------------------------------

*29.04.2006 15:29 ->Закроем курсор
USE IN SELECT([curOpenDay])
*------------------------------------------------------------------------------

DO CASE
	CASE lnRecCount>1
		RETURN -3 && открыто более одного локального дня
	CASE lnRecCount=1 AND !ISNULL(ltPOSActCloseStamp)
		RETURN -1 && локальный день уже закрыт
	CASE lnRecCount=1 AND ISNULL(ltPOSActCloseStamp)

	CASE lnRecCount=0

		*07.04.2006 16:45 -> открываем локальный день
		lnSqlExeResult = 0
		***
		DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
			lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
				[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
				[INSERT INTO POSActivity ] + ;
					[(POSActSLID,POSActCID,POSActOpenStamp) ] + ;
				[VALUES ] + ;
					[(?lnSLID,?tnCashID,GETDATE())])
		ENDDO
		***
		IF lnSqlExeResult = -1
			spHandleODBCError()
			RETURN
		ENDIF
		*------------------------------------------------------------------------------

	OTHERWISE
		RETURN -4 && неизвестная ошибка
ENDCASE
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> Делаем дисконнект: освобождаем соединение
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*12.04.2006 14:12 -> Вернем ID нового дня
RETURN lnSLID
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
