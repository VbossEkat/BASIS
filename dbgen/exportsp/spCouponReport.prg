*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spCouponReport()
* Called by.......: <NA>
* Parameters......: <tnCheckID>
* Returns.........: <none>
* Notes...........: Выборка для отчета по талонам
*------------------------------------------------------------------------------
PROCEDURE spCouponReport
LPARAMETERS tcQryParSID

*02.08.2006 09:30 ->Объявление и инициализация переменных
LOCAL	lcOldDate, ;
		lcOldCentury, ;
		lcOldMark, ;
		lcFilterExpr, ;
		luQryParDateEnabled, ;
		luQryParDateStartDate, ;
		luQryParCashEnabled, ;
		luQryParCashTableNM, ;
		luQryParCashierEnabled, ;
		luQryParCashierTableNM, ;
		luQryParCltIspEnabled, ;
		luQryParIspIDTableNM, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcOldDate = SET([DATE])
lcOldCentury = SET([CENTURY])
lcOldMark = SET([MARK])
lcFilterExpr = []
*------------------------------------------------------------------------------

*02.08.2006 09:30 ->Создаем таблицу с окружением для отчёта
CREATE TABLE tmp\RptEnv FREE (QryParSID C(10))
INSERT INTO RptEnv (QryParSID) VALUES (tcQryParSID)
*------------------------------------------------------------------------------

*02.08.2006 09:30 ->Сформируем условия выбора по дате
luQryParDateEnabled   = oQryParMgr.ParamGet(tcQryParSID,[qplDateEnabled])
luQryParDateStartDate = oQryParMgr.ParamGet(tcQryParSID,[qpdDateStart])
luQryParDateEndDate   = oQryParMgr.ParamGet(tcQryParSID,[qpdDateEnd])
***
IF !ISNULL(luQryParDateEnabled)   AND TYPE([luQryParDateEnabled])==[L]   AND luQryParDateEnabled AND ;
   !ISNULL(luQryParDateStartDate) AND TYPE([luQryParDateStartDate])==[D] AND !EMPTY(luQryParDateStartDate) AND ;
   !ISNULL(luQryParDateEndDate)   AND TYPE([luQryParDateEndDate])==[D]   AND !EMPTY(luQryParDateEndDate)

	*02.08.2006 09:30 ->Установим формат даты YMD и CENTURY ON
	SET DATE YMD
	SET CENTURY ON
	SET MARK TO "/"
	*------------------------------------------------------------------------------

	*02.08.2006 09:31 ->Сформируем условия выбора
	lcFilterExpr = lcFilterExpr + [ AND CheckSale.CheckStamp >= ']+STRTRAN(DTOC(luQryParDateStartDate),[/],[])+[' AND CheckSale.CheckStamp < ']+STRTRAN(DTOC(luQryParDateEndDate+1),[/],[])+[']
	*------------------------------------------------------------------------------

	*02.08.2006 09:31 ->Восстановим старый формат даты
	SET DATE (lcOldDate)
	SET CENTURY &lcOldCentury
	SET MARK TO lcOldMark
	*------------------------------------------------------------------------------

ENDIF
*------------------------------------------------------------------------------

*02.08.2006 09:33 ->Формируем фильтр по кассе
luQryParCashEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplCashEnabled])
***
IF !ISNULL(luQryParCashEnabled) AND TYPE([luQryParCashEnabled])==[L] AND luQryParCashEnabled
	luQryParCashTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcCashTableNM])
	IF !ISNULL(luQryParCashTableNM) AND TYPE([luQryParCashTableNM])==[C] AND FILE(luQryParCashTableNM+[.dbf])
		***
		lcFilterExpr = lcFilterExpr + ;
				[ AND CheckSale.CheckCashID IN (] + spGetTmpValueList(luQryParCashTableNM) + [)]

	ENDIF
ENDIF
*------------------------------------------------------------------------------

*02.08.2006 09:34 ->Формируем фильтр по кассе
luQryParCashierEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplCashierEnabled])
***
IF !ISNULL(luQryParCashierEnabled) AND TYPE([luQryParCashierEnabled])==[L] AND luQryParCashierEnabled
	luQryParCashierTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcCashierTableNM])
	IF !ISNULL(luQryParCashierTableNM) AND TYPE([luQryParCashierTableNM])==[C] AND FILE(luQryParCashierTableNM+[.dbf])
		***
		lcFilterExpr = lcFilterExpr + ;
				[ AND CheckSale.CheckCashierID IN (] + spGetTmpValueList(luQryParCashierTableNM) + [)]

	ENDIF
ENDIF
*------------------------------------------------------------------------------

*02.08.2006 09:34 ->Формируем фильтр по кассиру
luQryParCashierEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplCashierEnabled])
***
IF !ISNULL(luQryParCashierEnabled) AND TYPE([luQryParCashierEnabled])==[L] AND luQryParCashierEnabled
	luQryParCashierTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcCashierTableNM])
	IF !ISNULL(luQryParCashierTableNM) AND TYPE([luQryParCashierTableNM])==[C] AND FILE(luQryParCashierTableNM+[.dbf])
		***
		lcFilterExpr = lcFilterExpr + ;
				[ AND CheckSale.CheckCashierID IN (] + spGetTmpValueList(luQryParCashierTableNM) + [)]

	ENDIF
ENDIF
*------------------------------------------------------------------------------

*02.08.2006 09:47 ->Формируем фильтр по организации
luQryParCltIspEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplCltIspEnabled])
***
IF !ISNULL(luQryParCltIspEnabled) AND TYPE([luQryParCltIspEnabled])==[L] AND luQryParCltIspEnabled
	luQryParIspIDTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcCltISpIDTableNM])
	IF !ISNULL(luQryParIspIDTableNM) AND TYPE([luQryParIspIDTableNM])==[C] AND FILE(luQryParIspIDTableNM+[.dbf])
		***
		lcFilterExpr = lcFilterExpr + ;
				[ AND Coupon.CltID IN (] + spGetTmpValueList(luQryParIspIDTableNM) + [)]

	ENDIF
ENDIF
*------------------------------------------------------------------------------

*02.08.2006 09:49 ->Коннектимся к БД через существующее соединение
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*02.08.2006 09:49 ->Выполняем запрос
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE spCouponReport ?lcFilterExpr],[RptItog])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*02.08.2006 09:49 ->Делаем дисконнект: освобождаем соединение
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*02.08.2006 09:49 ->Сохраним курсоры на диск и закроем
SELECT RptItog
COPY TO tmp\RptItog.dbf
***
USE IN SELECT([RptItog])
*------------------------------------------------------------------------------

*02.08.2006 10:04 ->Индексируем таблицу
USE RptItog IN 0
SELECT RptItog
INDEX ON OrgNM TAG OrgNM
INDEX ON OrgNM + RTRIM(CouponNM) TAG OrgCoupNM
***
USE IN SELECT([RptItog])
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
