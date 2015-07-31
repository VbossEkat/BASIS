*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spFrmPrBookView()
* Called by.......: <NA>
* Parameters......: <tcExecVar[,tuFrmID[,tnFrmPartFrmID]]>
*					<[NODATA]>
*					<[BYFRMID],tnFrmID>
*					<[BYFRMPARTTVRID],tnFrmID,tnFrmPartID>
* Returns.........: <lcUniqueFileName>
* Notes...........: ��������� ������ ��� ��������� �������� ��������������� ���������
*-------------------------------------------------------
PROCEDURE spFrmPrBookView
LPARAMETERS tcExecVar,tuFrmID,tuFrmPartID

*05.08.2006 12:31 ->���������� � ������������� ����������
LOCAL	lcUniqueName, ;
		lcUniqueFilePath, ;
		lcFilterExpr, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcUniqueName = [_d] + SYS(2015)
lcUniqueFilePath = [tmp\] + lcUniqueName + [.DBF]
*------------------------------------------------------------------------------
*05.08.2006 12:33 ->��������� ������� � ����������� ���� �������
DO CASE
	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[NODATA]
		
		*05.08.2006 12:34 ->��������� ������, ��� ������������ ������ �������
		lcFilterExpr = [WHERE 0=1]
		*------------------------------------------------------------------------------

	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[BYFRMID]
		
		*05.08.2006 12:32 ->��������� ������ ��� ������ �������� ������� ������ ���������
		lcFilterExpr = [WHERE FrmPrBookView.PBookFrmID = ]+ALLTRIM(STR(tuFrmID))
		*------------------------------------------------------------------------------
	
	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[BYFRMPARTID]
		
		*05.08.2006 12:32 ->��������� ������ ��� ������ �������� ������� ������ ���������
		lcFilterExpr = 	[WHERE FrmPrBookView.PBookID = ] + ALLTRIM(STR(tuFrmPartID))
		*------------------------------------------------------------------------------

ENDCASE
*------------------------------------------------------------------------------		

*05.08.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*05.08.2006 16:45 -> ��������� ������
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE spFrmPrBookView ?lcFilterExpr],lcUniqueName)
ENDDO
***
IF lnSqlExeResult = -1
	*11.08.2006 15:37 ->������� ���������� ������
	spHandleODBCError()
	*------------------------------------------------------------------------------
	
	*11.08.2006 15:30 ->�������� ������ ������
	CREATE CURSOR (lcUniqueName) ( ;
		PBookID I, PBookFrmID I, PBookSum Y, Debet I, Credit I, PBookProvID I, DebetID I, CreditID I, FrmPartId I ;
	)
	*------------------------------------------------------------------------------
	
ENDIF
*------------------------------------------------------------------------------

*05.08.2006 14:07 -> �������� ������ � ���� � �������
SELECT (lcUniqueName)
***
COPY TO (lcUniqueFilePath)
***
USE IN SELECT(lcUniqueName)
*------------------------------------------------------------------------------

*05.08.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*05.08.2006 14:27 ->������ ��������
RETURN lcUniqueName
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
