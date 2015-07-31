*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spResetAutoNum()
* Parameters......: tnFrmTypeID
* Returns.........: 
* Notes...........: ����� �������������� ��� �������� �����
*-------------------------------------------------------
PROCEDURE spResetAutoNum
LPARAMETERS tnFrmTypeID

*31.05.2006 10:05 -> ���������� � ������������� ����������
LOCAL   lnConnectHandle, ;
		lnSqlExeResult
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ���������� ��������
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[UPDATE FrmNumCounter ] + ;
			[SET FrmNumCntVal = 0 ] + ;
		[WHERE FrmTypeID = ?tnFrmTypeID])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
