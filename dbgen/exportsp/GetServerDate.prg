*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: GetServerDate()
* Called by.......: <>
* Parameters......: <none>
* Returns.........: <none>
* Notes...........: <��������� ���� � �������>
*------------------------------------------------------------------------------
PROCEDURE GetServerDate
*31.03.2006 16:50 ->���������� � ������������� ����������
LOCAL	lnConnectHandle, ;
		lnSqlExeResult, ;
		ltServerDate AS Datetime
*------------------------------------------------------------------------------

*28.03.2007 12:10 ->����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*28.03.2007 12:10 ->�������� ���� � �������
IF lnConnectHandle > 0
	lnSqlExeResult = 0
	DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
		lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
			[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
			[SELECT GETDATE() AS GetDate],[curGetDate])
	ENDDO
	***
	IF lnSqlExeResult = -1
		spHandleODBCError()
		SQLDISCONNECT(lnConnectHandle)
		RETURN CTOT([])
	ENDIF
	
	ltSErverDate = curGetDate.GetDate
	USE IN SELECT([curGetDate])
ENDIF
*------------------------------------------------------------------------------

*28.03.2007 12:13 ->������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

RETURN ltSErverDate

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
