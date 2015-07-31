*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spOpenCheck()
* Called by.......: <NA>
* Parameters......: <tnSalesID,tnCheckTypeID,tnCashID,tnCltID>
* Returns.........: <none>
* Notes...........: �������� ���
*------------------------------------------------------------------------------
PROCEDURE spOpenCheck
LPARAMETERS tnSalesID, ;
			tnCheckTypeID, ;
			tnCashID, ;
			tnCltID
			
*15.04.2006 10:33 ->���������� � ������������� ����������
LOCAL	lcUniqueName, ;
		lcUniqueFilePath, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcUniqueName = [sl]+SYS(2015)
lcUniqueFilePath = [tmp\] + lcUniqueName + [.DBF]
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ��������� �������� ��������� �� ������� �������
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE spOpenCheck ?tnSalesID, ?tnCheckTypeID, ?tnCashID, ?tnCltID],lcUniqueName)
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> �������� ������ � ���� � �������
SELECT (lcUniqueName)
***
COPY TO (lcUniqueFilePath)
***
USE IN (lcUniqueName)
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*21.04.2004 14:27 -> ������ ��� ������� � ����������� ����
RETURN lcUniqueName
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
