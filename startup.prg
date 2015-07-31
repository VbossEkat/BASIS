*:******************************************************************************
*:
*: Procedure File D:\DEVELOP\WORK\BASIS\STARTUP.PRG
*:
*:	ГлуховВ. 
*:	Система. Бизнес. Автоматизация.
*:	
*:	Екатеринбург
*:	
*:	620100
*:	Россия
*:	
*:	
*:	
*:	
*:	
*:	
*:
*: Documented using Visual FoxPro Formatting wizard version  .05
*:******************************************************************************
*:   STARTUP
*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: BASIS.PRG
* Module/Procedure: BASIS()
* Called by.......: <NA>
* Parameters......: <none>
* Returns.........: <none>
* Notes...........: Главная программа
*-------------------------------------------------------
Lparameters luParamString
*01.05.2004 20:00 ->Для определения запускаемого приложения используем константы
#Define cnAPPLICATION_NAME	BASIS
*------------------------------------------------------------------------------
*SYS(2800 ,3 )

*01.05.2004 19:51 ->Объявление и инициализация переменных
Local	lcExecuteProgram, ;
	lcExecuteProgramExtension, ;
	lcExecuteProgramPath, ;
	lcApplicationNM, ;
	lcApplicationClassLib, ;
	lcApplicationIniFNM, ;
	llLibLoad,;
	nScrWidth
***
lcExecuteProgram = Sys(16)
lcExecuteProgramExtension = Upper(Right(lcExecuteProgram,3))
lcExecuteProgramPath = Upper(Substr(lcExecuteProgram,1,Rat([\],lcExecuteProgram)))
***
lcApplicationNM = [cnAPPLICATION_NAME]
lcApplicationClassLib = lcApplicationNM + [.VCX]
lcApplicationIniFNM = lcExecuteProgramPath + lcApplicationNM + [.INI]
*------------------------------------------------------------------------------

*14.08.2006 11:18 ->Распахнем окно на весь экран
_Screen.WindowState = 2

*_Screen.BackColor = RGB(212,208,200)
**_Screen.Icon = 'BASIS1_A.ICO'
_Screen.Icon = 'basis7.ico'
IF FILE('logoFrm.JPG')
	_screen.Picture = 'logoFrm.JPG'
else
	nScrWidth = _screen.Width 
	DO CASE 
		CASE nScrWidth <1024
			 _screen.Picture = 'logoSBAbs800.JPG'
		CASE nScrWidth > 1023 AND nScrWidth <1440
			 _screen.Picture = 'logoSBAbs1024.JPG'
		CASE nScrWidth > 1439
			 _screen.Picture = 'logoSBAbs.JPG'
	ENDCASE 
ENDIF 
*_Screen.HalfHeightCaption= .T. 
*------------------------------------------------------------------------------
PUBLIC llDebugModeFlg
*02.05.2004 15:00 ->Проверим режим запуска
If Inlist(lcExecuteProgramExtension,[EXE],[APP],[DLL])
	llDebugModeFlg = .F.
Else
	llDebugModeFlg = .T.
Endif
*------------------------------------------------------------------------------

*02.05.2004 15:47 ->Перейдем в каталог приложения и установим необходимые пути
If lcExecuteProgramPath # Fullpath(Curdir())
	Cd (lcExecuteProgramPath)
Endif
***
If !llDebugModeFlg
	Set Path To [Tmp;ImgBmp;ImgIco;Resource;Data;Drivers;OCX;DLL]
Else
	Set Path To [Tmp;ImgBmp;ImgIco;Resource;Graphic;Library;Menu;Program;Data;Drivers;OCX]
	Close Databases All
Endif
*------------------------------------------------------------------------------
*02.05.2004 15:47 ->Создадим объект для работы с окружением
If !([GENERAL_V1.VCX]$Set([CLASSLIB]))
	Set Classlib To GENERAL_V1.vcx Alias GENERAL_V1 Additive
	llLibLoad = .T.
Else
	llLibLoad = .F.
Endif
oEnv = Createobject([environment],llDebugModeFlg)
If llLibLoad
	Release Classlib Alias GENERAL_V1
Endif
*------------------------------------------------------------------------------

*02.05.2004 15:48 ->Создадим объект для работы с INI файлами
If !([GENERAL_V1.VCX]$Set([CLASSLIB]))
	Set Classlib To GENERAL_V1.vcx Alias GENERAL_V1 Additive
	llLibLoad = .T.
Else
	llLibLoad = .F.
Endif
oRes = Createobject([resource],lcApplicationIniFNM)
If llLibLoad
	Release Classlib Alias GENERAL_V1
Endif
*------------------------------------------------------------------------------

*02.05.2004 15:48 ->Создадим объект для работы с параметрами выборок
If !([QUERYPARAMIO_V1.VCX]$Set([CLASSLIB]))
	Set Classlib To QUERYPARAMIO_V1.vcx Alias QUERYPARAMIO_V1 Additive
	llLibLoad = .T.
Else
	llLibLoad = .F.
Endif
oQryParMgr = Createobject([QueryParamMgr])
If llLibLoad
	Release Classlib Alias QUERYPARAMIO_V1
Endif
*------------------------------------------------------------------------------

*14.09.2005 10:08 -> Создадим объект для работы со штрих-кодами
If !([TOVARLOOKUP_V1.VCX]$Set([CLASSLIB]))
	Set Classlib To TOVARLOOKUP_V1.vcx Alias TOVARLOOKUP_V1 Additive
	llLibLoad = .T.
Else
	llLibLoad = .F.
Endif
oTLU = Createobject([TovarLookUp])
If llLibLoad
	Release Classlib Alias TOVARLOOKUP_V1
Endif
*------------------------------------------------------------------------------

*02.05.2004 15:52 ->Создаем объект приложения
If !(lcApplicationClassLib$Set([CLASSLIB]))
	Set Classlib To (lcApplicationClassLib) Alias (lcApplicationNM) Additive
	llLibLoad = .T.
Else
	llLibLoad = .F.
Endif
oApp = Createobject(lcApplicationNM,llDebugModeFlg)
If llLibLoad
	Release Classlib Alias (lcApplicationNM)
Endif
*------------------------------------------------------------------------------

*19.01.2005 15:39 -> Создаем объекты менеджеры
If Type([oApp]) == [O]
	oMgrClient   = oApp.Createobject([interface;client_v1;client.app])
	oMgrTovar    = oApp.Createobject([interface;tovar_v1;tovar.app])
	oMgrPD 	     = oApp.Createobject([interface;primarydoc_v1;primarydoc.app])
	oMgrRpt      = oApp.Createobject([interface;report_v1;report.app])
	oMgrFormType = oApp.Createobject([interface;formtype_v1;formtype.app])
	oMgrOrgUnit  = oApp.Createobject([interface;orgunit_v1;orgunit.app])
	oMgrQryPar   = oApp.Createobject([interface;queryparam_v1;queryparam.app])
	oMgrScrFrm   = oApp.Createobject([interface;screenform_v1;screenform.app])
	oMgrDevice	 = oApp.Createobject([interface;device_v1;device.app])
	oMgrCash	 = oApp.Createobject([interface;cash_v1;cash.app])
	oMgrDisc	 = oApp.Createobject([interface;discount_v1;discount.app])
	oMgrUser	 = oApp.Createobject([interface;user_v1;user.app])
	oMgrPOSSET	 = oApp.Createobject([interface;poscfg_v1;poscfg.app])
	oMgrCoupon	 = oApp.Createobject([interface;coupon_v1;coupon.app])
	oMgrPBook	 = oApp.Createobject([interface;pbook_v1;pbook.app])
	oMgrAdmin	 = oApp.Createobject([interface;admin;admin.app])
	oMgrCard	 = oApp.Createobject([interface;card_v1;card.app])
	oSession	 = Newobject([WorkSession],[Messenger.prg])
*02.05.2004 16:02 ->Запускаем приложение
	oApp.STARTUP()
Endif
*------------------------------------------------------------------------------

*------------------------------------------------------------------------------

*******************************************************************************
*После того, как приложение отработало удаляем объекты в нужной нам последовательности
*******************************************************************************
Release oSession
Release oMgrAdmin
Release oMgrPBook
Release oMgrClient
Release oMgrTovar
Release oMgrPD
Release oMgrRpt
Release oMgrFormType
Release oMgrOrgUnit
Release oMgrQryPar
Release oMgrScrFrm
Release oMgrDevice
Release oMgrCash
Release oMgrDisc
Release oMgrUser
Release oMgrPOS
Release oMgrPOSSET
Release oMgrCoupon
Release oApp
Release oTLU
Release oQryParMgr
Release oRes
Release oEnv
*------------------------------------------------------------------------------
SET HELP ON 
Sys(2800 ,0 )
CLOSE DATABASES all
_screen.Picture = ''
*02.05.2004 16:03 ->Очистим память занимаемую всеми другими объектами
Clear All
*------------------------------------------------------------------------------

************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************
