*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spSaleCloseDay()
* Called by.......: <NA>
* Parameters......: <tnSLID,tnCashID>
* Returns.........: <none>
* Notes...........: �������� ���������� ���
*------------------------------------------------------------------------------
PROCEDURE spSaleCloseDay
PARAMETERS tnSLID,tnCashID

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ��������� ��������� ����
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[UPDATE ] + ;
			[POSActivity ] + ;
		[SET POSActCloseStamp = GETDATE() ] + ;
		[WHERE POSActSLID = ?tnSLID AND POSActCID = ?tnCashID])
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
