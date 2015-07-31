*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spTvrSetTree()
* Called by.......: <NA>
* Parameters......: <tnTvrSetID>
* Returns.........: <lcUniqueFileNM>
* Notes...........: 
*------------------------------------------------------------------------------
PROCEDURE spTvrSetTree
LPARAMETERS tnTvrSetID

*19.04.2006 11:58 -> ���������� � ������������� ����������
LOCAL   lcUniqueName, ;
		lcUniqueFilePath, ;
		lnRootID, ;
		lnPrcTypeID, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcUniqueName = [ts]+SYS(2015)
lcUniqueFilePath = [tmp\] + lcUniqueName + [.dbf]
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
		[EXECUTE spTvrSetTree ?tnTvrSetID],lcUniqueName)
ENDDO
***
IF lnSqlExeResult = -1

	*11.08.2006 17:22 ->������� ���������� ������
	spHandleODBCError()
	*------------------------------------------------------------------------------
	
	*11.08.2006 17:22 ->�������� ������ ������
	CREATE CURSOR (lcUniqueName) ( ;
		TKey I, TvrID I, TluID I, TvrParID I, TvrIsCnt L, TvrNM C(1), ListNumber I, Mark L, ;
		BmpID I, SBmpID I, BmpMID I, SBmpMID I, BmpPMID I, SBmpPMID I ;
	)
	*------------------------------------------------------------------------------

ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> �������� ������ �� ���� � �������
SELECT (lcUniqueName)
***
COPY TO (lcUniqueFilePath)
***
USE IN SELECT(lcUniqueName)
*------------------------------------------------------------------------------

*06.07.2006 15:06 -> ���������� ��� �����
RETURN lcUniqueName
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
