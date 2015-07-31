*------------------------------------------------------------------------------
* Project.........: Splash.PJX
* File............: Startup.PRG
* Called by.......: <NA>
* Parameters......: <none>
* Returns.........: <none>
* Notes...........: Главная программа
*------------------------------------------------------------------------------
LPARAMETERS luParamString
LOCAL luInstance, lcHwnd ,lcExecuteProgram ,lcExecuteProgramExtension 

*13.03.2007 12:53 -> Для определения запускаемого приложения используем константы
#DEFINE cnAPPLICATION_NAME	SPLASH
*------------------------------------------------------------------------------
PUBLIC llDebugModeFlg
*02.05.2012 15:00 ->Проверим режим запуска
lcExecuteProgram = Sys(16)
lcExecuteProgramExtension = Upper(Right(lcExecuteProgram,3))
If Inlist(lcExecuteProgramExtension,[EXE],[APP],[DLL])
    llDebugModeFlg = .F.
Else
    llDebugModeFlg = .T.
Endif
If !llDebugModeFlg
    Set Path To [Tmp;ImgBmp;ImgIco;Resource;Data;Drivers;OCX;DLL]
Else
    Set Path To [Tmp;ImgBmp;ImgIco;Resource;Graphic;Library;Menu;Program;Data;Drivers;OCX;D:\Develop\Work\DEMO\Kolcovo\]
 **   Close Databases All
Endif

*13.03.2007 12:53 -> Объявление и инициализация переменных
PUBLIC	gcProgramPath, ;
		glTerminate
LOCAL	lcExecuteProgram, ;
		lcApplicationNM, ;
		lcApplicationClassLib, ;
		lcApplicationIniFNM, ;
		llLibLoad, ;
		lcConfig, ;
		llTerminate
***
lcExecuteProgram = SYS(16)
gcProgramPath = UPPER(SUBSTR(lcExecuteProgram,1,RAT([\],lcExecuteProgram)))
glTerminate = .F.
***
lcApplicationNM = [cnAPPLICATION_NAME]
lcApplicationClassLib = lcApplicationNM + [.VCX]
lcApplicationIniFNM = gcProgramPath + [Basis.INI]
*------------------------------------------------------------------------------

*13.03.2007 12:50 -> Создадим объект для работы с INI файлами 
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

*13.03.2007 12:50 -> Создаем объект приложения
IF !(lcApplicationClassLib$SET([CLASSLIB]))
	SET CLASSLIB TO (lcApplicationClassLib) ALIAS (lcApplicationNM) ADDITIVE
	llLibLoad = .T.
ELSE
	llLibLoad = .F.	
ENDIF
oApp = CREATEOBJECT(lcApplicationNM)
IF llLibLoad
	RELEASE CLASSLIB ALIAS (lcApplicationNM)
ENDIF
*------------------------------------------------------------------------------

*13.03.2007 12:57 -> Запускаем приложение
oApp.Show()
*------------------------------------------------------------------------------

*18.04.2007 17:49 -> Убъем приложение
IF glTerminate
	CLEAR ALL
	RETURN
ENDIF
*------------------------------------------------------------------------------

SET SAFETY OFF

*13.03.2007 13:32 -> Восстанавливаем экран
TRY
lcConfig = FILETOSTR([Config.FPW])
lcConfig = STRTRAN(lcConfig,[SCREEN = OFF],[SCREEN = ON])
STRTOFILE(lcConfig,[Config.FPW])
CATCH
ENDTRY
*------------------------------------------------------------------------------

#DEFINE SW_NORMAL 1
DECLARE INTEGER ShellExecute IN Shell32 AS ShellExecute STRING @, STRING, STRING, STRING, STRING, INTEGER
    *09.09.2008 15:29 -> Выполним программу загрузки
    ***
    lcHwnd = REPLICATE(CHR(0),254)



*13.03.2007 13:13 -> Запускаем "БАЗИС"
TRY
IF TYPE([luParamString]) == [C]
	*RUN /N &luParamString
    luInstance = ShellExecute(@lcHwnd,.null.,luParamString,'','',1)
ELSE
	*RUN /N Basis.exe
    luInstance = ShellExecute(@lcHwnd,.null.,'Basis.exe','','',1)
ENDIF
CATCH
ENDTRY

*------------------------------------------------------------------------------
IF luInstance<=32
    =MESSAGEBOX([Не удалось запустить программу!]+ALLTRIM(runprogs.softexe),48,[Предупреждение...])
    RETURN .F.
ENDIF 

*13.03.2007 13:32 -> Убираем экран
TRY
lcConfig = FILETOSTR([Config.FPW])
lcConfig = STRTRAN(lcConfig,[SCREEN = ON],[SCREEN = OFF])
STRTOFILE(lcConfig,[Config.FPW])
CATCH
ENDTRY
*------------------------------------------------------------------------------

*13.03.2007 12:52 -> Очистим память занимаемую всеми другими объектами
CLEAR ALL
*------------------------------------------------------------------------------
RETURN 

