*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spReqPriceBay()
* Called by.......: <NA>
* Parameters......: <tnFrmID>
* Returns.........: <none>
* Notes...........: �������������� ���� ����������� �� �������� � �� �����������
*------------------------------------------------------------------------------
PROCEDURE spReqPriceBay
LPARAMETERS tnFrmID, tlShowMessageBox

*09.06.2006 16:20 -> ���������� � ������������� ����������
LOCAL	lnConnectHandle, ;
		lnSqlExeResult
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ��������� ������
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

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*19.06.2006 10:10 -> ��������� ����� � ������������� �����
spGetAccNetto(tnFrmID)
*------------------------------------------------------------------------------

*19.06.2006 12:09 -> ����� ���������
IF TYPE([tlShowMessageBox]) = [L] AND tlShowMessageBox
	MESSAGEBOX([��������� ��������� ���������],64,[����������])
ENDIF
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
