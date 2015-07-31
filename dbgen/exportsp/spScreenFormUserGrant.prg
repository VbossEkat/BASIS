*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: spScreenFormUserGrant()
* Called by.......: <NA>
* Parameters......: <tnUserID>
* Returns.........: <none>
* Notes...........: Получение списка доступных ЭФ для пользователя
*------------------------------------------------------------------------------
PROCEDURE spScreenFormUserGrant
LPARAMETERS tnUserID

*20.09.2006 10:47 ->Объявление и инициализация переменных
LOCAL   lcOldAlias, ;
		lnConnectHandle, ;
		lcSQLString, ;
		lnSqlExeResult, ;
		lcUniqueFileNM
***
lcOldAlias = ALIAS()
*------------------------------------------------------------------------------

*20.09.2006 10:47 ->Коннектимся к БД через существующее соединение
SET DATABASE TO Basis
***
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*20.09.2006 10:49 ->Формируем запрос
lcSQLString = ;
	[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
	[SELECT ] + ;
		[ScreenForm.ScrFrmObjDesc AS FrmDesc ] + ;
	[FROM UserGrant ] + ;
	[INNER JOIN ScreenForm ON ScreenForm.ScrFrmID = UserGrant.ObjectID ] + ;
	[WHERE ] + ;
		[UserGrant.UserId = ] + ALLTRIM(STR(tnUserID)) + [ AND ] + ;
		[UserGrant.ObjectTypeID = 1]
*------------------------------------------------------------------------------

*20.09.2006 10:58 ->Выполняем запрос
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, lcSQLString, [curScrFrm])
ENDDO
***
IF lnSqlExeResult = -1
	MESSAGEBOX([Произошла ошибка во время обмена данными с сервером.],16,[Ошибка соединения.])
	RETURN
ENDIF
*------------------------------------------------------------------------------

*20.09.2006 10:58 ->Сохраняем результат
IF RECCOUNT([curScrFrm]) # 0
	lcUniqueFileNM = [_ug]+SYS(2015)
	SELECT curScrFrm
	COPY TO ([tmp\]+lcUniqueFileNM+[.dbf])
ELSE
	lcUniqueFileNM = []
ENDIF
*------------------------------------------------------------------------------

*20.09.2006 11:03 ->Закроем курсор
USE IN SELECT([curScrFrm])
*------------------------------------------------------------------------------

*20.09.2006 11:03 ->Делаем дисконнект: освобождаем соединение
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*20.09.2006 11:03 ->Восстановим текущий Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias # ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*20.09.2006 11:03 ->Возвращаем результат
RETURN lcUniqueFileNM
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
