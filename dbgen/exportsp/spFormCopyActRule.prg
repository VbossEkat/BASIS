*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spFormCopyActRule()
* Called by.......: <NA>
* Parameters......: <tnSrcFrmID,tnTargetFrmTypeID,tcOperation>
* Returns.........: <none>
* Notes...........: ����������� ��������� ��������� � ��� ������������
*------------------------------------------------------------------------------
PROCEDURE spFormCopyActRule
LPARAMETERS tnSrcFrmID,tnTargetFrmTypeID,tcOperation

*15.12.2004 16:49 -> ���������� � ������������� ����������
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

*07.04.2006 16:45 -> ��������� ������
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE spFormCopyActRule ?tnSrcFrmID, ?tnTargetFrmTypeID, ?tcOperation], ;
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

*15.12.2004 16:50 -> ����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*16.12.2004 17:58 -> ������ ������������� ����� ������������ ��������
RETURN lnLastFrmID
*------------------------------------------------------------------------------

************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spFormCopyBludo()
* Called by.......: <NA>
* Parameters......: <tnSrcFrmID,tnTargetFrmTypeID,tcOperation>
* Returns.........: <none>
* Notes...........: ��������� �������� � ���������� � ���� �� ��������� ;
                  * ������ ���� � ������������� 
                  * ������ ���� ��������� ����������� ����
*------------------------------------------------------------------------------
PROCEDURE spFormCopyBludo
LPARAMETERS tnSrcFrmID,tnTargetFrmTypeID,tcOperation,tlIsOnlyBludo

*15.12.2004 16:49 -> ���������� � ������������� ����������
LOCAL	lcOldAlias, ;
		lnLastFrmID, ;
		llIsOnlyBludo, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcOldAlias = ALIAS()
IF PCOUNT() = 3
	llIsOnlyBludo = (MESSAGEBOX([�������� ������ ������������� (��� ����)?],4+32+256, [������])= 7)
ELSE
	llIsOnlyBludo = tlIsOnlyBludo
ENDIF
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
		[EXECUTE spFormCopyBludo ?tnSrcFrmID, ?tnTargetFrmTypeID, ?tcOperation, ?llIsOnlyBludo], ;
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

*15.12.2004 16:50 -> ����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*16.12.2004 17:58 -> ������ ������������� ����� ������������ ��������
RETURN lnLastFrmID
*------------------------------------------------------------------------------

************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spFormCopyAuto()
* Called by.......: <NA>
* Parameters......: <tnSrcFrmID,tnTargetFrmTypeID,tcOperation>
* Returns.........: <none>
* Notes...........: ��������� �������� � ���������� � ���� �� ��������� ;
                  * ������ ���� � ������������� c ����������� ����������
                  * ������ ���� ��������� ����������� ����
*------------------------------------------------------------------------------
PROCEDURE spFormCopyAuto
LPARAMETERS tnSrcFrmID,tnTargetFrmTypeID,tcOperation

*15.12.2004 16:49 -> ���������� � ������������� ����������
LOCAL	lcOldAlias, ;
		llIsOnlyBludo, ;
		lnSrcFrmID, ;
		lnLastFrmID, ;
		lnHalfReady, ;
		lnCounter, ;
		lnCirc, ;
		laCirc(1)
***
llIsOnlyBludo = .T.
lnSrcFrmID = tnSrcFrmID
***
lcOldAlias = ALIAS()
*------------------------------------------------------------------------------

*19.06.2006 11:20 -> ������� ��� ������������ � ������� �� �������� ���������
DO WHILE .T.

	*19.06.2006 11:58 -> ��������� ����������� ���������
	lnLastFrmID = spFormCopyBludo(lnSrcFrmID,tnTargetFrmTypeID,tcOperation,llIsOnlyBludo)
	llIsOnlyBludo = .F.
	lnCirc = ALEN(laCirc)
	laCirc[lnCirc] = lnLastFrmID
	DIMENSION laCirc(lnCirc+1)
	lnSrcFrmID = lnLastFrmID
	*------------------------------------------------------------------------------

	*19.06.2006 11:58 -> ������� ��� ������������
	lnHalfReady = spMakeActPro(lnLastFrmID)
	*------------------------------------------------------------------------------

	*19.06.2006 11:25 -> ��������� �� ������� ��������������, ���� �� ��� - �������
	IF lnHalfReady = 0
		EXIT
	ENDIF
	*------------------------------------------------------------------------------

ENDDO
*------------------------------------------------------------------------------

*19.06.2006 12:06 -> �������������� ���� ����������� �� �������� � �� �����������
FOR lnCounter = ALEN(laCirc) TO 1 STEP -1
	lnLastFrmID = laCirc[lnCirc]
	spReqActBay(lnLastFrmID,.F.)
ENDFOR
*------------------------------------------------------------------------------

*15.12.2004 16:50 ->����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*19.06.2006 12:12 -> ����� ���������
MESSAGEBOX([��������� ���������� ���������],64,[����������])
*------------------------------------------------------------------------------

*16.12.2004 17:58 -> ������ ������������� ����� ������������ ��������
RETURN lnLastFrmID
*------------------------------------------------------------------------------

************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*------------------------------------------------------------------------------
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
