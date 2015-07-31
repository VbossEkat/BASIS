*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spTvrConstraintReport()
* Called by.......: <NA>
* Parameters......: <tcQryParSID>
* Returns.........: <lcUniqueName>
* Notes...........: Выборка для отчета "Ассортиментный минимум"
*------------------------------------------------------------------------------
PROCEDURE spTvrConstraintReport
LPARAMETERS tcQryParSID

*19.06.2006 10:26 ->Объявление и инициализация переменных
LOCAL	lcOldAlias, ;
		lcUniqueName
***
lcOldAlias = ALIAS()
*------------------------------------------------------------------------------

*19.06.2006 10:18 ->Получим данные для отчета
lcUniqueName = spTvrConstraintView(tcQryParSID)
*------------------------------------------------------------------------------

*19.06.2006 10:19 ->Формируем окончательную выборку
SELECT ;
	tmpTvrConstr.TvrID, ;
	tmpTvrConstr.TvrNM, ;
	tmpTvrConstr.OUNM, ;
	tmpTvrConstr.MsuNM, ;
	tmpTvrConstr.TvrMinQnt, ;
	tmpTvrConstr.TvrMaxQnt, ;
	tmpTvrConstr.TvrCurQnt ;
FROM ([tmp\]+lcUniqueName) tmpTvrConstr ;
WHERE tmpTvrConstr.TvrMinQnt > tmpTvrConstr.TvrCurQnt ;
INTO TABLE tmp\RptItog
*------------------------------------------------------------------------------

*19.06.2006 10:24 ->Закрываем таблицы
USE IN IIF(USED(lcUniqueName),lcUniqueName,0)
USE IN SELECT([RptItog])
*------------------------------------------------------------------------------

*19.06.2006 10:26 ->Восстановим текущий Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*19.06.2006 10:26 ->Вернем значение
RETURN [PrtItog.dbf]
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
