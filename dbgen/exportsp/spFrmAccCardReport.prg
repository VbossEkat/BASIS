*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spFrmAccCardReport()
* Called by.......: <When Document Printed>
* Parameters......: <tcQryParSID>
* Returns.........: <Список временных файлов, созданных для отчета>
* Notes...........: Выборка для печати калькуляционных карт по актам производства
*------------------------------------------------------------------------------
PROCEDURE spFrmAccCardReport
LPARAMETERS tcQryParSID

*11.05.2005 12:53 -> Объявление и инициализация переменных
LOCAL	lnFrmID, ;
		lnConnectHandle, ;
		lnSqlExeResult
*------------------------------------------------------------------------------

*11.05.2005 12:54 -> Читаем параметры
IF TYPE([oQryParMgr])==[O] AND !ISNULL(oQryParMgr)

	*26.05.2004 21:18 -> Читаем идентификатор документа, который будем печатать
	lnFrmID = oQryParMgr.ParamGet(tcQryParSID,[FrmID])
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
		[EXECUTE spFrmAccCardReport ?lnFrmID],[RptItogHD])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*13.04.2006 14:03 -> Получаем вторую результирующую выборку
lnSqlExeResult = SQLMORERESULTS(lnConnectHandle,[RptItogDT])
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
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

*24.04.2006 13:59 -> Откроем сохраненные на диск таблицы
USE tmp\RptItogHD IN 0
USE tmp\RptItogDT IN 0
*------------------------------------------------------------------------------

*04.09.2006 11:44 -> Создадим индекс для Relation-а
SELECT RptItogHD
INDEX ON FrmID TAG FrmID OF tmp\RptItogHD
*------------------------------------------------------------------------------

*05.08.2004 15:42 -> Составим список идентификаторов клиентов, упоминающихся в документе
SELECT ;
	RptItogHD.OwnCltID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.DevCltID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.ExIspCltID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.CntCltID AS ID ;
FROM RptItogHD ;
INTO TABLE tmp\tmpCltIdList
*------------------------------------------------------------------------------

*05.08.2004 15:54 ->Получим подробные данные по клиентам
spClientInfoExpand([tmpCltIdList],[RptCltInfo])
*------------------------------------------------------------------------------

*22.07.2004 20:50 -> Вернем список временных файлов, созданных для отчета
RETURN [RPTITOGHD.DBF;RPTITOGHD.CDX;RPTITOGDT.DBF;RptCltInfo.dbf;RptCltInfo.cdx]
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
