*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures For Basis
* Module/Procedure: spTvrSetEditSetSave()
* Called by.......: <NA>
* Parameters......: <tnTvrSetID>
* Returns.........: <none>
* Notes...........: Сохранение отредактированного набора товаров
*------------------------------------------------------------------------------
PROCEDURE spTvrSetEditSetSave
LPARAMETERS tnTvrSetID

*08.08.2005 10:29 ->Объявление и инициализация переменных
LOCAL	lnMarkItemCount, ;
		lnKeyCounter, ;
		lnConnectHandle, ;
		lnSqlExeResult
*------------------------------------------------------------------------------

*08.08.2005 10:20 ->Подсчтываем количество отмаркированных элементов
SELECT ;
	COUNT(*) AS MarkCount ;
FROM TvrInSetEdit ;
WHERE !TvrInSetEdit.TvrIsCnt AND TvrInSetEdit.Mark = ALL_CHILD_MARKED ;
INTO CURSOR curMarkCount
***
lnMarkItemCount = curMarkCount.MarkCount
*------------------------------------------------------------------------------

*04.08.2005 16:46 ->Создаем список суррогатных ключей
CREATE TABLE tmp\tmpKey FREE (Key I)
FOR lnKeyCounter = 1 TO lnMarkItemCount
   INSERT INTO tmpKey (Key) VALUES (lnKeyCounter)
ENDFOR &&* m.i = 1 TO 10
*------------------------------------------------------------------------------

*04.08.2005 16:55 ->Удаляем суррогатные ключи, уже используемые в данном наборе
DELETE FROM tmpKey WHERE Key IN (SELECT ListNumber FROM TvrInSetEdit)
*------------------------------------------------------------------------------

*04.08.2005 17:00 ->Присваиваем товарам новые ключи
GO TOP IN tmpKey
***
SELECT TvrInSetEdit
SCAN ALL FOR !TvrInSetEdit.TvrIsCnt AND TvrInSetEdit.Mark = ALL_CHILD_MARKED AND EMPTY(TvrInSetEdit.ListNumber)
	REPLACE TvrInSetEdit.ListNumber WITH tmpKey.Key
	SKIP IN tmpKey
ENDSCAN
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
			[TvrInSet.TvrInSetID, ] + ;
			[TvrInSet.TvrID, ] + ;
			[ISNULL(TvrInSet.TluID,0) AS TluID, ] + ;
			[TvrInSet.ListNumber ] + ;
		[FROM TvrInSet WHERE TvrInSet.TvrSetID = ?tnTvrSetID],[TvrInSet])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN
ENDIF
*------------------------------------------------------------------------------

*******************************************************************************
* Удаляем удаленные элементы набора из БД
*******************************************************************************

*08.08.2005 10:34 ->Выбираем удаленные элементы набора
SELECT ;
	TvrInSet.TvrInSetID AS ID, ;
	NVL(TvrInSetEdit.Mark,NOT_CHILD_MARKED) AS Mark ;
FROM TvrInSet ;
LEFT JOIN TvrInSetEdit ON TvrInSetEdit.TvrID = TvrInSet.TvrID AND TvrInSetEdit.TLUID = TvrInSet.TLUID ;
WHERE TvrInSetEdit.Mark # ALL_CHILD_MARKED ;
INTO CURSOR curTvrSetDeleted NOFILTER
*------------------------------------------------------------------------------
* WHERE NVL(TvrInSetEdit.Mark,NOT_CHILD_MARKED) # ALL_CHILD_MARKED ;

*08.08.2005 10:54 -> Удаляем из БД
IF RECCOUNT([curTvrSetDeleted]) # 0
	lnSqlExeResult = 0
	***
	DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
		lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
			[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
			[DELETE FROM TvrInSet WHERE TvrInSet.TvrInSetID IN (] + spGetTmpValueList([curTvrSetDeleted]) + [)])
	ENDDO
	***
	IF lnSqlExeResult = -1
		spHandleODBCError()
		RETURN
	ENDIF
ENDIF
*------------------------------------------------------------------------------

*******************************************************************************
* Добавляем добавленные элементы набора в БД
*******************************************************************************

*08.08.2005 11:22 ->Выбираем добавленные элементы набора
SELECT ;
	TvrInSetEdit.TvrID, ;
	IIF(TvrInSetEdit.TluID=0,CAST(.NULL. AS I),TvrInSetEdit.TluID) AS TluID, ;
	TvrInSetEdit.ListNumber, ;
	!ISNULL(TvrInSet.TvrInSetID) AS ExistInDB ;
FROM TvrInSetEdit ;
LEFT JOIN TvrInSet ON TvrInSet.TvrID = TvrInSetEdit.TvrID AND TvrInSet.TLUID = TvrInSetEdit.TLUID ;
WHERE !TvrInSetEdit.TvrIsCnt AND TvrInSetEdit.Mark = ALL_CHILD_MARKED ;
INTO CURSOR curTvrSetAdded NOFILTER
*------------------------------------------------------------------------------

*08.08.2005 10:54 ->Добавляем в БД
SELECT curTvrSetAdded
SCAN ALL FOR !ExistInDB

	*08.08.2005 10:54 -> Добавляем запись
	lnSqlExeResult = 0
	***
	DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
		lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
			[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
			[INSERT INTO TvrInSet ( ] + ;
				[TvrSetID, ] + ;
				[TvrID, ] + ;
				[TLUID, ] + ;
				[ListNumber ] + ;
			[) VALUES ( ] + ;
				[?tnTvrSetID, ] + ;
				[?curTvrSetAdded.TvrID, ] + ;
				[?curTvrSetAdded.TluID, ] + ;
				[?curTvrSetAdded.ListNumber)])
	ENDDO
	***
	IF lnSqlExeResult = -1
		spHandleODBCError()
		RETURN
	ENDIF
	*------------------------------------------------------------------------------

ENDSCAN
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> Делаем дисконнект: освобождаем соединение
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*08.08.2005 10:32 ->Закроем временные курсоры и удалим временные файлы
USE IN IIF(USED([curMarkCount]),[curMarkCount],0)
USE IN IIF(USED([curTvrSetDeleted]),[curTvrSetDeleted],0)
USE IN IIF(USED([curTvrSetAdded]),[curTvrSetAdded],0)
***
USE IN IIF(USED([tmpKey]),[tmpKey],0)
IF FILE([tmp\tmpKey.dbf])
	ERASE tmp\tmpKey.dbf
ENDIF
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
