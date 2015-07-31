*-------------------------------------------------------
* Project.........: POS.PJX
* File............: SartUp_POS.PRG
* Module/Procedure: SartUp_POS()
* Called by.......: <NA>
* Parameters......: <none>
* Returns.........: <none>
* Notes...........: Главная программа
*-------------------------------------------------------
LPARAMETERS luParamString
*= NUMLOCK(.T.)
*01.05.2004 20:00 ->Для определения запускаемого приложения используем константы
#DEFINE cnAPPLICATION_NAME	POS
*------------------------------------------------------------------------------
*01.05.2004 19:51 ->Объявление и инициализация переменных
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
	SET PATH TO [Tmp;ImgBmp;ImgIco;Resource;OCX;Data]
ELSE
	SET PATH TO [Tmp;ImgBmp;ImgIco;Resource;Graphic;Library;Menu;Program;FoxUnit;FoxUnitTest;OCX]
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

*25.09.2006 14:44 ->Создадим объект для работы со штрих-кодами
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

*19.01.2005 15:39 -> Создаем объекты менеджеры
IF TYPE([oApp]) == [O]
	oMgrPOS		 = oApp.CreateObject([interface;pos_v1.vcx])
	oSession	 = NEWOBJECT([WorkSession],[Messenger.prg])
ENDIF	
*------------------------------------------------------------------------------
SET HELP OFF
*02.05.2004 16:02 ->Запускаем приложение
IF TYPE([oApp]) == [O]
	oApp.StartUp()
ENDIF
*------------------------------------------------------------------------------

*******************************************************************************
*После того, как приложение отработало удаляем объекты в нужной нам последовательности
*******************************************************************************
RELEASE oApp
RELEASE oMgrPOS
RELEASE oRes
RELEASE oSession
RELEASE oEnv
*------------------------------------------------------------------------------
SET HELP ON
*02.05.2004 16:03 ->Очистим память занимаемую всеми другими объектами
CLEAR ALL
*------------------------------------------------------------------------------
*= NUMLOCK(.F.)
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************