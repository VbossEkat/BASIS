*-------------------------------------------------------
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
