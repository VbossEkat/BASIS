*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: spNaklOutMake()
* Called by.......: <NA>
* Parameters......: <tcQryParSID,tnStoragePlaceBing>
* Returns.........: <none>
* Notes...........: ������������ ��������� �� ����
*------------------------------------------------------------------------------
PROCEDURE spNaklOutMake
LPARAMETERS tcQryParSID, tnStoragePlaceBing

*11.07.2005 15:26 -> ���������� � ������������� ����������
LOCAL	lcOldAlias, ;
		lcOldDate, ;
		lcOldCentury, ;
		lcOldMark, ;
		lnStoragePlaceBing, ;
		lcFilterExpr, ;
		luQryParDateEnabled, ;
		luQryParDateEnabled, ;
		luQryParDateStartDate, ;
		luQryParDateEndDate, ;
		lnFrmID, ;
		lnRecordCount
***
lcOldAlias = ALIAS()
lcOldDate = SET([DATE])
lcOldCentury = SET([CENTURY])
lcOldMark = SET([MARK])
lnStoragePlaceBing = tnStoragePlaceBing
lcFilterExpr = []
*------------------------------------------------------------------------------

*07.12.2005 11:37 ->���������� ��������� ������������, ���� ���������� �������� ����������
IF TYPE([oQryParMgr])==[O] AND !ISNULL(oQryParMgr)
	
	*07.12.2005 11:37 ->��������� ������ �� ����
	luQryParDateEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplDateEnabled])
	***
	IF !ISNULL(luQryParDateEnabled) AND TYPE([luQryParDateEnabled])==[L] AND luQryParDateEnabled
		
		*26.05.2004 21:33 ->������� ���� ��������� � ��������
		luQryParDateStartDate = oQryParMgr.ParamGet(tcQryParSID,[qpdDateStart])
		luQryParDateEndDate = oQryParMgr.ParamGet(tcQryParSID,[qpdDateEnd])
		*------------------------------------------------------------------------------

		*21.04.2006 10:33 -> ��������� ������ ���� YMD � CENTURY ON
		SET DATE YMD
		SET CENTURY ON
		SET MARK TO "/"
		*------------------------------------------------------------------------------

		*26.05.2004 21:27 ->��������� �������
		DO CASE
			CASE	!ISNULL(luQryParDateStartDate) AND TYPE([luQryParDateStartDate])==[D] AND !EMPTY(luQryParDateStartDate) AND ;
					!ISNULL(luQryParDateEndDate) AND TYPE([luQryParDateEndDate])==[D] AND !EMPTY(luQryParDateEndDate)
					*{
					lcFilterExpr = lcFilterExpr + [ AND SalesLog.StampOpenDay >= ']+STRTRAN(DTOC(luQryParDateStartDate),[/],[])+[' AND SalesLog.StampOpenDay < ']+STRTRAN(DTOC(luQryParDateEndDate+1),[/],[])+[']
					*}
			CASE	!ISNULL(luQryParDateStartDate) AND TYPE([luQryParDateStartDate])==[D] AND !EMPTY(luQryParDateStartDate)
					*{
					lcFilterExpr = lcFilterExpr + [ AND SalesLog.StampOpenDay >= ']+STRTRAN(DTOC(luQryParDateStartDate),[/],[])+[']
					*}
			CASE	!ISNULL(luQryParDateEndDate) AND TYPE([luQryParDateEndDate])==[D] AND !EMPTY(luQryParDateEndDate)
					*{
					lcFilterExpr = lcFilterExpr + [ AND SalesLog.StampOpenDay < ']+STRTRAN(DTOC(luQryParDateEndDate+1),[/],[])+[']
					*}
		ENDCASE
		*------------------------------------------------------------------------------	

		*21.04.2006 10:33 -> ����������� ������ ������ ����
		SET DATE (lcOldDate)
		SET CENTURY &lcOldCentury
		SET MARK TO lcOldMark
		*------------------------------------------------------------------------------

	ENDIF
	*------------------------------------------------------------------------------

ENDIF
*------------------------------------------------------------------------------

*15.07.2005 12:41 -> ������� ���������
WAIT WINDOW [���� ������������ ��������� ���������...] NOWAIT NOCLEAR
SET MESSAGE TO [���� ������������ ��������� ���������...]
*------------------------------------------------------------------------------�

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ��������� ������
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE spNaklOutMake ?lcFilterExpr, ?lnStoragePlaceBing],[curRecCount])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
***
lnRecordCount = curRecCount.RecordCount
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> ������� ������
USE IN SELECT([curRecCount])
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*15.07.2005 12:42 ->������ ���������
WAIT CLEAR
SET MESSAGE TO []
*------------------------------------------------------------------------------

*11.07.2005 15:55 ->����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*12.07.2005 11:44 -> ������ ���������
RETURN lnRecordCount
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
