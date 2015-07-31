*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spFrmPartTvrView()
* Called by.......: <NA>
* Parameters......: <tcExecVar[,tuFrmID[,tnFrmPartFrmID]]>
*					<[NODATA]>
*					<[BYFRMID],tnFrmID>
*					<[BYFRMPARTTVRID],tnFrmID,tnFrmPartTvrID>
* Returns.........: <lcUniqueFileName>
* Notes...........: ��������� ������ ��� ��������� �������� ������� ���������
*-------------------------------------------------------
PROCEDURE spFrmPartTvrView
LPARAMETERS tcExecVar,tuFrmID,tuFrmPartTvrID

*21.04.2004 12:31 ->���������� � ������������� ����������
LOCAL	lcUniqueName, ;
		lcUniqueFilePath, ;
		lcFilterExpr, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcUniqueName = [_d] + SYS(2015)
lcUniqueFilePath = [tmp\] + lcUniqueName + [.DBF]
*------------------------------------------------------------------------------

*21.04.2004 12:33 ->��������� ������� � ����������� ���� �������
DO CASE
	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[NODATA]
		
		*21.04.2004 12:34 ->��������� ������, ��� ������������ ������ �������
		lcFilterExpr = [WHERE 0=1]
		*------------------------------------------------------------------------------

	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[BYFRMID]
		
		*21.04.2004 12:32 ->��������� ������ ��� ������ �������� ������� ������ ���������
		lcFilterExpr = [WHERE FrmPartTvr.FrmID = ]+ALLTRIM(STR(tuFrmID))
		*------------------------------------------------------------------------------
	
	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[BYFRMPARTTVRID]
		
		*21.04.2004 12:32 ->��������� ������ ��� ������ �������� ������� ������ ���������
		lcFilterExpr = 	[WHERE FrmPartTvr.FrmID = ] + ALLTRIM(STR(tuFrmID)) + ;
						[AND FrmPartTvr.FrmPartTvrID = ] + ALLTRIM(STR(tuFrmPartTvrID))
		*------------------------------------------------------------------------------

ENDCASE
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
		[EXECUTE spFrmPartTvrView ?lcFilterExpr],lcUniqueName)
ENDDO
***
IF lnSqlExeResult = -1

	*11.08.2006 15:37 ->������� ���������� ������
	spHandleODBCError()
	*------------------------------------------------------------------------------
	
	*11.08.2006 15:30 ->�������� ������ ������
	CREATE CURSOR (lcUniqueName) ( ;
		PartTvrID I, TvrTypeID I, TvrIdCalc I, TvrID I, TvrNM C(1), TvrQnt I, TvrQntNett I, ;
		MsuShortNM C(1), TvrPrcBuy I, TvrSumBuy I, TvrPrcSale I, TvrSumSale I, MsuID I, FrmID I ; 
	)
	*------------------------------------------------------------------------------
	
ENDIF
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> �������� ������ � ���� � �������
SELECT (lcUniqueName)
***
COPY TO (lcUniqueFilePath)
***
USE IN SELECT(lcUniqueName)
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*21.04.2004 14:27 ->������ ��������
RETURN lcUniqueName
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
