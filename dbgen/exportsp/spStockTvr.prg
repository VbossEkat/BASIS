*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spStockTvr()
* Called by.......: <NA>
* Parameters......: <tnFrmID>
* Returns.........: <lcUniqueNM>
* Notes...........: ������� ��� ������ �� ��������
*-------------------------------------------------------
PROCEDURE spStockTvr
LPARAMETERS tcQryParSID

*27.09.2005 09:28 ->���������� � ������������� ����������
LOCAL	lcOldAlias, ;
		lcFilterExpr, ;
		lcUniqueName, ;
		lcUniqueFilePath, ;
		luQryParTvrID, ;
		luQryParOUIspEnabled, ;
		luQryParOUIspIDTableNM, ;
		luQryParCltEmiEnabled, ;
		luQryParCltEmiTableNM, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcOldAlias = ALIAS()
lcFilterExpr = []
*------------------------------------------------------------------------------

*29.09.2005 17:36 ->��������� ���������� ��� ��� ������� � ����������� �������
lcUniqueName = SYS(2015)
lcUniqueFilePath = [tmp\] + lcUniqueName + [.DBF]
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
		lcFilterExpr = lcFilterExpr + [ AND Stock.StockTvrID = ] + ALLTRIM(STR(luQryParTvrID))
		*------------------------------------------------------------------------------

	ENDIF
	*------------------------------------------------------------------------------

	*28.05.2004 03:01 ->��������� ������ (����� ������ (ISP))
	luQryParOUIspEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplOUIspEnabled])
	***
	IF !ISNULL(luQryParOUIspEnabled) AND TYPE([luQryParOUIspEnabled])==[L] AND luQryParOUIspEnabled

		*28.05.2004 00:37 ->������� ��� ������� � ���������������� �������������
		luQryParOUIspIDTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcOUIspIDTableNM])
		***
		IF !ISNULL(luQryParOUIspIDTableNM) AND TYPE([luQryParOUIspIDTableNM])==[C] AND FILE([tmp\]+luQryParOUIspIDTableNM+[.dbf])
			lcFilterExpr = lcFilterExpr + ;
							[ AND Stock.StockOUID IN (]+spGetTmpValueList(luQryParOUIspIDTableNM)+[)]
		ENDIF
		*------------------------------------------------------------------------------

	ENDIF
	*------------------------------------------------------------------------------

	*22.09.2005 17:41 ->��������� ������� ������ �� ����������
	luQryParCltEmiEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplCltEmiEnabled])
	luQryParCltEmiTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcCltEmiIDTableNM])
	***
	IF !ISNULL(luQryParCltEmiEnabled) AND TYPE([luQryParCltEmiEnabled])==[L] AND luQryParCltEmiEnabled AND ;
	   !ISNULL(luQryParCltEmiTableNM) AND TYPE([luQryParCltEmiTableNM])==[C]
		lcFilterExpr = lcFilterExpr + [ AND Form.PointEmiCltID IN (]+spGetTmpValueList(luQryParCltEmiTableNM)+[)]
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
		[EXECUTE spStockTvr ?lcFilterExpr],lcUniqueName)
ENDDO
***
IF lnSqlExeResult = -1

	*11.08.2006 15:37 ->������� ���������� ������
	spHandleODBCError()
	*------------------------------------------------------------------------------
	
	*11.08.2006 15:30 ->�������� ������ ������
	CREATE CURSOR (lcUniqueName) ( ;
		DateIn D, OUNM C(1), TvrBuy I, TvrSale I, TvrQnt I, CltNM C(1) ;
	)
	*------------------------------------------------------------------------------


ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> �������� ������� �� ���� � �������
SELECT (lcUniqueName)
***
COPY TO (lcUniqueFilePath)
***
USE IN SELECT(lcUniqueName)
*------------------------------------------------------------------------------

*28.09.2005 12:54 ->����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*19.09.2005 11:21 -> ������ ��������
RETURN lcUniqueName
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
