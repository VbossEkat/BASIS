*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spReqPriceBay()
* Called by.......: <NA>
* Parameters......: <tnFrmID>
* Returns.........: <none>
* Notes...........: Переопределяем цены поступления на продукты и на калькуляцию
*------------------------------------------------------------------------------
PROCEDURE spReqPriceBay
LPARAMETERS tnFrmID, tlShowMessageBox

*09.06.2006 16:20 -> Объявление и инициализация переменных
LOCAL	lnConnectHandle, ;
		lnSqlExeResult
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
			[TvrPrcBuy = TvrMidlBuy.TvrPrcBuy ] + ;
		[FROM ( ] + ;
			[SELECT ] + ;
				[FrmPartTvr.TvrID, ] + ;
				[TvrPrcBuy = CASE ] + ;
					[WHEN ISNULL(SUM(Stock.StockTvrQnt),0) = 0 THEN 0 ELSE ] + ;
					[ISNULL(SUM(Stock.StockTvrQnt*Stock.StockTvrPrcBuy),0)/ISNULL(SUM(Stock.StockTvrQnt),0) END ] + ;
			[FROM FrmPartTvr ] + ;
			[LEFT JOIN Stock ON Stock.StockTvrID = FrmPartTvr.TvrID ] + ;
			[WHERE FrmPartTvr.FrmID = ?tnFrmID ] + ;
			[GROUP BY FrmPartTvr.TvrID) AS TvrMidlBuy ] + ;
		[WHERE FrmPartTvr.FrmID = ?tnFrmID AND FrmPartTvr.TvrID = TvrMidlBuy.TvrID])
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

*19.06.2006 10:10 -> Определим нетто и себестоимость блюда
spGetAccNetto(tnFrmID)
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
