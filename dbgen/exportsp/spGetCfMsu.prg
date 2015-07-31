*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: spGetCfMsu()
* Called by.......: <NA>
* Parameters......: <tnOldMsuID, tnCurMsuID>
* Returns.........: <����������� ����������� ��� ����>
* Notes...........: ������� �� ����� �� � ������
*------------------------------------------------------------------------------
PROCEDURE spGetCfMsu
LPARAMETERS tnOldMsuID, tnCurMsuID

*09.06.2006 15:50 -> ���������� � ������������� ����������
LOCAL	lnCfBaseMsu, ;
		lnCfTargMsu, ;
		lnResultCf, ;
		lnSqlExeResult, ;
		llResult
***
lnCfBaseMsu = 000000000.00000
lnCfTargMsu = 000000000.00000
lnResultCf  = 000000000.00000
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ���������� ����������� ��� ������� ��
lnSqlExeResult = 0
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[SELECT ] + ;
			[MeasureUnit.MsuQnt ] + ;
		[FROM MeasureUnit ] + ;
		[WHERE MeasureUnit.MsuID = ?tnOldMsuID], ;
		[curOldMsuID])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN 0
ENDIF
***
lnCfBaseMsu = curOldMsuID.MsuQnt 
***
USE IN SELECT([curOldMsuID])
*------------------------------------------------------------------------------

*09.06.2006 16:02 -> ���������� ����������� ��� ������� ��
lnSqlExeResult = 0
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[SELECT ] + ;
			[MeasureUnit.MsuQnt ] + ;
		[FROM MeasureUnit ] + ;
		[WHERE MeasureUnit.MsuID = ?tnCurMsuID], ;
		[curMsuID])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN 0
ENDIF
***
lnCfTargMsu = curMsuID.MsuQnt 
***
USE IN SELECT([curMsuID])
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*09.06.2006 15:55 -> ���������� ����������� ��������� ������� �� � �������
lnResultCf = lnCfTargMsu / IIF(lnCfBaseMsu = 0, 1, lnCfBaseMsu)
*------------------------------------------------------------------------------

*09.06.2006 15:55 -> ���������� ���������
RETURN lnResultCf
*------------------------------------------------------------------------------

*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*******************************************************************************
*��������� ��� ������ � ������������
PROCEDURE _______ACCOUNTING_PROCEDURES_______
ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
