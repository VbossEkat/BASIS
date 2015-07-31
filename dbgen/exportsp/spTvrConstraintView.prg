*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: spTvrConstraintView()
* Called by.......: <NA>
* Parameters......: <tcQryParSID>
* Returns.........: <lcUniqueName>
* Notes...........: Просмотр ограничений товарного ассортимента
*------------------------------------------------------------------------------
PROCEDURE spTvrConstraintView
LPARAMETERS tcQryParSID

*27.09.2005 09:28 ->Объявление и инициализация переменных
LOCAL	lcOldAlias, ;
		lcFilterExpr, ;
		lcUniqueName, ;
		lcUniqueFilePath, ;
		luTvrID, ;
		luQryParTvrEnabled, ;
		luQryParTvrIDTableNM, ;
		luQryParOUEnabled, ;
		luQryParOUIDTableNM
***
lcOldAlias = ALIAS()
lcFilterExpr = [WHERE 0<>1]
lcUniqueName = [_d] + SYS(2015)
lcUniqueFilePath = [tmp\] + lcUniqueName + [.DBF]
*------------------------------------------------------------------------------

*25.05.2005 16:46 ->Читаем идентификатор экранной формы
luTvrID = oQryParMgr.ParamGet(tcQryParSID,[TvrID])
***
IF TYPE([luTvrID]) == [N] AND !EMPTY(luTvrID) AND !ISNULL(luTvrID)
	lcFilterExpr = [WHERE TvrConstraint.TvrID = ] + ALLTRIM(STR(luTvrID))
ENDIF
*------------------------------------------------------------------------------

*19.09.2005 15:33 -> Возможно, необходимо создать таблицу без данных
DO CASE
	CASE TYPE([tcQryParSID])==[C] AND tcQryParSID==[NODATA]
		lcFilterExpr = [WHERE 0=1]

	CASE TYPE([tcQryParSID])==[C]

		*19.01.2005 17:07 -> Формируем фильтр (Выбор товаров)
		luQryParTvrEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplTvrEnabled])
		***
		IF !ISNULL(luQryParTvrEnabled) AND TYPE([luQryParTvrEnabled])==[L] AND luQryParTvrEnabled

			*19.01.2005 17:08 -> Получим имя таблицы с идентификаторами типов документов
			luQryParTvrIDTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcTvrIDTableNM])
			***
			IF !ISNULL(luQryParTvrIDTableNM) AND TYPE([luQryParTvrIDTableNM])==[C] AND FILE([tmp\]+luQryParTvrIDTableNM+[.dbf])

				*10.04.2006 11:35 -> Сформируем фильтр
				lcFilterExpr = [WHERE TvrConstraint.TvrID IN (] + spGetTmpValueList(luQryParTvrIDTableNM) + [)]
				*------------------------------------------------------------------------------

			ENDIF
			*------------------------------------------------------------------------------
			
		ENDIF
		*------------------------------------------------------------------------------

	CASE TYPE([tcQryParSID])==[N]
		lcFilterExpr = [WHERE TvrConstraint.TvrCID = ] + ALLTRIM(STR(tcQryParSID))
ENDCASE
*------------------------------------------------------------------------------

*19.06.2006 11:26 ->Формируем фильтр по подразделению
luQryParOUEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplOUEnabled])
***
IF !ISNULL(luQryParOUEnabled) AND TYPE([luQryParOUEnabled])==[L] AND luQryParOUEnabled

	*19.06.2006 11:26 ->Получим имя таблицы с идентификаторами подразделений
	luQryParOUIDTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcOUIDTableNM])
	***
	IF !ISNULL(luQryParOUIDTableNM) AND TYPE([luQryParOUIDTableNM])==[C] AND FILE([tmp\]+luQryParOUIDTableNM+[.dbf])

		*10.04.2006 11:35 -> Сформируем фильтр
		lcFilterExpr = lcFilterExpr + ;
						[ AND TvrConstraint.OUID IN (] + spGetTmpValueList(luQryParOUIDTableNM) + [)]
		*------------------------------------------------------------------------------

	ENDIF
	*------------------------------------------------------------------------------

ENDIF
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
		[EXECUTE spTvrConstraintView ?lcFilterExpr],lcUniqueName)
ENDDO
***
IF lnSqlExeResult = -1

	*11.08.2006 16:19 ->Вызовем обработчик ошибок
	spHandleODBCError()
	*------------------------------------------------------------------------------

	*11.08.2006 16:19 ->Создадим пустой курсор
	CREATE CURSOR (lcUniqueName) ( ;
		TvrCID I, TvrID I, TvrNM C(1), OUNM C(1), MsuNM C(1), TvrMinQnt I, TvrMaxQnt I, TvrCurQnt I ;
	)
	*------------------------------------------------------------------------------
	
ENDIF
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> Сохраним курсор в файл и закроем
SELECT (lcUniqueName)
***
COPY TO (lcUniqueFilePath)
***
USE IN (lcUniqueName)
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> Делаем дисконнект: освобождаем соединение
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*27.07.2005 11:56 -> Восстановим текущий Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*21.04.2004 14:27 -> Вернем значение
RETURN lcUniqueName
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
