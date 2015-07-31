*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spRSTDiscRep()
* Called by.......: <When Document Printed>
* Parameters......: <tcQryParSID>
* Returns.........: <Список временных файлов, созданных для отчета>
* Author..........: Volga
* LastEditDate....: 31 August 2006
* Notes...........: Выборка для печати отчета по скидкам.
*-------------------------------------------------------
PROCEDURE spRSTDiscRep
LPARAMETERS tcQryParSID

*09.11.2006 21:39 ->Объявление и инициализация переменных
LOCAL	lcFilterExpr, ;
		lcOldDate, ;
		lcOldCentury, ;
		lcOldMark, ;
		luQryParDateEnabled, ;
		luQryParDateStartDate, ;
		luQryParDateEndDate, ;
		luQryParCashEnabled, ;
		luQryParCashTableNM, ;
		lnConnectHandle , ;
		lnSqlExeResult 
***		
lcFilterExpr = []
				
lcOldDate		   = SET([DATE])
lcOldCentury	   = SET([CENTURY])
lcOldMark		   = SET([MARK])
*------------------------------------------------------------------------------

*******************************************************************************
*Формируем выражения для отбора документов, соответствующих всем фильтрам
*******************************************************************************

*09.11.2006 21:40 ->Создаем таблицу с окружением для отчёта
CREATE TABLE tmp\RptEnv FREE (QryParSID C(10))
INSERT INTO RptEnv (QryParSID) VALUES (tcQryParSID)
*------------------------------------------------------------------------------

*09.11.2006 21:41 ->Дальнейшие параметры обрабатываем, если существует менеджер параметров
IF TYPE([oQryParMgr])==[O] AND !ISNULL(oQryParMgr)
	
	*09.11.2006 21:41 ->Формируем фильтр по дате
	luQryParDateEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplDateEnabled])
	***
	IF !ISNULL(luQryParDateEnabled) AND TYPE([luQryParDateEnabled])==[L] AND luQryParDateEnabled
		
		*09.11.2006 21:41 ->Получим дату стартовую и конечную
		luQryParDateStartDate = oQryParMgr.ParamGet(tcQryParSID,[qpdDateStart])
		luQryParDateEndDate = oQryParMgr.ParamGet(tcQryParSID,[qpdDateEnd])
		*------------------------------------------------------------------------------

		*09.11.2006 21:41 ->Установим формат даты YMD и CENTURY ON
		SET DATE YMD
		SET CENTURY ON
		SET MARK TO "/"
		*------------------------------------------------------------------------------

		*09.11.2006 21:41 ->Формируем условие
		DO CASE
			CASE	!ISNULL(luQryParDateStartDate) AND TYPE([luQryParDateStartDate])==[D] AND !EMPTY(luQryParDateStartDate) AND ;
					!ISNULL(luQryParDateEndDate) AND TYPE([luQryParDateEndDate])==[D] AND !EMPTY(luQryParDateEndDate)
					*{
					lcFilterExpr = lcFilterExpr + [ AND CheckSale.CheckStamp >= ']+STRTRAN(DTOC(luQryParDateStartDate),[/],[])+[' AND CheckSale.CheckStamp < ']+STRTRAN(DTOC(luQryParDateEndDate+1),[/],[])+[']
					*}
			CASE	!ISNULL(luQryParDateStartDate) AND TYPE([luQryParDateStartDate])==[D] AND !EMPTY(luQryParDateStartDate)
					*{
					lcFilterExpr = lcFilterExpr + [ AND CheckSale.CheckStamp  >= ']+STRTRAN(DTOC(luQryParDateStartDate),[/],[])+[']
					*}
			CASE	!ISNULL(luQryParDateEndDate) AND TYPE([luQryParDateEndDate])==[D] AND !EMPTY(luQryParDateEndDate)
					*{
					lcFilterExpr = lcFilterExpr + [ AND CheckSale.CheckStamp  < ']+STRTRAN(DTOC(luQryParDateEndDate+1),[/],[])+[']
					*}
		ENDCASE
		*------------------------------------------------------------------------------	
		
		*09.11.2006 21:41 ->Восстановим старый формат даты
		SET DATE (lcOldDate)
		SET CENTURY &lcOldCentury
		SET MARK TO lcOldMark
		*------------------------------------------------------------------------------

	ENDIF
	*------------------------------------------------------------------------------
	
	*09.11.2006 21:42 ->Формируем фильтр по кассе
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
ENDIF
*------------------------------------------------------------------------------

*09.11.2006 17:31 ->Коннектимся к БД через существующее соединение
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*09.11.2006 17:31 ->Установим свойство BatchMode в False, чтобы получать результирующие выборки с сервера по очереди командой SQLMoreResults
SQLSETPROP(lnConnectHandle,[BatchMode],.F.)
*------------------------------------------------------------------------------

*09.11.2006 17:31 ->Выполняем запрос
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE spRSTDiscRep ?lcFilterExpr],[tmpRptItog])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

SQLMORERESULTS(lnConnectHandle)

*09.11.2006 17:31 ->Делаем дисконнект: освобождаем соединение
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

SELECT tmpRptItog
COPY TO tmp\RptItog.dbf
***
USE IN SELECT([tmpRptItog])
*------------------------------------------------------------------------------


*--Вернем список файлов созданных для отчета
RETURN [RptItog.dbf]
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
