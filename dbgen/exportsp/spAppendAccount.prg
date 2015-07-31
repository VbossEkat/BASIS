*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spAppendAccount()
* Parameters......: <tnTvrId, tnTvrTypeID>
* Returns.........: <NA>
* Notes...........: ��������� ����������� � ���� ������
*------------------------------------------------------------------------------
PROCEDURE spAppendAccount
LPARAMETERS tnTvrId, tnTvrTypeID

*01.06.2006 16:44 -> VG
IF tnTvrTypeID = 5 OR tnTvrTypeID = 6

	*31.05.2006 10:05 -> ���������� � ������������� ����������
	LOCAL   lnConnectHandle, ;
			lnSqlExeResult
	*------------------------------------------------------------------------------

	*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
	lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
	*------------------------------------------------------------------------------

	*07.04.2006 16:45 -> ��������� ������
	lnSqlExeResult = 0
	***
	DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
		lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
			[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
			[EXECUTE spAppendAccount ?tnTvrId])
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

ENDIF 
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
