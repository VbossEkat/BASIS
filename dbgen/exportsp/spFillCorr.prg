*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spFillCorr()
* Called by.......: <Form Data Request>
* Parameters......: <tnFrmID>
* Returns.........: <none>
* Notes...........: ���������� ��������������� ���������
*-------------------------------------------------------
PROCEDURE spFillCorr
LPARAMETERS tnFrmID

*08.09.2006 11:25 ->���������� � ������������� ����������
LOCAL	lnConnectHandle, ;
		lnSqlExeResult, ;
		llResult
*------------------------------------------------------------------------------

*08.09.2006 11:25 ->����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*08.09.2006 11:25 ->����������� �������������� ���������
lnSqlExeResult = 0
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE spFillCorr ?tnFrmID])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN 0
ENDIF
*------------------------------------------------------------------------------

*08.09.2006 11:26 ->������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
