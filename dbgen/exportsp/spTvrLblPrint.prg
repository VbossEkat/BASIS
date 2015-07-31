*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: spTvrLblPrint()
* Called by.......: <NA>
* Parameters......: <none>
* Returns.........: <Список временных файлов, созданных для отчета>
* Notes...........: Выборка для печати ценников и этикеток
*-------------------------------------------------------
PROCEDURE spTvrLblPrint
LPARAMETERS tcQryParSID

*21.04.2004 12:31 -> Объявление и инициализация переменных
LOCAL	lcOldAlias, ;
		lcFilterExpr, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcOldAlias = ALIAS()
lcFilterExpr = [WHERE 1=1]
*------------------------------------------------------------------------------

*26.05.2006 16:04 -> Формируем фильтр (набор товаров)
luQryParTvrSetEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplTvrSetEnabled])
***
IF !ISNULL(luQryParTvrSetEnabled) AND TYPE([luQryParTvrSetEnabled])==[L] AND luQryParTvrSetEnabled

	*26.05.2006 16:05 -> Получим имя таблицы с идентификаторами наборов товаров
	luQryParTvrSetIDTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcTvrSetIDTableNM])
	***
	IF !ISNULL(luQryParTvrSetIDTableNM) AND TYPE([luQryParTvrSetIDTableNM])==[C] AND FILE([tmp\]+luQryParTvrSetIDTableNM+[.dbf])
		lcFilterExpr = lcFilterExpr + ;
						[ AND TvrInSet.TvrSetID IN (]+spGetTmpValueList(luQryParTvrSetIDTableNM)+[)]
	ENDIF
	*------------------------------------------------------------------------------
	
ENDIF
*------------------------------------------------------------------------------

*26.03.2007 16:23 -> Коннектимся к БД через существующее соединение
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*26.03.2007 16:27 ->Создаем таблицу для хранения списка отобранных товаров
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[IF OBJECT_ID('tempdb..#TvrLblQnt') IS NULL CREATE TABLE #TvrLblQnt(TvrID Int, TLUID Int, Price Money, Qnt Numeric(10,3))])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*26.03.2007 16:24 ->Сохраняем список отобранных товаров
USE TvrLblQnt IN 0
SELECT TvrLblQnt
SCAN ALL

	lnSqlExeResult = 0
	***
	DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
		lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
			[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
			[INSERT INTO #TvrLblQnt (TvrID,TLUID,Price,Qnt) VALUES (] + ;
				ALLTRIM(STR(TvrLblQnt.TvrID)) + [,] + ;
				ALLTRIM(STR(TvrLblQnt.TLUID)) + [,] + ;
				ALLTRIM(STR(TvrLblQnt.Price,10,2)) + [,] + ;
				ALLTRIM(STR(TvrLblQnt.Qnt,10,3)) + [)])
	ENDDO	
	***
	IF lnSqlExeResult = -1
		spHandleODBCError()
		RETURN .F.
	ENDIF

ENDSCAN
*------------------------------------------------------------------------------

*27.07.2005 11:04 -> Выберем информацию по товарам, отмеченным для печати
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)

	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[SELECT ] + ;
			[#TvrLblQnt.TvrID, ] + ;
			[TvrLookUp.TLUID, ] + ;
			[#TvrLblQnt.Qnt, ] + ;
			[#TvrLblQnt.Price, ] + ;
			[Tovar.TvrNM, ] + ;
			[ISNULL(TvrLookUp.TLU,'') AS TLU, ] + ;
			[ISNULL(Client.CltNM,'') AS MakerNM, ] + ;
			[ISNULL(CltAddress.CltAddrSettlNM,'') AS MakerSity, ] + ;
			[ISNULL(CltCountry.CltCountryNM,'') AS MakerState, ] + ;
			[ISNULL(Accounting.AccExit,'') AS AccExit, ] + ;
			[ISNULL(TvrInSet.ListNumber, 0) AS ListNumber ] + ;
		[FROM #TvrLblQnt ] + ;
		[INNER JOIN Tovar		ON Tovar.TvrID = #TvrLblQnt.TvrID ] + ;
		[LEFT JOIN TvrLookUp 	ON TvrLookUp.TLUID = #TvrLblQnt.TLUID ] + ;
		[LEFT JOIN Accounting	ON Accounting.AccTvrID = #TvrLblQnt.TvrID ] + ;
		[LEFT JOIN Client		ON Client.CltID = Tovar.MakerCltID ] + ;
		[LEFT JOIN CltAddress	ON CltAddress.CltID = Client.CltID ] + ;
		[LEFT JOIN CltCountry	ON CltCountry.CltCountryID = CltAddress.CltCountryID ] + ;
		[LEFT JOIN TvrInSet		ON TvrInSet.TvrID = Tovar.TvrID ] + ;
		lcFilterExpr, [curRptItog])
	***
	IF lnSqlExeResult = -1
		spHandleODBCError()
		RETURN .F.
	ENDIF
	
ENDDO
*------------------------------------------------------------------------------

*26.03.2007 16:09->Делаем дисконнект: освобождаем соединение
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*04.08.2005 17:46 -> Выберем товары из предыдущей выборки, но без учёта количества
SELECT ;
	curRptItog.TvrID, ;
	curRptItog.TLUID, ;
	curRptItog.TvrNM, ;
	curRptItog.TLU, ;
	curRptItog.Price, ;
	curRptItog.MakerNM, ;
	curRptItog.MakerSity, ;
	curRptItog.MakerState, ;
	curRptItog.AccExit, ;
	curRptItog.ListNumber ;
FROM curRptItog ;
INTO TABLE tmp\tmpRptItog
*------------------------------------------------------------------------------

*27.07.2005 11:04 -> Для нескольких экземпляров сделаем несколько записей
SELECT curRptItog
***
SCAN FOR curRptItog.Qnt > 1
	SCATTER MEMVAR
	FOR m.i = 2 TO curRptItog.Qnt
		INSERT INTO tmpRptItog FROM MEMVAR
	ENDFOR
ENDSCAN
*------------------------------------------------------------------------------

*04.08.2005 17:25 -> Закроем курсор
USE IN IIF(USED([curRptItog]),[curRptItog],0)
*------------------------------------------------------------------------------

*09.08.2005 14:28 -> Отсортируем записи
SELECT ;
	tmpRptItog.TvrID, ;
	tmpRptItog.TLUID, ;
	tmpRptItog.TvrNM, ;
	tmpRptItog.TLU, ;
	tmpRptItog.Price, ;
	tmpRptItog.MakerNM, ;
	tmpRptItog.MakerSity, ;
	tmpRptItog.MakerState, ;
	tmpRptItog.AccExit, ;
	tmpRptItog.ListNumber ;
FROM tmpRptItog ;
ORDER BY tmpRptItog.TvrNM, tmpRptItog.ListNumber ;
INTO TABLE tmp\RptItog
*------------------------------------------------------------------------------

*09.08.2005 14:30 -> Закроем и удаляем временную таблицу
USE IN IIF(USED([tmpRptItog]),[tmpRptItog],0)
***
IF FILE([Tmp\tmpRptItog.dbf])
	ERASE Tmp\tmpRptItog.dbf
ENDIF
*------------------------------------------------------------------------------

*09.08.2005 14:31 -> Закроем таблицу
USE IN IIF(USED([RptItog]),[RptItog],0)
*------------------------------------------------------------------------------

*27.07.2005 11:56 -> Восстановим текущий Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*27.07.2005 11:05 -> Вернем список файлов созданных для отчёта
RETURN [RptItog.dbf]
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
