*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: spSetTvrDisc()
* Called by.......: <NA>
* Parameters......: <tnTovarID,tnDiscID>
* Returns.........: <none>
* Notes...........: ��������� ������ �� �����/������ �������
*-------------------------------------------------------
PROCEDURE spSetTvrDisc
LPARAMETERS tnTovarID,tnDiscID

*24.08.2005 14:15 -> ���������� � ������������� ����������
LOCAL	lnSqlExeResult, ;
		llResult
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ��������� ������ �� �����/������ �������
lnSqlExeResult = 0
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE spSetTvrDisc ?tnTovarID, ?tnDiscID])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN 0
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
