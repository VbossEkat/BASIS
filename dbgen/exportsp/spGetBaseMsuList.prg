*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spGetBaseMsuList()
* Called by.......: <NA>
* Parameters......: <tnMsuID>
* Returns.........: <none>
* Notes...........: 
*------------------------------------------------------------------------------
PROCEDURE spGetBaseMsuList
LPARAMETERS tnMsuID

*11.01.2006 15:42 -> Объявление и инициализация переменных
LOCAL   lcDependentName, ;
		lcIndependentName, ;
		lcDependentFilePath, ;
		lcIndependentFilePath, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcDependentName   = [_sp]+SYS(2015)
lcIndependentName = [_sp]+SYS(2015)
lcDependentFilePath   = [tmp\] + lcDependentName + [.dbf]
lcIndependentFilePath = [tmp\] + lcIndependentName + [.dbf]
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> Коннектимся к БД через существующее соединение
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*13.04.2006 14:01 -> Установим свойство BatchMode в False, чтобы получать результирующие выборки с сервера по очереди командой SQLMoreResults
SQLSETPROP(lnConnectHandle,[BatchMode],.F.)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> Выполняем запрос
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE spGetBaseMsuList ?tnMsuID],lcDependentName)
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN
ENDIF
*------------------------------------------------------------------------------

*13.04.2006 14:03 -> Получаем вторую результирующую выборку
SQLMORERESULTS(lnConnectHandle,lcIndependentName)
SQLMORERESULTS(lnConnectHandle)
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> Сохраним курсоры на диск и закроем
SELECT (lcDependentName)
COPY TO (lcDependentFilePath)
***
SELECT (lcIndependentName)
COPY TO (lcIndependentFilePath)
***
USE IN SELECT(lcDependentName)
USE IN SELECT(lcIndependentName)
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> Делаем дисконнект: освобождаем соединение
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*21.04.2004 14:27 -> Вернем имена таблиц
RETURN lcIndependentName+[;]+lcDependentName
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
