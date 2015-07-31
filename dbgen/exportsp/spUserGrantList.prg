*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spUserGrantList()
* Called by.......: <NA>
* Parameters......: <tnUserID,tcQryPar>
* Returns.........: <none>
* Notes...........: Список прав пользователей
*------------------------------------------------------------------------------
PROCEDURE spUserGrantList
LPARAMETERS tnUserID,tuQryPar

*07.02.2006 13:15 -> Объявление и инициализация переменных
LOCAL   lcOldAlias, ;
		lcUniqueName, ;
		lcUniqueFilePath, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcOldAlias	     = ALIAS()
lcUniqueName = [_ug] + SYS(2015)
lcUniqueFilePath = [tmp\] + lcUniqueName + [.DBF]
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
		[EXECUTE spUserGrantList ?tnUserID, ?tuQryPar],lcUniqueName)
ENDDO
***
IF lnSqlExeResult = -1

	*11.08.2006 17:26 ->Вызовем обработчик 
	spHandleODBCError()
	*------------------------------------------------------------------------------
	
	*11.08.2006 17:29 ->Создадим пустой курсор
	CREATE CURSOR (lcUniqueName) ( ;
		Mark L, ObjTypeID I, ObjID I, ObjNM C(1), ObjFunс C(1) ;
	)
	*------------------------------------------------------------------------------
	
ENDIF
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> Сохраним курсор в файл и закроем
SELECT (lcUniqueName)
***
COPY TO (lcUniqueFilePath)
***
USE IN SELECT(lcUniqueName)
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> Делаем дисконнект: освобождаем соединение
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*07.02.2006 13:28 -> Восстановим текущий Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
   SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*07.02.2006 14:07 -> Вернем имя таблицы со списком
RETURN lcUniqueName
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
