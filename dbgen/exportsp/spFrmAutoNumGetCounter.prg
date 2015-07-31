*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spFrmAutoNumGetCounter()
* Called by.......: spFrmAutoNum()
* Parameters......: <tnFrmTypeID,tnOwnCltID,tnOUID>
* Returns.........: <lnCounter>
* Notes...........: Возвращаем счетчик автонумератора
*------------------------------------------------------------------------------
PROCEDURE spFrmAutoNumGetCounter
LPARAMETERS tnFrmTypeID,tnOwnCltID,tnOUID

*27.06.2006 15:17 -> Объявление и инициализация переменных
LOCAL 	lcOldAlias, ;
		lnConnectHandle, ;
		lnSqlExeResult, ;
		lnLastID, ;
		lnCounter
***
lcOldAlias = ALIAS()
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> Коннектимся к БД через существующее соединение
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> Получим параметры автонумерации
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE spFrmAutoNumGetCounter ?tnFrmTypeID, ?tnOwnCltID, ?tnOUID], ;
		[curFrmNumCounter])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN
ENDIF
***
lnCounter = curFrmNumCounter.FrmNumCntVal
***
USE IN SELECT([curFrmNumCounter])
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> Делаем дисконнект: освобождаем соединение
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*23.12.2004 12:14 ->Восстановим текущий Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*22.12.2004 12:15 -> Возвращаем значение счетчика
RETURN lnCounter
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
