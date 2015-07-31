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



CLOSE DATABASES ALL

*01.05.2004 20:00 ->��� ����������� ������������ ���������� ���������� ���������
#DEFINE cnAPPLICATION_NAME	RST
*------------------------------------------------------------------------------
_Screen.BackColor = RGB(212,208,200)
_screen.Enabled = .f.

*01.05.2004 19:51 ->���������� � ������������� ����������
LOCAL	lcExecuteProgram, ;
		lcExecuteProgramExtension, ;
		lcExecuteProgramPath, ;
		lcApplicationNM, ;
		lcApplicationClassLib, ;
		lcApplicationIniFNM, ;
		llLibLoad,;
		lChangeDisp
***
lChangeDisp = .f.
lcExecuteProgram = SYS(16)
lcExecuteProgramExtension = UPPER(RIGHT(lcExecuteProgram,3))
lcExecuteProgramPath = UPPER(SUBSTR(lcExecuteProgram,1,RAT([\],lcExecuteProgram)))
***
lcApplicationNM = [cnAPPLICATION_NAME]
lcApplicationClassLib = lcApplicationNM + [.VCX]
lcApplicationIniFNM = lcExecuteProgramPath + lcApplicationNM + [.INI]
SET HELP off 
*------------------------------------------------------------------------------
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
	SET PATH TO [Tmp;ImgBmp;ImgIco;Resource;OCX]
ELSE
	SET PATH TO [Tmp;ImgBmp;ImgIco;Resource;Graphic;Library;Menu;Program;OCX]
ENDIF	
*------------------------------------------------------------------------------
IF llDebugModeFlg 
DisplaySett(800)
ENDIF 

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
**------------------------------------------------------------------------------
*SET STEP ON
*19.01.2005 15:39 -> ������� ������� ���������
IF TYPE([oApp]) == [O]
	oMgrOrder    = oApp.CreateObject([interface;rst.vcx;rst.app])
*	oSession1	 = NEWOBJECT([WorkSession],[Messenger.prg])
	oSession	 = NEWOBJECT([WorkSession],[Messenger.prg])
ENDIF	
*------------------------------------------------------------------------------
_screen.TitleBar = 0
DO good_wind
*02.05.2004 16:02 ->��������� ����������
SET STATUS BAR Off
_screen.TitleBar= 0

IF TYPE([oApp]) == [O]
	oApp.StartUp()
ENDIF
*------------------------------------------------------------------------------

*******************************************************************************
*����� ����, ��� ���������� ���������� ������� ������� � ������ ��� ������������������
*******************************************************************************
RELEASE oApp
RELEASE oMgrOrder
RELEASE oRes
*RELEASE oSession1
RELEASE oSession
RELEASE oEnv
*------------------------------------------------------------------------------

= NUMLOCK(.t.)
IF llDebugModeFlg AND lChangeDisp 
DisplaySett()
ENDIF 
SET STATUS BAR ON
_screen.TitleBar= 1
SET HELP ON 
_screen.Enabled = .t.
*02.05.2004 16:03 ->������� ������ ���������� ����� ������� ���������
CLEAR ALL
*------------------------------------------------------------------------------
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************