*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: spGetTvrLbl()
* Called by.......: <NA>
* Parameters......: <none>
* Returns.........: <none>
* Notes...........: Формирование временной таблицы для печати ценников и этикеток
*------------------------------------------------------------------------------
PROCEDURE spGetTvrLbl
LPARAMETERS tcExecVar,tuParam1

*08.08.2005 12:10 -> Объявление и инициализация переменных
LOCAL	lcFilterExpr, ;
		luQryParTLUTypeEnabled, ;
		luQryParTLUTypeIDTableNM, ;
		luQryParPrcTypeEnabled, ;
		luQryParPrcTypeID, ;
		lnConnectHandle, ;
		lnSqlExeResult
		
LOCAL ARRAY aTvrLbl(1)
***
lcFilterExpr = [WHERE 1=0]
lcAliasListToClose = []
*------------------------------------------------------------------------------

DO CASE
	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[NODATA]
		
		*21.04.2004 12:34 ->Формируем фильтр, для формирования пустой выборки
		lcFilterExpr = [WHERE 1=0 ]
		*------------------------------------------------------------------------------

	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[BYTVRID]
		
		*21.04.2004 12:32 ->Формируем фильтр для выбора одного документа
		lcFilterExpr = [WHERE Tovar.TvrID = ]+ALLTRIM(STR(tuParam1))
		*------------------------------------------------------------------------------
		
	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[BYFILTER]
		
		*24.08.2005 16:45 -> Установим фильтр
		lcFilterExpr = [WHERE 1=1]
		*------------------------------------------------------------------------------

		*08.08.2005 12:19 ->Формируем фильтр по типам идентификаторов
		luQryParTLUTypeEnabled = oQryParMgr.ParamGet(tuParam1,[qplTLUTypeEnabled])
		***
		IF !ISNULL(luQryParTLUTypeEnabled) AND TYPE([luQryParTLUTypeEnabled])==[L] AND luQryParTLUTypeEnabled
			
			*08.08.2005 12:20 -> Получим имя временной таблицы с типами идентификаторов
			luQryParTLUTypeIDTableNM = oQryParMgr.ParamGet(tuParam1,[qpcTLUTypeIDTableNM])
			***
			IF !ISNULL(luQryParTLUTypeIDTableNM) AND TYPE([luQryParTLUTypeIDTableNM])==[C] AND FILE([tmp\]+luQryParTLUTypeIDTableNM+[.dbf])

				*26.03.2007 15:57 ->Сформируем фильтр
				lcFilterExpr = lcFilterExpr + ;
								[ AND TvrLookUp.TLUTypeID IN (]+spGetTmpValueList(luQryParTLUTypeIDTableNM)+[)]
				*------------------------------------------------------------------------------

			ENDIF
			*------------------------------------------------------------------------------		
			
		ENDIF
		*------------------------------------------------------------------------------
		
		*27.04.2006 12:19 ->Формируем фильтр по типам прайс-листов
		luQryParPrcTypeEnabled = oQryParMgr.ParamGet(tuParam1,[qplPrcTypeEnabled])
		***
		IF !ISNULL(luQryParPrcTypeEnabled) AND TYPE([luQryParPrcTypeEnabled])==[L] AND luQryParPrcTypeEnabled
			
			*27.04.2006 12:20 -> Получим идентификатор прайс-листа
			luQryParPrcTypeID = oQryParMgr.ParamGet(tuParam1,[qpnPrcTypeID])
			***
			IF !ISNULL(luQryParPrcTypeID) AND TYPE([luQryParPrcTypeID])==[N]
				lcFilterExpr = lcFilterExpr + [ AND Price.PrcTypeID = ]+ALLTRIM(STR(luQryParPrcTypeID))
			ENDIF
			*------------------------------------------------------------------------------		
			
		ENDIF
		*------------------------------------------------------------------------------
		
ENDCASE
*------------------------------------------------------------------------------

*26.03.2007 17:11 ->Коннектимся к БД через существующее соединение
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 ->Привязываем
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[SELECT ] + ;
			[Tovar.TvrID, ] + ;
			[Tovar.TvrNM, ] + ;
			[ISNULL(TvrLookUp.TLUID,000000) AS TLUID, ] + ;
			[ISNULL(TvrLookUp.TLU,SPACE(13)) AS TLU, ] + ;
			[0 AS Qnt, ] + ;
			[ISNULL(Price.Price,0) AS Price ] + ;
		[FROM Tovar ] + ;
		[INNER JOIN Price ON Price.TvrID = Tovar.TvrID ] + ;
		[LEFT JOIN TvrLookUp ON TvrLookUp.TvrID = Tovar.TvrID ] + ;
		lcFilterExpr, [curTvrLbl])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------


*26.03.2007 16:09->Делаем дисконнект: освобождаем соединение
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*09.08.2005 12:26 -> Сохраняем во временную таблицу результат
SELECT * FROM curTvrLbl INTO TABLE Tmp\TvrLbl.dbf
*------------------------------------------------------------------------------

*09.08.2005 12:26 -> Закроем курсор
USE IN IIF(USED([curTvrLbl]),[curTvrLbl],0)
*------------------------------------------------------------------------------

*09.08.2005 12:26 -> Закроем временную таблицу
USE IN IIF(USED([TvrLbl]),[TvrLbl],0)
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
