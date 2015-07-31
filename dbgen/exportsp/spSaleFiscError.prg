*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spSaleFiscError()
* Called by.......: <NA>
* Parameters......: <tnCheckID>
* Returns.........: <none>
* Notes...........: ������������ � ����, ��� ��� ������ �������� ������ ��
*------------------------------------------------------------------------------
PROCEDURE spSaleFiscError
LPARAMETERS tnCheckID

*31.05.2006 10:05 -> ���������� � ������������� ����������
LOCAL   lnConnectHandle, ;
		lnSqlExeResult, ;
		llResult
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> �������� ���
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[UPDATE CheckSale ] + ;
			[SET CheckAttributeID = CheckAttributeID | 2 ] + ;
		[WHERE CheckID = ?tnCheckID])
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
