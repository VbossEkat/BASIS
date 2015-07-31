*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spStockReport()
* Called by.......: <NA>
* Parameters......: <tnFrmID>
* Returns.........: <lcUniqueNM>
* Notes...........: Выборка для отчета по остаткам
*-------------------------------------------------------
PROCEDURE spStockReport
LPARAMETERS tcQryParSID

*27.09.2005 09:28 ->Объявление и инициализация переменных
LOCAL	lcOldDate, ;
		lcOldCentury, ;
		lcOldMark, ;
		lcOldAlias, ;
		lcFilterExpr, ;
		luQryParDateEnabled, ;
		luQryParDateStartDate, ;
		luQryParOUIspEnabled, ;
		luQryParOUIspIDTableNM, ;
		luQryParTvrGrpEnabled, ;
		luQryParTvrGrpTableNM, ;
		lcQryParTvrIDTableNM, ;
		luQryParCltEmiEnabled, ;
		luQryParCltEmiTableNM, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcOldDate = SET([DATE])
lcOldCentury = SET([CENTURY])
lcOldMark = SET([MARK])
lcOldAlias = ALIAS()
lcFilterExpr = []
*------------------------------------------------------------------------------

*02.06.2005 15:47 ->Создаем таблицу с окружением для отчёта
CREATE TABLE tmp\RptEnv FREE (QryParSID C(10))
INSERT INTO RptEnv (QryParSID) VALUES (tcQryParSID)
*------------------------------------------------------------------------------

*19.09.2005 17:07 ->Сформируем условия выбора по дате
luQryParDateEnabled   = oQryParMgr.ParamGet(tcQryParSID,[qplDateEnabled])
luQryParDateStartDate = oQryParMgr.ParamGet(tcQryParSID,[qpdDateStart])
****
IF !ISNULL(luQryParDateEnabled)   AND TYPE([luQryParDateEnabled])==[L]   AND luQryParDateEnabled AND ;
   !ISNULL(luQryParDateStartDate) AND TYPE([luQryParDateStartDate])==[D] AND !EMPTY(luQryParDateStartDate)

	*21.04.2006 10:33 -> Установим формат даты YMD и CENTURY ON
	SET DATE YMD
	***
	SET CENTURY ON
	***
	SET MARK TO "/"
	*------------------------------------------------------------------------------

	*03.07.2006 11:40 -> Сформируем условия выбора
	lcFilterExpr = 	[Stock.StockValidFrom < ']   + STRTRAN(DTOC(luQryParDateStartDate),[/],[]) + [' AND ] + ;
					[(Stock.StockValidThru >= '] + STRTRAN(DTOC(luQryParDateStartDate),[/],[]) + [' OR ]  + ;
					[Stock.StockValidThru IS NULL)]
	*------------------------------------------------------------------------------

	*21.04.2006 10:33 -> Восстановим старый формат даты
	SET DATE (lcOldDate)
	***
	SET CENTURY &lcOldCentury
	***
	SET MARK TO lcOldMark
	*------------------------------------------------------------------------------

ELSE
	lcFilterExpr = 	[Stock.StockValidThru IS NULL]
ENDIF
*------------------------------------------------------------------------------

*28.05.2004 03:01 ->Формируем фильтр (Выбор отдела (ISP))
luQryParOUIspEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplOUIspEnabled])
***
IF !ISNULL(luQryParOUIspEnabled) AND TYPE([luQryParOUIspEnabled])==[L] AND luQryParOUIspEnabled

	*28.05.2004 00:37 ->Получим имя таблицы с идентификаторами подразделений
	luQryParOUIspIDTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcOUIspIDTableNM])
	***
	IF !ISNULL(luQryParOUIspIDTableNM) AND TYPE([luQryParOUIspIDTableNM])==[C] AND FILE([tmp\]+luQryParOUIspIDTableNM+[.dbf])
		lcFilterExpr = lcFilterExpr + ;
						[ AND Stock.StockOUID IN (] + spGetTmpValueList(luQryParOUIspIDTableNM) + [)]
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
		lcFilterExpr = lcFilterExpr + ;
						[ AND Stock.StockTvrID IN (SELECT ID FROM GetTvrIDInSelectedTvrGrp('] + spGetTmpValueList(luQryParTvrGrpTableNM) + [') WHERE IsCnt = 0)]
	ENDIF
	*------------------------------------------------------------------------------
	
ENDIF
*------------------------------------------------------------------------------

*22.09.2005 17:41 ->Формируем условие выбора по поставщику
luQryParCltEmiEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplCltEmiEnabled])
luQryParCltEmiTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcCltEmiIDTableNM])
***
IF !ISNULL(luQryParCltEmiEnabled) AND TYPE([luQryParCltEmiEnabled])==[L] AND luQryParCltEmiEnabled AND ;
   !ISNULL(luQryParCltEmiTableNM) AND TYPE([luQryParCltEmiTableNM])==[C]
	lcFilterExpr = lcFilterExpr + [ AND Form.PointEmiCltID IN (] + spGetTmpValueList(luQryParCltEmiTableNM) + [)]
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
		[EXECUTE spStockReport ?lcFilterExpr],[RptItogDT])
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

*10.04.2006 14:07 -> Сохраним курсоры на диск и закроем
SELECT RptItogDT
***
COPY TO tmp\RptItogDT.dbf
***
USE IN SELECT([RptItogDT])
*------------------------------------------------------------------------------

*19.09.2005 11:25 -> Закроем курсор
USE IN SELECT([RptEnv])
*------------------------------------------------------------------------------

*28.09.2005 12:49 ->Индексируем итоговую выборку
USE tmp\RptItogDT.dbf IN 0
***
SELECT RptItogDT
INDEX ON OUNM  TAG OUNM OF tmp\RptItogDT
INDEX ON CltNM TAG CltNM OF tmp\RptItogDT ADDITIVE
INDEX ON TvrNM TAG TvrNM OF tmp\RptItogDT ADDITIVE
INDEX ON LEFT(TvrGrpNM,55)+LEFT(TvrNM,55) TAG TvrGrpNM OF tmp\RptItogDT ADDITIVE
*------------------------------------------------------------------------------

*28.09.2005 12:54 ->Восстановим текущий Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*19.09.2005 11:21 ->Вернем список временных таблиц для построения отчета
RETURN [RptItogDT.dbf;RptEnv.dbf]
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
