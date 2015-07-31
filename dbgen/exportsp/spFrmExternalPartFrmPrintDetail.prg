*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spFrmExternalPartFrmPrintDetail()
* Called by.......: <When Document Printed>
* Parameters......: <tnFrmID, tlAddSignature>
* Returns.........: <Список временных файлов, созданных для отчета>
* Notes...........: Выборка для печати документов содержащих данные в таблице FrmPayDetail
*-------------------------------------------------------
PROCEDURE spFrmExternalPartFrmPrintDetail
LPARAMETERS tcQryParSID

*11.05.2005 12:53 ->Объявление и инициализация переменных
LOCAL	lcResult, ;
		lnFrmID, ;
		llAddSignature, ;
		lnConnectHandle, ;
		lnSqlExeResult
*------------------------------------------------------------------------------

*12.01.2005 10:35 -> Вызываем процедуру выборки формирующую данные без FrmPayDetail
lcResult = spFrmExternalPartFrmPrint(tcQryParSID)
*------------------------------------------------------------------------------

*11.05.2005 12:54 ->Читаем параметры
IF TYPE([oQryParMgr])==[O] AND !ISNULL(oQryParMgr)

	*26.05.2004 21:18 ->Читаем идентификатор документа, который будем печатать
	lnFrmID = oQryParMgr.ParamGet(tcQryParSID,[FrmID])
	*------------------------------------------------------------------------------
	
	*11.05.2005 12:55 ->Читаем состояние флажка "С печатью/Без печати"
	llAddSignature = oQryParMgr.ParamGet(tcQryParSID,[qplAddSign])
	*------------------------------------------------------------------------------

ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> Коннектимся к БД через существующее соединение
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> Выполняем запрос
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE spFrmExternalPartFrmPrintDetail ?lnFrmID],[RptItogPD])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> Делаем дисконнект: освобождаем соединение
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> Сохраним курсор на диск и закроем
SELECT RptItogPD
COPY TO tmp\RptItogPD.dbf
***
USE IN SELECT([RptItogPD])
*------------------------------------------------------------------------------

*24.04.2006 13:59 -> Откроем сохраненную на диск таблицу
USE tmp\RptItogPD IN 0
*------------------------------------------------------------------------------

*12.01.2005 10:48 -> Вернем список временных файлов, созданных для отчета
RETURN lcResult + [;RPTITOGPD.DBF]
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
