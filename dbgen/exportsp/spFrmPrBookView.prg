*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spFrmPrBookView()
* Called by.......: <NA>
* Parameters......: <tcExecVar[,tuFrmID[,tnFrmPartFrmID]]>
*					<[NODATA]>
*					<[BYFRMID],tnFrmID>
*					<[BYFRMPARTTVRID],tnFrmID,tnFrmPartID>
* Returns.........: <lcUniqueFileName>
* Notes...........: Получение данных для просмотра проводок соответствующих документу
*-------------------------------------------------------
PROCEDURE spFrmPrBookView
LPARAMETERS tcExecVar,tuFrmID,tuFrmPartID

*05.08.2006 12:31 ->Объявление и инициализация переменных
LOCAL	lcUniqueName, ;
		lcUniqueFilePath, ;
		lcFilterExpr, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcUniqueName = [_d] + SYS(2015)
lcUniqueFilePath = [tmp\] + lcUniqueName + [.DBF]
*------------------------------------------------------------------------------
*05.08.2006 12:33 ->Формируем фильтры в зависимости типы запроса
DO CASE
	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[NODATA]
		
		*05.08.2006 12:34 ->Формируем фильтр, для формирования пустой выборки
		lcFilterExpr = [WHERE 0=1]
		*------------------------------------------------------------------------------

	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[BYFRMID]
		
		*05.08.2006 12:32 ->Формируем фильтр для выбора товарных позиций одного документа
		lcFilterExpr = [WHERE FrmPrBookView.PBookFrmID = ]+ALLTRIM(STR(tuFrmID))
		*------------------------------------------------------------------------------
	
	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[BYFRMPARTID]
		
		*05.08.2006 12:32 ->Формируем фильтр для выбора суммовых позиций одного документа
		lcFilterExpr = 	[WHERE FrmPrBookView.PBookID = ] + ALLTRIM(STR(tuFrmPartID))
		*------------------------------------------------------------------------------

ENDCASE
*------------------------------------------------------------------------------		

*05.08.2006 16:13 -> Коннектимся к БД через существующее соединение
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*05.08.2006 16:45 -> Выполняем запрос
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE spFrmPrBookView ?lcFilterExpr],lcUniqueName)
ENDDO
***
IF lnSqlExeResult = -1
	*11.08.2006 15:37 ->Вызовем обработчик ошибок
	spHandleODBCError()
	*------------------------------------------------------------------------------
	
	*11.08.2006 15:30 ->Создадим пустой курсор
	CREATE CURSOR (lcUniqueName) ( ;
		PBookID I, PBookFrmID I, PBookSum Y, Debet I, Credit I, PBookProvID I, DebetID I, CreditID I, FrmPartId I ;
	)
	*------------------------------------------------------------------------------
	
ENDIF
*------------------------------------------------------------------------------

*05.08.2006 14:07 -> Сохраним курсор в файл и закроем
SELECT (lcUniqueName)
***
COPY TO (lcUniqueFilePath)
***
USE IN SELECT(lcUniqueName)
*------------------------------------------------------------------------------

*05.08.2006 16:12 -> Делаем дисконнект: освобождаем соединение
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*05.08.2006 14:27 ->Вернем значение
RETURN lcUniqueName
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
