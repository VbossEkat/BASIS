*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spTop100SaleReport()
* Called by.......: <NA>
* Parameters......: <tcQryParSID>
* Returns.........: <none>
* Notes...........: Выборка для отчетов Top100
*------------------------------------------------------------------------------
PROCEDURE spTop100SaleReport
LPARAMETERS tcQryParSID

*30.11.2005 11:17 ->Объявление и инициализация переменных
LOCAL	lcOldAlias, ;
		luTop100Enabled, ;
		luQryParTop100Order, ;
		lcGroupExpr, ;
		lcQryInfo, ;
		lcResult
***
lcOldAlias			= ALIAS()
luQryParTop100Order = 0
lcGroupExpr			= [ORDER BY 4 DESC]
lcQryInfo			= [100 MAX продаж по сумме]
*------------------------------------------------------------------------------

*30.11.2005 11:16 ->Дальнейшие параметры обрабатываем, если существует менеджер параметров
IF TYPE([oQryParMgr])==[O] AND !ISNULL(oQryParMgr)
	
	*30.11.2005 11:16 ->Формируем фильтр для ограничения накоаительной суммы скидки
	luTop100Enabled = oQryParMgr.ParamGet(tcQryParSID,[qplTop100Enabled])
	*------------------------------------------------------------------------------
	
	*29.11.2005 10:38 ->Формируем
	IF !ISNULL(luTop100Enabled) AND TYPE([luTop100Enabled])==[L] AND luTop100Enabled
 
		*29.11.2005 10:30 ->Тип выборки
		luQryParTop100Order	= oQryParMgr.ParamGet(tcQryParSID,[qpnTop100Order])
		*------------------------------------------------------------------------------
		
		*30.11.2005 12:03 ->Сформируем выраженияе для упорядочивания выборки
		DO CASE
			CASE luQryParTop100Order = 2 && MAX по количеству
				lcGroupExpr = [ORDER BY 6 DESC]
				lcQryInfo	= [100 MAX продаж по количеству]
			CASE luQryParTop100Order = 3 && MIN по сумме
				lcGroupExpr = [ORDER BY 4]
				lcQryInfo	= [100 MIN продаж по сумме]
			CASE luQryParTop100Order = 4 && MIN по количеству
				lcGroupExpr = [ORDER BY 6]
				lcQryInfo	= [100 MIN продаж по количеству]
		ENDCASE	
		*------------------------------------------------------------------------------
		
	ENDIF
	*------------------------------------------------------------------------------
	
ENDIF
*------------------------------------------------------------------------------

*28.11.2005 13:27 ->Сформируем таблицу с данными о продажах со скидками по дисконтным картам
lcResult = spSaleReport(tcQryParSID)
*------------------------------------------------------------------------------

*30.11.2005 12:08 ->Сохраним дополнительный параметр отчета
UPDATE RptEnv SET QryTypeNM = lcQryInfo
*------------------------------------------------------------------------------

*30.11.2005 11:24 ->Формируем выборку для отчетов
SELECT TOP 100 ;
	tmpRptItog.TvrID, ;
	tmpRptItog.TvrNM, ;
	SUM(tmpRptItog.SumTran)		AS SumTran, ;
	SUM(tmpRptItog.SumTranWD)	AS SumTranWD, ;
	SUM(tmpRptItog.SumDisc)		AS SumDisc, ;
	SUM(tmpRptItog.TvrQnt)		AS TvrQnt;
FROM tmpRptItog ;
WHERE !tmpRptItog.IsAborted AND tmpRptItog.TvrQnt > 0 ;
GROUP BY 1,2 ;
&lcGroupExpr ;
INTO TABLE tmp\tmpRptTop100.dbf
*------------------------------------------------------------------------------

*30.11.2005 11:18 ->Восстановим текущий Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
   SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*21.04.2004 14:27 -> Вернем значение
RETURN [tmpRptTop100.dbf;] + IIF(TYPE([lcResult])=[C],lcResult,[])
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
