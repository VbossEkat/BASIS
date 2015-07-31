*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: spClientView()
* Called by.......: <NA>
* Parameters......: <tcQryParSID>
* Returns.........: <lcUniqueFileName>
* Notes...........: Просмотр клиентов
*------------------------------------------------------------------------------
PROCEDURE spClientView
LPARAMETERS tcQryParSID

*10.08.2005 14:58 -> Объявление и инициализация переменных
LOCAL	lcOldAlias, ;
		lcUniqueName, ;
		lcUniqueFilePath, ;
		lcCltJuridicalExpr, ;
		lcCltPhysicalExpr, ;
		lcClientExpr, ;
		luQryParCltNMEnabled, ;
		luQryParCltNM, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcOldAlias = ALIAS()
lcUniqueName = [_c] + SYS(2015)
lcUniqueFilePath = [tmp\] + lcUniqueName + [.DBF]
lcCltJuridicalExpr = [WHERE 0=1]
lcCltPhysicalExpr = [WHERE 0=1]
lcClientExpr = [WHERE 0=1]
*------------------------------------------------------------------------------

*10.08.2005 16:48 -> Читаем параметры
IF PCOUNT()=1 AND TYPE([oQryParMgr])==[O] AND !ISNULL(oQryParMgr)

	*10.08.2005 17:06 -> Инициализируем фильтр
	lcClientExpr = [WHERE 0<>1]
	*------------------------------------------------------------------------------

	*10.08.2005 16:48 -> Формируем фильтр по наименованию клиента
	luQryParCltNMEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplCltNMEnabled])
	***
	IF !ISNULL(luQryParCltNMEnabled) AND TYPE([luQryParCltNMEnabled])==[L] AND luQryParCltNMEnabled

		*10.08.2005 16:49 -> Получим наименование клиента
		luQryParCltNM = oQryParMgr.ParamGet(tcQryParSID,[qpcCltNM])
		***
		IF !ISNULL(luQryParCltNM) AND TYPE([luQryParCltNM])==[C]

			*10.08.2005 16:49 -> Формируем фильтры
			lcCltJuridicalExpr	= [WHERE UPPER(CltJuridical.CltJrdNM) LIKE '%] + UPPER(ALLTRIM(luQryParCltNM)) + [%']
			lcCltPhysicalExpr	= [WHERE UPPER(LTRIM(CASE WHEN NOT CltPhysical.CltPhysFNM IS NULL AND CltPhysical.CltPhysFNM <> '' THEN ' ' + CltPhysical.CltPhysFNM ELSE '' END + ] + ;
										[CASE WHEN NOT CltPhysical.CltPhysINM IS NULL AND CltPhysical.CltPhysINM <> '' THEN ' ' + CltPhysical.CltPhysINM ELSE '' END + ] + ;
										[CASE WHEN NOT CltPhysical.CltPhysONM IS NULL AND CltPhysical.CltPhysONM <> '' THEN ' ' + CltPhysical.CltPhysONM ELSE '' END)) ] + ;
										[LIKE '%] + UPPER(ALLTRIM(luQryParCltNM)) + [%']
			lcClientExpr		= [WHERE UPPER(Client.CltNM) LIKE '%] + UPPER(ALLTRIM(luQryParCltNM)) + [%']
			*------------------------------------------------------------------------------

		ENDIF
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
		[EXECUTE spClientView ?lcClientExpr, ?lcCltJuridicalExpr, ?lcCltPhysicalExpr],lcUniqueName)
ENDDO
***
IF lnSqlExeResult = -1

	*11.08.2006 16:04 ->Вызовем обработчик ошибок
	spHandleODBCError()
	*------------------------------------------------------------------------------

	*11.08.2006 16:04 ->Создадим пустой курсор
	CREATE CURSOR (lcUniqueName) ( ;
		CltID I, CltNM C(1), CltFullNM C(1), CltINN C(1) ;
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

*10.08.2005 16:55 -> Закроем файл
USE IN IIF(USED(lcUniqueName),lcUniqueName,0)
*------------------------------------------------------------------------------

*10.08.2005 14:58 -> Восстановим текущий Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*10.08.2005 14:58 -> Вернем значение
RETURN lcUniqueName
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
