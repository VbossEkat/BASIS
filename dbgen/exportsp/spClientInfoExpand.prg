*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spClientInfoExpand()
* Called by.......: <NA>
* Parameters......: <tcCltIdListTable, tcCltListTable>
* Returns.........: <none>
* Notes...........: ������� ���������� � ��������
*-------------------------------------------------------
PROCEDURE spClientInfoExpand
LPARAMETERS	tcCltIdListTable, tcCltListTable

*24.04.2006 12:49 ->���������� � ������������� ����������
LOCAL	lcFilterExpr, ;
		lnConnectHandle, ;
		lnSqlExeResult
*------------------------------------------------------------------------------

*21.04.2006 16:14 -> ���������� ������ �� ������� ��������������� ��������
lcFilterExpr = spGetTmpValueList(tcCltIdListTable)
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ��������� ������ (������� ��������� ������ �� ��������)
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE spClientInfoExpand ?lcFilterExpr],[curCltList])
ENDDO
***
IF lnSqlExeResult = -1

	*11.08.2006 16:02 ->������� ���������� ������
	spHandleODBCError()
	*------------------------------------------------------------------------------
	
	RETURN
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*15.09.2004 11:53 -> C������ ������������
SELECT ;
	curCltList.CltID, ;
	curCltList.CltNM, ;
	LTRIM(ALLTRIM(curCltList.CltLTAbbr) + ;
		[ ]+ALLTRIM(curCltList.CltJrdNM) + ;
		ALLTRIM(curCltList.CltFIO)) AS CltFullNM, ;
	LTRIM(ALLTRIM(curCltList.CltLTAbbr) + ;
		[ ]+ALLTRIM(curCltList.CltJrdNM) + ;
		ALLTRIM(curCltList.CltFIO_)) AS CltFullNM_, ;
	SUBSTR(PADR(IIF(!EMPTY(curCltList.CltFullINN),[, ]+ALLTRIM(curCltList.CltFullINN),[]) + ;
		IIF(!EMPTY(curCltList.CltFullKpp),[, ]+ALLTRIM(curCltList.CltFullKpp),[]),254),3) AS CltInnKpp, ;
	SUBSTR(PADR(IIF(curCltList.CltAddrZIP>0, [, ]+ALLTRIM(STR(curCltList.CltAddrZIP)), []) + ;
		IIF(!EMPTY(curCltList.CltAddrReg), [, ]+ALLTRIM(curCltList.CltAddrReg), []) + ;
		IIF(!EMPTY(curCltList.CltAddrStl), [, ]+ALLTRIM(curCltList.CltAddrStl), []) + ;
		IIF(!EMPTY(curCltList.CltAddrStr), [, ]+ALLTRIM(curCltList.CltAddrStr), []) + ;
		IIF(!EMPTY(curCltList.CltAddrHs), [, ]+ALLTRIM(curCltList.CltAddrHs), []) + ;
		IIF(!EMPTY(curCltList.CltAddrRm), [, ]+ALLTRIM(curCltList.CltAddrRm), []) + ;
		IIF(!EMPTY(curCltList.CltTel), [, ]+ALLTRIM(curCltList.CltTel), []), 254),3) AS CltFullAdr, ;
	PADR(LTRIM(IIF(!EMPTY(curCltList.CltPhPSer), [ ����� ]+ALLTRIM(curCltList.CltPhPSer), []) + ;
		IIF(!EMPTY(curCltList.CltPhPNum), [ ����� ]+ALLTRIM(curCltList.CltPhPNum), []) + ;
		IIF(!EMPTY(curCltList.CltPhPID) OR !EMPTY(curCltList.CltPhPIB), [ �����], []) + ;
		IIF(!EMPTY(curCltList.CltPhPIB), [ ]+ALLTRIM(curCltList.CltPhPIB), []) + ;
		IIF(!EMPTY(curCltList.CltPhPID), [ ]+DTOC(TTOD(curCltList.CltPhPID)), [])), 254) AS CltFullPh, ;
	curCltList.CltTypeID, ;
	curCltList.CltINN, ;
	curCltList.CltFullINN, ;
	curCltList.CltAddrZip, ;
	curCltList.CltAddrReg, ;
	curCltList.CltAddrStl, ;
	curCltList.CltAddrStr, ;
	curCltList.CltAddrHs, ;
	curCltList.CltAddrRm, ;
	curCltList.CltTel, ;
	curCltList.CltJrdNM, ;
	curCltList.CltJrdKPP, ;
	curCltList.CltFullKPP, ;
	curCltList.CltLTAbbr, ;
	curCltList.CltLTNM, ;
	curCltList.CltPhysFNM, ;
	curCltList.CltPhysINM, ;
	curCltList.CltPhysONM, ;
	curCltList.CltFIO, ;
	curCltList.CltFIO_, ;
	curCltList.CltPhBDate, ;
	curCltList.CltPhPSer, ;
	curCltList.CltPhPNum, ;
	curCltList.CltPhPID, ;
	curCltList.CltPhPIB, ;
	curCltList.CltPhPDate ;
FROM curCltList ;
INTO TABLE ([tmp\]+tcCltListTable)
*------------------------------------------------------------------------------

*16.09.2004 15:55 ->�������� ������ ��� Relation-�
SELECT (tcCltListTable)
INDEX ON CltID TAG CltID OF ([tmp\]+tcCltListTable)
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
