*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spSaleDiscCardReport()
* Called by.......: <NA>
* Parameters......: <tcQryParSID>
* Returns.........: <none>
* Notes...........: Формирование выборки для отчета по дисконтным картам
*------------------------------------------------------------------------------
PROCEDURE spSaleDiscCardReport
LPARAMETERS tcQryParSID

*28.11.2005 13:27 ->Объявление и инициализация переменных
LOCAL   lcOldAlias, ;
		lcHavingExpr, ;
		luQryParRangeEnabled, ;
		luQryParRangeSign, ;
		luQryParRangeValue, ;
		lcResult
***
lcOldAlias   = ALIAS()
lcHavingExpr = []		
*------------------------------------------------------------------------------

*21.07.2005 12:13 ->Дальнейшие параметры обрабатываем, если существует менеджер параметров
IF TYPE([oQryParMgr])==[O] AND !ISNULL(oQryParMgr)
	
	*29.11.2005 10:33 ->Формируем фильтр для ограничения накопительной суммы скидки
	luQryParRangeEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplRangeDiscEnabled])
	*------------------------------------------------------------------------------
	
	*29.11.2005 10:38 ->Формируем
	IF !ISNULL(luQryParRangeEnabled) AND TYPE([luQryParRangeEnabled])==[L] AND luQryParRangeEnabled
 
		*29.11.2005 10:30 ->Получим дату стартовую и конечную
		luQryParRangeSign	= oQryParMgr.ParamGet(tcQryParSID,[qpcRangeSign])
		luQryParRangeValue	= oQryParMgr.ParamGet(tcQryParSID,[qpnRangeValue])
		*------------------------------------------------------------------------------
			
		*29.11.2005 10:33 ->Формируем условие
		lcHavingExpr = [HAVING SUM(ROUND(MTON(tmpRptItog.SumTran),2)) ]+luQryParRangeSign+ALLTRIM(STR(luQryParRangeValue,20,2))
		*------------------------------------------------------------------------------
		
	ENDIF
	*------------------------------------------------------------------------------
	
ENDIF
*------------------------------------------------------------------------------

*28.11.2005 13:27 ->Сформируем таблицу с данными о продажах со скидками по дисконтным картам
lcResult = spSaleReport(tcQryParSID,.T.)
*------------------------------------------------------------------------------

*28.11.2005 13:34 ->Вычисляем сумму накопления по дисконтным картам
SELECT ;
	MAX(tmpRptItog.CheckDate)	AS CheckDate, ;
	tmpRptItog.DiscCardID, ;
	tmpRptItog.DiscCardNo, ;
	SUM(tmpRptItog.SumTran)	  AS AccumSum, ;
	SUM(tmpRptItog.SumTranWD) AS AccumSumWD, ;
	SUM(tmpRptItog.SumDisc)	  AS AccumSisc, ;
	NVL(Client.CltNM,SPACE(40))	AS CltNM ;
FROM tmpRptItog ;
LEFT JOIN DiscCard	ON DiscCard.DiscCardID = tmpRptItog.DiscCardID ;
LEFT JOIN Client	ON Client.CltID = DiscCard.CltID ;
WHERE !tmpRptItog.IsAborted ;
GROUP BY 2,3,7 &lcHavingExpr ;
ORDER BY 4 DESC; 
INTO CURSOR curDiscCardResult NOFILTER
*------------------------------------------------------------------------------

*28.11.2005 13:57 ->Перенесем данные в таблицу для отчета
USE IN SELECT([tmpRptItog])
SELECT * FROM curDiscCardResult INTO TABLE tmp\tmpRptItog
*-----------------------------------------------------------------------------

*28.11.2005 13:59 ->Закроем курсор
USE IN SELECT([curDiscCardResult])
*------------------------------------------------------------------------------

*28.11.2005 13:28 ->Восстановим текущий Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
   SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*21.04.2004 14:27 -> Вернем значение
RETURN lcResult
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
