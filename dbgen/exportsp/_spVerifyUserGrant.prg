*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: _spVerifyUserGrant()
* Called by.......: <NA>
* Parameters......: <tnUserID, tcTableNM, tuObjectID, tuObjectFunctionID>
* Returns.........: <none>
* Notes...........: �������� ���� ������� ������������
*------------------------------------------------------------------------------
PROCEDURE _spVerifyUserGrant
LPARAMETERS tnUserID, tcTableNM, tuObjectID, tuObjectFunctionID

*07.02.2006 16:29 -> ���������� � ������������� ����������
LOCAL   lcOldAlias, ;
		lnConnectHandle, ;
		lnSqlExeResult, ;
		llResult
***
lcOldAlias = ALIAS()
*------------------------------------------------------------------------------

*SET STEP ON

*28.07.2006 13:24 -> ���������, ���� �������� �����, ������ True
IF UPPER(ALLTRIM(tcTableNM)) = [SCREENFORM]
*	RETURN .T.
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
SET DATABASE TO Basis
***
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ��������� ������
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE _spVerifyUserGrant ?tnUserID, ?tcTableNM, ?tuObjectID] + IIF(PCOUNT()=4,[, ?tuObjectFunctionID],[]),[curUserGrant])
ENDDO
***
IF lnSqlExeResult = -1
	MESSAGEBOX([��������� ������ �� ����� ������ ������� � ��������.],16,[������ ����������.])
	RETURN
ENDIF
*------------------------------------------------------------------------------

*06.02.2006 19:31 -> ��������� ���������
llResult = IIF(RECCOUNT([curUserGrant]) = 0,.F.,.T.)
*------------------------------------------------------------------------------

*06.02.2006 18:08 -> ������� ������
USE IN SELECT([curUserGrant])
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*07.02.2006 16:30 -> ����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias # ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*06.02.2006 18:07 -> ���������� ���������
RETURN llResult
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
