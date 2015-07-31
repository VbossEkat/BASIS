*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: spFormCopyInventory()
* Called by.......: <NA>
* Parameters......: <tnSrcFrmID,tnTargetFrmTypeID,tcOperation>
* Returns.........: <.T./.F.>
* Notes...........: �������� ������������ ��������� �� ������ ������������������
*------------------------------------------------------------------------------
PROCEDURE spFormCopyInventory
LPARAMETERS tnSrcFrmID,tnTargetFrmTypeID,tcOperation

*11.05.2006 17:13 -> ���������� � ������������� ����������
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
		[EXECUTE spFormCopyInventory ?tnSrcFrmID, ?tnTargetFrmTypeID, ?tcOperation], ;
		[curLastFrmID])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
***
lnLastFrmID = curLastFrmID.FrmID
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*11.05.2006 17:13 -> ����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*11.05.2006 17:12 -> ������ ������������� ����� ������������ ��������
RETURN lnLastFrmID
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
