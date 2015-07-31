*-------------------------------------------------------
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
