*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spCheckSaleSucces()
* Called by.......: <NA>
* Parameters......: <tnCheckID>
* Returns.........: <none>
* Notes...........: ������������ ����������� ���������� ����
*------------------------------------------------------------------------------
PROCEDURE spCheckSaleSucces
LPARAMETERS tnCheckID

*10.10.2006 16:26 ->���������� � ������������� ����������
LOCAL   lnConnectHandle, ;
		lnSqlExeResult, ;
		llResult
*------------------------------------------------------------------------------

*10.10.2006 16:26 ->����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*10.10.2006 16:26 ->�������� ���
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[UPDATE CheckSale ] + ;
			[SET CheckAttributeID = CheckAttributeID & (~4) ] + ;
		[WHERE CheckID = ?tnCheckID])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*10.10.2006 16:26 ->������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
