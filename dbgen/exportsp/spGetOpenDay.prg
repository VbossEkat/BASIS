*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spGetOpenDay()
* Called by.......: <NA>
* Parameters......: <tnCashID,tlForce>
* Returns.........: <none>
* Notes...........: Проверка открытия локального дня
* LastEditDate....: 14 November 2006
*------------------------------------------------------------------------------
PROCEDURE spGetOpenDay
PARAMETERS tnCashID,tlForce

*29.04.2006 16:16 ->Объявление и инициализация переменных
LOCAL   lnRecCount, ;
		ltStampOpenDay, ;
		lnSLID, ;
		ltPOSActCloseStamp, ;
		lnConnectHandle, ;
		lnSqlExeResult
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> Коннектимся к БД через существующее соединение
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> Проверим количество открытых системных дней
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[SELECT ] + ;
			[SalesLog.SalesLogID, ] + ;
			[SalesLog.StampOpenDay ] + ;
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
ltStampOpenDay = curSalesLog.StampOpenDay
lnSLID = curSalesLog.SalesLogID
*------------------------------------------------------------------------------

*29.04.2006 15:14 ->Закроем курсор
USE IN SELECT([curSalesLog])
*------------------------------------------------------------------------------

DO CASE
	CASE lnRecCount>1
		RETURN -2 && осталось открытыми более одного дня
	CASE lnRecCount=0
		RETURN 0  && нет открытых дней
	CASE lnRecCount=1

		IF !tlForce AND (DATETIME()-ltStampOpenDay)/3600 > 24
			RETURN -4 && прошло более 24 часов с момента начала смены
		ENDIF

		*07.04.2006 16:45 -> Проверим, есть ли открытая локальная смена
		lnSqlExeResult = 0
		***
		DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
			lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
				[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
				[SELECT ] + ;
					[POSActivity.POSActID, ] + ;
					[POSActivity.POSActCloseStamp ] + ;
				[FROM POSActivity ] + ;
				[INNER JOIN SalesLog ON SalesLog.SalesLogID = POSActivity.POSActSLID AND POSActivity.POSActCID = ?tnCashID ] + ;
				[WHERE SalesLog.SalesLogID = ?lnSLID], ;
				[curLocalDay])
		ENDDO
		***
		IF lnSqlExeResult = -1
			spHandleODBCError()
			RETURN .F.
		ENDIF
		***
		lnRecCount = RECCOUNT([curLocalDay])
		ltPOSActCloseStamp = curLocalDay.POSActCloseStamp
		*------------------------------------------------------------------------------

		*29.04.2006 15:14 ->Закроем курсоры
		USE IN SELECT([curLocalDay])
		*------------------------------------------------------------------------------

		DO CASE
			CASE lnRecCount=1 AND !ISNULL(ltPOSActCloseStamp)
				RETURN -1 && локальный день уже закрыт
			CASE lnRecCount=0
				RETURN 0
		ENDCASE

	OTHERWISE
		RETURN -4 && неизвестная ошибка
ENDCASE
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> Делаем дисконнект: освобождаем соединение
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

RETURN lnSLID

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
