*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spSaleDelete()
* Called by.......: <NA>
* Parameters......: <none>
* Returns.........: <tnSalesLogID>
* Notes...........: �������� ������ �� ID
*------------------------------------------------------------------------------
PROCEDURE spSaleDelete
LPARAMETERS tnSalesLogID

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ��������� ������ (������� �������)
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[DELETE ] + ;
		[FROM SalesLog ] + ;
		[WHERE SalesLog.SalesLogID = ?tnSalesLogID])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
