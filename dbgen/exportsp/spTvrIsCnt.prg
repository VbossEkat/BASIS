*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spTvrIsCnt()
* Called by.......: <NA>
* Parameters......: <tnTvrID>
* Returns.........: <none>
* Notes...........:	���������� �������� �� ����� �����������
*------------------------------------------------------------------------------
PROCEDURE spTvrIsCnt
LPARAMETERS tnTvrID

*31.05.2006 10:05 -> ���������� � ������������� ����������
LOCAL   lnConnectHandle, ;
		lnSqlExeResult, ;
		llResult
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> �������� ������
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[SELECT ] + ;
			[TvrType.TvrTypeIsCnt ] + ;
		[FROM Tovar ] + ;
		[INNER JOIN TvrType ON TvrType.TvrTypeID = Tovar.TvrTypeID ] + ;
		[WHERE Tovar.TvrID = ?tnTvrID], ;
		[curTovar])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*21.04.2006 14:16 -> �������� ������� ������
llResult = curTovar.TvrTypeIsCnt
*------------------------------------------------------------------------------

*21.04.2006 14:17 -> ������� ������
USE IN SELECT([curTovar])
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

RETURN llResult

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
