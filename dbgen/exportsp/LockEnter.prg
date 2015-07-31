*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: LockEnter()
* Called by.......: <>
* Parameters......: <none>
* Returns.........: <none>
* Notes...........: <Проверка возможности запуска программы>
*------------------------------------------------------------------------------
PROCEDURE LockEnter

*02.04.2007 09:42 ->Объявление и инициализация переменных
LOCAL	lnConnectHandle AS Integer, ;
		lnSqlExeResult	AS Integer, ;
		llResult		AS Boolean
*------------------------------------------------------------------------------

*02.04.2007 09:42 ->Коннектимся к БД через существующее соединение
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*28.03.2007 12:10 ->Проверяем возможность запуска программы
IF lnConnectHandle > 0
	lnSqlExeResult = 0
	DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
		lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
			[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
			[SELECT COUNT(*) FROM EventJrn WHERE EventJrn.EventJrnCode = 1],[curEventJrn])
	ENDDO
	***
	IF lnSqlExeResult = -1
		SQLDISCONNECT(lnConnectHandle)
		RETURN .F.
	ENDIF
	
	llResult = (RECCOUNT([curEventJrn]) = 0)
	USE IN SELECT([curEventJrn])
ENDIF
*------------------------------------------------------------------------------

*28.03.2007 12:13 ->Делаем дисконнект: освобождаем соединение
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

RETURN llResult

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
