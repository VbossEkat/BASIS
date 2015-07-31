*-------------------------------------------------------
* Project.........: POS.PJX
* File............: SartUp_POS.PRG
* Module/Procedure: SartUp_POS()
* Called by.......: <NA>
* Parameters......: <none>
* Returns.........: <none>
* Notes...........: ������� ���������
*-------------------------------------------------------
LPARAMETERS luParamString
*= NUMLOCK(.T.)
*01.05.2004 20:00 ->��� ����������� ������������ ���������� ���������� ���������
#DEFINE cnAPPLICATION_NAME	POS
*------------------------------------------------------------------------------
*01.05.2004 19:51 ->���������� � ������������� ����������
LOCAL	lcExecuteProgram, ;
		lcExecuteProgramExtension, ;
		lcExecuteProgramPath, ;
		lcApplicationNM, ;
		lcApplicationClassLib, ;
		lcApplicationIniFNM, ;
		llLibLoad
***
lcExecuteProgram = SYS(16)
lcExecuteProgramExtension = UPPER(RIGHT(lcExecuteProgram,3))
lcExecuteProgramPath = UPPER(SUBSTR(lcExecuteProgram,1,RAT([\],lcExecuteProgram)))
***
lcApplicationNM = [cnAPPLICATION_NAME]
lcApplicationClassLib = lcApplicationNM + [.VCX]
lcApplicationIniFNM = lcExecuteProgramPath + lcApplicationNM + [.INI]
*------------------------------------------------------------------------------
_Screen.BackColor = RGB(212,208,200)

PUBLIC llDebugModeFlg 
*02.05.2004 15:00 ->�������� ����� �������
IF INLIST(lcExecuteProgramExtension,[EXE],[APP],[DLL])
	llDebugModeFlg = .F.
ELSE
	llDebugModeFlg = .T.	
ENDIF
*------------------------------------------------------------------------------

*02.05.2004 15:47 ->�������� � ������� ���������� � ��������� ����������� ����
IF lcExecuteProgramPath # FULLPATH(CURDIR())
	CD (lcExecuteProgramPath)
ENDIF
***
IF !llDebugModeFlg
	SET PATH TO [Tmp;ImgBmp;ImgIco;Resource;OCX;Data]
ELSE
	SET PATH TO [Tmp;ImgBmp;ImgIco;Resource;Graphic;Library;Menu;Program;FoxUnit;FoxUnitTest;OCX]
ENDIF	
*------------------------------------------------------------------------------

*02.05.2004 15:47 ->�������� ������ ��� ������ � ����������
IF !([GENERAL_V1.VCX]$SET([CLASSLIB]))
	SET CLASSLIB TO GENERAL_V1.VCX ALIAS GENERAL_V1 ADDITIVE
	llLibLoad = .T.
ELSE
	llLibLoad = .F.	
ENDIF
oEnv = CREATEOBJECT([environment],llDebugModeFlg)
IF llLibLoad
	RELEASE CLASSLIB ALIAS GENERAL_V1
ENDIF
*------------------------------------------------------------------------------
*02.05.2004 15:48 ->�������� ������ ��� ������ � INI ������� 
IF !([GENERAL_V1.VCX]$SET([CLASSLIB]))
	SET CLASSLIB TO GENERAL_V1.VCX ALIAS GENERAL_V1 ADDITIVE
	llLibLoad = .T.
ELSE
	llLibLoad = .F.	
ENDIF
oRes = CREATEOBJECT([resource],lcApplicationIniFNM)
IF llLibLoad
	RELEASE CLASSLIB ALIAS GENERAL_V1
ENDIF
*------------------------------------------------------------------------------		

*02.05.2004 15:48 ->�������� ������ ��� ������ � ����������� �������
IF !([QUERYPARAMIO_V1.VCX]$SET([CLASSLIB]))
	SET CLASSLIB TO QUERYPARAMIO_V1.VCX ALIAS QUERYPARAMIO_V1 ADDITIVE
	llLibLoad = .T.
ELSE
	llLibLoad = .F.	
ENDIF
oQryParMgr = CREATEOBJECT([QueryParamMgr])
IF llLibLoad
	RELEASE CLASSLIB ALIAS QUERYPARAMIO_V1
ENDIF
*------------------------------------------------------------------------------		

*02.05.2004 15:52 ->������� ������ ����������
IF !(lcApplicationClassLib$SET([CLASSLIB]))
	SET CLASSLIB TO (lcApplicationClassLib) ALIAS (lcApplicationNM) ADDITIVE
	llLibLoad = .T.
ELSE
	llLibLoad = .F.	
ENDIF
oApp = CREATEOBJECT(lcApplicationNM,llDebugModeFlg)
IF llLibLoad
	RELEASE CLASSLIB ALIAS (lcApplicationNM)
ENDIF
*------------------------------------------------------------------------------

*25.09.2006 14:44 ->�������� ������ ��� ������ �� �����-������
IF !([TOVARLOOKUP_V1.VCX]$SET([CLASSLIB]))
	SET CLASSLIB TO TOVARLOOKUP_V1.VCX ALIAS TOVARLOOKUP_V1 ADDITIVE
	llLibLoad = .T.
ELSE
	llLibLoad = .F.	
ENDIF
oTLU = CREATEOBJECT([TovarLookUp])
IF llLibLoad
	RELEASE CLASSLIB ALIAS TOVARLOOKUP_V1
ENDIF
*------------------------------------------------------------------------------		

*19.01.2005 15:39 -> ������� ������� ���������
IF TYPE([oApp]) == [O]
	oMgrPOS		 = oApp.CreateObject([interface;pos_v1.vcx])
	oSession	 = NEWOBJECT([WorkSession],[Messenger.prg])
ENDIF	
*------------------------------------------------------------------------------
SET HELP OFF
*02.05.2004 16:02 ->��������� ����������
IF TYPE([oApp]) == [O]
	oApp.StartUp()
ENDIF
*------------------------------------------------------------------------------

*******************************************************************************
*����� ����, ��� ���������� ���������� ������� ������� � ������ ��� ������������������
*******************************************************************************
RELEASE oApp
RELEASE oMgrPOS
RELEASE oRes
RELEASE oSession
RELEASE oEnv
*------------------------------------------------------------------------------
SET HELP ON
*02.05.2004 16:03 ->������� ������ ���������� ����� ������� ���������
CLEAR ALL
*------------------------------------------------------------------------------
*= NUMLOCK(.F.)
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************