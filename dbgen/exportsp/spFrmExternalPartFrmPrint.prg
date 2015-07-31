*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: SPFRMEXTERNALPARTFRMPRINT()
* Called by.......: <When Document Printed>
* Parameters......: <tnFrmID, tlAddSignature>
* Returns.........: <Список временных файлов, созданных для отчета>
* Notes...........: Выборка для печати внешних документов содержащих документы (суммы)
*-------------------------------------------------------
PROCEDURE spFrmExternalPartFrmPrint
LPARAMETERS tcQryParSID

*11.05.2005 12:53 ->Объявление и инициализация переменных
LOCAL	lnFrmID, ;
		llAddSignature, ;
		lnConnectHandle, ;
		lnSqlExeResult
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

*13.04.2006 14:01 -> Установим свойство BatchMode в False, чтобы получать результирующие выборки с сервера по очереди командой SQLMoreResults
SQLSETPROP(lnConnectHandle,[BatchMode],.F.)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> Выполняем запрос
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE spFrmExternalPartFrmPrint ?lnFrmID, ?llAddSignature],[RptItogHD])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*13.04.2006 14:03 -> Получаем вторую результирующую выборку
SQLMORERESULTS(lnConnectHandle,[RptItogDT])
SQLMORERESULTS(lnConnectHandle)
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> Делаем дисконнект: освобождаем соединение
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> Сохраним курсоры на диск и закроем
SELECT RptItogHD
COPY TO tmp\RptItogHD.dbf
***
SELECT RptItogDT
COPY TO tmp\RptItogDT.dbf
***
USE IN SELECT([RptItogHD])
USE IN SELECT([RptItogDT])
*------------------------------------------------------------------------------

*24.04.2006 13:59 -> Откроем сохраненные на диск таблицы
USE tmp\RptItogHD IN 0
USE tmp\RptItogDT IN 0
*------------------------------------------------------------------------------

*05.08.2004 15:42 ->Составим список идентификаторов клиентов, упоминающихся в документе
SELECT ;
	RptItogHD.CltID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.OwnCltID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.DevCltID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.ExEmiCltID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.ExIspCltID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.CntCltID AS ID ;
FROM RptItogHD ;
INTO CURSOR curCltIdList
*------------------------------------------------------------------------------

*21.04.2006 17:34 -> Получим подробные данные по клиентам
spClientInfoExpand([curCltIdList],[RptCltInfo])
*------------------------------------------------------------------------------

*23.09.2004 17:24 ->Составим список идентификаторов расчётных счетов клиентов
SELECT ;
	RptItogHD.CltSAccID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.OwnSAccID AS ID ;
FROM RptItogHD ;
INTO CURSOR curSAccIdList
*------------------------------------------------------------------------------

*21.04.2006 17:34 -> Получим подробные данные по расчётным счетам
spSAccInfoExpand([curSAccIdList],[RptSAccInfo])
*------------------------------------------------------------------------------

*22.07.2004 20:50 -> Вернем список временных файлов, созданных для отчета
RETURN [RptItogHD.dbf;RptItogDT.DBF;RptCltInfo.dbf;RptCltInfo.cdx;RptSAccInfo.dbf;RptSAccInfo.cdx]
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
