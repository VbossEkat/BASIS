*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spFormCopyActRule()
* Called by.......: <NA>
* Parameters......: <tnSrcFrmID,tnTargetFrmTypeID,tcOperation>
* Returns.........: <none>
* Notes...........: Копирование расходной накладной в акт производства
*------------------------------------------------------------------------------
PROCEDURE spFormCopyActRule
LPARAMETERS tnSrcFrmID,tnTargetFrmTypeID,tcOperation

*15.12.2004 16:49 -> Объявление и инициализация переменных
LOCAL	lcOldAlias, ;
		lnLastFrmID, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcOldAlias = ALIAS()
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
		[EXECUTE spFormCopyActRule ?tnSrcFrmID, ?tnTargetFrmTypeID, ?tcOperation], ;
		[curLastFrmID])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN 0
ENDIF
***
lnLastFrmID = curLastFrmID.FrmID
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> Делаем дисконнект: освобождаем соединение
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*15.12.2004 16:50 -> Восстановим текущий Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*16.12.2004 17:58 -> Вернем идентификатор вновь добавленного докумета
RETURN lnLastFrmID
*------------------------------------------------------------------------------

************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spFormCopyBludo()
* Called by.......: <NA>
* Parameters......: <tnSrcFrmID,tnTargetFrmTypeID,tcOperation>
* Returns.........: <none>
* Notes...........: Формирует документ с включением в него из источника ;
                  * только блюд и модификаторов 
                  * должно быть настроено копирование форм
*------------------------------------------------------------------------------
PROCEDURE spFormCopyBludo
LPARAMETERS tnSrcFrmID,tnTargetFrmTypeID,tcOperation,tlIsOnlyBludo

*15.12.2004 16:49 -> Объявление и инициализация переменных
LOCAL	lcOldAlias, ;
		lnLastFrmID, ;
		llIsOnlyBludo, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcOldAlias = ALIAS()
IF PCOUNT() = 3
	llIsOnlyBludo = (MESSAGEBOX([Выбирать только полуфабрикаты (без блюд)?],4+32+256, [Вопрос])= 7)
ELSE
	llIsOnlyBludo = tlIsOnlyBludo
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
		[EXECUTE spFormCopyBludo ?tnSrcFrmID, ?tnTargetFrmTypeID, ?tcOperation, ?llIsOnlyBludo], ;
		[curLastFrmID])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN 0
ENDIF
***
lnLastFrmID = curLastFrmID.FrmID
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> Делаем дисконнект: освобождаем соединение
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*15.12.2004 16:50 -> Восстановим текущий Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*16.12.2004 17:58 -> Вернем идентификатор вновь добавленного докумета
RETURN lnLastFrmID
*------------------------------------------------------------------------------

************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spFormCopyAuto()
* Called by.......: <NA>
* Parameters......: <tnSrcFrmID,tnTargetFrmTypeID,tcOperation>
* Returns.........: <none>
* Notes...........: Формирует документ с включением в него из источника ;
                  * только блюд и модификаторов c последующей обработкой
                  * должно быть настроено копирование форм
*------------------------------------------------------------------------------
PROCEDURE spFormCopyAuto
LPARAMETERS tnSrcFrmID,tnTargetFrmTypeID,tcOperation

*15.12.2004 16:49 -> Объявление и инициализация переменных
LOCAL	lcOldAlias, ;
		llIsOnlyBludo, ;
		lnSrcFrmID, ;
		lnLastFrmID, ;
		lnHalfReady, ;
		lnCounter, ;
		lnCirc, ;
		laCirc(1)
***
llIsOnlyBludo = .T.
lnSrcFrmID = tnSrcFrmID
***
lcOldAlias = ALIAS()
*------------------------------------------------------------------------------

*19.06.2006 11:20 -> Создаем акт производства с блюдами из текущего документа
DO WHILE .T.

	*19.06.2006 11:58 -> Выполняем копирование документа
	lnLastFrmID = spFormCopyBludo(lnSrcFrmID,tnTargetFrmTypeID,tcOperation,llIsOnlyBludo)
	llIsOnlyBludo = .F.
	lnCirc = ALEN(laCirc)
	laCirc[lnCirc] = lnLastFrmID
	DIMENSION laCirc(lnCirc+1)
	lnSrcFrmID = lnLastFrmID
	*------------------------------------------------------------------------------

	*19.06.2006 11:58 -> Создаем акт производства
	lnHalfReady = spMakeActPro(lnLastFrmID)
	*------------------------------------------------------------------------------

	*19.06.2006 11:25 -> Проверяем на наличие полуфабрикатов, если их нет - выходим
	IF lnHalfReady = 0
		EXIT
	ENDIF
	*------------------------------------------------------------------------------

ENDDO
*------------------------------------------------------------------------------

*19.06.2006 12:06 -> Переопределяем цены поступления на продукты и на калькуляцию
FOR lnCounter = ALEN(laCirc) TO 1 STEP -1
	lnLastFrmID = laCirc[lnCirc]
	spReqActBay(lnLastFrmID,.F.)
ENDFOR
*------------------------------------------------------------------------------

*15.12.2004 16:50 ->Восстановим текущий Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*19.06.2006 12:12 -> Вывод сообщения
MESSAGEBOX([Обработка документов завершена],64,[Информация])
*------------------------------------------------------------------------------

*16.12.2004 17:58 -> Вернем идентификатор вновь добавленного докумета
RETURN lnLastFrmID
*------------------------------------------------------------------------------

************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spCopyAccount()
* Called by.......: <NA>
* Parameters......: <tnSrcFrmID,tnTargetFrmTypeID,tcOperation>
* Returns.........: <lnLastFrmID>
* Notes...........: Копирование калькуляционной карты
*------------------------------------------------------------------------------
PROCEDURE spCopyAccount
LPARAMETERS tnSrcFrmID,tnTargetFrmTypeID,tcOperation

*15.12.2004 16:49 ->Объявление и инициализация переменных
LOCAL	lcOldAlias, ;
		lnLastFrmID, ;
		lnConnectHandle, ;
		lnSqlExeResult
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
		[EXECUTE spCopyAccount ?tnSrcFrmID, ?tnTargetFrmTypeID, ?tcOperation], ;
		[curLastFrmID])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN 0
ENDIF
***
lnLastFrmID = curLastFrmID.FrmID
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> Делаем дисконнект: освобождаем соединение
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*15.12.2004 16:50 ->Восстановим текущий Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*16.12.2004 17:58 ->Вернем идентификатор вновь добавленного докумета
RETURN lnLastFrmID
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
