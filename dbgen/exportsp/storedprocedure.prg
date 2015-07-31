#DEFINE	pcvCONNECTIONNAME	[SQLBASISCONNECTION]
#DEFINE	pcvLOCKTIMEOUT		[10000]
#DEFINE	pcvERRORHEADMSG		"[Microsoft][ODBC SQL Server Driver][SQL Server]"

*02.08.2005 16:58 ->��������� ��� �������������� ������� (�������)
#DEFINE	NOT_CHILD_MARKED		0
#DEFINE	ALL_CHILD_MARKED		1
#DEFINE	PART_CHILD_MARKED		2
*------------------------------------------------------------------------------

*12.07.2005 14:39 ->��������� - ����������� �����
#DEFINE	__INTEGER	00000000000
#DEFINE __FLOAT		00000000000.000
*------------------------------------------------------------------------------

*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spGetLastIncrementedID()
* Called by.......: <After Adding Record With Increment Key>
* Parameters......: <lcEditDBObjName>
* Returns.........: <lnLastIncrementedID>
* Notes...........: ���������� ��������� ������������� ������ ��� LV/RV/Table
*					��������������� SPINCREMENTID()
*-------------------------------------------------------
PROCEDURE spGetLastIncrementedID
LPARAMETERS lcEditDBObjName

*01.04.2004 13:51 ->���������� � ������������� ����������
LOCAL	lcOldAlias, ;
		lnEditDBObjectType, ;
		lcSourceTable, ;
		lnSqlExeResult, ;
		lnLastIncrementedID
***
lcOldAlias = ALIAS()
*------------------------------------------------------------------------------

*01.04.2004 13:53 ->������ ��� ������� ��������������� ��� ����������
lnEditDBObjectType = CURSORGETPROP([SourceType],lcEditDBObjName)
*------------------------------------------------------------------------------

*01.04.2004 13:56 ->��������� ��������� ��������������� �������������
DO CASE
	CASE lnEditDBObjectType	= 1	&& Local SQL View
		lcSourceTable = CURSORGETPROP([Tables],lcEditDBObjName)
		IF ([,]$lcSourceTable)
			lcSourceTable = LEFT(lcSourceTable,AT([,],lcSourceTable)-1)
		ENDIF
		IF ([!]$lcSourceTable)
			lcSourceTable = SUBSTR(lcSourceTable,AT([!],lcSourceTable)+1)
		ENDIF
		***
		IF !USED([LastIncrID])	
			IF FILE([LastIncrID.dbf])
				USE LastIncrID IN 0
			ELSE
				RETURN 0
			ENDIF	
		ENDIF
		***
		SELECT LastIncrID
		LOCATE ALL FOR UPPER(ALLTRIM(LastIncrID.TableNM))==UPPER(ALLTRIM(lcSourceTable))
		***
		IF FOUND()
			lnLastIncrementedID = LastIncrID.LastId
		ELSE
			lnLastIncrementedID = 0
		ENDIF
		***
		USE IN LastIncrID
	*------------------------------------------------------------------------------	
			
	CASE lnEditDBObjectType = 2 && Remote SQL View
		lcSourceTable = CURSORGETPROP([Tables],lcEditDBObjName)
		IF ([,]$lcSourceTable)
			lcSourceTable = LEFT(lcSourceTable,AT([,],lcSourceTable)-1)
		ENDIF
		IF ([!]$lcSourceTable)
			lcSourceTable = SUBSTR(lcSourceTable,AT([!],lcSourceTable)+1)
		ENDIF
		***
		lnConnHandler = CURSORGETPROP([ConnectHandle],lcEditDBObjName)
		lnSqlExeResult = 0
		DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
			lnSqlExeResult = SQLEXEC(lnConnHandler, ;
				[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
				[EXECUTE spGetLastIncrementedID ?lcSourceTable],[tmp])
		ENDDO
		***
		IF lnSqlExeResult = -1
			spHandleODBCError()
			RETURN 0
		ENDIF
		lnLastIncrementedID = tmp.LastId
		USE IN tmp
	*------------------------------------------------------------------------------
	
	CASE lnEditDBObjectType	= 3	&& Table
		lcSourceTable = lcEditDBObjName
		IF ([!]$lcSourceTable)
			lcSourceTable = SUBSTR(lcSourceTable,AT([!],lcSourceTable)+1)
		ENDIF
		***
		IF !USED([LastIncrID])	
			IF FILE([LastIncrID.dbf])
				USE LastIncrID IN 0
			ELSE
				RETURN 0
			ENDIF	
		ENDIF
		***
		SELECT LastIncrID
		LOCATE ALL FOR UPPER(ALLTRIM(LastIncrID.TableNM))==UPPER(ALLTRIM(lcSourceTable))
		***
		IF FOUND()
			lnLastIncrementedID = LastIncrID.LastId
		ELSE
			lnLastIncrementedID = 0
		ENDIF
		***
		USE IN LastIncrID
	*------------------------------------------------------------------------------	

ENDCASE

*01.04.2004 14:37 ->����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*01.04.2004 14:37 ->������ ��������
RETURN lnLastIncrementedID
*------------------------------------------------------------------------------

ENDPROC
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: spGetTmpValueList()
* Called by.......: <N/A>
* Parameters......: <tcIDTableNM>
* Returns.........: <lcValueList>
* Notes...........: ��������� ������ �������� ��������������� �� ��������� �������
*------------------------------------------------------------------------------
PROCEDURE spGetTmpValueList
LPARAMETERS tcIDTableNM

*10.04.2006 11:42 -> ���������� � ������������� ����������
LOCAL	luValue, ;
		lcValueList
*------------------------------------------------------------------------------

*10.04.2006 11:30 -> ������� ��������� �������
IF !USED(tcIDTableNM)
	USE (tcIDTableNM) IN 0
ENDIF
*------------------------------------------------------------------------------

*10.04.2006 11:34 -> ���������� ������ �������� ���������������
SELECT (tcIDTableNM)
lcValueList = []
***
SCAN ALL
	luValue = EVALUATE(tcIDTableNM + [.ID])
	IF TYPE([luValue]) == [N] AND !ISNULL(luValue)
		lcValueList = lcValueList + ALLTRIM(STR(luValue)) + [,]
	ENDIF
ENDSCAN
***
lcValueList = LEFT(lcValueList,LEN(lcValueList)-1)
*------------------------------------------------------------------------------

*10.04.2006 11:35 -> ������� ��������� �������
USE IN SELECT(tcIDTableNM)
*------------------------------------------------------------------------------

*10.04.2006 11:45 -> ������ ���������
RETURN lcValueList
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: spPrimaryDocView()
* Called by.......: <Form Data Request>
* Parameters......: <tcExecVar[,tuParam1,tuParam2]>
*					<[NODATA]>
*					<[BYFRMID],tnScrFrmID,tnFrmID>
*					<[BYFILTER],tnScrFrmID,tcQryParSID>
* Returns.........: <lcUniqueFileName>
* Notes...........: ��������� ������ ��� ��������� ���������� ��� ���������� �����.
*------------------------------------------------------------------------------
PROCEDURE spPrimaryDocView
LPARAMETERS tcExecVar,tuParam1,tuParam2

*21.04.2004 12:31 -> ���������� � ������������� ����������
LOCAL	lcOldDate, ;
		lcOldCentury, ;
		lcOldMark, ;
		lcUniqueName, ;
		lcUniqueFilePath, ;
		lcFilterExpr, ;
		lcValueList, ;
		luQryParDateEnabled, ;
		luQryParDateStartDate, ;
		luQryParDateEndDate, ;
		luQryParCltEnabled, ;
		luQryParCltIDTableNM, ;
		luQryParOUEnabled, ;
		luQryParOUIDTableNM, ;
		luQryParFrmTypeEnabled, ;
		luQryParFrmTypeIDTableNM, ;
		luQryParFrmStatEnabled, ;
		luQryParFrmStatIDTableNM, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcOldDate = SET([DATE])
lcOldCentury = SET([CENTURY])
lcOldMark = SET([MARK])
lcUniqueName = [_d] + SYS(2015)
lcUniqueFilePath = [tmp\] + lcUniqueName + [.DBF]
*------------------------------------------------------------------------------

*21.04.2004 12:33 -> ��������� ������� � ����������� �� ���� �������
DO CASE

	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[NODATA]

		*21.04.2004 12:34 -> ��������� ������, ��� ������������ ������ �������
		lcFilterExpr = [WHERE 0=1]
		*------------------------------------------------------------------------------

	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[11QUEUE]

		*21.04.2004 12:34 -> ��������� ������, ��� ������������ ������ �������
		lcFilterExpr = [WHERE Form.FrmID IN (SELECT Frmpayqueue.frmid FROM frmpayqueue)]
		*------------------------------------------------------------------------------

	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[BYFRMID]

		*21.04.2004 12:32 -> ��������� ������ ��� ������ ������ ���������
		lcFilterExpr = [WHERE 0<>1] + ;
							[ AND ScrFrmViewObj.ScrFrmID = ] + ALLTRIM(STR(tuParam1)) + ;
							[ AND Form.FrmID = ]+ALLTRIM(STR(tuParam2))
		*------------------------------------------------------------------------------

	CASE TYPE([tcExecVar])==[C] AND (tcExecVar==[BYFILTER] OR tcExecVar==[QUEUE])

		*********************************************************************************
		*��������� ��������� ��� ������ ����������, ��������������� ���� ��������		*
		*********************************************************************************
		
		*26.05.2004 21:08 -> �������� �������, ��� ������ ���������� �� ��
		IF tcExecVar==[QUEUE]
		   lcFilterExpr = [WHERE Form.FrmID IN (SELECT Frmpayqueue.frmid FROM frmpayqueue) ] + ;
							[ AND ScrFrmViewObj.ScrFrmID = ] + ALLTRIM(STR(tuParam1))
		ELSE
		   lcFilterExpr = [WHERE 0<>1] + ;
							[ AND ScrFrmViewObj.ScrFrmID = ] + ALLTRIM(STR(tuParam1))
		ENDIF
		*------------------------------------------------------------------------------

		*26.05.2004 21:20 -> ���������� ��������� ������������, ���� ���������� �������� ����������
		IF TYPE([oQryParMgr])==[O] AND !ISNULL(oQryParMgr)

			*26.05.2004 21:18 -> ��������� ������ �� ����
			luQryParDateEnabled = oQryParMgr.ParamGet(tuParam2,[qplDateEnabled])
			***
			IF !ISNULL(luQryParDateEnabled) AND TYPE([luQryParDateEnabled])==[L] AND luQryParDateEnabled

				*26.05.2004 21:33 -> ������� ���� ��������� � ��������
				luQryParDateStartDate = oQryParMgr.ParamGet(tuParam2,[qpdDateStart])
				luQryParDateEndDate = oQryParMgr.ParamGet(tuParam2,[qpdDateEnd])
				*------------------------------------------------------------------------------

				*21.04.2006 10:33 -> ��������� ������ ���� YMD � CENTURY ON
				SET DATE YMD
				***
				SET CENTURY ON
				***
				SET MARK TO "/"
				*------------------------------------------------------------------------------

				*26.05.2004 21:27 -> ��������� �������
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
				***
				SET CENTURY &lcOldCentury
				***
				SET MARK TO lcOldMark
				*------------------------------------------------------------------------------

			ENDIF
			*------------------------------------------------------------------------------

			*27.05.2004 00:29 -> ��������� ������ (����� ������� (EMI))
			luQryParCltEnabled = oQryParMgr.ParamGet(tuParam2,[qplCltEmiEnabled])
			***
			IF !ISNULL(luQryParCltEnabled) AND TYPE([luQryParCltEnabled])==[L] AND luQryParCltEnabled
				
				*27.05.2004 00:32 -> ������� ��� ��������� ������� � ���������������� ��������
				luQryParCltIDTableNM = oQryParMgr.ParamGet(tuParam2,[qpcCltEmiIDTableNM])
				***
				IF !ISNULL(luQryParCltIDTableNM) AND TYPE([luQryParCltIDTableNM])==[C] AND FILE([tmp\]+luQryParCltIDTableNM+[.dbf])

					*10.04.2006 11:35 -> ���������� ������
					lcFilterExpr = lcFilterExpr + ;
									[ AND Form.PointEmiCltID IN (] + spGetTmpValueList(luQryParCltIDTableNM) + [)]
					*------------------------------------------------------------------------------

				ENDIF
				*------------------------------------------------------------------------------		

			ENDIF
			*------------------------------------------------------------------------------

			*23.04.2006 00:29 ->��������� ������ (����� �������)
			luQryParTvrEnabled = oQryParMgr.ParamGet(tuParam2,[qplTvrEnabled])
			***
			IF !ISNULL(luQryParTvrEnabled) AND TYPE([luQryParTvrEnabled])==[L] AND luQryParTvrEnabled
				
				*23.04.2006 00:32 ->������� ��� ��������� ������� � ���������������� ������� 
				luQryParTvrIDTableNM = oQryParMgr.ParamGet(tuParam2,[qpcTvrIDTableNM])
				***
				IF !ISNULL(luQryParTvrIDTableNM) AND TYPE([luQryParTvrIDTableNM])==[C] AND FILE([tmp\]+luQryParTvrIDTableNM+[.dbf])

					*10.04.2006 11:35 -> ���������� ������
					lcFilterExpr = lcFilterExpr + ;
									[ AND FrmPartTvr.TvrId IN (] + spGetTmpValueList(luQryParTvrIDTableNM) + [)]
					*------------------------------------------------------------------------------

				ENDIF
				*------------------------------------------------------------------------------		

			ENDIF
			*------------------------------------------------------------------------------

			*27.05.2004 00:29 ->��������� ������ (����� ������� (ISP))
			luQryParCltEnabled = oQryParMgr.ParamGet(tuParam2,[qplCltIspEnabled])
			***
			IF !ISNULL(luQryParCltEnabled) AND TYPE([luQryParCltEnabled])==[L] AND luQryParCltEnabled
				
				*27.05.2004 00:32 ->������� ��� ��������� ������� � ���������������� ��������
				luQryParCltIDTableNM = oQryParMgr.ParamGet(tuParam2,[qpcCltIspIDTableNM])
				***
				IF !ISNULL(luQryParCltIDTableNM) AND TYPE([luQryParCltIDTableNM])==[C] AND FILE([tmp\]+luQryParCltIDTableNM+[.dbf])

					*10.04.2006 11:35 -> ���������� ������
					lcFilterExpr = lcFilterExpr + ;
									[ AND Form.PointIspCltID IN (] + spGetTmpValueList(luQryParCltIDTableNM) + [)]
					*------------------------------------------------------------------------------

				ENDIF
				*------------------------------------------------------------------------------		
				
			ENDIF
			*------------------------------------------------------------------------------
			
			*27.05.2004 00:29 ->��������� ������ (����� ������� (EMI OR ISP))
			luQryParCltEnabled = oQryParMgr.ParamGet(tuParam2,[qplCltEnabled])
			***
			IF !ISNULL(luQryParCltEnabled) AND TYPE([luQryParCltEnabled])==[L] AND luQryParCltEnabled
				
				*27.05.2004 00:32 ->������� ��� ��������� ������� � ���������������� ��������
				luQryParCltIDTableNM = oQryParMgr.ParamGet(tuParam2,[qpcCltIDTableNM])
				***
				IF !ISNULL(luQryParCltIDTableNM) AND TYPE([luQryParCltIDTableNM])==[C] AND FILE([tmp\]+luQryParCltIDTableNM+[.dbf])

					*10.04.2006 11:35 -> ���������� ������
					lcValueList = spGetTmpValueList(luQryParCltIDTableNM)
					***
					lcFilterExpr = lcFilterExpr + ;
									[ AND (Form.PointEmiCltID IN (] + lcValueList + [)] + ;
									[ OR Form.PointIspCltID IN (] + lcValueList + [))]
					*------------------------------------------------------------------------------

				ENDIF
				*------------------------------------------------------------------------------		
				
			ENDIF
			*------------------------------------------------------------------------------

			*28.05.2004 03:01 ->��������� ������ (����� ������ (EMI))
			luQryParOUEnabled = oQryParMgr.ParamGet(tuParam2,[qplOUEmiEnabled])
			***
			IF !ISNULL(luQryParOUEnabled) AND TYPE([luQryParOUEnabled])==[L] AND luQryParOUEnabled

				*28.05.2004 00:37 ->������� ��� ������� � ���������������� �������������
				luQryParOUIDTableNM = oQryParMgr.ParamGet(tuParam2,[qpcOUEmiIDTableNM])
				***
				IF !ISNULL(luQryParOUIDTableNM) AND TYPE([luQryParOUIDTableNM])==[C] AND FILE([tmp\]+luQryParOUIDTableNM+[.dbf])

					*10.04.2006 11:35 -> ���������� ������
					lcFilterExpr = lcFilterExpr + ;
									[ AND Form.PointEmiOUID IN (] + spGetTmpValueList(luQryParOUIDTableNM) + [)]
					*------------------------------------------------------------------------------

				ENDIF
				*------------------------------------------------------------------------------
				
			ENDIF
			*------------------------------------------------------------------------------

			*28.05.2004 03:01 ->��������� ������ (����� ������ (ISP))
			luQryParOUEnabled = oQryParMgr.ParamGet(tuParam2,[qplOUIspEnabled])
			***
			IF !ISNULL(luQryParOUEnabled) AND TYPE([luQryParOUEnabled])==[L] AND luQryParOUEnabled

				*28.05.2004 00:37 ->������� ��� ������� � ���������������� �������������
				luQryParOUIDTableNM = oQryParMgr.ParamGet(tuParam2,[qpcOUIspIDTableNM])
				***
				IF !ISNULL(luQryParOUIDTableNM) AND TYPE([luQryParOUIDTableNM])==[C] AND FILE([tmp\]+luQryParOUIDTableNM+[.dbf])

					*10.04.2006 11:35 -> ���������� ������
					lcFilterExpr = lcFilterExpr + ;
									[ AND Form.PointIspOUID IN (] + spGetTmpValueList(luQryParOUIDTableNM) + [)]
					*------------------------------------------------------------------------------

				ENDIF
				*------------------------------------------------------------------------------
				
			ENDIF
			*------------------------------------------------------------------------------
			
			*28.05.2004 00:32 ->��������� ������ (����� ������ (EMI OR ISP))
			luQryParOUEnabled = oQryParMgr.ParamGet(tuParam2,[qplOUEnabled])
			***
			IF !ISNULL(luQryParOUEnabled) AND TYPE([luQryParOUEnabled])==[L] AND luQryParOUEnabled

				*28.05.2004 00:37 ->������� ��� ������� � ���������������� �������������
				luQryParOUIDTableNM = oQryParMgr.ParamGet(tuParam2,[qpcOUIDTableNM])
				***
				IF !ISNULL(luQryParOUIDTableNM) AND TYPE([luQryParOUIDTableNM])==[C] AND FILE([tmp\]+luQryParOUIDTableNM+[.dbf])

					*10.04.2006 11:35 -> ���������� ������
					lcValueList = spGetTmpValueList(luQryParOUIDTableNM)
					***
					lcFilterExpr = lcFilterExpr + ;
									[ AND (Form.PointEmiOUID IN (] + lcValueList + [)] + ;
									[ OR Form.PointIspOUID IN (] + lcValueList + [))]
					*------------------------------------------------------------------------------

				ENDIF
				*------------------------------------------------------------------------------
				
			ENDIF
			*------------------------------------------------------------------------------

			*19.01.2005 17:07 -> ��������� ������ (����� ���� ���������)
			luQryParFrmTypeEnabled = oQryParMgr.ParamGet(tuParam2,[qplFrmTypeEnabled])
			***
			IF !ISNULL(luQryParFrmTypeEnabled) AND TYPE([luQryParFrmTypeEnabled])==[L] AND luQryParFrmTypeEnabled

				*19.01.2005 17:08 -> ������� ��� ������� � ���������������� ����� ����������
				luQryParFrmTypeIDTableNM = oQryParMgr.ParamGet(tuParam2,[qpcFrmTypeIDTableNM])
				***
				IF !ISNULL(luQryParFrmTypeIDTableNM) AND TYPE([luQryParFrmTypeIDTableNM])==[C] AND FILE([tmp\]+luQryParFrmTypeIDTableNM+[.dbf])

					*10.04.2006 11:35 -> ���������� ������
					lcFilterExpr = lcFilterExpr + ;
									[ AND Form.FrmTypeID IN (] + spGetTmpValueList(luQryParFrmTypeIDTableNM) + [)]
					*------------------------------------------------------------------------------

				ENDIF
				*------------------------------------------------------------------------------
				
			ENDIF
			*------------------------------------------------------------------------------
			
			*22.02.2006 16:55 -> ��������� ������ (����� ������� ���������)
			luQryParFrmStatEnabled = oQryParMgr.ParamGet(tuParam2,[qplFrmStatEnabled])
			***
			IF !ISNULL(luQryParFrmStatEnabled) AND TYPE([luQryParFrmStatEnabled])==[L] AND luQryParFrmStatEnabled

				*22.02.2006 16:55 -> ������� ��� ������� � ���������������� �������� ����������
				luQryParFrmStatIDTableNM = oQryParMgr.ParamGet(tuParam2,[qpcFrmStatIDTableNM])
				***
				IF !ISNULL(luQryParFrmStatIDTableNM) AND TYPE([luQryParFrmStatIDTableNM])==[C] AND FILE([tmp\]+luQryParFrmStatIDTableNM+[.dbf])

					*10.04.2006 11:35 -> ���������� ������
					lcFilterExpr = lcFilterExpr + ;
									[ AND Form.FrmStatusID IN (] + spGetTmpValueList(luQryParFrmStatIDTableNM) + [)]
					*------------------------------------------------------------------------------

				ENDIF
				*------------------------------------------------------------------------------
				
			ENDIF
			*------------------------------------------------------------------------------

			*10.01.2006 17:07 -> ��������� ������ (����� ���� ���������)
			luQryParFrmTypeEnabled = oQryParMgr.ParamGet(tuParam2,[qplQueue])
			***
			IF !ISNULL(luQryParFrmTypeEnabled) AND TYPE([luQryParFrmTypeEnabled])==[L] AND luQryParFrmTypeEnabled

					lcFilterExpr = lcFilterExpr + ;
									[ AND Form.FrmID IN (SELECT Frmpayqueue.frmid FROM frmpayqueue)]
				
			ENDIF
			*------------------------------------------------------------------------------

		ENDIF
		*------------------------------------------------------------------------------

ENDCASE
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
		[EXECUTE spPrimaryDocView ?lcFilterExpr],lcUniqueName)
ENDDO
***
IF lnSqlExeResult = -1

	*11.08.2006 14:53 ->������� ��������� ��������� ������
	spHandleODBCError()
	*------------------------------------------------------------------------------

	*11.08.2006 15:19 ->�������� ������ ������ ��� ��������
	CREATE CURSOR (lcUniqueName) ( ;
		_mark L, FrmID I, FrmTypeID I, FrmDate T, FrmNum C(1), FrmNote C(1), StatusID I, ;
		FrmIsPayed L, FTShortNM C(1), PEmiNM C(1), PIspNM C(1), FrmSum I, FrmVatSum I, ;
		FrmSumSale I, FrmSumBuy I, FrmVatSale I, FrmVatBuy I, TvrNM C(1) ;
	)
	*------------------------------------------------------------------------------

ENDIF
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> �������� ������ � ���� � �������
SELECT (lcUniqueName)
***
COPY TO (lcUniqueFilePath)
***
USE IN SELECT(lcUniqueName)
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*21.04.2004 14:27 -> ������ ��������
RETURN lcUniqueName
*------------------------------------------------------------------------------

ENDPROC
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: spAccountingView()
* Called by.......: <Form Data Request>
* Parameters......: <tcExecVar[,tuParam1,tuParam2]>
*					<[NODATA]>
*					<[BYFRMID],tnScrFrmID,tnFrmID>
*					<[BYFILTER],tnScrFrmID,tcQryParSID>
* Returns.........: <lcUniqueFileName>
* Notes...........: ��������� ������ ��� ��������� ��������������� ����
*------------------------------------------------------------------------------
PROCEDURE spAccountingView
LPARAMETERS tcExecVar,tuParam1,tuParam2

*21.04.2004 12:31 -> ���������� � ������������� ����������
LOCAL	lcOldDate, ;
		lcOldCentury, ;
		lcOldMark, ;
		lcUniqueName, ;
		lcUniqueFilePath, ;
		lcFilterExpr, ;
		lcValueList, ;
		luQryParDateEnabled, ;
		luQryParDateStartDate, ;
		luQryParDateEndDate, ;
		luQryParCltEnabled, ;
		luQryParCltIDTableNM, ;
		luQryParOUEnabled, ;
		luQryParOUIDTableNM, ;
		luQryParFrmTypeEnabled, ;
		luQryParFrmTypeIDTableNM, ;
		luQryParFrmStatEnabled, ;
		luQryParFrmStatIDTableNM, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcOldDate = SET([DATE])
lcOldCentury = SET([CENTURY])
lcOldMark = SET([MARK])
lcUniqueName = [_d] + SYS(2015)
lcUniqueFilePath = [tmp\] + lcUniqueName + [.DBF]
*------------------------------------------------------------------------------

*21.04.2004 12:33 -> ��������� ������� � ����������� �� ���� �������
DO CASE

	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[NODATA]

		*21.04.2004 12:34 -> ��������� ������, ��� ������������ ������ �������
		lcFilterExpr = [WHERE 0=1]
		*------------------------------------------------------------------------------

	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[11QUEUE]

		*21.04.2004 12:34 -> ��������� ������, ��� ������������ ������ �������
		lcFilterExpr = [WHERE Form.FrmID IN (SELECT Frmpayqueue.frmid FROM frmpayqueue)]
		*------------------------------------------------------------------------------

	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[BYFRMID]

		*21.04.2004 12:32 -> ��������� ������ ��� ������ ������ ���������
		lcFilterExpr = [WHERE 0<>1] + ;
							[ AND ScrFrmViewObj.ScrFrmID = ] + ALLTRIM(STR(tuParam1)) + ;
							[ AND Form.FrmID = ]+ALLTRIM(STR(tuParam2))
		*------------------------------------------------------------------------------

	CASE TYPE([tcExecVar])==[C] AND (tcExecVar==[BYFILTER] OR tcExecVar==[QUEUE])

		*********************************************************************************
		*��������� ��������� ��� ������ ����������, ��������������� ���� ��������		*
		*********************************************************************************
		
		*26.05.2004 21:08 -> �������� �������, ��� ������ ���������� �� ��
		IF tcExecVar==[QUEUE]
		   lcFilterExpr = [WHERE Form.FrmID IN (SELECT Frmpayqueue.frmid FROM frmpayqueue) ] + ;
							[ AND ScrFrmViewObj.ScrFrmID = ] + ALLTRIM(STR(tuParam1))
		ELSE
		   lcFilterExpr = [WHERE 0<>1] + ;
							[ AND ScrFrmViewObj.ScrFrmID = ] + ALLTRIM(STR(tuParam1))
		ENDIF
		*------------------------------------------------------------------------------

		*26.05.2004 21:20 -> ���������� ��������� ������������, ���� ���������� �������� ����������
		IF TYPE([oQryParMgr])==[O] AND !ISNULL(oQryParMgr)

			*26.05.2004 21:18 -> ��������� ������ �� ����
			luQryParDateEnabled = oQryParMgr.ParamGet(tuParam2,[qplDateEnabled])
			***
			IF !ISNULL(luQryParDateEnabled) AND TYPE([luQryParDateEnabled])==[L] AND luQryParDateEnabled

				*26.05.2004 21:33 -> ������� ���� ��������� � ��������
				luQryParDateStartDate = oQryParMgr.ParamGet(tuParam2,[qpdDateStart])
				luQryParDateEndDate = oQryParMgr.ParamGet(tuParam2,[qpdDateEnd])
				*------------------------------------------------------------------------------

				*21.04.2006 10:33 -> ��������� ������ ���� YMD � CENTURY ON
				SET DATE YMD
				***
				SET CENTURY ON
				***
				SET MARK TO "/"
				*------------------------------------------------------------------------------

				*26.05.2004 21:27 -> ��������� �������
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
				***
				SET CENTURY &lcOldCentury
				***
				SET MARK TO lcOldMark
				*------------------------------------------------------------------------------

			ENDIF
			*------------------------------------------------------------------------------

			*27.05.2004 00:29 -> ��������� ������ (����� ������� (EMI))
			luQryParCltEnabled = oQryParMgr.ParamGet(tuParam2,[qplCltEmiEnabled])
			***
			IF !ISNULL(luQryParCltEnabled) AND TYPE([luQryParCltEnabled])==[L] AND luQryParCltEnabled
				
				*27.05.2004 00:32 -> ������� ��� ��������� ������� � ���������������� ��������
				luQryParCltIDTableNM = oQryParMgr.ParamGet(tuParam2,[qpcCltEmiIDTableNM])
				***
				IF !ISNULL(luQryParCltIDTableNM) AND TYPE([luQryParCltIDTableNM])==[C] AND FILE([tmp\]+luQryParCltIDTableNM+[.dbf])

					*10.04.2006 11:35 -> ���������� ������
					lcFilterExpr = lcFilterExpr + ;
									[ AND Form.PointEmiCltID IN (] + spGetTmpValueList(luQryParCltIDTableNM) + [)]
					*------------------------------------------------------------------------------

				ENDIF
				*------------------------------------------------------------------------------		

			ENDIF
			*------------------------------------------------------------------------------

			*23.04.2006 00:29 ->��������� ������ (����� �������)
			luQryParTvrEnabled = oQryParMgr.ParamGet(tuParam2,[qplTvrEnabled])
			***
			IF !ISNULL(luQryParTvrEnabled) AND TYPE([luQryParTvrEnabled])==[L] AND luQryParTvrEnabled
				
				*23.04.2006 00:32 ->������� ��� ��������� ������� � ���������������� ������� 
				luQryParTvrIDTableNM = oQryParMgr.ParamGet(tuParam2,[qpcTvrIDTableNM])
				***
				IF !ISNULL(luQryParTvrIDTableNM) AND TYPE([luQryParTvrIDTableNM])==[C] AND FILE([tmp\]+luQryParTvrIDTableNM+[.dbf])

					*10.04.2006 11:35 -> ���������� ������
					lcFilterExpr = lcFilterExpr + ;
									[ AND FrmPartTvr.TvrId IN (] + spGetTmpValueList(luQryParTvrIDTableNM) + [)]
					*------------------------------------------------------------------------------

				ENDIF
				*------------------------------------------------------------------------------		

			ENDIF
			*------------------------------------------------------------------------------

			*27.05.2004 00:29 ->��������� ������ (����� ������� (ISP))
			luQryParCltEnabled = oQryParMgr.ParamGet(tuParam2,[qplCltIspEnabled])
			***
			IF !ISNULL(luQryParCltEnabled) AND TYPE([luQryParCltEnabled])==[L] AND luQryParCltEnabled
				
				*27.05.2004 00:32 ->������� ��� ��������� ������� � ���������������� ��������
				luQryParCltIDTableNM = oQryParMgr.ParamGet(tuParam2,[qpcCltIspIDTableNM])
				***
				IF !ISNULL(luQryParCltIDTableNM) AND TYPE([luQryParCltIDTableNM])==[C] AND FILE([tmp\]+luQryParCltIDTableNM+[.dbf])

					*10.04.2006 11:35 -> ���������� ������
					lcFilterExpr = lcFilterExpr + ;
									[ AND Form.PointIspCltID IN (] + spGetTmpValueList(luQryParCltIDTableNM) + [)]
					*------------------------------------------------------------------------------

				ENDIF
				*------------------------------------------------------------------------------		
				
			ENDIF
			*------------------------------------------------------------------------------
			
			*27.05.2004 00:29 ->��������� ������ (����� ������� (EMI OR ISP))
			luQryParCltEnabled = oQryParMgr.ParamGet(tuParam2,[qplCltEnabled])
			***
			IF !ISNULL(luQryParCltEnabled) AND TYPE([luQryParCltEnabled])==[L] AND luQryParCltEnabled
				
				*27.05.2004 00:32 ->������� ��� ��������� ������� � ���������������� ��������
				luQryParCltIDTableNM = oQryParMgr.ParamGet(tuParam2,[qpcCltIDTableNM])
				***
				IF !ISNULL(luQryParCltIDTableNM) AND TYPE([luQryParCltIDTableNM])==[C] AND FILE([tmp\]+luQryParCltIDTableNM+[.dbf])

					*10.04.2006 11:35 -> ���������� ������
					lcValueList = spGetTmpValueList(luQryParCltIDTableNM)
					***
					lcFilterExpr = lcFilterExpr + ;
									[ AND (Form.PointEmiCltID IN (] + lcValueList + [)] + ;
									[ OR Form.PointIspCltID IN (] + lcValueList + [))]
					*------------------------------------------------------------------------------

				ENDIF
				*------------------------------------------------------------------------------		
				
			ENDIF
			*------------------------------------------------------------------------------

			*28.05.2004 03:01 ->��������� ������ (����� ������ (EMI))
			luQryParOUEnabled = oQryParMgr.ParamGet(tuParam2,[qplOUEmiEnabled])
			***
			IF !ISNULL(luQryParOUEnabled) AND TYPE([luQryParOUEnabled])==[L] AND luQryParOUEnabled

				*28.05.2004 00:37 ->������� ��� ������� � ���������������� �������������
				luQryParOUIDTableNM = oQryParMgr.ParamGet(tuParam2,[qpcOUEmiIDTableNM])
				***
				IF !ISNULL(luQryParOUIDTableNM) AND TYPE([luQryParOUIDTableNM])==[C] AND FILE([tmp\]+luQryParOUIDTableNM+[.dbf])

					*10.04.2006 11:35 -> ���������� ������
					lcFilterExpr = lcFilterExpr + ;
									[ AND Form.PointEmiOUID IN (] + spGetTmpValueList(luQryParOUIDTableNM) + [)]
					*------------------------------------------------------------------------------

				ENDIF
				*------------------------------------------------------------------------------
				
			ENDIF
			*------------------------------------------------------------------------------

			*28.05.2004 03:01 ->��������� ������ (����� ������ (ISP))
			luQryParOUEnabled = oQryParMgr.ParamGet(tuParam2,[qplOUIspEnabled])
			***
			IF !ISNULL(luQryParOUEnabled) AND TYPE([luQryParOUEnabled])==[L] AND luQryParOUEnabled

				*28.05.2004 00:37 ->������� ��� ������� � ���������������� �������������
				luQryParOUIDTableNM = oQryParMgr.ParamGet(tuParam2,[qpcOUIspIDTableNM])
				***
				IF !ISNULL(luQryParOUIDTableNM) AND TYPE([luQryParOUIDTableNM])==[C] AND FILE([tmp\]+luQryParOUIDTableNM+[.dbf])

					*10.04.2006 11:35 -> ���������� ������
					lcFilterExpr = lcFilterExpr + ;
									[ AND Form.PointIspOUID IN (] + spGetTmpValueList(luQryParOUIDTableNM) + [)]
					*------------------------------------------------------------------------------

				ENDIF
				*------------------------------------------------------------------------------
				
			ENDIF
			*------------------------------------------------------------------------------
			
			*28.05.2004 00:32 ->��������� ������ (����� ������ (EMI OR ISP))
			luQryParOUEnabled = oQryParMgr.ParamGet(tuParam2,[qplOUEnabled])
			***
			IF !ISNULL(luQryParOUEnabled) AND TYPE([luQryParOUEnabled])==[L] AND luQryParOUEnabled

				*28.05.2004 00:37 ->������� ��� ������� � ���������������� �������������
				luQryParOUIDTableNM = oQryParMgr.ParamGet(tuParam2,[qpcOUIDTableNM])
				***
				IF !ISNULL(luQryParOUIDTableNM) AND TYPE([luQryParOUIDTableNM])==[C] AND FILE([tmp\]+luQryParOUIDTableNM+[.dbf])

					*10.04.2006 11:35 -> ���������� ������
					lcValueList = spGetTmpValueList(luQryParOUIDTableNM)
					***
					lcFilterExpr = lcFilterExpr + ;
									[ AND (Form.PointEmiOUID IN (] + lcValueList + [)] + ;
									[ OR Form.PointIspOUID IN (] + lcValueList + [))]
					*------------------------------------------------------------------------------

				ENDIF
				*------------------------------------------------------------------------------
				
			ENDIF
			*------------------------------------------------------------------------------

			*19.01.2005 17:07 -> ��������� ������ (����� ���� ���������)
			luQryParFrmTypeEnabled = oQryParMgr.ParamGet(tuParam2,[qplFrmTypeEnabled])
			***
			IF !ISNULL(luQryParFrmTypeEnabled) AND TYPE([luQryParFrmTypeEnabled])==[L] AND luQryParFrmTypeEnabled

				*19.01.2005 17:08 -> ������� ��� ������� � ���������������� ����� ����������
				luQryParFrmTypeIDTableNM = oQryParMgr.ParamGet(tuParam2,[qpcFrmTypeIDTableNM])
				***
				IF !ISNULL(luQryParFrmTypeIDTableNM) AND TYPE([luQryParFrmTypeIDTableNM])==[C] AND FILE([tmp\]+luQryParFrmTypeIDTableNM+[.dbf])

					*10.04.2006 11:35 -> ���������� ������
					lcFilterExpr = lcFilterExpr + ;
									[ AND Form.FrmTypeID IN (] + spGetTmpValueList(luQryParFrmTypeIDTableNM) + [)]
					*------------------------------------------------------------------------------

				ENDIF
				*------------------------------------------------------------------------------
				
			ENDIF
			*------------------------------------------------------------------------------
			
			*22.02.2006 16:55 -> ��������� ������ (����� ������� ���������)
			luQryParFrmStatEnabled = oQryParMgr.ParamGet(tuParam2,[qplFrmStatEnabled])
			***
			IF !ISNULL(luQryParFrmStatEnabled) AND TYPE([luQryParFrmStatEnabled])==[L] AND luQryParFrmStatEnabled

				*22.02.2006 16:55 -> ������� ��� ������� � ���������������� �������� ����������
				luQryParFrmStatIDTableNM = oQryParMgr.ParamGet(tuParam2,[qpcFrmStatIDTableNM])
				***
				IF !ISNULL(luQryParFrmStatIDTableNM) AND TYPE([luQryParFrmStatIDTableNM])==[C] AND FILE([tmp\]+luQryParFrmStatIDTableNM+[.dbf])

					*10.04.2006 11:35 -> ���������� ������
					lcFilterExpr = lcFilterExpr + ;
									[ AND Form.FrmStatusID IN (] + spGetTmpValueList(luQryParFrmStatIDTableNM) + [)]
					*------------------------------------------------------------------------------

				ENDIF
				*------------------------------------------------------------------------------
				
			ENDIF
			*------------------------------------------------------------------------------

			*10.01.2006 17:07 -> ��������� ������ (����� ���� ���������)
			luQryParFrmTypeEnabled = oQryParMgr.ParamGet(tuParam2,[qplQueue])
			***
			IF !ISNULL(luQryParFrmTypeEnabled) AND TYPE([luQryParFrmTypeEnabled])==[L] AND luQryParFrmTypeEnabled

					lcFilterExpr = lcFilterExpr + ;
									[ AND Form.FrmID IN (SELECT Frmpayqueue.frmid FROM frmpayqueue)]
				
			ENDIF
			*------------------------------------------------------------------------------

		ENDIF
		*------------------------------------------------------------------------------

ENDCASE
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
		[EXECUTE spAccountingView ?lcFilterExpr],lcUniqueName)
ENDDO
***
IF lnSqlExeResult = -1

	*11.08.2006 15:26 ->������� ��������� ��������� ������
	spHandleODBCError()
	*------------------------------------------------------------------------------

	*11.08.2006 15:19 ->�������� ������ ������ ��� ��������
	CREATE CURSOR (lcUniqueName) ( ;
		_mark L, FrmID I, FrmTypeID I, FrmDate T, FrmNum C(1), FrmNote C(1), StatusID I, FrmIsPayed L, ;
		FTShortNM C(1), PEmiNM C(1), PIspNM C(1), FrmSum I, FrmVatSum I, FrmSumSale I, FrmSumBuy I, ;
		FrmVatSale I, FrmVatBuy I, AccFrmID I, AccTvrId I, AccQnt I, AccExit C(1), AccIsActiv F, ;
		AccColor C(1), AccAppr C(1), AccTaste C(1), AccSmell C(1), AccState C(1), AccTech C(1), ;
		AccCaloric C(1), AccFiber C(1), AccFat C(1), AccCarb C(1), AccNote C(1), AccTCard C(1), ;
		AccNetto I, AccPrice I, TvrNm C(1) ;
	)
	*------------------------------------------------------------------------------
	
ENDIF
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> �������� ������ � ���� � �������
SELECT (lcUniqueName)
***
COPY TO (lcUniqueFilePath)
***
USE IN SELECT(lcUniqueName)
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*21.04.2004 14:27 -> ������ ��������
RETURN lcUniqueName
*------------------------------------------------------------------------------

ENDPROC
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spFrmPartFrmView()
* Called by.......: <NA>
* Parameters......: <tcExecVar[,tuFrmID[,tuFrmPartFrmID]]>
*					<[NODATA]>
*					<[BYFRMID],tnFrmID>
*					<[BYFRMPARTFRMID],tnFrmID,tnFrmPartFrmID>
* Returns.........: <lcUniqueFileName>
* Notes...........: ��������� ������ ��� ��������� �������� ������� ���������
*-------------------------------------------------------
PROCEDURE spFrmPartFrmView
LPARAMETERS tcExecVar,tuFrmID,tuFrmPartFrmID

*21.04.2004 12:31 ->���������� � ������������� ����������
LOCAL	lcUniqueName, ;
		lcUniqueFilePath, ;
		lcFilterExpr, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcUniqueName = [_d] + SYS(2015)
lcUniqueFilePath = [tmp\] + lcUniqueName + [.DBF]
*------------------------------------------------------------------------------

*21.04.2004 12:33 ->��������� ������� � ����������� �� ���� �������
DO CASE

	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[NODATA]
		
		*21.04.2004 12:34 ->��������� ������, ��� ������������ ������ �������
		lcFilterExpr = [WHERE 0=1]
		*------------------------------------------------------------------------------

	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[BYFRMID]
		
		*21.04.2004 12:32 ->��������� ������ ��� ������ �������� ������� ������ ���������
		lcFilterExpr = [WHERE FrmPartFrm.FrmID = ]+ALLTRIM(STR(tuFrmID))
		*------------------------------------------------------------------------------
	
	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[BYFRMPARTFRMID]
		
		*21.04.2004 12:32 ->��������� ������ ��� ������ �������� ������� ������ ���������
		lcFilterExpr = 	[WHERE FrmPartFrm.FrmID = ] + ALLTRIM(STR(tuFrmID)) + [ ] + ;
						[AND FrmPartFrm.FrmPartFrmID = ] + ALLTRIM(STR(tuFrmPartFrmID))
		*------------------------------------------------------------------------------

ENDCASE
*------------------------------------------------------------------------------		

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ��������� ������
lnSqlExeResult = -1
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE spFrmPartFrmView ?lcFilterExpr],lcUniqueName)
ENDDO
***
IF lnSqlExeResult = -1

	*11.08.2006 15:29 ->������� ���������� ������
	spHandleODBCError()
	*------------------------------------------------------------------------------
	
	*11.08.2006 15:30 ->�������� ������ ������
	CREATE CURSOR (lcUniqueName) ( ;
		PartFrmID I, CntFrmNM C(1), CntFrmSum I, CntFrmVAT I, CntFrmId I ;
	)
	*------------------------------------------------------------------------------
	
ENDIF
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> �������� ������ � ���� � �������
SELECT (lcUniqueName)
***
COPY TO (lcUniqueFilePath)
***
USE IN SELECT(lcUniqueName)
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*21.04.2004 14:27 ->������ ��������
RETURN lcUniqueName
*------------------------------------------------------------------------------

ENDPROC
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spFrmPartTvrView()
* Called by.......: <NA>
* Parameters......: <tcExecVar[,tuFrmID[,tnFrmPartFrmID]]>
*					<[NODATA]>
*					<[BYFRMID],tnFrmID>
*					<[BYFRMPARTTVRID],tnFrmID,tnFrmPartTvrID>
* Returns.........: <lcUniqueFileName>
* Notes...........: ��������� ������ ��� ��������� �������� ������� ���������
*-------------------------------------------------------
PROCEDURE spFrmPartTvrView
LPARAMETERS tcExecVar,tuFrmID,tuFrmPartTvrID

*21.04.2004 12:31 ->���������� � ������������� ����������
LOCAL	lcUniqueName, ;
		lcUniqueFilePath, ;
		lcFilterExpr, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcUniqueName = [_d] + SYS(2015)
lcUniqueFilePath = [tmp\] + lcUniqueName + [.DBF]
*------------------------------------------------------------------------------

*21.04.2004 12:33 ->��������� ������� � ����������� ���� �������
DO CASE
	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[NODATA]
		
		*21.04.2004 12:34 ->��������� ������, ��� ������������ ������ �������
		lcFilterExpr = [WHERE 0=1]
		*------------------------------------------------------------------------------

	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[BYFRMID]
		
		*21.04.2004 12:32 ->��������� ������ ��� ������ �������� ������� ������ ���������
		lcFilterExpr = [WHERE FrmPartTvr.FrmID = ]+ALLTRIM(STR(tuFrmID))
		*------------------------------------------------------------------------------
	
	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[BYFRMPARTTVRID]
		
		*21.04.2004 12:32 ->��������� ������ ��� ������ �������� ������� ������ ���������
		lcFilterExpr = 	[WHERE FrmPartTvr.FrmID = ] + ALLTRIM(STR(tuFrmID)) + ;
						[AND FrmPartTvr.FrmPartTvrID = ] + ALLTRIM(STR(tuFrmPartTvrID))
		*------------------------------------------------------------------------------

ENDCASE
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
		[EXECUTE spFrmPartTvrView ?lcFilterExpr],lcUniqueName)
ENDDO
***
IF lnSqlExeResult = -1

	*11.08.2006 15:37 ->������� ���������� ������
	spHandleODBCError()
	*------------------------------------------------------------------------------
	
	*11.08.2006 15:30 ->�������� ������ ������
	CREATE CURSOR (lcUniqueName) ( ;
		PartTvrID I, TvrTypeID I, TvrIdCalc I, TvrID I, TvrNM C(1), TvrQnt I, TvrQntNett I, ;
		MsuShortNM C(1), TvrPrcBuy I, TvrSumBuy I, TvrPrcSale I, TvrSumSale I, MsuID I, FrmID I ; 
	)
	*------------------------------------------------------------------------------
	
ENDIF
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> �������� ������ � ���� � �������
SELECT (lcUniqueName)
***
COPY TO (lcUniqueFilePath)
***
USE IN SELECT(lcUniqueName)
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*21.04.2004 14:27 ->������ ��������
RETURN lcUniqueName
*------------------------------------------------------------------------------

ENDPROC
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spFrmPrBookView()
* Called by.......: <NA>
* Parameters......: <tcExecVar[,tuFrmID[,tnFrmPartFrmID]]>
*					<[NODATA]>
*					<[BYFRMID],tnFrmID>
*					<[BYFRMPARTTVRID],tnFrmID,tnFrmPartID>
* Returns.........: <lcUniqueFileName>
* Notes...........: ��������� ������ ��� ��������� �������� ��������������� ���������
*-------------------------------------------------------
PROCEDURE spFrmPrBookView
LPARAMETERS tcExecVar,tuFrmID,tuFrmPartID

*05.08.2006 12:31 ->���������� � ������������� ����������
LOCAL	lcUniqueName, ;
		lcUniqueFilePath, ;
		lcFilterExpr, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcUniqueName = [_d] + SYS(2015)
lcUniqueFilePath = [tmp\] + lcUniqueName + [.DBF]
*------------------------------------------------------------------------------
*05.08.2006 12:33 ->��������� ������� � ����������� ���� �������
DO CASE
	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[NODATA]
		
		*05.08.2006 12:34 ->��������� ������, ��� ������������ ������ �������
		lcFilterExpr = [WHERE 0=1]
		*------------------------------------------------------------------------------

	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[BYFRMID]
		
		*05.08.2006 12:32 ->��������� ������ ��� ������ �������� ������� ������ ���������
		lcFilterExpr = [WHERE FrmPrBookView.PBookFrmID = ]+ALLTRIM(STR(tuFrmID))
		*------------------------------------------------------------------------------
	
	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[BYFRMPARTID]
		
		*05.08.2006 12:32 ->��������� ������ ��� ������ �������� ������� ������ ���������
		lcFilterExpr = 	[WHERE FrmPrBookView.PBookID = ] + ALLTRIM(STR(tuFrmPartID))
		*------------------------------------------------------------------------------

ENDCASE
*------------------------------------------------------------------------------		

*05.08.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*05.08.2006 16:45 -> ��������� ������
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE spFrmPrBookView ?lcFilterExpr],lcUniqueName)
ENDDO
***
IF lnSqlExeResult = -1
	*11.08.2006 15:37 ->������� ���������� ������
	spHandleODBCError()
	*------------------------------------------------------------------------------
	
	*11.08.2006 15:30 ->�������� ������ ������
	CREATE CURSOR (lcUniqueName) ( ;
		PBookID I, PBookFrmID I, PBookSum Y, Debet I, Credit I, PBookProvID I, DebetID I, CreditID I, FrmPartId I ;
	)
	*------------------------------------------------------------------------------
	
ENDIF
*------------------------------------------------------------------------------

*05.08.2006 14:07 -> �������� ������ � ���� � �������
SELECT (lcUniqueName)
***
COPY TO (lcUniqueFilePath)
***
USE IN SELECT(lcUniqueName)
*------------------------------------------------------------------------------

*05.08.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*05.08.2006 14:27 ->������ ��������
RETURN lcUniqueName
*------------------------------------------------------------------------------

ENDPROC
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spFrmInternalPartTvrPrint()
* Called by.......: <When Document Printed>
* Parameters......: <tcQryParSID>
* Returns.........: <������ ��������� ������, ��������� ��� ������>
* Notes...........: ������� ��� ������ ���������� ���������� ���������� ������
*-------------------------------------------------------
PROCEDURE spFrmInternalPartTvrPrint
LPARAMETERS tcQryParSID

*11.05.2005 12:53 ->���������� � ������������� ����������
LOCAL	lnFrmID, ;
		lnConnectHandle, ;
		lnSqlExeResult
*------------------------------------------------------------------------------

*11.05.2005 12:54 ->������ ���������
IF TYPE([oQryParMgr])==[O] AND !ISNULL(oQryParMgr)

	*26.05.2004 21:18 ->������ ������������� ���������, ������� ����� ��������
	lnFrmID = oQryParMgr.ParamGet(tcQryParSID,[FrmID])
	*------------------------------------------------------------------------------
	
ENDIF
*------------------------------------------------------------------------------
			
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
		[EXECUTE spFrmInternalPartTvrPrint ?lnFrmID],[RptItogHD])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*13.04.2006 14:03 -> �������� ������ �������������� �������
SQLMORERESULTS(lnConnectHandle,[RptItogDT])
SQLMORERESULTS(lnConnectHandle)
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> �������� ������� �� ���� � �������
SELECT RptItogHD
COPY TO tmp\RptItogHD.dbf
***
SELECT RptItogDT
COPY TO tmp\RptItogDT.dbf
***
USE IN SELECT([RptItogHD])
USE IN SELECT([RptItogDT])
*------------------------------------------------------------------------------

*24.04.2006 13:59 -> ������� ����������� �� ���� �������
USE tmp\RptItogHD IN 0
USE tmp\RptItogDT IN 0
*------------------------------------------------------------------------------

*05.08.2004 15:42 -> �������� ������ ��������������� ��������, ������������� � ���������
SELECT ;
	RptItogHD.OwnCltID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.DevCltID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.ExEmiCltID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.ExIspCltID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.CntCltID AS ID ;
FROM RptItogHD ;
INTO CURSOR curCltIdList
*------------------------------------------------------------------------------

*05.08.2004 15:54 -> ������� ��������� ������ �� ��������
spClientInfoExpand([curCltIdList],[RptCltInfo])
*------------------------------------------------------------------------------

*26.05.2006 10:41 -> ������� �������
SELECT RptItogDT
INDEX ON STR(TvrCalc,10) + IIF(TvrQnt>0,[1],[2]) TAG TvrCalc COMPACT
INDEX ON STR(NVL(MenuRate,0),10,3)+ ALLTRIM(TvrNM) TAG TvrMenu COMPACT
INDEX ON ALLTRIM(TvrNM) TAG TvrNM COMPACT
SET ORDER TO
*INDEX ON STR(TvrCalc,10) + STR(tvridcalc,10) + IIF(TvrQnt>0,[1],[2]) TAG TvrCalc COMPACT
*------------------------------------------------------------------------------

*22.07.2004 20:50 ->������ ������ ��������� ������, ��������� ��� ������
RETURN [RPTITOGHD.DBF;RPTITOGDT.DBF;RptCltInfo.dbf;RptCltInfo.cdx]
*------------------------------------------------------------------------------

ENDPROC
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spFrmExternalPartTvrPrint()
* Called by.......: <When Document Printed>
* Parameters......: <tnFrmID, tlAddSignature>
* Returns.........: <������ ��������� ������, ��������� ��� ������>
* Notes...........: ������� ��� ������ ������� ���������� ���������� ������
*------------------------------------------------------------------------------
PROCEDURE spFrmExternalPartTvrPrint
LPARAMETERS tcQryParSID

*11.05.2005 12:53 -> ���������� � ������������� ����������
LOCAL	lnFrmID, ;
		llAddSignature, ;
		lnConnectHandle, ;
		lnSqlExeResult
*------------------------------------------------------------------------------

*11.05.2005 12:54 ->������ ���������
IF TYPE([oQryParMgr])==[O] AND !ISNULL(oQryParMgr)

	*26.05.2004 21:18 ->������ ������������� ���������, ������� ����� ��������
	lnFrmID = oQryParMgr.ParamGet(tcQryParSID,[FrmID])
	*------------------------------------------------------------------------------
	
	*11.05.2005 12:55 ->������ ��������� ������ "� �������/��� ������"
	llAddSignature = oQryParMgr.ParamGet(tcQryParSID,[qplAddSign])
	*------------------------------------------------------------------------------

ENDIF
*------------------------------------------------------------------------------

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
		[EXECUTE spFrmExternalPartTvrPrint ?lnFrmID, ?llAddSignature],[RptItogHD])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*13.04.2006 14:03 -> �������� ������ �������������� �������
SQLMORERESULTS(lnConnectHandle,[RptItogDT])
SQLMORERESULTS(lnConnectHandle)
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> �������� ������� �� ���� � �������
SELECT RptItogHD
COPY TO tmp\RptItogHD.dbf
***
SELECT RptItogDT
COPY TO tmp\RptItogDT.dbf
***
USE IN SELECT([RptItogHD])
USE IN SELECT([RptItogDT])
*------------------------------------------------------------------------------

*24.04.2006 13:59 -> ������� ����������� �� ���� �������
USE tmp\RptItogHD IN 0
USE tmp\RptItogDT IN 0
***
SELECT RptItogDT
INDEX ON TvrNM TAG TvrNM
*------------------------------------------------------------------------------

*05.08.2004 15:42 -> �������� ������ ��������������� ��������, ������������� � ���������
SELECT ;
	RptItogHD.CltID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.OwnCltID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.DevCltID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.ExEmiCltID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.ExIspCltID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.CntCltID AS ID ;
FROM RptItogHD ;
INTO CURSOR curCltIdList
*------------------------------------------------------------------------------

*21.04.2006 17:34 -> ������� ��������� ������ �� ��������
spClientInfoExpand([curCltIdList],[RptCltInfo])
*------------------------------------------------------------------------------

*23.09.2004 17:24 -> �������� ������ ��������������� ��������� ������ ��������
SELECT ;
	RptItogHD.CltSAccID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.OwnSAccID AS ID ;
FROM RptItogHD ;
INTO CURSOR curSAccIdList
*------------------------------------------------------------------------------

*21.04.2006 17:34 -> ������� ��������� ������ �� ��������� ������
spSAccInfoExpand([curSAccIdList],[RptSAccInfo])
*------------------------------------------------------------------------------

*22.07.2004 20:50 -> ������ ������ ��������� ������, ��������� ��� ������
RETURN [RptItogHD.dbf;RptItogDT.DBF;RptCltInfo.dbf;RptCltInfo.cdx;RptSAccInfo.dbf;RptSAccInfo.cdx]
*------------------------------------------------------------------------------

ENDPROC
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: SPFRMEXTERNALPARTFRMPRINT()
* Called by.......: <When Document Printed>
* Parameters......: <tnFrmID, tlAddSignature>
* Returns.........: <������ ��������� ������, ��������� ��� ������>
* Notes...........: ������� ��� ������ ������� ���������� ���������� ��������� (�����)
*-------------------------------------------------------
PROCEDURE spFrmExternalPartFrmPrint
LPARAMETERS tcQryParSID

*11.05.2005 12:53 ->���������� � ������������� ����������
LOCAL	lnFrmID, ;
		llAddSignature, ;
		lnConnectHandle, ;
		lnSqlExeResult
*------------------------------------------------------------------------------

*11.05.2005 12:54 ->������ ���������
IF TYPE([oQryParMgr])==[O] AND !ISNULL(oQryParMgr)

	*26.05.2004 21:18 ->������ ������������� ���������, ������� ����� ��������
	lnFrmID = oQryParMgr.ParamGet(tcQryParSID,[FrmID])
	*------------------------------------------------------------------------------
	
	*11.05.2005 12:55 ->������ ��������� ������ "� �������/��� ������"
	llAddSignature = oQryParMgr.ParamGet(tcQryParSID,[qplAddSign])
	*------------------------------------------------------------------------------

ENDIF
*------------------------------------------------------------------------------

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
		[EXECUTE spFrmExternalPartFrmPrint ?lnFrmID, ?llAddSignature],[RptItogHD])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*13.04.2006 14:03 -> �������� ������ �������������� �������
SQLMORERESULTS(lnConnectHandle,[RptItogDT])
SQLMORERESULTS(lnConnectHandle)
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> �������� ������� �� ���� � �������
SELECT RptItogHD
COPY TO tmp\RptItogHD.dbf
***
SELECT RptItogDT
COPY TO tmp\RptItogDT.dbf
***
USE IN SELECT([RptItogHD])
USE IN SELECT([RptItogDT])
*------------------------------------------------------------------------------

*24.04.2006 13:59 -> ������� ����������� �� ���� �������
USE tmp\RptItogHD IN 0
USE tmp\RptItogDT IN 0
*------------------------------------------------------------------------------

*05.08.2004 15:42 ->�������� ������ ��������������� ��������, ������������� � ���������
SELECT ;
	RptItogHD.CltID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.OwnCltID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.DevCltID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.ExEmiCltID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.ExIspCltID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.CntCltID AS ID ;
FROM RptItogHD ;
INTO CURSOR curCltIdList
*------------------------------------------------------------------------------

*21.04.2006 17:34 -> ������� ��������� ������ �� ��������
spClientInfoExpand([curCltIdList],[RptCltInfo])
*------------------------------------------------------------------------------

*23.09.2004 17:24 ->�������� ������ ��������������� ��������� ������ ��������
SELECT ;
	RptItogHD.CltSAccID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.OwnSAccID AS ID ;
FROM RptItogHD ;
INTO CURSOR curSAccIdList
*------------------------------------------------------------------------------

*21.04.2006 17:34 -> ������� ��������� ������ �� ��������� ������
spSAccInfoExpand([curSAccIdList],[RptSAccInfo])
*------------------------------------------------------------------------------

*22.07.2004 20:50 -> ������ ������ ��������� ������, ��������� ��� ������
RETURN [RptItogHD.dbf;RptItogDT.DBF;RptCltInfo.dbf;RptCltInfo.cdx;RptSAccInfo.dbf;RptSAccInfo.cdx]
*------------------------------------------------------------------------------

ENDPROC
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spFrmExternalPartFrmPrintDetail()
* Called by.......: <When Document Printed>
* Parameters......: <tnFrmID, tlAddSignature>
* Returns.........: <������ ��������� ������, ��������� ��� ������>
* Notes...........: ������� ��� ������ ���������� ���������� ������ � ������� FrmPayDetail
*-------------------------------------------------------
PROCEDURE spFrmExternalPartFrmPrintDetail
LPARAMETERS tcQryParSID

*11.05.2005 12:53 ->���������� � ������������� ����������
LOCAL	lcResult, ;
		lnFrmID, ;
		llAddSignature, ;
		lnConnectHandle, ;
		lnSqlExeResult
*------------------------------------------------------------------------------

*12.01.2005 10:35 -> �������� ��������� ������� ����������� ������ ��� FrmPayDetail
lcResult = spFrmExternalPartFrmPrint(tcQryParSID)
*------------------------------------------------------------------------------

*11.05.2005 12:54 ->������ ���������
IF TYPE([oQryParMgr])==[O] AND !ISNULL(oQryParMgr)

	*26.05.2004 21:18 ->������ ������������� ���������, ������� ����� ��������
	lnFrmID = oQryParMgr.ParamGet(tcQryParSID,[FrmID])
	*------------------------------------------------------------------------------
	
	*11.05.2005 12:55 ->������ ��������� ������ "� �������/��� ������"
	llAddSignature = oQryParMgr.ParamGet(tcQryParSID,[qplAddSign])
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
		[EXECUTE spFrmExternalPartFrmPrintDetail ?lnFrmID],[RptItogPD])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> �������� ������ �� ���� � �������
SELECT RptItogPD
COPY TO tmp\RptItogPD.dbf
***
USE IN SELECT([RptItogPD])
*------------------------------------------------------------------------------

*24.04.2006 13:59 -> ������� ����������� �� ���� �������
USE tmp\RptItogPD IN 0
*------------------------------------------------------------------------------

*12.01.2005 10:48 -> ������ ������ ��������� ������, ��������� ��� ������
RETURN lcResult + [;RPTITOGPD.DBF]
*------------------------------------------------------------------------------

ENDPROC
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spFrmAccCardPrint()
* Called by.......: <When Document Printed>
* Parameters......: <tnFrmID, tlAddSignature>
* Returns.........: <������ ��������� ������, ��������� ��� ������>
* Notes...........: ������� ��� ������ ������� ���������� ���������� ������
*------------------------------------------------------------------------------
PROCEDURE spFrmAccCardPrint
LPARAMETERS tcQryParSID

*11.05.2005 12:53 -> ���������� � ������������� ����������
LOCAL	lnFrmID, ;
		llAddSignature, ;
		lnConnectHandle, ;
		lnSqlExeResult
*------------------------------------------------------------------------------

*11.05.2005 12:54 -> ������ ���������
IF TYPE([oQryParMgr])==[O] AND !ISNULL(oQryParMgr)

	*26.05.2004 21:18 -> ������ ������������� ���������, ������� ����� ��������
	lnFrmID = oQryParMgr.ParamGet(tcQryParSID,[FrmID])
	*------------------------------------------------------------------------------
	
	*11.05.2005 12:55 -> ������ ��������� ������ "� �������/��� ������"
	llAddSignature = oQryParMgr.ParamGet(tcQryParSID,[qplAddSign])
	*------------------------------------------------------------------------------

ENDIF
*------------------------------------------------------------------------------
			
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
		[EXECUTE spFrmAccCardPrint ?lnFrmID, ?llAddSignature],[RptItogHD])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*13.04.2006 14:03 -> �������� ������ �������������� �������
SQLMORERESULTS(lnConnectHandle,[RptItogDT])
SQLMORERESULTS(lnConnectHandle)
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> �������� ������� �� ���� � �������
SELECT RptItogHD
COPY TO tmp\RptItogHD.dbf
***
SELECT RptItogDT
COPY TO tmp\RptItogDT.dbf
***
USE IN SELECT([RptItogHD])
USE IN SELECT([RptItogDT])
*------------------------------------------------------------------------------

*24.04.2006 13:59 -> ������� ����������� �� ���� �������
USE tmp\RptItogHD IN 0
USE tmp\RptItogDT IN 0
*------------------------------------------------------------------------------

*05.08.2004 15:42 -> �������� ������ ��������������� ��������, ������������� � ���������
SELECT ;
	RptItogHD.CltID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.OwnCltID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.DevCltID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.ExEmiCltID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.ExIspCltID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.CntCltID AS ID ;
FROM RptItogHD ;
INTO TABLE tmp\tmpCltIdList
*------------------------------------------------------------------------------

*05.08.2004 15:54 ->������� ��������� ������ �� ��������
spClientInfoExpand([tmpCltIdList],[RptCltInfo])
*------------------------------------------------------------------------------

*22.07.2004 20:50 -> ������ ������ ��������� ������, ��������� ��� ������
RETURN [RPTITOGHD.DBF;RPTITOGDT.DBF;RptCltInfo.dbf;RptCltInfo.cdx]
*------------------------------------------------------------------------------

ENDPROC
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*------------------------------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spT30Report()
* Called by.......: <When Document Printed>
* Parameters......: <tcQryParSID>
* Returns.........: <������ ��������� ������, ��������� ��� ������>
* Notes...........: ������� ��� ������ ������ �� ����
*------------------------------------------------------------------------------
PROCEDURE spT30Report
LPARAMETERS tcQryParSID

*21.04.2004 12:31 -> ���������� � ������������� ����������
LOCAL	lcOldDate, ;
		lcOldCentury, ;
		lcOldMark, ;
		lcFilterExpr, ;
		lcBalanceFilterExpr, ;
		luQryParDateEnabled, ;
		luQryParDateStartDate, ;
		luQryParDateEndDate, ;
		luQryParOUEnabled, ;
		luQryParOUIDTableNM, ;
		lcValueList, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcOldDate = SET([DATE])
lcOldCentury = SET([CENTURY])
lcOldMark = SET([MARK])
lcFilterExpr = [WHERE 0<>1]
lcBalanceFilterExpr = [WHERE 0<>1]
*------------------------------------------------------------------------------

*****************************************************************************
* 1. �������� ������������� ������ ���������� ��� ������������� � ������	*
*****************************************************************************

*02.06.2005 15:47 -> ������� ������� � ���������� ��� ������
CREATE TABLE tmp\RptEnv FREE (QryParSID C(10))
INSERT INTO RptEnv (QryParSID) VALUES (tcQryParSID)
*------------------------------------------------------------------------------

*****************************************************************************
* 2. ���������� ������� ������ ������										*
*****************************************************************************

*08.07.2005 14:35 -> ���������� ������� ������ �� ����
luQryParDateEnabled   = oQryParMgr.ParamGet(tcQryParSID,[qplDateEnabled])
luQryParDateStartDate = oQryParMgr.ParamGet(tcQryParSID,[qpdDateStart])
luQryParDateEndDate   = oQryParMgr.ParamGet(tcQryParSID,[qpdDateEnd])
***
IF !ISNULL(luQryParDateEnabled)   AND TYPE([luQryParDateEnabled])==[L]   AND luQryParDateEnabled AND ;
   !ISNULL(luQryParDateStartDate) AND TYPE([luQryParDateStartDate])==[D] AND !EMPTY(luQryParDateStartDate) AND ;
   !ISNULL(luQryParDateEndDate)   AND TYPE([luQryParDateEndDate])==[D]   AND !EMPTY(luQryParDateEndDate)

	*21.04.2006 10:33 -> ��������� ������ ���� YMD � CENTURY ON
	SET DATE YMD
	***
	SET CENTURY ON
	***
	SET MARK TO "/"
	*------------------------------------------------------------------------------

	*08.07.2005 14:38 -> ���������� ������� ������
	lcFilterExpr = lcFilterExpr + [ AND StockTrans.StockTransDate >= ']+STRTRAN(DTOC(luQryParDateStartDate),[/],[])+[' AND StockTrans.StockTransDate < ']+STRTRAN(DTOC(luQryParDateEndDate+1),[/],[])+[']
	lcBalanceFilterExpr = lcBalanceFilterExpr + [ AND StockTrans.StockTransDate < ']+STRTRAN(DTOC(luQryParDateStartDate),[/],[])+[']
	*------------------------------------------------------------------------------

	*21.04.2006 10:33 -> ����������� ������ ������ ����
	SET DATE (lcOldDate)
	***
	SET CENTURY &lcOldCentury
	***
	SET MARK TO lcOldMark
	*------------------------------------------------------------------------------

ELSE

	*08.07.2005 14:40 -> ������� ��������� � ������������� ������� ��������� � �������� ���� ��� ���������� ������
	spHandleODBCError()
	RETURN .F.
	*------------------------------------------------------------------------------

ENDIF
*------------------------------------------------------------------------------

*28.05.2004 00:32 -> ��������� ������� ������ �� �������������
luQryParOUEnabled   = oQryParMgr.ParamGet(tcQryParSID,[qplOUEnabled])
luQryParOUIDTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcOUIDTableNM])
***
IF !ISNULL(luQryParOUEnabled)   AND TYPE([luQryParOUEnabled])==[L]   AND luQryParOUEnabled AND ;
   !ISNULL(luQryParOUIDTableNM) AND TYPE([luQryParOUIDTableNM])==[C]

   	*08.07.2005 14:38 -> ���������� ������� ������
   	lcValueList = spGetTmpValueList(luQryParOUIDTableNM)
   	***
	lcFilterExpr = lcFilterExpr + [ AND StockTrans.StockTransOUID IN (] + lcValueList + [)]
	lcBalanceFilterExpr = lcBalanceFilterExpr + [ AND StockTrans.StockTransOUID IN (] + lcValueList + [)]
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
		[EXECUTE spT30Report ?lcFilterExpr, ?lcBalanceFilterExpr],[RptItog])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*05.08.2004 15:42 -> �������� ������ ��������������� ��������, ������������� � ���������
SELECT DISTINCT ;
	RptItog.OwnCltID AS CltID ;
FROM RptItog ;
INTO TABLE tmp\tmpCltIdList
*------------------------------------------------------------------------------

*05.08.2004 15:54 -> ������� ��������� ������ �� ��������
spClientInfoExpand([tmpCltIdList],[RptCltInfo])
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> �������� ������ � ���� � �������
SELECT RptItog
***
COPY TO tmp\RptItog.dbf
***
USE IN SELECT([RptItog])
*------------------------------------------------------------------------------

*26.01.2005 19:10 -> ������ ������ ������ ��������� ��� ������
RETURN [RptEnv.dbf;RptItog.dbf;RptCltInfo.dbf;RptCltInfo.cdx]
*------------------------------------------------------------------------------

ENDPROC
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*-------------------------------------------------------
*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spT29Report()
* Called by.......: <When Document Printed>
* Parameters......: <tcQryParSID>
* Returns.........: <������ ��������� ������, ��������� ��� ������>
* Notes...........: ������� ��� ������ ��������� ������
*-------------------------------------------------------
PROCEDURE spT29Report
LPARAMETERS tcQryParSID

*21.04.2004 12:31 -> ���������� � ������������� ����������
LOCAL	lcOldDate, ;
		lcOldCentury, ;
		lcOldMark, ;
		lcFilterExpr, ;
		lcBalanceFilterExpr, ;
		luQryParDateEnabled, ;
		luQryParDateStartDate, ;
		luQryParDateEndDate, ;
		luQryParOUEnabled, ;
		luQryParOUIDTableNM, ;
		lcValueList, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcOldDate = SET([DATE])
lcOldCentury = SET([CENTURY])
lcOldMark = SET([MARK])
lcFilterExpr = [WHERE Form.FrmTypeID <> 27]
lcBalanceFilterExpr = [WHERE Form.FrmTypeID <> 27]
*------------------------------------------------------------------------------

*****************************************************************************
* 1. �������� ������������� ������ ���������� ��� ������������� � ������	*
*****************************************************************************

*02.06.2005 15:47 -> ������� ������� � ���������� ��� ������
CREATE TABLE tmp\RptEnv FREE (QryParSID C(10))
INSERT INTO RptEnv (QryParSID) VALUES (tcQryParSID)
*------------------------------------------------------------------------------

*****************************************************************************
* 2. ���������� ������� ������ ������										*
*****************************************************************************

*08.07.2005 14:35 -> ���������� ������� ������ �� ����
luQryParDateEnabled   = oQryParMgr.ParamGet(tcQryParSID,[qplDateEnabled])
luQryParDateStartDate = oQryParMgr.ParamGet(tcQryParSID,[qpdDateStart])
luQryParDateEndDate   = oQryParMgr.ParamGet(tcQryParSID,[qpdDateEnd])
***
IF !ISNULL(luQryParDateEnabled)   AND TYPE([luQryParDateEnabled])==[L]   AND luQryParDateEnabled AND ;
   !ISNULL(luQryParDateStartDate) AND TYPE([luQryParDateStartDate])==[D] AND !EMPTY(luQryParDateStartDate) AND ;
   !ISNULL(luQryParDateEndDate)   AND TYPE([luQryParDateEndDate])==[D]   AND !EMPTY(luQryParDateEndDate)

	*21.04.2006 10:33 -> ��������� ������ ���� YMD � CENTURY ON
	SET DATE YMD
	***
	SET CENTURY ON
	***
	SET MARK TO "/"
	*------------------------------------------------------------------------------

	*08.07.2005 14:38 -> ���������� ������� ������
	lcFilterExpr = lcFilterExpr + [ AND StockTrans.StockTransDate >= ']+STRTRAN(DTOC(luQryParDateStartDate),[/],[])+[' AND StockTrans.StockTransDate < ']+STRTRAN(DTOC(luQryParDateEndDate+1),[/],[])+[']
	lcBalanceFilterExpr = lcBalanceFilterExpr + [ AND StockTrans.StockTransDate < ']+STRTRAN(DTOC(luQryParDateStartDate),[/],[])+[']
	*------------------------------------------------------------------------------

	*21.04.2006 10:33 -> ����������� ������ ������ ����
	SET DATE (lcOldDate)
	***
	SET CENTURY &lcOldCentury
	***
	SET MARK TO lcOldMark
	*------------------------------------------------------------------------------

ELSE

	*08.07.2005 14:40 -> ������� ��������� � ������������� ������� ��������� � �������� ���� ��� ���������� ������
	spHandleODBCError()
	RETURN .F.
	*------------------------------------------------------------------------------

ENDIF
*------------------------------------------------------------------------------

*28.05.2004 00:32 -> ��������� ������� ������ �� �������������
luQryParOUEnabled   = oQryParMgr.ParamGet(tcQryParSID,[qplOUEnabled])
luQryParOUIDTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcOUIDTableNM])
***
IF !ISNULL(luQryParOUEnabled)   AND TYPE([luQryParOUEnabled])==[L]   AND luQryParOUEnabled AND ;
   !ISNULL(luQryParOUIDTableNM) AND TYPE([luQryParOUIDTableNM])==[C]

   	*08.07.2005 14:38 -> ���������� ������� ������
   	lcValueList = spGetTmpValueList(luQryParOUIDTableNM)
   	***
	lcFilterExpr = lcFilterExpr + [ AND StockTrans.StockTransOUID IN (] + lcValueList + [)]
	lcBalanceFilterExpr = lcBalanceFilterExpr + [ AND StockTrans.StockTransOUID IN (] + lcValueList + [)]
	*------------------------------------------------------------------------------

ENDIF
*------------------------------------------------------------------------------

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
		[EXECUTE spT29Report ?lcFilterExpr, ?lcBalanceFilterExpr],[RptItog])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*13.04.2006 14:03 -> �������� ������ �������������� �������
SQLMORERESULTS(lnConnectHandle,[RptBalance])
SQLMORERESULTS(lnConnectHandle)
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> �������� ������� �� ���� � �������
SELECT RptItog
COPY TO tmp\RptItog.dbf
***
SELECT RptBalance
COPY TO tmp\RptBalance.dbf
***
USE IN SELECT([RptItog])
USE IN SELECT([RptBalance])
*------------------------------------------------------------------------------

*22.07.2004 20:27 -> ��������� �������
USE tmp\RptItog.dbf IN 0
***
SELECT RptItog
INDEX ON ALLTRIM(STR(RptItog.OUID,11)) + IIF(RptItog.FrmSign=1,[0],[1]) + IIF(RptItog.IsReturn,[1],[0]) + DTOC(RptItog.FrmDate,1) TAG OuDtSign COMPACT
*------------------------------------------------------------------------------

*05.08.2004 15:42 -> �������� ������ ��������������� ��������, ������������� � ���������
SELECT DISTINCT ;
	RptItog.CltID AS ID;
FROM RptItog ;
UNION ALL ;
SELECT DISTINCT ;
	RptItog.OwnCltID AS ID ;
FROM RptItog ;
INTO TABLE tmp\tmpCltIdList
*------------------------------------------------------------------------------

*05.08.2004 15:54 -> ������� ��������� ������ �� ��������
spClientInfoExpand([tmpCltIdList],[RptCltInfo])
*------------------------------------------------------------------------------

*22.07.2004 20:27 -> ��������� �������
USE tmp\RptBalance.dbf IN 0
***
SELECT RptBalance
INDEX ON OUID TAG OUID COMPACT
*------------------------------------------------------------------------------

*26.01.2005 19:10 -> ������ ������ ������ ��������� ��� ������
RETURN [RptEnv.dbf;RptItog.dbf;RptItog.cdx;RptCltInfo.dbf;RptCltInfo.cdx;RptBalance.dbf;RptBalance.cdx]
*------------------------------------------------------------------------------

ENDPROC
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

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
*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spStockReport()
* Called by.......: <NA>
* Parameters......: <tnFrmID>
* Returns.........: <lcUniqueNM>
* Notes...........: ������� ��� ������ �� ��������
*-------------------------------------------------------
PROCEDURE spStockReport
LPARAMETERS tcQryParSID

*27.09.2005 09:28 ->���������� � ������������� ����������
LOCAL	lcOldDate, ;
		lcOldCentury, ;
		lcOldMark, ;
		lcOldAlias, ;
		lcFilterExpr, ;
		luQryParDateEnabled, ;
		luQryParDateStartDate, ;
		luQryParOUIspEnabled, ;
		luQryParOUIspIDTableNM, ;
		luQryParTvrGrpEnabled, ;
		luQryParTvrGrpTableNM, ;
		lcQryParTvrIDTableNM, ;
		luQryParCltEmiEnabled, ;
		luQryParCltEmiTableNM, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcOldDate = SET([DATE])
lcOldCentury = SET([CENTURY])
lcOldMark = SET([MARK])
lcOldAlias = ALIAS()
lcFilterExpr = []
*------------------------------------------------------------------------------

*02.06.2005 15:47 ->������� ������� � ���������� ��� ������
CREATE TABLE tmp\RptEnv FREE (QryParSID C(10))
INSERT INTO RptEnv (QryParSID) VALUES (tcQryParSID)
*------------------------------------------------------------------------------

*19.09.2005 17:07 ->���������� ������� ������ �� ����
luQryParDateEnabled   = oQryParMgr.ParamGet(tcQryParSID,[qplDateEnabled])
luQryParDateStartDate = oQryParMgr.ParamGet(tcQryParSID,[qpdDateStart])
****
IF !ISNULL(luQryParDateEnabled)   AND TYPE([luQryParDateEnabled])==[L]   AND luQryParDateEnabled AND ;
   !ISNULL(luQryParDateStartDate) AND TYPE([luQryParDateStartDate])==[D] AND !EMPTY(luQryParDateStartDate)

	*21.04.2006 10:33 -> ��������� ������ ���� YMD � CENTURY ON
	SET DATE YMD
	***
	SET CENTURY ON
	***
	SET MARK TO "/"
	*------------------------------------------------------------------------------

	*03.07.2006 11:40 -> ���������� ������� ������
	lcFilterExpr = 	[Stock.StockValidFrom < ']   + STRTRAN(DTOC(luQryParDateStartDate),[/],[]) + [' AND ] + ;
					[(Stock.StockValidThru >= '] + STRTRAN(DTOC(luQryParDateStartDate),[/],[]) + [' OR ]  + ;
					[Stock.StockValidThru IS NULL)]
	*------------------------------------------------------------------------------

	*21.04.2006 10:33 -> ����������� ������ ������ ����
	SET DATE (lcOldDate)
	***
	SET CENTURY &lcOldCentury
	***
	SET MARK TO lcOldMark
	*------------------------------------------------------------------------------

ELSE
	lcFilterExpr = 	[Stock.StockValidThru IS NULL]
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
						[ AND Stock.StockOUID IN (] + spGetTmpValueList(luQryParOUIspIDTableNM) + [)]
	ENDIF
	*------------------------------------------------------------------------------
	
ENDIF
*------------------------------------------------------------------------------

*28.09.2005 10:09 -> ��������� ������ (����� ����� �������)
luQryParTvrGrpEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplTvrGrpEnabled])
***
IF !ISNULL(luQryParTvrGrpEnabled) AND TYPE([luQryParTvrGrpEnabled])==[L] AND luQryParTvrGrpEnabled

	*28.09.2005 10:16 -> ������� ��� ������� � ���������������� ����� �������
	luQryParTvrGrpTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcTvrGrpTableNM])
	***
	IF !ISNULL(luQryParTvrGrpTableNM) AND TYPE([luQryParTvrGrpTableNM])==[C] AND FILE([tmp\]+luQryParTvrGrpTableNM+[.dbf])
		lcFilterExpr = lcFilterExpr + ;
						[ AND Stock.StockTvrID IN (SELECT ID FROM GetTvrIDInSelectedTvrGrp('] + spGetTmpValueList(luQryParTvrGrpTableNM) + [') WHERE IsCnt = 0)]
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
	lcFilterExpr = lcFilterExpr + [ AND Form.PointEmiCltID IN (] + spGetTmpValueList(luQryParCltEmiTableNM) + [)]
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
		[EXECUTE spStockReport ?lcFilterExpr],[RptItogDT])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> �������� ������� �� ���� � �������
SELECT RptItogDT
***
COPY TO tmp\RptItogDT.dbf
***
USE IN SELECT([RptItogDT])
*------------------------------------------------------------------------------

*19.09.2005 11:25 -> ������� ������
USE IN SELECT([RptEnv])
*------------------------------------------------------------------------------

*28.09.2005 12:49 ->����������� �������� �������
USE tmp\RptItogDT.dbf IN 0
***
SELECT RptItogDT
INDEX ON OUNM  TAG OUNM OF tmp\RptItogDT
INDEX ON CltNM TAG CltNM OF tmp\RptItogDT ADDITIVE
INDEX ON TvrNM TAG TvrNM OF tmp\RptItogDT ADDITIVE
INDEX ON LEFT(TvrGrpNM,55)+LEFT(TvrNM,55) TAG TvrGrpNM OF tmp\RptItogDT ADDITIVE
*------------------------------------------------------------------------------

*28.09.2005 12:54 ->����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*19.09.2005 11:21 ->������ ������ ��������� ������ ��� ���������� ������
RETURN [RptItogDT.dbf;RptEnv.dbf]
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

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

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spFormCopy()
* Called by.......: <NA>
* Parameters......: <tnSrcFrmID,tnTargetFrmTypeID,tcOperation>
* Returns.........: <lnLastFrmID>
* Notes...........: ����������� ���������
*------------------------------------------------------------------------------
PROCEDURE spFormCopy
LPARAMETERS tnSrcFrmID,tnTargetFrmTypeID,tcOperation

*15.12.2004 16:49 ->���������� � ������������� ����������
LOCAL	lcOldAlias, ;
		lnLastFrmID, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcOldAlias = ALIAS()
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ������ ��� ���������
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE spFormCopy  ?tnSrcFrmID, ?tnTargetFrmTypeID, ?tcOperation], ;
		[curLastFrmID])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
***
lnLastFrmID = curLastFrmID.FrmID
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*15.12.2004 16:50 ->����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*16.12.2004 17:58 ->������ ������������� ����� ������������ ��������
RETURN lnLastFrmID
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures For Basis
* Module/Procedure: spFrmAutoNum()
* Called by.......: <NA>
* Parameters......: <tnFrmTypeID,tnPointEmiOUID,tnPointIspOUID,tdDate>
* Returns.........: <lcFrmNum>
* Notes...........: �������������
*------------------------------------------------------------------------------
PROCEDURE spFrmAutoNum
LPARAMETERS tnFrmTypeID,tdDate,tnPointEmiOUID,tnPointIspOUID

*21.12.2004 18:09 ->���������� � ������������� ����������
LOCAL	lcOldAlias, ;
		lnConnectHandle, ;
		lnSqlExeResult, ;
		lnOUID, ;
		lnOwnCltID, ;
		lcMask, ;
		lcFrmNum, ;
		lnStartPos, ;
		lnEndPos, ;
		lcSerialSection, ;
		lcSerialSectionValue, ;
		lnCounter
***
lcOldAlias = ALIAS()
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ������ ��� ���������
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[SELECT ] + ;
			[FrmType.FrmTypeDirection ] + ;
		[FROM FrmType ] + ;
		[WHERE FrmType.FrmTypeID = ?tnFrmTypeID], ;
		[curFrmType])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN
ENDIF
*------------------------------------------------------------------------------

*21.12.2004 18:08 ->��������� ��� �������������
lnOUID = IIF(curFrmType.FrmTypeDirection=2,tnPointIspOUID,tnPointEmiOUID)
***
IF lnOUID = 0
	RETURN []
ENDIF
*------------------------------------------------------------------------------

*22.12.2004 10:06 -> ��������� ������ curFrmType
USE IN SELECT([curFrmType])
*------------------------------------------------------------------------------

*21.12.2004 18:18 ->��������� ������������� �������� �������������
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[SELECT ] + ;
			[OrgUnit.CltID ] + ;
		[FROM OrgUnit ] + ;
		[WHERE OrgUnit.OUID = ?lnOUID], ;
		[curOrgUnit])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN
ENDIF
***
lnOwnCltID = curOrgUnit.CltID
***
IF EMPTY(lnOwnCltID)
	ASSERT .F. MESSAGE [STORED PROCEDURES FOR BASIS: ���������� ������������� ����� �� �������������, �� �������� ��������-�������]
	RETURN [ERROR]
ENDIF
*------------------------------------------------------------------------------

*22.12.2004 10:06 -> ��������� ������ curOrgUnit
USE IN SELECT([curOrgUnit])
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ������� ��������� �������������
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE spFrmAutoNum ?tnFrmTypeID, ?lnOUID], ;
		[curFrmTypeAutoNum])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN
ENDIF
***
IF RECCOUNT([curFrmTypeAutoNum])#1
	ASSERT .F. MESSAGE [STORED PROCEDURES FOR BASIS: �� ������ �������� �������������� ��� ������� ���� ���������]
	RETURN [ERROR]
ENDIF
*------------------------------------------------------------------------------

*21.12.2004 18:23 ->���������� �������
lcFrmNum = []
***
IF !EMPTY(curFrmTypeAutoNum.AutoNumMask) AND curFrmTypeAutoNum.AutoNumIsEnabled
	lcFrmNum = ALLTRIM(curFrmTypeAutoNum.AutoNumMask)
	DO WHILE [{]$lcFrmNum AND [}]$lcFrmNum
		lnStartPos = AT([{],lcFrmNum)
		lnEndPos = AT([}],lcFrmNum)
		***
		IF lnStartPos > lnEndPos
			ASSERT .F. MESSAGE [STORED PROCEDURES FOR BASIS: ������������ ����� ��������������]
			RETURN [ERROR]
		ENDIF
		***
		lcSerialSection = SUBSTR(lcFrmNum,lnStartPos+1,lnEndPos-lnStartPos-1)
		***
		DO CASE
			CASE UPPER(lcSerialSection)==[YYYY]
				lcSerialSectionValue = ALLTRIM(STR(YEAR(tdDate)))
			CASE UPPER(lcSerialSection)==[YY]
				lcSerialSectionValue = RIGHT(ALLTRIM(STR(YEAR(tdDate))),2)
			CASE UPPER(lcSerialSection)==[MM]
				lcSerialSectionValue = ALLTRIM(STR(MONTH(tdDate)))
			CASE UPPER(lcSerialSection)==[DD]
				lcSerialSectionValue = ALLTRIM(STR(DAY(tdDate)))
			CASE [n]$lcSerialSection OR [N]$lcSerialSection
				lnCounter = spFrmAutoNumGetCounter(IIF(curFrmTypeAutoNum.FrmTypeIDIsConst,curFrmTypeAutoNum.FrmTypeIDConst,tnFrmTypeID), ;
												   IIF(curFrmTypeAutoNum.OwnCltIDIsConst,curFrmTypeAutoNum.OwnCltIDConst,lnOwnCltID), ;
												   IIF(curFrmTypeAutoNum.OUIDIsConst,curFrmTypeAutoNum.OUIDConst,lnOUID))
				***
				IF [N]$lcSerialSection
					lcSerialSectionValue = PADL(ALLTRIM(STR(lnCounter)),lnEndPos-lnStartPos-1,[0])
				ELSE
					lcSerialSectionValue = ALLTRIM(STR(lnCounter))
				ENDIF				
			OTHERWISE
				lcSerialSectionValue = []
		ENDCASE
		***
		lcFrmNum = STUFF(lcFrmNum,lnStartPos,lnEndPos-lnStartPos+1,lcSerialSectionValue)
	ENDDO
ENDIF
*------------------------------------------------------------------------------

*22.12.2004 10:07 -> ��������� �������
USE IN IIF(USED([curFrmTypeAutoNum]),[curFrmTypeAutoNum],0)
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*23.12.2004 12:06 ->����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*21.12.2004 19:01 ->����� ��������������� �����
RETURN lcFrmNum
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*------------------------------------------------------------------------------
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

*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spResetAutoNum()
* Parameters......: tnFrmTypeID
* Returns.........: 
* Notes...........: ����� �������������� ��� �������� �����
*-------------------------------------------------------
PROCEDURE spResetAutoNum
LPARAMETERS tnFrmTypeID

*31.05.2006 10:05 -> ���������� � ������������� ����������
LOCAL   lnConnectHandle, ;
		lnSqlExeResult
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ���������� ��������
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[UPDATE FrmNumCounter ] + ;
			[SET FrmNumCntVal = 0 ] + ;
		[WHERE FrmTypeID = ?tnFrmTypeID])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

ENDPROC
*------------------------------------------------------------------------------

************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

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
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spSAccInfoExpand()
* Called by.......: <NA>
* Parameters......: <tcSAccIdList, tcRptSAccInfo>
* Returns.........: <none>
* Notes...........: ������� ���������� �� ��������� ������
*-------------------------------------------------------
PROCEDURE spSAccInfoExpand
LPARAMETERS tcSAccIdList, tcRptSAccInfo

*24.04.2006 12:49 ->���������� � ������������� ����������
LOCAL	lcRptSAccInfoPath, ;
		lcFilterExpr, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcRptSAccInfoPath = [tmp\] + tcRptSAccInfo + [.dbf]
*------------------------------------------------------------------------------

*21.04.2006 16:14 -> ���������� ������ �� ������� ��������� ��������������� ��������� ������ ��������
lcFilterExpr = spGetTmpValueList(tcSAccIdList)
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ��������� ������ (������� ��������� ������ �� ��������� ������)
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE spSAccInfoExpand ?lcFilterExpr],tcRptSAccInfo)
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> �������� ������ �� ���� � �������
SELECT (tcRptSAccInfo)
COPY TO (lcRptSAccInfoPath)
***
USE IN SELECT(tcRptSAccInfo)
*------------------------------------------------------------------------------

*24.04.2006 13:59 -> ������� ����������� �� ���� �������
USE (lcRptSAccInfoPath) IN 0
*------------------------------------------------------------------------------

*16.09.2004 15:55 ->�������� ������ ��� Relation-�
SELECT (tcRptSAccInfo)
INDEX ON CltSAccID TAG CltSAccID OF ([tmp\]+tcRptSAccInfo)
*------------------------------------------------------------------------------
	
ENDPROC
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: spClientView()
* Called by.......: <NA>
* Parameters......: <tcQryParSID>
* Returns.........: <lcUniqueFileName>
* Notes...........: �������� ��������
*------------------------------------------------------------------------------
PROCEDURE spClientView
LPARAMETERS tcQryParSID

*10.08.2005 14:58 -> ���������� � ������������� ����������
LOCAL	lcOldAlias, ;
		lcUniqueName, ;
		lcUniqueFilePath, ;
		lcCltJuridicalExpr, ;
		lcCltPhysicalExpr, ;
		lcClientExpr, ;
		luQryParCltNMEnabled, ;
		luQryParCltNM, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcOldAlias = ALIAS()
lcUniqueName = [_c] + SYS(2015)
lcUniqueFilePath = [tmp\] + lcUniqueName + [.DBF]
lcCltJuridicalExpr = [WHERE 0=1]
lcCltPhysicalExpr = [WHERE 0=1]
lcClientExpr = [WHERE 0=1]
*------------------------------------------------------------------------------

*10.08.2005 16:48 -> ������ ���������
IF PCOUNT()=1 AND TYPE([oQryParMgr])==[O] AND !ISNULL(oQryParMgr)

	*10.08.2005 17:06 -> �������������� ������
	lcClientExpr = [WHERE 0<>1]
	*------------------------------------------------------------------------------

	*10.08.2005 16:48 -> ��������� ������ �� ������������ �������
	luQryParCltNMEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplCltNMEnabled])
	***
	IF !ISNULL(luQryParCltNMEnabled) AND TYPE([luQryParCltNMEnabled])==[L] AND luQryParCltNMEnabled

		*10.08.2005 16:49 -> ������� ������������ �������
		luQryParCltNM = oQryParMgr.ParamGet(tcQryParSID,[qpcCltNM])
		***
		IF !ISNULL(luQryParCltNM) AND TYPE([luQryParCltNM])==[C]

			*10.08.2005 16:49 -> ��������� �������
			lcCltJuridicalExpr	= [WHERE UPPER(CltJuridical.CltJrdNM) LIKE '%] + UPPER(ALLTRIM(luQryParCltNM)) + [%']
			lcCltPhysicalExpr	= [WHERE UPPER(LTRIM(CASE WHEN NOT CltPhysical.CltPhysFNM IS NULL AND CltPhysical.CltPhysFNM <> '' THEN ' ' + CltPhysical.CltPhysFNM ELSE '' END + ] + ;
										[CASE WHEN NOT CltPhysical.CltPhysINM IS NULL AND CltPhysical.CltPhysINM <> '' THEN ' ' + CltPhysical.CltPhysINM ELSE '' END + ] + ;
										[CASE WHEN NOT CltPhysical.CltPhysONM IS NULL AND CltPhysical.CltPhysONM <> '' THEN ' ' + CltPhysical.CltPhysONM ELSE '' END)) ] + ;
										[LIKE '%] + UPPER(ALLTRIM(luQryParCltNM)) + [%']
			lcClientExpr		= [WHERE UPPER(Client.CltNM) LIKE '%] + UPPER(ALLTRIM(luQryParCltNM)) + [%']
			*------------------------------------------------------------------------------

		ENDIF
		*------------------------------------------------------------------------------

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
		[EXECUTE spClientView ?lcClientExpr, ?lcCltJuridicalExpr, ?lcCltPhysicalExpr],lcUniqueName)
ENDDO
***
IF lnSqlExeResult = -1

	*11.08.2006 16:04 ->������� ���������� ������
	spHandleODBCError()
	*------------------------------------------------------------------------------

	*11.08.2006 16:04 ->�������� ������ ������
	CREATE CURSOR (lcUniqueName) ( ;
		CltID I, CltNM C(1), CltFullNM C(1), CltINN C(1) ;
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

*10.08.2005 16:55 -> ������� ����
USE IN IIF(USED(lcUniqueName),lcUniqueName,0)
*------------------------------------------------------------------------------

*10.08.2005 14:58 -> ����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*10.08.2005 14:58 -> ������ ��������
RETURN lcUniqueName
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: spTovarView()
* Called by.......: <NA>
* Parameters......: <tcQryParSID>
* Returns.........: <lcUniqueFileName>
* Notes...........: �������� �������
*------------------------------------------------------------------------------
PROCEDURE spTovarView
LPARAMETERS tcQryParSID

*29.07.2005 10:48 -> ���������� � ������������� ����������
LOCAL	lcOldAlias, ;
		lcUniqueName, ;
		lcUniqueFilePath, ;
		lcFilterExpr, ;
		lcAliasListToClose, ;
		luQryParTvrNMEnabled, ;
		luQryParTvrNM, ;
		luQryParTvrTLUEnabled, ;
		luQryParTvrTLU, ;
		luQryParTvrIDEnabled, ;
		luQryParTvrID, ;
		luQryParTvrPrcEnabled, ;
		luQryParTvrPrc, ;
		luQryParCltMakerEnabled, ;
		luQryParCltMakerIDTableNM, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcOldAlias = ALIAS()
lcUniqueName = [_t] + SYS(2015)
lcUniqueFilePath = [tmp\] + lcUniqueName + [.DBF]
lcFilterExpr = [WHERE 0=1]
lcAliasListToClose = []
*------------------------------------------------------------------------------

*29.07.2005 10:49 -> ������ ���������
IF PCOUNT()=1 AND TYPE([oQryParMgr])==[O] AND !ISNULL(oQryParMgr)

	*29.07.2005 11:07 -> ������������� �������
	lcFilterExpr = [WHERE 0<>1]
	*------------------------------------------------------------------------------
	
	*29.07.2005 11:08 -> ��������� ������ (������������ ������)
	luQryParTvrNMEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplTvrNMEnabled])
	***
	IF !ISNULL(luQryParTvrNMEnabled) AND TYPE([luQryParTvrNMEnabled])==[L] AND luQryParTvrNMEnabled

		*29.07.2005 11:10 -> ������� ������������ ������
		luQryParTvrNM = oQryParMgr.ParamGet(tcQryParSID,[qpcTvrNM])
		***
		IF !ISNULL(luQryParTvrNM) AND TYPE([luQryParTvrNM])==[C]

			*29.07.2005 11:12 -> ��������� �������
			lcFilterExpr = lcFilterExpr + [ AND UPPER(Tovar.TvrNM) LIKE '%] + UPPER(ALLTRIM(luQryParTvrNM)) + [%']
			*------------------------------------------------------------------------------

		ENDIF
		*------------------------------------------------------------------------------

	ENDIF
	*------------------------------------------------------------------------------

	*29.07.2005 11:08 -> ��������� ������ (��� ������)
	luQryParTvrIDEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplTvrIDEnabled])
	***
	IF !ISNULL(luQryParTvrIDEnabled) AND TYPE([luQryParTvrIDEnabled])==[L] AND luQryParTvrIDEnabled

		*29.07.2005 11:10 -> ������� ��� ������
		luQryParTvrID = oQryParMgr.ParamGet(tcQryParSID,[qpnTvrID])
		***
		IF !ISNULL(luQryParTvrID) AND TYPE([luQryParTvrID])==[N]

			*29.07.2005 11:12 -> ��������� �������
			lcFilterExpr = lcFilterExpr + [ AND Tovar.TvrID = ] + ALLTRIM(STR(luQryParTvrID))
			*------------------------------------------------------------------------------

		ENDIF
		*------------------------------------------------------------------------------

	ENDIF
	*------------------------------------------------------------------------------

	*29.07.2005 11:08 -> ��������� ������ (�����-��� ������)
	luQryParTvrTLUEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplTvrTLUEnabled])
	***
	IF !ISNULL(luQryParTvrTLUEnabled) AND TYPE([luQryParTvrTLUEnabled])==[L] AND luQryParTvrTLUEnabled

		*29.07.2005 11:10 -> ������� �����-��� ������
		luQryParTvrTLU = oQryParMgr.ParamGet(tcQryParSID,[qpcTvrTLU])
		***
		IF !ISNULL(luQryParTvrTLU) AND TYPE([luQryParTvrTLU])==[C]

			*29.07.2005 11:12 -> ��������� �������
			lcFilterExpr = lcFilterExpr + [ AND UPPER(TvrLookUp.TLU) LIKE '%] + UPPER(ALLTRIM(luQryParTvrTLU)) + [%']
			*------------------------------------------------------------------------------

		ENDIF
		*------------------------------------------------------------------------------

	ENDIF
	*------------------------------------------------------------------------------

	*29.07.2005 11:08 -> ��������� ������ (���� ������)
	luQryParTvrPrcEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplTvrPrcEnabled])
	***
	IF !ISNULL(luQryParTvrPrcEnabled) AND TYPE([luQryParTvrPrcEnabled])==[L] AND luQryParTvrPrcEnabled

		*29.07.2005 11:10 -> ������� ���� ������
		luQryParTvrPrc = oQryParMgr.ParamGet(tcQryParSID,[qpnTvrPrc])
		***
		IF !ISNULL(luQryParTvrPrc) AND TYPE([luQryParTvrPrc])==[N]

			*29.07.2005 11:12 -> ��������� �������
			lcFilterExpr = lcFilterExpr + [ AND Price.Price = ] + ALLTRIM(STR(luQryParTvrPrc))
			*------------------------------------------------------------------------------

		ENDIF
		*------------------------------------------------------------------------------

	ENDIF
	*------------------------------------------------------------------------------

	*29.07.2005 11:08 -> ��������� ������ (����� �������������)
	luQryParCltMakerEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplCltMakerEnabled])
	***
	IF !ISNULL(luQryParCltMakerEnabled) AND TYPE([luQryParCltMakerEnabled])==[L] AND luQryParCltMakerEnabled
		
		*29.07.2005 11:10 -> ������� ��� ��������� ������� � ���������������� ��������������
		luQryParCltMakerIDTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcCltMakerIDTableNM])
		***
		IF !ISNULL(luQryParCltMakerIDTableNM) AND TYPE([luQryParCltMakerIDTableNM])==[C] AND FILE([tmp\]+luQryParCltMakerIDTableNM+[.dbf])

			*10.04.2006 11:35 -> ���������� ������
			lcFilterExpr = lcFilterExpr + ;
							[ AND Tovar.MakerCltID IN (] + spGetTmpValueList(luQryParCltMakerIDTableNM) + [)]
			*------------------------------------------------------------------------------

		ENDIF
		*------------------------------------------------------------------------------		

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
		[EXECUTE spTovarView ?lcFilterExpr],lcUniqueName)
ENDDO
***
IF lnSqlExeResult = -1

	*11.08.2006 16:18 ->������� ���������� ������
	spHandleODBCError()
	*------------------------------------------------------------------------------

	*11.08.2006 16:18 ->�������� ������ ������
	CREATE CURSOR (lcUniqueName) ( ;
		TvrID I, TvrNM C(1), TLU C(1), Price Y, MakerNM C(1) ;
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

*27.07.2005 12:19 -> ������� ����
USE IN IIF(USED(lcUniqueName),lcUniqueName,0)
*------------------------------------------------------------------------------

*27.07.2005 11:56 -> ����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*21.04.2004 14:27 ->������ ��������
RETURN lcUniqueName
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: spTvrConstraintView()
* Called by.......: <NA>
* Parameters......: <tcQryParSID>
* Returns.........: <lcUniqueName>
* Notes...........: �������� ����������� ��������� ������������
*------------------------------------------------------------------------------
PROCEDURE spTvrConstraintView
LPARAMETERS tcQryParSID

*27.09.2005 09:28 ->���������� � ������������� ����������
LOCAL	lcOldAlias, ;
		lcFilterExpr, ;
		lcUniqueName, ;
		lcUniqueFilePath, ;
		luTvrID, ;
		luQryParTvrEnabled, ;
		luQryParTvrIDTableNM, ;
		luQryParOUEnabled, ;
		luQryParOUIDTableNM
***
lcOldAlias = ALIAS()
lcFilterExpr = [WHERE 0<>1]
lcUniqueName = [_d] + SYS(2015)
lcUniqueFilePath = [tmp\] + lcUniqueName + [.DBF]
*------------------------------------------------------------------------------

*25.05.2005 16:46 ->������ ������������� �������� �����
luTvrID = oQryParMgr.ParamGet(tcQryParSID,[TvrID])
***
IF TYPE([luTvrID]) == [N] AND !EMPTY(luTvrID) AND !ISNULL(luTvrID)
	lcFilterExpr = [WHERE TvrConstraint.TvrID = ] + ALLTRIM(STR(luTvrID))
ENDIF
*------------------------------------------------------------------------------

*19.09.2005 15:33 -> ��������, ���������� ������� ������� ��� ������
DO CASE
	CASE TYPE([tcQryParSID])==[C] AND tcQryParSID==[NODATA]
		lcFilterExpr = [WHERE 0=1]

	CASE TYPE([tcQryParSID])==[C]

		*19.01.2005 17:07 -> ��������� ������ (����� �������)
		luQryParTvrEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplTvrEnabled])
		***
		IF !ISNULL(luQryParTvrEnabled) AND TYPE([luQryParTvrEnabled])==[L] AND luQryParTvrEnabled

			*19.01.2005 17:08 -> ������� ��� ������� � ���������������� ����� ����������
			luQryParTvrIDTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcTvrIDTableNM])
			***
			IF !ISNULL(luQryParTvrIDTableNM) AND TYPE([luQryParTvrIDTableNM])==[C] AND FILE([tmp\]+luQryParTvrIDTableNM+[.dbf])

				*10.04.2006 11:35 -> ���������� ������
				lcFilterExpr = [WHERE TvrConstraint.TvrID IN (] + spGetTmpValueList(luQryParTvrIDTableNM) + [)]
				*------------------------------------------------------------------------------

			ENDIF
			*------------------------------------------------------------------------------
			
		ENDIF
		*------------------------------------------------------------------------------

	CASE TYPE([tcQryParSID])==[N]
		lcFilterExpr = [WHERE TvrConstraint.TvrCID = ] + ALLTRIM(STR(tcQryParSID))
ENDCASE
*------------------------------------------------------------------------------

*19.06.2006 11:26 ->��������� ������ �� �������������
luQryParOUEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplOUEnabled])
***
IF !ISNULL(luQryParOUEnabled) AND TYPE([luQryParOUEnabled])==[L] AND luQryParOUEnabled

	*19.06.2006 11:26 ->������� ��� ������� � ���������������� �������������
	luQryParOUIDTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcOUIDTableNM])
	***
	IF !ISNULL(luQryParOUIDTableNM) AND TYPE([luQryParOUIDTableNM])==[C] AND FILE([tmp\]+luQryParOUIDTableNM+[.dbf])

		*10.04.2006 11:35 -> ���������� ������
		lcFilterExpr = lcFilterExpr + ;
						[ AND TvrConstraint.OUID IN (] + spGetTmpValueList(luQryParOUIDTableNM) + [)]
		*------------------------------------------------------------------------------

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
		[EXECUTE spTvrConstraintView ?lcFilterExpr],lcUniqueName)
ENDDO
***
IF lnSqlExeResult = -1

	*11.08.2006 16:19 ->������� ���������� ������
	spHandleODBCError()
	*------------------------------------------------------------------------------

	*11.08.2006 16:19 ->�������� ������ ������
	CREATE CURSOR (lcUniqueName) ( ;
		TvrCID I, TvrID I, TvrNM C(1), OUNM C(1), MsuNM C(1), TvrMinQnt I, TvrMaxQnt I, TvrCurQnt I ;
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

*27.07.2005 11:56 -> ����������� ������� Alias
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

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spTvrConstraintReport()
* Called by.......: <NA>
* Parameters......: <tcQryParSID>
* Returns.........: <lcUniqueName>
* Notes...........: ������� ��� ������ "�������������� �������"
*------------------------------------------------------------------------------
PROCEDURE spTvrConstraintReport
LPARAMETERS tcQryParSID

*19.06.2006 10:26 ->���������� � ������������� ����������
LOCAL	lcOldAlias, ;
		lcUniqueName
***
lcOldAlias = ALIAS()
*------------------------------------------------------------------------------

*19.06.2006 10:18 ->������� ������ ��� ������
lcUniqueName = spTvrConstraintView(tcQryParSID)
*------------------------------------------------------------------------------

*19.06.2006 10:19 ->��������� ������������� �������
SELECT ;
	tmpTvrConstr.TvrID, ;
	tmpTvrConstr.TvrNM, ;
	tmpTvrConstr.OUNM, ;
	tmpTvrConstr.MsuNM, ;
	tmpTvrConstr.TvrMinQnt, ;
	tmpTvrConstr.TvrMaxQnt, ;
	tmpTvrConstr.TvrCurQnt ;
FROM ([tmp\]+lcUniqueName) tmpTvrConstr ;
WHERE tmpTvrConstr.TvrMinQnt > tmpTvrConstr.TvrCurQnt ;
INTO TABLE tmp\RptItog
*------------------------------------------------------------------------------

*19.06.2006 10:24 ->��������� �������
USE IN IIF(USED(lcUniqueName),lcUniqueName,0)
USE IN SELECT([RptItog])
*------------------------------------------------------------------------------

*19.06.2006 10:26 ->����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*19.06.2006 10:26 ->������ ��������
RETURN [PrtItog.dbf]
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spAccChangePrc()
* Called by.......: <NA>
* Parameters......: <tnTvrID, tnNewPrcBuy>
* Returns.........: <none>
* Notes...........: ��������� ���� �� ���� ������������
*------------------------------------------------------------------------------
PROCEDURE spAccChangePrc
LPARAMETERS tnTvrID, tnNewPrcBuy

*24.08.2005 14:15 -> ���������� � ������������� ����������
LOCAL	lnSqlExeResult, ;
		llResult
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ������ ���� �� ���� ������������
lnSqlExeResult = 0
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[UPDATE ] + ;
			[FrmPartTvr ] + ;
		[SET TvrPrcBuy = ?tnNewPrcBuy ] + ;
		[WHERE FrmPartTvr.TvrID = ?tnTvrID AND FrmPartTvr.FrmID IN (SELECT Form.FrmID FROM Form WHERE Form.FrmTypeID = 19)])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN 0
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

ENDPROC
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: spSetTvrDisc()
* Called by.......: <NA>
* Parameters......: <tnTovarID,tnDiscID>
* Returns.........: <none>
* Notes...........: ��������� ������ �� �����/������ �������
*-------------------------------------------------------
PROCEDURE spSetTvrDisc
LPARAMETERS tnTovarID,tnDiscID

*24.08.2005 14:15 -> ���������� � ������������� ����������
LOCAL	lnSqlExeResult, ;
		llResult
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ��������� ������ �� �����/������ �������
lnSqlExeResult = 0
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE spSetTvrDisc ?tnTovarID, ?tnDiscID])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN 0
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: _spMainMarked()
* Called by.......: <NA>
* Parameters......: <tcTableNM, tcFieldNameFlag, tcFieldNameID, tnID>
* Returns.........: <none>
* Notes...........: �������� ������������ ����� "��������"
*-------------------------------------------------------
PROCEDURE _spMainMarked
LPARAMETERS	tcTableNM, tcFieldNameFlag, tcFieldNameID, tnID

*24.08.2005 14:15 -> ���������� � ������������� ����������
LOCAL	lcFilterExpr, ;
		lcQuery, ;
		lnSqlExeResult, ;
		llResult
***
lcFilterExpr = [WHERE ] + tcFieldNameFlag + [ = 1]
*------------------------------------------------------------------------------

*24.08.2005 14:16 -> ������������� �������������� ������
IF PCOUNT()=4
	lcFilterExpr = lcFilterExpr + [ AND ] + tcFieldNameID + [ = ?tnID]
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:44 -> ��������� ������ � ��
lcQuery = [SELECT ] + tcFieldNameFlag + [ FROM ] + tcTableNM + [ ] + lcFilterExpr
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ��������� ������
lnSqlExeResult = 0
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		lcQuery,[tmp])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN 0
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:46 -> �������� ���������
llResult = RECCOUNT([tmp]) > 0
*------------------------------------------------------------------------------

*07.04.2006 16:46 -> ������� ������
USE IN tmp
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ���������� ���������
RETURN llResult
*------------------------------------------------------------------------------

ENDPROC
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spUserClt()
* Called by.......: <Form Data Request>
* Parameters......: <lnResType>
* Returns.........: <luCltInfo>
* Notes...........: ��������� ����(��������������) ���������� �� ���� ������������
*-------------------------------------------------------
PROCEDURE spUserClt
LPARAMETERS tnResType, tnUserID

*06.04.2006 18:07 ->���������� � ������������� ����������
LOCAL	luCltInfo, ;
		lnUserID
*------------------------------------------------------------------------------

*30.05.2006 17:21 -> ��������� ���������� ������������� ������������
IF TYPE([tnUserID])=[N] AND !EMPTY(tnUserID)
	lnUserID = tnUserID
ELSE
	lnUserID = oApp.nUserKod
ENDIF
*-------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ������� ��� ���������� �� ���� User-a
lnSqlExeResult = 0
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[SELECT ] + ;
			[AppUser.UserCltID, ] + ;
			[ISNULL(Client.CltNM,'') AS UserCltNM ] + ;
		[FROM AppUser ] + ;
		[LEFT JOIN Client ON Client.CltID = AppUser.UserCltID ] + ;
		[WHERE AppUser.UserID = ?lnUserID], ;
		[curCltByUser])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN 0
ENDIF
*------------------------------------------------------------------------------

*11.04.2006 10:58 -> �������� ���������� � �������
IF TYPE([tnResType])=[N] AND tnResType=1
	luCltInfo = IIF(RECCOUNT([curCltByUser])>0,ALLTRIM(curCltByUser.UserCltNM),[])
ELSE
	luCltInfo = IIF(RECCOUNT([curCltByUser])>0,curCltByUser.UserCltID,0)
ENDIF
*------------------------------------------------------------------------------

*11.04.2006 10:58 ->������� ������
USE IN SELECT([curCltByUser])
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*11.04.2006 10:59 ->������ ���������
RETURN luCltInfo
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spFillCorr()
* Called by.......: <Form Data Request>
* Parameters......: <tnFrmID>
* Returns.........: <none>
* Notes...........: ���������� ��������������� ���������
*-------------------------------------------------------
PROCEDURE spFillCorr
LPARAMETERS tnFrmID

*08.09.2006 11:25 ->���������� � ������������� ����������
LOCAL	lnConnectHandle, ;
		lnSqlExeResult, ;
		llResult
*------------------------------------------------------------------------------

*08.09.2006 11:25 ->����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*08.09.2006 11:25 ->����������� �������������� ���������
lnSqlExeResult = 0
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE spFillCorr ?tnFrmID])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN 0
ENDIF
*------------------------------------------------------------------------------

*08.09.2006 11:26 ->������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spFrmAccCardReport()
* Called by.......: <When Document Printed>
* Parameters......: <tcQryParSID>
* Returns.........: <������ ��������� ������, ��������� ��� ������>
* Notes...........: ������� ��� ������ ��������������� ���� �� ����� ������������
*------------------------------------------------------------------------------
PROCEDURE spFrmAccCardReport
LPARAMETERS tcQryParSID

*11.05.2005 12:53 -> ���������� � ������������� ����������
LOCAL	lnFrmID, ;
		lnConnectHandle, ;
		lnSqlExeResult
*------------------------------------------------------------------------------

*11.05.2005 12:54 -> ������ ���������
IF TYPE([oQryParMgr])==[O] AND !ISNULL(oQryParMgr)

	*26.05.2004 21:18 -> ������ ������������� ���������, ������� ����� ��������
	lnFrmID = oQryParMgr.ParamGet(tcQryParSID,[FrmID])
	*------------------------------------------------------------------------------
	
ENDIF
*------------------------------------------------------------------------------
			
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
		[EXECUTE spFrmAccCardReport ?lnFrmID],[RptItogHD])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*13.04.2006 14:03 -> �������� ������ �������������� �������
lnSqlExeResult = SQLMORERESULTS(lnConnectHandle,[RptItogDT])
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
SQLMORERESULTS(lnConnectHandle)
*------------------------------------------------------------------------------


*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> �������� ������� �� ���� � �������
SELECT RptItogHD
COPY TO tmp\RptItogHD.dbf
***
SELECT RptItogDT
COPY TO tmp\RptItogDT.dbf
***
USE IN SELECT([RptItogHD])
USE IN SELECT([RptItogDT])

*24.04.2006 13:59 -> ������� ����������� �� ���� �������
USE tmp\RptItogHD IN 0
USE tmp\RptItogDT IN 0
*------------------------------------------------------------------------------

*04.09.2006 11:44 -> �������� ������ ��� Relation-�
SELECT RptItogHD
INDEX ON FrmID TAG FrmID OF tmp\RptItogHD
*------------------------------------------------------------------------------

*05.08.2004 15:42 -> �������� ������ ��������������� ��������, ������������� � ���������
SELECT ;
	RptItogHD.OwnCltID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.DevCltID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.ExIspCltID AS ID ;
FROM RptItogHD ;
UNION ;
SELECT ;
	RptItogHD.CntCltID AS ID ;
FROM RptItogHD ;
INTO TABLE tmp\tmpCltIdList
*------------------------------------------------------------------------------

*05.08.2004 15:54 ->������� ��������� ������ �� ��������
spClientInfoExpand([tmpCltIdList],[RptCltInfo])
*------------------------------------------------------------------------------

*22.07.2004 20:50 -> ������ ������ ��������� ������, ��������� ��� ������
RETURN [RPTITOGHD.DBF;RPTITOGHD.CDX;RPTITOGDT.DBF;RptCltInfo.dbf;RptCltInfo.cdx]
*------------------------------------------------------------------------------

ENDPROC
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*******************************************************************************
* ��������� ��� ������� �� ��������
PROCEDURE __________SALES_PROCEDURES__________
ENDPROC
******************************************************************************

*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spSaleReport()
* Called by.......: <NA>
* Parameters......: <tcQryParSID,tlDiscCardInfo>
* Returns.........: <none>
* Notes...........: ������������ ������� ��� ������ � ��������
*-------------------------------------------------------
PROCEDURE spSaleReport
LPARAMETERS tcQryParSID,tlDiscCardInfo 

*21.07.2005 12:13 -> ���������� � ������������� ����������
LOCAL	lcOldDate, ;
		lcOldCentury, ;
		lcOldMark, ;
		lcOldAlias, ;
		lcFilterExpr, ;
		lcFilterExprTvr, ;
		lcFilterExprCheckType, ;
		luQryParDateEnabled, ;
		luQryParDateStartDate, ;
		luQryParDateEndDate, ;
		luQryParTvrEnabled, ;
		luQryParTvrIDTableNM, ;
		luQryParTvrGrpEnabled, ;
		lcQryParTvrIDTableNM, ;
		luQryParCheckTypeAborted, ;
		luQryParIsAbortedCheck, ;
		luQryParCashEnabled, ;
		luQryParCashTableNM, ;
		luQryParCashierEnabled, ;
		luQryParCashierTableNM, ;
		luQryParCheckTypeEnabled, ;
		luQryParCheckTypeTableNM
***
lcOldDate = SET([DATE])
lcOldCentury = SET([CENTURY])
lcOldMark = SET([MARK])
lcOldAlias = ALIAS()
lcFilterExpr = [WHERE 0<>1]
lcFilterExprTvr		  = []
lcFilterExprCheckType = []
*------------------------------------------------------------------------------

*28.11.2005 13:39 ->���� ����������� ������� ��� ������ �� ���������� ������, �� ��������� �������������� ������
IF tlDiscCardInfo
	lcFilterExpr = lcFilterExpr + [ AND NOT CheckSale.DiscCardID IS NULL]
ENDIF
*------------------------------------------------------------------------------

*21.07.2005 12:13 ->���������� ��������� ������������, ���� ���������� �������� ����������
IF TYPE([oQryParMgr])==[O] AND !ISNULL(oQryParMgr)
	
	*21.07.2005 15:37 ->������� ������� � ���������� ��� ������
	CREATE TABLE tmp\RptEnv FREE (QryParSID C(10), QryTypeNM C(40))
	INSERT INTO RptEnv (QryParSID) VALUES (tcQryParSID)
	*------------------------------------------------------------------------------
	
	*21.07.2005 12:13 ->��������� ������ �� ����
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

	*14.06.2006 15:47 ->��������� ������ (����� �������)
	luQryParTvrEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplTvrEnabled])
	***
	IF !ISNULL(luQryParTvrEnabled) AND TYPE([luQryParTvrEnabled])==[L] AND luQryParTvrEnabled
				
		*14.06.2006 15:47 ->������� ��� ��������� ������� � ���������������� ������� 
		luQryParTvrIDTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcTvrIDTableNM])
		***
		IF !ISNULL(luQryParTvrIDTableNM) AND TYPE([luQryParTvrIDTableNM])==[C] AND FILE([tmp\]+luQryParTvrIDTableNM+[.dbf])

			*10.04.2006 11:35 -> ���������� ������
			lcFilterExprTvr = lcFilterExprTvr + ;
							[ AND Tovar.TvrID IN (] + spGetTmpValueList(luQryParTvrIDTableNM) + [)]
			*------------------------------------------------------------------------------

		ENDIF
		*------------------------------------------------------------------------------		
				
	ENDIF
	*------------------------------------------------------------------------------

	*28.09.2005 10:09 -> ��������� ������ (����� ����� �������)
	luQryParTvrGrpEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplTvrGrpEnabled])
	***
	IF !ISNULL(luQryParTvrGrpEnabled) AND TYPE([luQryParTvrGrpEnabled])==[L] AND luQryParTvrGrpEnabled

		*28.09.2005 10:16 -> ������� ��� ������� � ���������������� ����� �������
		luQryParTvrGrpTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcTvrGrpTableNM])
		***
		IF !ISNULL(luQryParTvrGrpTableNM) AND TYPE([luQryParTvrGrpTableNM])==[C] AND FILE([tmp\]+luQryParTvrGrpTableNM+[.dbf])

			*10.04.2006 11:35 -> ���������� ������
			lcFilterExprTvr = lcFilterExprTvr + ;
							[ AND Tovar.TvrID IN (SELECT ID FROM GetTvrIDInSelectedTvrGrp('] + spGetTmpValueList(luQryParTvrGrpTableNM) + [') WHERE IsCnt = 0)]
			*------------------------------------------------------------------------------

		ENDIF
		*------------------------------------------------------------------------------
		
	ENDIF
	*------------------------------------------------------------------------------

	*21.07.2005 12:13 ->��������� ������ �� ���������� �����
	luQryParCheckTypeAborted = oQryParMgr.ParamGet(tcQryParSID,[qplCheckTypeAborted])
	***
	IF !ISNULL(luQryParCheckTypeAborted) AND TYPE([luQryParCheckTypeAborted])==[L] AND luQryParCheckTypeAborted
		luQryParIsAbortedCheck = oQryParMgr.ParamGet(tcQryParSID,[qplAborted])
		IF !ISNULL(luQryParIsAbortedCheck) AND TYPE([luQryParIsAbortedCheck])==[L] AND luQryParIsAbortedCheck
			lcFilterExpr = lcFilterExpr+[ AND CheckType.CheckTypeAborted=1]
		ELSE
			lcFilterExpr = lcFilterExpr+[ AND CheckType.CheckTypeAborted=0]
		ENDIF
	ENDIF
	*------------------------------------------------------------------------------

	*02.08.2005 09:08 ->��������� ������ �� �����
	luQryParCashEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplCashEnabled])
	***
	IF !ISNULL(luQryParCashEnabled) AND TYPE([luQryParCashEnabled])==[L] AND luQryParCashEnabled
		luQryParCashTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcCashTableNM])
		IF !ISNULL(luQryParCashTableNM) AND TYPE([luQryParCashTableNM])==[C] AND FILE(luQryParCashTableNM+[.dbf])

			*10.04.2006 11:35 -> ���������� ������
			lcFilterExpr = lcFilterExpr + ;
							[ AND CheckSale.CheckCashID IN (] + spGetTmpValueList(luQryParCashTableNM) + [)]
			*------------------------------------------------------------------------------

		ENDIF
	ENDIF
	*------------------------------------------------------------------------------

	*02.08.2005 09:08 ->��������� ������ �� �������
	luQryParCashierEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplCashierEnabled])
	***
	IF !ISNULL(luQryParCashierEnabled) AND TYPE([luQryParCashierEnabled])==[L] AND luQryParCashierEnabled
		luQryParCashierTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcCashierTableNM])
		IF !ISNULL(luQryParCashierTableNM) AND TYPE([luQryParCashierTableNM])==[C] AND FILE(luQryParCashierTableNM+[.dbf])

			*10.04.2006 11:35 -> ���������� ������
			lcFilterExpr = lcFilterExpr + ;
							[ AND CheckSale.CheckCashierID IN (] + spGetTmpValueList(luQryParCashierTableNM) + [)]
			*------------------------------------------------------------------------------

		ENDIF
	ENDIF
	*------------------------------------------------------------------------------

	*01.12.2005 11:12 ->��������� ������ �� ����� �����
	luQryParCheckTypeEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplCheckTypeEnabled])
	***
	IF !ISNULL(luQryParCheckTypeEnabled) AND TYPE([luQryParCheckTypeEnabled])==[L] AND luQryParCheckTypeEnabled
		luQryParCheckTypeTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcCheckTypeTableNM])
		IF !ISNULL(luQryParCheckTypeTableNM) AND TYPE([luQryParCheckTypeTableNM])==[C] AND FILE(luQryParCheckTypeTableNM+[.dbf])

			*10.04.2006 11:35 -> ���������� ������
			lcFilterExprCheckType = lcFilterExprCheckType + ;
							[ AND CheckSale.CheckTypeID IN (] + spGetTmpValueList(luQryParCheckTypeTableNM) + [)]
			*------------------------------------------------------------------------------

		ENDIF
	ENDIF
	*------------------------------------------------------------------------------
	
ENDIF
*------------------------------------------------------------------------------

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
		[EXECUTE spSaleReport ?lcFilterExpr, ?lcFilterExprTvr, ?lcFilterExprCheckType],[tmpRptItog])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*13.04.2006 14:03 -> �������� ������ �������������� �������
SQLMORERESULTS(lnConnectHandle,[tmpRptCheckType])
SQLMORERESULTS(lnConnectHandle)
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*28.11.2005 12:16 -> �������� ������� �� ���� � �������
SELECT tmpRptCheckType
COPY TO tmp\tmpRptCheckType.dbf
***
SELECT tmpRptItog
COPY TO tmp\tmpRptItog.dbf
***
USE IN SELECT([tmpRptCheckType])
USE IN SELECT([tmpRptItog])
*------------------------------------------------------------------------------

*30.06.2006 16:11 -> ������� ����� � �������� �������������� �������
USE tmp\tmpRptCheckType.dbf IN 0
USE tmp\tmpRptItog.dbf IN 0
***
SELECT tmpRptCheckType
INDEX ON CheckTID TAG CheckTID
***
SELECT tmpRptItog
INDEX ON CheckDate TAG CheckDate
INDEX ON TvrID TAG TvrID ADDITIVE
INDEX ON TvrNM TAG TvrNM ADDITIVE
INDEX ON DTOC(CheckDate,1)+PADL(ALLTRIM(STR(CheckNo)),6,[0]) TAG ChkOrder ADDITIVE
INDEX ON CheckHour TAG CheckHour ADDITIVE
*------------------------------------------------------------------------------

*28.11.2005 12:16 ->����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*21.04.2004 14:27 -> ������ ��������
RETURN [tmpRptItog.dbf;tmpRptItog.cdx;tmpRptCheckType.dbf;tmpRptCheckType.cdx;RptEnv.dbf]
*------------------------------------------------------------------------------

ENDPROC
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spSaleDiscCardReport()
* Called by.......: <NA>
* Parameters......: <tcQryParSID>
* Returns.........: <none>
* Notes...........: ������������ ������� ��� ������ �� ���������� ������
*------------------------------------------------------------------------------
PROCEDURE spSaleDiscCardReport
LPARAMETERS tcQryParSID

*28.11.2005 13:27 ->���������� � ������������� ����������
LOCAL   lcOldAlias, ;
		lcHavingExpr, ;
		luQryParRangeEnabled, ;
		luQryParRangeSign, ;
		luQryParRangeValue, ;
		lcResult
***
lcOldAlias   = ALIAS()
lcHavingExpr = []		
*------------------------------------------------------------------------------

*21.07.2005 12:13 ->���������� ��������� ������������, ���� ���������� �������� ����������
IF TYPE([oQryParMgr])==[O] AND !ISNULL(oQryParMgr)
	
	*29.11.2005 10:33 ->��������� ������ ��� ����������� ������������� ����� ������
	luQryParRangeEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplRangeDiscEnabled])
	*------------------------------------------------------------------------------
	
	*29.11.2005 10:38 ->���������
	IF !ISNULL(luQryParRangeEnabled) AND TYPE([luQryParRangeEnabled])==[L] AND luQryParRangeEnabled
 
		*29.11.2005 10:30 ->������� ���� ��������� � ��������
		luQryParRangeSign	= oQryParMgr.ParamGet(tcQryParSID,[qpcRangeSign])
		luQryParRangeValue	= oQryParMgr.ParamGet(tcQryParSID,[qpnRangeValue])
		*------------------------------------------------------------------------------
			
		*29.11.2005 10:33 ->��������� �������
		lcHavingExpr = [HAVING SUM(ROUND(MTON(tmpRptItog.SumTran),2)) ]+luQryParRangeSign+ALLTRIM(STR(luQryParRangeValue,20,2))
		*------------------------------------------------------------------------------
		
	ENDIF
	*------------------------------------------------------------------------------
	
ENDIF
*------------------------------------------------------------------------------

*28.11.2005 13:27 ->���������� ������� � ������� � �������� �� �������� �� ���������� ������
lcResult = spSaleReport(tcQryParSID,.T.)
*------------------------------------------------------------------------------

*28.11.2005 13:34 ->��������� ����� ���������� �� ���������� ������
SELECT ;
	MAX(tmpRptItog.CheckDate)	AS CheckDate, ;
	tmpRptItog.DiscCardID, ;
	tmpRptItog.DiscCardNo, ;
	SUM(tmpRptItog.SumTran)	  AS AccumSum, ;
	SUM(tmpRptItog.SumTranWD) AS AccumSumWD, ;
	SUM(tmpRptItog.SumDisc)	  AS AccumSisc, ;
	NVL(Client.CltNM,SPACE(40))	AS CltNM ;
FROM tmpRptItog ;
LEFT JOIN DiscCard	ON DiscCard.DiscCardID = tmpRptItog.DiscCardID ;
LEFT JOIN Client	ON Client.CltID = DiscCard.CltID ;
WHERE !tmpRptItog.IsAborted ;
GROUP BY 2,3,7 &lcHavingExpr ;
ORDER BY 4 DESC; 
INTO CURSOR curDiscCardResult NOFILTER
*------------------------------------------------------------------------------

*28.11.2005 13:57 ->��������� ������ � ������� ��� ������
USE IN SELECT([tmpRptItog])
SELECT * FROM curDiscCardResult INTO TABLE tmp\tmpRptItog
*-----------------------------------------------------------------------------

*28.11.2005 13:59 ->������� ������
USE IN SELECT([curDiscCardResult])
*------------------------------------------------------------------------------

*28.11.2005 13:28 ->����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
   SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*21.04.2004 14:27 -> ������ ��������
RETURN lcResult
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spTop100SaleReport()
* Called by.......: <NA>
* Parameters......: <tcQryParSID>
* Returns.........: <none>
* Notes...........: ������� ��� ������� Top100
*------------------------------------------------------------------------------
PROCEDURE spTop100SaleReport
LPARAMETERS tcQryParSID

*30.11.2005 11:17 ->���������� � ������������� ����������
LOCAL	lcOldAlias, ;
		luTop100Enabled, ;
		luQryParTop100Order, ;
		lcGroupExpr, ;
		lcQryInfo, ;
		lcResult
***
lcOldAlias			= ALIAS()
luQryParTop100Order = 0
lcGroupExpr			= [ORDER BY 4 DESC]
lcQryInfo			= [100 MAX ������ �� �����]
*------------------------------------------------------------------------------

*30.11.2005 11:16 ->���������� ��������� ������������, ���� ���������� �������� ����������
IF TYPE([oQryParMgr])==[O] AND !ISNULL(oQryParMgr)
	
	*30.11.2005 11:16 ->��������� ������ ��� ����������� ������������� ����� ������
	luTop100Enabled = oQryParMgr.ParamGet(tcQryParSID,[qplTop100Enabled])
	*------------------------------------------------------------------------------
	
	*29.11.2005 10:38 ->���������
	IF !ISNULL(luTop100Enabled) AND TYPE([luTop100Enabled])==[L] AND luTop100Enabled
 
		*29.11.2005 10:30 ->��� �������
		luQryParTop100Order	= oQryParMgr.ParamGet(tcQryParSID,[qpnTop100Order])
		*------------------------------------------------------------------------------
		
		*30.11.2005 12:03 ->���������� ���������� ��� �������������� �������
		DO CASE
			CASE luQryParTop100Order = 2 && MAX �� ����������
				lcGroupExpr = [ORDER BY 6 DESC]
				lcQryInfo	= [100 MAX ������ �� ����������]
			CASE luQryParTop100Order = 3 && MIN �� �����
				lcGroupExpr = [ORDER BY 4]
				lcQryInfo	= [100 MIN ������ �� �����]
			CASE luQryParTop100Order = 4 && MIN �� ����������
				lcGroupExpr = [ORDER BY 6]
				lcQryInfo	= [100 MIN ������ �� ����������]
		ENDCASE	
		*------------------------------------------------------------------------------
		
	ENDIF
	*------------------------------------------------------------------------------
	
ENDIF
*------------------------------------------------------------------------------

*28.11.2005 13:27 ->���������� ������� � ������� � �������� �� �������� �� ���������� ������
lcResult = spSaleReport(tcQryParSID)
*------------------------------------------------------------------------------

*30.11.2005 12:08 ->�������� �������������� �������� ������
UPDATE RptEnv SET QryTypeNM = lcQryInfo
*------------------------------------------------------------------------------

*30.11.2005 11:24 ->��������� ������� ��� �������
SELECT TOP 100 ;
	tmpRptItog.TvrID, ;
	tmpRptItog.TvrNM, ;
	SUM(tmpRptItog.SumTran)		AS SumTran, ;
	SUM(tmpRptItog.SumTranWD)	AS SumTranWD, ;
	SUM(tmpRptItog.SumDisc)		AS SumDisc, ;
	SUM(tmpRptItog.TvrQnt)		AS TvrQnt;
FROM tmpRptItog ;
WHERE !tmpRptItog.IsAborted AND tmpRptItog.TvrQnt > 0 ;
GROUP BY 1,2 ;
&lcGroupExpr ;
INTO TABLE tmp\tmpRptTop100.dbf
*------------------------------------------------------------------------------

*30.11.2005 11:18 ->����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
   SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*21.04.2004 14:27 -> ������ ��������
RETURN [tmpRptTop100.dbf;] + IIF(TYPE([lcResult])=[C],lcResult,[])
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*------------------------------------------------------------------------------
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

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spCheckView()
* Called by.......: <NA>
* Parameters......: <tcQryParSID>
* Returns.........: <none>
* Notes...........: ������ �����
*------------------------------------------------------------------------------
PROCEDURE spCheckView
LPARAMETERS tcQryParSID

*28.02.2006 12:16 ->���������� � ������������� ����������
LOCAL	lcOldAlias, ;
		lcOldDate, ;
		lcOldCentury, ;
		lcOldMark, ;
		lcUniqueName, ;
		lcUniqueFilePath, ;
		lcFilterExpr, ;
		luQryParDateEnabled, ;
		luQryParDateStartDate, ;
		luQryParDateEndDate, ;
		luQryParCashEnabled, ;
		luQryParCashTableNM, ;
		luQryParCashierEnabled, ;
		luQryParCashierTableNM, ;
		luQryParTvrEnabled, ;
		luQryParTvrIDTableNM, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcOldAlias = ALIAS()
lcOldDate = SET([DATE])
lcOldCentury = SET([CENTURY])
lcOldMark = SET([MARK])
lcFilterExpr   = []
lcUniqueName = [_sl]+SYS(2015)
lcUniqueFilePath = [tmp\] + lcUniqueName + [.DBF]
*------------------------------------------------------------------------------

*07.07.2006 16:38 -> ����� ��������� ������������
WAIT WINDOW [���� ���������� ������...] NOWAIT NOCLEAR
SET MESSAGE TO [���� ���������� ������...]
*------------------------------------------------------------------------------

*28.02.2006 14:52 ->���������� ��������� ������������, ���� ���������� �������� ����������
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
		***
		SET CENTURY ON
		***
		SET MARK TO "/"
		*------------------------------------------------------------------------------

		*26.05.2004 21:27 ->��������� �������
		DO CASE
			CASE	!ISNULL(luQryParDateStartDate) AND TYPE([luQryParDateStartDate])==[D] AND !EMPTY(luQryParDateStartDate) AND ;
					!ISNULL(luQryParDateEndDate) AND TYPE([luQryParDateEndDate])==[D] AND !EMPTY(luQryParDateEndDate)
					*{
					lcFilterExpr = lcFilterExpr + [ AND CheckSale.CheckStamp >= ']+STRTRAN(DTOC(luQryParDateStartDate),[/],[])+[' AND CheckSale.CheckStamp < ']+STRTRAN(DTOC(luQryParDateEndDate+1),[/],[])+[']
					*}
			CASE	!ISNULL(luQryParDateStartDate) AND TYPE([luQryParDateStartDate])==[D] AND !EMPTY(luQryParDateStartDate)
					*{
					lcFilterExpr = lcFilterExpr + [ AND CheckSale.CheckStamp >= ']+STRTRAN(DTOC(luQryParDateStartDate),[/],[])+[']
					*}
			CASE	!ISNULL(luQryParDateEndDate) AND TYPE([luQryParDateEndDate])==[D] AND !EMPTY(luQryParDateEndDate)
					*{
					lcFilterExpr = lcFilterExpr + [ AND CheckSale.CheckStamp < ']+STRTRAN(DTOC(luQryParDateEndDate+1),[/],[])+[']
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

	ENDIF
	*------------------------------------------------------------------------------

	*02.06.2006 11:34 ->��������� ������ �� �����
	luQryParCashEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplCashEnabled])
	***
	IF !ISNULL(luQryParCashEnabled) AND TYPE([luQryParCashEnabled])==[L] AND luQryParCashEnabled
		luQryParCashTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcCashTableNM])
		IF !ISNULL(luQryParCashTableNM) AND TYPE([luQryParCashTableNM])==[C] AND FILE(luQryParCashTableNM+[.dbf])

			*10.04.2006 11:35 -> ���������� ������
			lcFilterExpr = lcFilterExpr+[ AND CheckSale.CheckCashID IN (] + spGetTmpValueList(luQryParCashTableNM) + [)]
			*------------------------------------------------------------------------------

		ENDIF
	ENDIF
	*------------------------------------------------------------------------------

	*02.06.2006 11:34 ->��������� ������ �� �������
	luQryParCashierEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplCashierEnabled])
	***
	IF !ISNULL(luQryParCashierEnabled) AND TYPE([luQryParCashierEnabled])==[L] AND luQryParCashierEnabled
		luQryParCashierTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcCashierTableNM])
		IF !ISNULL(luQryParCashierTableNM) AND TYPE([luQryParCashierTableNM])==[C] AND FILE(luQryParCashierTableNM+[.dbf])

			*10.04.2006 11:35 -> ���������� ������
			lcFilterExpr = lcFilterExpr+[ AND CheckSale.CheckCashierID IN (] + spGetTmpValueList(luQryParCashierTableNM) + [)]
			*------------------------------------------------------------------------------

		ENDIF
	ENDIF
	*------------------------------------------------------------------------------

	*02.06.2006 11:38 ->��������� ������ (����� �������)
	luQryParTvrEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplTvrEnabled])
	***
	IF !ISNULL(luQryParTvrEnabled) AND TYPE([luQryParTvrEnabled])==[L] AND luQryParTvrEnabled
	
		*23.04.2006 00:32 ->������� ��� ��������� ������� � ���������������� ������� 
		luQryParTvrIDTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcTvrIDTableNM])
		***
		IF !ISNULL(luQryParTvrIDTableNM) AND TYPE([luQryParTvrIDTableNM])==[C] AND FILE([tmp\]+luQryParTvrIDTableNM+[.dbf])

			*10.04.2006 11:35 -> ���������� ������
			lcFilterExpr = lcFilterExpr + ;
							[ AND CheckTrans.CheckTransTvrId IN (]+spGetTmpValueList(luQryParTvrIDTableNM)+[)]
			*------------------------------------------------------------------------------

		ENDIF
		*------------------------------------------------------------------------------		
				
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
		[EXECUTE spCheckView ?lcFilterExpr],lcUniqueName)
ENDDO
***
IF lnSqlExeResult = -1

	*11.08.2006 17:00 ->������� ���������� ������
	spHandleODBCError()
	*------------------------------------------------------------------------------
	
	*11.08.2006 17:01 ->���������� ������ ������
	CREATE CURSOR (lcUniqueName) ( ;
		CheckID I, BranchID I, BranchNM C(1), ChkTypeNM C(1), CheckNo I, CashNM C(1), ;
		CashierNM C(1), CheckStamp T, DiscCardNo C(1) ;
	)
	*------------------------------------------------------------------------------

ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> �������� ������ � ���� � �������
SELECT (lcUniqueName)
***
COPY TO (lcUniqueFilePath)
***
USE IN SELECT(lcUniqueName)
*------------------------------------------------------------------------------

*02.06.2006 12:24 ->����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
   SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*07.07.2006 16:39 -> ������� ���������
WAIT CLEAR
SET MESSAGE TO []
*------------------------------------------------------------------------------

*21.04.2004 14:27 -> ������ ��������
RETURN lcUniqueName
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spGetSaleSum()
* Called by.......: <NA>
* Parameters......: <tcQryParSID>
* Returns.........: <none>
* Notes...........: ����������� ����� ������ �� ������
*------------------------------------------------------------------------------
PROCEDURE spGetSaleSum
LPARAMETERS tcQryParSID

*28.02.2006 12:16 ->���������� � ������������� ����������
LOCAL	lcOldDate, ;
		lcOldCentury, ;
		lcOldMark, ;
		lcOldAlias, ;
		lcFilterExpr, ;
		luQryParDateEnabled, ;
		luQryParDateStartDate, ;
		luQryParDateEndDate, ;
		luQryParCashEnabled, ;
		luQryParCashTableNM, ;
		luQryParCashierEnabled, ;
		luQryParCashierTableNM, ;
		luQryParTvrEnabled, ;
		luQryParTvrIDTableNM, ;
		lnSalesSum
***
lcOldDate = SET([DATE])
lcOldCentury = SET([CENTURY])
lcOldMark = SET([MARK])
lcOldAlias	 = ALIAS()
lcFilterExpr = []
*------------------------------------------------------------------------------

*06.03.2006 16:22 ->���������� ��������� ������������, ���� ���������� �������� ����������
IF TYPE([oQryParMgr])==[O] AND !ISNULL(oQryParMgr)
	
	*06.03.2006 16:22 ->��������� ������ �� ����
	luQryParDateEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplDateEnabled])
	***
	IF !ISNULL(luQryParDateEnabled) AND TYPE([luQryParDateEnabled])==[L] AND luQryParDateEnabled
		
		*06.03.2006 16:22 ->������� ���� ��������� � ��������
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

		*06.03.2006 16:22 ->��������� �������
		DO CASE
			CASE	!ISNULL(luQryParDateStartDate) AND TYPE([luQryParDateStartDate])==[D] AND !EMPTY(luQryParDateStartDate) AND ;
					!ISNULL(luQryParDateEndDate) AND TYPE([luQryParDateEndDate])==[D] AND !EMPTY(luQryParDateEndDate)
					*{
					lcFilterExpr = lcFilterExpr + [ AND CheckSale.CheckStamp >= ']+STRTRAN(DTOC(luQryParDateStartDate),[/],[])+[' AND CheckSale.CheckStamp < ']+STRTRAN(DTOC(luQryParDateEndDate+1),[/],[])+[']
					*}
			CASE	!ISNULL(luQryParDateStartDate) AND TYPE([luQryParDateStartDate])==[D] AND !EMPTY(luQryParDateStartDate)
					*{
					lcFilterExpr = lcFilterExpr + [ AND CheckSale.CheckStamp >= ']+STRTRAN(DTOC(luQryParDateStartDate),[/],[])+[']
					*}
			CASE	!ISNULL(luQryParDateEndDate) AND TYPE([luQryParDateEndDate])==[D] AND !EMPTY(luQryParDateEndDate)
					*{
					lcFilterExpr = lcFilterExpr + [ AND CheckSale.CheckStamp < ']+STRTRAN(DTOC(luQryParDateEndDate+1),[/],[])+[']
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

	ENDIF
	*------------------------------------------------------------------------------

	*02.06.2006 11:34 ->��������� ������ �� �����
	luQryParCashEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplCashEnabled])
	***
	IF !ISNULL(luQryParCashEnabled) AND TYPE([luQryParCashEnabled])==[L] AND luQryParCashEnabled
		luQryParCashTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcCashTableNM])
		IF !ISNULL(luQryParCashTableNM) AND TYPE([luQryParCashTableNM])==[C] AND FILE(luQryParCashTableNM+[.dbf])

			*10.04.2006 11:35 -> ���������� ������
			lcFilterExpr = lcFilterExpr+[ AND CheckSale.CheckCashID IN (]+spGetTmpValueList(luQryParCashTableNM)+[)]
			*------------------------------------------------------------------------------

		ENDIF
	ENDIF
	*------------------------------------------------------------------------------

	*02.06.2006 11:34 ->��������� ������ �� �������
	luQryParCashierEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplCashierEnabled])
	***
	IF !ISNULL(luQryParCashierEnabled) AND TYPE([luQryParCashierEnabled])==[L] AND luQryParCashierEnabled
		luQryParCashierTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcCashierTableNM])
		IF !ISNULL(luQryParCashierTableNM) AND TYPE([luQryParCashierTableNM])==[C] AND FILE(luQryParCashierTableNM+[.dbf])

			*10.04.2006 11:35 -> ���������� ������
			lcFilterExpr = lcFilterExpr+[ AND CheckSale.CheckCashierID IN (]+spGetTmpValueList(luQryParCashierTableNM)+[)]
			*------------------------------------------------------------------------------

		ENDIF
	ENDIF
	*------------------------------------------------------------------------------

	*02.06.2006 11:38 ->��������� ������ (����� �������)
	luQryParTvrEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplTvrEnabled])
	***
	IF !ISNULL(luQryParTvrEnabled) AND TYPE([luQryParTvrEnabled])==[L] AND luQryParTvrEnabled
	
		*23.04.2006 00:32 ->������� ��� ��������� ������� � ���������������� ������� 
		luQryParTvrIDTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcTvrIDTableNM])
		***
		IF !ISNULL(luQryParTvrIDTableNM) AND TYPE([luQryParTvrIDTableNM])==[C] AND FILE([tmp\]+luQryParTvrIDTableNM+[.dbf])

			*10.04.2006 11:35 -> ���������� ������
			lcFilterExpr = lcFilterExpr + ;
							[ AND CheckTrans.CheckTransTvrId IN (]+spGetTmpValueList(luQryParTvrIDTableNM)+[)]
			*------------------------------------------------------------------------------

		ENDIF
		*------------------------------------------------------------------------------		
				
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
		[EXECUTE spGetSaleSum ?lcFilterExpr],[curSaleSum])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN 0
ENDIF
*------------------------------------------------------------------------------

*06.03.2006 16:24 ->�������� �����
lnSalesSum = curSaleSum.SaleSum
*------------------------------------------------------------------------------

*06.03.2006 16:23 ->������� ������
USE IN SELECT([curSaleSum])
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*06.03.2006 16:30 ->����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
   SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*07.07.2006 16:51 -> ������ ���������
RETURN lnSalesSum
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
********************************* END METHOD **********************************
*******************************************************************************

*------------------------------------------------------------------------------
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

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spSaleDelete()
* Called by.......: <NA>
* Parameters......: <none>
* Returns.........: <tnSalesLogID>
* Notes...........: �������� ������ �� ID
*------------------------------------------------------------------------------
PROCEDURE spSaleDelete
LPARAMETERS tnSalesLogID

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ��������� ������ (������� �������)
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[DELETE ] + ;
		[FROM SalesLog ] + ;
		[WHERE SalesLog.SalesLogID = ?tnSalesLogID])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spSaleMarkEOD()
* Called by.......: <NA>
* Parameters......: <none>
* Returns.........: <tnSalesLogID>
* Notes...........: �������� ���
*------------------------------------------------------------------------------
PROCEDURE spSaleMarkEOD
LPARAMETERS tnSalesLogID

*29.04.2006 17:49 ->���������� � ������������� ����������
LOCAL   lnRecCount, ;
		llResult
*------------------------------------------------------------------------------  

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ��������, ���������� �� �������� ����� � ���� ��� �����
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[SELECT ] + ;
			[POSActivity.POSActCloseStamp ] + ;
		[FROM POSActivity ] + ;
		[WHERE POSActivity.POSActSLID = ?tnSalesLogID AND POSActivity.POSActCloseStamp IS NULL], ;
		[curOpenDay])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
***
lnRecCount = RECCOUNT([curOpenDay])
*------------------------------------------------------------------------------

*29.04.2006 17:49 ->��������� ������
USE IN SELECT([curOpenDay])
*------------------------------------------------------------------------------

IF lnRecCount = 0

	*12.04.2006 14:04 ->��������� ����
	lnSqlExeResult = 0
	***
	DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
		lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
			[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
			[UPDATE SalesLog ] + ;
			[SET Stamp = GETDATE(), ] + ;
				[EOD = 1 ] + ;
			[WHERE SalesLog.SalesLogID = ?tnSalesLogID])
	ENDDO
	***
	IF lnSqlExeResult = -1
		spHandleODBCError()
		RETURN .F.
	ENDIF
	*------------------------------------------------------------------------------

	llResult = .T.

ELSE

	llResult = .F.

ENDIF

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

RETURN llResult

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spSaleOpenDay()
* Called by.......: <NA>
* Parameters......: <tnCashID>
* Returns.........: <none>
* Notes...........: �������� ���
*------------------------------------------------------------------------------
PROCEDURE spSaleOpenDay
PARAMETERS tnCashID

*29.04.2006 15:14 ->���������� � ������������� ����������
LOCAL   lnRecCount, ;
		lnSLID, ;
		ltPOSActCloseStamp, ;
		lnConnectHandle, ;
		lnSqlExeResult
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ��������, ���������� �� �������� ����
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[SELECT ] + ;
			[SalesLog.SalesLogID ] + ;
		[FROM SalesLog ] + ;
		[WHERE SalesLog.EOD = 0], ;
		[curSalesLog])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
***
lnRecCount = RECCOUNT([curSalesLog])
lnSLID = curSalesLog.SalesLogID
*------------------------------------------------------------------------------

*29.04.2006 15:14 -> ������� ������
USE IN SELECT([curSalesLog])
*------------------------------------------------------------------------------

*29.04.2006 17:00 ->
DO CASE
	CASE lnRecCount>1
		RETURN -2 && �������� ��������� ����� ������ ���
	CASE lnRecCount=0
	
		*07.04.2006 16:45 -> ��������� ��������� ����
		lnSqlExeResult = 0
		***
		DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
			lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
				[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
				[INSERT INTO SalesLog ] + ;
					[(StampOpenDay,EOD) ] + ;
				[VALUES ] + ;
					[(GETDATE(),0) ] + ;
				[SELECT SCOPE_IDENTITY() AS LastID], ;
				[curSLID])
		ENDDO
		***
		IF lnSqlExeResult = -1
			spHandleODBCError()
			RETURN
		ENDIF
		*------------------------------------------------------------------------------
		
		*12.04.2006 14:12 -> �������� ID ������ ���
		lnSLID = curSLID.LastID
		*------------------------------------------------------------------------------

	CASE lnRecCount=1
		
	OTHERWISE
		RETURN -4 && ����������� ������
ENDCASE
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ��������, ���������� �� �������� ���� ��� ������ �����
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[SELECT ] + ;
			[POSActivity.POSActCloseStamp ] + ;
		[FROM POSActivity ] + ;
		[WHERE POSActivity.POSActSLID = ?lnSLID AND POSActivity.POSActCID = ?tnCashID], ;
		[curOpenDay])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
***
lnRecCount = RECCOUNT([curOpenDay])
ltPOSActCloseStamp = curOpenDay.POSActCloseStamp
*------------------------------------------------------------------------------

*29.04.2006 15:29 ->������� ������
USE IN SELECT([curOpenDay])
*------------------------------------------------------------------------------

DO CASE
	CASE lnRecCount>1
		RETURN -3 && ������� ����� ������ ���������� ���
	CASE lnRecCount=1 AND !ISNULL(ltPOSActCloseStamp)
		RETURN -1 && ��������� ���� ��� ������
	CASE lnRecCount=1 AND ISNULL(ltPOSActCloseStamp)

	CASE lnRecCount=0

		*07.04.2006 16:45 -> ��������� ��������� ����
		lnSqlExeResult = 0
		***
		DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
			lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
				[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
				[INSERT INTO POSActivity ] + ;
					[(POSActSLID,POSActCID,POSActOpenStamp) ] + ;
				[VALUES ] + ;
					[(?lnSLID,?tnCashID,GETDATE())])
		ENDDO
		***
		IF lnSqlExeResult = -1
			spHandleODBCError()
			RETURN
		ENDIF
		*------------------------------------------------------------------------------

	OTHERWISE
		RETURN -4 && ����������� ������
ENDCASE
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*12.04.2006 14:12 -> ������ ID ������ ���
RETURN lnSLID
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spSaleCloseDay()
* Called by.......: <NA>
* Parameters......: <tnSLID,tnCashID>
* Returns.........: <none>
* Notes...........: �������� ���������� ���
*------------------------------------------------------------------------------
PROCEDURE spSaleCloseDay
PARAMETERS tnSLID,tnCashID

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ��������� ��������� ����
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[UPDATE ] + ;
			[POSActivity ] + ;
		[SET POSActCloseStamp = GETDATE() ] + ;
		[WHERE POSActSLID = ?tnSLID AND POSActCID = ?tnCashID])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
********************************* END METHOD **********************************
*******************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spGetOpenDay()
* Called by.......: <NA>
* Parameters......: <tnCashID,tlForce>
* Returns.........: <none>
* Notes...........: �������� �������� ���������� ���
* LastEditDate....: 14 November 2006
*------------------------------------------------------------------------------
PROCEDURE spGetOpenDay
PARAMETERS tnCashID,tlForce

*29.04.2006 16:16 ->���������� � ������������� ����������
LOCAL   lnRecCount, ;
		ltStampOpenDay, ;
		lnSLID, ;
		ltPOSActCloseStamp, ;
		lnConnectHandle, ;
		lnSqlExeResult
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> �������� ���������� �������� ��������� ����
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[SELECT ] + ;
			[SalesLog.SalesLogID, ] + ;
			[SalesLog.StampOpenDay ] + ;
		[FROM SalesLog ] + ;
		[WHERE SalesLog.EOD = 0], ;
		[curSalesLog])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
***
lnRecCount = RECCOUNT([curSalesLog])
ltStampOpenDay = curSalesLog.StampOpenDay
lnSLID = curSalesLog.SalesLogID
*------------------------------------------------------------------------------

*29.04.2006 15:14 ->������� ������
USE IN SELECT([curSalesLog])
*------------------------------------------------------------------------------

DO CASE
	CASE lnRecCount>1
		RETURN -2 && �������� ��������� ����� ������ ���
	CASE lnRecCount=0
		RETURN 0  && ��� �������� ����
	CASE lnRecCount=1

		IF !tlForce AND (DATETIME()-ltStampOpenDay)/3600 > 24
			RETURN -4 && ������ ����� 24 ����� � ������� ������ �����
		ENDIF

		*07.04.2006 16:45 -> ��������, ���� �� �������� ��������� �����
		lnSqlExeResult = 0
		***
		DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
			lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
				[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
				[SELECT ] + ;
					[POSActivity.POSActID, ] + ;
					[POSActivity.POSActCloseStamp ] + ;
				[FROM POSActivity ] + ;
				[INNER JOIN SalesLog ON SalesLog.SalesLogID = POSActivity.POSActSLID AND POSActivity.POSActCID = ?tnCashID ] + ;
				[WHERE SalesLog.SalesLogID = ?lnSLID], ;
				[curLocalDay])
		ENDDO
		***
		IF lnSqlExeResult = -1
			spHandleODBCError()
			RETURN .F.
		ENDIF
		***
		lnRecCount = RECCOUNT([curLocalDay])
		ltPOSActCloseStamp = curLocalDay.POSActCloseStamp
		*------------------------------------------------------------------------------

		*29.04.2006 15:14 ->������� �������
		USE IN SELECT([curLocalDay])
		*------------------------------------------------------------------------------

		DO CASE
			CASE lnRecCount=1 AND !ISNULL(ltPOSActCloseStamp)
				RETURN -1 && ��������� ���� ��� ������
			CASE lnRecCount=0
				RETURN 0
		ENDCASE

	OTHERWISE
		RETURN -4 && ����������� ������
ENDCASE
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

RETURN lnSLID

ENDPROC
*******************************************************************************
********************************* END METHOD **********************************
*******************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spOpenCheck()
* Called by.......: <NA>
* Parameters......: <tnSalesID,tnCheckTypeID,tnCashID,tnCltID>
* Returns.........: <none>
* Notes...........: �������� ���
*------------------------------------------------------------------------------
PROCEDURE spOpenCheck
LPARAMETERS tnSalesID, ;
			tnCheckTypeID, ;
			tnCashID, ;
			tnCltID
			
*15.04.2006 10:33 ->���������� � ������������� ����������
LOCAL	lcUniqueName, ;
		lcUniqueFilePath, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcUniqueName = [sl]+SYS(2015)
lcUniqueFilePath = [tmp\] + lcUniqueName + [.DBF]
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ��������� �������� ��������� �� ������� �������
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE spOpenCheck ?tnSalesID, ?tnCheckTypeID, ?tnCashID, ?tnCltID],lcUniqueName)
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
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

*21.04.2004 14:27 -> ������ ��� ������� � ����������� ����
RETURN lcUniqueName
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spCheckReset()
* Called by.......: <NA>
* Parameters......: <tnCheckID>
* Returns.........: <none>
* Notes...........: ����� ����
*------------------------------------------------------------------------------
PROCEDURE spCheckReset
LPARAMETERS tnCheckID

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ���������� ���
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[UPDATE CheckSale ] + ;
			[SET CheckTypeID = CheckTypeID + 3 ] + ;
		[WHERE CheckID = ?tnCheckID])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spSaleFiscError()
* Called by.......: <NA>
* Parameters......: <tnCheckID>
* Returns.........: <none>
* Notes...........: ������������ � ����, ��� ��������� �������� ������ ��
*------------------------------------------------------------------------------
PROCEDURE spSaleFiscError
LPARAMETERS tnCheckID

*31.05.2006 10:05 -> ���������� � ������������� ����������
LOCAL   lnConnectHandle, ;
		lnSqlExeResult, ;
		llResult
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> �������� ���
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[UPDATE CheckSale ] + ;
			[SET CheckAttributeID = 2 ] + ;
		[WHERE CheckID = ?tnCheckID])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*------------------------------------------------------------------------------
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

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spBindDisc()
* Called by.......: <NA>
* Parameters......: <tnCheckID,tnDiscCardID>
* Returns.........: <none>
* Notes...........:	�������� ���������� ����� � ����
*------------------------------------------------------------------------------
PROCEDURE spBindDisc
LPARAMETERS tnCheckID,tnDiscCardID

*31.05.2006 10:05 -> ���������� � ������������� ����������
LOCAL   lnConnectHandle, ;
		lnSqlExeResult
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> �����������
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[UPDATE CheckSale ] + ;
			[SET DiscCardID = ?tnDiscCardID ] + ;
		[WHERE CheckID = ?tnCheckID])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: spGetTvrLbl()
* Called by.......: <NA>
* Parameters......: <none>
* Returns.........: <none>
* Notes...........: ������������ ��������� ������� ��� ������ �������� � ��������
*------------------------------------------------------------------------------
PROCEDURE spGetTvrLbl
LPARAMETERS tcExecVar,tuParam1

*08.08.2005 12:10 -> ���������� � ������������� ����������
LOCAL	lcFilterExpr, ;
		luQryParTLUTypeEnabled, ;
		luQryParTLUTypeIDTableNM, ;
		luQryParPrcTypeEnabled, ;
		luQryParPrcTypeID, ;
		lnConnectHandle, ;
		lnSqlExeResult
		
LOCAL ARRAY aTvrLbl(1)
***
lcFilterExpr = [WHERE 1=0]
lcAliasListToClose = []
*------------------------------------------------------------------------------

DO CASE
	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[NODATA]
		
		*21.04.2004 12:34 ->��������� ������, ��� ������������ ������ �������
		lcFilterExpr = [WHERE 1=0 ]
		*------------------------------------------------------------------------------

	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[BYTVRID]
		
		*21.04.2004 12:32 ->��������� ������ ��� ������ ������ ���������
		lcFilterExpr = [WHERE Tovar.TvrID = ]+ALLTRIM(STR(tuParam1))
		*------------------------------------------------------------------------------
		
	CASE TYPE([tcExecVar])==[C] AND tcExecVar==[BYFILTER]
		
		*24.08.2005 16:45 -> ��������� ������
		lcFilterExpr = [WHERE 1=1]
		*------------------------------------------------------------------------------

		*08.08.2005 12:19 ->��������� ������ �� ����� ���������������
		luQryParTLUTypeEnabled = oQryParMgr.ParamGet(tuParam1,[qplTLUTypeEnabled])
		***
		IF !ISNULL(luQryParTLUTypeEnabled) AND TYPE([luQryParTLUTypeEnabled])==[L] AND luQryParTLUTypeEnabled
			
			*08.08.2005 12:20 -> ������� ��� ��������� ������� � ������ ���������������
			luQryParTLUTypeIDTableNM = oQryParMgr.ParamGet(tuParam1,[qpcTLUTypeIDTableNM])
			***
			IF !ISNULL(luQryParTLUTypeIDTableNM) AND TYPE([luQryParTLUTypeIDTableNM])==[C] AND FILE([tmp\]+luQryParTLUTypeIDTableNM+[.dbf])

				*26.03.2007 15:57 ->���������� ������
				lcFilterExpr = lcFilterExpr + ;
								[ AND TvrLookUp.TLUTypeID IN (]+spGetTmpValueList(luQryParTLUTypeIDTableNM)+[)]
				*------------------------------------------------------------------------------

			ENDIF
			*------------------------------------------------------------------------------		
			
		ENDIF
		*------------------------------------------------------------------------------
		
		*27.04.2006 12:19 ->��������� ������ �� ����� �����-������
		luQryParPrcTypeEnabled = oQryParMgr.ParamGet(tuParam1,[qplPrcTypeEnabled])
		***
		IF !ISNULL(luQryParPrcTypeEnabled) AND TYPE([luQryParPrcTypeEnabled])==[L] AND luQryParPrcTypeEnabled
			
			*27.04.2006 12:20 -> ������� ������������� �����-�����
			luQryParPrcTypeID = oQryParMgr.ParamGet(tuParam1,[qpnPrcTypeID])
			***
			IF !ISNULL(luQryParPrcTypeID) AND TYPE([luQryParPrcTypeID])==[N]
				lcFilterExpr = lcFilterExpr + [ AND Price.PrcTypeID = ]+ALLTRIM(STR(luQryParPrcTypeID))
			ENDIF
			*------------------------------------------------------------------------------		
			
		ENDIF
		*------------------------------------------------------------------------------
		
ENDCASE
*------------------------------------------------------------------------------

*26.03.2007 17:11 ->����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 ->�����������
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[SELECT ] + ;
			[Tovar.TvrID, ] + ;
			[Tovar.TvrNM, ] + ;
			[ISNULL(TvrLookUp.TLUID,000000) AS TLUID, ] + ;
			[ISNULL(TvrLookUp.TLU,SPACE(13)) AS TLU, ] + ;
			[0 AS Qnt, ] + ;
			[ISNULL(Price.Price,0) AS Price ] + ;
		[FROM Tovar ] + ;
		[INNER JOIN Price ON Price.TvrID = Tovar.TvrID ] + ;
		[LEFT JOIN TvrLookUp ON TvrLookUp.TvrID = Tovar.TvrID ] + ;
		lcFilterExpr, [curTvrLbl])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------


*26.03.2007 16:09->������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*09.08.2005 12:26 -> ��������� �� ��������� ������� ���������
SELECT * FROM curTvrLbl INTO TABLE Tmp\TvrLbl.dbf
*------------------------------------------------------------------------------

*09.08.2005 12:26 -> ������� ������
USE IN IIF(USED([curTvrLbl]),[curTvrLbl],0)
*------------------------------------------------------------------------------

*09.08.2005 12:26 -> ������� ��������� �������
USE IN IIF(USED([TvrLbl]),[TvrLbl],0)
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: spTvrLblPrint()
* Called by.......: <NA>
* Parameters......: <none>
* Returns.........: <������ ��������� ������, ��������� ��� ������>
* Notes...........: ������� ��� ������ �������� � ��������
*-------------------------------------------------------
PROCEDURE spTvrLblPrint
LPARAMETERS tcQryParSID

*21.04.2004 12:31 -> ���������� � ������������� ����������
LOCAL	lcOldAlias, ;
		lcFilterExpr, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcOldAlias = ALIAS()
lcFilterExpr = [WHERE 1=1]
*------------------------------------------------------------------------------

*26.05.2006 16:04 -> ��������� ������ (����� �������)
luQryParTvrSetEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplTvrSetEnabled])
***
IF !ISNULL(luQryParTvrSetEnabled) AND TYPE([luQryParTvrSetEnabled])==[L] AND luQryParTvrSetEnabled

	*26.05.2006 16:05 -> ������� ��� ������� � ���������������� ������� �������
	luQryParTvrSetIDTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcTvrSetIDTableNM])
	***
	IF !ISNULL(luQryParTvrSetIDTableNM) AND TYPE([luQryParTvrSetIDTableNM])==[C] AND FILE([tmp\]+luQryParTvrSetIDTableNM+[.dbf])
		lcFilterExpr = lcFilterExpr + ;
						[ AND TvrInSet.TvrSetID IN (]+spGetTmpValueList(luQryParTvrSetIDTableNM)+[)]
	ENDIF
	*------------------------------------------------------------------------------
	
ENDIF
*------------------------------------------------------------------------------

*26.03.2007 16:23 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*26.03.2007 16:27 ->������� ������� ��� �������� ������ ���������� �������
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[IF OBJECT_ID('tempdb..#TvrLblQnt') IS NULL CREATE TABLE #TvrLblQnt(TvrID Int, TLUID Int, Price Money, Qnt Numeric(10,3))])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*26.03.2007 16:24 ->��������� ������ ���������� �������
USE TvrLblQnt IN 0
SELECT TvrLblQnt
SCAN ALL

	lnSqlExeResult = 0
	***
	DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
		lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
			[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
			[INSERT INTO #TvrLblQnt (TvrID,TLUID,Price,Qnt) VALUES (] + ;
				ALLTRIM(STR(TvrLblQnt.TvrID)) + [,] + ;
				ALLTRIM(STR(TvrLblQnt.TLUID)) + [,] + ;
				ALLTRIM(STR(TvrLblQnt.Price,10,2)) + [,] + ;
				ALLTRIM(STR(TvrLblQnt.Qnt,10,3)) + [)])
	ENDDO	
	***
	IF lnSqlExeResult = -1
		spHandleODBCError()
		RETURN .F.
	ENDIF

ENDSCAN
*------------------------------------------------------------------------------

*27.07.2005 11:04 -> ������� ���������� �� �������, ���������� ��� ������
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)

	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[SELECT ] + ;
			[#TvrLblQnt.TvrID, ] + ;
			[TvrLookUp.TLUID, ] + ;
			[#TvrLblQnt.Qnt, ] + ;
			[#TvrLblQnt.Price, ] + ;
			[Tovar.TvrNM, ] + ;
			[ISNULL(TvrLookUp.TLU,'') AS TLU, ] + ;
			[ISNULL(Client.CltNM,'') AS MakerNM, ] + ;
			[ISNULL(CltAddress.CltAddrSettlNM,'') AS MakerSity, ] + ;
			[ISNULL(CltCountry.CltCountryNM,'') AS MakerState, ] + ;
			[ISNULL(Accounting.AccExit,'') AS AccExit, ] + ;
			[ISNULL(TvrInSet.ListNumber, 0) AS ListNumber ] + ;
		[FROM #TvrLblQnt ] + ;
		[INNER JOIN Tovar		ON Tovar.TvrID = #TvrLblQnt.TvrID ] + ;
		[LEFT JOIN TvrLookUp 	ON TvrLookUp.TLUID = #TvrLblQnt.TLUID ] + ;
		[LEFT JOIN Accounting	ON Accounting.AccTvrID = #TvrLblQnt.TvrID ] + ;
		[LEFT JOIN Client		ON Client.CltID = Tovar.MakerCltID ] + ;
		[LEFT JOIN CltAddress	ON CltAddress.CltID = Client.CltID ] + ;
		[LEFT JOIN CltCountry	ON CltCountry.CltCountryID = CltAddress.CltCountryID ] + ;
		[LEFT JOIN TvrInSet		ON TvrInSet.TvrID = Tovar.TvrID ] + ;
		lcFilterExpr, [curRptItog])
	***
	IF lnSqlExeResult = -1
		spHandleODBCError()
		RETURN .F.
	ENDIF
	
ENDDO
*------------------------------------------------------------------------------

*26.03.2007 16:09->������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*04.08.2005 17:46 -> ������� ������ �� ���������� �������, �� ��� ����� ����������
SELECT ;
	curRptItog.TvrID, ;
	curRptItog.TLUID, ;
	curRptItog.TvrNM, ;
	curRptItog.TLU, ;
	curRptItog.Price, ;
	curRptItog.MakerNM, ;
	curRptItog.MakerSity, ;
	curRptItog.MakerState, ;
	curRptItog.AccExit, ;
	curRptItog.ListNumber ;
FROM curRptItog ;
INTO TABLE tmp\tmpRptItog
*------------------------------------------------------------------------------

*27.07.2005 11:04 -> ��� ���������� ����������� ������� ��������� �������
SELECT curRptItog
***
SCAN FOR curRptItog.Qnt > 1
	SCATTER MEMVAR
	FOR m.i = 2 TO curRptItog.Qnt
		INSERT INTO tmpRptItog FROM MEMVAR
	ENDFOR
ENDSCAN
*------------------------------------------------------------------------------

*04.08.2005 17:25 -> ������� ������
USE IN IIF(USED([curRptItog]),[curRptItog],0)
*------------------------------------------------------------------------------

*09.08.2005 14:28 -> ����������� ������
SELECT ;
	tmpRptItog.TvrID, ;
	tmpRptItog.TLUID, ;
	tmpRptItog.TvrNM, ;
	tmpRptItog.TLU, ;
	tmpRptItog.Price, ;
	tmpRptItog.MakerNM, ;
	tmpRptItog.MakerSity, ;
	tmpRptItog.MakerState, ;
	tmpRptItog.AccExit, ;
	tmpRptItog.ListNumber ;
FROM tmpRptItog ;
ORDER BY tmpRptItog.TvrNM, tmpRptItog.ListNumber ;
INTO TABLE tmp\RptItog
*------------------------------------------------------------------------------

*09.08.2005 14:30 -> ������� � ������� ��������� �������
USE IN IIF(USED([tmpRptItog]),[tmpRptItog],0)
***
IF FILE([Tmp\tmpRptItog.dbf])
	ERASE Tmp\tmpRptItog.dbf
ENDIF
*------------------------------------------------------------------------------

*09.08.2005 14:31 -> ������� �������
USE IN IIF(USED([RptItog]),[RptItog],0)
*------------------------------------------------------------------------------

*27.07.2005 11:56 -> ����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*27.07.2005 11:05 -> ������ ������ ������ ��������� ��� ������
RETURN [RptItog.dbf]
*------------------------------------------------------------------------------

ENDPROC
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spCheckReset()
* Called by.......: <NA>
* Parameters......: <tnCheckID>
* Returns.........: <none>
* Notes...........: ����� ����
*------------------------------------------------------------------------------
PROCEDURE spCheckReset
LPARAMETERS tnCheckID

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ���������� ���
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[UPDATE CheckSale ] + ;
			[SET CheckTypeID = CheckTypeID + 3 ] + ;
		[WHERE CheckID = ?tnCheckID])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spSaleFiscError()
* Called by.......: <NA>
* Parameters......: <tnCheckID>
* Returns.........: <none>
* Notes...........: ������������ � ����, ��� ��� ������ �������� ������ ��
*------------------------------------------------------------------------------
PROCEDURE spSaleFiscError
LPARAMETERS tnCheckID

*31.05.2006 10:05 -> ���������� � ������������� ����������
LOCAL   lnConnectHandle, ;
		lnSqlExeResult, ;
		llResult
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> �������� ���
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[UPDATE CheckSale ] + ;
			[SET CheckAttributeID = CheckAttributeID | 2 ] + ;
		[WHERE CheckID = ?tnCheckID])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spCheckSaleSucces()
* Called by.......: <NA>
* Parameters......: <tnCheckID>
* Returns.........: <none>
* Notes...........: ������������ ����������� ���������� ����
*------------------------------------------------------------------------------
PROCEDURE spCheckSaleSucces
LPARAMETERS tnCheckID

*10.10.2006 16:26 ->���������� � ������������� ����������
LOCAL   lnConnectHandle, ;
		lnSqlExeResult, ;
		llResult
*------------------------------------------------------------------------------

*10.10.2006 16:26 ->����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*10.10.2006 16:26 ->�������� ���
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[UPDATE CheckSale ] + ;
			[SET CheckAttributeID = CheckAttributeID & (~4) ] + ;
		[WHERE CheckID = ?tnCheckID])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*10.10.2006 16:26 ->������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spSaleReport_ingred()
* Called by.......: <NA>
* Parameters......: <tcQryParSID,tlDiscCardInfo>
* Returns.........: <none>
* Notes...........: ������������ ������� ��� ������ � ��������
*-------------------------------------------------------
PROCEDURE spSaleReport_ingred
LPARAMETERS tcQryParSID,tlDiscCardInfo 

*21.07.2005 12:13 -> ���������� � ������������� ����������
LOCAL	lcOldDate, ;
		lcOldCentury, ;
		lcOldMark, ;
		lcOldAlias, ;
		lcFilterExpr, ;
		lcFilterExprTvr, ;
		lcFilterExprCheckType, ;
		luQryParDateEnabled, ;
		luQryParDateStartDate, ;
		luQryParDateEndDate, ;
		luQryParTvrEnabled, ;
		luQryParTvrIDTableNM, ;
		luQryParTvrGrpEnabled, ;
		lcQryParTvrIDTableNM, ;
		luQryParCheckTypeAborted, ;
		luQryParIsAbortedCheck, ;
		luQryParCashEnabled, ;
		luQryParCashTableNM, ;
		luQryParCashierEnabled, ;
		luQryParCashierTableNM, ;
		luQryParCheckTypeEnabled, ;
		luQryParCheckTypeTableNM
***
lcOldDate = SET([DATE])
lcOldCentury = SET([CENTURY])
lcOldMark = SET([MARK])
lcOldAlias = ALIAS()
lcFilterExpr = [WHERE 0<>1]
lcFilterExprTvr		  = []
lcFilterExprCheckType = []
*------------------------------------------------------------------------------

*28.11.2005 13:39 ->���� ����������� ������� ��� ������ �� ���������� ������, �� ��������� �������������� ������
IF tlDiscCardInfo
	lcFilterExpr = lcFilterExpr + [ AND NOT CheckSale.DiscCardID IS NULL]
ENDIF
*------------------------------------------------------------------------------

*21.07.2005 12:13 ->���������� ��������� ������������, ���� ���������� �������� ����������
IF TYPE([oQryParMgr])==[O] AND !ISNULL(oQryParMgr)
	
	*21.07.2005 15:37 ->������� ������� � ���������� ��� ������
	CREATE TABLE tmp\RptEnv FREE (QryParSID C(10), QryTypeNM C(40))
	INSERT INTO RptEnv (QryParSID) VALUES (tcQryParSID)
	*------------------------------------------------------------------------------
	
	*21.07.2005 12:13 ->��������� ������ �� ����
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

	*14.06.2006 15:47 ->��������� ������ (����� �������)
	luQryParTvrEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplTvrEnabled])
	***
	IF !ISNULL(luQryParTvrEnabled) AND TYPE([luQryParTvrEnabled])==[L] AND luQryParTvrEnabled
				
		*14.06.2006 15:47 ->������� ��� ��������� ������� � ���������������� ������� 
		luQryParTvrIDTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcTvrIDTableNM])
		***
		IF !ISNULL(luQryParTvrIDTableNM) AND TYPE([luQryParTvrIDTableNM])==[C] AND FILE([tmp\]+luQryParTvrIDTableNM+[.dbf])

			*10.04.2006 11:35 -> ���������� ������
			lcFilterExprTvr = lcFilterExprTvr + ;
							[ AND Tovar.TvrID IN (] + spGetTmpValueList(luQryParTvrIDTableNM) + [)]
			*------------------------------------------------------------------------------

		ENDIF
		*------------------------------------------------------------------------------		
				
	ENDIF
	*------------------------------------------------------------------------------

	*28.09.2005 10:09 -> ��������� ������ (����� ����� �������)
	luQryParTvrGrpEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplTvrGrpEnabled])
	***
	IF !ISNULL(luQryParTvrGrpEnabled) AND TYPE([luQryParTvrGrpEnabled])==[L] AND luQryParTvrGrpEnabled

		*28.09.2005 10:16 -> ������� ��� ������� � ���������������� ����� �������
		luQryParTvrGrpTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcTvrGrpTableNM])
		***
		IF !ISNULL(luQryParTvrGrpTableNM) AND TYPE([luQryParTvrGrpTableNM])==[C] AND FILE([tmp\]+luQryParTvrGrpTableNM+[.dbf])

			*10.04.2006 11:35 -> ���������� ������
			lcFilterExprTvr = lcFilterExprTvr + ;
							[ AND Tovar.TvrID IN (SELECT ID FROM GetTvrIDInSelectedTvrGrp('] + spGetTmpValueList(luQryParTvrGrpTableNM) + [') WHERE IsCnt = 0)]
			*------------------------------------------------------------------------------

		ENDIF
		*------------------------------------------------------------------------------
		
	ENDIF
	*------------------------------------------------------------------------------

	*21.07.2005 12:13 ->��������� ������ �� ���������� �����
	luQryParCheckTypeAborted = oQryParMgr.ParamGet(tcQryParSID,[qplCheckTypeAborted])
	***
	IF !ISNULL(luQryParCheckTypeAborted) AND TYPE([luQryParCheckTypeAborted])==[L] AND luQryParCheckTypeAborted
		luQryParIsAbortedCheck = oQryParMgr.ParamGet(tcQryParSID,[qplAborted])
		IF !ISNULL(luQryParIsAbortedCheck) AND TYPE([luQryParIsAbortedCheck])==[L] AND luQryParIsAbortedCheck
			lcFilterExpr = lcFilterExpr+[ AND CheckType.CheckTypeAborted=1]
		ELSE
			lcFilterExpr = lcFilterExpr+[ AND CheckType.CheckTypeAborted=0]
		ENDIF
	ENDIF
	*------------------------------------------------------------------------------

	*02.08.2005 09:08 ->��������� ������ �� �����
	luQryParCashEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplCashEnabled])
	***
	IF !ISNULL(luQryParCashEnabled) AND TYPE([luQryParCashEnabled])==[L] AND luQryParCashEnabled
		luQryParCashTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcCashTableNM])
		IF !ISNULL(luQryParCashTableNM) AND TYPE([luQryParCashTableNM])==[C] AND FILE(luQryParCashTableNM+[.dbf])

			*10.04.2006 11:35 -> ���������� ������
			lcFilterExpr = lcFilterExpr + ;
							[ AND CheckSale.CheckCashID IN (] + spGetTmpValueList(luQryParCashTableNM) + [)]
			*------------------------------------------------------------------------------

		ENDIF
	ENDIF
	*------------------------------------------------------------------------------

	*02.08.2005 09:08 ->��������� ������ �� �������
	luQryParCashierEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplCashierEnabled])
	***
	IF !ISNULL(luQryParCashierEnabled) AND TYPE([luQryParCashierEnabled])==[L] AND luQryParCashierEnabled
		luQryParCashierTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcCashierTableNM])
		IF !ISNULL(luQryParCashierTableNM) AND TYPE([luQryParCashierTableNM])==[C] AND FILE(luQryParCashierTableNM+[.dbf])

			*10.04.2006 11:35 -> ���������� ������
			lcFilterExpr = lcFilterExpr + ;
							[ AND CheckSale.CheckCashierID IN (] + spGetTmpValueList(luQryParCashierTableNM) + [)]
			*------------------------------------------------------------------------------

		ENDIF
	ENDIF
	*------------------------------------------------------------------------------

	*01.12.2005 11:12 ->��������� ������ �� ����� �����
	luQryParCheckTypeEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplCheckTypeEnabled])
	***
	IF !ISNULL(luQryParCheckTypeEnabled) AND TYPE([luQryParCheckTypeEnabled])==[L] AND luQryParCheckTypeEnabled
		luQryParCheckTypeTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcCheckTypeTableNM])
		IF !ISNULL(luQryParCheckTypeTableNM) AND TYPE([luQryParCheckTypeTableNM])==[C] AND FILE(luQryParCheckTypeTableNM+[.dbf])

			*10.04.2006 11:35 -> ���������� ������
			lcFilterExprCheckType = lcFilterExprCheckType + ;
							[ AND CheckSale.CheckTypeID IN (] + spGetTmpValueList(luQryParCheckTypeTableNM) + [)]
			*------------------------------------------------------------------------------

		ENDIF
	ENDIF
	*------------------------------------------------------------------------------
	
ENDIF
*------------------------------------------------------------------------------

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
		[EXECUTE spSaleReport_ingred ?lcFilterExpr, ?lcFilterExprTvr, ?lcFilterExprCheckType],[tmpRptItog])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*--------------------------------------0----------------------------------------

*13.04.2006 14:03 -> �������� ������ �������������� �������
SQLMORERESULTS(lnConnectHandle,[tmpRptCheckType])
SQLMORERESULTS(lnConnectHandle)
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*28.11.2005 12:16 -> �������� ������� �� ���� � �������
SELECT tmpRptCheckType
COPY TO tmp\tmpRptCheckType.dbf
***
SELECT tmpRptItog
COPY TO tmp\tmpRptItog.dbf
***
USE IN SELECT([tmpRptCheckType])
USE IN SELECT([tmpRptItog])
*------------------------------------------------------------------------------

*30.06.2006 16:11 -> ������� ����� � �������� �������������� �������
USE tmp\tmpRptCheckType.dbf IN 0
USE tmp\tmpRptItog.dbf IN 0
***
SELECT tmpRptCheckType
INDEX ON CheckTID TAG CheckTID
***
SELECT tmpRptItog
INDEX ON CheckDate TAG CheckDate
INDEX ON TvrID TAG TvrID ADDITIVE
INDEX ON TvrNM TAG TvrNM ADDITIVE
INDEX ON DTOC(CheckDate,1)+PADL(ALLTRIM(STR(CheckNo)),6,[0]) TAG ChkOrder ADDITIVE
INDEX ON CheckHour TAG CheckHour ADDITIVE
INDEX ON STR(SalesLogID,10) + TvrNM TAG SLTvrNM ADDITIVE
*------------------------------------------------------------------------------

*28.11.2005 12:16 ->����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*21.04.2004 14:27 -> ������ ��������
RETURN [tmpRptItog.dbf;tmpRptItog.cdx;tmpRptCheckType.dbf;tmpRptCheckType.cdx;RptEnv.dbf]
*------------------------------------------------------------------------------

ENDPROC
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*******************************************************************************
*��������� ��� ������ � ���������������
PROCEDURE _______INVENTORY_PROCEDURES________
ENDPROC
*******************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: spFormCopyInventory()
* Called by.......: <NA>
* Parameters......: <tnSrcFrmID,tnTargetFrmTypeID,tcOperation>
* Returns.........: <.T./.F.>
* Notes...........: �������� ������������ ��������� �� ������ ������������������
*------------------------------------------------------------------------------
PROCEDURE spFormCopyInventory
LPARAMETERS tnSrcFrmID,tnTargetFrmTypeID,tcOperation

*11.05.2006 17:13 -> ���������� � ������������� ����������
LOCAL	lcOldAlias, ;
		lnLastFrmID, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcOldAlias = ALIAS()
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ������ ��� ���������
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE spFormCopyInventory ?tnSrcFrmID, ?tnTargetFrmTypeID, ?tcOperation], ;
		[curLastFrmID])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
***
lnLastFrmID = curLastFrmID.FrmID
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*11.05.2006 17:13 -> ����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*11.05.2006 17:12 -> ������ ������������� ����� ������������ ��������
RETURN lnLastFrmID
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored procedures for Basis
* Module/Procedure: spInventoryReport()
* Called by.......: <NA>
* Parameters......: <tcQryParSID>
* Returns.........: <������ ��������� ������, ��������� ��� ������>
* Notes...........: ������� ��� ������ "������������ ���������"
*------------------------------------------------------------------------------
PROCEDURE spInventoryReport
LPARAMETERS tcQryParSID

*12.05.2006 11:02 -> ���������� � ������������� ����������
LOCAL	lnFrmID, ;
		lcOldAlias, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcOldAlias = ALIAS()
*------------------------------------------------------------------------------

*12.05.2006 11:02 -> ������� ������� � ���������� ��� ������
CREATE TABLE tmp\RptEnv FREE (QryParSID C(10))
INSERT INTO RptEnv (QryParSID) VALUES (tcQryParSID)
*------------------------------------------------------------------------------

*12.05.2006 11:02 ->������ ���������
IF TYPE([oQryParMgr])==[O] AND !ISNULL(oQryParMgr)

	*12.05.2006 11:02 -> ������ ������������� ���������, ������� ����� ��������
	lnFrmID = oQryParMgr.ParamGet(tcQryParSID,[FrmID])
	*------------------------------------------------------------------------------

ENDIF
*------------------------------------------------------------------------------

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
		[EXECUTE spInventoryReport ?lnFrmID],[RptItogHD])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*13.04.2006 14:03 -> �������� ������ �������������� �������
SQLMORERESULTS(lnConnectHandle,[RptItogDT])
SQLMORERESULTS(lnConnectHandle)
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> �������� ������� �� ���� � �������
SELECT RptItogHD
COPY TO tmp\RptItogHD.dbf
***
SELECT RptItogDT
COPY TO tmp\RptItogDT.dbf
***
USE IN SELECT([RptItogHD])
USE IN SELECT([RptItogDT])
*------------------------------------------------------------------------------

*12.05.2006 11:29 -> ����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*12.05.2006 11:29 -> ������ ������ ��������� ������ ��� ���������� ������
RETURN [RptItogHD.dbf;RptItogDT.dbf;RptEnv.dbf]
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored procedures for Basis
* Module/Procedure: spFrmInventoryPrint()
* Called by.......: <NA>
* Parameters......: <tcQryParSID>
* Returns.........: <������ ��������� ������, ��������� ��� ������>
* Notes...........: ������� ��� ������ "������������������ ���������"
*------------------------------------------------------------------------------
PROCEDURE spFrmInventoryPrint
LPARAMETERS tcQryParSID

*12.05.2006 11:02 -> ���������� � ������������� ����������
LOCAL	lnFrmID, ;
		lcOldAlias, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcOldAlias = ALIAS()
*------------------------------------------------------------------------------

*12.05.2006 11:02 -> ������� ������� � ���������� ��� ������
CREATE TABLE tmp\RptEnv FREE (QryParSID C(10))
INSERT INTO RptEnv (QryParSID) VALUES (tcQryParSID)
*------------------------------------------------------------------------------

*12.05.2006 11:02 ->������ ���������
IF TYPE([oQryParMgr])==[O] AND !ISNULL(oQryParMgr)

	*12.05.2006 11:02 -> ������ ������������� ���������, ������� ����� ��������
	lnFrmID = oQryParMgr.ParamGet(tcQryParSID,[FrmID])
	*------------------------------------------------------------------------------

ENDIF
*------------------------------------------------------------------------------

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
		[EXECUTE spFrmInventoryPrint ?lnFrmID],[RptItogHD])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*13.04.2006 14:03 -> �������� ������ �������������� �������
SQLMORERESULTS(lnConnectHandle,[InvTotal])
SQLMORERESULTS(lnConnectHandle,[RptItogDT])
SQLMORERESULTS(lnConnectHandle)
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> �������� ������� �� ���� � �������
SELECT RptItogHD
COPY TO tmp\RptItogHD.dbf
***
SELECT InvTotal
COPY TO tmp\InvTotal.dbf
***
SELECT RptItogDT
COPY TO tmp\RptItogDT.dbf
***
USE IN SELECT([RptItogHD])
USE IN SELECT([InvTotal])
USE IN SELECT([RptItogDT])
*------------------------------------------------------------------------------

*30.06.2006 13:25 -> ������� ������������� ��������
*!*	USE RptItogDT IN 0
*!*	***
*!*	LOCAL lnTvrID
*!*	***
*!*	SELECT RptItogDT
*!*	lnTvrID = 0
*!*	***
*!*	SCAN ALL
*!*		IF lnTvrID = RptItogDT.TvrID
*!*			REPLACE ;
*!*				RptItogDT.MsuNM  WITH [], ;
*!*				RptItogDT.TvrQnt WITH 0, ;
*!*				RptItogDT.TvrSum WITH 0
*!*		ENDIF
*!*		lnTvrID = RptItogDT.TvrID
*!*	ENDSCAN
*------------------------------------------------------------------------------

*12.05.2006 11:29 -> ������� �������
USE IN SELECT([RptEnv])
USE IN SELECT([RptItogDT])
*------------------------------------------------------------------------------

*12.05.2006 11:29 -> ����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*12.05.2006 11:29 -> ������ ������ ��������� ������ ��� ���������� ������
RETURN [RptItogHD.dbf;RptItogDT.dbf;InvTotal.dbf;RptEnv.dbf]
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: spInventoryBludo()
* Called by.......: <NA>
* Parameters......: <tnFrmID>
* Returns.........: <���-�� ������� (���� ������������ � ������)>
* Notes...........: ������������� ����� �� ������������
*------------------------------------------------------------------------------
PROCEDURE spInventoryBludo
LPARAMETERS tnFrmID

*19.06.2006 12:23 ->���������� � ������������� ����������
LOCAL   lnConnectHandle, ;
		lnSqlExeResult, ;
		lnRecCnt
*------------------------------------------------------------------------------

*06.12.2006 12:12 ->������� ��������� ��� ������������
WAIT WINDOW [�����. ���� ��������� ������...] NOWAIT NOCLEAR
SET MESSAGE TO [�����. ���� ��������� ������...]
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
		[EXECUTE spInventoryBludo ?tnFrmID],[curTmp])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN
ENDIF
***
lnRecCnt = curTmp.RecCnt
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*06.12.2006 12:13 ->������ ���������
WAIT CLEAR
SET MESSAGE TO []
*------------------------------------------------------------------------------

*20.06.2006 12:39 -> ����� ��������� ������������
MESSAGEBOX([��������� ��������� ������� ���������.],64,[����������])
*------------------------------------------------------------------------------

*19.06.2006 12:30 -> ������ ���������
RETURN .T.
*------------------------------------------------------------------------------

************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*******************************************************************************
* ��������� ��� ������ � �������� �������
PROCEDURE ________TOVAR_SET_PROCEDURES________
ENDPROC
*******************************************************************************

*------------------------------------------------------------------------------
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

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures For Basis
* Module/Procedure: spTvrSetEditSetSave()
* Called by.......: <NA>
* Parameters......: <tnTvrSetID>
* Returns.........: <none>
* Notes...........: ���������� ������������������ ������ �������
*------------------------------------------------------------------------------
PROCEDURE spTvrSetEditSetSave
LPARAMETERS tnTvrSetID

*08.08.2005 10:29 ->���������� � ������������� ����������
LOCAL	lnMarkItemCount, ;
		lnKeyCounter, ;
		lnConnectHandle, ;
		lnSqlExeResult
*------------------------------------------------------------------------------

*08.08.2005 10:20 ->����������� ���������� ��������������� ���������
SELECT ;
	COUNT(*) AS MarkCount ;
FROM TvrInSetEdit ;
WHERE !TvrInSetEdit.TvrIsCnt AND TvrInSetEdit.Mark = ALL_CHILD_MARKED ;
INTO CURSOR curMarkCount
***
lnMarkItemCount = curMarkCount.MarkCount
*------------------------------------------------------------------------------

*04.08.2005 16:46 ->������� ������ ����������� ������
CREATE TABLE tmp\tmpKey FREE (Key I)
FOR lnKeyCounter = 1 TO lnMarkItemCount
   INSERT INTO tmpKey (Key) VALUES (lnKeyCounter)
ENDFOR &&* m.i = 1 TO 10
*------------------------------------------------------------------------------

*04.08.2005 16:55 ->������� ����������� �����, ��� ������������ � ������ ������
DELETE FROM tmpKey WHERE Key IN (SELECT ListNumber FROM TvrInSetEdit)
*------------------------------------------------------------------------------

*04.08.2005 17:00 ->����������� ������� ����� �����
GO TOP IN tmpKey
***
SELECT TvrInSetEdit
SCAN ALL FOR !TvrInSetEdit.TvrIsCnt AND TvrInSetEdit.Mark = ALL_CHILD_MARKED AND EMPTY(TvrInSetEdit.ListNumber)
	REPLACE TvrInSetEdit.ListNumber WITH tmpKey.Key
	SKIP IN tmpKey
ENDSCAN
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
		[SELECT ] + ;
			[TvrInSet.TvrInSetID, ] + ;
			[TvrInSet.TvrID, ] + ;
			[ISNULL(TvrInSet.TluID,0) AS TluID, ] + ;
			[TvrInSet.ListNumber ] + ;
		[FROM TvrInSet WHERE TvrInSet.TvrSetID = ?tnTvrSetID],[TvrInSet])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN
ENDIF
*------------------------------------------------------------------------------

*******************************************************************************
* ������� ��������� �������� ������ �� ��
*******************************************************************************

*08.08.2005 10:34 ->�������� ��������� �������� ������
SELECT ;
	TvrInSet.TvrInSetID AS ID, ;
	NVL(TvrInSetEdit.Mark,NOT_CHILD_MARKED) AS Mark ;
FROM TvrInSet ;
LEFT JOIN TvrInSetEdit ON TvrInSetEdit.TvrID = TvrInSet.TvrID AND TvrInSetEdit.TLUID = TvrInSet.TLUID ;
WHERE TvrInSetEdit.Mark # ALL_CHILD_MARKED ;
INTO CURSOR curTvrSetDeleted NOFILTER
*------------------------------------------------------------------------------
* WHERE NVL(TvrInSetEdit.Mark,NOT_CHILD_MARKED) # ALL_CHILD_MARKED ;

*08.08.2005 10:54 -> ������� �� ��
IF RECCOUNT([curTvrSetDeleted]) # 0
	lnSqlExeResult = 0
	***
	DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
		lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
			[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
			[DELETE FROM TvrInSet WHERE TvrInSet.TvrInSetID IN (] + spGetTmpValueList([curTvrSetDeleted]) + [)])
	ENDDO
	***
	IF lnSqlExeResult = -1
		spHandleODBCError()
		RETURN
	ENDIF
ENDIF
*------------------------------------------------------------------------------

*******************************************************************************
* ��������� ����������� �������� ������ � ��
*******************************************************************************

*08.08.2005 11:22 ->�������� ����������� �������� ������
SELECT ;
	TvrInSetEdit.TvrID, ;
	IIF(TvrInSetEdit.TluID=0,CAST(.NULL. AS I),TvrInSetEdit.TluID) AS TluID, ;
	TvrInSetEdit.ListNumber, ;
	!ISNULL(TvrInSet.TvrInSetID) AS ExistInDB ;
FROM TvrInSetEdit ;
LEFT JOIN TvrInSet ON TvrInSet.TvrID = TvrInSetEdit.TvrID AND TvrInSet.TLUID = TvrInSetEdit.TLUID ;
WHERE !TvrInSetEdit.TvrIsCnt AND TvrInSetEdit.Mark = ALL_CHILD_MARKED ;
INTO CURSOR curTvrSetAdded NOFILTER
*------------------------------------------------------------------------------

*08.08.2005 10:54 ->��������� � ��
SELECT curTvrSetAdded
SCAN ALL FOR !ExistInDB

	*08.08.2005 10:54 -> ��������� ������
	lnSqlExeResult = 0
	***
	DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
		lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
			[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
			[INSERT INTO TvrInSet ( ] + ;
				[TvrSetID, ] + ;
				[TvrID, ] + ;
				[TLUID, ] + ;
				[ListNumber ] + ;
			[) VALUES ( ] + ;
				[?tnTvrSetID, ] + ;
				[?curTvrSetAdded.TvrID, ] + ;
				[?curTvrSetAdded.TluID, ] + ;
				[?curTvrSetAdded.ListNumber)])
	ENDDO
	***
	IF lnSqlExeResult = -1
		spHandleODBCError()
		RETURN
	ENDIF
	*------------------------------------------------------------------------------

ENDSCAN
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*08.08.2005 10:32 ->������� ��������� ������� � ������ ��������� �����
USE IN IIF(USED([curMarkCount]),[curMarkCount],0)
USE IN IIF(USED([curTvrSetDeleted]),[curTvrSetDeleted],0)
USE IN IIF(USED([curTvrSetAdded]),[curTvrSetAdded],0)
***
USE IN IIF(USED([tmpKey]),[tmpKey],0)
IF FILE([tmp\tmpKey.dbf])
	ERASE tmp\tmpKey.dbf
ENDIF
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures For Basis
* Module/Procedure: spTvrSetReport()
* Called by.......: <NA>
* Parameters......: <tcQryParSID>
* Returns.........: <none>
* Notes...........: ���������� ������ �� ������ �������
*------------------------------------------------------------------------------
PROCEDURE spTvrSetReport
LPARAMETERS tcQryParSID

*09.08.2005 17:10 ->���������� � ������������� ����������
LOCAL	lcFilterExpr, ;
		lcOrderExp, ;
		luTvrSetID, ;
		llSortName, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcFilterExpr = [WHERE 0<>1]
*------------------------------------------------------------------------------

*02.06.2005 15:47 ->������� ������� � ���������� ��� ������
CREATE TABLE tmp\RptEnv FREE (QryParSID C(10))
INSERT INTO RptEnv (QryParSID) VALUES (tcQryParSID)
*------------------------------------------------------------------------------

*25.05.2005 16:46 ->������ ������������� �������� �����
luTvrSetID = oQryParMgr.ParamGet(tcQryParSID,[TvrSetID])
***
lcFilterExpr = lcFilterExpr + [ AND TvrSet.TvrSetID = ] + ALLTRIM(STR(luTvrSetID))
*------------------------------------------------------------------------------
		
*11.05.2005 12:55 ->������ ��������� ������ "� �������/��� ������"
llSortName = oQryParMgr.ParamGet(tcQryParSID,[qplSortName])
***
IF ISNULL(llSortName) OR TYPE([llSortName])#[L]
	llSortName = .F.
ENDIF
***
lcOrderExp = IIF(llSortName,[ORDER BY 3],[ORDER BY 1])
*------------------------------------------------------------------------------
	
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
		[EXECUTE spTvrSetReport ?lcFilterExpr, ?lcOrderExp],[tmpRptItogHD])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*13.04.2006 14:03 -> �������� ������ �������������� �������
SQLMORERESULTS(lnConnectHandle,[tmpRptItogDT])
SQLMORERESULTS(lnConnectHandle)
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> �������� ������ �� ���� � �������
SELECT tmpRptItogHD
COPY TO tmp\tmpRptItogHD.dbf
***
SELECT tmpRptItogDT
COPY TO tmp\tmpRptItogDT.dbf
***
USE IN SELECT([tmpRptItogHD])
USE IN SELECT([tmpRptItogDT])
*------------------------------------------------------------------------------

*09.08.2005 17:58 -> ���������� ����������
USE tmpRptItogDT IN 0
SELECT tmpRptItogDT
INDEX ON ALLTRIM(TvrParNM) TAG GrpSort COMPACT
SET ORDER TO
*------------------------------------------------------------------------------

*26.01.2005 19:10 -> ������ ������ ������ ��������� ��� ������
RETURN [RptEnv.dbf;tmpRptItogHD.dbf;tmpRptItogDT.dbf;tmpRptItogDT.cdx]
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spTvrSetTree()
* Called by.......: <NA>
* Parameters......: <tnTvrSetID>
* Returns.........: <lcUniqueFileNM>
* Notes...........: 
*------------------------------------------------------------------------------
PROCEDURE spTvrSetTree
LPARAMETERS tnTvrSetID

*19.04.2006 11:58 -> ���������� � ������������� ����������
LOCAL   lcUniqueName, ;
		lcUniqueFilePath, ;
		lnRootID, ;
		lnPrcTypeID, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcUniqueName = [ts]+SYS(2015)
lcUniqueFilePath = [tmp\] + lcUniqueName + [.dbf]
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
		[EXECUTE spTvrSetTree ?tnTvrSetID],lcUniqueName)
ENDDO
***
IF lnSqlExeResult = -1

	*11.08.2006 17:22 ->������� ���������� ������
	spHandleODBCError()
	*------------------------------------------------------------------------------
	
	*11.08.2006 17:22 ->�������� ������ ������
	CREATE CURSOR (lcUniqueName) ( ;
		TKey I, TvrID I, TluID I, TvrParID I, TvrIsCnt L, TvrNM C(1), ListNumber I, Mark L, ;
		BmpID I, SBmpID I, BmpMID I, SBmpMID I, BmpPMID I, SBmpPMID I ;
	)
	*------------------------------------------------------------------------------

ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> �������� ������ �� ���� � �������
SELECT (lcUniqueName)
***
COPY TO (lcUniqueFilePath)
***
USE IN SELECT(lcUniqueName)
*------------------------------------------------------------------------------

*06.07.2006 15:06 -> ���������� ��� �����
RETURN lcUniqueName
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
********************************* END METHOD **********************************
*******************************************************************************

*******************************************************************************
* ��������� ��� ������ � ��������������
PROCEDURE __________GRANT_PROCEDURES__________
ENDPROC
*******************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spUserGrantList()
* Called by.......: <NA>
* Parameters......: <tnUserID,tcQryPar>
* Returns.........: <none>
* Notes...........: ������ ���� �������������
*------------------------------------------------------------------------------
PROCEDURE spUserGrantList
LPARAMETERS tnUserID,tuQryPar

*07.02.2006 13:15 -> ���������� � ������������� ����������
LOCAL   lcOldAlias, ;
		lcUniqueName, ;
		lcUniqueFilePath, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcOldAlias	     = ALIAS()
lcUniqueName = [_ug] + SYS(2015)
lcUniqueFilePath = [tmp\] + lcUniqueName + [.DBF]
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
		[EXECUTE spUserGrantList ?tnUserID, ?tuQryPar],lcUniqueName)
ENDDO
***
IF lnSqlExeResult = -1

	*11.08.2006 17:26 ->������� ���������� 
	spHandleODBCError()
	*------------------------------------------------------------------------------
	
	*11.08.2006 17:29 ->�������� ������ ������
	CREATE CURSOR (lcUniqueName) ( ;
		Mark L, ObjTypeID I, ObjID I, ObjNM C(1), ObjFun� C(1) ;
	)
	*------------------------------------------------------------------------------
	
ENDIF
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> �������� ������ � ���� � �������
SELECT (lcUniqueName)
***
COPY TO (lcUniqueFilePath)
***
USE IN SELECT(lcUniqueName)
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*07.02.2006 13:28 -> ����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
   SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*07.02.2006 14:07 -> ������ ��� ������� �� �������
RETURN lcUniqueName
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
********************************* END METHOD **********************************
*******************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: _spVerifyUserGrant()
* Called by.......: <NA>
* Parameters......: <tnUserID, tcTableNM, tuObjectID, tuObjectFunctionID>
* Returns.........: <none>
* Notes...........: �������� ���� ������� ������������
*------------------------------------------------------------------------------
PROCEDURE _spVerifyUserGrant
LPARAMETERS tnUserID, tcTableNM, tuObjectID, tuObjectFunctionID

*07.02.2006 16:29 -> ���������� � ������������� ����������
LOCAL   lcOldAlias, ;
		lnConnectHandle, ;
		lnSqlExeResult, ;
		llResult
***
lcOldAlias = ALIAS()
*------------------------------------------------------------------------------

*SET STEP ON

*28.07.2006 13:24 -> ���������, ���� �������� �����, ������ True
IF UPPER(ALLTRIM(tcTableNM)) = [SCREENFORM]
*	RETURN .T.
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
SET DATABASE TO Basis
***
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ��������� ������
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE _spVerifyUserGrant ?tnUserID, ?tcTableNM, ?tuObjectID] + IIF(PCOUNT()=4,[, ?tuObjectFunctionID],[]),[curUserGrant])
ENDDO
***
IF lnSqlExeResult = -1
	MESSAGEBOX([��������� ������ �� ����� ������ ������� � ��������.],16,[������ ����������.])
	RETURN
ENDIF
*------------------------------------------------------------------------------

*06.02.2006 19:31 -> ��������� ���������
llResult = IIF(RECCOUNT([curUserGrant]) = 0,.F.,.T.)
*------------------------------------------------------------------------------

*06.02.2006 18:08 -> ������� ������
USE IN SELECT([curUserGrant])
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*07.02.2006 16:30 -> ����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias # ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*06.02.2006 18:07 -> ���������� ���������
RETURN llResult
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: spScreenFormUserGrant()
* Called by.......: <NA>
* Parameters......: <tnUserID>
* Returns.........: <none>
* Notes...........: ��������� ������ ��������� �� ��� ������������
*------------------------------------------------------------------------------
PROCEDURE spScreenFormUserGrant
LPARAMETERS tnUserID

*20.09.2006 10:47 ->���������� � ������������� ����������
LOCAL   lcOldAlias, ;
		lnConnectHandle, ;
		lcSQLString, ;
		lnSqlExeResult, ;
		lcUniqueFileNM
***
lcOldAlias = ALIAS()
*------------------------------------------------------------------------------

*20.09.2006 10:47 ->����������� � �� ����� ������������ ����������
SET DATABASE TO Basis
***
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*20.09.2006 10:49 ->��������� ������
lcSQLString = ;
	[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
	[SELECT ] + ;
		[ScreenForm.ScrFrmObjDesc AS FrmDesc ] + ;
	[FROM UserGrant ] + ;
	[INNER JOIN ScreenForm ON ScreenForm.ScrFrmID = UserGrant.ObjectID ] + ;
	[WHERE ] + ;
		[UserGrant.UserId = ] + ALLTRIM(STR(tnUserID)) + [ AND ] + ;
		[UserGrant.ObjectTypeID = 1]
*------------------------------------------------------------------------------

*20.09.2006 10:58 ->��������� ������
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, lcSQLString, [curScrFrm])
ENDDO
***
IF lnSqlExeResult = -1
	MESSAGEBOX([��������� ������ �� ����� ������ ������� � ��������.],16,[������ ����������.])
	RETURN
ENDIF
*------------------------------------------------------------------------------

*20.09.2006 10:58 ->��������� ���������
IF RECCOUNT([curScrFrm]) # 0
	lcUniqueFileNM = [_ug]+SYS(2015)
	SELECT curScrFrm
	COPY TO ([tmp\]+lcUniqueFileNM+[.dbf])
ELSE
	lcUniqueFileNM = []
ENDIF
*------------------------------------------------------------------------------

*20.09.2006 11:03 ->������� ������
USE IN SELECT([curScrFrm])
*------------------------------------------------------------------------------

*20.09.2006 11:03 ->������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*20.09.2006 11:03 ->����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias # ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*20.09.2006 11:03 ->���������� ���������
RETURN lcUniqueFileNM
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*******************************************************************************
*��������� ��� ������ � ��������� ���������
PROCEDURE ____________MEASUREUNIT____________
ENDPROC
*******************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spGetBaseMsuList()
* Called by.......: <NA>
* Parameters......: <tnMsuID>
* Returns.........: <none>
* Notes...........: 
*------------------------------------------------------------------------------
PROCEDURE spGetBaseMsuList
LPARAMETERS tnMsuID

*11.01.2006 15:42 -> ���������� � ������������� ����������
LOCAL   lcDependentName, ;
		lcIndependentName, ;
		lcDependentFilePath, ;
		lcIndependentFilePath, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcDependentName   = [_sp]+SYS(2015)
lcIndependentName = [_sp]+SYS(2015)
lcDependentFilePath   = [tmp\] + lcDependentName + [.dbf]
lcIndependentFilePath = [tmp\] + lcIndependentName + [.dbf]
*------------------------------------------------------------------------------

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
		[EXECUTE spGetBaseMsuList ?tnMsuID],lcDependentName)
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN
ENDIF
*------------------------------------------------------------------------------

*13.04.2006 14:03 -> �������� ������ �������������� �������
SQLMORERESULTS(lnConnectHandle,lcIndependentName)
SQLMORERESULTS(lnConnectHandle)
*------------------------------------------------------------------------------

*10.04.2006 14:07 -> �������� ������� �� ���� � �������
SELECT (lcDependentName)
COPY TO (lcDependentFilePath)
***
SELECT (lcIndependentName)
COPY TO (lcIndependentFilePath)
***
USE IN SELECT(lcDependentName)
USE IN SELECT(lcIndependentName)
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*21.04.2004 14:27 -> ������ ����� ������
RETURN lcIndependentName+[;]+lcDependentName
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
********************************* END METHOD **********************************
*******************************************************************************

*------------------------------------------------------------------------------
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

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: spGetAccNetto()
* Called by.......: <NA>
* Parameters......: <tnFrmID>
* Returns.........: <none>
* Notes...........: ���������� ����� � ������������� ��� ����� �����
*------------------------------------------------------------------------------
PROCEDURE spGetAccNetto
LPARAMETERS tnFrmID

*09.06.2006 16:20 -> ���������� � ������������� ����������
LOCAL	lnConnectHandle, ;
		lnSqlExeResult
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ��������� ������
lnSqlExeResult = 0
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[UPDATE Accounting SET ] + ;
			[AccPrice = AccExit.Price, ] + ;
			[AccNetto = AccExit.Netto ] + ;
		[FROM ( ] + ;
			[SELECT ] + ;
				[SUM(FrmPartTvr.TvrQnt*FrmPartTvr.TvrPrcBuy) AS Price, ] + ;
				[SUM(FrmPartTvr.TvrQntNetto) AS Netto ] + ;
			[FROM FrmPartTvr ] + ;
			[INNER JOIN Tovar ON Tovar.TvrID = FrmPartTvr.TvrID ] + ;
			[WHERE FrmPartTvr.FrmID = ?tnFrmID AND Tovar.TvrTypeID <> 6) AS AccExit ] + ;
		[WHERE Accounting.AccFrmID = ?tnFrmID])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN 0
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: spReqPriceSale()
* Called by.......: <NA>
* Parameters......: <tnFrmID>
* Returns.........: <none>
* Notes...........: �������������� ���� ������� �� �������� � �� �����������
*------------------------------------------------------------------------------
PROCEDURE spReqPriceSale
LPARAMETERS tnFrmID, tnPrcTypeID

*09.06.2006 16:20 -> ���������� � ������������� ����������
LOCAL	lnConnectHandle, ;
		lnSqlExeResult
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ��������� ������
lnSqlExeResult = 0
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[UPDATE FrmPartTvr SET ] + ;
			[TvrPrcSale = Price.Price ] + ;
		[FROM Price ] + ;
		[WHERE ] + ;
			[FrmPartTvr.FrmID = ?tnFrmID AND ] + ;
			[Price.TvrID = FrmPartTvr.TvrID AND ] + ;
			[Price.PrcTypeID = ?tnPrcTypeID])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN 0
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ��������� ������
lnSqlExeResult = 0
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[SELECT ] + ;
			[SUM(FrmPartTvr.TvrQnt*FrmPartTvr.TvrPrcSale) AS PrcSale ] + ;
		[FROM FrmPartTvr ] + ;
		[INNER JOIN Tovar ON Tovar.TvrID = FrmPartTvr.TvrID ] + ;
		[WHERE FrmPartTvr.FrmID = ?tnFrmID AND Tovar.TvrTypeID <> 6], ;
		[AccExit])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN 0
ENDIF
***
WAIT WINDOW AccExit.PrcSale
***
USE IN SELECT([AccExit])
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

ENDPROC
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*------------------------------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spReqPriceBay()
* Called by.......: <NA>
* Parameters......: <tnFrmID>
* Returns.........: <none>
* Notes...........: �������������� ���� ����������� �� �������� � �� �����������
*------------------------------------------------------------------------------
PROCEDURE spReqPriceBay
LPARAMETERS tnFrmID, tlShowMessageBox

*09.06.2006 16:20 -> ���������� � ������������� ����������
LOCAL	lnConnectHandle, ;
		lnSqlExeResult
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ��������� ������
lnSqlExeResult = 0
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[UPDATE FrmPartTvr SET ] + ;
			[TvrPrcBuy = TvrMidlBuy.TvrPrcBuy ] + ;
		[FROM ( ] + ;
			[SELECT ] + ;
				[FrmPartTvr.TvrID, ] + ;
				[TvrPrcBuy = CASE ] + ;
					[WHEN ISNULL(SUM(Stock.StockTvrQnt),0) = 0 THEN 0 ELSE ] + ;
					[ISNULL(SUM(Stock.StockTvrQnt*Stock.StockTvrPrcBuy),0)/ISNULL(SUM(Stock.StockTvrQnt),0) END ] + ;
			[FROM FrmPartTvr ] + ;
			[LEFT JOIN Stock ON Stock.StockTvrID = FrmPartTvr.TvrID ] + ;
			[WHERE FrmPartTvr.FrmID = ?tnFrmID ] + ;
			[GROUP BY FrmPartTvr.TvrID) AS TvrMidlBuy ] + ;
		[WHERE FrmPartTvr.FrmID = ?tnFrmID AND FrmPartTvr.TvrID = TvrMidlBuy.TvrID])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN 0
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*19.06.2006 10:10 -> ��������� ����� � ������������� �����
spGetAccNetto(tnFrmID)
*------------------------------------------------------------------------------

*19.06.2006 12:09 -> ����� ���������
IF TYPE([tlShowMessageBox]) = [L] AND tlShowMessageBox
	MESSAGEBOX([��������� ��������� ���������],64,[����������])
ENDIF
*------------------------------------------------------------------------------

ENDPROC
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*------------------------------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spReqActBay()
* Called by.......: <NA>
* Parameters......: <tnFrmID>
* Returns.........: <none>
* Notes...........: �������������� ���� ����������� �� �������� � �� ������� �����
*------------------------------------------------------------------------------
PROCEDURE spReqActBay
LPARAMETERS tnFrmID, tlShowMessageBox

*09.06.2006 16:20 -> ���������� � ������������� ����������
LOCAL	lnConnectHandle, ;
		lnSqlExeResult
*------------------------------------------------------------------------------

*19.06.2006 15:32 -> �������� �� spReqPriceBay
spReqPriceBay(tnFrmID,.F.)
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ��������� ������
lnSqlExeResult = 0
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[UPDATE FrmPartTvr SET ] + ;
			[TvrPrcBuy = ABS(MakeActProBay.TvrSumBuy/FrmPartTvr.TvrQnt) ] + ;
		[FROM ( ] + ;
			[SELECT ] + ;
				[FrmPartTvr.TvrIDCalc AS TvrID, ] + ;
				[SUM(FrmPartTvr.TvrQnt*FrmPartTvr.TvrPrcBuy) AS TvrSumBuy ] + ;
			[FROM FrmPartTvr ] + ;
			[WHERE FrmPartTvr.FrmID = ?tnFrmID AND NOT (FrmPartTvr.TvrIDCalc = 0 OR FrmPartTvr.TvrIDCalc IS NULL) ] + ;
			[GROUP BY FrmPartTvr.TvrIDCalc) AS MakeActProBay ] + ;
		[WHERE FrmPartTvr.FrmID = ?tnFrmID AND FrmPartTvr.TvrID = MakeActProBay.TvrID])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN 0
ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*19.06.2006 12:09 -> ����� ���������
IF TYPE([tlShowMessageBox]) = [L] AND tlShowMessageBox
	MESSAGEBOX([��������� ��������� ���������],64,[����������])
ENDIF
*------------------------------------------------------------------------------

ENDPROC
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*------------------------------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spAppendAccount()
* Parameters......: <tnTvrId, tnTvrTypeID>
* Returns.........: <NA>
* Notes...........: ��������� ����������� � ���� ������
*------------------------------------------------------------------------------
PROCEDURE spAppendAccount
LPARAMETERS tnTvrId, tnTvrTypeID

*01.06.2006 16:44 -> VG
IF tnTvrTypeID = 5 OR tnTvrTypeID = 6

	*31.05.2006 10:05 -> ���������� � ������������� ����������
	LOCAL   lnConnectHandle, ;
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
			[EXECUTE spAppendAccount ?tnTvrId])
	ENDDO
	***
	IF lnSqlExeResult = -1
		spHandleODBCError()
		RETURN .F.
	ENDIF
	*------------------------------------------------------------------------------

	*07.04.2006 16:12 -> ������ ����������: ����������� ����������
	SQLDISCONNECT(lnConnectHandle)
	*------------------------------------------------------------------------------

ENDIF 
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spFormCopyActRule()
* Called by.......: <NA>
* Parameters......: <tnSrcFrmID,tnTargetFrmTypeID,tcOperation>
* Returns.........: <none>
* Notes...........: ����������� ��������� ��������� � ��� ������������
*------------------------------------------------------------------------------
PROCEDURE spFormCopyActRule
LPARAMETERS tnSrcFrmID,tnTargetFrmTypeID,tcOperation

*15.12.2004 16:49 -> ���������� � ������������� ����������
LOCAL	lcOldAlias, ;
		lnLastFrmID, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcOldAlias = ALIAS()
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
		[EXECUTE spFormCopyActRule ?tnSrcFrmID, ?tnTargetFrmTypeID, ?tcOperation], ;
		[curLastFrmID])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN 0
ENDIF
***
lnLastFrmID = curLastFrmID.FrmID
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*15.12.2004 16:50 -> ����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*16.12.2004 17:58 -> ������ ������������� ����� ������������ ��������
RETURN lnLastFrmID
*------------------------------------------------------------------------------

************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spFormCopyBludo()
* Called by.......: <NA>
* Parameters......: <tnSrcFrmID,tnTargetFrmTypeID,tcOperation>
* Returns.........: <none>
* Notes...........: ��������� �������� � ���������� � ���� �� ��������� ;
                  * ������ ���� � ������������� 
                  * ������ ���� ��������� ����������� ����
*------------------------------------------------------------------------------
PROCEDURE spFormCopyBludo
LPARAMETERS tnSrcFrmID,tnTargetFrmTypeID,tcOperation,tlIsOnlyBludo

*15.12.2004 16:49 -> ���������� � ������������� ����������
LOCAL	lcOldAlias, ;
		lnLastFrmID, ;
		llIsOnlyBludo, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcOldAlias = ALIAS()
IF PCOUNT() = 3
	llIsOnlyBludo = (MESSAGEBOX([�������� ������ ������������� (��� ����)?],4+32+256, [������])= 7)
ELSE
	llIsOnlyBludo = tlIsOnlyBludo
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
		[EXECUTE spFormCopyBludo ?tnSrcFrmID, ?tnTargetFrmTypeID, ?tcOperation, ?llIsOnlyBludo], ;
		[curLastFrmID])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN 0
ENDIF
***
lnLastFrmID = curLastFrmID.FrmID
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*15.12.2004 16:50 -> ����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*16.12.2004 17:58 -> ������ ������������� ����� ������������ ��������
RETURN lnLastFrmID
*------------------------------------------------------------------------------

************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spFormCopyAuto()
* Called by.......: <NA>
* Parameters......: <tnSrcFrmID,tnTargetFrmTypeID,tcOperation>
* Returns.........: <none>
* Notes...........: ��������� �������� � ���������� � ���� �� ��������� ;
                  * ������ ���� � ������������� c ����������� ����������
                  * ������ ���� ��������� ����������� ����
*------------------------------------------------------------------------------
PROCEDURE spFormCopyAuto
LPARAMETERS tnSrcFrmID,tnTargetFrmTypeID,tcOperation

*15.12.2004 16:49 -> ���������� � ������������� ����������
LOCAL	lcOldAlias, ;
		llIsOnlyBludo, ;
		lnSrcFrmID, ;
		lnLastFrmID, ;
		lnHalfReady, ;
		lnCounter, ;
		lnCirc, ;
		laCirc(1)
***
llIsOnlyBludo = .T.
lnSrcFrmID = tnSrcFrmID
***
lcOldAlias = ALIAS()
*------------------------------------------------------------------------------

*19.06.2006 11:20 -> ������� ��� ������������ � ������� �� �������� ���������
DO WHILE .T.

	*19.06.2006 11:58 -> ��������� ����������� ���������
	lnLastFrmID = spFormCopyBludo(lnSrcFrmID,tnTargetFrmTypeID,tcOperation,llIsOnlyBludo)
	llIsOnlyBludo = .F.
	lnCirc = ALEN(laCirc)
	laCirc[lnCirc] = lnLastFrmID
	DIMENSION laCirc(lnCirc+1)
	lnSrcFrmID = lnLastFrmID
	*------------------------------------------------------------------------------

	*19.06.2006 11:58 -> ������� ��� ������������
	lnHalfReady = spMakeActPro(lnLastFrmID)
	*------------------------------------------------------------------------------

	*19.06.2006 11:25 -> ��������� �� ������� ��������������, ���� �� ��� - �������
	IF lnHalfReady = 0
		EXIT
	ENDIF
	*------------------------------------------------------------------------------

ENDDO
*------------------------------------------------------------------------------

*19.06.2006 12:06 -> �������������� ���� ����������� �� �������� � �� �����������
FOR lnCounter = ALEN(laCirc) TO 1 STEP -1
	lnLastFrmID = laCirc[lnCirc]
	spReqActBay(lnLastFrmID,.F.)
ENDFOR
*------------------------------------------------------------------------------

*15.12.2004 16:50 ->����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*19.06.2006 12:12 -> ����� ���������
MESSAGEBOX([��������� ���������� ���������],64,[����������])
*------------------------------------------------------------------------------

*16.12.2004 17:58 -> ������ ������������� ����� ������������ ��������
RETURN lnLastFrmID
*------------------------------------------------------------------------------

************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spCopyAccount()
* Called by.......: <NA>
* Parameters......: <tnSrcFrmID,tnTargetFrmTypeID,tcOperation>
* Returns.........: <lnLastFrmID>
* Notes...........: ����������� ��������������� �����
*------------------------------------------------------------------------------
PROCEDURE spCopyAccount
LPARAMETERS tnSrcFrmID,tnTargetFrmTypeID,tcOperation

*15.12.2004 16:49 ->���������� � ������������� ����������
LOCAL	lcOldAlias, ;
		lnLastFrmID, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcOldAlias = ALIAS()
*------------------------------------------------------------------------------

*07.04.2006 16:13 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*07.04.2006 16:45 -> ������ ��� ���������
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE spCopyAccount ?tnSrcFrmID, ?tnTargetFrmTypeID, ?tcOperation], ;
		[curLastFrmID])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN 0
ENDIF
***
lnLastFrmID = curLastFrmID.FrmID
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*15.12.2004 16:50 ->����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*16.12.2004 17:58 ->������ ������������� ����� ������������ ��������
RETURN lnLastFrmID
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spMakeActPro()
* Called by.......: <NA>
* Parameters......: <tnFrmID, tlShowMessageBox>
* Returns.........: <���-�� ������� (���� ������������ � ������)>
* Notes...........: ��������� ��� ������������ �� ��������� � ���� ������
*-------------------------------------------------------
PROCEDURE spMakeActPro
LPARAMETERS tnFrmID, tlShowMessageBox

*19.06.2006 12:23 ->���������� � ������������� ����������
LOCAL   lnConnectHandle, ;
		lnSqlExeResult, ;
		lnRecCnt, ;
		llResult
***
llResult = 0
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
		[SELECT ] + ;
			[COUNT(*) AS RecCnt ] + ;
		[FROM FrmPartTvr ] + ;
		[INNER JOIN Tovar ON Tovar.TvrID = FrmPartTvr.TvrID ] + ;
		[WHERE FrmPartTvr.FrmID = ?tnFrmID AND Tovar.TvrTypeID NOT IN (5,6)], ;
		[curTmp])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN
ENDIF
***
lnRecCnt = curTmp.RecCnt
*------------------------------------------------------------------------------

*19.06.2006 12:29 -> ������ �� �������
IF lnRecCnt = 0

	*20.06.2006 13:24 -> ������������� ����� � ������������
	lnSqlExeResult = 0
	***
	DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
		lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
			[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
			[INSERT INTO FrmPartTvr ( ] + ;
				[FrmID, ] + ;
				[TvrId, ] + ;
				[MsuId, ] + ;
				[TvrQnt, ] + ;
				[TvrPrcBuy, ] + ;
				[TvrPrcSale, ] + ;
				[TvrVATRate, ] + ;
				[TvrIDCalc, ] + ;
				[TvrAttr) ] + ;
			[SELECT ] + ;
				[FrmPartTvr.FrmID, ] + ;
				[FrmPartTvrAcc.TvrId, ] + ;
				[FrmPartTvrAcc.MsuId, ] + ;
				[FrmPartTvr.TvrQnt * FrmPartTvrAcc.TvrQnt * -1 /Accounting.AccQnt, ] + ;
				[FrmPartTvrAcc.TvrPrcBuy, ] + ;
				[FrmPartTvrAcc.TvrPrcSale, ] + ;
				[FrmPartTvrAcc.TvrVATRate, ] + ;
				[FrmPartTvr.TvrID, ] + ;
				[FrmPartTvrAcc.TvrAttr ] + ;
			[FROM FrmPartTvr ] + ;
			[INNER JOIN Tovar ON Tovar.TvrID = FrmPartTvr.TvrID ] + ;
			[INNER JOIN Accounting ON Accounting.AccTvrID = FrmPartTvr.TvrID ] + ;
			[INNER JOIN FrmPartTvr FrmPartTvrAcc ON FrmPartTvrAcc.FrmID = Accounting.AccFrmID ] + ;
			[INNER JOIN Tovar TovarAcc ON TovarAcc.TvrID = FrmPartTvrAcc.TvrID ] + ;
			[WHERE ] + ;
				[FrmPartTvr.FrmID = ?tnFrmID AND ] + ;
				[Tovar.TvrTypeID IN (5,6) AND ] + ;
				[TovarAcc.TvrTypeID <> 6])
	ENDDO
	***
	IF lnSqlExeResult = -1
		spHandleODBCError()
		RETURN
	ENDIF
	***
	llResult = curTmp.RecCnt
	*------------------------------------------------------------------------------

	*07.04.2006 16:45 -> ������� ���-�� �������
	lnSqlExeResult = 0
	***
	DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
		lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
			[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
			[SELECT ] + ;
				[COUNT(*) AS RecCnt ] + ;
			[FROM FrmPartTvr ] + ;
			[INNER JOIN Tovar ON Tovar.TvrID = FrmPartTvr.TvrID ] + ;
			[WHERE ] + ;
				[FrmPartTvr.FrmID = ?tnFrmID AND ] + ;
				[Tovar.TvrTypeID IN (5,6) AND ] + ;
				[NOT (FrmPartTvr.TvrIDCalc IS NULL OR FrmPartTvr.TvrIDCalc = 0)], ;
			[curTmp])
	ENDDO
	***
	IF lnSqlExeResult = -1
		spHandleODBCError()
		RETURN
	ENDIF
	***
	llResult = curTmp.RecCnt
	*------------------------------------------------------------------------------

	*19.06.2006 12:09 -> ����� ���������
	IF TYPE([tlShowMessageBox]) = [L] AND tlShowMessageBox
		MESSAGEBOX([��������� ��������� ���������],64,[����������])
	ENDIF
	*------------------------------------------------------------------------------

ELSE

	*20.06.2006 12:39 -> ����� ��������� ������������
	WAIT WINDOW "� ��������� ��� ���� �������� ������� ..."
	*------------------------------------------------------------------------------

ENDIF
*------------------------------------------------------------------------------

*07.04.2006 16:12 -> ������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*19.06.2006 12:30 -> ������ ���������
RETURN llResult
*------------------------------------------------------------------------------

************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

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

ENDPROC &&--(spRSTCancelRep)
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spRSTDiscRep()
* Called by.......: <When Document Printed>
* Parameters......: <tcQryParSID>
* Returns.........: <������ ��������� ������, ��������� ��� ������>
* Author..........: Volga
* LastEditDate....: 31 August 2006
* Notes...........: ������� ��� ������ ������ �� �������.
*-------------------------------------------------------
PROCEDURE spRSTDiscRep
LPARAMETERS tcQryParSID

*09.11.2006 21:39 ->���������� � ������������� ����������
LOCAL	lcFilterExpr, ;
		lcOldDate, ;
		lcOldCentury, ;
		lcOldMark, ;
		luQryParDateEnabled, ;
		luQryParDateStartDate, ;
		luQryParDateEndDate, ;
		luQryParCashEnabled, ;
		luQryParCashTableNM, ;
		lnConnectHandle , ;
		lnSqlExeResult 
***		
lcFilterExpr = []
				
lcOldDate		   = SET([DATE])
lcOldCentury	   = SET([CENTURY])
lcOldMark		   = SET([MARK])
*------------------------------------------------------------------------------

*******************************************************************************
*��������� ��������� ��� ������ ����������, ��������������� ���� ��������
*******************************************************************************

*09.11.2006 21:40 ->������� ������� � ���������� ��� ������
CREATE TABLE tmp\RptEnv FREE (QryParSID C(10))
INSERT INTO RptEnv (QryParSID) VALUES (tcQryParSID)
*------------------------------------------------------------------------------

*09.11.2006 21:41 ->���������� ��������� ������������, ���� ���������� �������� ����������
IF TYPE([oQryParMgr])==[O] AND !ISNULL(oQryParMgr)
	
	*09.11.2006 21:41 ->��������� ������ �� ����
	luQryParDateEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplDateEnabled])
	***
	IF !ISNULL(luQryParDateEnabled) AND TYPE([luQryParDateEnabled])==[L] AND luQryParDateEnabled
		
		*09.11.2006 21:41 ->������� ���� ��������� � ��������
		luQryParDateStartDate = oQryParMgr.ParamGet(tcQryParSID,[qpdDateStart])
		luQryParDateEndDate = oQryParMgr.ParamGet(tcQryParSID,[qpdDateEnd])
		*------------------------------------------------------------------------------

		*09.11.2006 21:41 ->��������� ������ ���� YMD � CENTURY ON
		SET DATE YMD
		SET CENTURY ON
		SET MARK TO "/"
		*------------------------------------------------------------------------------

		*09.11.2006 21:41 ->��������� �������
		DO CASE
			CASE	!ISNULL(luQryParDateStartDate) AND TYPE([luQryParDateStartDate])==[D] AND !EMPTY(luQryParDateStartDate) AND ;
					!ISNULL(luQryParDateEndDate) AND TYPE([luQryParDateEndDate])==[D] AND !EMPTY(luQryParDateEndDate)
					*{
					lcFilterExpr = lcFilterExpr + [ AND CheckSale.CheckStamp >= ']+STRTRAN(DTOC(luQryParDateStartDate),[/],[])+[' AND CheckSale.CheckStamp < ']+STRTRAN(DTOC(luQryParDateEndDate+1),[/],[])+[']
					*}
			CASE	!ISNULL(luQryParDateStartDate) AND TYPE([luQryParDateStartDate])==[D] AND !EMPTY(luQryParDateStartDate)
					*{
					lcFilterExpr = lcFilterExpr + [ AND CheckSale.CheckStamp  >= ']+STRTRAN(DTOC(luQryParDateStartDate),[/],[])+[']
					*}
			CASE	!ISNULL(luQryParDateEndDate) AND TYPE([luQryParDateEndDate])==[D] AND !EMPTY(luQryParDateEndDate)
					*{
					lcFilterExpr = lcFilterExpr + [ AND CheckSale.CheckStamp  < ']+STRTRAN(DTOC(luQryParDateEndDate+1),[/],[])+[']
					*}
		ENDCASE
		*------------------------------------------------------------------------------	
		
		*09.11.2006 21:41 ->����������� ������ ������ ����
		SET DATE (lcOldDate)
		SET CENTURY &lcOldCentury
		SET MARK TO lcOldMark
		*------------------------------------------------------------------------------

	ENDIF
	*------------------------------------------------------------------------------
	
	*09.11.2006 21:42 ->��������� ������ �� �����
	luQryParCashEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplCashEnabled])
	***
	IF !ISNULL(luQryParCashEnabled) AND TYPE([luQryParCashEnabled])==[L] AND luQryParCashEnabled
		luQryParCashTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcCashTableNM])
		IF !ISNULL(luQryParCashTableNM) AND TYPE([luQryParCashTableNM])==[C] AND FILE(luQryParCashTableNM+[.dbf])

			*10.04.2006 11:35 -> ���������� ������
			lcFilterExpr = lcFilterExpr + ;
							[ AND CheckSale.CheckCashID IN (] + spGetTmpValueList(luQryParCashTableNM) + [)]
			*------------------------------------------------------------------------------

		ENDIF
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
		[EXECUTE spRSTDiscRep ?lcFilterExpr],[tmpRptItog])
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

ENDPROC &&--(spRSTDiscRep)
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spRSTChkDelRep ()
* Called by.......: <When Document Printed>
* Parameters......: <tcQryParSID>
* Returns.........: <������ ��������� ������, ��������� ��� ������>
* Author..........: Volga
* LastEditDate....: 31 August 2006
* Notes...........: ������� ��� ������ ������ �� ��������� �������.
*-------------------------------------------------------
PROCEDURE spRSTChkDelRep 
LPARAMETERS tcQryParSID

*09.11.2006 17:50 ->���������� � ������������� ����������
LOCAL	lcFilterExpr, ;
		lcOldDate, ;
		lcOldCentury, ;
		lcOldMark, ;
		luQryParDateEnabled, ;
		luQryParDateStartDate, ;
		luQryParDateEndDate, ;
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
		[EXECUTE spRSTChkDelRep ?lcFilterExpr],[tmpRptItog])
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

ENDPROC &&--(spRSTChkDelRep )
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************
  
    
*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spCouponReport()
* Called by.......: <NA>
* Parameters......: <tnCheckID>
* Returns.........: <none>
* Notes...........: ������� ��� ������ �� �������
*------------------------------------------------------------------------------
PROCEDURE spCouponReport
LPARAMETERS tcQryParSID

*02.08.2006 09:30 ->���������� � ������������� ����������
LOCAL	lcOldDate, ;
		lcOldCentury, ;
		lcOldMark, ;
		lcFilterExpr, ;
		luQryParDateEnabled, ;
		luQryParDateStartDate, ;
		luQryParCashEnabled, ;
		luQryParCashTableNM, ;
		luQryParCashierEnabled, ;
		luQryParCashierTableNM, ;
		luQryParCltIspEnabled, ;
		luQryParIspIDTableNM, ;
		lnConnectHandle, ;
		lnSqlExeResult
***
lcOldDate = SET([DATE])
lcOldCentury = SET([CENTURY])
lcOldMark = SET([MARK])
lcFilterExpr = []
*------------------------------------------------------------------------------

*02.08.2006 09:30 ->������� ������� � ���������� ��� ������
CREATE TABLE tmp\RptEnv FREE (QryParSID C(10))
INSERT INTO RptEnv (QryParSID) VALUES (tcQryParSID)
*------------------------------------------------------------------------------

*02.08.2006 09:30 ->���������� ������� ������ �� ����
luQryParDateEnabled   = oQryParMgr.ParamGet(tcQryParSID,[qplDateEnabled])
luQryParDateStartDate = oQryParMgr.ParamGet(tcQryParSID,[qpdDateStart])
luQryParDateEndDate   = oQryParMgr.ParamGet(tcQryParSID,[qpdDateEnd])
***
IF !ISNULL(luQryParDateEnabled)   AND TYPE([luQryParDateEnabled])==[L]   AND luQryParDateEnabled AND ;
   !ISNULL(luQryParDateStartDate) AND TYPE([luQryParDateStartDate])==[D] AND !EMPTY(luQryParDateStartDate) AND ;
   !ISNULL(luQryParDateEndDate)   AND TYPE([luQryParDateEndDate])==[D]   AND !EMPTY(luQryParDateEndDate)

	*02.08.2006 09:30 ->��������� ������ ���� YMD � CENTURY ON
	SET DATE YMD
	SET CENTURY ON
	SET MARK TO "/"
	*------------------------------------------------------------------------------

	*02.08.2006 09:31 ->���������� ������� ������
	lcFilterExpr = lcFilterExpr + [ AND CheckSale.CheckStamp >= ']+STRTRAN(DTOC(luQryParDateStartDate),[/],[])+[' AND CheckSale.CheckStamp < ']+STRTRAN(DTOC(luQryParDateEndDate+1),[/],[])+[']
	*------------------------------------------------------------------------------

	*02.08.2006 09:31 ->����������� ������ ������ ����
	SET DATE (lcOldDate)
	SET CENTURY &lcOldCentury
	SET MARK TO lcOldMark
	*------------------------------------------------------------------------------

ENDIF
*------------------------------------------------------------------------------

*02.08.2006 09:33 ->��������� ������ �� �����
luQryParCashEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplCashEnabled])
***
IF !ISNULL(luQryParCashEnabled) AND TYPE([luQryParCashEnabled])==[L] AND luQryParCashEnabled
	luQryParCashTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcCashTableNM])
	IF !ISNULL(luQryParCashTableNM) AND TYPE([luQryParCashTableNM])==[C] AND FILE(luQryParCashTableNM+[.dbf])
		***
		lcFilterExpr = lcFilterExpr + ;
				[ AND CheckSale.CheckCashID IN (] + spGetTmpValueList(luQryParCashTableNM) + [)]

	ENDIF
ENDIF
*------------------------------------------------------------------------------

*02.08.2006 09:34 ->��������� ������ �� �����
luQryParCashierEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplCashierEnabled])
***
IF !ISNULL(luQryParCashierEnabled) AND TYPE([luQryParCashierEnabled])==[L] AND luQryParCashierEnabled
	luQryParCashierTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcCashierTableNM])
	IF !ISNULL(luQryParCashierTableNM) AND TYPE([luQryParCashierTableNM])==[C] AND FILE(luQryParCashierTableNM+[.dbf])
		***
		lcFilterExpr = lcFilterExpr + ;
				[ AND CheckSale.CheckCashierID IN (] + spGetTmpValueList(luQryParCashierTableNM) + [)]

	ENDIF
ENDIF
*------------------------------------------------------------------------------

*02.08.2006 09:34 ->��������� ������ �� �������
luQryParCashierEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplCashierEnabled])
***
IF !ISNULL(luQryParCashierEnabled) AND TYPE([luQryParCashierEnabled])==[L] AND luQryParCashierEnabled
	luQryParCashierTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcCashierTableNM])
	IF !ISNULL(luQryParCashierTableNM) AND TYPE([luQryParCashierTableNM])==[C] AND FILE(luQryParCashierTableNM+[.dbf])
		***
		lcFilterExpr = lcFilterExpr + ;
				[ AND CheckSale.CheckCashierID IN (] + spGetTmpValueList(luQryParCashierTableNM) + [)]

	ENDIF
ENDIF
*------------------------------------------------------------------------------

*02.08.2006 09:47 ->��������� ������ �� �����������
luQryParCltIspEnabled = oQryParMgr.ParamGet(tcQryParSID,[qplCltIspEnabled])
***
IF !ISNULL(luQryParCltIspEnabled) AND TYPE([luQryParCltIspEnabled])==[L] AND luQryParCltIspEnabled
	luQryParIspIDTableNM = oQryParMgr.ParamGet(tcQryParSID,[qpcCltISpIDTableNM])
	IF !ISNULL(luQryParIspIDTableNM) AND TYPE([luQryParIspIDTableNM])==[C] AND FILE(luQryParIspIDTableNM+[.dbf])
		***
		lcFilterExpr = lcFilterExpr + ;
				[ AND Coupon.CltID IN (] + spGetTmpValueList(luQryParIspIDTableNM) + [)]

	ENDIF
ENDIF
*------------------------------------------------------------------------------

*02.08.2006 09:49 ->����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*02.08.2006 09:49 ->��������� ������
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[EXECUTE spCouponReport ?lcFilterExpr],[RptItog])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*02.08.2006 09:49 ->������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

*02.08.2006 09:49 ->�������� ������� �� ���� � �������
SELECT RptItog
COPY TO tmp\RptItog.dbf
***
USE IN SELECT([RptItog])
*------------------------------------------------------------------------------

*02.08.2006 10:04 ->����������� �������
USE RptItog IN 0
SELECT RptItog
INDEX ON OrgNM TAG OrgNM
INDEX ON OrgNM + RTRIM(CouponNM) TAG OrgCoupNM
***
USE IN SELECT([RptItog])
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: _spUpdateStampAndUser()
* Called by.......: <NA>
* Parameters......: <none>
* Returns.........: <none>
* Notes...........: <~>
*------------------------------------------------------------------------------
PROCEDURE _spUpdateStampAndUser
LPARAMETERS tcAliasName, tnUserID

*23.01.2006 15:00 -> ���������� � ������������� ����������
LOCAL	lnFieldCount, ;
		lnCounter, ;
		llFieldIsExist
***
lnFieldCount = AFIELDS(laFieldArray,tcAliasName)
*------------------------------------------------------------------------------

*23.01.2006 15:40 -> ��������� ������������� ������������
llFieldIsExist = .F.
***
FOR lnCounter = 1 TO lnFieldCount
	IF UPPER(ALLTRIM(laFieldArray(lnCounter,1))) == [USER_]
		llFieldIsExist = .T.
		EXIT
	ENDIF
ENDFOR
***
IF llFieldIsExist
	REPLACE User_ WITH tnUserID IN (tcAliasName)
ENDIF
*------------------------------------------------------------------------------

*23.01.2006 11:36 -> ���������� ���������
RETURN .T.
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: spHandleODBCError()
* Called by.......: <NA>
* Parameters......: <taErrors>
* Returns.........: <none>
* Notes...........: ��������� ������ ODBC
*------------------------------------------------------------------------------
PROCEDURE spHandleODBCError

*28.07.2006 09:38 ->���������� � ������������� ����������
LOCAL	lnErrorRowsCount, ;
		lnCounter, ;
		lcErrorMessage
***
LOCAL ARRAY laErrors[1]
***
lcErrorMessage = []
*------------------------------------------------------------------------------

*21.01.2004 18:52 -> ��������� ���������� �� ������
lnErrorRowsCount = AERROR(laErrors)
*------------------------------------------------------------------------------

*28.07.2006 09:37 -> ��������������� ���������� ��� ������ 
FOR lnCounter = 1 TO lnErrorRowsCount
	IF laErrors[lnCounter,5] # 50001
		lcErrorMessage = lcErrorMessage + STRTRAN(laErrors[lnCounter,3],pcvERRORHEADMSG,[* ]) + CHR(13)
	ENDIF
	STRTOFILE(TTOC(DATETIME())+[ -> ] + STRTRAN(laErrors[lnCounter,3],pcvERRORHEADMSG,[]) + CHR(13),[Error.log],1)
ENDFOR
*------------------------------------------------------------------------------

*28.07.2006 09:46 -> ������� ��������� ������������
IF lnErrorRowsCount > 0
	MESSAGEBOX(lcErrorMessage,16,[������ ����������...])
ENDIF
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: dbc_AfterOpenTable()
* Called by.......: <DBC Event>
* Parameters......: <tcTableName>
* Returns.........: <none>
* Notes...........: 
*------------------------------------------------------------------------------
PROCEDURE dbc_AfterOpenTable(tcTableName)

*31.03.2006 16:50 ->���������� � ������������� ����������
LOCAL	lnConnHandler, ;
		lnSqlExeResult
***
lnConnHandler = -1
*------------------------------------------------------------------------------

*31.03.2006 16:51 -> ������� ����� Connection
IF CURSORGETPROP([SourceType],tcTableName) = 2 && Remote View
	lnConnHandler = CURSORGETPROP([ConnectHandle],tcTableName)
ENDIF
*------------------------------------------------------------------------------

*31.03.2006 16:52 -> �������� ��������� ������� ��� �������� ID
IF lnConnHandler > 0
	lnSqlExeResult = 0
	DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
		lnSqlExeResult = SQLEXEC(lnConnHandler, ;
			[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
			[IF OBJECT_ID('tempdb..#LastIncrID') IS NULL CREATE TABLE #LastIncrID (TableNM varchar(40), LastID INT)])
	ENDDO
	***
	IF lnSqlExeResult = -1
		spHandleODBCError()
		RETURN
	ENDIF
ENDIF
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: GetServerDate()
* Called by.......: <>
* Parameters......: <none>
* Returns.........: <none>
* Notes...........: <��������� ���� � �������>
*------------------------------------------------------------------------------
PROCEDURE GetServerDate
*31.03.2006 16:50 ->���������� � ������������� ����������
LOCAL	lnConnectHandle, ;
		lnSqlExeResult, ;
		ltServerDate AS Datetime
*------------------------------------------------------------------------------

*28.03.2007 12:10 ->����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*28.03.2007 12:10 ->�������� ���� � �������
IF lnConnectHandle > 0
	lnSqlExeResult = 0
	DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
		lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
			[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
			[SELECT GETDATE() AS GetDate],[curGetDate])
	ENDDO
	***
	IF lnSqlExeResult = -1
		spHandleODBCError()
		SQLDISCONNECT(lnConnectHandle)
		RETURN CTOT([])
	ENDIF
	
	ltSErverDate = curGetDate.GetDate
	USE IN SELECT([curGetDate])
ENDIF
*------------------------------------------------------------------------------

*28.03.2007 12:13 ->������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

RETURN ltSErverDate

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: LockEnter()
* Called by.......: <>
* Parameters......: <none>
* Returns.........: <none>
* Notes...........: <�������� ����������� ������� ���������>
*------------------------------------------------------------------------------
PROCEDURE LockEnter

*02.04.2007 09:42 ->���������� � ������������� ����������
LOCAL	lnConnectHandle AS Integer, ;
		lnSqlExeResult	AS Integer, ;
		llResult		AS Boolean
*------------------------------------------------------------------------------

*02.04.2007 09:42 ->����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*28.03.2007 12:10 ->��������� ����������� ������� ���������
IF lnConnectHandle > 0
	lnSqlExeResult = 0
	DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
		lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
			[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
			[SELECT COUNT(*) FROM EventJrn WHERE EventJrn.EventJrnCode = 1],[curEventJrn])
	ENDDO
	***
	IF lnSqlExeResult = -1
		SQLDISCONNECT(lnConnectHandle)
		RETURN .F.
	ENDIF
	
	llResult = (RECCOUNT([curEventJrn]) = 0)
	USE IN SELECT([curEventJrn])
ENDIF
*------------------------------------------------------------------------------

*28.03.2007 12:13 ->������ ����������: ����������� ����������
SQLDISCONNECT(lnConnectHandle)
*------------------------------------------------------------------------------

RETURN llResult

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************