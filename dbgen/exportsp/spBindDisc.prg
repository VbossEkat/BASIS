*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spBindDisc()
* Called by.......: <NA>
* Parameters......: <tnCheckID,tnDiscCardID>
* Returns.........: <none>
* Notes...........:	�������� ���������� ����� � ����
*------------------------------------------------------------------------------
PROCEDURE spBindDisc
LPARAMETERS tnCheckID,tnDiscCardID

*31.05.2006 10:05 -> ���������� � ������������� ����������
LOCAL   lnConnectHandle, ;
		lnSqlExeResult
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> �����������
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[UPDATE CheckSale ] + ;
			[SET DiscCardID = ?tnDiscCardID ] + ;
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
