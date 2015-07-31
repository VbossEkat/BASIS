*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spSaleReport_ingred()
* Called by.......: <NA>
* Parameters......: <tcQryParSID,tlDiscCardInfo>
* Returns.........: <none>
* Notes...........: Формирование выборки для отчета о продажах
*-------------------------------------------------------
PROCEDURE spSaleReport_ingred
LPARAMETERS tcQryParSID,tlDiscCardInfo 

*21.07.2005 12:13 -> Объявление и инициализация переменных
LOCAL	lcOldDate, ;
		lcOldCentury, ;
		lcOldMark, ;
		lcOldAlias, ;
		lcFilterExpr, ;
		lcFilterExprTvr, ;
		lcFilterExprCheckType, ;
		luQryParDateEnabled, ;
		luQryParDateStartDate, ;
		luQryParDateEndDate, ;
		luQryParTvrEnabled, ;
		luQryParTvrIDTableNM, ;
		luQryParTvrGrpEnabled, ;
		lcQryParTvrIDTableNM, ;
		luQryParCheckTypeAborted, ;
		luQryParIsAbortedCheck, ;
		luQryParCashEnabled, ;
		luQryParCashTableNM, ;
		luQryParCashierEnabled, ;
		luQryParCashierTableNM, ;
		luQryParCheckTypeEnabled, ;
		luQryParCheckTypeTableNM
***
lcOldDate = SET([DATE])
lcOldCentury = SET([CENTURY])
lcOldMark = SET([MARK])
lcOldAlias = ALIAS()
lcFilterExpr = [WHERE 0<>1]
lcFilterExprTvr		  = []
lcFilterExprCheckType = []
*------------------------------------------------------------------------------

*28.11.2005 13:39 ->Если формируется выборка для отчета по дисконтным картам, то установим соответсвующий фильтр
IF tlDiscCardInfo
	lcFilterExpr = lcFilterExpr + [ AND NOT CheckSale.DiscCardID IS NULL]
ENDIF
*------------------------------------------------------------------------------

*21.07.2005 12:13 ->Дальнейшие параметры обрабатываем, если существует менеджер параметров
IF TYPE([oQryParMgr])==[O] AND !ISNULL(oQryParMgr)
	
	*21.07.2005 15:37 ->Создаем таблицу с окружением для отчёта
	CREATE TABLE tmp\RptEnv FREE (QryParSID C(10), QryTypeNM C(40))
	INSERT INTO RptEnv (QryParSID) VALUES (tcQryParSID)
	*------------------------------------------------------------------------------
	
	*21.07.2005 12:13 ->Формируем фильтр по дате
	luQryParDateEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplDateEnabled])
	***
	IF !ISNULL(luQryParDateEnabled) AND TYPE([luQryParDateEnabled])==[L] AND luQryParDateEnabled
		
		*26.05.2004 21:33 ->Получим дату стартовую и конечную
		luQryParDateStartDate = oQryParMgr.ParamGet(tcQryParSID,[qpdDateStart])
		luQryParDateEndDate = oQryParMgr.ParamGet(tcQryParSID,[qpdDateEnd])
		*------------------------------------------------------------------------------

		*21.04.2006 10:33 -> Установим формат даты YMD и CENTURY ON
		SET DATE YMD
		SET CENTURY ON
		SET MARK TO "/"
		*------------------------------------------------------------------------------

		*26.05.2004 21:27 ->Формируем условие
		DO CASE
			CASE	!ISNULL(luQryParDateStartDate) AND TYPE([luQryParDateStartDate])==[D] AND !EMPTY(luQryParDateStartDate) AND ;
					!ISNULL(luQryParDateEndDate) AND TYPE([luQryParDateEndDate])==[D] AND !EMPTY(luQryParDateEndDate)
					*{
					lcFilterExpr = lcFilterExpr + [ AND SalesLog.StampOpenDay >= ']+STRTRAN(DTOC(luQryParDateStartDate),[/],[])+[' AND SalesLog.StampOpenDay < ']+STRTRAN(DTOC(luQryParDateEndDate+1),[/],[])+[']
					*}
			CASE	!ISNULL(luQryParDateStartDate) AND TYPE([luQryParDateStartDate])==[D] AND !EMPTY(luQryParDateStartDate)
					*{
					lcFilterExpr = lcFilterExpr + [ AND SalesLog.StampOpenDay >= ']+STRTRAN(DTOC(luQryParDateStartDate),[/],[])+[']
					*}
			CASE	!ISNULL(luQryParDateEndDate) AND TYPE([luQryParDateEndDate])==[D] AND !EMPTY(luQryParDateEndDate)
					*{
					lcFilterExpr = lcFilterExpr + [ AND SalesLog.StampOpenDay < ']+STRTRAN(DTOC(luQryParDateEndDate+1),[/],[])+[']
					*}
		ENDCASE
		*------------------------------------------------------------------------------	
		
		*21.04.2006 10:33 -> Восстановим старый формат даты
		SET DATE (lcOldDate)
		SET CENTURY &lcOldCentury
		SET MARK TO lcOldMark
		*------------------------------------------------------------------------------

	ENDIF
	*------------------------------------------------------------------------------

	*14.06.2006 15:47 ->Формируем фильтр (Выбор товаров)
	luQryParTvrEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplTvrEnabled])
	***
	IF !ISNULL(luQryParTvrEnabled) AND TYPE([luQryParTvrEnabled])==[L] AND luQryParTvrEnabled
				
		*14.06.2006 15:47 ->Получим имя временной таблицы с идентификаторами товАРОВ 
		luQryParTvrIDTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcTvrIDTableNM])
		***
		IF !ISNULL(luQryParTvrIDTableNM) AND TYPE([luQryParTvrIDTableNM])==[C] AND FILE([tmp\]+luQryParTvrIDTableNM+[.dbf])

			*10.04.2006 11:35 -> Сформируем фильтр
			lcFilterExprTvr = lcFilterExprTvr + ;
							[ AND Tovar.TvrID IN (] + spGetTmpValueList(luQryParTvrIDTableNM) + [)]
			*------------------------------------------------------------------------------

		ENDIF
		*------------------------------------------------------------------------------		
				
	ENDIF
	*------------------------------------------------------------------------------

	*28.09.2005 10:09 -> Формируем фильтр (Выбор групп товаров)
	luQryParTvrGrpEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplTvrGrpEnabled])
	***
	IF !ISNULL(luQryParTvrGrpEnabled) AND TYPE([luQryParTvrGrpEnabled])==[L] AND luQryParTvrGrpEnabled

		*28.09.2005 10:16 -> Получим имя таблицы с идентификаторами групп товаров
		luQryParTvrGrpTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcTvrGrpTableNM])
		***
		IF !ISNULL(luQryParTvrGrpTableNM) AND TYPE([luQryParTvrGrpTableNM])==[C] AND FILE([tmp\]+luQryParTvrGrpTableNM+[.dbf])

			*10.04.2006 11:35 -> Сформируем фильтр
			lcFilterExprTvr = lcFilterExprTvr + ;
							[ AND Tovar.TvrID IN (SELECT ID FROM GetTvrIDInSelectedTvrGrp('] + spGetTmpValueList(luQryParTvrGrpTableNM) + [') WHERE IsCnt = 0)]
			*------------------------------------------------------------------------------

		ENDIF
		*------------------------------------------------------------------------------
		
	ENDIF
	*------------------------------------------------------------------------------

	*21.07.2005 12:13 ->Формируем фильтр по сброшенным чекам
	luQryParCheckTypeAborted = oQryParMgr.ParamGet(tcQryParSID,[qplCheckTypeAborted])
	***
	IF !ISNULL(luQryParCheckTypeAborted) AND TYPE([luQryParCheckTypeAborted])==[L] AND luQryParCheckTypeAborted
		luQryParIsAbortedCheck = oQryParMgr.ParamGet(tcQryParSID,[qplAborted])
		IF !ISNULL(luQryParIsAbortedCheck) AND TYPE([luQryParIsAbortedCheck])==[L] AND luQryParIsAbortedCheck
			lcFilterExpr = lcFilterExpr+[ AND CheckType.CheckTypeAborted=1]
		ELSE
			lcFilterExpr = lcFilterExpr+[ AND CheckType.CheckTypeAborted=0]
		ENDIF
	ENDIF
	*------------------------------------------------------------------------------

	*02.08.2005 09:08 ->Формируем фильтр по кассе
	luQryParCashEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplCashEnabled])
	***
	IF !ISNULL(luQryParCashEnabled) AND TYPE([luQryParCashEnabled])==[L] AND luQryParCashEnabled
		luQryParCashTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcCashTableNM])
		IF !ISNULL(luQryParCashTableNM) AND TYPE([luQryParCashTableNM])==[C] AND FILE(luQryParCashTableNM+[.dbf])

			*10.04.2006 11:35 -> Сформируем фильтр
			lcFilterExpr = lcFilterExpr + ;
							[ AND CheckSale.CheckCashID IN (] + spGetTmpValueList(luQryParCashTableNM) + [)]
			*------------------------------------------------------------------------------

		ENDIF
	ENDIF
	*------------------------------------------------------------------------------

	*02.08.2005 09:08 ->Формируем фильтр по кассиру
	luQryParCashierEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplCashierEnabled])
	***
	IF !ISNULL(luQryParCashierEnabled) AND TYPE([luQryParCashierEnabled])==[L] AND luQryParCashierEnabled
		luQryParCashierTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcCashierTableNM])
		IF !ISNULL(luQryParCashierTableNM) AND TYPE([luQryParCashierTableNM])==[C] AND FILE(luQryParCashierTableNM+[.dbf])

			*10.04.2006 11:35 -> Сформируем фильтр
			lcFilterExpr = lcFilterExpr + ;
							[ AND CheckSale.CheckCashierID IN (] + spGetTmpValueList(luQryParCashierTableNM) + [)]
			*------------------------------------------------------------------------------

		ENDIF
	ENDIF
	*------------------------------------------------------------------------------

	*01.12.2005 11:12 ->Формируем фильтр по типам чеков
	luQryParCheckTypeEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplCheckTypeEnabled])
	***
	IF !ISNULL(luQryParCheckTypeEnabled) AND TYPE([luQryParCheckTypeEnabled])==[L] AND luQryParCheckTypeEnabled
		luQryParCheckTypeTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcCheckTypeTableNM])
		IF !ISNULL(luQryParCheckTypeTableNM) AND TYPE([luQryParCheckTypeTableNM])==[C] AND FILE(luQryParCheckTypeTableNM+[.dbf])

			*10.04.2006 11:35 -> Сформируем фильтр
			lcFilterExprCheckType = lcFilterExprCheckType + ;
							[ AND CheckSale.CheckTypeID IN (] + spGetTmpValueList(luQryParCheckTypeTableNM) + [)]
			*------------------------------------------------------------------------------

		ENDIF
	ENDIF
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
		[EXECUTE spSaleReport_ingred ?lcFilterExpr, ?lcFilterExprTvr, ?lcFilterExprCheckType],[tmpRptItog])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*--------------------------------------0----------------------------------------

*13.04.2006 14:03 -> Получаем вторую результирующую выборку
SQLMORERESULTS(lnConnectHandle,[tmpRptCheckType])
SQLMORERESULTS(lnConnectHandle)
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> Делаем дисконнект: освобождаем соединение
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*28.11.2005 12:16 -> Сохраним курсоры на диск и закроем
SELECT tmpRptCheckType
COPY TO tmp\tmpRptCheckType.dbf
***
SELECT tmpRptItog
COPY TO tmp\tmpRptItog.dbf
***
USE IN SELECT([tmpRptCheckType])
USE IN SELECT([tmpRptItog])
*------------------------------------------------------------------------------

*30.06.2006 16:11 -> Откроем файлы и создадим дополнительные индексы
USE tmp\tmpRptCheckType.dbf IN 0
USE tmp\tmpRptItog.dbf IN 0
***
SELECT tmpRptCheckType
INDEX ON CheckTID TAG CheckTID
***
SELECT tmpRptItog
INDEX ON CheckDate TAG CheckDate
INDEX ON TvrID TAG TvrID ADDITIVE
INDEX ON TvrNM TAG TvrNM ADDITIVE
INDEX ON DTOC(CheckDate,1)+PADL(ALLTRIM(STR(CheckNo)),6,[0]) TAG ChkOrder ADDITIVE
INDEX ON CheckHour TAG CheckHour ADDITIVE
INDEX ON STR(SalesLogID,10) + TvrNM TAG SLTvrNM ADDITIVE
*------------------------------------------------------------------------------

*28.11.2005 12:16 ->Восстановим текущий Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*21.04.2004 14:27 -> Вернем значение
RETURN [tmpRptItog.dbf;tmpRptItog.cdx;tmpRptCheckType.dbf;tmpRptCheckType.cdx;RptEnv.dbf]
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
