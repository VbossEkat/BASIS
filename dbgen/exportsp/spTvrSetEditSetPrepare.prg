*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures For Basis
* Module/Procedure: spTvrSetEditSetPrepare()
* Called by.......: <NA>
* Parameters......: <tnTvrSetID>
* Returns.........: <none>
* Notes...........: ���������� ������ ��� �������������� ������ �������
*------------------------------------------------------------------------------
PROCEDURE spTvrSetEditSetPrepare
LPARAMETERS tnTvrSetID

*02.08.2005 16:52 ->���������� � ������������� ����������
LOCAL	_PARAM, ;
		lcTLUIdExp, ;
		lcTvrNMExp, ;
		lcTLUJoinExp, ;
		lcTvrSetTLUTypeJoinExp, ;
		lcTvrSetTvrTypeJoinExp, ;
		lcTvrInSetJoinExp, ;
		lnKeyCounter, ;
		lnConnectHandle, ;
		lnSqlExeResult
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
		[EXECUTE spTvrSetEditSetPrepare ?tnTvrSetID],[TvrInSetEdit])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN
ENDIF
*------------------------------------------------------------------------------

*04.08.2005 11:19 -> �������� ������ �� ���� � �������
SELECT TvrInSetEdit
COPY TO tmp\TvrInSetEdit.dbf
USE IN SELECT([TvrInSetEdit])
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*04.08.2005 16:43 ->��������� ������ ����������� ���������������
IF lvTvrSetByID.BindTLU
	
	*06.07.2006 15:54 -> ������� ������ � ������
	USE TvrInSetEdit IN 0
	*------------------------------------------------------------------------------
	
	*04.08.2005 16:46 ->������� ������ ����������� ������
	CREATE TABLE tmp\tmpKey FREE (Key I)
	FOR lnKeyCounter = 1 TO RECCOUNT([TvrInSetEdit])
	   INSERT INTO tmpKey (Key) VALUES (lnKeyCounter)
	ENDFOR &&* m.i = 1 TO 10
	*------------------------------------------------------------------------------
	
	*04.08.2005 16:55 ->������� ����������� �����, ���������� ���������������� �����
	DELETE FROM tmpKey WHERE Key IN (SELECT Key FROM TvrInSetEdit WHERE TvrInSetEdit.TvrIsCnt)
	*------------------------------------------------------------------------------
	
	*04.08.2005 17:00 ->����������� ������� ����� �����
	GO TOP IN tmpKey
	***
	SELECT TvrInSetEdit
	SCAN ALL FOR !TvrInSetEdit.TvrIsCnt
		REPLACE TvrInSetEdit.TKey WITH tmpKey.Key
		SKIP IN tmpKey
	ENDSCAN
	*------------------------------------------------------------------------------
	
	*04.08.2005 11:19 ->������� Alias
	USE IN IIF(USED([TvrInSetEdit]),[TvrInSetEdit],0)
	*------------------------------------------------------------------------------

	*05.08.2005 16:14 ->������� ��������� ������� � ������ ��������� �������
	USE IN IIF(USED([tmpKey]),[tmpKey],0)
	IF FILE([tmp\tmpKey.dbf])
		ERASE tmp\tmpKey.dbf
	ENDIF
	*------------------------------------------------------------------------------

ENDIF
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
