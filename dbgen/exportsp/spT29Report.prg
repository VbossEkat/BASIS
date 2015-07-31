*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spT29Report()
* Called by.......: <When Document Printed>
* Parameters......: <tcQryParSID>
* Returns.........: <Список временных файлов, созданных для отчета>
* Notes...........: Выборка для печати товарного отчёта
*-------------------------------------------------------
PROCEDURE spT29Report
LPARAMETERS tcQryParSID

*21.04.2004 12:31 -> Объявление и инициализация переменных
LOCAL	lcOldDate, ;
		lcOldCentury, ;
		lcOldMark, ;
		lcFilterExpr, ;
		lcBalanceFilterExpr, ;
		luQryParDateEnabled, ;
		luQryParDateStartDate, ;
		luQryParDateEndDate, ;
		luQryParOUEnabled, ;
		luQryParOUIDTableNM, ;
		lcValueList, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcOldDate = SET([DATE])
lcOldCentury = SET([CENTURY])
lcOldMark = SET([MARK])
lcFilterExpr = [WHERE Form.FrmTypeID <> 27]
lcBalanceFilterExpr = [WHERE Form.FrmTypeID <> 27]
*------------------------------------------------------------------------------

*****************************************************************************
* 1. Сохраним идентификатор сессии параметров для использования в отчёте	*
*****************************************************************************

*02.06.2005 15:47 -> Создаем таблицу с окружением для отчёта
CREATE TABLE tmp\RptEnv FREE (QryParSID C(10))
INSERT INTO RptEnv (QryParSID) VALUES (tcQryParSID)
*------------------------------------------------------------------------------

*****************************************************************************
* 2. Сформируем условия выбора данных										*
*****************************************************************************

*08.07.2005 14:35 -> Сформируем условия выбора по дате
luQryParDateEnabled   = oQryParMgr.ParamGet(tcQryParSID,[qplDateEnabled])
luQryParDateStartDate = oQryParMgr.ParamGet(tcQryParSID,[qpdDateStart])
luQryParDateEndDate   = oQryParMgr.ParamGet(tcQryParSID,[qpdDateEnd])
***
IF !ISNULL(luQryParDateEnabled)   AND TYPE([luQryParDateEnabled])==[L]   AND luQryParDateEnabled AND ;
   !ISNULL(luQryParDateStartDate) AND TYPE([luQryParDateStartDate])==[D] AND !EMPTY(luQryParDateStartDate) AND ;
   !ISNULL(luQryParDateEndDate)   AND TYPE([luQryParDateEndDate])==[D]   AND !EMPTY(luQryParDateEndDate)

	*21.04.2006 10:33 -> Установим формат даты YMD и CENTURY ON
	SET DATE YMD
	***
	SET CENTURY ON
	***
	SET MARK TO "/"
	*------------------------------------------------------------------------------

	*08.07.2005 14:38 -> Сформируем условия выбора
	lcFilterExpr = lcFilterExpr + [ AND StockTrans.StockTransDate >= ']+STRTRAN(DTOC(luQryParDateStartDate),[/],[])+[' AND StockTrans.StockTransDate < ']+STRTRAN(DTOC(luQryParDateEndDate+1),[/],[])+[']
	lcBalanceFilterExpr = lcBalanceFilterExpr + [ AND StockTrans.StockTransDate < ']+STRTRAN(DTOC(luQryParDateStartDate),[/],[])+[']
	*------------------------------------------------------------------------------

	*21.04.2006 10:33 -> Восстановим старый формат даты
	SET DATE (lcOldDate)
	***
	SET CENTURY &lcOldCentury
	***
	SET MARK TO lcOldMark
	*------------------------------------------------------------------------------

ELSE

	*08.07.2005 14:40 -> Выведем сообщение о необходимости указать стартовую и конечную дату для построения отчёта
	spHandleODBCError()
	RETURN .F.
	*------------------------------------------------------------------------------

ENDIF
*------------------------------------------------------------------------------

*28.05.2004 00:32 -> Формируем условие выбора по подразделению
luQryParOUEnabled   = oQryParMgr.ParamGet(tcQryParSID,[qplOUEnabled])
luQryParOUIDTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcOUIDTableNM])
***
IF !ISNULL(luQryParOUEnabled)   AND TYPE([luQryParOUEnabled])==[L]   AND luQryParOUEnabled AND ;
   !ISNULL(luQryParOUIDTableNM) AND TYPE([luQryParOUIDTableNM])==[C]

   	*08.07.2005 14:38 -> Сформируем условия выбора
   	lcValueList = spGetTmpValueList(luQryParOUIDTableNM)
   	***
	lcFilterExpr = lcFilterExpr + [ AND StockTrans.StockTransOUID IN (] + lcValueList + [)]
	lcBalanceFilterExpr = lcBalanceFilterExpr + [ AND StockTrans.StockTransOUID IN (] + lcValueList + [)]
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
		[EXECUTE spT29Report ?lcFilterExpr, ?lcBalanceFilterExpr],[RptItog])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*13.04.2006 14:03 -> Получаем вторую результирующую выборку
SQLMORERESULTS(lnConnectHandle,[RptBalance])
SQLMORERESULTS(lnConnectHandle)
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> Делаем дисконнект: освобождаем соединение
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> Сохраним курсоры на диск и закроем
SELECT RptItog
COPY TO tmp\RptItog.dbf
***
SELECT RptBalance
COPY TO tmp\RptBalance.dbf
***
USE IN SELECT([RptItog])
USE IN SELECT([RptBalance])
*------------------------------------------------------------------------------

*22.07.2004 20:27 -> Формируем индексы
USE tmp\RptItog.dbf IN 0
***
SELECT RptItog
INDEX ON ALLTRIM(STR(RptItog.OUID,11)) + IIF(RptItog.FrmSign=1,[0],[1]) + IIF(RptItog.IsReturn,[1],[0]) + DTOC(RptItog.FrmDate,1) TAG OuDtSign COMPACT
*------------------------------------------------------------------------------

*05.08.2004 15:42 -> Составим список идентификаторов клиентов, упоминающихся в документе
SELECT DISTINCT ;
	RptItog.CltID AS ID;
FROM RptItog ;
UNION ALL ;
SELECT DISTINCT ;
	RptItog.OwnCltID AS ID ;
FROM RptItog ;
INTO TABLE tmp\tmpCltIdList
*------------------------------------------------------------------------------

*05.08.2004 15:54 -> Получим подробные данные по клиентам
spClientInfoExpand([tmpCltIdList],[RptCltInfo])
*------------------------------------------------------------------------------

*22.07.2004 20:27 -> Формируем индексы
USE tmp\RptBalance.dbf IN 0
***
SELECT RptBalance
INDEX ON OUID TAG OUID COMPACT
*------------------------------------------------------------------------------

*26.01.2005 19:10 -> Вернем список файлов созданных для отчета
RETURN [RptEnv.dbf;RptItog.dbf;RptItog.cdx;RptCltInfo.dbf;RptCltInfo.cdx;RptBalance.dbf;RptBalance.cdx]
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
