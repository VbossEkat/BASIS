*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spMakeActPro()
* Called by.......: <NA>
* Parameters......: <tnFrmID, tlShowMessageBox>
* Returns.........: <Кол-во подблюд (блюд содержащихся в блюдах)>
* Notes...........: Формирует акт производства по внесенным в него блюдам
*-------------------------------------------------------
PROCEDURE spMakeActPro
LPARAMETERS tnFrmID, tlShowMessageBox

*19.06.2006 12:23 ->Объявление и инициализация переменных
LOCAL   lnConnectHandle, ;
		lnSqlExeResult, ;
		lnRecCnt, ;
		llResult
***
llResult = 0
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
		[SELECT ] + ;
			[COUNT(*) AS RecCnt ] + ;
		[FROM FrmPartTvr ] + ;
		[INNER JOIN Tovar ON Tovar.TvrID = FrmPartTvr.TvrID ] + ;
		[WHERE FrmPartTvr.FrmID = ?tnFrmID AND Tovar.TvrTypeID NOT IN (5,6)], ;
		[curTmp])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN
ENDIF
***
lnRecCnt = curTmp.RecCnt
*------------------------------------------------------------------------------

*19.06.2006 12:29 -> Записи не найдены
IF lnRecCnt = 0

	*20.06.2006 13:24 -> Разворачиваем блюда и модификаторы
	lnSqlExeResult = 0
	***
	DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
		lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
			[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
			[INSERT INTO FrmPartTvr ( ] + ;
				[FrmID, ] + ;
				[TvrId, ] + ;
				[MsuId, ] + ;
				[TvrQnt, ] + ;
				[TvrPrcBuy, ] + ;
				[TvrPrcSale, ] + ;
				[TvrVATRate, ] + ;
				[TvrIDCalc, ] + ;
				[TvrAttr) ] + ;
			[SELECT ] + ;
				[FrmPartTvr.FrmID, ] + ;
				[FrmPartTvrAcc.TvrId, ] + ;
				[FrmPartTvrAcc.MsuId, ] + ;
				[FrmPartTvr.TvrQnt * FrmPartTvrAcc.TvrQnt * -1 /Accounting.AccQnt, ] + ;
				[FrmPartTvrAcc.TvrPrcBuy, ] + ;
				[FrmPartTvrAcc.TvrPrcSale, ] + ;
				[FrmPartTvrAcc.TvrVATRate, ] + ;
				[FrmPartTvr.TvrID, ] + ;
				[FrmPartTvrAcc.TvrAttr ] + ;
			[FROM FrmPartTvr ] + ;
			[INNER JOIN Tovar ON Tovar.TvrID = FrmPartTvr.TvrID ] + ;
			[INNER JOIN Accounting ON Accounting.AccTvrID = FrmPartTvr.TvrID ] + ;
			[INNER JOIN FrmPartTvr FrmPartTvrAcc ON FrmPartTvrAcc.FrmID = Accounting.AccFrmID ] + ;
			[INNER JOIN Tovar TovarAcc ON TovarAcc.TvrID = FrmPartTvrAcc.TvrID ] + ;
			[WHERE ] + ;
				[FrmPartTvr.FrmID = ?tnFrmID AND ] + ;
				[Tovar.TvrTypeID IN (5,6) AND ] + ;
				[TovarAcc.TvrTypeID <> 6])
	ENDDO
	***
	IF lnSqlExeResult = -1
		spHandleODBCError()
		RETURN
	ENDIF
	***
	llResult = curTmp.RecCnt
	*------------------------------------------------------------------------------

	*07.04.2006 16:45 -> Получим кол-во подблюд
	lnSqlExeResult = 0
	***
	DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
		lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
			[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
			[SELECT ] + ;
				[COUNT(*) AS RecCnt ] + ;
			[FROM FrmPartTvr ] + ;
			[INNER JOIN Tovar ON Tovar.TvrID = FrmPartTvr.TvrID ] + ;
			[WHERE ] + ;
				[FrmPartTvr.FrmID = ?tnFrmID AND ] + ;
				[Tovar.TvrTypeID IN (5,6) AND ] + ;
				[NOT (FrmPartTvr.TvrIDCalc IS NULL OR FrmPartTvr.TvrIDCalc = 0)], ;
			[curTmp])
	ENDDO
	***
	IF lnSqlExeResult = -1
		spHandleODBCError()
		RETURN
	ENDIF
	***
	llResult = curTmp.RecCnt
	*------------------------------------------------------------------------------

	*19.06.2006 12:09 -> Вывод сообщения
	IF TYPE([tlShowMessageBox]) = [L] AND tlShowMessageBox
		MESSAGEBOX([Обработка документа завершена],64,[Информация])
	ENDIF
	*------------------------------------------------------------------------------

ELSE

	*20.06.2006 12:39 -> Вывод сообщения пользователю
	WAIT WINDOW "В документе уже есть товарные позиции ..."
	*------------------------------------------------------------------------------

ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> Делаем дисконнект: освобождаем соединение
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*19.06.2006 12:30 -> Вернем результат
RETURN llResult
*------------------------------------------------------------------------------

************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spRSTCancelRep()
* Called by.......: <When Document Printed>
* Parameters......: <tcQryParSID>
* Returns.........: <Список временных файлов, созданных для отчета>
* Author..........: Volga
* LastEditDate....: 31 August 2006
* Notes...........: Выборка для печати отчета по отменам.
*-------------------------------------------------------
PROCEDURE spRSTCancelRep
LPARAMETERS tcQryParSID

*09.11.2006 17:50 ->Объявление и инициализация переменных
LOCAL	lcFilterExpr, ;
		lcOldDate, ;
		lcOldCentury, ;
		lcOldMark, ;
		luQryParDateEnabled, ;
		luQryParDateStartDate, ;
		luQryParDateEndDate, ;
		luQryParTvrEnabled, ;
		luQryParTvrIDTableNM, ;
		luQryParOUEnabled, ;
		luQryParOUIDTableNM, ;
		lnConnectHandle , ;
		lnSqlExeResult 
***
lcFilterExpr       = []

lcOldDate		   = SET([DATE])
lcOldCentury	   = SET([CENTURY])
lcOldMark		   = SET([MARK])
*------------------------------------------------------------------------------

*09.11.2006 18:00 ->Создаем таблицу с окружением для отчёта
CREATE TABLE tmp\RptEnv FREE (QryParSID C(10))
INSERT INTO RptEnv (QryParSID) VALUES (tcQryParSID)
*------------------------------------------------------------------------------

*******************************************************************************
*Формируем выражения для отбора документов, соответствующих всем фильтрам
*******************************************************************************

*--Дальнейшие параметры обрабатываем, если существует менеджер параметров
IF TYPE([oQryParMgr])==[O] AND !ISNULL(oQryParMgr)
	
	*--Формируем фильтр по дате
	luQryParDateEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplDateEnabled])
	***
	IF !ISNULL(luQryParDateEnabled) AND TYPE([luQryParDateEnabled])==[L] AND luQryParDateEnabled
		
		*--Получим дату стартовую и конечную
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
					lcFilterExpr = lcFilterExpr + [ AND Form.FrmDate >= ']+STRTRAN(DTOC(luQryParDateStartDate),[/],[])+[' AND Form.FrmDate < ']+STRTRAN(DTOC(luQryParDateEndDate+1),[/],[])+[']
					*}
			CASE	!ISNULL(luQryParDateStartDate) AND TYPE([luQryParDateStartDate])==[D] AND !EMPTY(luQryParDateStartDate)
					*{
					lcFilterExpr = lcFilterExpr + [ AND Form.FrmDate >= ']+STRTRAN(DTOC(luQryParDateStartDate),[/],[])+[']
					*}
			CASE	!ISNULL(luQryParDateEndDate) AND TYPE([luQryParDateEndDate])==[D] AND !EMPTY(luQryParDateEndDate)
					*{
					lcFilterExpr = lcFilterExpr + [ AND Form.FrmDate < ']+STRTRAN(DTOC(luQryParDateEndDate+1),[/],[])+[']
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

	*14.06.2006 15:47 ->Формируем фильтр (Выбор товара (блюда))
	luQryParTvrEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplTvrEnabled])
	***
	IF !ISNULL(luQryParTvrEnabled) AND TYPE([luQryParTvrEnabled])==[L] AND luQryParTvrEnabled
				
		*14.06.2006 15:47 ->Получим имя временной таблицы с идентификаторами товаров (блюд)
		luQryParTvrIDTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcTvrIDTableNM])
		***
		IF !ISNULL(luQryParTvrIDTableNM) AND TYPE([luQryParTvrIDTableNM])==[C] AND FILE([tmp\]+luQryParTvrIDTableNM+[.dbf])

			*10.04.2006 11:35 -> Сформируем фильтр
			lcFilterExpr = lcFilterExpr + ;
							[ AND Tovar.TvrID IN (] + spGetTmpValueList(luQryParTvrIDTableNM) + [)]
			*------------------------------------------------------------------------------

		ENDIF
		*------------------------------------------------------------------------------		
				
	ENDIF
	*------------------------------------------------------------------------------

	*09.11.2006 17:28 ->Формируем условие выбора по подразделению
	luQryParOUEnabled   = oQryParMgr.ParamGet(tcQryParSID,[qplParOUEmiEnabled])
	luQryParOUIDTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcParOUEmiIDTableNM])
	***
	IF !ISNULL(luQryParOUEnabled)   AND TYPE([luQryParOUEnabled])==[L]   AND luQryParOUEnabled AND ;
	   !ISNULL(luQryParOUIDTableNM) AND TYPE([luQryParOUIDTableNM])==[C]

	   	*09.11.2006 17:28 ->Сформируем условия выбора
	   	lcValueList = spGetTmpValueList(luQryParOUIDTableNM)
	   	***
		lcFilterExpr = lcFilterExpr + [ AND (OrgUnit.OUParID IN (] + lcValueList + [))]
		*------------------------------------------------------------------------------

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
		[EXECUTE spRSTCancelRep ?lcFilterExpr],[tmpRptItog])
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
