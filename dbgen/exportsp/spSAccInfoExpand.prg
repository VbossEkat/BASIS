*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spSAccInfoExpand()
* Called by.......: <NA>
* Parameters......: <tcSAccIdList, tcRptSAccInfo>
* Returns.........: <none>
* Notes...........: ������� ���������� �� ��������� ������
*-------------------------------------------------------
PROCEDURE spSAccInfoExpand
LPARAMETERS tcSAccIdList, tcRptSAccInfo

*24.04.2006 12:49 ->���������� � ������������� ����������
LOCAL	lcRptSAccInfoPath, ;
		lcFilterExpr, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcRptSAccInfoPath = [tmp\] + tcRptSAccInfo + [.dbf]
*------------------------------------------------------------------------------

*21.04.2006 16:14 -> ���������� ������ �� ������� ��������� ��������������� ��������� ������ ��������
lcFilterExpr = spGetTmpValueList(tcSAccIdList)
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ��������� ������ (������� ��������� ������ �� ��������� ������)
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE spSAccInfoExpand ?lcFilterExpr],tcRptSAccInfo)
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> �������� ������ �� ���� � �������
SELECT (tcRptSAccInfo)
COPY TO (lcRptSAccInfoPath)
***
USE IN SELECT(tcRptSAccInfo)
*------------------------------------------------------------------------------

*24.04.2006 13:59 -> ������� ����������� �� ���� �������
USE (lcRptSAccInfoPath) IN 0
*------------------------------------------------------------------------------

*16.09.2004 15:55 ->�������� ������ ��� Relation-�
SELECT (tcRptSAccInfo)
INDEX ON CltSAccID TAG CltSAccID OF ([tmp\]+tcRptSAccInfo)
*------------------------------------------------------------------------------
	
ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
