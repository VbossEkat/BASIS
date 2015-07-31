*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: _spMainMarked()
* Called by.......: <NA>
* Parameters......: <tcTableNM, tcFieldNameFlag, tcFieldNameID, tnID>
* Returns.........: <none>
* Notes...........: Проверка уникальности флага "Основной"
*-------------------------------------------------------
PROCEDURE _spMainMarked
LPARAMETERS	tcTableNM, tcFieldNameFlag, tcFieldNameID, tnID

*24.08.2005 14:15 -> Объявление и инициализация переменных
LOCAL	lcFilterExpr, ;
		lcQuery, ;
		lnSqlExeResult, ;
		llResult
***
lcFilterExpr = [WHERE ] + tcFieldNameFlag + [ = 1]
*------------------------------------------------------------------------------

*24.08.2005 14:16 -> Устанавливаем дополнительный фильтр
IF PCOUNT()=4
	lcFilterExpr = lcFilterExpr + [ AND ] + tcFieldNameID + [ = ?tnID]
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:44 -> Формируем запрос к БД
lcQuery = [SELECT ] + tcFieldNameFlag + [ FROM ] + tcTableNM + [ ] + lcFilterExpr
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> Коннектимся к БД через существующее соединение
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> Выполняем запрос
lnSqlExeResult = 0
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		lcQuery,[tmp])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN 0
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:46 -> Сохраним результат
llResult = RECCOUNT([tmp]) > 0
*------------------------------------------------------------------------------

*07.04.2006 16:46 -> Закроем курсор
USE IN tmp
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> Делаем дисконнект: освобождаем соединение
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> Возвращаем результат
RETURN llResult
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
