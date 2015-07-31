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
