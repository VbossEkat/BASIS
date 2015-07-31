*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spFrmExternalPartFrmPrintDetail()
* Called by.......: <When Document Printed>
* Parameters......: <tnFrmID, tlAddSignature>
* Returns.........: <������ ��������� ������, ��������� ��� ������>
* Notes...........: ������� ��� ������ ���������� ���������� ������ � ������� FrmPayDetail
*-------------------------------------------------------
PROCEDURE spFrmExternalPartFrmPrintDetail
LPARAMETERS tcQryParSID

*11.05.2005 12:53 ->���������� � ������������� ����������
LOCAL	lcResult, ;
		lnFrmID, ;
		llAddSignature, ;
		lnConnectHandle, ;
		lnSqlExeResult
*------------------------------------------------------------------------------

*12.01.2005 10:35 -> �������� ��������� ������� ����������� ������ ��� FrmPayDetail
lcResult = spFrmExternalPartFrmPrint(tcQryParSID)
*------------------------------------------------------------------------------

*11.05.2005 12:54 ->������ ���������
IF TYPE([oQryParMgr])==[O] AND !ISNULL(oQryParMgr)

	*26.05.2004 21:18 ->������ ������������� ���������, ������� ����� ��������
	lnFrmID = oQryParMgr.ParamGet(tcQryParSID,[FrmID])
	*------------------------------------------------------------------------------
	
	*11.05.2005 12:55 ->������ ��������� ������ "� �������/��� ������"
	llAddSignature = oQryParMgr.ParamGet(tcQryParSID,[qplAddSign])
	*------------------------------------------------------------------------------

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
		[EXECUTE spFrmExternalPartFrmPrintDetail ?lnFrmID],[RptItogPD])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> �������� ������ �� ���� � �������
SELECT RptItogPD
COPY TO tmp\RptItogPD.dbf
***
USE IN SELECT([RptItogPD])
*------------------------------------------------------------------------------

*24.04.2006 13:59 -> ������� ����������� �� ���� �������
USE tmp\RptItogPD IN 0
*------------------------------------------------------------------------------

*12.01.2005 10:48 -> ������ ������ ��������� ������, ��������� ��� ������
RETURN lcResult + [;RPTITOGPD.DBF]
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
