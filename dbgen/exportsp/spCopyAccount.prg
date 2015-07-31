*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spCopyAccount()
* Called by.......: <NA>
* Parameters......: <tnSrcFrmID,tnTargetFrmTypeID,tcOperation>
* Returns.........: <lnLastFrmID>
* Notes...........: ����������� ��������������� �����
*------------------------------------------------------------------------------
PROCEDURE spCopyAccount
LPARAMETERS tnSrcFrmID,tnTargetFrmTypeID,tcOperation

*15.12.2004 16:49 ->���������� � ������������� ����������
LOCAL	lcOldAlias, ;
		lnLastFrmID, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcOldAlias = ALIAS()
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ������ ��� ���������
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE spCopyAccount ?tnSrcFrmID, ?tnTargetFrmTypeID, ?tcOperation], ;
		[curLastFrmID])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN 0
ENDIF
***
lnLastFrmID = curLastFrmID.FrmID
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*15.12.2004 16:50 ->����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*16.12.2004 17:58 ->������ ������������� ����� ������������ ��������
RETURN lnLastFrmID
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
