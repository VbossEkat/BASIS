*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: BASIS.PRG
* Module/Procedure: BASIS()
* Called by.......: <NA>
* Parameters......: <none>
* Returns.........: <none>
* Notes...........: Главная программа
*-------------------------------------------------------
LPARAMETERS luParamString

*01.05.2004 20:00 ->Для определения запускаемого приложения используем константы
#DEFINE cnAPPLICATION_NAME	BASIS_ADMIN
*------------------------------------------------------------------------------

_SCREEN.WindowState = 2

*01.05.2004 19:51 ->Объявление и инициализация переменных
LOCAL	lcExecuteProgram, ;
		lcExecuteProgramExtension, ;
		lcExecuteProgramPath, ;
		lcApplicationNM, ;
		lcApplicationClassLib, ;
		lcApplicationIniFNM, ;
		lnFileHandler, ;
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

*09.07.2006 10:33 ->Проверим, запущена ли программа
IF FILE(lcExecuteProgramPath + lcApplicationNM + [.log])
	lnFileHandler = FOPEN(lcExecuteProgramPath + lcApplicationNM + [.log],12)
	IF lnFileHandler = -1
		MESSAGEBOX([АРМ.Администратор VIP-терминала уже запущен!],48,[Предупреждение],10000)
		RETURN
	ENDIF
ELSE
	lnFileHandler = FCREATE(lcExecuteProgramPath + lcApplicationNM + [.log])
	FCLOSE(lnFileHandler)
	lnFileHandler = FOPEN(lcExecuteProgramPath + lcApplicationNM + [.log],12)
ENDIF
*------------------------------------------------------------------------------

*02.05.2004 15:00 ->Проверим режим запуска
IF INLIST(lcExecuteProgramExtension,[EXE],[APP],[DLL])
	llDebugModeFlg = .F.
ELSE
	llDebugModeFlg = .T.	
ENDIF
*------------------------------------------------------------------------------

*02.05.2004 15:47 ->Перейдем в каталог приложения и установим необходимые пути
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

*02.05.2004 15:47 ->Создадим объект для работы с окружением
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

*02.05.2004 15:48 ->Создадим объект для работы с INI файлами 
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

*02.05.2004 15:48 ->Создадим объект для работы с параметрами выборок
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

*02.05.2004 15:52 ->Создаем объект приложения
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

*19.01.2005 15:39 -> Создаем объекты менеджеры
IF TYPE([oApp]) == [O]
	oMgrClient   = oApp.CreateObject([interface;client_v1;client.app])
	oMgrPD 	     = oApp.CreateObject([interface;primarydoc_v1;primarydoc.app])
	oMgrRpt      = oApp.CreateObject([interface;report_v1;report.app])
	oMgrFormType = oApp.CreateObject([interface;formtype_v1;formtype.app])
	oMgrOrgUnit  = oApp.CreateObject([interface;orgunit_v1;orgunit.app])
	oMgrQryPar   = oApp.CreateObject([interface;queryparam_v1;queryparam.app])
	oMgrScrFrm   = oApp.CreateObject([interface;screenform_v1;screenform.app])
	oMgrDevice	 = oApp.CreateObject([interface;device_v1;device.app])
	oMgrUser	 = oApp.CreateObject([interface;user_v1;user.app])
	oMgrCard	 = oApp.CreateObject([interface;card_v1;card.app])
	oAuth		 = oApp.CreateObject([cntAuthAdmin;auth_v1;auth.app])
ENDIF	
*------------------------------------------------------------------------------

*_SCREEN.Visible = .T.

*02.05.2004 16:02 ->Запускаем приложение
IF TYPE([oApp]) == [O]
	oApp.StartUp()
ENDIF
*------------------------------------------------------------------------------

*08.07.2006 11:02 ->Уберем признак того, что программа запущена
FCLOSE(lnFileHandler)
*------------------------------------------------------------------------------

*******************************************************************************
*После того, как приложение отработало удаляем объекты в нужной нам последовательности
*******************************************************************************
RELEASE oMgrClient
RELEASE oMgrPD
RELEASE oMgrRpt
RELEASE oMgrFormType
RELEASE oMgrOrgUnit
RELEASE oMgrQryPar
RELEASE oMgrScrFrm
RELEASE oMgrDevice
RELEASE oMgrUser
RELEASE oApp
RELEASE oRes
RELEASE oEnv
*------------------------------------------------------------------------------

*02.05.2004 16:03 ->Очистим память занимаемую всеми другими объектами
CLEAR ALL
*------------------------------------------------------------------------------

************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************