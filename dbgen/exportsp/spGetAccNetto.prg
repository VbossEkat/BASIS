*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: spGetAccNetto()
* Called by.......: <NA>
* Parameters......: <tnFrmID>
* Returns.........: <none>
* Notes...........: ���������� ����� � ������������� ��� ����� �����
*------------------------------------------------------------------------------
PROCEDURE spGetAccNetto
LPARAMETERS tnFrmID

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
		[UPDATE Accounting SET ] + ;
			[AccPrice = AccExit.Price, ] + ;
			[AccNetto = AccExit.Netto ] + ;
		[FROM ( ] + ;
			[SELECT ] + ;
				[SUM(FrmPartTvr.TvrQnt*FrmPartTvr.TvrPrcBuy) AS Price, ] + ;
				[SUM(FrmPartTvr.TvrQntNetto) AS Netto ] + ;
			[FROM FrmPartTvr ] + ;
			[INNER JOIN Tovar ON Tovar.TvrID = FrmPartTvr.TvrID ] + ;
			[WHERE FrmPartTvr.FrmID = ?tnFrmID AND Tovar.TvrTypeID <> 6) AS AccExit ] + ;
		[WHERE Accounting.AccFrmID = ?tnFrmID])
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

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
