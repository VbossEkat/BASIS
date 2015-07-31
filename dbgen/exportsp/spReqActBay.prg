*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spReqActBay()
* Called by.......: <NA>
* Parameters......: <tnFrmID>
* Returns.........: <none>
* Notes...........: �������������� ���� ����������� �� �������� � �� ������� �����
*------------------------------------------------------------------------------
PROCEDURE spReqActBay
LPARAMETERS tnFrmID, tlShowMessageBox

*09.06.2006 16:20 -> ���������� � ������������� ����������
LOCAL	lnConnectHandle, ;
		lnSqlExeResult
*------------------------------------------------------------------------------

*19.06.2006 15:32 -> �������� �� spReqPriceBay
spReqPriceBay(tnFrmID,.F.)
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

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
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
