*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spFrmAutoNumGetCounter()
* Called by.......: spFrmAutoNum()
* Parameters......: <tnFrmTypeID,tnOwnCltID,tnOUID>
* Returns.........: <lnCounter>
* Notes...........: ���������� ������� ��������������
*------------------------------------------------------------------------------
PROCEDURE spFrmAutoNumGetCounter
LPARAMETERS tnFrmTypeID,tnOwnCltID,tnOUID

*27.06.2006 15:17 -> ���������� � ������������� ����������
LOCAL 	lcOldAlias, ;
		lnConnectHandle, ;
		lnSqlExeResult, ;
		lnLastID, ;
		lnCounter
***
lcOldAlias = ALIAS()
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ������� ��������� �������������
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE spFrmAutoNumGetCounter ?tnFrmTypeID, ?tnOwnCltID, ?tnOUID], ;
		[curFrmNumCounter])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN
ENDIF
***
lnCounter = curFrmNumCounter.FrmNumCntVal
***
USE IN SELECT([curFrmNumCounter])
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*23.12.2004 12:14 ->����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*22.12.2004 12:15 -> ���������� �������� ��������
RETURN lnCounter
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
