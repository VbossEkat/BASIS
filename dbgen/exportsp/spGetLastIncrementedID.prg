*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spGetLastIncrementedID()
* Called by.......: <After Adding Record With Increment Key>
* Parameters......: <lcEditDBObjName>
* Returns.........: <lnLastIncrementedID>
* Notes...........: Возвращает последний идентификатор записи для LV/RV/Table
*					сгенерированный SPINCREMENTID()
*-------------------------------------------------------
PROCEDURE spGetLastIncrementedID
LPARAMETERS lcEditDBObjName

*01.04.2004 13:51 ->Объявление и инициализация переменных
LOCAL	lcOldAlias, ;
		lnEditDBObjectType, ;
		lcSourceTable, ;
		lnSqlExeResult, ;
		lnLastIncrementedID
***
lcOldAlias = ALIAS()
*------------------------------------------------------------------------------

*01.04.2004 13:53 ->Узнаем тип объекта использованного для добавления
lnEditDBObjectType = CURSORGETPROP([SourceType],lcEditDBObjName)
*------------------------------------------------------------------------------

*01.04.2004 13:56 ->Определим последний сгенерированный идентификатор
DO CASE
	CASE lnEditDBObjectType	= 1	&& Local SQL View
		lcSourceTable = CURSORGETPROP([Tables],lcEditDBObjName)
		IF ([,]$lcSourceTable)
			lcSourceTable = LEFT(lcSourceTable,AT([,],lcSourceTable)-1)
		ENDIF
		IF ([!]$lcSourceTable)
			lcSourceTable = SUBSTR(lcSourceTable,AT([!],lcSourceTable)+1)
		ENDIF
		***
		IF !USED([LastIncrID])	
			IF FILE([LastIncrID.dbf])
				USE LastIncrID IN 0
			ELSE
				RETURN 0
			ENDIF	
		ENDIF
		***
		SELECT LastIncrID
		LOCATE ALL FOR UPPER(ALLTRIM(LastIncrID.TableNM))==UPPER(ALLTRIM(lcSourceTable))
		***
		IF FOUND()
			lnLastIncrementedID = LastIncrID.LastId
		ELSE
			lnLastIncrementedID = 0
		ENDIF
		***
		USE IN LastIncrID
	*------------------------------------------------------------------------------	
			
	CASE lnEditDBObjectType = 2 && Remote SQL View
		lcSourceTable = CURSORGETPROP([Tables],lcEditDBObjName)
		IF ([,]$lcSourceTable)
			lcSourceTable = LEFT(lcSourceTable,AT([,],lcSourceTable)-1)
		ENDIF
		IF ([!]$lcSourceTable)
			lcSourceTable = SUBSTR(lcSourceTable,AT([!],lcSourceTable)+1)
		ENDIF
		***
		lnConnHandler = CURSORGETPROP([ConnectHandle],lcEditDBObjName)
		lnSqlExeResult = 0
		DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
			lnSqlExeResult = SQLEXEC(lnConnHandler, ;
				[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
				[EXECUTE spGetLastIncrementedID ?lcSourceTable],[tmp])
		ENDDO
		***
		IF lnSqlExeResult = -1
			spHandleODBCError()
			RETURN 0
		ENDIF
		lnLastIncrementedID = tmp.LastId
		USE IN tmp
	*------------------------------------------------------------------------------
	
	CASE lnEditDBObjectType	= 3	&& Table
		lcSourceTable = lcEditDBObjName
		IF ([!]$lcSourceTable)
			lcSourceTable = SUBSTR(lcSourceTable,AT([!],lcSourceTable)+1)
		ENDIF
		***
		IF !USED([LastIncrID])	
			IF FILE([LastIncrID.dbf])
				USE LastIncrID IN 0
			ELSE
				RETURN 0
			ENDIF	
		ENDIF
		***
		SELECT LastIncrID
		LOCATE ALL FOR UPPER(ALLTRIM(LastIncrID.TableNM))==UPPER(ALLTRIM(lcSourceTable))
		***
		IF FOUND()
			lnLastIncrementedID = LastIncrID.LastId
		ELSE
			lnLastIncrementedID = 0
		ENDIF
		***
		USE IN LastIncrID
	*------------------------------------------------------------------------------	

ENDCASE

*01.04.2004 14:37 ->Восстановим текущий Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*01.04.2004 14:37 ->Вернем значение
RETURN lnLastIncrementedID
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
