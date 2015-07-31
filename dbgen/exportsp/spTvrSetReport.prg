*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures For Basis
* Module/Procedure: spTvrSetReport()
* Called by.......: <NA>
* Parameters......: <tcQryParSID>
* Returns.........: <none>
* Notes...........: ���������� ������ �� ������ �������
*------------------------------------------------------------------------------
PROCEDURE spTvrSetReport
LPARAMETERS tcQryParSID

*09.08.2005 17:10 ->���������� � ������������� ����������
LOCAL	lcFilterExpr, ;
		lcOrderExp, ;
		luTvrSetID, ;
		llSortName, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcFilterExpr = [WHERE 0<>1]
*------------------------------------------------------------------------------

*02.06.2005 15:47 ->������� ������� � ���������� ��� ������
CREATE TABLE tmp\RptEnv FREE (QryParSID C(10))
INSERT INTO RptEnv (QryParSID) VALUES (tcQryParSID)
*------------------------------------------------------------------------------

*25.05.2005 16:46 ->������ ������������� �������� �����
luTvrSetID = oQryParMgr.ParamGet(tcQryParSID,[TvrSetID])
***
lcFilterExpr = lcFilterExpr + [ AND TvrSet.TvrSetID = ] + ALLTRIM(STR(luTvrSetID))
*------------------------------------------------------------------------------
		
*11.05.2005 12:55 ->������ ��������� ������ "� �������/��� ������"
llSortName = oQryParMgr.ParamGet(tcQryParSID,[qplSortName])
***
IF ISNULL(llSortName) OR TYPE([llSortName])#[L]
	llSortName = .F.
ENDIF
***
lcOrderExp = IIF(llSortName,[ORDER BY 3],[ORDER BY 1])
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
		[EXECUTE spTvrSetReport ?lcFilterExpr, ?lcOrderExp],[tmpRptItogHD])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*13.04.2006 14:03 -> �������� ������ �������������� �������
SQLMORERESULTS(lnConnectHandle,[tmpRptItogDT])
SQLMORERESULTS(lnConnectHandle)
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> �������� ������ �� ���� � �������
SELECT tmpRptItogHD
COPY TO tmp\tmpRptItogHD.dbf
***
SELECT tmpRptItogDT
COPY TO tmp\tmpRptItogDT.dbf
***
USE IN SELECT([tmpRptItogHD])
USE IN SELECT([tmpRptItogDT])
*------------------------------------------------------------------------------

*09.08.2005 17:58 -> ���������� ����������
USE tmpRptItogDT IN 0
SELECT tmpRptItogDT
INDEX ON ALLTRIM(TvrParNM) TAG GrpSort COMPACT
SET ORDER TO
*------------------------------------------------------------------------------

*26.01.2005 19:10 -> ������ ������ ������ ��������� ��� ������
RETURN [RptEnv.dbf;tmpRptItogHD.dbf;tmpRptItogDT.dbf;tmpRptItogDT.cdx]
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
