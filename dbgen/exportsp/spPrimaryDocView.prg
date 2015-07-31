*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: spPrimaryDocView()
* Called by.......: <Form Data Request>
* Parameters......: <tcExecVar[,tuParam1,tuParam2]>
*					<[NODATA]>
*					<[BYFRMID],tnScrFrmID,tnFrmID>
*					<[BYFILTER],tnScrFrmID,tcQryParSID>
* Returns.........: <lcUniqueFileName>
* Notes...........: Получение данных для просмотра документов для конкретной формы.
*------------------------------------------------------------------------------
PROCEDURE spPrimaryDocView
LPARAMETERS tcExecVar,tuParam1,tuParam2

*21.04.2004 12:31 -> Объявление и инициализация переменных
LOCAL	lcOldDate, ;
		lcOldCentury, ;
		lcOldMark, ;
		lcUniqueName, ;
		lcUniqueFilePath, ;
		lcFilterExpr, ;
		lcValueList, ;
		luQryParDateEnabled, ;
		luQryParDateStartDate, ;
		luQryParDateEndDate, ;
		luQryParCltEnabled, ;
		luQryParCltIDTableNM, ;
		luQryParOUEnabled, ;
		luQryParOUIDTableNM, ;
		luQryParFrmTypeEnabled, ;
		luQryParFrmTypeIDTableNM, ;
		luQryParFrmStatEnabled, ;
		luQryParFrmStatIDTableNM, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcOldDate = SET([DATE])
lcOldCentury = SET([CENTURY])
lcOldMark = SET([MARK])
lcUniqueName = [_d] + SYS(2015)
lcUniqueFilePath = [tmp\] + lcUniqueName + [.DBF]
*------------------------------------------------------------------------------

*21.04.2004 12:33 -> Формируем фильтры в зависимости от типа запроса
DO CASE

	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[NODATA]

		*21.04.2004 12:34 -> Формируем фильтр, для формирования пустой выборки
		lcFilterExpr = [WHERE 0=1]
		*------------------------------------------------------------------------------

	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[11QUEUE]

		*21.04.2004 12:34 -> Формируем фильтр, для формирования пустой выборки
		lcFilterExpr = [WHERE Form.FrmID IN (SELECT Frmpayqueue.frmid FROM frmpayqueue)]
		*------------------------------------------------------------------------------

	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[BYFRMID]

		*21.04.2004 12:32 -> Формируем фильтр для выбора одного документа
		lcFilterExpr = [WHERE 0<>1] + ;
							[ AND ScrFrmViewObj.ScrFrmID = ] + ALLTRIM(STR(tuParam1)) + ;
							[ AND Form.FrmID = ]+ALLTRIM(STR(tuParam2))
		*------------------------------------------------------------------------------

	CASE TYPE([tcExecVar])==[C] AND (tcExecVar==[BYFILTER] OR tcExecVar==[QUEUE])

		*********************************************************************************
		*Формируем выражения для отбора документов, соответствующих всем фильтрам		*
		*********************************************************************************
		
		*26.05.2004 21:08 -> Основное условие, для отбора документов по ЭФ
		IF tcExecVar==[QUEUE]
		   lcFilterExpr = [WHERE Form.FrmID IN (SELECT Frmpayqueue.frmid FROM frmpayqueue) ] + ;
							[ AND ScrFrmViewObj.ScrFrmID = ] + ALLTRIM(STR(tuParam1))
		ELSE
		   lcFilterExpr = [WHERE 0<>1] + ;
							[ AND ScrFrmViewObj.ScrFrmID = ] + ALLTRIM(STR(tuParam1))
		ENDIF
		*------------------------------------------------------------------------------

		*26.05.2004 21:20 -> Дальнейшие параметры обрабатываем, если существует менеджер параметров
		IF TYPE([oQryParMgr])==[O] AND !ISNULL(oQryParMgr)

			*26.05.2004 21:18 -> Формируем фильтр по дате
			luQryParDateEnabled = oQryParMgr.ParamGet(tuParam2,[qplDateEnabled])
			***
			IF !ISNULL(luQryParDateEnabled) AND TYPE([luQryParDateEnabled])==[L] AND luQryParDateEnabled

				*26.05.2004 21:33 -> Получим дату стартовую и конечную
				luQryParDateStartDate = oQryParMgr.ParamGet(tuParam2,[qpdDateStart])
				luQryParDateEndDate = oQryParMgr.ParamGet(tuParam2,[qpdDateEnd])
				*------------------------------------------------------------------------------

				*21.04.2006 10:33 -> Установим формат даты YMD и CENTURY ON
				SET DATE YMD
				***
				SET CENTURY ON
				***
				SET MARK TO "/"
				*------------------------------------------------------------------------------

				*26.05.2004 21:27 -> Формируем условие
				DO CASE
					CASE	!ISNULL(luQryParDateStartDate) AND TYPE([luQryParDateStartDate])==[D] AND !EMPTY(luQryParDateStartDate) AND ;
							!ISNULL(luQryParDateEndDate) AND TYPE([luQryParDateEndDate])==[D] AND !EMPTY(luQryParDateEndDate)
							*{
							lcFilterExpr = lcFilterExpr + [ AND Form.FrmDate >= ']+STRTRAN(DTOC(luQryParDateStartDate),[/],[])+[' AND Form.FrmDate < ']+STRTRAN(DTOC(luQryParDateEndDate+1),[/],[])+[']
							*}
					CASE	!ISNULL(luQryParDateStartDate) AND TYPE([luQryParDateStartDate])==[D] AND !EMPTY(luQryParDateStartDate)
							*{
							lcFilterExpr = lcFilterExpr + [ AND Form.FrmDate >= ']+STRTRAN(DTOC(luQryParDateStartDate),[/],[])+[']
							*}
					CASE	!ISNULL(luQryParDateEndDate) AND TYPE([luQryParDateEndDate])==[D] AND !EMPTY(luQryParDateEndDate)
							*{
							lcFilterExpr = lcFilterExpr + [ AND Form.FrmDate < ']+STRTRAN(DTOC(luQryParDateEndDate+1),[/],[])+[']
							*}
				ENDCASE
				*------------------------------------------------------------------------------	

				*21.04.2006 10:33 -> Восстановим старый формат даты
				SET DATE (lcOldDate)
				***
				SET CENTURY &lcOldCentury
				***
				SET MARK TO lcOldMark
				*------------------------------------------------------------------------------

			ENDIF
			*------------------------------------------------------------------------------

			*27.05.2004 00:29 -> Формируем фильтр (Выбор клиента (EMI))
			luQryParCltEnabled = oQryParMgr.ParamGet(tuParam2,[qplCltEmiEnabled])
			***
			IF !ISNULL(luQryParCltEnabled) AND TYPE([luQryParCltEnabled])==[L] AND luQryParCltEnabled
				
				*27.05.2004 00:32 -> Получим имя временной таблицы с идентификаторами клиентов
				luQryParCltIDTableNM = oQryParMgr.ParamGet(tuParam2,[qpcCltEmiIDTableNM])
				***
				IF !ISNULL(luQryParCltIDTableNM) AND TYPE([luQryParCltIDTableNM])==[C] AND FILE([tmp\]+luQryParCltIDTableNM+[.dbf])

					*10.04.2006 11:35 -> Сформируем фильтр
					lcFilterExpr = lcFilterExpr + ;
									[ AND Form.PointEmiCltID IN (] + spGetTmpValueList(luQryParCltIDTableNM) + [)]
					*------------------------------------------------------------------------------

				ENDIF
				*------------------------------------------------------------------------------		

			ENDIF
			*------------------------------------------------------------------------------

			*23.04.2006 00:29 ->Формируем фильтр (Выбор товаров)
			luQryParTvrEnabled = oQryParMgr.ParamGet(tuParam2,[qplTvrEnabled])
			***
			IF !ISNULL(luQryParTvrEnabled) AND TYPE([luQryParTvrEnabled])==[L] AND luQryParTvrEnabled
				
				*23.04.2006 00:32 ->Получим имя временной таблицы с идентификаторами товАРОВ 
				luQryParTvrIDTableNM = oQryParMgr.ParamGet(tuParam2,[qpcTvrIDTableNM])
				***
				IF !ISNULL(luQryParTvrIDTableNM) AND TYPE([luQryParTvrIDTableNM])==[C] AND FILE([tmp\]+luQryParTvrIDTableNM+[.dbf])

					*10.04.2006 11:35 -> Сформируем фильтр
					lcFilterExpr = lcFilterExpr + ;
									[ AND FrmPartTvr.TvrId IN (] + spGetTmpValueList(luQryParTvrIDTableNM) + [)]
					*------------------------------------------------------------------------------

				ENDIF
				*------------------------------------------------------------------------------		

			ENDIF
			*------------------------------------------------------------------------------

			*27.05.2004 00:29 ->Формируем фильтр (Выбор клиента (ISP))
			luQryParCltEnabled = oQryParMgr.ParamGet(tuParam2,[qplCltIspEnabled])
			***
			IF !ISNULL(luQryParCltEnabled) AND TYPE([luQryParCltEnabled])==[L] AND luQryParCltEnabled
				
				*27.05.2004 00:32 ->Получим имя временной таблицы с идентификаторами клиентов
				luQryParCltIDTableNM = oQryParMgr.ParamGet(tuParam2,[qpcCltIspIDTableNM])
				***
				IF !ISNULL(luQryParCltIDTableNM) AND TYPE([luQryParCltIDTableNM])==[C] AND FILE([tmp\]+luQryParCltIDTableNM+[.dbf])

					*10.04.2006 11:35 -> Сформируем фильтр
					lcFilterExpr = lcFilterExpr + ;
									[ AND Form.PointIspCltID IN (] + spGetTmpValueList(luQryParCltIDTableNM) + [)]
					*------------------------------------------------------------------------------

				ENDIF
				*------------------------------------------------------------------------------		
				
			ENDIF
			*------------------------------------------------------------------------------
			
			*27.05.2004 00:29 ->Формируем фильтр (Выбор клиента (EMI OR ISP))
			luQryParCltEnabled = oQryParMgr.ParamGet(tuParam2,[qplCltEnabled])
			***
			IF !ISNULL(luQryParCltEnabled) AND TYPE([luQryParCltEnabled])==[L] AND luQryParCltEnabled
				
				*27.05.2004 00:32 ->Получим имя временной таблицы с идентификаторами клиентов
				luQryParCltIDTableNM = oQryParMgr.ParamGet(tuParam2,[qpcCltIDTableNM])
				***
				IF !ISNULL(luQryParCltIDTableNM) AND TYPE([luQryParCltIDTableNM])==[C] AND FILE([tmp\]+luQryParCltIDTableNM+[.dbf])

					*10.04.2006 11:35 -> Сформируем фильтр
					lcValueList = spGetTmpValueList(luQryParCltIDTableNM)
					***
					lcFilterExpr = lcFilterExpr + ;
									[ AND (Form.PointEmiCltID IN (] + lcValueList + [)] + ;
									[ OR Form.PointIspCltID IN (] + lcValueList + [))]
					*------------------------------------------------------------------------------

				ENDIF
				*------------------------------------------------------------------------------		
				
			ENDIF
			*------------------------------------------------------------------------------

			*28.05.2004 03:01 ->Формируем фильтр (Выбор отдела (EMI))
			luQryParOUEnabled = oQryParMgr.ParamGet(tuParam2,[qplOUEmiEnabled])
			***
			IF !ISNULL(luQryParOUEnabled) AND TYPE([luQryParOUEnabled])==[L] AND luQryParOUEnabled

				*28.05.2004 00:37 ->Получим имя таблицы с идентификаторами подразделений
				luQryParOUIDTableNM = oQryParMgr.ParamGet(tuParam2,[qpcOUEmiIDTableNM])
				***
				IF !ISNULL(luQryParOUIDTableNM) AND TYPE([luQryParOUIDTableNM])==[C] AND FILE([tmp\]+luQryParOUIDTableNM+[.dbf])

					*10.04.2006 11:35 -> Сформируем фильтр
					lcFilterExpr = lcFilterExpr + ;
									[ AND Form.PointEmiOUID IN (] + spGetTmpValueList(luQryParOUIDTableNM) + [)]
					*------------------------------------------------------------------------------

				ENDIF
				*------------------------------------------------------------------------------
				
			ENDIF
			*------------------------------------------------------------------------------

			*28.05.2004 03:01 ->Формируем фильтр (Выбор отдела (ISP))
			luQryParOUEnabled = oQryParMgr.ParamGet(tuParam2,[qplOUIspEnabled])
			***
			IF !ISNULL(luQryParOUEnabled) AND TYPE([luQryParOUEnabled])==[L] AND luQryParOUEnabled

				*28.05.2004 00:37 ->Получим имя таблицы с идентификаторами подразделений
				luQryParOUIDTableNM = oQryParMgr.ParamGet(tuParam2,[qpcOUIspIDTableNM])
				***
				IF !ISNULL(luQryParOUIDTableNM) AND TYPE([luQryParOUIDTableNM])==[C] AND FILE([tmp\]+luQryParOUIDTableNM+[.dbf])

					*10.04.2006 11:35 -> Сформируем фильтр
					lcFilterExpr = lcFilterExpr + ;
									[ AND Form.PointIspOUID IN (] + spGetTmpValueList(luQryParOUIDTableNM) + [)]
					*------------------------------------------------------------------------------

				ENDIF
				*------------------------------------------------------------------------------
				
			ENDIF
			*------------------------------------------------------------------------------
			
			*28.05.2004 00:32 ->Формируем фильтр (Выбор отдела (EMI OR ISP))
			luQryParOUEnabled = oQryParMgr.ParamGet(tuParam2,[qplOUEnabled])
			***
			IF !ISNULL(luQryParOUEnabled) AND TYPE([luQryParOUEnabled])==[L] AND luQryParOUEnabled

				*28.05.2004 00:37 ->Получим имя таблицы с идентификаторами подразделений
				luQryParOUIDTableNM = oQryParMgr.ParamGet(tuParam2,[qpcOUIDTableNM])
				***
				IF !ISNULL(luQryParOUIDTableNM) AND TYPE([luQryParOUIDTableNM])==[C] AND FILE([tmp\]+luQryParOUIDTableNM+[.dbf])

					*10.04.2006 11:35 -> Сформируем фильтр
					lcValueList = spGetTmpValueList(luQryParOUIDTableNM)
					***
					lcFilterExpr = lcFilterExpr + ;
									[ AND (Form.PointEmiOUID IN (] + lcValueList + [)] + ;
									[ OR Form.PointIspOUID IN (] + lcValueList + [))]
					*------------------------------------------------------------------------------

				ENDIF
				*------------------------------------------------------------------------------
				
			ENDIF
			*------------------------------------------------------------------------------

			*19.01.2005 17:07 -> Формируем фильтр (Выбор типа документа)
			luQryParFrmTypeEnabled = oQryParMgr.ParamGet(tuParam2,[qplFrmTypeEnabled])
			***
			IF !ISNULL(luQryParFrmTypeEnabled) AND TYPE([luQryParFrmTypeEnabled])==[L] AND luQryParFrmTypeEnabled

				*19.01.2005 17:08 -> Получим имя таблицы с идентификаторами типов документов
				luQryParFrmTypeIDTableNM = oQryParMgr.ParamGet(tuParam2,[qpcFrmTypeIDTableNM])
				***
				IF !ISNULL(luQryParFrmTypeIDTableNM) AND TYPE([luQryParFrmTypeIDTableNM])==[C] AND FILE([tmp\]+luQryParFrmTypeIDTableNM+[.dbf])

					*10.04.2006 11:35 -> Сформируем фильтр
					lcFilterExpr = lcFilterExpr + ;
									[ AND Form.FrmTypeID IN (] + spGetTmpValueList(luQryParFrmTypeIDTableNM) + [)]
					*------------------------------------------------------------------------------

				ENDIF
				*------------------------------------------------------------------------------
				
			ENDIF
			*------------------------------------------------------------------------------
			
			*22.02.2006 16:55 -> Формируем фильтр (Выбор статуса документа)
			luQryParFrmStatEnabled = oQryParMgr.ParamGet(tuParam2,[qplFrmStatEnabled])
			***
			IF !ISNULL(luQryParFrmStatEnabled) AND TYPE([luQryParFrmStatEnabled])==[L] AND luQryParFrmStatEnabled

				*22.02.2006 16:55 -> Получим имя таблицы с идентификаторами статусов документов
				luQryParFrmStatIDTableNM = oQryParMgr.ParamGet(tuParam2,[qpcFrmStatIDTableNM])
				***
				IF !ISNULL(luQryParFrmStatIDTableNM) AND TYPE([luQryParFrmStatIDTableNM])==[C] AND FILE([tmp\]+luQryParFrmStatIDTableNM+[.dbf])

					*10.04.2006 11:35 -> Сформируем фильтр
					lcFilterExpr = lcFilterExpr + ;
									[ AND Form.FrmStatusID IN (] + spGetTmpValueList(luQryParFrmStatIDTableNM) + [)]
					*------------------------------------------------------------------------------

				ENDIF
				*------------------------------------------------------------------------------
				
			ENDIF
			*------------------------------------------------------------------------------

			*10.01.2006 17:07 -> Формируем фильтр (Выбор типа документа)
			luQryParFrmTypeEnabled = oQryParMgr.ParamGet(tuParam2,[qplQueue])
			***
			IF !ISNULL(luQryParFrmTypeEnabled) AND TYPE([luQryParFrmTypeEnabled])==[L] AND luQryParFrmTypeEnabled

					lcFilterExpr = lcFilterExpr + ;
									[ AND Form.FrmID IN (SELECT Frmpayqueue.frmid FROM frmpayqueue)]
				
			ENDIF
			*------------------------------------------------------------------------------

		ENDIF
		*------------------------------------------------------------------------------

ENDCASE
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
		[EXECUTE spPrimaryDocView ?lcFilterExpr],lcUniqueName)
ENDDO
***
IF lnSqlExeResult = -1

	*11.08.2006 14:53 ->Вызовем процедуру обработки ошибок
	spHandleODBCError()
	*------------------------------------------------------------------------------

	*11.08.2006 15:19 ->Создадим пустой курсор для возврата
	CREATE CURSOR (lcUniqueName) ( ;
		_mark L, FrmID I, FrmTypeID I, FrmDate T, FrmNum C(1), FrmNote C(1), StatusID I, ;
		FrmIsPayed L, FTShortNM C(1), PEmiNM C(1), PIspNM C(1), FrmSum I, FrmVatSum I, ;
		FrmSumSale I, FrmSumBuy I, FrmVatSale I, FrmVatBuy I, TvrNM C(1) ;
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

*21.04.2004 14:27 -> Вернем значение
RETURN lcUniqueName
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
