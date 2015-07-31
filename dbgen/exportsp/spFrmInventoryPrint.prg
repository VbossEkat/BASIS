*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored procedures for Basis
* Module/Procedure: spFrmInventoryPrint()
* Called by.......: <NA>
* Parameters......: <tcQryParSID>
* Returns.........: <Список временных файлов, созданных для отчета>
* Notes...........: Выборка для отчета "Инвентаризационная ведомость"
*------------------------------------------------------------------------------
PROCEDURE spFrmInventoryPrint
LPARAMETERS tcQryParSID

*12.05.2006 11:02 -> Объявление и инициализация переменных
LOCAL	lnFrmID, ;
		lcOldAlias, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcOldAlias = ALIAS()
*------------------------------------------------------------------------------

*12.05.2006 11:02 -> Создаем таблицу с окружением для отчёта
CREATE TABLE tmp\RptEnv FREE (QryParSID C(10))
INSERT INTO RptEnv (QryParSID) VALUES (tcQryParSID)
*------------------------------------------------------------------------------

*12.05.2006 11:02 ->Читаем параметры
IF TYPE([oQryParMgr])==[O] AND !ISNULL(oQryParMgr)

	*12.05.2006 11:02 -> Читаем идентификатор документа, который будем печатать
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
		[EXECUTE spFrmInventoryPrint ?lnFrmID],[RptItogHD])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*13.04.2006 14:03 -> Получаем вторую результирующую выборку
SQLMORERESULTS(lnConnectHandle,[InvTotal])
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
SELECT InvTotal
COPY TO tmp\InvTotal.dbf
***
SELECT RptItogDT
COPY TO tmp\RptItogDT.dbf
***
USE IN SELECT([RptItogHD])
USE IN SELECT([InvTotal])
USE IN SELECT([RptItogDT])
*------------------------------------------------------------------------------

*30.06.2006 13:25 -> Убираем повторяющеися значения
*!*	USE RptItogDT IN 0
*!*	***
*!*	LOCAL lnTvrID
*!*	***
*!*	SELECT RptItogDT
*!*	lnTvrID = 0
*!*	***
*!*	SCAN ALL
*!*		IF lnTvrID = RptItogDT.TvrID
*!*			REPLACE ;
*!*				RptItogDT.MsuNM  WITH [], ;
*!*				RptItogDT.TvrQnt WITH 0, ;
*!*				RptItogDT.TvrSum WITH 0
*!*		ENDIF
*!*		lnTvrID = RptItogDT.TvrID
*!*	ENDSCAN
*------------------------------------------------------------------------------

*12.05.2006 11:29 -> Закроем таблицы
USE IN SELECT([RptEnv])
USE IN SELECT([RptItogDT])
*------------------------------------------------------------------------------

*12.05.2006 11:29 -> Восстановим текущий Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*12.05.2006 11:29 -> Вернем список временных таблиц для построения отчета
RETURN [RptItogHD.dbf;RptItogDT.dbf;InvTotal.dbf;RptEnv.dbf]
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
