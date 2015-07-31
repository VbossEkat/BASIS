*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spRSTCancelRep()
* Called by.......: <When Document Printed>
* Parameters......: <tcQryParSID>
* Returns.........: <������ ��������� ������, ��������� ��� ������>
* Author..........: Volga
* LastEditDate....: 31 August 2006
* Notes...........: ������� ��� ������ ������ �� �������.
*-------------------------------------------------------
PROCEDURE spRSTCancelRep
LPARAMETERS tcQryParSID

*09.11.2006 17:50 ->���������� � ������������� ����������
LOCAL	lcFilterExpr, ;
		lcOldDate, ;
		lcOldCentury, ;
		lcOldMark, ;
		luQryParDateEnabled, ;
		luQryParDateStartDate, ;
		luQryParDateEndDate, ;
		luQryParTvrEnabled, ;
		luQryParTvrIDTableNM, ;
		luQryParOUEnabled, ;
		luQryParOUIDTableNM, ;
		lnConnectHandle , ;
		lnSqlExeResult 
***
lcFilterExpr       = []

lcOldDate		   = SET([DATE])
lcOldCentury	   = SET([CENTURY])
lcOldMark		   = SET([MARK])
*------------------------------------------------------------------------------

*09.11.2006 18:00 ->������� ������� � ���������� ��� ������
CREATE TABLE tmp\RptEnv FREE (QryParSID C(10))
INSERT INTO RptEnv (QryParSID) VALUES (tcQryParSID)
*------------------------------------------------------------------------------

*******************************************************************************
*��������� ��������� ��� ������ ����������, ��������������� ���� ��������
*******************************************************************************

*--���������� ��������� ������������, ���� ���������� �������� ����������
IF TYPE([oQryParMgr])==[O] AND !ISNULL(oQryParMgr)
	
	*--��������� ������ �� ����
	luQryParDateEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplDateEnabled])
	***
	IF !ISNULL(luQryParDateEnabled) AND TYPE([luQryParDateEnabled])==[L] AND luQryParDateEnabled
		
		*--������� ���� ��������� � ��������
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
					lcFilterExpr = lcFilterExpr + [ AND Form.FrmDate >= ']+STRTRAN(DTOC(luQryParDateStartDate),[/],[])+[' AND Form.FrmDate < ']+STRTRAN(DTOC(luQryParDateEndDate+1),[/],[])+[']
					*}
			CASE	!ISNULL(luQryParDateStartDate) AND TYPE([luQryParDateStartDate])==[D] AND !EMPTY(luQryParDateStartDate)
					*{
					lcFilterExpr = lcFilterExpr + [ AND Form.FrmDate >= ']+STRTRAN(DTOC(luQryParDateStartDate),[/],[])+[']
					*}
			CASE	!ISNULL(luQryParDateEndDate) AND TYPE([luQryParDateEndDate])==[D] AND !EMPTY(luQryParDateEndDate)
					*{
					lcFilterExpr = lcFilterExpr + [ AND Form.FrmDate < ']+STRTRAN(DTOC(luQryParDateEndDate+1),[/],[])+[']
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

	*14.06.2006 15:47 ->��������� ������ (����� ������ (�����))
	luQryParTvrEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplTvrEnabled])
	***
	IF !ISNULL(luQryParTvrEnabled) AND TYPE([luQryParTvrEnabled])==[L] AND luQryParTvrEnabled
				
		*14.06.2006 15:47 ->������� ��� ��������� ������� � ���������������� ������� (����)
		luQryParTvrIDTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcTvrIDTableNM])
		***
		IF !ISNULL(luQryParTvrIDTableNM) AND TYPE([luQryParTvrIDTableNM])==[C] AND FILE([tmp\]+luQryParTvrIDTableNM+[.dbf])

			*10.04.2006 11:35 -> ���������� ������
			lcFilterExpr = lcFilterExpr + ;
							[ AND Tovar.TvrID IN (] + spGetTmpValueList(luQryParTvrIDTableNM) + [)]
			*------------------------------------------------------------------------------

		ENDIF
		*------------------------------------------------------------------------------		
				
	ENDIF
	*------------------------------------------------------------------------------

	*09.11.2006 17:28 ->��������� ������� ������ �� �������������
	luQryParOUEnabled   = oQryParMgr.ParamGet(tcQryParSID,[qplParOUEmiEnabled])
	luQryParOUIDTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcParOUEmiIDTableNM])
	***
	IF !ISNULL(luQryParOUEnabled)   AND TYPE([luQryParOUEnabled])==[L]   AND luQryParOUEnabled AND ;
	   !ISNULL(luQryParOUIDTableNM) AND TYPE([luQryParOUIDTableNM])==[C]

	   	*09.11.2006 17:28 ->���������� ������� ������
	   	lcValueList = spGetTmpValueList(luQryParOUIDTableNM)
	   	***
		lcFilterExpr = lcFilterExpr + [ AND (OrgUnit.OUParID IN (] + lcValueList + [))]
		*------------------------------------------------------------------------------

	ENDIF
	*------------------------------------------------------------------------------

ENDIF
*------------------------------------------------------------------------------

*09.11.2006 17:31 ->����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*09.11.2006 17:31 ->��������� �������� BatchMode � False, ����� �������� �������������� ������� � ������� �� ������� �������� SQLMoreResults
SQLSETPROP(lnConnectHandle,[BatchMode],.F.)
*------------------------------------------------------------------------------

*09.11.2006 17:31 ->��������� ������
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE spRSTCancelRep ?lcFilterExpr],[tmpRptItog])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

SQLMORERESULTS(lnConnectHandle)

*09.11.2006 17:31 ->������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

SELECT tmpRptItog
COPY TO tmp\RptItog.dbf
***
USE IN SELECT([tmpRptItog])
*------------------------------------------------------------------------------


*--������ ������ ������ ��������� ��� ������
RETURN [RptItog.dbf]
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
