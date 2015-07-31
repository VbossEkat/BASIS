*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: dbc_AfterOpenTable()
* Called by.......: <DBC Event>
* Parameters......: <tcTableName>
* Returns.........: <none>
* Notes...........: 
*------------------------------------------------------------------------------
PROCEDURE dbc_AfterOpenTable(tcTableName)

*31.03.2006 16:50 ->Объявление и инициализация переменных
LOCAL	lnConnHandler, ;
		lnSqlExeResult
***
lnConnHandler = -1
*------------------------------------------------------------------------------

*31.03.2006 16:51 -> Получим номер Connection
IF CURSORGETPROP([SourceType],tcTableName) = 2 && Remote View
	lnConnHandler = CURSORGETPROP([ConnectHandle],tcTableName)
ENDIF
*------------------------------------------------------------------------------

*31.03.2006 16:52 -> Создадим временную таблицу для хранения ID
IF lnConnHandler > 0
	lnSqlExeResult = 0
	DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
		lnSqlExeResult = SQLEXEC(lnConnHandler, ;
			[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
			[IF OBJECT_ID('tempdb..#LastIncrID') IS NULL CREATE TABLE #LastIncrID (TableNM varchar(40), LastID INT)])
	ENDDO
	***
	IF lnSqlExeResult = -1
		spHandleODBCError()
		RETURN
	ENDIF
ENDIF
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
