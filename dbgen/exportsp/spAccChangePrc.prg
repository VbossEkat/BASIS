*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spAccChangePrc()
* Called by.......: <NA>
* Parameters......: <tnTvrID, tnNewPrcBuy>
* Returns.........: <none>
* Notes...........: Изменение цены во всех калькуляциях
*------------------------------------------------------------------------------
PROCEDURE spAccChangePrc
LPARAMETERS tnTvrID, tnNewPrcBuy

*24.08.2005 14:15 -> Объявление и инициализация переменных
LOCAL	lnSqlExeResult, ;
		llResult
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> Коннектимся к БД через существующее соединение
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> Меняем цену во всех калькуляциях
lnSqlExeResult = 0
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[UPDATE ] + ;
			[FrmPartTvr ] + ;
		[SET TvrPrcBuy = ?tnNewPrcBuy ] + ;
		[WHERE FrmPartTvr.TvrID = ?tnTvrID AND FrmPartTvr.FrmID IN (SELECT Form.FrmID FROM Form WHERE Form.FrmTypeID = 19)])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN 0
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> Делаем дисконнект: освобождаем соединение
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
