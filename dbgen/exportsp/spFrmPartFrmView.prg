*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spFrmPartFrmView()
* Called by.......: <NA>
* Parameters......: <tcExecVar[,tuFrmID[,tuFrmPartFrmID]]>
*					<[NODATA]>
*					<[BYFRMID],tnFrmID>
*					<[BYFRMPARTFRMID],tnFrmID,tnFrmPartFrmID>
* Returns.........: <lcUniqueFileName>
* Notes...........: ��������� ������ ��� ��������� �������� ������� ���������
*-------------------------------------------------------
PROCEDURE spFrmPartFrmView
LPARAMETERS tcExecVar,tuFrmID,tuFrmPartFrmID

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

*21.04.2004 12:33 ->��������� ������� � ����������� �� ���� �������
DO CASE

	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[NODATA]
		
		*21.04.2004 12:34 ->��������� ������, ��� ������������ ������ �������
		lcFilterExpr = [WHERE 0=1]
		*------------------------------------------------------------------------------

	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[BYFRMID]
		
		*21.04.2004 12:32 ->��������� ������ ��� ������ �������� ������� ������ ���������
		lcFilterExpr = [WHERE FrmPartFrm.FrmID = ]+ALLTRIM(STR(tuFrmID))
		*------------------------------------------------------------------------------
	
	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[BYFRMPARTFRMID]
		
		*21.04.2004 12:32 ->��������� ������ ��� ������ �������� ������� ������ ���������
		lcFilterExpr = 	[WHERE FrmPartFrm.FrmID = ] + ALLTRIM(STR(tuFrmID)) + [ ] + ;
						[AND FrmPartFrm.FrmPartFrmID = ] + ALLTRIM(STR(tuFrmPartFrmID))
		*------------------------------------------------------------------------------

ENDCASE
*------------------------------------------------------------------------------		

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ��������� ������
lnSqlExeResult = -1
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE spFrmPartFrmView ?lcFilterExpr],lcUniqueName)
ENDDO
***
IF lnSqlExeResult = -1

	*11.08.2006 15:29 ->������� ���������� ������
	spHandleODBCError()
	*------------------------------------------------------------------------------
	
	*11.08.2006 15:30 ->�������� ������ ������
	CREATE CURSOR (lcUniqueName) ( ;
		PartFrmID I, CntFrmNM C(1), CntFrmSum I, CntFrmVAT I, CntFrmId I ;
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
