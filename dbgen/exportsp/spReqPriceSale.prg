*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: spReqPriceSale()
* Called by.......: <NA>
* Parameters......: <tnFrmID>
* Returns.........: <none>
* Notes...........: �������������� ���� ������� �� �������� � �� �����������
*------------------------------------------------------------------------------
PROCEDURE spReqPriceSale
LPARAMETERS tnFrmID, tnPrcTypeID

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
			[TvrPrcSale = Price.Price ] + ;
		[FROM Price ] + ;
		[WHERE ] + ;
			[FrmPartTvr.FrmID = ?tnFrmID AND ] + ;
			[Price.TvrID = FrmPartTvr.TvrID AND ] + ;
			[Price.PrcTypeID = ?tnPrcTypeID])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN 0
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ��������� ������
lnSqlExeResult = 0
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[SELECT ] + ;
			[SUM(FrmPartTvr.TvrQnt*FrmPartTvr.TvrPrcSale) AS PrcSale ] + ;
		[FROM FrmPartTvr ] + ;
		[INNER JOIN Tovar ON Tovar.TvrID = FrmPartTvr.TvrID ] + ;
		[WHERE FrmPartTvr.FrmID = ?tnFrmID AND Tovar.TvrTypeID <> 6], ;
		[AccExit])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN 0
ENDIF
***
WAIT WINDOW AccExit.PrcSale
***
USE IN SELECT([AccExit])
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
