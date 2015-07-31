*28.03.2007 13:32 ->����������� ������ ��� ��������� ���������
DEFINE CLASS WorkSession AS Session

DataSession = 2
SessionID	= 0
oTimer		= .NULL.
oMessenger	= .NULL.
oSQLServer  = .NULL.
*28.03.2007 13:37 ->�������������
PROCEDURE Init
	
	*28.03.2007 13:35 ->������ ����������� ���������
	SET EXCLUSIVE OFF
	SET DELETED ON
	SET TALK OFF
	SET SAFETY OFF
	SET DATE TO GERMAN
	*------------------------------------------------------------------------------
	This.oTimer = CREATEOBJECT([TmrSession],This)
*	This.oSQLServer = CREATEOBJECT([SQLDMO.SQLServer])
	*TRY
	*	This.oSQLServer = CREATEOBJECT([SQLDMO.SQLServer])
	**	This.oSQLServer.Name = This.GetServerName()
	*CATCH
	*ENDTRY
	
ENDPROC
*******************************************************************************
********************************* END METHOD **********************************
*******************************************************************************
PROCEDURE Destroy
	WAIT WINDOW '��������� ������ ' NOWAIT 
	this.CloseSession()
		
ENDPROC
*******************************************************************************
********************************* END METHOD **********************************
*******************************************************************************
PROCEDURE GetServerName
*11.12.2006 16:06 ->���������� � ������������� ����������
LOCAL   lcConnectionString, ;
		lcServerName
*------------------------------------------------------------------------------

*11.12.2006 16:06 ->�������� ��� ������� �� ConnectionString
SET DATABASE TO Basis
lcConnectionString = DBGETPROP([SQLBASISCONNECTION],[CONNECTION],[ConnectString])
*lcConnectionString = UPPER(DBGETPROP([SQLBASISCONNECTION],[CONNECTION],[ConnectString]))
lcServerName = SUBSTR(lcConnectionString,AT([SERVER=],lcConnectionString))
lcServerName = STRTRAN(lcServerName,[SERVER=],[])
lcServerName = LEFT(lcServerName,AT([;],lcServerName)-1)
*------------------------------------------------------------------------------

RETURN lcServerName
*******************************************************************************
********************************* END METHOD **********************************
********************************************************************************28.03.2007 15:22 ->�������� ��
PROCEDURE OpenDatabase
LOCAL llStatusGetResult
llStatusGetResult = .t.
	IF !DBUSED([Basis])
		OPEN DATABASE Basis SHARED
	ENDIF
	***
	SET DATABASE TO Basis
	*15.07.2007 18:41 ->�������� ������ ��� ������� � �������
	RETURN .t.
	TRY
		*This.oSQLServer = CREATEOBJECT([SQLDMO.SQLServer])
		*This.oSQLServer.Name = This.GetServerName()
		*12.12.2006 10:56 ->������� ������
		*lnSQLServerStatus = This.oSQLServer.Status
		
		lnSQLServerStatus = 1
		
        WAIT WINDOW TTOC(DATETIME()) + CHR(13) +[������ ������� ] + This.GetServerName() + ;
        IIF(lnSQLServerStatus=1,': ��������',': ����������') nowait
		*------------------------------------------------------------------------------
		
	CATCH
		llStatusGetResult = .F.
		MESSAGEBOX([������ ]+This.GetServerName()+[ ����������.]+CHR(13)+[���������� � ��������������.],64,[������ ��������� ����])
		CLOSE DATABASES all
		CLEAR EVENTS 
	ENDTRY
	IF !llStatusGetResult
		RETURN .f.
    ENDIF
    RETURN .t.
		MESSAGEBOX([������ ]+This.GetServerName()+[ ����������.]+CHR(13)+[���������� � ��������������.],64,[������ ��������� ����])
		CLOSE DATABASES all
		CLEAR EVENTS 
		CLOSE all
		CLEAR ALL
		quit
  **  RETURN .f.
ENDPROC
*******************************************************************************
********************************* END METHOD **********************************
*******************************************************************************

*28.03.2007 13:37 ->����� ���������
PROCEDURE RecieveMessage
	*28.03.2007 11:55 ->���������� � ������������� ����������
	LOCAL   _PARAM,_PARAM1, ;
			lnUserMsgID, ;
			loSimpleMsgViewer, ;
			lnUserMsgActionID, ;
			lWk
	*------------------------------------------------------------------------------

	*28.03.2007 13:36 ->������� ��
	IF !This.OpenDatabase()
    	RETURN .f.
	ENDIF
	*------------------------------------------------------------------------------
	This.oTimer.Enabled = .f.
	*28.03.2007 11:55 ->�������� ���������
	USE IN SELECT([lvUserMsgLast])
	_PARAM = This.SessionID
	IF VARTYPE(oApp)<>'O'
		CANCEL 
	ENDIF 
	_PARAM1= oApp.nUserKod
	lWk = .t.
	TRY
		USE lvUserMsgLast IN 0 SHARED
	CATCH
		**llStatusGetResult = .F.
		MESSAGEBOX([������ ����������.]+CHR(13)+[���������� � ��������������.],64,[������ ��������� ����])
		CLOSE DATABASES all
		lWk = .f.
		CLEAR EVENTS 
	ENDTRY
	IF !lWk 
    	RETURN .f.
	ENDIF
	lnUserMsgID = lvUserMsgLast.UserMsgID
	*------------------------------------------------------------------------------
	
	*28.03.2007 13:38 ->��� ������� ������ ��������� �������� ��� ��� ����������
	IF lnUserMsgID <> 0

		lnUserMsgActionID = lvUserMsgLast.UserMsgActionID

		*28.03.2007 14:54 ->������� ���������
		IF TYPE([This.oMessenger]) == [O]
			This.oMessenger.NewMsg(lnUserMsgID)
		ELSE
			oApp.DoFormObj( ;
				[frmsimplemsgviewer;admin;admin.app], ;
				ALLTRIM(lvUserMsgLast.UserMsgCont), ;
				ALLTRIM(lvUserMsgLast.UserLogin), ;
				lvUserMsgLast.UserMsgCreateDate, ;
				This.SessionID)
		ENDIF
		*------------------------------------------------------------------------------

		USE IN SELECT([lvUserMsgEdit])
		_PARAM = lnUserMsgID
		USE lvUserMsgEdit IN 0
		UPDATE lvUserMsgEdit SET UserMsgReceptionDate = GetServerDate()
		TABLEUPDATE(1,.T.,[lvUserMsgEdit])
		
		IF lnUserMsgActionID = 1
			MESSAGEBOX([��������� ����� �������!], 64, [�����������������], 30000)
			CLEAR EVENTS
		ENDIF
		 
	ENDIF
	*------------------------------------------------------------------------------
	This.oTimer.Enabled = .t.
ENDPROC
*******************************************************************************
********************************* END METHOD **********************************
*******************************************************************************
	
*28.03.2007 15:18 ->����������� ������ ������
PROCEDURE OpenSession
LPARAMETERS tnUserID
	LOCAL	lcWSNM, ;
			lcUserNM, ;
			llResult, ;
			_PARAM, ;
			nMaxCnt

	*28.03.2007 13:36 ->������� ��
	IF !This.OpenDatabase()
	   RETURN .f.
	ENDIF
	*------------------------------------------------------------------------------

	*28.03.2007 15:23 ->�������� ������
	lcWSNM   = SYS(0)
	lcUserNM = ALLTRIM(SUBSTR(lcWSNM,AT([#],lcWSNM)+1))
	lcWSNM   = ALLTRIM(LEFT(lcWSNM,AT([#],lcWSNM)-1))
	_PARAM = tnUserID
	USE lvsessioncontrol IN 0
	SELECT lvsessioncontrol 
	IF RECCOUNT('lvsessioncontrol')>0 
		IF MESSAGEBOX('������������ '+ lcUserNM +' ��� � �������,'+CHR(13);
								+ '�� ���������� '+ALLTRIM(lvsessioncontrol.WsNm)+'. ��������� ���?',4+64;
								,'������������ '+ lcUserNM +' ��� � �������')=6
			REPLACE ALL lvsessioncontrol.sessionstatus WITH 3
			*** sessionstatus = 3 - �������������� ��������
			USE IN SELECT([lvsessioncontrol])
		ELSE 
			RETURN .f.
		ENDIF 
	ENDIF 
	USE IN SELECT([lvsessioncontrol])
	***
	*** - 13.06.2009 17:20:53 ������ �.�. (C) - > 
	*** USE lvMaxCnt IN 0
	USESPR('lvMaxCnt')
	nMaxCnt = VAL(SUBSTR(lvMaxCnt.MaxCnt,AT(']',lvMaxCnt.MaxCnt)+1))
	USE IN SELECT([lvMaxCnt])
	USE lvsessionview IN 0
	IF RECCOUNT('lvsessionview')+1 > nMaxCnt 
		MESSAGEBOX('���������� ����������� ��������� �����������.',0+64,'���������� ������������� � �������: '+STR(RECCOUNT('lvsessionview'),4,0))
		USE IN SELECT([lvsessionview])
		RETURN .f.
	ENDIF
	USE IN SELECT([lvsessionview])
	*** - 13.06.2009 17:20:46 ������ �.�. (C) - > 
	SET DATABASE to Basis
	USE IN SELECT([lvSessionEdit])
	USE lvSessionEdit IN 0 NODATA
	INSERT INTO lvSessionEdit ( ;
		WSNM, UserNM, UserId, SessionStatus) ; 
	VALUES ( ;
		lcWSNM, lcUserNM, tnUserID, 1)
	***
	llResult = TABLEUPDATE(1,.T.,[lvSessionEdit])

	IF llResult
		This.SessionID = spGetLastIncrementedID([lvSessionEdit])
	ENDIF
	*------------------------------------------------------------------------------	
	This.oTimer.Timer
	RETURN llResult
ENDPROC
*******************************************************************************
********************************* END METHOD **********************************
*******************************************************************************

*28.03.2007 15:45 ->���������� ������ ������
PROCEDURE CloseSession
	LOCAL	_PARAM, lWk
	lWk = .t.
	*28.03.2007 15:46 ->������� ��
	IF !This.OpenDatabase()
	   RETURN .f.
	ENDIF
	*------------------------------------------------------------------------------
	
	*28.03.2007 15:46 ->������� ������
	USE IN SELECT([lvSessionEdit])
	_PARAM = This.SessionID

	TRY 
		USE lvSessionEdit IN 0
	CATCH 
		lWk = .f.
	ENDTRY 

	IF !lWk
		MESSAGEBOX([������ ����������.]+CHR(13)+[���������� � ��������������.],64,[������ ��������� ����])
		RETURN .f.
	ENDIF 
	UPDATE lvSessionEdit SET SessionStatus = 2
	UPDATE lvSessionEdit SET SessionDuration = GetServerDate()
	***
	RETURN TABLEUPDATE(1,.T.,[lvSessionEdit])
ENDPROC
*******************************************************************************
********************************* END METHOD **********************************
*******************************************************************************

*28.03.2007 15:45 ->��������� ���������� ������
PROCEDURE LiveSession
	LOCAL	_PARAM
	LOCAL llStatusGetResult
	llStatusGetResult = .t.

	*28.03.2007 15:46 ->������� ��
	IF !This.OpenDatabase()
	RETURN .f.
	ENDIF
	*------------------------------------------------------------------------------
	TRY
	
    	*28.03.2007 15:46 ->������� ������
	  USE IN SELECT([lvSessionEdit])
	  _PARAM = This.SessionID
	  USE lvSessionEdit IN 0
	  UPDATE lvSessionEdit SET SessionDuration = GetServerDate()
	CATCH
		llStatusGetResult = .F.
		MESSAGEBOX([������ ]+This.GetServerName()+[ ����������.]+CHR(13)+[���������� � ��������������.],64,[������ ��������� ����])
	ENDTRY
	***
	IF !llStatusGetResult
		RETURN .f.
    ENDIF
	IF lvSessionEdit.SessionStatus >1
		MESSAGEBOX('������������ �������� �� ������� ...',0+64,'������ ����������� ...')
		TABLEUPDATE(1,.T.,[lvSessionEdit])
		CLEAR EVENTS 
	ENDIF
	RETURN TABLEUPDATE(1,.T.,[lvSessionEdit])
ENDPROC
*******************************************************************************
********************************* END METHOD **********************************
*******************************************************************************

*30.03.2007 16:18 ->������ ������� 
PROCEDURE TimerEnable
LPARAMETERS tlEnabled

	This.oTimer.Enabled = tlEnabled

ENDPROC
*******************************************************************************
********************************* END METHOD **********************************
*******************************************************************************

PROCEDURE oMessenger_ASSIGN
LPARAMETERS toMessenger

This.oMessenger = toMessenger

ENDPROC
*******************************************************************************
********************************* END METHOD **********************************
*******************************************************************************

ENDDEFINE
*------------------------------------------------------------------------------

DEFINE CLASS TmrSession AS Timer

oSession = .NULL.

PROCEDURE Init
LPARAMETERS toSession

	This.oSession = toSession
	*** � ����� ��������
	This.Interval = 60000
	This.Enabled  = .t.
	IF FILE('tmp\tmpUserGrant.dbf')
		ERASE tmp\tmpUserGrant.dbf
	ENDIF 
	
ENDPROC
*******************************************************************************
********************************* END METHOD **********************************
*******************************************************************************

*28.03.2007 14:51 ->�����
PROCEDURE Timer
	LOCAL   lnOldInterval
	This.oSession.RecieveMessage()
	This.oSession.LiveSession()
	lnOldInterval = This.Interval
	This.Enabled = .T.
	RETURN .t.
	
	
	
	This.Enabled = .F.
	This.Interval = 0
	***
	IF TYPE('This.oSQLServer')=[O] AND This.oSQLServer.Status = 3
		MESSAGEBOX([������ ]+This.oSQLServer.Name+[ ����������.]+CHR(13)+[���������� � ��������������.],64,[������ ��������� ����])
		This.Interval = lnOldInterval
	    This.Enabled = .T.
	    RETURN .t.
    ENDIF
	***
	This.Interval = lnOldInterval
	This.Enabled = .T.
ENDPROC
*******************************************************************************
********************************* END METHOD **********************************
*******************************************************************************


ENDDEFINE


*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************