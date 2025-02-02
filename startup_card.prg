*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: BASIS.PRG
* Module/Procedure: BASIS()
* Called by.......: <NA>
* Parameters......: <none>
* Returns.........: <none>
* Notes...........: ������� ���������
*-------------------------------------------------------
LPARAMETERS luParamString

*01.05.2004 20:00 ->��� ����������� ������������ ���������� ���������� ���������
#DEFINE cnAPPLICATION_NAME	BASIS_CARD
*------------------------------------------------------------------------------

_SCREEN.WindowState = 2

*01.05.2004 19:51 ->���������� � ������������� ����������
LOCAL	lcExecuteProgram, ;
		lcExecuteProgramExtension, ;
		lcExecuteProgramPath, ;
		lcApplicationNM, ;
		lcApplicationClassLib, ;
		lcApplicationIniFNM, ;
		llDebugModeFlg, ;
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
	SET PATH TO [Tmp;ImgBmp;ImgIco;Resource]
ELSE
	SET PATH TO [Tmp;ImgBmp;ImgIco;Resource;Graphic;Library;Menu;Program]
	CLOSE DATABASES ALL
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

*19.01.2005 15:39 -> ������� ������� ���������
IF TYPE([oApp]) == [O]
	oMgrClient   = oApp.CreateObject([interface;client_v1;client.app])
	oMgrPD 	     = oApp.CreateObject([interface;primarydoc_v1;primarydoc.app])
	oMgrRpt      = oApp.CreateObject([interface;report_v1;report.app])
	oMgrFormType = oApp.CreateObject([interface;formtype_v1;formtype.app])
	oMgrQryPar   = oApp.CreateObject([interface;queryparam_v1;queryparam.app])
	oMgrScrFrm   = oApp.CreateObject([interface;screenform_v1;screenform.app])
	oMgrUser	 = oApp.CreateObject([interface;user_v1;user.app])
	oMgrCard	 = oApp.CreateObject([interface;card_v1;card.app])
ENDIF	
*------------------------------------------------------------------------------

*02.05.2004 16:02 ->��������� ����������
IF TYPE([oApp]) == [O]
	oApp.StartUp()
ENDIF
*------------------------------------------------------------------------------

*******************************************************************************
*����� ����, ��� ���������� ���������� ������� ������� � ������ ��� ������������������
*******************************************************************************
RELEASE oMgrCard
RELEASE oMgrClient
RELEASE oMgrPD
RELEASE oMgrRpt
RELEASE oMgrFormType
RELEASE oMgrQryPar
RELEASE oMgrScrFrm
RELEASE oMgrUser
RELEASE oApp
RELEASE oQryParMgr
RELEASE oRes
RELEASE oEnv
*------------------------------------------------------------------------------

*02.05.2004 16:03 ->������� ������ ���������� ����� ������� ���������
CLEAR ALL
*------------------------------------------------------------------------------

************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************