*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: _spMainMarked()
* Called by.......: <NA>
* Parameters......: <tcTableNM, tcFieldNameFlag, tcFieldNameID, tnID>
* Returns.........: <none>
* Notes...........: �������� ������������ ����� "��������"
*-------------------------------------------------------
PROCEDURE _spMainMarked
LPARAMETERS	tcTableNM, tcFieldNameFlag, tcFieldNameID, tnID

*24.08.2005 14:15 -> ���������� � ������������� ����������
LOCAL	lcFilterExpr, ;
		lcQuery, ;
		lnSqlExeResult, ;
		llResult
***
lcFilterExpr = [WHERE ] + tcFieldNameFlag + [ = 1]
*------------------------------------------------------------------------------

*24.08.2005 14:16 -> ������������� �������������� ������
IF PCOUNT()=4
	lcFilterExpr = lcFilterExpr + [ AND ] + tcFieldNameID + [ = ?tnID]
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:44 -> ��������� ������ � ��
lcQuery = [SELECT ] + tcFieldNameFlag + [ FROM ] + tcTableNM + [ ] + lcFilterExpr
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ��������� ������
lnSqlExeResult = 0
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		lcQuery,[tmp])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN 0
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:46 -> �������� ���������
llResult = RECCOUNT([tmp]) > 0
*------------------------------------------------------------------------------

*07.04.2006 16:46 -> ������� ������
USE IN tmp
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ���������� ���������
RETURN llResult
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
