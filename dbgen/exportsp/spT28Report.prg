*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spT28Report()
* Called by.......: <When Document Printed>
* Parameters......: <tcQryParSID>
* Returns.........: <������ ��������� ������, ��������� ��� ������>
* Notes...........: ������� ��� �������� �������������-������������ �����
*-------------------------------------------------------
PROCEDURE spT28Report
LPARAMETERS tcQryParSID

*15.09.2005 15:20 ->���������� � ������������� ����������
LOCAL	lcOldDate, ;
		lcOldCentury, ;
		lcOldMark, ;
		lcFilterExpr, ;
		lcTvrFilterExpr, ;
		lcBalanceFilterExpr, ;
		luQryParTvrID, ;
		luQryParDateEnabled, ;
		luQryParDateStartDate, ;
		luQryParDateEndDate, ;
		luQryParOUEnabled, ;
		luQryParOUIDTableNM, ;
		luQryParFrmTypeEnabled, ;
		luQryParCltIspEnabled, ;
		luQryParCltIspTableNM, ;
		luQryParCltEmiEnabled, ;
		luQryParCltEmiTableNM, ;
		llCltFilterRequrest, ;
		llPvdFilterRequrest, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcOldDate = SET([DATE])
lcOldCentury = SET([CENTURY])
lcOldMark = SET([MARK])
lcFilterExpr = []
lcTvrFilterExpr = [0=1]
lcBalanceFilterExpr = [0=1]
*------------------------------------------------------------------------------

*******************************************************************************
* 1. �������� ������������� ������ ���������� ��� ������������� � ������
*******************************************************************************

*02.06.2005 15:47 ->������� ������� � ���������� ��� ������
CREATE TABLE tmp\RptEnv FREE (QryParSID C(10))
INSERT INTO RptEnv (QryParSID) VALUES (tcQryParSID)
*------------------------------------------------------------------------------

*19.09.2005 15:33 ->��������, ���������� ������� ������� ��� ������
IF TYPE([tcQryParSID])=[C] AND tcQryParSID=[NODATA]
	lcFilterExpr = [ AND 0=1]
ELSE

	*20.09.2005 17:08 ->���������� ������� ������ �� ���� ������
	luQryParTvrID = oQryParMgr.ParamGet(tcQryParSID,[qpnTvrID])
	***
	IF !ISNULL(luQryParTvrID) AND TYPE([luQryParTvrID])=[N]

		*20.09.2005 17:10 ->���������� ������� ������
		lcFilterExpr = lcFilterExpr + [ AND StockTrans.StockTransTvrID = ] + ALLTRIM(STR(luQryParTvrID))
		lcTvrFilterExpr = [Tovar.TvrID = ] + ALLTRIM(STR(luQryParTvrID))
		*------------------------------------------------------------------------------

	ENDIF
	*------------------------------------------------------------------------------

	*21.04.2006 10:33 -> ��������� ������ ���� YMD � CENTURY ON
	SET DATE YMD
	***
	SET CENTURY ON
	***
	SET MARK TO "/"
	*------------------------------------------------------------------------------

	*19.09.2005 17:07 ->���������� ������� ������ �� ����
	luQryParDateEnabled   = oQryParMgr.ParamGet(tcQryParSID,[qplDateEnabled])
	luQryParDateStartDate = oQryParMgr.ParamGet(tcQryParSID,[qpdDateStart])
	luQryParDateEndDate   = oQryParMgr.ParamGet(tcQryParSID,[qpdDateEnd])
	****
	IF !ISNULL(luQryParDateEnabled)   AND TYPE([luQryParDateEnabled])==[L]   AND luQryParDateEnabled AND ;
	   !ISNULL(luQryParDateStartDate) AND TYPE([luQryParDateStartDate])==[D] AND !EMPTY(luQryParDateStartDate) AND ;
	   !ISNULL(luQryParDateEndDate)   AND TYPE([luQryParDateEndDate])==[D]   AND !EMPTY(luQryParDateEndDate)

		*19.09.2005 17:09 ->���������� ������� ������
		lcFilterExpr = lcFilterExpr + [ AND Form.FrmDateAcc >= ']+STRTRAN(DTOC(luQryParDateStartDate),[/],[])+[' AND Form.FrmDateAcc <= ']+STRTRAN(DTOC(luQryParDateEndDate),[/],[])+[']
		*------------------------------------------------------------------------------

	ENDIF
	*------------------------------------------------------------------------------

	*19.09.2005 17:07 ->���������� ������� ������ �� ������ � �� ����
		IF	!ISNULL(luQryParTvrID) AND TYPE([luQryParTvrID])=[N] AND ;
		!ISNULL(luQryParDateEnabled)   AND TYPE([luQryParDateEnabled])==[L]   AND luQryParDateEnabled AND ;
		!ISNULL(luQryParDateStartDate) AND TYPE([luQryParDateStartDate])==[D] AND !EMPTY(luQryParDateStartDate)
	   	***
		lcBalanceFilterExpr = STRTRAN(lcBalanceFilterExpr,[0=1],[0<>1]) + [ AND ] + ;
								[StockTrans.StockTransTvrID = ] + ALLTRIM(STR(luQryParTvrID)) + [ AND ] + ;
								[StockTrans.StockTransDate < ']   + STRTRAN(DTOC(luQryParDateStartDate),[/],[]) + [']
	ENDIF
	*------------------------------------------------------------------------------

	*21.04.2006 10:33 -> ����������� ������ ������ ����
	SET DATE (lcOldDate)
	***
	SET CENTURY &lcOldCentury
	***
	SET MARK TO lcOldMark
	*------------------------------------------------------------------------------

	*20.09.2005 09:50 ->��������� ������� ������ �� �������������
	luQryParOUEnabled   = oQryParMgr.ParamGet(tcQryParSID,[qplOUEnabled])
	luQryParOUIDTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcOUIDTableNM])
	***
	IF !ISNULL(luQryParOUEnabled)   AND TYPE([luQryParOUEnabled])==[L]   AND luQryParOUEnabled AND ;
	   !ISNULL(luQryParOUIDTableNM) AND TYPE([luQryParOUIDTableNM])==[C]
	   
	   	*08.07.2005 14:38 ->���������� ������� ������
		lcFilterExpr = lcFilterExpr + [ AND StockTrans.StockTransOUID IN (] + spGetTmpValueList(luQryParOUIDTableNM) + [)]
		lcBalanceFilterExpr = lcBalanceFilterExpr + [ AND StockTrans.StockTransOUID IN (] + spGetTmpValueList(luQryParOUIDTableNM) + [)]
		*------------------------------------------------------------------------------

	ENDIF
	*------------------------------------------------------------------------------

	*27.05.2004 00:29 ->���������� ������������� ������������ ������� ������ ����������
	luQryParCltIspEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplCltIspEnabled])
	luQryParCltIspTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcCltIspIDTableNM])
	***
	IF !ISNULL(luQryParCltIspEnabled) AND TYPE([luQryParCltIspEnabled])==[L] AND luQryParCltIspEnabled AND ;
	   !ISNULL(luQryParCltIspTableNM) AND TYPE([luQryParCltIspTableNM])==[C]
		llCltFilterRequrest = .T.
	ENDIF
	*------------------------------------------------------------------------------

	*27.05.2004 00:29 ->���������� ������������� ������������ ������� ������ ����������
	luQryParCltEmiEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplCltEmiEnabled])
	luQryParCltEmiTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcCltEmiIDTableNM])
	***
	IF !ISNULL(luQryParCltEmiEnabled) AND TYPE([luQryParCltEmiEnabled])==[L] AND luQryParCltEmiEnabled AND ;
	   !ISNULL(luQryParCltEmiTableNM) AND TYPE([luQryParCltEmiTableNM])==[C]
		llPvdFilterRequrest = .T.
	ENDIF
	*------------------------------------------------------------------------------

	*22.09.2005 17:41 ->��������� ������� ������ �� ���������� � ����������
	IF llCltFilterRequrest AND llPvdFilterRequrest
		lcFilterExpr = lcFilterExpr + [ AND (] + ;
							[Form.PointIspCltID IN (]+spGetTmpValueList(luQryParCltIspTableNM)+[) OR ] + ;
							[Form.PointEmiCltID IN (]+spGetTmpValueList(luQryParCltEmiTableNM)+[))]
	ELSE
		IF llCltFilterRequrest
			lcFilterExpr = lcFilterExpr + [ AND Form.PointIspCltID IN (]+spGetTmpValueList(luQryParCltIspTableNM)+[)]
		ENDIF
		***
		IF llPvdFilterRequrest
			lcFilterExpr = lcFilterExpr + [ AND Form.PointEmiCltID IN (]+spGetTmpValueList(luQryParCltEmiTableNM)+[)]
		ENDIF
	ENDIF
	*------------------------------------------------------------------------------

		
	*15.09.2005 15:18 ->��������� ������� ������ �� ���� ���������
	luQryParFrmTypeEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplFrmTypeEnabled])
	lcQryParFrmTypeIDTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcFrmTypeIDTableNM])
	***
	IF !ISNULL(luQryParFrmTypeEnabled)   AND TYPE([luQryParFrmTypeEnabled])==[L] AND luQryParFrmTypeEnabled AND ;
	   !ISNULL(lcQryParFrmTypeIDTableNM) AND TYPE([lcQryParFrmTypeIDTableNM])==[C]

	   	*19.09.2005 17:09 ->���������� ������� ������
		lcFilterExpr = lcFilterExpr + [ AND Form.FrmTypeID IN (]+spGetTmpValueList(lcQryParFrmTypeIDTableNM)+[)]
		*------------------------------------------------------------------------------

	ENDIF
	*------------------------------------------------------------------------------

ENDIF
*------------------------------------------------------------------------------

SET STEP ON 

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*13.04.2006 14:01 -> ��������� �������� BatchMode � False, ����� �������� �������������� ������� � ������� �� ������� �������� SQLMoreResults
SQLSETPROP(lnConnectHandle,[BatchMode],.F.)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ��������� ������
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE spT28Report ?lcFilterExpr, ?lcTvrFilterExpr, ?lcBalanceFilterExpr],[RptItogDT])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*13.04.2006 14:03 -> �������� ��������� �������������� �������
SQLMORERESULTS(lnConnectHandle,[RptTvrInfo])
SQLMORERESULTS(lnConnectHandle,[RptStockInfo])
SQLMORERESULTS(lnConnectHandle)
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> �������� ������� �� ���� � �������
SELECT RptItogDT
COPY TO tmp\RptItogDT.dbf
***
SELECT RptTvrInfo
COPY TO tmp\RptTvrInfo.dbf
***
SELECT RptStockInfo
COPY TO tmp\RptStockInfo.dbf
***
USE IN SELECT([RptItogDT])
USE IN SELECT([RptTvrInfo])
USE IN SELECT([RptStockInfo])
*------------------------------------------------------------------------------

*19.09.2005 11:25 -> ������� ������
USE IN SELECT([RptEnv])
*------------------------------------------------------------------------------

*19.09.2005 11:21 ->������ ������ ��������� ������ ��� ���������� ������
RETURN [RptItogDT.dbf;RptStockInfo.dbf;RptTvrInfo.dbf;RptEnv.dbf]
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
