*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spGetSaleSum()
* Called by.......: <NA>
* Parameters......: <tcQryParSID>
* Returns.........: <none>
* Notes...........: Расчитываем сумму продаж за период
*------------------------------------------------------------------------------
PROCEDURE spGetSaleSum
LPARAMETERS tcQryParSID

*28.02.2006 12:16 ->Объявление и инициализация переменных
LOCAL	lcOldDate, ;
		lcOldCentury, ;
		lcOldMark, ;
		lcOldAlias, ;
		lcFilterExpr, ;
		luQryParDateEnabled, ;
		luQryParDateStartDate, ;
		luQryParDateEndDate, ;
		luQryParCashEnabled, ;
		luQryParCashTableNM, ;
		luQryParCashierEnabled, ;
		luQryParCashierTableNM, ;
		luQryParTvrEnabled, ;
		luQryParTvrIDTableNM, ;
		lnSalesSum
***
lcOldDate = SET([DATE])
lcOldCentury = SET([CENTURY])
lcOldMark = SET([MARK])
lcOldAlias	 = ALIAS()
lcFilterExpr = []
*------------------------------------------------------------------------------

*06.03.2006 16:22 ->Дальнейшие параметры обрабатываем, если существует менеджер параметров
IF TYPE([oQryParMgr])==[O] AND !ISNULL(oQryParMgr)
	
	*06.03.2006 16:22 ->Формируем фильтр по дате
	luQryParDateEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplDateEnabled])
	***
	IF !ISNULL(luQryParDateEnabled) AND TYPE([luQryParDateEnabled])==[L] AND luQryParDateEnabled
		
		*06.03.2006 16:22 ->Получим дату стартовую и конечную
		luQryParDateStartDate = oQryParMgr.ParamGet(tcQryParSID,[qpdDateStart])
		luQryParDateEndDate = oQryParMgr.ParamGet(tcQryParSID,[qpdDateEnd])
		*------------------------------------------------------------------------------
		
		*21.04.2006 10:33 -> Установим формат даты YMD и CENTURY ON
		SET DATE YMD
		***
		SET CENTURY ON
		***
		SET MARK TO "/"
		*------------------------------------------------------------------------------

		*06.03.2006 16:22 ->Формируем условие
		DO CASE
			CASE	!ISNULL(luQryParDateStartDate) AND TYPE([luQryParDateStartDate])==[D] AND !EMPTY(luQryParDateStartDate) AND ;
					!ISNULL(luQryParDateEndDate) AND TYPE([luQryParDateEndDate])==[D] AND !EMPTY(luQryParDateEndDate)
					*{
					lcFilterExpr = lcFilterExpr + [ AND CheckSale.CheckStamp >= ']+STRTRAN(DTOC(luQryParDateStartDate),[/],[])+[' AND CheckSale.CheckStamp < ']+STRTRAN(DTOC(luQryParDateEndDate+1),[/],[])+[']
					*}
			CASE	!ISNULL(luQryParDateStartDate) AND TYPE([luQryParDateStartDate])==[D] AND !EMPTY(luQryParDateStartDate)
					*{
					lcFilterExpr = lcFilterExpr + [ AND CheckSale.CheckStamp >= ']+STRTRAN(DTOC(luQryParDateStartDate),[/],[])+[']
					*}
			CASE	!ISNULL(luQryParDateEndDate) AND TYPE([luQryParDateEndDate])==[D] AND !EMPTY(luQryParDateEndDate)
					*{
					lcFilterExpr = lcFilterExpr + [ AND CheckSale.CheckStamp < ']+STRTRAN(DTOC(luQryParDateEndDate+1),[/],[])+[']
					*}
		ENDCASE
		*------------------------------------------------------------------------------	

		*21.04.2006 10:33 -> Восстановим старый формат даты
		SET DATE (lcOldDate)
		***
		SET CENTURY &lcOldCentury
		***
		SET MARK TO lcOldMark
		*------------------------------------------------------------------------------

	ENDIF
	*------------------------------------------------------------------------------

	*02.06.2006 11:34 ->Формируем фильтр по кассе
	luQryParCashEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplCashEnabled])
	***
	IF !ISNULL(luQryParCashEnabled) AND TYPE([luQryParCashEnabled])==[L] AND luQryParCashEnabled
		luQryParCashTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcCashTableNM])
		IF !ISNULL(luQryParCashTableNM) AND TYPE([luQryParCashTableNM])==[C] AND FILE(luQryParCashTableNM+[.dbf])

			*10.04.2006 11:35 -> Сформируем фильтр
			lcFilterExpr = lcFilterExpr+[ AND CheckSale.CheckCashID IN (]+spGetTmpValueList(luQryParCashTableNM)+[)]
			*------------------------------------------------------------------------------

		ENDIF
	ENDIF
	*------------------------------------------------------------------------------

	*02.06.2006 11:34 ->Формируем фильтр по кассиру
	luQryParCashierEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplCashierEnabled])
	***
	IF !ISNULL(luQryParCashierEnabled) AND TYPE([luQryParCashierEnabled])==[L] AND luQryParCashierEnabled
		luQryParCashierTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcCashierTableNM])
		IF !ISNULL(luQryParCashierTableNM) AND TYPE([luQryParCashierTableNM])==[C] AND FILE(luQryParCashierTableNM+[.dbf])

			*10.04.2006 11:35 -> Сформируем фильтр
			lcFilterExpr = lcFilterExpr+[ AND CheckSale.CheckCashierID IN (]+spGetTmpValueList(luQryParCashierTableNM)+[)]
			*------------------------------------------------------------------------------

		ENDIF
	ENDIF
	*------------------------------------------------------------------------------

	*02.06.2006 11:38 ->Формируем фильтр (Выбор товаров)
	luQryParTvrEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplTvrEnabled])
	***
	IF !ISNULL(luQryParTvrEnabled) AND TYPE([luQryParTvrEnabled])==[L] AND luQryParTvrEnabled
	
		*23.04.2006 00:32 ->Получим имя временной таблицы с идентификаторами товАРОВ 
		luQryParTvrIDTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcTvrIDTableNM])
		***
		IF !ISNULL(luQryParTvrIDTableNM) AND TYPE([luQryParTvrIDTableNM])==[C] AND FILE([tmp\]+luQryParTvrIDTableNM+[.dbf])

			*10.04.2006 11:35 -> Сформируем фильтр
			lcFilterExpr = lcFilterExpr + ;
							[ AND CheckTrans.CheckTransTvrId IN (]+spGetTmpValueList(luQryParTvrIDTableNM)+[)]
			*------------------------------------------------------------------------------

		ENDIF
		*------------------------------------------------------------------------------		
				
	ENDIF
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
		[EXECUTE spGetSaleSum ?lcFilterExpr],[curSaleSum])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN 0
ENDIF
*------------------------------------------------------------------------------

*06.03.2006 16:24 ->Сохраним сумму
lnSalesSum = curSaleSum.SaleSum
*------------------------------------------------------------------------------

*06.03.2006 16:23 ->Закроем курсор
USE IN SELECT([curSaleSum])
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> Делаем дисконнект: освобождаем соединение
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*06.03.2006 16:30 ->Восстановим текущий Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
   SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*07.07.2006 16:51 -> Вернем результат
RETURN lnSalesSum
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
