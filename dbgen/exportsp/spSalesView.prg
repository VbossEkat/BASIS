*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spSalesView()
* Called by.......: <NA>
* Parameters......: <tcQryParSID>
* Returns.........: <lcUniqueFileNM>
* Notes...........: �������� ������ �� ID
*------------------------------------------------------------------------------
PROCEDURE spSalesView
LPARAMETERS tcQryParSID

*29.03.2006 15:38 ->���������� � ������������� ����������
LOCAL	lcOldDate, ;
		lcOldCentury, ;
		lcOldMark, ;
		lcOldAlias, ;
		lcUniqueName, ;
		lcUniqueFilePath, ;
		lcFilterExpr, ;
		luQryParDateEnabled, ;
		luQryParDateStartDate, ;
		luQryParDateEndDate, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcOldDate = SET([DATE])
lcOldCentury = SET([CENTURY])
lcOldMark = SET([MARK])
lcOldAlias = ALIAS()
lcFilterExpr   = []
lcUniqueName = [_sl]+SYS(2015)
lcUniqueFilePath = [tmp\] + lcUniqueName + [.DBF]
*------------------------------------------------------------------------------

*30.03.2006 10:08 ->�������������� ������������
WAIT WINDOW [�����. ���� �������� ������....] NOWAIT NOCLEAR
SET MESSAGE TO [�����. ���� �������� ������....]
*------------------------------------------------------------------------------

*30.03.2006 09:56 ->���������� ��������� ������������, ���� ���������� �������� ����������
IF TYPE([oQryParMgr])==[O] AND !ISNULL(oQryParMgr)
	
	*30.03.2006 09:56 ->��������� ������ �� ����
	luQryParDateEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplDateEnabled])
	***
	IF !ISNULL(luQryParDateEnabled) AND TYPE([luQryParDateEnabled])==[L] AND luQryParDateEnabled
		
		*30.03.2006 09:56 ->������� ���� ��������� � ��������
		luQryParDateStartDate = oQryParMgr.ParamGet(tcQryParSID,[qpdDateStart])
		luQryParDateEndDate = oQryParMgr.ParamGet(tcQryParSID,[qpdDateEnd])
		*------------------------------------------------------------------------------
		
		*21.04.2006 10:33 -> ��������� ������ ���� YMD � CENTURY ON
		SET DATE YMD
		***
		SET CENTURY ON
		***
		SET MARK TO "/"
		*------------------------------------------------------------------------------

		*30.03.2006 09:56 ->��������� �������
		DO CASE
			CASE	!ISNULL(luQryParDateStartDate) AND TYPE([luQryParDateStartDate])==[D] AND !EMPTY(luQryParDateStartDate) AND ;
					!ISNULL(luQryParDateEndDate) AND TYPE([luQryParDateEndDate])==[D] AND !EMPTY(luQryParDateEndDate)
					*{
					lcFilterExpr = lcFilterExpr + [ AND SalesLog.Stamp >= ']+STRTRAN(DTOC(luQryParDateStartDate),[/],[])+[' AND SalesLog.Stamp < ']+STRTRAN(DTOC(luQryParDateEndDate+1),[/],[])+[']
					*}
			CASE	!ISNULL(luQryParDateStartDate) AND TYPE([luQryParDateStartDate])==[D] AND !EMPTY(luQryParDateStartDate)
					*{
					lcFilterExpr = lcFilterExpr + [ AND SalesLog.Stamp >= ']+STRTRAN(DTOC(luQryParDateStartDate),[/],[])+[']
					*}
			CASE	!ISNULL(luQryParDateEndDate) AND TYPE([luQryParDateEndDate])==[D] AND !EMPTY(luQryParDateEndDate)
					*{
					lcFilterExpr = lcFilterExpr + [ AND SalesLog.Stamp < ']+STRTRAN(DTOC(luQryParDateEndDate+1),[/],[])+[']
					*}
		ENDCASE
		*------------------------------------------------------------------------------	

		*21.04.2006 10:33 -> ����������� ������ ������ ����
		SET DATE (lcOldDate)
		***
		SET CENTURY &lcOldCentury
		***
		SET MARK TO lcOldMark
		*------------------------------------------------------------------------------

	ELSE
		lcFilterExpr = IIF(tcQryParSID==[NONE],[ AND 0=1 ],[])
	ENDIF
	*------------------------------------------------------------------------------

ENDIF
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
		[EXECUTE spSalesView ?lcFilterExpr],lcUniqueName)
ENDDO
***
IF lnSqlExeResult = -1

	*11.08.2006 17:08 ->�������� ���������� ������
	spHandleODBCError()
	*------------------------------------------------------------------------------
	
	*11.08.2006 17:09 ->������� ������ ������
	CREATE CURSOR (lcUniqueName) ( ;
		SalesLogID I, EOD I, SaleDate T, SaleSum I, DiscSum I, SaleSumWD I ;
	)
	*------------------------------------------------------------------------------

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

*30.03.2006 10:08 ->������ ���������
WAIT CLEAR
SET MESSAGE TO []
*------------------------------------------------------------------------------

*06.03.2006 16:30 ->����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
   SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*21.04.2004 14:27 -> ������ ��������
RETURN lcUniqueName
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
