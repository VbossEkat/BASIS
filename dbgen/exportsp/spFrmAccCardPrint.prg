*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spFrmAccCardPrint()
* Called by.......: <When Document Printed>
* Parameters......: <tnFrmID, tlAddSignature>
* Returns.........: <������ ��������� ������, ��������� ��� ������>
* Notes...........: ������� ��� ������ ������� ���������� ���������� ������
*------------------------------------------------------------------------------
PROCEDURE spFrmAccCardPrint
LPARAMETERS tcQryParSID

*11.05.2005 12:53 -> ���������� � ������������� ����������
LOCAL	lnFrmID, ;
		llAddSignature, ;
		lnConnectHandle, ;
		lnSqlExeResult
*------------------------------------------------------------------------------

*11.05.2005 12:54 -> ������ ���������
IF TYPE([oQryParMgr])==[O] AND !ISNULL(oQryParMgr)

	*26.05.2004 21:18 -> ������ ������������� ���������, ������� ����� ��������
	lnFrmID = oQryParMgr.ParamGet(tcQryParSID,[FrmID])
	*------------------------------------------------------------------------------
	
	*11.05.2005 12:55 -> ������ ��������� ������ "� �������/��� ������"
	llAddSignature = oQryParMgr.ParamGet(tcQryParSID,[qplAddSign])
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
		[EXECUTE spFrmAccCardPrint ?lnFrmID, ?llAddSignature],[RptItogHD])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*13.04.2006 14:03 -> �������� ������ �������������� �������
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
SELECT RptItogDT
COPY TO tmp\RptItogDT.dbf
***
USE IN SELECT([RptItogHD])
USE IN SELECT([RptItogDT])
*------------------------------------------------------------------------------

*24.04.2006 13:59 -> ������� ����������� �� ���� �������
USE tmp\RptItogHD IN 0
USE tmp\RptItogDT IN 0
*------------------------------------------------------------------------------

*05.08.2004 15:42 -> �������� ������ ��������������� ��������, ������������� � ���������
SELECT ;
	RptItogHD.CltID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.OwnCltID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.DevCltID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.ExEmiCltID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.ExIspCltID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.CntCltID AS ID ;
FROM RptItogHD ;
INTO TABLE tmp\tmpCltIdList
*------------------------------------------------------------------------------

*05.08.2004 15:54 ->������� ��������� ������ �� ��������
spClientInfoExpand([tmpCltIdList],[RptCltInfo])
*------------------------------------------------------------------------------

*22.07.2004 20:50 -> ������ ������ ��������� ������, ��������� ��� ������
RETURN [RPTITOGHD.DBF;RPTITOGDT.DBF;RptCltInfo.dbf;RptCltInfo.cdx]
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
