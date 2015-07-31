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
#DEFINE cnAPPLICATION_NAME	BASIS_TURN
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
		llLibLoad, ;
		lcLogFileDir, ;
		lnTurnCount, ;
		lnTurnCnt
		
*LOCAL ARRAY laAuth[1,2]
***
lcExecuteProgram = SYS(16)
lcExecuteProgramExtension = UPPER(RIGHT(lcExecuteProgram,3))
lcExecuteProgramPath = UPPER(SUBSTR(lcExecuteProgram,1,RAT([\],lcExecuteProgram)))
***
lcApplicationNM = [cnAPPLICATION_NAME]
lcApplicationClassLib = lcApplicationNM + [.VCX]
lcApplicationIniFNM = lcExecuteProgramPath + lcApplicationNM + [.INI]
*------------------------------------------------------------------------------

*08.07.2006 10:55 ->Проверим, запущена ли программа
IF FILE(lcExecuteProgramPath + lcApplicationNM + [.log])
	lnFileHandler = FOPEN(lcExecuteProgramPath + lcApplicationNM + [.log],12)
	IF lnFileHandler = -1
		MESSAGEBOX([АРМ.Видеверификация уже запущен!],48,[Предупреждение],10000)
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

*16.07.2006 13:23 ->Получим имя каталога для записи Log-файла
lcLogFileDir = ADDBS(oRes.GetParam([COMMON],[LOG_FILE_DIR]))
*------------------------------------------------------------------------------

*05.07.2006 15:28 ->Сохраним в лог событие 
STRTOFILE(CHR(13)+TTOC(DATETIME())+[ -> ]+[*** Запуск АРМ-а ***]+CHR(13),lcLogFileDir+[Scud.log],1)
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

	*06.09.2006 09:47 ->Получим количество турникетов
	lnTurnCount = VAL(oRes.GetParam([COMMON],[TURN_COUNT]))
	*------------------------------------------------------------------------------

	*06.09.2006 09:50 ->Установим размеры массива для хранения объектов, которые работают с прокси-считывателями
	DIMENSION laAuth[lnTurnCount,4]
	*------------------------------------------------------------------------------
	
	*06.09.2006 09:48 ->Создадим объекты для работы с прокси-считывателями
	FOR lnTurnCnt = 1 TO lnTurnCount

		*05.09.2006 11:00 ->вход
		laAuth[lnTurnCnt,1] = oApp.CreateObject([cntauthturn;auth_v1;auth.app],lnTurnCnt,1)
		*------------------------------------------------------------------------------
		
		*05.09.2006 11:00 ->выход
		laAuth[lnTurnCnt,2] = oApp.CreateObject([cntauthturn;auth_v1;auth.app],lnTurnCnt,2)
		*------------------------------------------------------------------------------

		*08.09.2006 09:02 ->разблокировка
*		laAuth[lnTurnCnt,3] = oApp.CreateObject([cntauthturn;auth_v1;auth.app],lnTurnCnt,3)
		*------------------------------------------------------------------------------

		*08.09.2006 09:02 ->блокировка
*		laAuth[lnTurnCnt,4] = oApp.CreateObject([cntauthturn;auth_v1;auth.app],lnTurnCnt,4)
		*------------------------------------------------------------------------------
		
	ENDFOR
	*------------------------------------------------------------------------------

	oTurnDrv = oApp.CreateObject([cntturndriver;auth_v1;auth.app])
	
ENDIF	
*------------------------------------------------------------------------------

*_SCREEN.Visible = .T.

*!* ON KEY LABEL F2 laAuth[1,1].Authorization()
*!*	ON KEY LABEL F3 oAuth0R.Authorization()
*!*	ON KEY LABEL F4 oAuth0C.Authorization()

*02.05.2004 16:02 ->Запускаем приложение
IF TYPE([oApp]) == [O]
	oApp.StartUp()
ENDIF
*------------------------------------------------------------------------------

*!*	ON KEY LABEL F2
*!*	ON KEY LABEL F3
*!*	ON KEY LABEL F4

*08.07.2006 11:02 ->Уберем признак того, что программа запущена
FCLOSE(lnFileHandler)
*------------------------------------------------------------------------------

*******************************************************************************
*После того, как приложение отработало удаляем объекты в нужной нам последовательности
*******************************************************************************
RELEASE oApp
RELEASE oRes
RELEASE oEnv
RELEASE oTurnDrv
RELEASE laAuth
*------------------------------------------------------------------------------

*05.07.2006 15:30 ->Сохраним в лог событие 
STRTOFILE(TTOC(DATETIME())+[ -> ]+[*** Завершение работы АРМ-а ***]+CHR(13)+CHR(13),lcLogFileDir+[Scud.log],1)
*------------------------------------------------------------------------------

*02.05.2004 16:03 ->Очистим память занимаемую всеми другими объектами
CLEAR ALL
*------------------------------------------------------------------------------

************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************