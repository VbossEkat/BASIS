*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spFrmPartFrmView()
* Called by.......: <NA>
* Parameters......: <tcExecVar[,tuFrmID[,tuFrmPartFrmID]]>
*					<[NODATA]>
*					<[BYFRMID],tnFrmID>
*					<[BYFRMPARTFRMID],tnFrmID,tnFrmPartFrmID>
* Returns.........: <lcUniqueFileName>
* Notes...........: Получение данных для просмотра суммовых позиций документа
*-------------------------------------------------------
PROCEDURE spFrmPartFrmView
LPARAMETERS tcExecVar,tuFrmID,tuFrmPartFrmID

*21.04.2004 12:31 ->Объявление и инициализация переменных
LOCAL	lcUniqueName, ;
		lcUniqueFilePath, ;
		lcFilterExpr, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcUniqueName = [_d] + SYS(2015)
lcUniqueFilePath = [tmp\] + lcUniqueName + [.DBF]
*------------------------------------------------------------------------------

*21.04.2004 12:33 ->Формируем фильтры в зависимости от типа запроса
DO CASE

	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[NODATA]
		
		*21.04.2004 12:34 ->Формируем фильтр, для формирования пустой выборки
		lcFilterExpr = [WHERE 0=1]
		*------------------------------------------------------------------------------

	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[BYFRMID]
		
		*21.04.2004 12:32 ->Формируем фильтр для выбора суммовых позиций одного документа
		lcFilterExpr = [WHERE FrmPartFrm.FrmID = ]+ALLTRIM(STR(tuFrmID))
		*------------------------------------------------------------------------------
	
	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[BYFRMPARTFRMID]
		
		*21.04.2004 12:32 ->Формируем фильтр для выбора суммовых позиций одного документа
		lcFilterExpr = 	[WHERE FrmPartFrm.FrmID = ] + ALLTRIM(STR(tuFrmID)) + [ ] + ;
						[AND FrmPartFrm.FrmPartFrmID = ] + ALLTRIM(STR(tuFrmPartFrmID))
		*------------------------------------------------------------------------------

ENDCASE
*------------------------------------------------------------------------------		

*07.04.2006 16:13 -> Коннектимся к БД через существующее соединение
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> Выполняем запрос
lnSqlExeResult = -1
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE spFrmPartFrmView ?lcFilterExpr],lcUniqueName)
ENDDO
***
IF lnSqlExeResult = -1

	*11.08.2006 15:29 ->Вызовем обработчик ошибок
	spHandleODBCError()
	*------------------------------------------------------------------------------
	
	*11.08.2006 15:30 ->Создадим пустой курсор
	CREATE CURSOR (lcUniqueName) ( ;
		PartFrmID I, CntFrmNM C(1), CntFrmSum I, CntFrmVAT I, CntFrmId I ;
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

*21.04.2004 14:27 ->Вернем значение
RETURN lcUniqueName
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
