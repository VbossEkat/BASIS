*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored procedures for Basis
* Module/Procedure: spFrmInventoryPrint()
* Called by.......: <NA>
* Parameters......: <tcQryParSID>
* Returns.........: <������ ��������� ������, ��������� ��� ������>
* Notes...........: ������� ��� ������ "������������������ ���������"
*------------------------------------------------------------------------------
PROCEDURE spFrmInventoryPrint
LPARAMETERS tcQryParSID

*12.05.2006 11:02 -> ���������� � ������������� ����������
LOCAL	lnFrmID, ;
		lcOldAlias, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcOldAlias = ALIAS()
*------------------------------------------------------------------------------

*12.05.2006 11:02 -> ������� ������� � ���������� ��� ������
CREATE TABLE tmp\RptEnv FREE (QryParSID C(10))
INSERT INTO RptEnv (QryParSID) VALUES (tcQryParSID)
*------------------------------------------------------------------------------

*12.05.2006 11:02 ->������ ���������
IF TYPE([oQryParMgr])==[O] AND !ISNULL(oQryParMgr)

	*12.05.2006 11:02 -> ������ ������������� ���������, ������� ����� ��������
	lnFrmID = oQryParMgr.ParamGet(tcQryParSID,[FrmID])
	*------------------------------------------------------------------------------

ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*13.04.2006 14:01 -> ��������� �������� BatchMode � False, ����� �������� �������������� ������� � ������� �� ������� �������� SQLMoreResults
SQLSETPROP(lnConnectHandle,[BatchMode],.F.)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ��������� ������
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE spFrmInventoryPrint ?lnFrmID],[RptItogHD])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*13.04.2006 14:03 -> �������� ������ �������������� �������
SQLMORERESULTS(lnConnectHandle,[InvTotal])
SQLMORERESULTS(lnConnectHandle,[RptItogDT])
SQLMORERESULTS(lnConnectHandle)
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> �������� ������� �� ���� � �������
SELECT RptItogHD
COPY TO tmp\RptItogHD.dbf
***
SELECT InvTotal
COPY TO tmp\InvTotal.dbf
***
SELECT RptItogDT
COPY TO tmp\RptItogDT.dbf
***
USE IN SELECT([RptItogHD])
USE IN SELECT([InvTotal])
USE IN SELECT([RptItogDT])
*------------------------------------------------------------------------------

*30.06.2006 13:25 -> ������� ������������� ��������
*!*	USE RptItogDT IN 0
*!*	***
*!*	LOCAL lnTvrID
*!*	***
*!*	SELECT RptItogDT
*!*	lnTvrID = 0
*!*	***
*!*	SCAN ALL
*!*		IF lnTvrID = RptItogDT.TvrID
*!*			REPLACE ;
*!*				RptItogDT.MsuNM  WITH [], ;
*!*				RptItogDT.TvrQnt WITH 0, ;
*!*				RptItogDT.TvrSum WITH 0
*!*		ENDIF
*!*		lnTvrID = RptItogDT.TvrID
*!*	ENDSCAN
*------------------------------------------------------------------------------

*12.05.2006 11:29 -> ������� �������
USE IN SELECT([RptEnv])
USE IN SELECT([RptItogDT])
*------------------------------------------------------------------------------

*12.05.2006 11:29 -> ����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*12.05.2006 11:29 -> ������ ������ ��������� ������ ��� ���������� ������
RETURN [RptItogHD.dbf;RptItogDT.dbf;InvTotal.dbf;RptEnv.dbf]
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
