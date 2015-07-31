*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spReqActBay()
* Called by.......: <NA>
* Parameters......: <tnFrmID>
* Returns.........: <none>
* Notes...........: Переопределяем цены поступления на продукты и на готовые блюда
*------------------------------------------------------------------------------
PROCEDURE spReqActBay
LPARAMETERS tnFrmID, tlShowMessageBox

*09.06.2006 16:20 -> Объявление и инициализация переменных
LOCAL	lnConnectHandle, ;
		lnSqlExeResult
*------------------------------------------------------------------------------

*19.06.2006 15:32 -> Выполним ХП spReqPriceBay
spReqPriceBay(tnFrmID,.F.)
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> Коннектимся к БД через существующее соединение
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> Выполняем запрос
lnSqlExeResult = 0
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[UPDATE FrmPartTvr SET ] + ;
			[TvrPrcBuy = ABS(MakeActProBay.TvrSumBuy/FrmPartTvr.TvrQnt) ] + ;
		[FROM ( ] + ;
			[SELECT ] + ;
				[FrmPartTvr.TvrIDCalc AS TvrID, ] + ;
				[SUM(FrmPartTvr.TvrQnt*FrmPartTvr.TvrPrcBuy) AS TvrSumBuy ] + ;
			[FROM FrmPartTvr ] + ;
			[WHERE FrmPartTvr.FrmID = ?tnFrmID AND NOT (FrmPartTvr.TvrIDCalc = 0 OR FrmPartTvr.TvrIDCalc IS NULL) ] + ;
			[GROUP BY FrmPartTvr.TvrIDCalc) AS MakeActProBay ] + ;
		[WHERE FrmPartTvr.FrmID = ?tnFrmID AND FrmPartTvr.TvrID = MakeActProBay.TvrID])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN 0
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> Делаем дисконнект: освобождаем соединение
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*19.06.2006 12:09 -> Вывод сообщения
IF TYPE([tlShowMessageBox]) = [L] AND tlShowMessageBox
	MESSAGEBOX([Обработка документа завершена],64,[Информация])
ENDIF
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
