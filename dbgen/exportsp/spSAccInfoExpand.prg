*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spSAccInfoExpand()
* Called by.......: <NA>
* Parameters......: <tcSAccIdList, tcRptSAccInfo>
* Returns.........: <none>
* Notes...........: Выборка информации по расчётным счетам
*-------------------------------------------------------
PROCEDURE spSAccInfoExpand
LPARAMETERS tcSAccIdList, tcRptSAccInfo

*24.04.2006 12:49 ->Объявление и инициализация переменных
LOCAL	lcRptSAccInfoPath, ;
		lcFilterExpr, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcRptSAccInfoPath = [tmp\] + tcRptSAccInfo + [.dbf]
*------------------------------------------------------------------------------

*21.04.2006 16:14 -> Сформируем строку со списком выбранных идентификаторов расчётных счетов клиентов
lcFilterExpr = spGetTmpValueList(tcSAccIdList)
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> Коннектимся к БД через существующее соединение
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> Выполняем запрос (получим подробные данные по расчётным счетам)
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE spSAccInfoExpand ?lcFilterExpr],tcRptSAccInfo)
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> Делаем дисконнект: освобождаем соединение
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> Сохраним курсор на диск и закроем
SELECT (tcRptSAccInfo)
COPY TO (lcRptSAccInfoPath)
***
USE IN SELECT(tcRptSAccInfo)
*------------------------------------------------------------------------------

*24.04.2006 13:59 -> Откроем сохраненную на диск таблицу
USE (lcRptSAccInfoPath) IN 0
*------------------------------------------------------------------------------

*16.09.2004 15:55 ->Создадим индекс для Relation-а
SELECT (tcRptSAccInfo)
INDEX ON CltSAccID TAG CltSAccID OF ([tmp\]+tcRptSAccInfo)
*------------------------------------------------------------------------------
	
ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
