*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures For Basis
* Module/Procedure: spFrmAutoNum()
* Called by.......: <NA>
* Parameters......: <tnFrmTypeID,tnPointEmiOUID,tnPointIspOUID,tdDate>
* Returns.........: <lcFrmNum>
* Notes...........: Автонумератор
*------------------------------------------------------------------------------
PROCEDURE spFrmAutoNum
LPARAMETERS tnFrmTypeID,tdDate,tnPointEmiOUID,tnPointIspOUID

*21.12.2004 18:09 ->Объявление и инициализация переменных
LOCAL	lcOldAlias, ;
		lnConnectHandle, ;
		lnSqlExeResult, ;
		lnOUID, ;
		lnOwnCltID, ;
		lcMask, ;
		lcFrmNum, ;
		lnStartPos, ;
		lnEndPos, ;
		lcSerialSection, ;
		lcSerialSectionValue, ;
		lnCounter
***
lcOldAlias = ALIAS()
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> Коннектимся к БД через существующее соединение
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> Узнаем тип документа
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[SELECT ] + ;
			[FrmType.FrmTypeDirection ] + ;
		[FROM FrmType ] + ;
		[WHERE FrmType.FrmTypeID = ?tnFrmTypeID], ;
		[curFrmType])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN
ENDIF
*------------------------------------------------------------------------------

*21.12.2004 18:08 ->Вычисляем код подразделения
lnOUID = IIF(curFrmType.FrmTypeDirection=2,tnPointIspOUID,tnPointEmiOUID)
***
IF lnOUID = 0
	RETURN []
ENDIF
*------------------------------------------------------------------------------

*22.12.2004 10:06 -> Закрываем курсор curFrmType
USE IN SELECT([curFrmType])
*------------------------------------------------------------------------------

*21.12.2004 18:18 ->Вычисляем идентификатор родителя подразделения
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[SELECT ] + ;
			[OrgUnit.CltID ] + ;
		[FROM OrgUnit ] + ;
		[WHERE OrgUnit.OUID = ?lnOUID], ;
		[curOrgUnit])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN
ENDIF
***
lnOwnCltID = curOrgUnit.CltID
***
IF EMPTY(lnOwnCltID)
	ASSERT .F. MESSAGE [STORED PROCEDURES FOR BASIS: невозможно сгенерировать номер по подразделению, не имеющему родителя-клиента]
	RETURN [ERROR]
ENDIF
*------------------------------------------------------------------------------

*22.12.2004 10:06 -> Закрываем курсор curOrgUnit
USE IN SELECT([curOrgUnit])
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> Получим параметры автонумерации
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE spFrmAutoNum ?tnFrmTypeID, ?lnOUID], ;
		[curFrmTypeAutoNum])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN
ENDIF
***
IF RECCOUNT([curFrmTypeAutoNum])#1
	ASSERT .F. MESSAGE [STORED PROCEDURES FOR BASIS: не найден параметр автонумератора для данного типа документа]
	RETURN [ERROR]
ENDIF
*------------------------------------------------------------------------------

*21.12.2004 18:23 ->Генерируем счётчик
lcFrmNum = []
***
IF !EMPTY(curFrmTypeAutoNum.AutoNumMask) AND curFrmTypeAutoNum.AutoNumIsEnabled
	lcFrmNum = ALLTRIM(curFrmTypeAutoNum.AutoNumMask)
	DO WHILE [{]$lcFrmNum AND [}]$lcFrmNum
		lnStartPos = AT([{],lcFrmNum)
		lnEndPos = AT([}],lcFrmNum)
		***
		IF lnStartPos > lnEndPos
			ASSERT .F. MESSAGE [STORED PROCEDURES FOR BASIS: некорректная маска автонумератора]
			RETURN [ERROR]
		ENDIF
		***
		lcSerialSection = SUBSTR(lcFrmNum,lnStartPos+1,lnEndPos-lnStartPos-1)
		***
		DO CASE
			CASE UPPER(lcSerialSection)==[YYYY]
				lcSerialSectionValue = ALLTRIM(STR(YEAR(tdDate)))
			CASE UPPER(lcSerialSection)==[YY]
				lcSerialSectionValue = RIGHT(ALLTRIM(STR(YEAR(tdDate))),2)
			CASE UPPER(lcSerialSection)==[MM]
				lcSerialSectionValue = ALLTRIM(STR(MONTH(tdDate)))
			CASE UPPER(lcSerialSection)==[DD]
				lcSerialSectionValue = ALLTRIM(STR(DAY(tdDate)))
			CASE [n]$lcSerialSection OR [N]$lcSerialSection
				lnCounter = spFrmAutoNumGetCounter(IIF(curFrmTypeAutoNum.FrmTypeIDIsConst,curFrmTypeAutoNum.FrmTypeIDConst,tnFrmTypeID), ;
												   IIF(curFrmTypeAutoNum.OwnCltIDIsConst,curFrmTypeAutoNum.OwnCltIDConst,lnOwnCltID), ;
												   IIF(curFrmTypeAutoNum.OUIDIsConst,curFrmTypeAutoNum.OUIDConst,lnOUID))
				***
				IF [N]$lcSerialSection
					lcSerialSectionValue = PADL(ALLTRIM(STR(lnCounter)),lnEndPos-lnStartPos-1,[0])
				ELSE
					lcSerialSectionValue = ALLTRIM(STR(lnCounter))
				ENDIF				
			OTHERWISE
				lcSerialSectionValue = []
		ENDCASE
		***
		lcFrmNum = STUFF(lcFrmNum,lnStartPos,lnEndPos-lnStartPos+1,lcSerialSectionValue)
	ENDDO
ENDIF
*------------------------------------------------------------------------------

*22.12.2004 10:07 -> Закрываем таблицы
USE IN IIF(USED([curFrmTypeAutoNum]),[curFrmTypeAutoNum],0)
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> Делаем дисконнект: освобождаем соединение
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*23.12.2004 12:06 ->Восстановим текущий Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*21.12.2004 19:01 ->Вернём сгенерированный номер
RETURN lcFrmNum
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
