*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures For Basis
* Module/Procedure: spTvrSetEditSetPrepare()
* Called by.......: <NA>
* Parameters......: <tnTvrSetID>
* Returns.........: <none>
* Notes...........: Подготовка данных для редактирования набора товаров
*------------------------------------------------------------------------------
PROCEDURE spTvrSetEditSetPrepare
LPARAMETERS tnTvrSetID

*02.08.2005 16:52 ->Объявление и инициализация переменных
LOCAL	_PARAM, ;
		lcTLUIdExp, ;
		lcTvrNMExp, ;
		lcTLUJoinExp, ;
		lcTvrSetTLUTypeJoinExp, ;
		lcTvrSetTvrTypeJoinExp, ;
		lcTvrInSetJoinExp, ;
		lnKeyCounter, ;
		lnConnectHandle, ;
		lnSqlExeResult
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
		[EXECUTE spTvrSetEditSetPrepare ?tnTvrSetID],[TvrInSetEdit])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN
ENDIF
*------------------------------------------------------------------------------

*04.08.2005 11:19 -> Сохраним курсор на диск и закроем
SELECT TvrInSetEdit
COPY TO tmp\TvrInSetEdit.dbf
USE IN SELECT([TvrInSetEdit])
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> Делаем дисконнект: освобождаем соединение
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*04.08.2005 16:43 ->Формируем список суррогатных идентификаторов
IF lvTvrSetByID.BindTLU
	
	*06.07.2006 15:54 -> Откроем товары в наборе
	USE TvrInSetEdit IN 0
	*------------------------------------------------------------------------------
	
	*04.08.2005 16:46 ->Создаем список суррогатных ключей
	CREATE TABLE tmp\tmpKey FREE (Key I)
	FOR lnKeyCounter = 1 TO RECCOUNT([TvrInSetEdit])
	   INSERT INTO tmpKey (Key) VALUES (lnKeyCounter)
	ENDFOR &&* m.i = 1 TO 10
	*------------------------------------------------------------------------------
	
	*04.08.2005 16:55 ->Удаляем суррогатные ключи, являющиеся идентификаторами групп
	DELETE FROM tmpKey WHERE Key IN (SELECT Key FROM TvrInSetEdit WHERE TvrInSetEdit.TvrIsCnt)
	*------------------------------------------------------------------------------
	
	*04.08.2005 17:00 ->Присваиваем товарам новые ключи
	GO TOP IN tmpKey
	***
	SELECT TvrInSetEdit
	SCAN ALL FOR !TvrInSetEdit.TvrIsCnt
		REPLACE TvrInSetEdit.TKey WITH tmpKey.Key
		SKIP IN tmpKey
	ENDSCAN
	*------------------------------------------------------------------------------
	
	*04.08.2005 11:19 ->Закроем Alias
	USE IN IIF(USED([TvrInSetEdit]),[TvrInSetEdit],0)
	*------------------------------------------------------------------------------

	*05.08.2005 16:14 ->Закроем временные курсоры и удалим временные таблицы
	USE IN IIF(USED([tmpKey]),[tmpKey],0)
	IF FILE([tmp\tmpKey.dbf])
		ERASE tmp\tmpKey.dbf
	ENDIF
	*------------------------------------------------------------------------------

ENDIF
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
